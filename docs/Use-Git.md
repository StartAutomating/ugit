Use-Git
-------




### Synopsis
Use Git



---


### Description

Calls the git application, with whatever arguments are provided.

Arguments can be provided with -GitArgument, which will automatically be bound to all parameters provided without a name.        

Input can also be piped in.

If the input is a directory, Use-Git will Push-Location that directory.
Otherwise, it will be passed as a positional argument (after any other arguments).

Use-Git will combine errors and output, so that git output to standard error is handled without difficulty.



---


### Related Links
* [Out-Git](Out-Git.md)





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
#### **GitArgument**

Any arguments passed to git.  All positional arguments will automatically be passed to -GitArgument.






|Type        |Required|Position|PipelineInput|Aliases     |
|------------|--------|--------|-------------|------------|
|`[String[]]`|false   |named   |false        |GitArguments|



#### **InputObject**

An optional input object.
If the Input is a directory, Use-Git will Push-Location to that directory
Otherwise, it will be passed as a postional argument (after any other arguments)






|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|false   |named   |true (ByValue)|



#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.


If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.



---


### Notes
Use-Git will generate two events before git runs.  They will have the source identifiers of "Use-Git" and "Use-Git $GitArgument"



---


### Syntax
```PowerShell
Use-Git [-GitArgument <String[]>] [-InputObject <PSObject[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
