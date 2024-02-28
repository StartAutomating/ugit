#require -Module Piecemeal
Push-Location ($PSScriptRoot | Split-Path)

$commandsPath = Join-Path $pwd "Commands"

if (-not (Test-Path $commandsPath)) {
    New-Item -ItemType Directory -path $commandsPath | Out-Null
}
$outputPath = Join-Path $commandsPath 'Get-UGitExtension.ps1'
Install-Piecemeal -ExtensionModule 'ugit' -ExtensionModuleAlias 'git' -ExtensionNoun 'UGitExtension' -ExtensionTypeName 'ugit.extension' -OutputPath $outputPath

Pop-Location
