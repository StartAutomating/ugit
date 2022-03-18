param([string[]]$DiffArgs)

git diff $this.CommitHash @DiffArgs
