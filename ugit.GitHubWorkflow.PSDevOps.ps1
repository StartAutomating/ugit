#requires -Module PSDevOps
Push-Location $PSScriptRoot

New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, UsePiecemeal, RunEZOut, HelpOut |
    Set-Content .\.github\workflows\TestAndPublish.yml -Encoding UTF8 -PassThru

Pop-Location