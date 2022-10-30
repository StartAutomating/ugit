<div align='center'>
<img src='assets/ugit.svg' />
</div>

Updated Git: A powerful PowerShell wrapper for git that lets you extend git, automate multiple repos, and output git as objects.


## What is ugit?

ugit is a PowerShell module that gives you an updated git.  You can use the object pipeline to pipe folders or files into git.  
If you're using one of a number of supported commands, ugit will return your git output as objects.
This enables _a lot_ of interesting scenarios, giving you and updated way to work with git.

## Getting started

### Installing ugit
~~~PowerShell
Install-Module ugit -Scope CurrentUser
Import-Module ugit -Force -PassThru
# Once you've imported ugit, just run git commands normally.
# If ugit has an extension for the command, it will output as an object.
# These objects can be formatted by PowerShell
git log -n 5 

# To get a sense of what you can do, pipe a given git command into Get-Member.
git log -n 5 |
  Get-Member
~~~


## How ugit works:

ugit only has a few commands:

### Use-Git

After you've imported ugit, Use-Git is what will be called when you run "git".

This happens because Use-Git is aliased to "git", and aliases are resolved first in PowerShell.

Use-Git assumes all positional parameters are arguments to Git, and passes them on directly.

This works in almost every scenario, except with some single character git options.  You can pass these in quotes.

When Use-Git outputs, it sets $global:LastGitOutput and then pipes to Out-Git.

### Out-Git

Out-Git will attempt to take git output and return it as a useful object.

This object can then be extended and formatted by PowerShell's Extended Type System.

Out-Git accomplishes this with several extensions.  You can list extensions with Get-UGitExtension:

### Get-UGitExtension

Get-UGitExtension enables any file beneath ugit (or a module that tags ugit) named *.ugit.extension.ps1 to be treated as an extension.

In ugit, extensions signal that they apply to a given git command by adding a ```[ValidatePattern]``` attribute to the command.

If this pattern matches the given git command, the extension will run.

Get-UGitExtension is built using [Piecemeal](https://github.com/StartAutomating/Piecemeal)

## Git Commands Extended


* [Git Branch](Git.Branch-Extension.md)

 
* [Git Checkout](Git.Checkout-Extension.md)

 
* [Git Clone](Git.Clone-Extension.md)

 
* [Git Commit](Git.Commit-Extension.md)

 
* [Git Diff](Git.Diff-Extension.md)

 
* [Git Help All](Git.Help.All-Extension.md)

 
* [Git Init](Git.Init-Extension.md)

 
* [Git Log](Git.Log-Extension.md)

 
* [Git Mv](Git.Mv-Extension.md)

 
* [Git Pull](Git.Pull-Extension.md)

 
* [Git Push](Git.Push-Extension.md)

 
* [Git RefLog](Git.RefLog-Extension.md)

 
* [Git Rm](Git.Rm-Extension.md)

 
* [Git Shortlog](Git.Shortlog-Extension.md)

 
* [Git Stash](Git.Stash-Extension.md)

 
* [Git Status](Git.Status-Extension.md)



### Extensions that may apply to any git command:

* git.fileoutput

This applies to an git command that uses the -o flag.
It will attempt to locate any output specified by -o and return it as a file or directory.

## ugit examples

### Git.Branch Example 1


~~~PowerShell
    git branch  # Get a list of branches
~~~

### Git.Branch Example 2


~~~PowerShell
    git branch |                                          # Get all branches
        Where-Object -Not IsCurrentBranch |               # where it is not the current branch
        Where-Object BranchName -NotIn 'main', 'master' | # and the name is not either main or master
        git branch -d                                     # then attempt to delete the branch.
~~~

### Git.Checkout Example 1


~~~PowerShell
    git checkout -b CreateNewBranch
~~~

### Git.Checkout Example 2


~~~PowerShell
    git checkout main
~~~

### Git.Clone Example 1


~~~PowerShell
    git clone https://github.com/StartAutomating/ugit.git
~~~

### Git.Clone Example 2


~~~PowerShell
    # Clone a large repo.
    # When --progress is provided, Write-Progress will be called.
    git clone https://github.com/Azure/azure-quickstart-templates --progress
~~~

### Git.Commit Example 1


~~~PowerShell
    git commit -m "Updating #123"
~~~

### Git.Commit Example 2


~~~PowerShell
    $committedMessage = git commit -m "Committting Stuff" # Whoops, this commit had a typo
    $commitMessage.Amend("Committing stuff") # that's better
~~~

### Git.FileOutput Example 1


~~~PowerShell
    git archive -o My.zip
~~~

### Git.Help.All Example 1


~~~PowerShell
    git help -a
~~~

### Git.Help.All Example 2


~~~PowerShell
    git help --all
~~~

### Git.Init Example 1


~~~PowerShell
    git init # Initialize the current directory as a repository
~~~

### Git.Log Example 1


~~~PowerShell
    # Get all logs
    git log | 
        # until the first merged pull request
        Where-Object -Not Merged
~~~

### Git.Log Example 2


~~~PowerShell
    # Get a single log entry
    git log -n 1 | 
        # and see what the log object can do.
        Get-Member
~~~

### Git.Log Example 3


~~~PowerShell
    # Get all logs
    git log |
        # Group them by the author
        Group-Object GitUserEmail -NoElement |
        # sort them by count
        Sort-Object Count -Descending
~~~

### Git.Log Example 4


~~~PowerShell
    # Get all logs
    git log |
        # Group them by day of week 
        Group-Object { $_.CommitDate.DayOfWeek } -NoElement
~~~

### Git.Log Example 5


~~~PowerShell
    # Get all logs
    git log |
        # where there is a pull request number
        Where-Object PullRequestNumber |
        # pick out the PullRequestNumber and CommitDate
        Select PullRequestNumber, CommitDate
~~~

### Git.Log Example 6


~~~PowerShell
    git log --merges
~~~

### Git.Mv Example 1


~~~PowerShell
    git mv .\OldName.txt .\NewName.txt
~~~

### Git.Mv Example 2


~~~PowerShell
    git mv .\OldName.txt .\NewName.txt --verbose
~~~

### Git.Pull Example 1


~~~PowerShell
    git pull
~~~

### Git.Push Example 1


~~~PowerShell
    git push
~~~

### Git.RefLog Example 1


~~~PowerShell
    git reflog
~~~

### Git.Rm Example 1


~~~PowerShell
    git rm .\FileIDontCareAbout.txt
~~~

### Git.Shortlog Example 1


~~~PowerShell
    git shortlog  # Get a shortlog
~~~

### Git.Shortlog Example 2


~~~PowerShell
    git shortlog --email # Get a shortlog with email information
~~~

### Git.Shortlog Example 3


~~~PowerShell
    git shortlog --summary # Get a shortlog summary
~~~

### Git.Shortlog Example 4


~~~PowerShell
    git shortlog --sumary --email # Get a shortlog summary, with email.
~~~

### Git.Stash Example 1


~~~PowerShell
    git stash list
~~~

### Git.Status Example 1


~~~PowerShell
    git status
~~~

### Git.Status Example 2


~~~PowerShell
    git status | Select-Object -ExpandProperty Untracked
~~~




