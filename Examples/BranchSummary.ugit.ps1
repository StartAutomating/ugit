<#
.SYNOPSIS
    Generates a summary of the current branch
.DESCRIPTION
    This will generate a summary of the current branch, in markdown format.
#>
param()

$gitRemote = git remote
$headBranch = git remote |
    Select-Object -First 1 |
    git remote show |
    Select-Object -ExpandProperty HeadBranch

$currentBranch = git branch | ? IsCurrentBranch
if ($currentBranchName -eq $headBranch) {
    Write-Warning "Not summarizing the main branch."    
    return
}

$currentBranchCommits = git log "$($gitRemote.RemoteName)/$headBranch..$CurrentBranch" -Statistics
$currentBranchCommits | Out-Host
$markdownTable = '|GitUserName|CommitDate|CommitMessage|'
'|-|:-:|-|'
foreach ($gitlog in $currentBranchCommits) {    
    '|' + $(
        $gitLog.GitUserName, 
        $gitLog.GitCommitDate.ToString(), 
        ($gitLog.CommitMessage -replace '(?>\r\n|\n)', '<br/>') -join '|'
    ) + '|'
}

if ($env:GITHUB_STEP_SUMMARY) {
    $remoteUrl = git remote | git remote get-url
    "
## Branch summary

$markdownTable
" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
}

