@{
    ModuleVersion    = '0.4.5.1'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022-2024 Start-Automating'
    CompanyName      = 'Start-Automating'
    Description      = 'ugit: git, updated with PowerShell'
PrivateData   = @{
    PSData    = @{
        Tags       = 'PowerShell', 'git'
        ProjectURI = 'https://github.com/StartAutomating/ugit'
        LicenseURI = 'https://github.com/StartAutomating/ugit/blob/main/LICENSE'
        BuildModule  = @('EZOut', 'Piecemeal', 'PipeScript', 'PSSVG')
        ReleaseNotes = @'
## ugit 0.4.5.1:

> Like It? [Star It](https://github.com/StartAutomating/ugit)
> Love It? [Support It](https://github.com/sponsors/StartAutomating)

* `git log` fix duplicate commit issue ( #334 )
* Thanks @ninmonkey !
---

Additional Changes in [Changelog](https://github.com/StartAutomating/ugit/blob/main/CHANGELOG.md)
'@
        Taglines = @(
            "I've got to admit it's gitting better, gitting better all the time:"
            "Somehow, someway, I keep coming up with funky git nearly every single day:"
            "#git in the #PowerShell object pipeline!"
            "Get your git together!"
            "Put this git in your pipe and smoke it!"
            "I promise you, git gets better"
            "Git ahead of the game!"
        )
    }
}
}
