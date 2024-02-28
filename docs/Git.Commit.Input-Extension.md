Extensions/Git.Commit.Input.UGit.Extension.ps1
----------------------------------------------

### Synopsis
Git Commit Input

---

### Description

Makes Git Commit easier to use from PowerShell by providing parameters for the -Message, -Title, -Body, and -Trailers

---

### Examples
> EXAMPLE 1

```PowerShell
git commit -Title "Fixing Something"
```
> EXAMPLE 2

"}

---

### Parameters
#### **Title**
The title of the commit.  If -Message is also provided, this will become part of the -Body

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |named   |false        |Subject|

#### **Message**
The commit message.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Type**
The type of the commit.  This uses the conventional commits format.
https://www.conventionalcommits.org/en/v1.0.0/#specification

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Scope**
The scope of the commit.  This uses the conventional commits format.
https://www.conventionalcommits.org/en/v1.0.0/#specification

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Description**
A description of the commit.  This uses the conventional commits format.
https://www.conventionalcommits.org/en/v1.0.0/#specification

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Footer**
The footer for the commit.  This uses the conventional commits format.
https://www.conventionalcommits.org/en/v1.0.0/#specification

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Body**
The body of the commit.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Trailers**
Any git trailers to add to the commit.
git trailers are key-value pairs you can use to associate metadata with a commit.
As this uses --trailer, this requires git version 2.33 or greater.

|Type           |Required|Position|PipelineInput|Aliases                                   |
|---------------|--------|--------|-------------|------------------------------------------|
|`[IDictionary]`|false   |named   |false        |Trailer<br/>CommitMetadata<br/>GitMetadata|

#### **Amend**
If set, will amend an existing commit.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **CommitDate**
The commit date.

|Type        |Required|Position|PipelineInput        |Aliases                                 |
|------------|--------|--------|---------------------|----------------------------------------|
|`[DateTime]`|false   |named   |true (ByPropertyName)|Date<br/>Time<br/>DateTime<br/>Timestamp|

#### **Fix**
If provided, will mark this commit as a fix.
This will add 'Fixes #...' to your commit message.

|Type        |Required|Position|PipelineInput        |Aliases        |
|------------|--------|--------|---------------------|---------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Fixes<br/>Fixed|

#### **Close**
If provided, will mark this commit as a close.
This will add 'Closes #...' to your commit message.

|Type        |Required|Position|PipelineInput        |Aliases          |
|------------|--------|--------|---------------------|-----------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Closed<br/>Closes|

#### **Resolve**
If provided, will mark this commit as a resolution.
This will add 'Resolves #...' to your commit message.

|Type        |Required|Position|PipelineInput        |Aliases              |
|------------|--------|--------|---------------------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Resolves<br/>Resolved|

#### **Reference**
If provided, will mark this commit as referencing an issue.
This will add 'Re #...' to your commit message.

|Type        |Required|Position|PipelineInput        |Aliases                                               |
|------------|--------|--------|---------------------|------------------------------------------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Re<br/>Regard<br/>Regards<br/>Regarding<br/>References|

---

### Syntax
```PowerShell
Extensions/Git.Commit.Input.UGit.Extension.ps1 [-Title <String>] [-Message <String>] [-Type <String>] [-Scope <String>] [-Description <String>] [-Footer <String>] [-Body <String>] [-Trailers <IDictionary>] [-Amend] [-CommitDate <DateTime>] [-Fix <String[]>] [-Close <String[]>] [-Resolve <String[]>] [-Reference <String[]>] [<CommonParameters>]
```
