
Extensions/Git.Clone.UGit.Extension.ps1
---------------------------------------
### Synopsis
git clone extension

---
### Description

Clones a repository, and returns the result as an object.

---
### Examples
#### EXAMPLE 1
```PowerShell
git clone https://github.com/StartAutomating/ugit.git
```

#### EXAMPLE 2
```PowerShell
# Clone a large repo.
# When --progress is provided, Write-Progress will be called.
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
---



