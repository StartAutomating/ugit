<#
.SYNOPSIS
    Generates a summary of the current branch
.DESCRIPTION
    This will generate a summary of the current branch, in markdown format.
#>
param()

$gitPullFirst = git pull
$currentBranchName = git branch | ? IsCurrentBranch
if ($currentBranchName -in 'master','main') {
    Write-Warning "Not summarizing the main branch."    
    return
}

$currentBranchCommits = git log -CurrentBranch -Statistics 
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
## branch summary

$markdownTable
" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
}

