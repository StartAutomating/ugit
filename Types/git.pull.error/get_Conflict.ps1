<#
.SYNOPSIS
    Gets Conflicts
.DESCRIPTION
    Gets Conflicts from any git pull output.
#>
foreach ($line in $this -split '[\r\n]+') {
    if ($line -match "^\t(?<path>.+?)\s{0,}$") {
        $matches.path
    }    
}

