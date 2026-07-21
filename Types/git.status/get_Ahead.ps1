<#
.SYNOPSIS
    Gets the commits ahead
.DESCRIPTION
    Gets the number of commits ahead of the remote branch.
#>
if ($GitStatus.Status -match 'ahead') {
    $gitStatus.Status -replace '\D' -as [int]
} else {
    0
}