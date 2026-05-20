Get-GitFunction
---------------

### Synopsis
Gets Git Functions

---

### Description

Gets git functions.

Gets any functions or aliases named git.*

---

### Examples
> EXAMPLE 1

```PowerShell
function git.hello.world {
    "hello world"
}
git hello world
```
> EXAMPLE 2

```PowerShell
function git.last.time {
    git log -n 1 | 
        Select-Object -ExpandProperty CommitDate
}
git last time
```
> EXAMPLE 3

function git.last.year {
    param(
    $Then = [DateTime]::Now.AddYears(-1),
    $Now = [DateTime]::Now,            
    )
git log -Since $Then -Before $now
}
git last year

---

### Notes
These functions may be called directly.

They will be called when ugit matches the longest valid name.

This returns an enumerable.

New commands can be found by iterating over the output.

---

### Syntax
```PowerShell
Get-GitFunction [<CommonParameters>]
```
