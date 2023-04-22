<#
.SYNOPSIS
    Get Changes for a given file
.DESCRIPTION
    Gets changes from git for a given file.  Can provide a timespan, series of numbers, date, or pair of dates.
#>

$byDate = @()
$byNumber = @()
$byTimespan = @()
foreach ($arg in $args) {
    if ($arg -as [int] -ne $null) {
        $byNumber += $arg -as [int]
    }
    elseif ($arg -is [object[]]) {
        $byNumber += $arg
    }
    elseif ($arg -as [DateTime]) {        
        $byDate+= $arg -as [DateTime]
    }
    elseif (
        $arg -as [TimeSpan]
    ) {
        $byTimespan+= $arg -as [TimeSpan]
    }    
}

Push-Location $this.Directory



if ($byTimespan) {    
    git log -Since ([DateTime]::Now - $byTimespan[0]) $this.Name 
}
elseif ($byDate) {
    if ($byDate.Length -gt 1) {
        $first, $second = $byDate | Sort-Object
        git log -After $second -Before $first $this.Name
    } elseif ($byDate.Length -eq 1) {
        git log -Since $byDate[0] $this.Name 
    } else {
        throw "Can only list Changes between two dates"
    }
}
elseif ($byNumber.Length) {
    $maxNumber = $byNumber | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $maxNumber = $maxNumber + 1
    $anyNegative = @($byNumber -lt 0).Length
    
    if ($anyNegative) {                
        @(git log $this.Name)[@($byNumber -as [int[]])]
    } else {
        @(git log -n $maxNumber $this.Name)[@($byNumber -as [int[]])]
    }        
}
else {
    git log $this.Name
}

Pop-Location