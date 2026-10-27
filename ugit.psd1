@{
    ModuleVersion    = '0.4.7'
    RootModule       = 'ugit.psm1'
    FormatsToProcess = 'ugit.format.ps1xml'
    TypesToProcess   = 'ugit.types.ps1xml'
    Guid             = '32323806-1d4a-485b-a64b-c502b0468847'
    Author           = 'James Brundage'
    Copyright        = '2022-2026 Start-Automating'
    CompanyName      = 'Start-Automating'
    Description      = 'ugit: git, updated with PowerShell'

    FunctionsToExport = @(
        'Get-UGitExtension','Use-Git','Out-Git',
        
        'Get-GitFunction'

        'Get-GitOctal'

        'Get-GitPrompt'
    )

    AliasesToExport   = @(
        'git', 'gitreal', 'realgit', 
        
        'gitFunction', 'gitFunctions',
            'git.func', 'git.function', 'git.functions',
            'git.octal', 'git.prompt'
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

## ugit 0.4.7

* `git status` improvement
  * `git.status.ahead` (#358)
  * `git.status.behind` (#359)
  * `git.status.modified` (#356)
  * `git.status.deleted` (#357)
  * `git.status.addded` (#361)
  * `git.status` formatting improvement (#363)
  * `git.status.WorkingDirectory` (#365)
  * `git.status.Unmerged` (#367)
  * `git.status.Diff` (#364)
  * `git status --short` support (#343)
  * Performance and fault tolerance (#366)
* Removing IO.FileInfo extended properties (#369)
* Internationalization support (#177)
* New Functions:
  * `Get-GitPrompt` (#368)
  * `Get-GitOctal` (#370)

To use the new prompt, you can simply:

Set-Alias prompt git.prompt

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
