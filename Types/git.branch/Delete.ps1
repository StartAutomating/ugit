Push-Location $this.GitRoot
git branch '-d' $this.BranchName @args
Pop-Location