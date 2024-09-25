<#
.SYNOPSIS
    Gets git commit notes
.DESCRIPTION
    Gets git notes associated with a commit.    
#>
Push-Location $this.GitRoot
git notes show $this.CommitHash
Pop-Location
