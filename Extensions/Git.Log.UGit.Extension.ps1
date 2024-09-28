<#
.Synopsis
    Log Extension
.Description
    Outputs git log as objects.
.Example
    # Get all logs
    git log |
        # until the first merged pull request
        Where-Object -Not Merged
.Example
    # Get a single log entry
    git log -n 1 |
        # and see what the log object can do.
        Get-Member
.Example
    # Get all logs
    git log |
        # Group them by the author
        Group-Object GitUserEmail -NoElement |
        # sort them by count
        Sort-Object Count -Descending
.Example
    # Get all logs
    git log |
        # Group them by day of week
        Group-Object { $_.CommitDate.DayOfWeek } -NoElement
.Example
    # Get all logs
    git log |
        # where there is a pull request number
        Where-Object PullRequestNumber |
        # pick out the PullRequestNumber and CommitDate
        Select PullRequestNumber, CommitDate
.Example
    git log --merges
#>
[Management.Automation.Cmdlet("Out","Git")]        # It's an extension for Out-Git
[ValidatePattern("^git log",Options='IgnoreCase')] # when the pattern is "git log"
param(
)

begin {    
    $script:LogChangesMerged = $false
    $Git_Log = [Regex]::new(@'
(?m)^commit                                                             # Commits start with 'commit'
\s+(?<CommitHash>(?<HexDigits>
[0-9abcdef]+
)
)                                                                       # The CommitHash is all hex digits after whitespace
\s+                                                                     # More whitespace (includes the newline)
(?:(?:Merge:                                                            # Next is the optional merge
\s+(?:(?<MergeHash>(?<HexDigits>
[0-9abcdef]+
)
)[\s-[\n\r]]{0,}                                                        # Which is hex digits, followed by optional whitespace
){2,} [\n\r]+                                                           # followed by a newline
))?Author:                                                              # New is the author line
\s+(?<GitUserName>(?:.|\s){0,}?(?=\z|\s\<))                             # The username comes before whitespace and a <
\s+\<                                                                   # The email is enclosed in <>
(?<GitUserEmail>(?:.|\s){0,}?(?=\z|>))\>(?:.|\s){0,}?(?=\z|^date:)Date: # Next comes the Date line
\s+(?<CommitDate>(?:.|\s){0,}?(?=\z|\n))                                # Since dates can come in many formats, capture the line
\n(?<CommitMessage>(?:.|\s){0,}?(?=\z|(?>\r\n|\n){2,2}))                # Anything until two newlines is the commit message

'@, 'IgnoreCase,IgnorePatternWhitespace', '00:00:05')

    $lines = [Collections.Generic.List[string]]::new()
    $StartsWithCommit = [Regex]::new('^commit', 'IgnoreCase')
    $gitLogTypeName = 
        if ($gitCommand -match '--merges') {
            'git.merge.log'
        } else {
            'git.log'
        }

    function OutGitLog {
        param([string[]]$OutputLines)
        if (-not $OutputLines) { return }
        $gitLogMatch = $Git_Log.Match($OutputLines -join [Environment]::NewLine)
        if (-not $gitLogMatch.Success) { return }

        $gitLogOut = [Ordered]@{PSTypeName=$gitLogTypeName;GitCommand=$gitCommand}        
        foreach ($group in $gitLogMatch.Groups) {
            if ($group.Name -as [int] -ne $null) { continue }
            if (-not $gitLogOut.Contains($group.Name)) {
                $gitLogOut[$group.Name] = $group.Value
            } else {
                $gitLogOut[$group.Name] = @( $gitLogOut[$group.Name] ) + $group.Value
            }
        }
        $gitLogOut.Remove("HexDigits")
        if ($gitLogOut.CommitDate) {
            $gitLogOut.CommitDateString = $gitLogOut.CommitDate
            $gitLogOut.Remove("CommitDate")            
        }
        if ($gitLogOut.CommitMessage) {
            $gitLogOut.CommitMessage = $gitLogOut.CommitMessage.Trim()
        }
        if ($gitLogOut.MergeHash -and
            $gitLogOut.CommitMessage -notmatch '^merge branch') {
            $script:LogChangesMerged = $true
            if ($gitLogOut.CommitMessage -match '^Merge pull request \#(?<Num>\d+)') {
                $gitLogOut.PullRequestNumber = [int]$matches.Num
            }
            if ($gitLogOut.CommitMessage -match 'from[\r\n\s]{0,}(?<Src>\S+)') {
                $gitLogOut.Source = $matches.Src
            }
        }
        elseif (
            $gitLogOut.MergeHash
        ) {
            if ($gitLogOut.CommitMessage -match "^merge branch '(?<Branch>[^']+)'") {
                $gitLogOut.Source = $matches.Branch
            }
            if ($gitLogOut.CommitMessage -match 'into (?<Branch>.+)$') {
                $gitLogOut.Destination = $matches.Branch
            }
        }        

        if ($GitArgument -contains '--shortstat' -or $GitArgument -contains '--stat') {
            foreach ($linePart in $OutputLines[-2] -split ',' -replace '[\s\w\(\)-[\d]]') {
                if ($linePart.Contains('+')) {
                    # If the part contains +, it's insertions.
                    $gitLogOut.Insertions = $linePart -replace '\+' -as [int]
                }
                elseif ($linePart.Contains('-'))
                {
                    # If the part contains -, it's deletions.
                    $gitLogOut.Deletions = $linePart -replace '\-' -as [int]
                }
                else
                {
                    # Otherwise, its the file change count.
                    $gitLogOut.FilesChanged = $linePart -as [int]
                }
            }
            if (-not $gitLogOut.Deletions) {
                $gitLogOut.Deletions = 0
            }
            if (-not $gitLogOut.Insertions) {
                $gitLogOut.Insertions = 0
            }
        }        

        $gitLogOut.GitOutputLines = $OutputLines
        $gitLogOut.Merged = $script:LogChangesMerged
        $gitLogOut.GitRoot = $GitRoot
        [PSCustomObject]$gitLogOut
    }

    $shouldSkip = $gitCommand -match '--(?>pretty|format)'
    if ($shouldSkip) {
        continue
    }
}

end {
    if ($shouldSkip) {
        return
    }
    $allInput = @($input)
    $commitStartLine = 0
    for ($lineIndex = 0; $lineIndex -lt $allInput.Count; $lineIndex++) {
        if ($allInput[$lineIndex] -match $StartsWithCommit) {
            OutGitLog $allInput[$commitStartLine..($lineIndex - 1)]
            $commitStartLine = $lineIndex
        }
    }
    
    OutGitLog $allInput[$commitStartIndex..($allInput.Count - 1)]
    $ExecutionContext.SessionState.PSVariable.Remove('script:LogChangesMerged')
}

