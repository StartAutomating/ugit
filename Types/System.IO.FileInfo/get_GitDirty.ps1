Push-Location $this.Directory
$(git status $this.Name '-s') -as [bool]
Pop-Location
