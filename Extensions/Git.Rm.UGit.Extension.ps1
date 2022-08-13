<#
.Synopsis
    Git Remove Extension
.Description
    Outputs git rm as objects.
.EXAMPLE
    git rm .\FileIDontCareAbout.txt
#>
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("^git rm")]                  # that is run when the switch -o is used.
[OutputType([IO.FileInfo])]
param(   )

begin {
    $removeLines = @()    
}

process {
    $removeLines += $gitOut
}

end {
    if ($gitArgument -match '--(?>n|dry-run)') {
        return $removeLines
    }

    foreach ($line in $removeLines) {
        if ($line -match "^rm '") {
            $removedFileName = $line -replace "^rm\s" -replace "^'" -replace "'$"
            $removedLinesFound = $true
            [PSCustomObject][Ordered]@{
                PSTypeName     = 'git.removal'
                RemovedFile    = $removedFileName
                GitOutputLines = $removeLines
                GitRoot        = $gitRoot
                GitCommand     = $gitCommand
            }
        } else {
            $line
        }        
    }    
}
