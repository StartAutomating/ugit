<#
.SYNOPSIS
    Generates a Mermaid graph of changes by username.
.DESCRIPTION
    Generates a Mermaid graph of changes by username, for the current branch.
#>
param()

$gitRemote = git remote
$headBranch = git remote |
    Select-Object -First 1 |
    git remote show |
    Select-Object -ExpandProperty HeadBranch

$currentBranch = git branch | ? IsCurrentBranch
if ($currentBranchName -eq $headBranch) {
    Write-Warning "Not graphing the main branch."
    return
}

$currentBranchCommits = git log "$($gitRemote.RemoteName)/$headBranch..$CurrentBranch"
$changesByUserName = $currentBranchCommits |     
    Group-Object GitUserName -NoElement

if ($env:GITHUB_STEP_SUMMARY) { 
"
~~~mermaid
$(
@(
"pie title Changes by UserName"
foreach ($changeSet in $changesByUserName) {
    (' ' * 4) + '"' + $($changeSet.Name) + '"' + ' : ' + ($changeSet.Group.Count)
}
) -join [Environment]::NewLine)
~~~

" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
}

