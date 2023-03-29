#requires -Module PSDevOps
Push-Location $PSScriptRoot
Import-BuildStep -ModuleName ugit
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, 
    TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    buildugit -OutputPath .\.github\workflows\TestAndPublish.yml

New-GitHubWorkflow -On Issue, 
    Demand -Job RunGitPub -Name OnIssueChanged -OutputPath .\.github\workflows\OnIssue.yml

Pop-Location