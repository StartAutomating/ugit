Extensions/Git.Format.Json.ugit.extension.ps1
---------------------------------------------

### Synopsis
git json format

---

### Description

Parses the output of git format, if the results are a series of json objects

---

### Examples
> EXAMPLE 1

```PowerShell
git branch --format "{'ref':'%(refname:short)','parent':'%(parent)'}"
```

---

### Syntax
```PowerShell
Extensions/Git.Format.Json.ugit.extension.ps1 [<CommonParameters>]
```
