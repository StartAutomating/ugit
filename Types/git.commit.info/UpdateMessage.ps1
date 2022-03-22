param(
[Parameter(Mandatory)]
[string]
$Message
)

Push-Location $this.GitRoot
git commit --ammend -m $Message @args
Pop-Location

