@{
    ModuleVersion    = '0.1'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022 Start-Automating'    
    CompanyName      = 'Start-Automating'
    Description      = 'uGit:  Updated Git.

A powerful PowerShell wrapper for git that lets you extend git, automate multiple repos, and use the object pipeline.'
PrivateData   = @{
    PSData    = @{
        Tags       = 'PowerShell', 'git'
        ProjectURI = 'https://github.com/StartAutomating/ugit'
        LicenseURI = 'https://github.com/StartAutomating/ugit/blob/main/LICENSE'
        ReleaseNotes = @'
## 0.1
* Initial Release of ugit
---
'@
    }
}
}
