# ugit
Updated Git: A powerful PowerShell wrapper for git that lets you extend git, automate multiple repos, and output git as objects.


## What is ugit?

ugit is a PowerShell module that gives you an updated git.  You can use the object pipeline to pipe folders or files into git.  
If you're using one of a number of supported commands, ugit will return your git output as objects.
This enables _a lot_ of interesting scenarios, giving you and updated way to work with git.

## Getting start

### Installing ugit
~~~PowerShell
Install-Module ugit -Scope CurrentUser
Import-Module ugit -Force -PassThru
# Once you've imported ugit, just run git commands normally.
# If ugit has an extension for the command, it will output as an object.
# These objects can be formatted by PowerShell
git log -n 5 

git log -n 5 |
  Get-Member
~~~







