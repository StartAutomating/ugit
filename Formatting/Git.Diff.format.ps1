Write-FormatView -TypeName Git.Diff -Action {
    Write-FormatViewExpression -ScriptBlock {
        @(
        . $SetOutputStyle -ForegroundColor Verbose
        '@ '
        if ($_.From -eq $_.To) {
            $_.From
        } else {
            $_.From + '-->' + $_.To
        }

        ' @'
        " ($($_.FromHash)..$($_.ToHash)) "
        . $ClearOutputStyle
        ) -join ''
    }
    
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ControlName Git.Diff.ChangeSet -Enumerate -ScriptBlock { $_.ChangeSet }
}
