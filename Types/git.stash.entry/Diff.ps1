Push-Location $this.GitRoot
git stash show $this.Number --patch
Pop-Location
