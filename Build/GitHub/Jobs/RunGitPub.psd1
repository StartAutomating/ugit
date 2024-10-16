@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        }
        @{
            name = 'Use GitPub Action'
            uses = 'StartAutomating/GitPub@main'
            id  = 'GitPub'
            with = @{
                TargetBranch = 'edits-$([DateTime]::Now.ToString("o") -replace "T.+$")'
                CommitMessage = 'Posting with GitPub [skip ci]'
                PublishParameters = @'
{
    "Get-GitPubIssue": {
        "Repository": '${{github.repository}}'
    },
    "Get-GitPubRelease": {
        "Repository": '${{github.repository}}'        
    },
    "Publish-GitPubJekyll": {
        "OutputPath": "docs/_posts"
    }
}
'@                    
            }
        }
    )
}