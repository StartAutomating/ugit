Push-Location $this.GitRoot
git reset $this.CommitHash @args
Pop-Location