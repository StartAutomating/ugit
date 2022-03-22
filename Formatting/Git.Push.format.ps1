Write-FormatView -TypeName Git.Push -Action {
    Write-FormatViewExpression -ScriptBlock {
        "To " + $_.GitUrl + [Environment]::NewLine
    }
    Write-FormatViewExpression -ScriptBlock {
        "   " + $_.LastCommitHash + '..' + $_.CommitHash + "  " + $_.SourceBranch + " -> " + $_.DestinationBranch
    } -ForegroundColor Verbose
}
