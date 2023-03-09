#requires -Module PSDevOps
#requires -Module ugit
Import-BuildStep -ModuleName ugit
New-GitHubAction -Name "UseUGit" -Description 'Updated Git' -Action UGitAction -Icon git-merge -OutputPath .\action.yml
