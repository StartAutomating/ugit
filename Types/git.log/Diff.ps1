Push-Location $this.GitRoot
git diff $this.CommitHash @args
Pop-Location