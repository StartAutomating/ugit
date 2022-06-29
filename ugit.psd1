@{
    ModuleVersion    = '0.2.2'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022 Start-Automating'    
    CompanyName      = 'Start-Automating'
    Description      = 'ugit:  Updated Git.

A powerful PowerShell wrapper for git that lets you extend git, automate multiple repos, and use the object pipeline.'
PrivateData   = @{
    PSData    = @{
        Tags       = 'PowerShell', 'git'
        ProjectURI = 'https://github.com/StartAutomating/ugit'
        LicenseURI = 'https://github.com/StartAutomating/ugit/blob/main/LICENSE'
        ReleaseNotes = @'
## 0.2.2:
* Outputting hints as warnings (#56)
* Improved support for git pull (#57)
* Auto-building depedencies (#58)
* Consolidating CI/CD (#59)
---
## 0.2.1:
* Adding support for git shortlog (#48)
* Adding .GitRoot to git reflog (#53)
* Extension documentation cleanup (#54)
---

## 0.2.0:
* Adding support for git reflog (#51)
---

## 0.1.9.1:
* Fixing git status duplicate message (#49)
---
## 0.1.9:
* Support for eventing (#42)
* Autogeneration of docs (#43)
* Autogeneration of formatting (#44)
* Fixing git status formatting (#45)
---

## 0.1.8:
* Adding Support for git checkout (#38)
* Use-Git:  Avoiding unwanted confirmation ( Fixing #39 )
---

## 0.1.7:
* Use-Git: -Verbose no longer infers --verbose (#10)
* Out-Git: Support for extension caching (#35)
* Out-Git: Using -ErrorAction Ignore when -Verbose is not passed (#36)
* Get-UGitExtension:  Updating Piecemeal Version [0.2.1].  (Re #32 #36)
---

## 0.1.6
* Adding support / formatting for git pull (#26)
* Out-Git:  Extension Improvements (#33)
---

## 0.1.5
* Adding git.log .Checkout() and Revert() (#27, #28)
* Fixing formatting for git diff (#25)
* Out-Git:  Adding History (#30)
* Use-Git:  SupportsShouldProcess (#29)
---
## 0.1.4
* Adding git.log.reset() (#20)
* Adding git clone extension (#17)
* Use-Git:  Running certain git commands when there is no repo (currently clone and init)
* Use-Git:  Support for progress bars (#18).  Warning when repo not found (#21)
* git branch extension:  Adding example
* Highlighting branch name (fixing #19)
---
## 0.1.3
* Updating git.log extension:  Adding .Merged (#16)
* Updating git push extension:  Support for first push (#14)
* Adding .output to automatic typenames (Fixing #11)
* Adding .ToString to git.branch and git.branch.detail (#9)
* Updating git branch extension:  Fixing --delete behavior (#13)
* Use-Git:  Support for -d/-D/-v/-V (#12).  -Verbose implies --verbose (#10)
---
## 0.1.2
* Support for git push (#7)
* Adding .Amend/.UpdateMessage to git.commit.info (#6)
---
## 0.1.1
* Support for git commit (#4)
---
## 0.1
* Initial Release of ugit
---
'@
    }
}
}