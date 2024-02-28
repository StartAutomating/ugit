Write-FormatView -TypeName Git.Shortlog.Summary -Action {
    Write-FormatViewExpression -ScriptBlock {
        ' ' * 4
    }
    Write-FormatViewExpression -ScriptBlock {
        $_.Count.ToString().PadLeft(3, ' ')
    } -ForegroundColor Verbose
    Write-FormatViewExpression -ScriptBlock {
        ' ' * 2
    }
    Write-FormatViewExpression -Property Name
    Write-FormatViewExpression -If { $_.Email } -ScriptBlock { ' <' + $_.Email + '>' }
} -GroupByProperty GitRoot
 