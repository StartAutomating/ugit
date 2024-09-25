<#
.SYNOPSIS
    Generates a Mermaid graph of changes by commit type.
.DESCRIPTION
    Generates a Mermaid graph of changes by the conventional commit type.
#>
param()

Write-Information "Graphing $($MyInvocation.MyCommand.Name) for $($currentBranch.BranchName) branch."
$gitRemote = git remote
$headBranch = git remote |
    Select-Object -First 1 |
    git remote show |
    Select-Object -ExpandProperty HeadBranch

$currentBranch = git branch | ? IsCurrentBranch


$commitList = 
    if ($currentBranch.BranchName -ne $headBranch) {
        git log "$($gitRemote.RemoteName)/$headBranch..$($CurrentBranch.BranchName)"
    } else {
        git log
    }

$groupedChangedSet = $commitList |
    ? { $_.CommitType } |
    Group-Object { $_.CommitType } -NoElement

$mermaidDiagram = @(
    "pie title Changes by Commit Type"
    foreach ($changeSet in $groupedChangedSet) {
        (' ' * 4),'"',$($changeSet.Name),'"',' : ',($changeSet.Count) -join ''
    }
) -join [Environment]::NewLine

if ($env:GITHUB_STEP_SUMMARY) { 
"
~~~mermaid
$mermaidDiagram
~~~

" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
}

