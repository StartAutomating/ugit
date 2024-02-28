@{
    ModuleVersion    = '0.4.3'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022-2024 Start-Automating'    
    CompanyName      = 'Start-Automating'
    Description      = 'ugit: Updated Git.  Git gets better with PowerShell and the Object Pipeline.

ugit is a powerful PowerShell wrapper for git that lets you extend git, automate multiple repos, and use the object pipeline.
'
PrivateData   = @{
    PSData    = @{
        Tags       = 'PowerShell', 'git'
        ProjectURI = 'https://github.com/StartAutomating/ugit'
        LicenseURI = 'https://github.com/StartAutomating/ugit/blob/main/LICENSE'
        BuildModule  = @('EZOut', 'Piecemeal', 'PipeScript', 'PSSVG')
        ReleaseNotes = @'
## ugit 0.4.3:

* Cloning Improvements:
    * git clone -Depth (#219)
    * git clone -Sparse (#220)
    * git clone -NoCheckout (#221)
    * git clone -Since (#224)
    * git clone -Nothing (#229)
    * git clone now handles gitless urls (#223)
* Commit Improvements:
    * Conventional Commit Support
    * Improving git commit -Type tab completion (#197)
    * git commit -Title will become description if -Type is passed (#225)
    * git.Conventional.Commit pseudotype (#250,#251,#252, #253, #254)  
    * git commit -Fix (#226)
    * git commit -Reference (#227)
* Decorating errors and output for better experience (#228)
* Adding some helpful script properties:
    * git.output.NotGitCommand (#236)
    * git.merge.error.Conflict (#235)  
    * git.pull.error.Conflict (#234)
    * git.error.UnknownRevision (#232)  
* Fixes:
    * Improving Use-Git dynamic alias support (#231)
* Consolidating Repo structure (#240, #241, #242, #243)
* Module Improvements:
    * Exporting `$ugit` (#247)
    * Mounting module to `ugit:` (#246)
    * Mounting `$home/Myugit` to `Myugit:` (if present) (#246)

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