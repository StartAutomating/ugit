Write-FormatView -TypeName Git.Diff -Action {
    Write-FormatViewExpression -Text '@'
    Write-FormatViewExpression -If {
        ($_.From -replace '^[ab]/') -eq ($_.To -replace '^[ab]/')
    }  -ScriptBlock {
        (' ' + $_.From -replace '^[ab]/')
    }

    Write-FormatViewExpression -If {
        ($_.From -replace '^[ab]/') -ne ($_.To -replace '^[ab]/')
    } -ScriptBlock {
        '' + $_.From + '-->' + $_.To
    }
    
    Write-FormatViewExpression -ScriptBlock {
        " ($($_.FromHash)..$($_.ToHash)) "
    }

    Write-FormatViewExpression -ControlName Git.Diff.ChangeSet -Enumerate -ScriptBlock { $_.ChangeSet }
}
