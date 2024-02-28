#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction
Push-Location ($PSScriptRoot | Split-Path)
New-GitHubAction -Name "UseUGit" -Description 'Updated Git' -Action UGitAction -Icon git-merge -OutputPath .\action.yml
Pop-Location