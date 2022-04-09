Write-FormatView -TypeName Git.Pull.No.Update -Action {
    Write-FormatViewExpression -Text "Everything up to date." -ForegroundColor Success
} -GroupByProperty GitRoot
