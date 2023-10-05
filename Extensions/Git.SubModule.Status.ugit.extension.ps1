<#
.Synopsis
    Git Submodule Extension
.Description
    Git Submodule as objects.
.EXAMPLE
    git submodule
#>
[Management.Automation.Cmdlet("Out","Git")]                         # It's an extension for Out-Git
[ValidatePattern("^(?:git)\s(?:submodule)\s(?:status)?$")]          # that is run when git submodule is run (with no other options (except for status)).
param()

begin {
    $submoduleLines = @()
}

process {
    $submoduleLines += $gitOut
}

end {
    if ($gitArgument -match '--(?>n|dry-run)') {
        return $submoduleLines
    }

    foreach ($line in $submoduleLines) {
        if ($line -match '^\s{0,}[\+]?(?<CommitHash>[0-9a-f]{10,})\s(?<SubModule>\S+)\s\((?<Reference>[^\)]+)\)') {
            $Matches.Remove(0)
            $toObject = [Ordered]@{
                PSTypeName = 'git.submodule.status'
                GitOutputLines = $submoduleLines
                GitRoot = $gitRoot                
            } + $Matches                            
            [PSCustomObject]$toObject
        }
    }
}
