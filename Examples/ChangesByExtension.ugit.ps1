<#
.SYNOPSIS
    Generates a Mermaid graph of changes by extension.
.DESCRIPTION
    Generates a Mermaid graph of changes by extension, for the current branch.
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

$currentBranchCommits = git log "$($gitRemote.RemoteName)/$headBranch..$CurrentBranch" -Statistics
$changesByExtension = $currentBranchCommits.Changes | Group-Object { ($_.FilePath -split '\.')[-1]}

if ($env:GITHUB_STEP_SUMMARY) { 
"
~~~mermaid
$(
@(
"pie title Changes by Extension"
foreach ($changeSet in $changesByExtension) {
    "    $($changeSet.Name): $(($changeSet.Group.LinesChanged | Measure-Object -Sum).Sum)"
}
) -join [Environment]::NewLine
)
~~~

" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
}

