Write-FormatView -TypeName Git.Diff -Action {
    Write-FormatViewExpression -ScriptBlock {
        @(        
        '@ '
        if ($_.From -eq $_.To) {
            $_.From
        } else {
            $_.From + '-->' + $_.To
        }

        ' @'
        " ($($_.FromHash)..$($_.ToHash)) "
        ) -join ''
    } -ForegroundColor Verbose

    Write-FormatViewExpression -If { $_.Binary } -ScriptBlock {
        "Binary files differ"
    } -ForegroundColor Warning
            
    Write-FormatViewExpression -ControlName Git.Diff.ChangeSet -Enumerate -ScriptBlock { $_.ChangeSet }
}
