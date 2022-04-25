#requires -Module PSDevOps
Push-Location $PSScriptRoot

New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish |
    Set-Content .\.github\workflows\TestAndPublish.yml -Encoding UTF8 -PassThru

New-GitHubWorkflow -Name "Run HelpOut" -On Push  -Job HelpOut |
    Set-Content .\.github\workflows\UpdateDocs.yml -Encoding UTF8 -PassThru

New-GitHubWorkflow -Name "Run EZOut" -On Push -Job RunEZOut |
    Set-Content .\.github\workflows\RunEZOut.yml -Encoding UTF8 -PassThru

Pop-Location