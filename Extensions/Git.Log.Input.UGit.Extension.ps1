<#
.SYNOPSIS
    git log input
.DESCRIPTION
    Extends the parameters for git log, making it easier to use from PowerShell.

    Allows timeframe parameters to be tab-completed:
    * After/Since become --after
    * Before/Until become --before
    * Author/Committer become --author

    Adds -CurrentBranch, which gives the changes between the upstream branch and the current branch.

    Also adds -IssueNumber, which searchers for commits that reference particular issues.
.EXAMPLE
    git log -CurrentBranch
#>
[ValidatePattern('^git log')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# Gets logs after a given date
[DateTime]
[Alias('Since')]
$After,

# Gets before a given date
[DateTime]
[Alias('Until')]
$Before,

# Gets lof from a given author or committer
[Alias('Committer')]
[string]
$Author,

# If set, will get all changes between the upstream branch and the current branch.
[Alias('UpstreamDelta','ThisBranch')]
[switch]
$CurrentBranch,

# One or more issue numbers.  Providing an issue number of 0 will find all log entries that reference an issue.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Number','ReferenceNumbers','ReferenceNumber','IssueNumbers','WorkItemID','WorkItemIDs')]
[int[]]
$IssueNumber,

# If set, will get statistics associated with each change
[Alias('Stat')]
[switch]
$Statistics
)

foreach ($dashToDoubleDash in 'after', 'before', 'author') {
    if ($PSBoundParameters[$dashToDoubleDash]) {
        "--$dashToDoubleDash"
        "$($PSBoundParameters[$dashToDoubleDash])"
    }
}

foreach ($dashToDoubleDashSwitch in 'Statistics') {
    if ($PSBoundParameters[$dashToDoubleDash]) {
        "--$dashToDoubleDashSwitch"
    }
}

if ($CurrentBranch) {        
    $headbranch        = git remote | git remote show | Select-Object -ExpandProperty HeadBranch
    $currentBranchName = git branch | Where-Object IsCurrentBranch
    if ($currentBranchName -ne $headbranch) {
        "$headbranch..$currentBranchName"
    } else {
        Write-Warning "On $headBranch"
    }
}

if ($IssueNumber) {
    "--perl-regexp"    
    foreach ($IssueNum in $IssueNumber) {
        '--grep'
        if ($IssueNum -eq 0) {
            '\#\d+\D'
        } else {
            "\#$IssueNum\D"
        }
    }    
}