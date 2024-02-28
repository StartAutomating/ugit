Extensions/Git.Log.UGit.Extension.ps1
-------------------------------------

### Synopsis
Log Extension

---

### Description

Outputs git log as objects.

---

### Examples
Get all logs

```PowerShell
git log |
    # until the first merged pull request
    Where-Object -Not Merged
```
Get a single log entry

```PowerShell
git log -n 1 |
    # and see what the log object can do.
    Get-Member
```
Get all logs

```PowerShell
git log |
    # Group them by the author
    Group-Object GitUserEmail -NoElement |
    # sort them by count
    Sort-Object Count -Descending
```
Get all logs

```PowerShell
git log |
    # Group them by day of week
    Group-Object { $_.CommitDate.DayOfWeek } -NoElement
```
Get all logs

```PowerShell
git log |
    # where there is a pull request number
    Where-Object PullRequestNumber |
    # pick out the PullRequestNumber and CommitDate
    Select PullRequestNumber, CommitDate
```
> EXAMPLE 6

```PowerShell
git log --merges
```

---

### Syntax
```PowerShell
Extensions/Git.Log.UGit.Extension.ps1 [<CommonParameters>]
```
