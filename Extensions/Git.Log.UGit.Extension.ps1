<#
.Synopsis
    Log Extension
.Description
    Outputs git log entries as objects
.Example
    git log | Group-Object GitUserEmail -NoElement | Sort-Object Count -Descending
.EXAMPLE
    git log | Where-Object -Not Merged
.EXAMPLE
    git log | Group-Object { $_.CommitDate.DayOfWeek } -NoElement
#>
# It's an extension for Out-Git
[Management.Automation.Cmdlet("Out","Git")]
# when the pattern is "git log"
[ValidatePattern("^git log",Options='IgnoreCase')]
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

    $lines = @()

    function OutGitLog {
        param([string[]]$OutputLines)
        if (-not $OutputLines) { return }
        $gitLogMatch = $Git_Log.Match($OutputLines -join [Environment]::NewLine)
        if (-not $gitLogMatch.Success) { return }
        
        $gitLogOut = [Ordered]@{PSTypeName='git.log'}
        if ($gitCommand -like '*--merges*') {
            $gitLogOut.PSTypeName = 'git.merge.log'
        }
        foreach ($group in $gitLogMatch.Groups) {
            if ($group.Name -as [int] -ne $null) { continue }
            if (-not $gitLogOut.Contains($group.Name)) {
                $gitLogOut[$group.Name]  = $group.Value
            } else {
                $gitLogOut[$group.Name]  = @( $gitLogOut[$group.Name] ) + $group.Value
            }            
        }
        $gitLogOut.Remove("HexDigits")
        if ($gitLogOut.CommitDate) {
            $gitLogOut.CommitDate = [datetime]::ParseExact($gitLogOut.CommitDate.Trim(), "ddd MMM d HH:mm:ss yyyy K", [cultureinfo]::InvariantCulture)
        }
        if ($gitLogOut.CommitMessage) {
            $gitLogOut.CommitMessage = $gitLogOut.CommitMessage.Trim()
        }
        if ($gitLogOut.MergeHash) {
            $script:LogChangesMerged = $true
        }
        $gitLogOut.Merged = $script:LogChangesMerged
        $gitLogOut.GitRoot = $GitRoot
        [PSCustomObject]$gitLogOut
    }
}


process {
    
    if ("$gitOut" -like 'Commit*' -and $lines) {
        OutGitLog $lines
        
        $lines = @()
    }
    $lines += "$gitOut"
}

end {
    OutGitLog $lines
    $ExecutionContext.SessionState.PSVariable.Remove('script:LogChangesMerged')
}

