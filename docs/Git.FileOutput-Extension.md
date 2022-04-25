
Extensions/Git.FileOutput.UGit.Extension.ps1
--------------------------------------------
### Synopsis
Git FileOutput Extension

---
### Description

This extension runs on any command that includes the argument -o, followed by a single space.

When the command is finished, this will attempt to file the argument provided after -o, and return it as a file.

---
### Examples
#### EXAMPLE 1
```PowerShell
git archive -o My.zip
```
It's an extension for Out-Git
---
### Syntax
```PowerShell
Extensions/Git.FileOutput.UGit.Extension.ps1 [<CommonParameters>]
```
---


