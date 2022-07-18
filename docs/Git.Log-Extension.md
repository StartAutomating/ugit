
Extensions/Git.Log.UGit.Extension.ps1
-------------------------------------
### Synopsis
Log Extension

---
### Description

Outputs git log as objects.

---
### Examples
#### EXAMPLE 1
```PowerShell
# Get all logs
git log | 
    # until the first merged pull request
    Where-Object -Not Merged
```

#### EXAMPLE 2
```PowerShell
# Get a single log entry
git log -n 1 | 
    # and see what the log object can do.
    Get-Member
```

#### EXAMPLE 3
```PowerShell
# Get all logs
git log |
    # Group them by the author
    Group-Object GitUserEmail -NoElement |
    # sort them by count
    Sort-Object Count -Descending
```

#### EXAMPLE 4
```PowerShell
# Get all logs
git log |
    # Group them by day of week 
    Group-Object { $_.CommitDate.DayOfWeek } -NoElement
```

#### EXAMPLE 5
```PowerShell
# Get all logs
git log |
    # where there is a pull request number
    Where-Object PullRequestNumber |
    # pick out the PullRequestNumber and CommitDate
    Select PullRequestNumber, CommitDate
```

#### EXAMPLE 6
```PowerShell
git log --merges
```

---
### Syntax
```PowerShell
Extensions/Git.Log.UGit.Extension.ps1 [<CommonParameters>]
```
---


