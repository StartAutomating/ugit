Write-FormatView -TypeName 'Git.Shortlog' -Action {
    Write-FormatViewExpression -Property name -ForegroundColor Success
    Write-FormatViewExpression -If { $_.Email } -ScriptBlock {
        " < " +  $_.Email +  ' >'
    } -ForegroundColor Warning
    Write-FormatViewExpression -ScriptBlock {
        ' (' + $_.Count + '):'
    } -ForegroundColor Verbose
    Write-FormatViewExpression -ScriptBlock {
        $lineAndIndent = [Environment]::Newline + (' ' * 4)
        $lineAndIndent + $(@(
            $_.Commits
        ) -join $lineAndIndent)
    }
} -GroupByProperty GitRoot
