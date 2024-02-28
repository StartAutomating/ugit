if (-not $this.'.ConventionalCommits') {
    $this | Add-Member NoteProperty '.ConventionalCommits' ([PSCustomObject]@{
        PSTypeName = 'ugit.Conventional.Commit'
    })
}

$this.'.ConventionalCommits'
