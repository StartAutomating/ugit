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


---


### Parameters
#### **NoCheckout**

If set, will not check out files from the respository.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|





---


### Syntax
```PowerShell
Extensions/Git.Clone.Input.UGit.Extension.ps1 [-NoCheckout] [<CommonParameters>]
```
