Push-Location $this.GitRoot
$logPaths = @($this.GitArgument -ne 'log' -notmatch '^\-')
foreach ($logPath in $logPaths) {
    if (Test-Path $logPath) {
        $relativeArgs = @("--relative", $logPath)
        git diff $this.CommitHash @relativeArgs @args    
    }
}
if (-not $logPaths) {
    git diff $this.CommitHash @args
}
Pop-Location