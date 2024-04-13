<#
.SYNOPSIS
    git config list extension
.DESCRIPTION
    Parses the output of git config --list int a PowerShell object.
.EXAMPLE
    git config --list
.EXAMPLE
    git config --global --list
.EXAMPLE
    git config --list --local
#>
[Management.Automation.Cmdlet("Out","Git")]         # It  extends Out-Git
[ValidatePattern('^[\S]{0,}git config[\s\S]{1,}--list')]
param()

begin {
    $configLines = @()
}

process {
    $configLines += "$gitOut"
}

end {
    $configEntries = [Ordered]@{}

    foreach ($configLine in $configLines -match '=') {
        $key, $value = $configLine -split '=', 2
        if (-not $configEntries[$key]) {
            $configEntries[$key] = $value
        } else {
            $configEntries[$key] = @($configEntries[$key]) + $value
        }        
    }
    if ($configEntries.Count) {
        $configObject = [PSCustomObject]$configEntries
        $configObject.PSTypeNames.insert(0,'git.config')
        $configObject
    } else {
        $configLines
    }
}


