Extensions/Git.Status.UGit.Extension.ps1
----------------------------------------

### Synopsis
git status extension

---

### Description

Returns git status as an object.

git status provides a lot of useful information.

---

### Examples
Get the status of the current repository

```PowerShell
git status
```
Get the untracked files

```PowerShell
git status |
    Select-Object -ExpandProperty Untracked
```
Get the status of the repo in the current directory

```PowerShell
git status .
```
Get untracked files in the current directory

```PowerShell
git status . |
    Select-Object -ExpandProperty Untracked
```
See all git status can do

```PowerShell
git status |
    Get-Member
```
We can also git status --short

```PowerShell
git status --short
```
We can also ask for short status with a branch summary

```PowerShell
git status --short --branch
```
We can use the shortform `-sb`

```PowerShell
git status -sb
```

---

### Syntax
```PowerShell
Extensions/Git.Status.UGit.Extension.ps1 [<CommonParameters>]
```
