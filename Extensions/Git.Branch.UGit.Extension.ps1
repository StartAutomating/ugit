# It's an extension
[Runtime.CompilerServices.Extension()]
# that extends Out-Git
[Management.Automation.Cmdlet("Out","Git")]
# when the pattern is "git branch"
[ValidatePattern("^git branch",Options='IgnoreCase')]
param()

begin {
    <#
    If any of these parameters are used, we will skip processing.
    #>
    $SkipIf = 'm', 'c', 'column','format', 'show-current' -join '|'    
    if ($gitCommand -match "\s-(?>$SkipIf)")      { break }
    $allBranches = @()
}
process {
    if ($gitCommand -match '\s-(?>d|delete)') {
        if ("$gitout" -match '^Deleted branch (?<BranchName>\S+) \(was (?<BranchHash>[0-9a-f]+)\)') {
            [PSCustomObject][Ordered]@{
                PSTypeName = 'git.branch.deleted'
                BranchName = $Matches.BranchName
                BranchHash = $Matches.BranchHash
            }
        } elseif (-not ("$gitout" -replace '\s')) {
            $gitout
        }
        return
    }
    $IsCurrentBranch = ("$gitOut" -match '^\*\s' -as [bool])
    
    
    
    if ($gitCommand -match '\s-(?:v|-verbose)'){
        $branchName, $branchHash, $lastCommitMessage = "$gitOut" -replace '^[\*\s]+' -split '\s+' -ne ''
        $allBranches += [PSCustomObject][Ordered]@{
            PSTypeName       = 'git.branch.detail'
            BranchName       = $branchName
            BranchHash       = $branchHash
            CommitMessage    = $lastCommitMessage -join ' '
            IsCurrentBranch  = $IsCurrentBranch
        }
        
    } else {
        
        $branchName      = "$gitOut" -replace '^[\s\*]+' -replace '^origin/'
        
        $allBranches += [PSCustomObject][Ordered]@{
            PSTypeName       = 'git.branch'
            BranchName       = $branchName
            IsCurrentBranch = $IsCurrentBranch
        }
    }
    if ($gitCommand -match '\s--sort') {
        $allBranches[-1]
        $allBranches = @()
    }
    
}

end {
    $allBranches | Sort-Object @{Expression='IsCurrentBranch';Descending=$true}, BranchName
}
