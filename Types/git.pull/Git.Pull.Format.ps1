Write-FormatView -TypeName Git.Pull.FastForward, Git.Pull.Strategy -Action {
    Write-FormatViewExpression -ScriptBlock {
        ">> Fast Forward >>"        
    } -if { -not $_.Strategy}
    Write-FormatViewExpression -If { $_.strategy } -ScriptBlock {
        ">> Merge made by '$($_.Strategy)' strategy >>"
    } -ForegroundColor Warning
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
    } -ForegroundColor verbose -If { $_.Changes }
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

    Write-FormatViewExpression -If {
        $_.NewFiles
    } -ScriptBlock {
        @([System.Environment]::NewLine
        "++ New Files ++" 
        [System.Environment]::NewLine) -join ''
    }
    
    Write-FormatViewExpression -If {
        $_.NewFiles
    } -ScriptBlock {
        $_.NewFiles | Out-String 
    }
}
