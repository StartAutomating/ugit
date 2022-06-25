
Get-UGitExtension
-----------------
### Synopsis
Gets Extensions

---
### Description

Gets Extensions.

UGitExtension can be found in:

* Any module that includes -UGitExtensionModuleName in it's tags.
* The directory specified in -UGitExtensionPath

---
### Examples
#### EXAMPLE 1
```PowerShell
Get-UGitExtension
```

---
### Parameters
#### **UGitExtensionPath**

If provided, will look beneath a specific path for extensions.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |1      |true (ByPropertyName)|
---
#### **Force**

If set, will clear caches of extensions, forcing a refresh.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **CommandName**

If provided, will get UGitExtension that extend a given command



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |2      |true (ByPropertyName)|
---
#### **UGitExtensionName**

The name of an extension.
By default, this will match any extension command whose name, displayname, or aliases exactly match the name.

If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -UGitExtensionName will be valid if that regular expression matches.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |3      |true (ByPropertyName)|
---
#### **Like**

If provided, will treat -UGitExtensionName as a wildcard.
This will return any extension whose name, displayname, or aliases are like the -UGitExtensionName.

If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -UGitExtensionName will be valid if that regular expression matches.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Match**

If provided, will treat -UGitExtensionName as a regular expression.
This will return any extension whose name, displayname, or aliases match the -UGitExtensionName.

If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -UGitExtensionName will be valid if that regular expression matches.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **DynamicParameter**

If set, will return the dynamic parameters object of all the UGitExtension for a given command.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **CouldRun**

If set, will return if the extension could run.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **CouldPipe**

If set, will return if the extension could accept this input from the pipeline.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[PSObject]```|false   |4      |false        |
---
#### **Run**

If set, will run the extension.  If -Stream is passed, results will be directly returned.
By default, extension results are wrapped in a return object.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Stream**

If set, will stream output from running the extension.
By default, extension results are wrapped in a return object.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **DynamicParameterSetName**

If set, will return the dynamic parameters of all UGitExtension for a given command, using the provided DynamicParameterSetName.
Implies -DynamicParameter.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |5      |true (ByPropertyName)|
---
#### **DynamicParameterPositionOffset**

If provided, will return the dynamic parameters of all UGitExtension for a given command, with all positional parameters offset.
Implies -DynamicParameter.



|Type         |Requried|Postion|PipelineInput        |
|-------------|--------|-------|---------------------|
|```[Int32]```|false   |6      |true (ByPropertyName)|
---
#### **NoMandatoryDynamicParameter**

If set, will return the dynamic parameters of all UGitExtension for a given command, with all mandatory parameters marked as optional.
Implies -DynamicParameter.  Does not actually prevent the parameter from being Mandatory on the Extension.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **ValidateInput**

If set, will validate this input against [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |7      |true (ByPropertyName)|
---
#### **AllValid**

If set, will validate this input against all [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.
By default, if any validation attribute returned true, the extension is considered validated.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **ParameterSetName**

The name of the parameter set.  This is used by -CouldRun and -Run to enforce a single specific parameter set.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |8      |true (ByPropertyName)|
---
#### **Parameter**

The parameters to the extension.  Only used when determining if the extension -CouldRun.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |9      |true (ByPropertyName)|
---
#### **SteppablePipeline**

If set, will output a steppable pipeline for the extension.
Steppable pipelines allow you to control how begin, process, and end are executed in an extension.
This allows for the execution of more than one extension at a time.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Help**

If set, will output the help for the extensions



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **ParameterHelp**

If set, will get help about one or more parameters of an extension



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |10     |false        |
---
#### **Example**

If set, will get help examples



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **FullHelp**

If set, will output the full help for the extensions



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Outputs
Extension


---
### Syntax
```PowerShell
Get-UGitExtension [[-UGitExtensionPath] <String>] [-Force] [[-CommandName] <String[]>] [[-UGitExtensionName] <String[]>] [-Like] [-Match] [-DynamicParameter] [-CouldRun] [[-CouldPipe] <PSObject>] [-Run] [-Stream] [[-DynamicParameterSetName] <String>] [[-DynamicParameterPositionOffset] <Int32>] [-NoMandatoryDynamicParameter] [[-ValidateInput] <PSObject>] [-AllValid] [[-ParameterSetName] <String>] [[-Parameter] <IDictionary>] [-SteppablePipeline] [-Help] [[-ParameterHelp] <String[]>] [-Example] [-FullHelp] [<CommonParameters>]
```
---


