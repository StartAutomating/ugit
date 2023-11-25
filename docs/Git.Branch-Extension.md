Extensions/Git.Branch.UGit.Extension.ps1
----------------------------------------

### Synopsis
git branch extension

---

### Description

Outputs git branch as objects (unless, -m, -c, -column, -format, or -show-current are passed)

---

### Examples
> EXAMPLE 1

```PowerShell
git branch  # Get a list of branches
```
> EXAMPLE 2

```PowerShell
git branch |                                          # Get all branches
    Where-Object -Not IsCurrentBranch |               # where it is not the current branch
    Where-Object BranchName -NotIn 'main', 'master' | # and the name is not either main or master
    git branch -d                                     # then attempt to delete the branch.
```

---

### Outputs
* git.branch

* git.branch.deleted

* git.branch.detail

---

### Syntax
```PowerShell
Extensions/Git.Branch.UGit.Extension.ps1 [<CommonParameters>]
```
