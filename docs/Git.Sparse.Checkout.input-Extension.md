Extensions/Git.Sparse.Checkout.input.ugit.extension.ps1
-------------------------------------------------------

### Synopsis
git sparse-checkout input extension

---

### Description

Extends the parameters for git sparse-checkout, making it easier to use from PowerShell.

---

### Examples
> EXAMPLE 1

```PowerShell
git sparse-checkout -FileFilters *.ps1,*.psm1
```

---

### Parameters
#### **FileFilter**
The list of file filters to use.
Filters that start with * or *. will be converted to **.

|Type        |Required|Position|PipelineInput        |Aliases    |
|------------|--------|--------|---------------------|-----------|
|`[String[]]`|false   |named   |true (ByPropertyName)|FileFilters|

#### **DirectoryFilter**
The list of directory filters to use
If provided with a file filter, the directory filter will be used as a parent directory filter.

|Type        |Required|Position|PipelineInput        |Aliases         |
|------------|--------|--------|---------------------|----------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|DirectoryFilters|

---

### Syntax
```PowerShell
Extensions/Git.Sparse.Checkout.input.ugit.extension.ps1 [-FileFilter <String[]>] [-DirectoryFilter <String[]>] [<CommonParameters>]
```
