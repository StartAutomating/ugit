Push-Location $this.Directory
(git log -n 1 $this.Name).Diff()
Pop-Location
