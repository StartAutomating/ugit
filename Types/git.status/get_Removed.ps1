<#
.SYNOPSIS
    Gets staged removed files
.DESCRIPTION
    Gets staged removed files.
    
    These are all files that are staged for removal.
#>
@(foreach ($staged in $this.staged) {
    if ($staged.ChangeType -in 'deleted') {
        $staged.Path
    }   
})