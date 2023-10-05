if (-not $args) {
    throw "Must provide a new branch name"
}
Push-Location $this.GitRoot
git branch '-m' $this.BranchName @args
Pop-Location
