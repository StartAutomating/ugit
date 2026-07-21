<#
.SYNOPSIS
    Gets modified files
.DESCRIPTION
    Gets unstaged modified files
#>
@(foreach ($unstaged in $this.Unstaged) {
    if ($unstaged.ChangeType -eq 'modified') {
        $unstaged.File
    }
})