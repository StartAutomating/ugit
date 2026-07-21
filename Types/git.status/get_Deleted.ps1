<#
.SYNOPSIS
    Gets unstaged deleted paths
.DESCRIPTION
    Gets unstaged deleted paths.
#>
@(foreach ($unstaged in $this.Unstaged) {
    if ($unstaged.ChangeType -eq 'deleted') {
        $unstaged.Path
    }
})