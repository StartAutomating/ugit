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
#### EXAMPLE 1
```PowerShell
# Log entries are returned as objects, with properties and methods.
git log -n 1 | Get-Member
```

#### EXAMPLE 2
```PowerShell
# Status entries are converted into objects.
git status
```

#### EXAMPLE 3
```PowerShell
# Display untracked files.
git status | Select-Object -ExpandProperty Untracked
```

#### EXAMPLE 4
```PowerShell
# Display the list of branches, as objects.
git branch
```

---
### Parameters
#### **GitOutputLine**

One or more output lines from Git.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **GitArgument**

The arguments that were passed to git.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **GitRoot**

The root of the current git repository.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **TimeStamp**

The timestamp.   This can be used for tracking.  Defaults to [DateTime]::Now



> **Type**: ```[DateTime]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Out-Git [-GitOutputLine <String[]>] [-GitArgument <String[]>] [-GitRoot <String>] [-TimeStamp <DateTime>] [<CommonParameters>]
```
---
### Notes
Out-Git will generate two events upon completion.  They will have the source identifiers of "Out-Git" and "Out-Git $GitArgument"
