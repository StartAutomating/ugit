@{
    ModuleVersion    = '0.1.4'
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
