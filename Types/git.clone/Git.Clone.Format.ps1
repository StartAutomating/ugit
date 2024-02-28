Write-FormatView -TypeName 'git.clone' -Action {
    Write-FormatViewExpression -Text "Cloned "
    Write-FormatViewExpression -Property GitUrl -ForegroundColor Success
    Write-FormatViewExpression -Text " into "
    Write-FormatViewExpression -Property Directory -ForegroundColor verbose
}
