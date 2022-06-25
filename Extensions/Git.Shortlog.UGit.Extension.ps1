<#
.SYNOPSIS
    git shortlog extension
.DESCRIPTION
    Outputs git shortlog as objects
.EXAMPLE
    git shortlog  # Get a shortlog
.EXAMPLE
    git shortlog --email # Get a shortlog with email information
.EXAMPLE
    git shortlog --summary # Get a shortlog summary
.EXAMPLE
    git shortlog --sumary --email # Get a shortlog summary, with email.
#>
[Management.Automation.Cmdlet("Out","Git")]           # It's an extension for Out-Git
[ValidatePattern("^git shortlog",Options='IgnoreCase')] # when the pattern is "git branch"
param()

begin {
    $shortlogLines = @()

    $SummaryLineRegex = [Regex]::new(@'
^\s{1,}(?<Count>\d+)\s{1,}(?<Name>[^\<]+)(?:\<(?<Email>[^\>]+)\>){0,1}$
'@,'IgnoreCase,IgnorePatternWhitespace')

    $CommitterLineRegex = [Regex]::new(@'
^(?<Name>\S[^\<\()]+)(?:\<(?<Email>[^\>]+)\>){0,1}\s{0,}\((?<Count>\d+)\)\:$
'@,'IgnoreCase,IgnorePatternWhitespace')

    $CommitMessageLineRegex = [Regex]::new('^\s{4,}(?<CommitMessage>.+)$')
}

process {
    $shortlogLines += $gitOut
}

end {
    $currentCommitter = $null
    $hadSummaries     = $false
    foreach ($shortLogLine in $shortlogLines) {
        if ($shortLogLine -match $SummaryLineRegex) {
            $hadSummaries = $true
            $shortLogExtract = [Ordered]@{} + $matches
            $shortLogExtract.Remove(0)
            $shortLogExtract.GitRoot = $GitRoot
            $shortLogExtract.PSTypeName = 'Git.Shortlog.Summary'
            [PSCustomObject]$shortLogExtract
        } elseif ($shortlogLine -match $CommitterLineRegex) {
            if ($currentCommitter) {
                [PSCustomObject]$currentCommitter
            }
            $shortLogExtract = [Ordered]@{} + $matches
            $shortLogExtract.Remove(0)
            $shortLogExtract.Commits = @()
            $shortLogExtract.GitRoot = $GitRoot
            $shortLogExtract.PSTypeName = 'Git.Shortlog'
            $currentCommitter = $shortLogExtract            
        } elseif ($currentCommitter -and 
            $shortlogLine -match $CommitMessageLineRegex) {
            $currentCommitter.Commits += $matches.CommitMessage
        }
    }

    if ($currentCommitter) {
        [PSCustomObject]$currentCommitter
    } elseif (-not $hadSummaries) {
        $shortlogLines
    }
}
