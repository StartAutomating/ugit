Push-Location $this.GitRoot
git stash drop $this.Number
Pop-Location
