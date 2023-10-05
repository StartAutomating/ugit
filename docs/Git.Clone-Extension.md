Extensions/Git.Clone.UGit.Extension.ps1
---------------------------------------




### Synopsis
git clone extension



---


### Description

Clones a repository, and returns the result as an object.



---


### Examples
> EXAMPLE 1

```PowerShell
git clone https://github.com/StartAutomating/ugit.git
```
Clone a large repo.
When --progress is provided, Write-Progress will be called.

```PowerShell
git clone https://github.com/Azure/azure-quickstart-templates --progress
```


---


### Outputs
* git.clone






---


### Syntax
```PowerShell
Extensions/Git.Clone.UGit.Extension.ps1 [<CommonParameters>]
```
