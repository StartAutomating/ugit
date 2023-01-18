Write-FormatView -TypeName Git.Grep.Match -Action {
    # Path in Magenta        
    Write-FormatViewExpression -ForegroundColor Magenta -Property GitPath
    # Colons in cyan
    Write-FormatViewExpression -ForegroundColor Cyan -Text ':'
    
    Write-FormatViewExpression -If {
        # LineNumber in green (if present)
        $_.LineNumber
    } -ForegroundColor Green -Property LineNumber
    
    Write-FormatViewExpression -If {
        # Colons in cyan
        $_.LineNumber
    } -ForegroundColor Cyan -Text ':'
    
    Write-FormatViewExpression -If {
        # ColumnNumber in green (if present)
        $_.ColumnNumber
    }  -ForegroundColor Green -ScriptBlock {
        '' + $_.LineNumber
    }
    
    Write-FormatViewExpression -If {
        # Colons in cyan
        $_.ColumnNumber
    } -ForegroundColor Cyan -Text ':'

    
    Write-FormatViewExpression -ScriptBlock {
        # Higlight the match with a replacer.
        [Regex]::Replace($_.Line, $_.Pattern, {
            param($match)
            Format-RichText -ForegroundColor Error -InputObject "$match"
        }, $(if ($_.CaseSensitive) { 'None'} else { 'IgnoreCase' }))        
    }
}
