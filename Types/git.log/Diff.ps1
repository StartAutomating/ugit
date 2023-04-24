Push-Location $this.GitRoot
$logPaths = @($this.GitCommand -split '\s' -notmatch '^(?>git|log)$' -notmatch '^\-' -ne '')
Write-Debug "Logging paths: $logPaths"
foreach ($logPath in $logPaths) {
    if (Test-Path $logPath) {
        $relativeArgs = @("--relative", $logPath)
        git diff $this.CommitHash @relativeArgs @args    
    }
}
if (-not $logPaths) {
    Write-Debug "Getting diff of commit hash: $($this.CommitHash)"
    git diff $this.CommitHash @args
}
Pop-Location