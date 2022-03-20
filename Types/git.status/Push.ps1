Push-Location $this.GitRoot
if (-not $this.Status) {
    git push --set-upstream origin $this.BranchName @args
} else {
    git push @args
}
Pop-Location
