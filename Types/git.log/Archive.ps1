param(
[Parameter(Mandatory)]
[string]
$ArchivePath
)
$unresolvedArchivePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ArchivePath)

Push-Location $this.GitRoot
git archive $this.CommitHash '-o' "$unresolvedArchivePath" @args
Pop-Location
