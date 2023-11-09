Extensions/Git.Clone.Input.UGit.Extension.ps1
---------------------------------------------




### Synopsis
Git Clone extended input



---


### Description

Extends the input for git clone.

By default, if --progress is not found, it will be added to any git clone.



---


### Examples
> EXAMPLE 1

```PowerShell
git clone https://github.com/MDN/content.git # This is a big repo.  Progress bars will be very welcome.
```
If we don't check things out, cloning is faster.

```PowerShell
git clone https://github.com/PowerShell/PowerShell -NoCheckout 
# (of course, that's because we're not copying files, just history)
```
We can also clone more quickly by only picking a certain number of commits

```PowerShell
git clone https://github.com/Microsoft/vscode.git -Depth 1
# (of course, this will make the history lie to you,
# by saying everything was changed whenever anything was changed)
```


---


### Parameters
#### **NoCheckout**

If set, will not check out files from the respository.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



#### **Sparse**

Employ a sparse-checkout.
Only files in the toplevel directory will be present by default.
Sparse checkout can be configured with git sparse-checkout.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



#### **Depth**

Create a shallow clone with a history truncated to the specified number of commits






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[UInt32]`|false   |named   |true (ByPropertyName)|



#### **Since**

Create a shallow clone with a history after the specified time.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[DateTime]`|false   |named   |true (ByPropertyName)|



#### **Filter**

One or more filters






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|





---


### Syntax
```PowerShell
Extensions/Git.Clone.Input.UGit.Extension.ps1 [-NoCheckout] [-Sparse] [-Depth <UInt32>] [-Since <DateTime>] [-Filter <String[]>] [<CommonParameters>]
```
