#requires -Module PSDevOps
Push-Location $PSScriptRoot
Import-BuildStep -ModuleName ugit
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, buildugit |
    Set-Content .\.github\workflows\TestAndPublish.yml -Encoding UTF8 -PassThru

Pop-Location