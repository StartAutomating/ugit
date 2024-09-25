<#
.SYNOPSIS
    Generates a Mermaid graph of changes by day of week.
.DESCRIPTION
    Generates a Mermaid graph of changes by day of week.
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

$commitList = 
    if ($currentBranch -ne $headBranch) {
        git log "$($gitRemote.RemoteName)/$headBranch..$CurrentBranch"
    } else {
        git log 
    }

$groupedChangedSet = $commitList |     
    Group-Object { $_.CommitDate.DayOfWeek } -NoElement

if ($env:GITHUB_STEP_SUMMARY) { 
"
~~~mermaid
$(
@(
"pie title Changes by Day Of Week"
foreach ($changeSet in $groupedChangedSet ) {
    (' ' * 4) + '"' + $($changeSet.Name) + '"' + ' : ' + ($changeSet.Count)
}
) -join [Environment]::NewLine)
~~~

" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
}

