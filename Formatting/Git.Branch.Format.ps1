Write-FormatView -TypeName git.branch -Property BranchName, IsCurrentBranch -GroupByProperty GitRoot

Write-FormatView -TypeName git.branch.detail -Property BranchName, BranchHash, IsCurrentBranch, CommitMessage -GroupByProperty GitRoot -Wrap
