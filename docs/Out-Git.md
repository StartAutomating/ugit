Out-Git
-------

### Synopsis
Outputs Git to PowerShell

---

### Description

Outputs Git as PowerShell Objects.

Git Output can be provided by any number of extensions to Out-Git.

Extensions use two attributes to indicate if they should be run:

~~~PowerShell
[Management.Automation.Cmdlet("Out","Git")] # This signals that this is an extension for Out-Git
[ValidatePattern("RegularExpression")]      # This is run on $GitCommand to determine if the extension should run.
~~~

---

### Related Links
* [Invoke-Git](Invoke-Git.md)

---

### Examples
Log entries are returned as objects, with properties and methods.

```PowerShell
git log -n 1 | Get-Member
```
Status entries are converted into objects.

```PowerShell
git status
```
Display untracked files.

```PowerShell
git status | Select-Object -ExpandProperty Untracked
```
Display the list of branches, as objects.

```PowerShell
git branch
```

---

### Parameters
#### **GitOutputLine**
One or more output lines from Git.

|Type        |Required|Position|PipelineInput |Aliases       |
|------------|--------|--------|--------------|--------------|
|`[String[]]`|false   |named   |true (ByValue)|GitOutputLines|

#### **GitArgument**
The arguments that were passed to git.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **GitRoot**
The root of the current git repository.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **TimeStamp**
The timestamp.   This can be used for tracking.  Defaults to [DateTime]::Now

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[DateTime]`|false   |named   |false        |

---

### Notes
Out-Git will generate two events upon completion.  They will have the source identifiers of "Out-Git" and "Out-Git $GitArgument"

---

### Syntax
```PowerShell
Out-Git [-GitOutputLine <String[]>] [-GitArgument <String[]>] [-GitRoot <String>] [-TimeStamp <DateTime>] [<CommonParameters>]
```
