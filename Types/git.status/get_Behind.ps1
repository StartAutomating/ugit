<#
.SYNOPSIS
    Gets the commits behind
.DESCRIPTION
    Gets the number of commits behind the remote branch.
#>
if ($this.Status -match 'behind') {
    @($this.Status -replace '[\D-[,]]','' -split ',',2)[0] -as [int]
} else {
    0
}
