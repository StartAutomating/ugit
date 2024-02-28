#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction
New-GitHubAction -Name "UseUGit" -Description 'Updated Git' -Action UGitAction -Icon git-merge -OutputPath .\action.yml
