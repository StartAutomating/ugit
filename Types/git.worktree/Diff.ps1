<#
.SYNOPSIS
    Diffs a worktree
.DESCRIPTION
    Compares a worktree.
.NOTES
    This will move to the worktree path, run `git diff`, and move back.

    Relative paths are not recommended.
    
    Tthey will refer to the worktree path, not the original path
#>
param()

if (-not $this.WorktreePath) { return }
Push-Location $this.WorktreePath
git diff @args
Pop-Location