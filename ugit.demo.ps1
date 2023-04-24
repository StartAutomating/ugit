# 1. ugitting started

# ugit updates git to make it work wonderfully in PowerShell.

# When you use ugit, git returns objects, not files.

git log -n 1

# Don't believe me?  Just pipe to Get-Member

git log -n 1 | 
    Get-Member

# You can also pipe into git commands

Get-Item .\ugit.psd1 | git log

# git logs ain't all, ugit supports a bunch of git commands
git branch

# Let's use the object pipeline to filter out the current branch
git branch | 
    Where-Object -Not IsCurrentBranch

# Another cool thing ugit can do is -WhatIf.  That will output the git command without running it.
git branch |
    Where-Object -Not IsCurrentBranch |
    git branch -d -WhatIf

# We can also git status
git status

# And even get untracked files (as files!)
git status |
    Where-Object Untracked | 
    Select-Object -Expand Untracked
    
# We can git diffs

git diff

# And get files with differences this way, too

(git diff).File

# 2. ugitting cooler

# ugit has started to extend the parameters of git

# some of these are simple, like --convenience parameters:

git log -After ([datetime]::Now.AddMonths(-1))

# Others are more interesting, like being able to get changes from the current branch:
git log -CurrentBranch

# Others make obscure git features easier to access.  For example, let's search for any commits that changed ModuleVersion
git log -SearchPattern ModuleVersion

# Or, let's look for all commits related to issue #1
git log -IssueNumber 1

# Some improvements are subtle.  For instance, we git clone will always add --progress, and will Write-Progress
git clone https://github.com/StartAutomating/ugit.git

# Let's clean that up.
Remove-Item .\ugit -Recurse -Force

# 3. ugit how it works

# ugit works with a few tricks of the PowerShell trade

# Aliases win over everything, so step one is to make git an alias to a function, Use-Git
Get-Command git

# When we override git, we can add extra parameters and parse it's output.

# We do this with ugit extensions.
Get-UGitExtension

# An extension can apply to Use-Git or Out-Git.

# Out-Git extensions turn git output into objects when the git command matches a pattern.
Get-UGitExtension -CommandName Out-Git

# Use-Git extensions add extra parameters to git when the command matches a pattern.
Get-UGitExtension -CommandName Use-Git

# Each extension returns a property bag, which can then be extended within ugit.types.ps1xml and formatted within a ugit.format.ps1xml.

# In this way, we can elegantly parse anything git throws at us, and leave the rest alone.

# ugit it?