
### 1. ugitting started

 ugit updates git to make it work wonderfully in PowerShell.

    
 When you use ugit, git returns objects, not files.

    

```PowerShell
git log -n 1
```

    
    GitUserName    CommitDate          CommitMessage
    -----------    ----------          -------------
    James Brundage 04/24/2023 00:37:52 Improving ugit demo (adding mock file) (Fixes #163)
    
    
 Don't believe me?  Just pipe to Get-Member

    

```PowerShell
git log -n 1 | 
    Get-Member
```

    
       TypeName: git.log
    
    Name             MemberType     Definition
    ----             ----------     ----------
    Equals           Method         bool Equals(System.Object obj)
    GetHashCode      Method         int GetHashCode()
    GetType          Method         type GetType()
    ToString         Method         string ToString()
    CommitDate       NoteProperty   datetime CommitDate=04/24/2023 00:37:52
    CommitHash       NoteProperty   string CommitHash=caf98ef79777d30f283eac04dc1e76222b8dd2ef
    CommitMessage    NoteProperty   string CommitMessage=Improving ugit demo (adding mock file) (Fixes #163)
    GitCommand       NoteProperty   string GitCommand=git log -n 1 
    GitOutputLines   NoteProperty   string[] GitOutputLines=System.String[]
    GitRoot          NoteProperty   string GitRoot=/home/runner/work/ugit/ugit
    GitUserEmail     NoteProperty   string GitUserEmail=@github.com
    GitUserName      NoteProperty   string GitUserName=James Brundage
    Merged           NoteProperty   bool Merged=False
    MergeHash        NoteProperty   string MergeHash=
    Trailers         NoteProperty   OrderedDictionary Trailers=System.Collections.Specialized.OrderedDictionary
    Archive          ScriptMethod   System.Object Archive();
    Checkout         ScriptMethod   System.Object Checkout();
    Diff             ScriptMethod   System.Object Diff();
    Reset            ScriptMethod   System.Object Reset();
    Revert           ScriptMethod   System.Object Revert();
    ReferenceNumbers ScriptProperty System.Object ReferenceNumbers {get=[Regex]::new("#(?<n>\d+)").Matches($this.CommitMessage) -replace '#' -as [int[]];}
    
    
 You can also pipe into git commands

    

```PowerShell
Get-Item .\ugit.psd1 | git log
```

    
    GitUserName    CommitDate          CommitMessage
    -----------    ----------          -------------
    James Brundage 03/29/2023 20:22:02 Updating Module Version [0.3.8] and CHANGELOG
    James Brundage 03/09/2023 01:17:39 Updating Module Version [0.3.7] and CHANGELOG
    James Brundage 02/08/2023 04:25:43 Updating Module Version [0.3.6] and CHANGELOG
    James Brundage 02/05/2023 07:36:16 Updating Module Version [0.3.5] and CHANGELOG
    James Brundage 01/28/2023 01:47:01 Updating Module Version [0.3.4] and CHANGELOG
    James Brundage 01/18/2023 03:34:55 Updating Module Version [0.3.3] and CHANGELOG
    James Brundage 01/18/2023 02:57:03 Updating Manifest (Starting work on 0.3.3)
    James Brundage 11/29/2022 23:00:00 Updating Module Version [0.3.2] and CHANGELOG
    James Brundage 11/29/2022 22:57:03 ugit.psd1:  Adding build modules
    James Brundage 10/30/2022 06:06:22 Updating Module Version [0.3.1] and CHANGELOG
    James Brundage 10/13/2022 05:56:37 Updating Module Version [0.3.0] and CHANGELOG
    James Brundage 10/01/2022 22:53:55 Updating Module Version [0.2.9] and CHANGELOG
    James Brundage 08/13/2022 19:32:37 Updating Module Version [0.2.8] and CHANGELOG
    James Brundage 07/29/2022 20:20:25 Updating Module Version [0.2.7] and CHANGELOG
    James Brundage 07/24/2022 04:05:39 Updating Module Version [0.2.6] and CHANGELOG
    James Brundage 07/24/2022 04:05:25 Updating Module Version [0.2.6] and CHANGELOG
    James Brundage 07/18/2022 18:43:35 Updating Module Version [0.2.5], CHANGELOG, and README
    James Brundage 07/16/2022 19:47:56 Updating Module Version [0.2.4] and CHANGELOG
    James Brundage 07/07/2022 02:18:37 Updating Module Version [0.2.3] and CHANGELOG
    James Brundage 06/29/2022 01:18:06 Updating Module Version [0.2.2] and CHANGELOG
    James Brundage 06/25/2022 21:07:39 Updating Module Version [0.2.1] and CHANGELOG
    James Brundage 06/25/2022 04:41:42 Updating Module Version [0.2.0] and CHANGELOG
    James Brundage 06/08/2022 01:31:17 Updating Module Version [0.1.9.1] and CHANGELOG
    James Brundage 04/25/2022 02:56:16 Updating Module Version [0.1.9] and CHANGELOG
    James Brundage 04/12/2022 22:42:45 Merge branch 'main' into CheckoutSupportAndFixes
    James Brundage 04/12/2022 22:41:31 Updating Module Version [0.1.8] and CHANGELOG
    James Brundage 04/10/2022 20:30:47 Updating Module Version [0.1.7] and CHANGELOG
    James Brundage 04/09/2022 20:36:23 Updating Module Version [0.1.6] and CHANGELOG
    James Brundage 04/04/2022 21:19:07 Updating Module Version [0.1.5] and CHANGELOG
    James Brundage 03/26/2022 22:49:42 Updating Module Version [0.1.4], CHANGELOG, and README
    James Brundage 03/26/2022 22:46:53 Updating Module Version [0.1.4], CHANGELOG, and README
    James Brundage 03/25/2022 03:17:42 Updating Module Version [0.1.3] and CHANGELOG
    James Brundage 03/25/2022 03:06:14 Updating Module Version [0.1.3] and CHANGELOG
    James Brundage 03/22/2022 05:06:20 Updating Module Version [0.1.2] and CHANGELOG
    James Brundage 03/21/2022 06:41:30 Updating Module Version [0.1.1] and CHANGELOG
    James Brundage 03/20/2022 11:17:48 Updating ugit.psd1 - Adding Module Metadata
    James Brundage 03/18/2022 21:44:32 Initial Commit of ugit
    
    
 git logs ain't all, ugit supports a bunch of git commands

    

```PowerShell
git branch
```

    
       GitRoot: /home/runner/work/ugit/ugit
    
    BranchName      IsCurrentBranch
    ----------      ---------------
    ugit-file-diffs True
    
    
 Let's use the object pipeline to filter out the current branch

    

```PowerShell
git branch | 
    Where-Object -Not IsCurrentBranch
```

    
 Another cool thing ugit can do is -WhatIf.  That will output the git command without running it.

    

```PowerShell
git branch |
    Where-Object -Not IsCurrentBranch |
    git branch -d -WhatIf
```

    
 We can also git status

    

```PowerShell
git status
```

    
       GitRoot: /home/runner/work/ugit/ugit
    
    On Branch: ugit-file-diffs
    Your branch is up to date with 'origin/ugit-file-diffs'.
    Nothing to commit, working tree clean
    
    
 Let's make a little file, so that there are some changes

    

```PowerShell
"hello world" | Set-Content .\hello.txt
```

    

```PowerShell
# Now we can see our file in the status's .Untracked property (as fileinfo objects)
(git status).Untracked
```

    
        Directory: /home/runner/work/ugit/ugit
    
    UnixMode   User             Group                 LastWriteTime           Size Name
    --------   ----             -----                 -------------           ---- ----
    -rw-r--r-- runner           docker             04/24/2023 00:39             12 hello.txt
    
    
 We can git diffs

    

```PowerShell
git diff
```

    
 And get files with differences this way, too

    

```PowerShell
(git diff).File
```

    
 Let's clean up our file

    

```PowerShell
Remove-Item .\hello.txt
```

    
### 2. ugitting cooler

 ugit has started to extend the parameters of git

    
 some of these are simple, like --convenience parameters:

    

```PowerShell
git log -After ([datetime]::Now.AddMonths(-1))
```

    
    GitUserName     CommitDate          CommitMessage
    -----------     ----------          -------------
    James Brundage  04/24/2023 00:37:52 Improving ugit demo (adding mock file) (Fixes #163)
    StartAutomating 04/24/2023 00:29:58 Adding ugit demo (Fixes #163)
    StartAutomating 04/24/2023 00:29:51 Adding ugit demo (Fixes #163)
    James Brundage  04/24/2023 00:27:47 Adding ugit demo (Fixes #163)
    StartAutomating 04/24/2023 00:26:25 Adding git.branch IsTracked (Fixes #160)
    James Brundage  04/24/2023 00:24:29 Adding git.branch IsTracked (Fixes #160)
    James Brundage  04/23/2023 22:35:20 Updating workflow (Using GitLogger)
    James Brundage  04/22/2023 23:49:11 Use-Git - Improving -Confirm (Fixes #165)
    James Brundage  04/22/2023 23:48:52 Use-Git - Improving -Confirm (Fixes #165)
    StartAutomating 04/22/2023 23:48:18 Adding ugit.extension formatting (Fixes #164)
    StartAutomating 04/22/2023 23:48:18 Adding ugit.extension formatting (Fixes #164)
    James Brundage  04/22/2023 23:40:08 Adding ugit.extension formatting (Fixes #164)
    James Brundage  04/22/2023 22:51:31 Use-Git - -WhatIf Support (Fixes #162)
    StartAutomating 04/22/2023 22:34:20 Git.Log.Input - Adding -NumberOfCommits (Fixes #161, re #156)
    James Brundage  04/22/2023 22:32:59 Git.Log.Input - Adding -NumberOfCommits (Fixes #161, re #156)
    StartAutomating 04/22/2023 21:45:54 Git.Log.Input - Removing -IgnoreSearchPattern (re #159)
    James Brundage  04/22/2023 21:44:20 Git.Log.Input - Removing -IgnoreSearchPattern (re #159)
    James Brundage  04/22/2023 21:44:12 Git.Log.Input - Removing -IgnoreSearchPattern (re #159)
    StartAutomating 04/22/2023 21:40:15 Git.Log.Input - Adding -IgnoreSearchPattern (Fixes #159)
    James Brundage  04/22/2023 21:38:47 Git.Log.Input - Adding -IgnoreSearchPattern (Fixes #159)
    StartAutomating 04/22/2023 21:20:40 Git.Log.Input - Adding -SearchPattern (Fixes #158)
    James Brundage  04/22/2023 21:19:03 Git.Log.Input - Adding -SearchPattern (Fixes #158)
    StartAutomating 04/22/2023 21:16:24 Git.Log.Input - Adding -SearchString (Fixes #157)
    James Brundage  04/22/2023 21:14:51 Git.Log.Input - Adding -SearchString (Fixes #157)
    StartAutomating 04/22/2023 21:10:43 Git.Log.Input -IssueNumber aliasing to Number (Fixes #156)
    James Brundage  04/22/2023 21:09:18 Git.Log.Input -IssueNumber aliasing to Number (Fixes #156)
    StartAutomating 04/22/2023 21:08:55 Git.Log.Input -Statistics (Fixes #155)
    James Brundage  04/22/2023 21:05:29 Git.Log.Input -Statistics (Fixes #155)
    StartAutomating 04/22/2023 20:47:19 System.IO.FileInfo.GitChanges - Using extended parameters (re #153 #154)
    James Brundage  04/22/2023 20:45:38 System.IO.FileInfo.GitChanges - Using extended parameters (re #153 #154)
    James Brundage  04/22/2023 20:38:24 Use-Git - Improving Extension Argument Behavior (Fixes #154)
    StartAutomating 04/22/2023 02:30:27 Extending FileInfo for better git results (Fixes #153)
                                       
                                            Co-authored-by: Jake Bolton <ninmonkey@github.com>
    James Brundage  04/22/2023 02:28:51 Extending FileInfo for better git results (Fixes #153)
                                       
                                            Co-authored-by: Jake Bolton <ninmonkey@github.com>
    James Brundage  04/22/2023 02:27:16 Extending FileInfo for better git results (Fixes #153)
                                       
                                            Co-authored-by: Jake Bolton <ninmonkey@github.com>
    StartAutomating 04/22/2023 01:05:06 git log formatting - right-aligning CommitMessage (Fixes #152)
    James Brundage  04/22/2023 01:03:34 git log formatting - right-aligning CommitMessage (Fixes #152)
    StartAutomating 04/22/2023 00:30:14 git log .diff FileChange fix (Fixes #151)
    James Brundage  04/22/2023 00:28:49 git log .diff FileChange fix (Fixes #151)
    StartAutomating 04/22/2023 00:26:59 Git Diff ChangeSet Formatting Fix (Fixes #150)
    James Brundage  04/22/2023 00:23:51 Git Diff ChangeSet Formatting Fix (Fixes #150)
    James Brundage  03/29/2023 20:29:05 Merge pull request #146 from StartAutomating/ugit-updates
                                       
                                            ugit 0.3.8
    StartAutomating 03/29/2023 20:22:54 Updating Module Version [0.3.8] and CHANGELOG
    James Brundage  03/29/2023 20:22:02 Updating Module Version [0.3.8] and CHANGELOG
    James Brundage  03/29/2023 20:20:18 Updating ugit Workflow source
                                       
                                            Using -OutputPath
    StartAutomating 03/29/2023 20:03:28 Updating Git Remote Formatting (Fixes #145)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/145
    James Brundage  03/29/2023 20:02:34 Updating Git Remote Formatting (Fixes #145)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/145
    StartAutomating 03/28/2023 08:17:48 Git commit extension:  Not using -Metadata as an alias for -Trailers (re #144)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/144
    StartAutomating 03/28/2023 08:17:47 Git commit extension:  Not using -Metadata as an alias for -Trailers (re #144)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/144
    StartAutomating 03/28/2023 08:17:33 Git commit extension:  Not using -Metadata as an alias for -Trailers (re #144)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/144
    James Brundage  03/28/2023 08:16:20 Git commit extension:  Not using -Metadata as an alias for -Trailers (re #144)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/144
    James Brundage  03/28/2023 08:13:48 Use-Git - Improving Extensibility Support and Internally refactoring (re #140)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/140
    James Brundage  03/28/2023 07:57:48 git log extension - Supporting .Trailers (Fixes #112)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/112
    James Brundage  03/28/2023 07:51:26 Adding Git Commit Input Extension (Fixes #144)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/144
    StartAutomating 03/28/2023 07:46:50 Adding Git Log Input Extension (Fixes #142)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/142
    StartAutomating 03/28/2023 07:46:49 Adding Git Log Input Extension (Fixes #142)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/142
    StartAutomating 03/28/2023 07:46:32 Adding Git Log Input Extension (Fixes #142)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/142
    James Brundage  03/28/2023 07:43:55 Adding Git Log Input Extension (Fixes #142)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/142
    James Brundage  03/28/2023 03:41:48 Git Log - continue if --pretty or --format (Fixes #143)
                                       
                                            github-issue: https://github.com/StartAutomating/ugit/issues/143
    StartAutomating 03/27/2023 21:00:34 Updating README.ps1.md (moving examples up, adding Use-Git extensions)
    StartAutomating 03/27/2023 21:00:20 Updating README.ps1.md (moving examples up, adding Use-Git extensions)
    James Brundage  03/27/2023 20:59:05 Updating README.ps1.md (moving examples up, adding Use-Git extensions)
    James Brundage  03/27/2023 20:53:12 Updating README.ps1.md (moving examples up, adding Use-Git extensions)
    StartAutomating 03/27/2023 20:49:23 Adding git.clone.input extension (Fixes #141)
    StartAutomating 03/27/2023 20:49:22 Adding git.clone.input extension (Fixes #141)
    StartAutomating 03/27/2023 20:49:09 Adding git.clone.input extension (Fixes #141)
    James Brundage  03/27/2023 20:47:45 Adding git.clone.input extension (Fixes #141)
    StartAutomating 03/27/2023 20:45:00 Updating README.ps1.md (clarifying extensions)
    StartAutomating 03/27/2023 20:44:42 Updating README.ps1.md (clarifying extensions)
    James Brundage  03/27/2023 20:43:24 Updating README.ps1.md (clarifying extensions)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:47 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/27/2023 20:36:46 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    James Brundage  03/27/2023 20:34:48 Use-Git:  Allowing Extensibility (Fixes #140) (Fixes #97)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:35 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:34 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:33 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 23:07:13 Updating ugit logo (Fixes #139)
    James Brundage  03/26/2023 23:06:02 Updating ugit logo (Fixes #139)
    StartAutomating 03/26/2023 22:40:57 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:57 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:57 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:57 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:56 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:55 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    StartAutomating 03/26/2023 22:40:54 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    James Brundage  03/26/2023 22:37:39 Git Remote Extension: Fixing behavior for multiple remotes (Fixes #136)
    James Brundage  03/26/2023 21:38:29 Merge pull request #138 from StartAutomating/edits-Wed,15Mar202303-20-53GMT
                                       
                                            Posting with GitPub [skip ci]
    
    
 Others are more interesting, like being able to get changes from the current branch:

    

```PowerShell
git log -CurrentBranch
```

    
    Use '--' to separate paths from revisions, like this:
    'git <command> [<revision>...] -- [<file>...]'
    
    
 Others make obscure git features easier to access.  For example, let's search for any commits that changed ModuleVersion

    

```PowerShell
git log -SearchPattern ModuleVersion
```

    
    Use '--' to separate paths from revisions, like this:
    'git <command> [<revision>...] -- [<file>...]'
    
    
 Or, let's look for all commits related to issue #1

    

```PowerShell
git log -IssueNumber 1
```

    
    GitUserName    CommitDate          CommitMessage
    -----------    ----------          -------------
    James Brundage 03/20/2022 11:11:20 Merge pull request #1 from StartAutomating/InitialCommit
                                      
                                           Initial commit
    
    
 Some improvements are subtle.  For instance, we git clone will always add --progress, and will Write-Progress

    

```PowerShell
git clone https://github.com/StartAutomating/ugit.git
```

    
    Cloned https://github.com/StartAutomating/ugit.git into /home/runner/work/ugit/ugit/ugit
    
    
 Let's clean that up.

    

```PowerShell
Remove-Item .\ugit -Recurse -Force
```

    
### 3. ugit how it works

 ugit works with a few tricks of the PowerShell trade

    
 Aliases win over everything, so step one is to make git an alias to a function, Use-Git

    

```PowerShell
Get-Command git
```

    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Alias           git -> Use-Git                                     0.3.8      ugit
    
    
 When we override git, we can add extra parameters and parse it's output.

    
 We do this with ugit extensions.

    

```PowerShell
Get-UGitExtension
```

    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    ExternalScript  Git.Branch.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Branch.UGit.Extension.ps1
    ExternalScript  Git.Checkout.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Checkout.UGit.Extension.ps1
    ExternalScript  Git.Clone.Input.UGit.Extension.ps1                            /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Clone.Input.UGit.Extension.ps1
    ExternalScript  Git.Clone.UGit.Extension.ps1                                  /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Clone.UGit.Extension.ps1
    ExternalScript  Git.Commit.Input.UGit.Extension.ps1                           /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Commit.Input.UGit.Extension.ps1
    ExternalScript  Git.Commit.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Commit.UGit.Extension.ps1
    ExternalScript  Git.Diff.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Diff.UGit.Extension.ps1
    ExternalScript  Git.FileName.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.FileName.UGit.Extension.ps1
    ExternalScript  Git.FileOutput.UGit.Extension.ps1                             /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.FileOutput.UGit.Extension.ps1
    ExternalScript  Git.Grep.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Grep.UGit.Extension.ps1
    ExternalScript  Git.Help.All.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Help.All.UGit.Extension.ps1
    ExternalScript  Git.Init.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Init.UGit.Extension.ps1
    ExternalScript  Git.Log.Input.UGit.Extension.ps1                              /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Log.Input.UGit.Extension.ps1
    ExternalScript  Git.Log.UGit.Extension.ps1                                    /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Log.UGit.Extension.ps1
    ExternalScript  Git.Mv.UGit.Extension.ps1                                     /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Mv.UGit.Extension.ps1
    ExternalScript  Git.Pull.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Pull.UGit.Extension.ps1
    ExternalScript  Git.Push.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Push.UGit.Extension.ps1
    ExternalScript  Git.RefLog.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.RefLog.UGit.Extension.ps1
    ExternalScript  Git.Remote.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Remote.UGit.Extension.ps1
    ExternalScript  Git.Rm.UGit.Extension.ps1                                     /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Rm.UGit.Extension.ps1
    ExternalScript  Git.Shortlog.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Shortlog.UGit.Extension.ps1
    ExternalScript  Git.Stash.UGit.Extension.ps1                                  /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Stash.UGit.Extension.ps1
    ExternalScript  Git.Status.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Status.UGit.Extension.ps1
    
    
 An extension can apply to Use-Git or Out-Git.

    
 Out-Git extensions turn git output into objects when the git command matches a pattern.

    

```PowerShell
Get-UGitExtension -CommandName Out-Git
```

    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    ExternalScript  Git.Branch.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Branch.UGit.Extension.ps1
    ExternalScript  Git.Checkout.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Checkout.UGit.Extension.ps1
    ExternalScript  Git.Clone.UGit.Extension.ps1                                  /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Clone.UGit.Extension.ps1
    ExternalScript  Git.Commit.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Commit.UGit.Extension.ps1
    ExternalScript  Git.Diff.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Diff.UGit.Extension.ps1
    ExternalScript  Git.FileName.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.FileName.UGit.Extension.ps1
    ExternalScript  Git.FileOutput.UGit.Extension.ps1                             /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.FileOutput.UGit.Extension.ps1
    ExternalScript  Git.Grep.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Grep.UGit.Extension.ps1
    ExternalScript  Git.Help.All.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Help.All.UGit.Extension.ps1
    ExternalScript  Git.Init.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Init.UGit.Extension.ps1
    ExternalScript  Git.Log.UGit.Extension.ps1                                    /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Log.UGit.Extension.ps1
    ExternalScript  Git.Mv.UGit.Extension.ps1                                     /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Mv.UGit.Extension.ps1
    ExternalScript  Git.Pull.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Pull.UGit.Extension.ps1
    ExternalScript  Git.Push.UGit.Extension.ps1                                   /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Push.UGit.Extension.ps1
    ExternalScript  Git.RefLog.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.RefLog.UGit.Extension.ps1
    ExternalScript  Git.Remote.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Remote.UGit.Extension.ps1
    ExternalScript  Git.Rm.UGit.Extension.ps1                                     /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Rm.UGit.Extension.ps1
    ExternalScript  Git.Shortlog.UGit.Extension.ps1                               /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Shortlog.UGit.Extension.ps1
    ExternalScript  Git.Stash.UGit.Extension.ps1                                  /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Stash.UGit.Extension.ps1
    ExternalScript  Git.Status.UGit.Extension.ps1                                 /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Status.UGit.Extension.ps1
    
    
 Use-Git extensions add extra parameters to git when the command matches a pattern.

    

```PowerShell
Get-UGitExtension -CommandName Use-Git
```

    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    ExternalScript  Git.Clone.Input.UGit.Extension.ps1                            /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Clone.Input.UGit.Extension.ps1
    ExternalScript  Git.Commit.Input.UGit.Extension.ps1                           /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Commit.Input.UGit.Extension.ps1
    ExternalScript  Git.Log.Input.UGit.Extension.ps1                              /home/runner/.local/share/powershell/Modules/ugit/0.3.8/Extensions/Git.Log.Input.UGit.Extension.ps1
    
    
 Each extension returns a property bag, which can then be extended within ugit.types.ps1xml and formatted within a ugit.format.ps1xml.

    



