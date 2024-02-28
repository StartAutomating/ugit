Write-FormatView -Typename git.init -GroupByProperty GitRoot -Action {
    Write-FormatViewExpression -ForegroundColor Verbose -ScriptBlock {
        "Initialized empty git repository in "
    }
    Write-FormatViewExpression -ForegroundColor Success -Property GitRoot
}