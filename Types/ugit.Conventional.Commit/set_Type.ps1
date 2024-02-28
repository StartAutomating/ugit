param()

$unrolledArgs = @($args | . { process { $_ }})

$standardTypes = @(
    "feat"      # feature
    "fix"       # bugfix
    "build"     # build related
    "chore"     # chore / code housekeeping
    "ci"        # ci
    "docs"      # documentation
    "style"     # stylistic
    "refactor"  # refactoring
    "release"   # releasing
    "perf"      # performance improvement
    "test"      # tests
    "BREAKING CHANGE" # BREAKING CHANGES
)

$combinedTypes = @(@($unrolledArgs + $standardTypes) | Select-Object -Unique)

$this | Add-Member NoteProperty '.Types' $combinedTypes -Force
