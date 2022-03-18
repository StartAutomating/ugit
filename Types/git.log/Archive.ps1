param(
[Parameter(Mandatory)]
[string]
$ArchivePath
)

git archive $this.CommitHash '-o' $ArchivePath @args
