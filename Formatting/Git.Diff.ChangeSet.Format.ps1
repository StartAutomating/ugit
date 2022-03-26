Write-FormatView -TypeName Git.Diff.ChangeSet -AsControl -Name Git.Diff.ChangeSet -Action {
    Write-FormatViewExpression -ScriptBlock {
        "@@ -$($_.LineStart),$($_.LineCount) +$($_.NewLineStart),$($_.NewLineCount) @@"
    } -ForegroundColor Verbose
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {
        $changeLines = @($_.Changes -split '(?>\r\n|\n)' -ne '')
        @(foreach ($changeLine in $changeLines) {
            [Environment]::NewLine
            if ($changeLine.StartsWith('+')) {                
                . $SetOutputStyle -ForegroundColor Success
                $changeLine -replace "[\s\r\n]+$"
                . $ClearOutputStyle
            }
            elseif ($changeLine.StartsWith('-')) {            
                . $SetOutputStyle -ForegroundColor Failure
                $changeLine -replace "[\s\r\n]+$"
                . $ClearOutputStyle
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
