<#
.SYNOPSIS
    git grep extension
.DESCRIPTION
    Outputs matches from git grep.
    
    When possible, the regular expression will be converted into PowerSEhll so that the .Match populates accurately.    
.EXAMPLE
    git grep '-i' example # look for all examples in the repository
.LINK
    Out-Git
#>
[Management.Automation.Cmdlet("Out","Git")]         # It  extends Out-Git
[ValidatePattern("^git grep",Options='IgnoreCase')] # when the pattern is "git grep"
[OutputType('Git.Grep.Match')]
param()

begin {
    $grepLines = @()
    $multilineContext = $false
    $afterLines  = 0
    $beforeLines = 0
    $AfterContext  = $GitCommand -cmatch '\s-(?>A|-after-context)\s(?<ac>\d+)'
    if ($AfterContext) {
        $afterLines = $matches.ac -as [int]
    }
    $BeforeContext = $GitCommand -cmatch '\s-(?>B|-before-context)\s(?<bc>\d+)'
    if ($BeforeContext) {
        $beforeLines = $matches.bc -as [int]
    }

    if ($afterLines -or $beforeLines) {
        $multilineContext = $true
    }
    $CurrentMatch = $null
    $GrepLineMatchIndex = -1   
    $grepTerm = for ($gitArgIndex =1 ; $gitArgIndex -lt $gitArgument.Length; $gitArgIndex++) {
        $gitArg = $GitArgument[$gitArgIndex]
        if ($gitArg -notmatch '^-' -and 
            $gitArgument[$gitArgIndex - 1] -notmatch '^-(?>-after-context|-before-context|O|B|A)'
        ) {
            $gitArg
            break
        }
    }
 
    $caseSensitive = $true
    if ($gitArgument -eq '-i' -or $gitArgument -eq '--ignore-case') {
        $caseSensitive = $false
    }
}

process {
    $gitOutputLine = $_
    $grepLines += $_
    if ($gitOutputLine -match '^([^\:]+)\:') {
        if ($CurrentMatch) {
            $CurrentMatch.GitOutputLines = $grepLines[0..($grepLines.Length -2)]
            [PSCustomObject]$CurrentMatch
        }
        $GrepLineMatchIndex = $grepLines.Length - 1
        $CurrentMatch = [Ordered]@{
            PSTypeName = 'Git.Grep.Match'
            GitPath    = $matches.1
            GitRoot    = $gitRoot
            Pattern    = $grepTerm
        }
        $gitOutputLine = $gitOutputLine -replace '^([^\:]+)\:'
        if ($GitCommand -cmatch '--line-number') {            
            $null = $gitOutputLine -match '^(?<line>\d+)\:'
            $CurrentMatch.LineNumber = $matches.line -as [int]
            $gitOutputLine = $gitOutputLine -replace '^(?<line>\d+)\:'
        }
        
        if ($GitCommand -cmatch '--column') {
            $null = $gitOutputLine -match '^(?<column>\d+)\:'
            $CurrentMatch.ColumnNumber = $matches.column -as [int]
            $gitOutputLine = $gitOutputLine -replace '^(?<column>\d+)\:'
        }

        
        $CurrentMatch.Line = $gitOutputLine
        
        # Go back from the previous line to get lines before
        if ($beforeLines) {            
            $CurrentMatch.Before = $grepLines[
                ($GrepLineMatchIndex - 1)..
                ($GrepLineMatchIndex - $beforeLines)
            ] -replace "^$($CurrentMatch.GitPath)-(\d+)?-(\d+)?"
        }
    }

    if ($gitOutputLine -match '^--$') {
        if ($afterLines) {
            $CurrentMatch.After = $grepLines[
                ($GrepLineMatchIndex + 1)..
                ($GrepLineMatchIndex + $afterLines)
            ] -replace "^$($CurrentMatch.GitPath)-(\d+)?-(\d+)?"
        }        
        $CurrentMatch.GitOutputLines = $grepLines
        [PSCustomObject]$CurrentMatch
        $grepLines = @()
        $GrepLineMatchIndex = -1
        # Separator, reset $grepLines and finish $currentMatch
    }
    
}

end {
    if ($CurrentMatch) {
        $CurrentMatch.GitOutputLines = $grepLines
        [PSCustomObject]$CurrentMatch
    }
}
