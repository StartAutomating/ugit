<#
.SYNOPSIS
    git branch Extension
.DESCRIPTION
    Outputs git branch as objects (unless, -m, -c, -column, -format, or -show-current are passed)
.EXAMPLE
    git branch
#>
# It's an extension for Out-Git
[Management.Automation.Cmdlet("Out","Git")]
# when the pattern is "git branch"
[ValidatePattern("^git branch",Options='IgnoreCase')]
[OutputType('git.branch', 'git.branch.deleted','git.branch.detail')]
param()

begin {
    <#
    If any of these parameters are used, we will skip processing.
    #>
    $SkipIf = 'm', 'c', 'column','format', 'show-current' -join '|'    
    if ($gitCommand -match "\s-(?>$SkipIf)")      { continue }
    $allBranches = @()
}
process {
    # If -d or -delete was passed
    if ($gitCommand -match '\s-(?>d|-delete)') {
        # and we have a confirmation of the branch being deleted
        if ("$gitout" -match '^Deleted branch (?<BranchName>\S+) \(was (?<BranchHash>[0-9a-f]+)\)') {
            # Output a 'git.branch.deleted' object
            [PSCustomObject][Ordered]@{
                PSTypeName = 'git.branch.deleted'
                DeletedBranchName = $Matches.BranchName
                BranchHash = $Matches.BranchHash
                GitRoot = $GitRoot
            }
        } elseif (-not ("$gitout" -replace '\s')) { # Otherwise, if there was content on the line
            $gitout # output it.
        }
        return
    }

    # Current branches will start with an asterisk.  Convert this to a boolean.
    $IsCurrentBranch = ("$gitOut" -match '^\*\s' -as [bool])
        
    # If the -verbose flag was passed, we have more information in a more predictable fashion.
    if ($gitCommand -match '\s-(?:v|-verbose)'){
        # The branch name and hash are each separated by spaces.  Everything else is a commit message.
        $branchName, $branchHash, $lastCommitMessage = "$gitOut" -replace '^[\*\s]+' -split '\s+' -ne ''
        # All this to this of all branches (we will sort them at the end).
        $allBranches += [PSCustomObject][Ordered]@{
            PSTypeName       = 'git.branch.detail'
            BranchName       = $branchName
            BranchHash       = $branchHash
            CommitMessage    = $lastCommitMessage -join ' '
            IsCurrentBranch  = $IsCurrentBranch
            GitRoot          = $GitRoot
        }        
    } else {
        # If verbose wasn't passed, the branchname is any whitepsace.
        # If remotes were passed, then they may start with origin.  We can replace this.
        $branchName      = "$gitOut" -replace '^[\s\*]+' -replace '^origin/'
        
        # Add the output to the list of all branches
        $allBranches += [PSCustomObject][Ordered]@{
            PSTypeName       = 'git.branch'
            BranchName       = $branchName
            IsCurrentBranch  = $IsCurrentBranch
            GitRoot          = $GitRoot
        }
    }
    # If the user passed their own --sort parameter, 
    if ($gitCommand -match '\s--sort') {
        $allBranches[-1]    # don't sort for them and output the branch,
        $allBranches = @()  # and reset the list of all branches.
    }    
}

end {
    # If no --sort was passed, 
    $allBranches | 
        Sort-Object @{ # then put the current branch first
                Expression='IsCurrentBranch'
                Descending=$true
            }, 
            BranchName # and sort the rest alphabetically.
}
