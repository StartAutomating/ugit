if (-not $this.'.Types') {
    $this | Add-Member NoteProperty '.Types' @(
        "feat"      # feature
        "fix"       # bugfix
        "build"     # build related
        "chore"     # chore / code housekeeping
        "ci"        # ci
        "docs"      # documentation
        "style"     # stylistic
        "refactor"  # refactoring
        "perf"      # performance improvement
        "test"      # tests
        "BREAKING CHANGE" # BREAKING CHANGES
    ) -Force
}
$this.'.Types'
