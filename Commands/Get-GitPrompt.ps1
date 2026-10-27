function Get-GitPrompt {
    <#
    .SYNOPSIS
        Git Prompt
    .DESCRIPTION
        Git friendly PowerShell prompt.

        Shows current branch, modified, untracked, added, and removed files.
    #>
    [Alias('git.prompt')]
    param(
    # The icon used for git branches.
    # By default `⑆` (OCR Branch Bank Identification [0x2446]) 
    [string]
    $BranchIcon = '⑆',

    # The prompt icon after a successful command.
    # By default, `≻` (Succeeds [0x227b])
    [string]
    $SuccessIcon = '≻', #'⊃', # '>', "➫", "⮚"

    # By default, `≻` (Does not Succeed [0x2281]) 
    [string]
    $ErrorIcon = '⊁',

    # The home icon.
    # This is displayed when the path is 
    # beneath the user home directory.
    # By default: `⌂` (House [0x2302])
    [string]
    $HomeIcon = '⌂',

    [string]
    $BranchOpenIcon = '⟦',

    [string]
    $BranchCloseIcon = '⟧',

    [string]
    $JobIcon = '⏲',

    # The icon used for slash.
    # This will separate directories.
    # By default ` ⹊ ` (Dotted Solidus [0x2e4a])
    [string]
    $Slash = " ⹊ ", # '⹊' #, '/'

    # The style to use when things succeed
    [string]
    $SuccessStyle = $PSStyle.Foreground.Green,

    # The style to use when things fail
    [string]
    $ErrorStyle = $PSStyle.Foreground.Red,

    # The style to use when warning
    [string]
    $WarningStyle = $PSStyle.Foreground.Yellow,

    # The style to use when cyan
    [string]
    $InfoStyle = $PSStyle.Foreground.Cyan,

    [string]
    $UnknownStyle = $PSStyle.Foreground.Magenta,

    # The style to use when bolding text.
    [string]
    $BoldStyle = $psStyle.Bold,

    [string]
    $BoldStyleOff = $psStyle.Bold.Off,

    # The string used to reset styles.
    [string]
    $ResetStyle = $PSStyle.Reset,

    # If set, will display the history ID
    [switch]
    $ShowHistoryId
    )

    # Capture if the last statement worked
    # (if we do not do this first, it will not be accurate)
    $worked = $?

    # If we have a nested prompt level greater than one
    # we are debugging or in another nested context.
    # Performance will be more important in this case
    if ($NestedPromptLevel -gt 1) {
        # so simply multiply our prompt icon by the nested prompt level
        return ($SuccessIcon * $NestedPromptLevel)
    }

    # We may want to pad the lines
    $LeftPadding = 
        # If we are not showing the history ID
        if (-not $ShowHistoryId) {
            ' ' # we can padd with a single space
        } else {
            # Otherwise, pad with the history id length.
            ' ' * "$($MyInvocation.HistoryId)".Length
        }    
    
    # Determine if nothing happened
    # (someone just pressing `ENTER` will not increment the history ID)
    $isNoOp = $script:LastHistoryId -eq $MyInvocation.HistoryId

    # Determine our display path.    
    $displayPath =
        # If we're somewhere beneath `$home`
        if ("$pwd".StartsWith("$home")) {
            # Use the home icon
            $HomeIcon,
                # and the path beneath home
                "$pwd".Substring(
                    "$home".Length
                ) -replace # Fix slashes to unix style
                '[\\/]+','/' -replace # then replace any duplicate slashes
                '/+','/' -join 
                    ''
        } else {
            # Otherwise, just fix slashes to unix style.
            "$pwd" -replace '[\\/]+', '/'
        }

    # Replace the last slash, and then replace slashes with our slash icon
    $displayPath = $displayPath -replace '/{0,}$' -replace '/+',$Slash
    
    # If nothing happened
    if ($isNoOp) {
        # Output our prompt
        return "$(
            # If the last command worked, use the info style;
            if ($worked) { $InfoStyle }
            # otherwise, use the error style.
            else { $ErrorStyle }
        )$(
            # If the last command worked, use the success icon;
            if ($worked) {$SuccessIcon}
            # otherwise, use the error icon.
            else { $ErrorIcon }
        )$($LeftPadding)$(
            $ResetStyle
        )"
    } else {
        # If something happened, update our history ID.
        $script:LastHistoryId = $MyInvocation.HistoryId
    }

    # Next we want to check for git remotes.

    # Cache any remote paths we find
    if (-not $script:GitRemotePath) {
        $script:GitRemotePath = [Ordered]@{}
    }
    # If we do not know the remote for the current directory
    if (-not $script:GitRemotePath.Contains("$pwd")) {
        # get the remote
        $script:GitRemotePath["$pwd"] = git remote -ErrorAction Ignore | git remote show
    }
    
    # There might be more than one remote.  We want the first.
    $gitRemoteUrl = @($script:GitRemotePath["$pwd"].RemoteUrls.Fetch)[0]

    $repoUrl = $gitRemoteUrl -replace 
        '^ssh://', 'https://' -replace 
        '\.git$' -replace 
        '\.wiki$', '/wiki'  -as [uri]
    
    # Now git our status
    $gitStatus = if ([IO.Directory]::Exists($pwd)) {
        git status . -WarningAction Ignore
    } else {
        $null
    }
    
    # If somehow that failed
    if (-not $gitStatus) {
        # If there was no status url, we're not in a repository.        
        # Output our prompt
        return "$(
            # Show the history ID (or not)
            if ($ShowHistoryId) {
                "$($myInvocation.HistoryId) "
            } else {
                ''
            }
        )$(
            # Followed by the display path
            $displayPath
        ) $(
            # Followed by the appropriate style
            if ($worked) { $InfoStyle }
            else { $ErrorStyle }
        )$(
            # and icon (based off of the success/failure of the last command)
            if ($worked) {$SuccessIcon}
            else {$ErrorIcon }
        )$(
            $ResetStyle
        )$(' ' * 1)"        
    }    
    
    # Collect the files that have been staged for addition
    $stagedModified = @($gitStatus.Added)
    # and deletion.
    $stagedDeletes = @($gitStatus.Removed)
    # Collect the files that have been locally modified
    $modified = @($gitStatus.Modified)
    # and deleted.
    $deleted = @($gitStatus.Deleted)
    
    # Last but not least, collect untracked files.    
    $untracked = @($gitStatus.Untracked)
    
    # Create a link to our repo
    $LinkToRepo = $PSStyle.FormatHyperlink(
        # This will make our file tree link to the repo tree
        $displayPath,
        "$repoUrl"
    )

    # Get our git relative path.
    $gitRelativePath =
        "$pwd".Substring($gitStatus.GitRoot.Length) -replace '[\\/]', '/'

    # Prepare the branch info portion of our prompt
    $gitBranchInfo = @(
        # If the branch is in `main`, `master`, or `latest`,
        # you might want to check out.
        if ($GitStatus.BranchName -in 'main', 'master', 'latest') {
            # So we will display that as a warning
            $WarningStyle
        } else {
            # If we are behind the upstream
            if ($gitCommitsBehind -or 
                # or have diverged, we're in trouble.
                $gitStatus.Status -match 'diverged') {
                $ErrorStyle # and should show the repo using the error style.
            } elseif ($gitStatus.Staged) {
                # If we've got commits staged for addition
                $SuccessStyle # we're green / good to go.
            } else {
                # Otherwise, we're just informing you about the branch name.
                $InfoStyle
            }                
        }

        
        # The rest of our git branch info is:
        $BoldStyle             # * Bold        
        $BranchIcon            # * Branch Icon
        $LeftPadding           # * LeftPadding        
        $BranchOpenIcon        # * BranchOpenIcon        
        $gitStatus.BranchName  # * `$gitStatus.BranchName`
        $BranchCloseIcon       # * Close our branch.
        $BoldStyleOff          # * Bold Off        
        $ResetStyle            # * Reset Style
    )

    # Now we just have to hyperlink things
    $gitInfo = @(
        # If we have a repo url
        if ($repoUrl) {
            # make a hyperlink to it and display the branch info
            $PSStyle.FormatHyperlink(
                "$($gitBranchInfo -join '')",
                "$repoUrl/tree/$($gitStatus.BranchName)$GitRelativePath"
            )
        } else {
            $gitBranchInfo -join ''
        }  

        # If we are in a git subdirectory
        if ($gitRelativePath) {            
            # hyperlink to this exact spot in the tree.
            $PSStyle.FormatHyperlink(                
                ($gitRelativePath -replace '[\\/]', $Slash),
                "$repoUrl/tree/$($gitStatus.BranchName)$GitRelativePath"
            )
        }

        # If the branches have diverged
        if ($gitStatus.Status -match 'diverged') {
            # Make sure we notice.
            "$($ErrorStyle) diverged!$($($ResetStyle))"
        }

        # If we are behind
        if ($gitStatus.Behind -gt 0) {
            # make sure we notice.
            "$($ErrorStyle)(-$($gitStatus.Behind))$($ResetStyle)"
        }

        # If we are ahead
        if ($gitStatus.Ahead -gt 0) {
            # make sure we notice and feel successful. 
            "$($SuccessStyle)(+$($gitStatus.Ahead))$($ResetStyle)"
        }

        # If we have any staged files,
        if ($stagedModified) {
            # make sure we know how many have been added.
            $SuccessStyle,
                " $($stagedModified.Length) added",
                    $ResetStyle
        }

        # If we have any deleted files,
        if ($stagedDeletes) {
            # make sure we know how many have been removed.
            $ErrorStyle,
                " $($stagedDeletes.Length) removed",
                    $ResetStyle
        }

        # If we have any modified files
        if ($modified) {
            # Display the info.
            $InfoStyle,
                " $($modified.Length) modified",
                    $ResetStyle
        }

        # If we have any deleted files
        if ($deleted) {
            # Make sure we know.
            $ErrorStyle,
                " $($deleted.Length) deleted",
                    $ResetStyle
        }

        # If we have any untracked files
        if ($untracked) {
            
            $PSStyle.Foreground.Magenta,
                " $($untracked.Count) untracked",
                    $ResetStyle
        }        
        $ResetStyle
    ) -join ''

    # ⮚ ⟣ ⤳ ⟫ ⟩
    "$(
        if (-not $ShowHistoryId) {
            ''
        } else {
            "$($myInvocation.HistoryId) "
        }            
    )$LinkToRepo",
        "$gitInfo",            
            "$(
                if ($worked) { $InfoStyle }
                else { $ErrorStyle }
            )$(
                if ($worked) {$SuccessIcon}
                else {$ErrorIcon }
            )$LeftPadding$(
                $ResetStyle
            )" -join
                [Environment]::NewLine
    
}