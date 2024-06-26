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

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|

#### **NewBranchName**
The name of a new branch

|Type      |Required|Position|PipelineInput        |Aliases          |
|----------|--------|--------|---------------------|-----------------|
|`[String]`|false   |named   |true (ByPropertyName)|New<br/>NewBranch|

#### **ResetBranchName**
The name of a branch to reset.

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[String]`|false   |named   |true (ByPropertyName)|ResetBranch|

#### **ResetPath**
One or more specific paths to reset.
This will overwrite the contents of the files with the contents of the index.

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Reset  |

#### **FromBranch**
The name of the branch to checkout from.
This is only used when the -ResetPath parameter is provided.
It defaults to `HEAD`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **RevisionNumber**
The revision number to checkout.
This is only used when the -ResetPath parameter is provided.
If provided, this will checkout the Nth most recent parent.
Eg. HEAD~2

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|

#### **ParentNumber**
The pattern number to checkout.
This is only used when the -ResetPath parameter is provided.
If provided, this will checkout the Nth most recent parent.
Eg. HEAD^2

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|

#### **Detach**
If set, will checkout a branch in a detached state.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Extensions/Git.Checkout.Input.Ugit.Extension.ps1 [-BranchName <String>] [-PullRequest <Int32>] [-NewBranchName <String>] [-ResetBranchName <String>] [-ResetPath <String[]>] [-FromBranch <String>] [-RevisionNumber <Int32>] [-ParentNumber <Int32>] [-Detach] [<CommonParameters>]
```
