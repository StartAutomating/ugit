# Formatting definitions for various outputs from Git.Remote

Write-FormatView -TypeName Git.Remote.Name -Property RemoteName -GroupByProperty GitRoot

Write-FormatView -TypeName Git.Remote.Url -Property RemoteName, RemoteUrl -GroupByProperty GitRoot

Write-FormatView -TypeName Git.Remote.Show -Action {
    Write-FormatViewExpression -Text '* remote '
    Write-FormatViewExpression -ForegroundColor Verbose -Property RemoteName
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Text '  HEAD branch: '
    Write-FormatViewExpression -ForegroundColor Verbose -Property HeadBranch
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Text '  URLS: '
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {        
        (' ' * 4) + @(
            $_.RemoteUrls | Out-String -Width ($host.UI.RawUI.BufferSize.Width - 4)
        ) -split [Environment]::NewLine -join (
            [Environment]::NewLine + (' ' * 4)
        )
    }
    Write-FormatViewExpression -If { $_.RemoteBranches } -ScriptBlock {
        [Environment]::NewLine +  '  Remote Branches:' + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.RemoteBranches } -ControlName GitRemoteBranchList -Property RemoteBranches         
    
    Write-FormatViewExpression -If { $_.LocalBranches } -ScriptBlock {
        [Environment]::NewLine +  '  Local Branches:' + [Environment]::NewLine
    }

    Write-FormatViewExpression -If { $_.LocalBranches } -ControlName GitRemoteBranchList -Property LocalBranches
    

    Write-FormatViewExpression -If { $_.TrackedUpstreams } -ScriptBlock {
        [Environment]::NewLine +  '  Tracked Upstreams:' + [Environment]::NewLine
    }
    
    Write-FormatViewExpression -If { $_.TrackedUpstreams } -ControlName GitRemoteBranchList -Property TrackedUpstreams    
}

Write-FormatView -TypeName n/a -Name GitRemoteBranchList -AsControl -Action {
    (' ' * 4) + @($_ | 
        Format-Table -Property BranchName, Status |
        Out-String -Width ($host.UI.RawUI.BufferSize.Width - 4)
    ) -split [Environment]::NewLine -join (
        [Environment]::NewLine + (' ' * 4)
    )
}

