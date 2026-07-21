Write-FormatView -TypeName Git.Status -Action {
    Write-FormatViewExpression -Text "On branch: "

    Write-FormatViewExpression -ScriptBlock { 
        $branchName = $_.BranchName
        @(
            if ($branchName -notin 'main', 'master', 'latest') {
                $PSStyle.Foreground.Cyan
                $PSStyle.Bold
            } else {
                $PSStyle.Formatting.Warning
            }
            $branchName
            $PSStyle.Reset
        ) -join ''                
    }
    Write-FormatViewExpression -Newline
    
    Write-FormatViewExpression -ScriptBlock {
        $gitStatus = $_
        if ($gitStatus.Status -match 'nothing') {
            return ''
        }
        @(
            if ($gitStatus.Ahead) {
                $PSStyle.Formatting.Success
            } elseif ($gitStatus.Behind) {
                $PSStyle.Formatting.Error
            }
            else {
                $PSStyle.Foreground.Cyan
            }
            $gitStatus.Status + [Environment]::NewLine
            $PSStyle.Reset
        ) -join ''        
    }    

    Write-formatviewExpression -If { $_.Staged } -ScriptBlock {
        "Changes Staged For Commit:
  (use git commit -m to commit)" + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.Staged } -ScriptBlock {
        (@(
            foreach ($staged in $_.Staged) {                
                "`t$($staged.ChangeType):`t$($staged.Path)"
            }    
        ) -join [Environment]::NewLine) + (
            [Environment]::NewLine * 2
        )
    }

    Write-FormatViewExpression -If { $_.Unstaged } -ScriptBlock {
        (@(
            "Changes $($PSStyle.Foreground.Cyan + $PSStyle.Bold)Not Staged$($PSStyle.Reset) for commit:"
            '  (use "git add <file>..." to update what will be committed)'
            '  (use "git restore <file>..." to discard changes in working directory)'
        ) -join [Environment]::NewLine) + (
            [Environment]::NewLine * 2
        )
    }

    Write-FormatViewExpression -If { $_.Unstaged }   -ScriptBlock {
        (@(
            foreach ($staged in $_.Unstaged) {                
                "`t$(
                    if ($staged.changetype -eq 'modified') {
                        $PSStyle.Foreground.Cyan
                    } 
                    elseif ($PSStyle.changetype -eq 'newfile') {
                        $PSStyle.Foreground.Green
                    }
                    elseif ($staged.changetype -eq 'deleted') {
                        $PSStyle.Foreground.Red
                    } else {
                        $PSStyle.Foreground.White
                    }
                    $psStyle.Bold                    
                )$($staged.ChangeType):`t$($staged.Path)$($PSStyle.Reset)"
            }    
        ) -join [Environment]::NewLine) + (
            [Environment]::NewLine * 2
        )
    }

    Write-FormatViewExpression -If { $_.Untracked } -ScriptBlock {
        (@(
            "$($PSStyle.Foreground.Magenta + $PSStyle.Bold)Untracked$($PSStyle.Reset) Files:"
            '  (use "git add <file>..." to include in what will be committed)'
        ) -join [Environment]::NewLine) + (
            [Environment]::NewLine * 2
        )
    }

    Write-FormatViewExpression -If { $_.Untracked}   -ScriptBlock {
        (@(
            $gitRoot = $_.GitRoot
            foreach ($untracked in $_.Untracked) {
                "`t$(
                    $untracked.FullName.Substring($gitRoot.Length + 1) -replace '[\\/]', '/'
                )"
            }            
        ) -join [Environment]::NewLine) + 
            [Environment]::NewLine + [Environment]::NewLine
    } -ForegroundColor Magenta

    Write-FormatViewExpression -ScriptBlock {
        if(($_.Untracked.Count + $_.Unstaged.Count + $_.Staged.Count) -eq 0)
        {
            "Nothing to commit, working tree clean"
        }
    } -ForegroundColor Success
}
