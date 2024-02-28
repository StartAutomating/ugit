Extensions/Git.Format.Simple.ugit.extension.ps1
-----------------------------------------------

### Synopsis
git simple format

---

### Description

Parses the output of git format, if the results are a series of simple delimited fields

---

### Examples
> EXAMPLE 1

```PowerShell
git branch --format "%(refname:short)|%(objectname)|%(parent)|%(committerdate:iso8601)|%(objecttype)"
```

---

### Syntax
```PowerShell
Extensions/Git.Format.Simple.ugit.extension.ps1 [<CommonParameters>]
```
