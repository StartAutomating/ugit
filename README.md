# ugit
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

* git branch
* git commit
* git clone
* git diff
* git log
* git push
* git pull
* git status


### Extensions that may apply to any git command:

* git.fileoutput

This applies to an git command that uses the -o flag.
It will attempt to locate any output specified by -o and return it as a file or directory.
