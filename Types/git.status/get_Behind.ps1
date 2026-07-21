<#
.SYNOPSIS
    Gets the commits behind
.DESCRIPTION
    Gets the number of commits behind the remote branch.
#>
if ($GitStatus.Status -match 'behind') {
    @($gitStatus.Status -replace '[\D-[,]]','' -split ',',2)[0] -as [int]
} else {
    0
}
