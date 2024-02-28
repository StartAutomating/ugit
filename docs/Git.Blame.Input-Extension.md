Extensions/Git.Blame.Input.ugit.extension.ps1
---------------------------------------------

### Synopsis
Extends git blame's parameters

---

### Description

Extends the parameters for git blame.

---

### Parameters
#### **LineNumber**
The line number (and relative offset)

|Type       |Required|Position|PipelineInput        |
|-----------|--------|--------|---------------------|
|`[Int32[]]`|false   |named   |true (ByPropertyName)|

#### **Pattern**
The blame pattern to look for.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Extensions/Git.Blame.Input.ugit.extension.ps1 [-LineNumber <Int32[]>] [-Pattern <String[]>] [<CommonParameters>]
```
