#requires -Module PSDevOps
Push-Location $PSScriptRoot
Import-BuildStep -ModuleName ugit
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, 
    TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    buildugit -OutputPath .\.github\workflows\TestAndPublish.yml -Env @{
        "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
        "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'
    }

New-GitHubWorkflow -On Issue, 
    Demand -Job RunGitPub -Name OnIssueChanged -OutputPath .\.github\workflows\OnIssue.yml

New-GitHubWorkflow -On Demand -Name ugit-psa -Job SendPSA -OutputPath .\.github\workflows\SendPSA.yml  -Env @{
    "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
    "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'
}

Pop-Location