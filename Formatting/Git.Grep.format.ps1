Write-FormatView -TypeName Git.Grep.Match -Action {        
    Write-FormatViewExpression -ForegroundColor Magenta -Property GitPath
    Write-FormatViewExpression -ForegroundColor Cyan -Text ':'
    Write-FormatViewExpression -If { $_.LineNumber } -ForegroundColor Green -Property LineNumber
    Write-FormatViewExpression -If { $_.LineNumber } -ForegroundColor Cyan -Text ':'
    Write-FormatViewExpression -If { $_.ColumnNumber}  -ForegroundColor Green -ScriptBlock {
        '' + $_.LineNumber
    }
    Write-FormatViewExpression -If { $_.ColumnNumber } -ForegroundColor Cyan -Text ':'

    Write-FormatViewExpression -ScriptBlock {
        [Regex]::Replace($_.Line, $_.Pattern, {
            param($match)
            Format-RichText -ForegroundColor Error -InputObject "$match"
        }, $(if ($_.CaseSensitive) { 'None'} else { 'IgnoreCase' }))        
    }
}
