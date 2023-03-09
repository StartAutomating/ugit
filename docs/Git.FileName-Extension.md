
Extensions/Git.FileName.UGit.Extension.ps1
------------------------------------------




### Synopsis
Git FileName Extension



---


### Description

This extension runs on any command that includes the argument -name-only.

It will attempt to treat each name as a file.

If that fails, it will output a Git.Object.Name.



---


### Examples
#### EXAMPLE 1
```PowerShell
git diff --name-only
```



---


### Outputs
* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)


* Git.FileInfo


* Git.Object.Name






---


### Syntax
```PowerShell
Extensions/Git.FileName.UGit.Extension.ps1 [<CommonParameters>]
```



