Write-FormatView -TypeName Git.Commit.Info -Action {
    Write-FormatViewExpression -ScriptBlock {
        "[$($_.BranchName) $($_.CommitHash)] "
    }
    Write-FormatViewExpression -Property CommitMessage
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {
        " $($_.FilesChanged) files changed"
    } -ForegroundColor verbose
    Write-FormatViewExpression -If {
        $_.Insertions
    } -ScriptBlock {
        ", $($_.Insertions) insertions(+)"
    } -ForegroundColor Success 
    Write-FormatViewExpression -If {
        $_.Deletions
    } -ScriptBlock {
        ", $($_.Deletions) deletions(-)"
    } -ForegroundColor Error
}
