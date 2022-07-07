Push-Location $this.GitRoot
git revert $this.CommitHash @args
Pop-Location