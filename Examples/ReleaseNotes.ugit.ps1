<#
.SYNOPSIS
    Generates release notes by commit type.
.DESCRIPTION
    Generates release notes of changes by grouping by the conventional commit type.
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
        Write-Warning "Not generating Release Notes for everything in $headBranch."
        return        
    }



$groupedChangedSet = $commitList |    
    Group-Object { $_.CommitType }

$releaseNoteBulletpoints = @(    
    foreach ($changeSet in $groupedChangedSet) {
        if ($changeSet.Name) {
            "* $($changeSet.Name)"
            $indent = ' ' * 2
        }
        else {
            "* $($changeSet.Name)"
            $indent = ''
        }
        
        foreach ($Description in $changeSet.Group | 
            Select-Object -ExpandProperty Description -Unique
        ) { 
            $indent, '* ', $Description -join ''
        }
    }
) -join [Environment]::NewLine

if ($env:GITHUB_STEP_SUMMARY) { 
"
~~~markdown
$releaseNoteBulletpoints
~~~

" |
        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
} else {
    $releaseNoteBulletpoints
}


