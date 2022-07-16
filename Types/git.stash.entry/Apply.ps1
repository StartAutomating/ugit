Push-Location $this.GitRoot
git stash apply $this.Number 
Pop-Location
