@{
    ModuleVersion    = '0.4.4'
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
## ugit 0.4.4:

> Like It? [Star It](https://github.com/StartAutomating/ugit)
> Love It? [Support It](https://github.com/sponsors/StartAutomating)

* ugit a container! (#262, #263, #264)
  * `docker run --interactive --tty ghcr.io/startautomating/ugit`  
* `git checkout` improvements
  * `git checkout -PullRequest [int]` (#178)
  * `git checkout -NewBranchName [string]` (#266)
  * `git checkout -ResetBranchName [string]` (#267)
  * `git checkout -Detach [switch]` (#268)
  * `git checkout -ResetPath [string]` (#269)
  * `git checkout -FromBranch [string]` (#270)
  * `git checkout -RevisionNumber/-ParentNumber [int]` (#271)
* `git sparse-checkout` improvements
  * git sparse-checkout -FileFilter ( Fixes #257 )
  * git sparse-checkout -DirectoryFilter ( Fixes #258 )
* `git branch -Remote` (#185)
* `git config --list` (#265)
* `git --format json` (#239)

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