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
.EXAMPLE
    git config --list --show-origin
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

    # Only lines containing an = are considered configuration entries
    foreach ($configLine in $configLines -match '=') {
        # Split the line into key and value
        $key, $value = $configLine -split '=', 2
        # If the key starts with file:, replace spaces with ? and convert to URI
        if ($key -match '^file:') {
            $key = $key -replace '\s', '?' -as [uri]
        }
        # If there are no entries, set the value
        if (-not $configEntries[$key]) {
            $configEntries[$key] = $value
        } else {
            # If there are multiple entries, convert to array
            $configEntries[$key] = @($configEntries[$key]) + $value
        }        
    }

    # If there were any entries,
    if ($configEntries.Count) {
        # create a custom object
        $configObject = [PSCustomObject]$configEntries
        # decorate it as a 'git.config.list' object
        $configObject.PSTypeNames.insert(0,'git.config.list')
        # and output it.
        $configObject
    } else {
        # If there were no entries, output the original lines
        $configLines
    }
}


