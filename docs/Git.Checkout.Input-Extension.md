Extensions/Git.Checkout.Input.Ugit.Extension.ps1
------------------------------------------------

### Synopsis
git checkout input extension

---

### Description

Extends the parameters for git checkout, making it easier to use from PowerShell.

If the -PullRequest parameter is provided, the branch will be fetched from the remote.

If the -BranchName parameter is provided, the branch will be checked out.

---

### Parameters
#### **BranchName**
The branch name.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **PullRequest**
The number of the pull request.
If no Branch Name is provided, the branch will be `PR-$PullRequest`.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |

---

### Syntax
```PowerShell
Extensions/Git.Checkout.Input.Ugit.Extension.ps1 [-BranchName <String>] [-PullRequest <Int32>] [<CommonParameters>]
```
