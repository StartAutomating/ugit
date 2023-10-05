Extensions/Git.Commit.UGit.Extension.ps1
----------------------------------------




### Synopsis
git commit extension



---


### Description

Returns output from succesful git commits as objects.



---


### Examples
> EXAMPLE 1

```PowerShell
git commit -m "Updating #123"
```
> EXAMPLE 2

```PowerShell
$committedMessage = git commit -m "Committting Stuff" # Whoops, this commit had a typo
$commitMessage.Amend("Committing stuff") # that's better
```


---


### Outputs
* git.commit.info






---


### Syntax
```PowerShell
Extensions/Git.Commit.UGit.Extension.ps1 [<CommonParameters>]
```
