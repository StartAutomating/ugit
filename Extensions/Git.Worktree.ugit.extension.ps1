<#
.SYNOPSIS
    git worktree extension
.DESCRIPTION
    Extends git worktree to return objects.

    Currently, only `git worktree list` is supported.
.LINK
    https://git-scm.com/docs/git-worktree
.EXAMPLE
    git worktree list
#>

[Management.Automation.Cmdlet("Out","Git")]        # It's an extension for Out-Git
[ValidatePattern("^git worktree",Options='IgnoreCase')] # when the pattern is "git worktree"
param()

begin {
    $supportedWorktreeCommands = @('list')
    
    $shouldSkip = $gitCommand -notmatch "worktree (?>$(
        $supportedWorktreeCommands -join '|'
    ))" -or $gitCommand -match '--porcelain'

    if ($shouldSkip) {
        continue
    }
}

process {
    switch -regex ($gitCommand) {        
        '^git worktree list' {            
            $worktreePath, $commitHashAndBranch = $gitOut -split '\s{2,}', 2
            $commitHash, $branchNameAndStatus = $commitHashAndBranch -split '\s', 2
            
            $branchStatus = ''
            $branchName, $branchStatus = $branchNameAndStatus -split '\s', 2
            
            [PSCustomObject][Ordered]@{
                PSTypeName='git.worktree'
                WorktreePath = $worktreePath
                CommitHash = $commitHash
                Branch = $branchName -replace '^\[' -replace '\]$'
                Locked = if (-not $branchStatus) { $false } else { $true }
            }
        }
    }
}

end {
    if ($gitOut) {$gitout}
}