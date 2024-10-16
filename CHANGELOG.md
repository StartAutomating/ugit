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

## ugit 0.4.4:

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
  * `git sparse-checkout -FileFilter [string[]]` (#257)
  * `git sparse-checkout -DirectoryFilter [string[]]` (#258)
* `git branch -Remote [switch]` (#185)
* `git config --list` outputs as objects (#265)
* `git --format json` outputs as objects (#239)

---

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

## ugit 0.4.2:

* git blame support (#192, #193, #199, #201)
* Use-Git will write to Verbose, not warning, when a directory is not a repository (#198, #204)
* ugit PSA improvements (#189, #205, #206, #207)

---

## ugit 0.4.1:

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

## ugit 0.4:

* Adding Sponsorship! (#174)
* RealGit / GitReal will opt-out of ugit (#173)
* Added git.commit.info.psuh (#111)
* Fixing directory piping (#172)
* Git Clone allows absolute paths (#169, thanks @corbob)
* Fixing Git Log -Statistics (#171)
* Not Mapping Partial Dynamic Parameters (#168)

--

## ugit 0.3.9:

* Adding ugit demo (Fixes #163)
* Use-Git: Improving -Confirm (Fixes #165) and -WhatIf (Fixes #162)
* git.log.input
  * Adding -NumberOfCommits (#161/#156)
  * Adding -SearchPattern (Fixes #158)
  * Adding -SearchString (Fixes #157)
  * Adding -Statistics (Fixes #155)
* Adding git.branch IsTracked (Fixes #160)
* Extending FileInfo for better git results (Fixes #153) (thanks @ninmonkey)
* Adding ugit.extension formatting (Fixes #164)
* git log formatting - right-aligning CommitMessage (Fixes #152) (thanks @ninmonkey)
* git log .diff FileChange fix (Fixes #151)
* Git Diff ChangeSet Formatting Fix (Fixes #150)
* Updating workflow (Using GitLogger)

---

## ugit 0.3.8:

* Use-Git can now be extended (#140, #97), letting you add PowerShell parameters to any git command
* Initial input extensions
  * git.clone.input (#141) (--progress is inferred so Write-Progress happens automagically)
  * git.log.input (#142) (Added -Before/-After/-Author/-CurrentBranch)
  * git.commit.input (#144) (Added -Message/-Body/-Title/-Trailer)
* Other Improvements:
  * git log will not process --pretty/--format (Fixes #143)
  * git log now supports .Trailers (Fixes #112)
  * git remote formatting improved (Fixes #145)
  * git remote now works for multiple remotes (Fixes #136)
  * Updated logo (#139)

---

## ugit 0.3.7:

* git remote
 * Now supporting git remote! (Fixes #129)

~~~PowerShell
git remote | git remote show
~~~

Also, some improvements to the GitHub Action:

* Icon Update (Fixes #132)
* No longer using set-output (Fixes #131)
* Adding -InstallModule to Action (Fixes #132)

---

## ugit 0.3.6:

* git log
  * Supporting --stat (Fixes #123)
  * Supporting --shortstat (Fixes #102)
  * Adding .GitOutputLines (Fixes #122)
* git diff 
  * Fixing subdirectory issue (Fixes #121)

---

## ugit 0.3.5:

* Use-Git:  Fixing pipeline behavior for non-file input (Fixes #119)
* Git.log: Attaching .GitCommand, not .GitArgument (Fixes #118)
* Git.mv: Reducing liklihood of errors in directory moves (Fixes #117)

---

## ugit 0.3.4:

* Improving pipeling behavior (Fixes #110)
* Adding tests for pipelining

---

## ugit 0.3.3:

* New Extensions:
  * git grep (Fixes #101)
  * --name-only support (Fixes #103)
* -WhatIf now returns a [ScriptBlock] (Fixes #90)
* Git.FileOutput: Test-Path before Get-Item (Fixes #106)

---

## ugit 0.3.2:

* git diff now includes .File and .GitRoot (Fixes #93)
* git pull no longer includes 'files changed' when no files change (Fixes #92)

---

## ugit 0.3.1:

* git help --all now returns as objects (Fixes #88)
* (git log .\filename).Diff() now only diffs the selected files (Fixes #87)
* git -C is permitted in any direectory (Fixes #85)

---

## ugit 0.3:

* Adding git version and git help to list of commands that do not require a repo (Fixes #79) (Thanks @charltonstanley!)

--

## ugit 0.2.9:
* Adding support for git init (Fixes #75)

---

## ugit 0.2.8:
* Adding support for git rm (Fixes #73)

---

## ugit 0.2.7:
* Adding support for git mv (#70, thanks @ninmonkey !)

---

## ugit 0.2.6:
* Fixing git diff for binary files (#47)

---

## ugit 0.2.5:
* Improving .Merged support for git log (#68)
* git log now also returns:
  * [int] .PullRequestNumber (the pull request number)
  * .Source (the source branch of a merge)
  * .Destination (the destination branch of a merge)

---

## ugit 0.2.4:
* Adding support for git stash (#65)
* Allowing git diff extension to display git stash show --patch (#66)

---

## ugit 0.2.3:
* Adding types for git.reference.log (#61 #62)

---

## ugit 0.2.2:
* Outputting hints as warnings (#56)
* Improved support for git pull (#57)
* Auto-building depedencies (#58)
* Consolidating CI/CD (#59)

---

## ugit 0.2.1:
* Adding support for git shortlog (#48)
* Adding .GitRoot to git reflog (#53)
* Extension documentation cleanup (#54)

---

## ugit 0.2.0:
* Adding support for git reflog (#51)

---

## ugit 0.1.9.1:
* Fixing git status duplicate message (#49)

---

## ugit 0.1.9:
* Support for eventing (#42)
* Autogeneration of docs (#43)
* Autogeneration of formatting (#44)
* Fixing git status formatting (#45)

---

## ugit 0.1.8:
* Adding Support for git checkout (#38)
* Use-Git:  Avoiding unwanted confirmation ( Fixing #39)

---

## ugit 0.1.7:
* Use-Git: -Verbose no longer infers --verbose (#10)
* Out-Git: Support for extension caching (#35)
* Out-Git: Using -ErrorAction Ignore when -Verbose is not passed (#36)
* Get-UGitExtension:  Updating Piecemeal Version [0.2.1].  (Re #32 #36)

---

## ugit 0.1.6
* Adding support / formatting for git pull (#26)
* Out-Git:  Extension Improvements (#33)

---

## ugit 0.1.5
* Adding git.log .Checkout() and Revert() (#27, #28)
* Fixing formatting for git diff (#25)
* Out-Git:  Adding History (#30)
* Use-Git:  SupportsShouldProcess (#29)

---

## ugit 0.1.4
* Adding git.log.reset() (#20)
* Adding git clone extension (#17)
* Use-Git:  Running certain git commands when there is no repo (currently clone and init)
* Use-Git:  Support for progress bars (#18).  Warning when repo not found (#21)
* git branch extension:  Adding example
* Highlighting branch name (fixing #19)

---

## ugit 0.1.3
* Updating git.log extension:  Adding .Merged (#16)
* Updating git push extension:  Support for first push (#14)
* Adding .output to automatic typenames (Fixing #11)
* Adding .ToString to git.branch and git.branch.detail (#9)
* Updating git branch extension:  Fixing --delete behavior (#13)
* Use-Git:  Support for -d/-D/-v/-V (#12).  -Verbose implies --verbose (#10)

---

## ugit 0.1.2
* Support for git push (#7)
* Adding .Amend/.UpdateMessage to git.commit.info (#6)

---

## ugit 0.1.1
* Support for git commit (#4)

---

## ugit 0.1
* Initial Release of ugit

---