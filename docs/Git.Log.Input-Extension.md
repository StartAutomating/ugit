Extensions/Git.Log.Input.UGit.Extension.ps1
-------------------------------------------

### Synopsis
git log input

---

### Description

Extends the parameters for git log, making it easier to use from PowerShell.

Allows timeframe parameters to be tab-completed:
* After/Since become --after
* Before/Until become --before
* Author/Committer become --author

Adds -CurrentBranch, which gives the changes between the upstream branch and the current branch.

Also adds -IssueNumber, which searchers for commits that reference particular issues.

---

### Examples
> EXAMPLE 1

```PowerShell
git log -CurrentBranch
```

---

### Parameters
#### **NumberOfCommits**
The number of entries to get.

|Type     |Required|Position|PipelineInput|Aliases                      |
|---------|--------|--------|-------------|-----------------------------|
|`[Int32]`|false   |named   |false        |CommitNumber<br/>N<br/>Number|

#### **After**
Gets logs after a given date

|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[DateTime]`|false   |named   |false        |Since  |

#### **Before**
Gets before a given date

|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[DateTime]`|false   |named   |false        |Until  |

#### **Author**
Gets lof from a given author or committer

|Type      |Required|Position|PipelineInput|Aliases  |
|----------|--------|--------|-------------|---------|
|`[String]`|false   |named   |false        |Committer|

#### **CurrentBranch**
If set, will get all changes between the upstream branch and the current branch.

|Type      |Required|Position|PipelineInput|Aliases                     |
|----------|--------|--------|-------------|----------------------------|
|`[Switch]`|false   |named   |false        |UpstreamDelta<br/>ThisBranch|

#### **IssueNumber**
One or more issue numbers.  Providing an issue number of 0 will find all log entries that reference an issue.

|Type       |Required|Position|PipelineInput        |Aliases                                                                             |
|-----------|--------|--------|---------------------|------------------------------------------------------------------------------------|
|`[Int32[]]`|false   |named   |true (ByPropertyName)|ReferenceNumbers<br/>ReferenceNumber<br/>IssueNumbers<br/>WorkItemID<br/>WorkItemIDs|

#### **Statistics**
If set, will get statistics associated with each change

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Stat   |

#### **SearchString**
If provided, will search for specific strings within the change sets of a commit.
This is especially useful when finding references to or changes to a given function or structure.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Search |

#### **SearchPattern**
If provided, will search for specific patterns within the change sets of a commit.
This is especially useful when finding references to or changes to a given function or structure.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Pattern|

---

### Syntax
```PowerShell
Extensions/Git.Log.Input.UGit.Extension.ps1 [-NumberOfCommits <Int32>] [-After <DateTime>] [-Before <DateTime>] [-Author <String>] [-CurrentBranch] [-IssueNumber <Int32[]>] [-Statistics] [-SearchString <String>] [-SearchPattern <String>] [<CommonParameters>]
```
