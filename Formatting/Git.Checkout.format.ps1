Write-FormatView -TypeName git.checkout.newbranch -Action {
    Write-FormatViewExpression -Text "Switched to a new branch "
    Write-FormatViewExpression -ScriptBlock {"'$($_.BranchName)'"} -ForegroundColor verbose 
} -GroupByProperty GitRoot

Write-FormatView -TypeName git.checkout.alreadyonbranch -Action {
    Write-FormatViewExpression -Text "Already on "
    Write-FormatViewExpression -ScriptBlock {"'$($_.BranchName)'"} -ForegroundColor warning -If { $_.BranchName -in 'main', 'master'}
    Write-FormatViewExpression -ScriptBlock {"'$($_.BranchName)'"} -ForegroundColor verbose -If { $_.BranchName -notin 'main', 'master'}
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Property Status
} -GroupByProperty GitRoot

Write-FormatView -TypeName git.checkout.switchbranch -Action {
    Write-FormatViewExpression -Text "Switched to "
    Write-FormatViewExpression -ScriptBlock {"'$($_.BranchName)'"} -ForegroundColor warning -If { $_.BranchName -in 'main', 'master'}
    Write-FormatViewExpression -ScriptBlock {"'$($_.BranchName)'"} -ForegroundColor verbose -If { $_.BranchName -notin 'main', 'master'}
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Property Status
    Write-FormatViewExpression -If { $_.Modified } -ScriptBlock {
        @(
            "  Untracked modifications:"
            ""
            $($_.Modified | Out-String).Trim()
        ) -join [Environment]::NewLine
    }
} -GroupByProperty GitRoot
