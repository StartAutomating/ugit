Write-FormatView -TypeName Git.Pull.FastForward -Action {
    Write-FormatViewExpression -ScriptBlock {
        ">> Fast Forward >>"        
    }
    Write-FormatViewExpression -Newline     
    Write-FormatViewExpression -ScriptBlock {
        "$($_.GitUrl)"        
    } -ForegroundColor verbose
    Write-FormatViewExpression -Newline 
    Write-FormatViewExpression -ScriptBlock {
        "$($_.LastCommitHash)..$($_.CommitHash)  $($_.DestinationBranch) -> $($_.SourceBranch)"
    } -ForegroundColor verbose
    Write-FormatViewExpression -Newline     
    Write-FormatViewExpression -ScriptBlock {
        $maxLength = 0 
        foreach ($change in $_.Changes) {
            if ($change.FilePath.Length -gt $maxLength) {
                $maxLength = $change.FilePath.Length
            }
        }
        @(foreach ($change in $_.Changes) {
            '  ' + $($change.FilePath.PadRight($maxLength, ' ')) + " | $($changes.LinesChanged)" + ' ' + (
                @(
                    if ($change.LinesInserted) {
                        . $SetOutputStyle -ForegroundColor Success
                        '+' * $change.LinesInserted
                        . $ClearOutputStyle
                    }
                ) -join ''
            ) + (
                @(
                    if ($change.LinesDeleted) {
                        . $SetOutputStyle -ForegroundColor Error
                        '-' * $change.LinesDeleted
                        . $ClearOutputStyle
                    }
                ) -join ''
            )
        }) -join [Environment]::NewLine
    }
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {
        " $($_.FilesChanged) files changed"
    } -ForegroundColor verbose
    Write-FormatViewExpression -If {
        $_.Insertions
    } -ScriptBlock {
        ", $($_.Insertions) insertions(+)"
    } -ForegroundColor Success 
    Write-FormatViewExpression -If {
        $_.Deletions
    } -ScriptBlock {
        ", $($_.Deletions) deletions(-)"
    } -ForegroundColor Error
}
