@{
    ModuleVersion    = '0.4.1'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022-2023 Start-Automating'    
    CompanyName      = 'Start-Automating'
    Description      = 'ugit:  Updated Git.

A powerful PowerShell wrapper for git that lets you extend git, automate multiple repos, and use the object pipeline.'
PrivateData   = @{
    PSData    = @{
        Tags       = 'PowerShell', 'git'
        ProjectURI = 'https://github.com/StartAutomating/ugit'
        LicenseURI = 'https://github.com/StartAutomating/ugit/blob/main/LICENSE'
        BuildModule  = @('EZOut', 'Piecemeal', 'PipeScript', 'PSSVG')
        ReleaseNotes = @'
## 0.4.1:

* New Git Command Support:
  * git submodule status (#183)
* New Git ScriptMethods:
  * git.branch.diff (#187)
  * git.branch.rename (#86)
* Easier Input:
  * git commit -CommitDate (#184)
  * git log -CurrentBranch (fixing forks, #179)
* Announcing Releases with [PSA](https://github.com/StartAutomating/PSA)

---

Additional Changes in [Changelog](/CHANGELOG.md)
Like It?  Start It.  Love It?  Support It.
https://github.com/StartAutomating/ugit

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