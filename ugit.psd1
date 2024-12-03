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
## ugit 0.4.5:

> Like It? [Star It](https://github.com/StartAutomating/ugit)
> Love It? [Support It](https://github.com/sponsors/StartAutomating)

* git improvements
  * `git clone`
    * git clone -Since improvements (#276)
    * git clone -Since time period (#277)
  * `git log`
    * git.log.Trailer (#305)
    * git.log.Description (#304)
    * git.log.Scope (#303)
    * git.log.CommitType (#301)
    * git.log.CommitDate (#309)
    * git.log.Change(s) (#306)
    * git.log.note(s) (#296)
    * git log accumulation improvement (#308)
    * git log parsing improvement (#306,#308,#309)
    * git.log.JiraTicket(s) (#313)
    * git log -TicketNumber(s) (#315)
  * `git commit`
    * git commit -OnBehalfOf (#275)
    * git commit -CoAuthoredBy (#274)
    * git commit -SkipCI (#320)
* Container improvements
  * Container.init.ps1 (#279,#280)
  * Container.start.ps1 (#281)
  * Container.stop.ps1 (#282)
* Action improvements
  * Refactoring ugit action (#289,#290)
  * Testing action in branch (#288)
  * New Parameters:
    * `ActionScript` (#311)
    * `GitHubToken` (#317)
    * `NoCommit` (#318)
    * `NoPush` (#319)
    * `TargetBranch` (#316)
* Workflow improvements
  * Fixing ugit workflow PublishTestResults (#287)
  * GitPub cleanup (#310)
* New Examples:
  * ChangesByCommitType example (#302, #301)
  * ChangesByDayOfWeek example (#295)
  * ChangesByIssueNumber example (#294)
  * ChangesByUserName example (#293)
  * ChangesByExtension example (#292)
  * ReleaseNotes Example (#307)
  * TableOfCurrentBranch example (#291)

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
