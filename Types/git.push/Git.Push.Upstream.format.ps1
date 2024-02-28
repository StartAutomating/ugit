Write-FormatView -TypeName Git.Push.Upstream -Action {
    Write-FormatViewExpression -ScriptBlock {
        "To " + $_.GitUrl + [Environment]::NewLine
    }
    Write-FormatViewExpression -ScriptBlock {
        " * [new branch]      " + $_.SourceBranch + " -> " + $_.DestinationBranch + [Environment]::NewLine
    } -ForegroundColor Verbose

    Write-FormatViewExpression -ScriptBlock {
        "    Create a pull request for $($_.SourceBranch) on $($_.CreatePullRequestUrl.host) by visiting:" + [Environment]::NewLine
    }

    Write-FormatViewExpression -ScriptBlock {
        "      " + $_.CreatePullRequestUrl
    }
}

