<#
.SYNOPSIS
    Gets staged added files
.DESCRIPTION
    Gets staged added files.  These are all files that are new or modified.
#>
@(foreach ($staged in $this.staged) {
    if ($staged.ChangeType -in 'newfile','modified') {
        $staged.File
    }   
})