
Extensions/Git.Log.UGit.Extension.ps1
-------------------------------------
### Synopsis
Log Extension

---
### Description

Outputs git log entries as objects

---
### Examples
#### EXAMPLE 1
```PowerShell
git log | Group-Object GitUserEmail -NoElement | Sort-Object Count -Descending
```

#### EXAMPLE 2
```PowerShell
git log | Where-Object -Not Merged
```

#### EXAMPLE 3
```PowerShell
git log | Group-Object { $_.CommitDate.DayOfWeek } -NoElement
```

---
### Syntax
```PowerShell
Extensions/Git.Log.UGit.Extension.ps1 [<CommonParameters>]
```
---


