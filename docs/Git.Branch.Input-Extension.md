Extensions/Git.Branch.Input.Ugit.Extension.ps1
----------------------------------------------

### Synopsis
git branch input extension

---

### Description

Extends the parameters for git branch, making it easier to use from PowerShell.

---

### Examples
> EXAMPLE 1

```PowerShell
git branch -Remote
```

---

### Parameters
#### **Remote**
If set, will add the --remote flag to the command.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|false   |named   |true (ByPropertyName)|Remotes|

---

### Syntax
```PowerShell
Extensions/Git.Branch.Input.Ugit.Extension.ps1 [-Remote] [<CommonParameters>]
```
