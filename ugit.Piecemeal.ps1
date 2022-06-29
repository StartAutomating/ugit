#require -Module Piecemeal
Push-Location $PSScriptRoot

Install-Piecemeal -ExtensionModule 'ugit' -ExtensionModuleAlias 'git' -ExtensionNoun 'UGitExtension' -ExtensionTypeName 'ugit.extension' -OutputPath '.\Get-UGitExtension.ps1'

Pop-Location
