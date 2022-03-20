Write-FormatView -TypeName Git.Status -Action {
    Write-FormatViewExpression -Text "On Branch: "
    Write-FormatViewExpression -ScriptBlock { $_.BranchName }
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -If { $_.Status } -ScriptBlock { $_.Status + [Environment]::NewLine }
    Write-formatviewExpression -If { $_.Staged } -ScriptBlock { 
        "Changes Staged For Commit:
  (use git commit -m to commit)" + [Environment]::NewLine
    }
    Write-FormatViewExpression -If { $_.Staged } -ScriptBlock {
        (@(foreach ($line in $($_.Staged | Select-Object ChangeType, Path | Out-String -Width ($host.UI.RawUI.BufferSize.Width - 8)) -split '(?>\r\n|\n)') {
            (" " * 4) + $line
        }) -join [Environment]::NewLine) + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.Unstaged } -ScriptBlock { 
        "Changes Not Staged For Commit:
  (use git add <file> to add, git restore <file> to discard changes)" + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.Unstaged}   -ScriptBlock {
        (@(foreach ($line in $($_.Unstaged | Select-Object ChangeType, Path | Out-String -Width ($host.UI.RawUI.BufferSize.Width - 8)) -split '(?>\r\n|\n)') {
            (" " * 4) + $line
        }) -join [Environment]::NewLine) + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.Untracked } -ScriptBlock {
        "Untracked Files:
  (use git add <file> to include in commit)" + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.Untracked}   -ScriptBlock {
        @(foreach ($line in $($_.Untracked | Out-String -Width ($host.UI.RawUI.BufferSize.Width - 8)) -split '(?>\r\n|\n)') {
            (" " * 4) + $line
        }) -join [Environment]::NewLine
    }

    Write-FormatViewExpression -if { -not $_.Untracked -and -not $_.Unstaged -and -not $_.Staged } -Text "Nothing to commit, working tree clean"
} -GroupByProperty GitRoot
