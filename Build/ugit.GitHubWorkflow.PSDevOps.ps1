#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)

New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, 
    TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    buildugit -OutputPath .\.github\workflows\TestAndPublish.yml -Env ([Ordered]@{
        "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
        "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'
        "REGISTRY" = "ghcr.io"
        "IMAGE_NAME" = '${{ github.repository }}'
    })

New-GitHubWorkflow -On Issue, 
    Demand -Job RunGitPub -Name OnIssueChanged -OutputPath .\.github\workflows\OnIssue.yml

New-GitHubWorkflow -On Demand -Name ugit-psa -Job SendPSA -OutputPath .\.github\workflows\SendPSA.yml  -Env @{
    "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
    "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'
}

Pop-Location
