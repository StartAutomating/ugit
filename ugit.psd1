@{
    ModuleVersion    = '0.4.6'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022-2026 Start-Automating'
    CompanyName      = 'Start-Automating'
    Description      = 'ugit: git, updated with PowerShell'

    FunctionsToExport = @(
        'Get-UGitExtension','Use-Git','Out-Git','Get-GitFunction'
    )

    AliasesToExport   = @(
        'git', 'gitreal', 'realgit', 
        
        'gitFunction', 'gitFunctions',
            'git.func', 'git.function', 'git.functions'
    )

    PrivateData   = @{
        PSData    = @{
            Tags       = 'PowerShell', 'git'
            ProjectURI = 'https://github.com/StartAutomating/ugit'
            LicenseURI = 'https://github.com/StartAutomating/ugit/blob/main/LICENSE'
            BuildModule  = @('EZOut', 'Piecemeal', 'PipeScript', 'PSSVG')
            ReleaseNotes = @'
# ugit

* [Repo](https://github.com/StartAutomating/ugit)
* [Issues](https://github.com/StartAutomating/ugit/issues)
* [Discussions](https://github.com/StartAutomating/ugit/discussions/)
* [Website](https://ugit.start-automating.com/)

## ugit 0.4.6:

* Git Functions Support! (#259)
  * Any function or alias named git.* will be considered a git function
  * git functions can be run in ugit implicitly (i.e. `git functions`)
  * git functions can have parameters, accept arguments, and bind from the pipeline.
  * We can get git functions with `Get-GitFunction` (#352)  
* `git worktree list` support (#347)
* git status improvement (#341)
  * Adding color ( Thanks @derekthecool !)
  * Using Green for staged, Red for unstaged, Yellow for Untracked.
* Container Changes
  * Fixing requirements (#348)
  * Using DotNet SDK as base (#349)
* Workflow updates (#350)
  * Updating upload-artifact
  * Removing PSA from build
* Minor Updates
  * `ugit.Piecemeal.ps1` now #requires Piecemeal (#344, Thanks @ninmonkey !)
  * Community Guides (#329,#330,#331)

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
