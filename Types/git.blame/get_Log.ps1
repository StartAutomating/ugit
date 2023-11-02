
Push-Location $this.GitRoot
git log $this.CommitHash -NumberOfCommits 1
Pop-Location