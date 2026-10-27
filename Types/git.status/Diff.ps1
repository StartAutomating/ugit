<#
.SYNOPSIS
    Gets Status Difference
.DESCRIPTION
    Gets the diff of a status.  
    
    This will show any modifications to files.
#>
param()

Push-Location $this.WorkingDirectory
git status . | 
    Select-Object -ExpandProperty Modified |
    git diff
Pop-Location