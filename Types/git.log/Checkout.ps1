Push-Location $this.GitRoot
git checkout $this.CommitHash @args
Pop-Location