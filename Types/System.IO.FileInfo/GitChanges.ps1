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
    git log --since ([DateTime]::Now - $byTimespan[0]).ToString('s') $this.Name 
}
elseif ($byDate) {
    if ($byDate.Length -gt 1) {
        $first, $second = $byDate | Sort-Object
        git log --after $second.ToString('s') --before $first.ToString('s') $this.Name
    } elseif ($byDate.Length -eq 1) {
        git log --since $byDate[0].ToString('s') $this.Name 
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