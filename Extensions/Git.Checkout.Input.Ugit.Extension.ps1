<#
.SYNOPSIS
    git checkout input extension
.DESCRIPTION
    Extends the parameters for git checkout, making it easier to use from PowerShell.

    If the -PullRequest parameter is provided, the branch will be fetched from the remote.

    If the -BranchName parameter is provided, the branch will be checked out.
#>
[ValidatePattern('^git checkout')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# The branch name.
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$BranchName,

# The number of the pull request.
# If no Branch Name is provided, the branch will be `PR-$PullRequest`.
[Parameter(ValueFromPipelineByPropertyName)]
[int]
$PullRequest,

# The name of a new branch
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('New','NewBranch')]
[string]
$NewBranchName,

# The name of a branch to reset.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('ResetBranch')]
[string]
$ResetBranchName,

# One or more specific paths to reset.
# This will overwrite the contents of the files with the contents of the index.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Reset')]
[string[]]
$ResetPath,

# If set, will checkout a branch in a detached state.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$Detach
)

if ($Detach) {
    "--detach"
}

if ($PullRequest) {
    $remoteName = git remote | Select-Object -ExpandProperty RemoteName | Select-Object -First 1
    if (-not $BranchName) {
        $BranchName = "PR-$PullRequest"        
    }
    $fetchedBranch = git fetch $remoteName "pull/$PullRequest/head:$BranchName"
    if (-not $fetchedBranch) { 
        return $BranchName
    }
    $BranchName
} 
elseif ($NewBranchName) {
    "-b"
    $NewBranchName
}
elseif ($ResetBranchName) {
    if ($PSCmdlet -and $PSCmdlet.ShouldProcess("Reset branch $ResetBranchName")) {
        "-B" # Beware of capital B in git
        $ResetBranchName    
    }    
}
elseif ($BranchName) {    
    $BranchName
}

if ($ResetPath) {
    "HEAD"
    foreach ($pathToReset in $ResetPath) {
        $pathToReset
    }
}