Write-FormatView -TypeName Git.Diff.ChangeSet -AsControl -Name Git.Diff.ChangeSet -Action {
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {
        "@@ -$($_.LineStart),$($_.LineCount) +$($_.NewLineStart),$($_.NewLineCount) @@"
    } -ForegroundColor Verbose
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {
        $changeLines = @($_.Changes -split '(?>\r\n|\n)' -ne '')
        @(foreach ($changeLine in $changeLines) {
            [Environment]::NewLine
            if ($changeLine.StartsWith('+')) {
                Format-RichText -InputObject ($changeLine -replace "[\s\r\n]+$") -ForegroundColor Success
            }
            elseif ($changeLine.StartsWith('-')) {
                Format-RichText -InputObject ($changeLine -replace "[\s\r\n]+$") -ForegroundColor Error                
            }
            else {                
                $changeLine
            }
            
        }) -join ''
    }
}

Write-FormatView -TypeName Git.Diff.ChangeSet -Action {
    Write-FormatViewExpression -ControlName Git.Diff.ChangeSet -ScriptBlock { $_ }
}
