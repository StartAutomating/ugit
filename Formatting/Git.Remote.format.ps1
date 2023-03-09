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
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Text '  Remote Branches:'
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ControlName GitRemoteBranchList -Property RemoteBranches
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Text '  Local Branches:' 
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ControlName GitRemoteBranchList -Property LocalBranches
    Write-FormatViewExpression -Text '  Tracked Upstreams:'
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ControlName GitRemoteBranchList -Property TrackedUpstreams
    Write-FormatViewExpression -Newline
}

Write-FormatView -TypeName n/a -Name GitRemoteBranchList -AsControl -Action {
    (' ' * 4) + @($_ | 
        Format-Table -Property BranchName, Status |
        Out-String -Width ($host.UI.RawUI.BufferSize.Width - 4)
    ) -split [Environment]::NewLine -join (
        [Environment]::NewLine + (' ' * 4)
    )
}

