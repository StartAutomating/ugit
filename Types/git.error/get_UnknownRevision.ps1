<#
.SYNOPSIS
    Gets Unknown Revisions
.DESCRIPTION
    Gets Unknown Revisions from any git error output.
#>
if ($this -match "'(?<n>.+?)'\: unknown revision or path not in the working tree") {
    $matches.n
}