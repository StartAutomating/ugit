Push-Location $this.GitRoot
(
    git remote |
        git remote show |
        Select-Object -ExpandProperty RemoteBranches |
        Where-Object BranchName -like "*$($this.BranchName)"
) -as [bool]
Pop-Location