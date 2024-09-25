<#
.SYNOPSIS
    Gets git commit notes
.DESCRIPTION
    Gets git notes associated with a commit.    
#>
$pushed = 
    if ($this.GitRoot -ne $pwd) {
        Push-Location $this.GitRoot
        $true
    } else {
        $false
    }
$showNotes = git notes show $this.CommitHash *>&1
if ($showNotes -isnot [Management.Automation.ErrorRecord]) {
    $showNotes
} else {
    $error.RemoveAt(0)
}
if ($pushed) {
    Pop-Location
}
