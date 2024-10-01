<#
.SYNOPSIS
    git checkout extension
.DESCRIPTION
    Outputs git checkout as objects.
.EXAMPLE
    git checkout -b CreateNewBranch
.EXAMPLE
    git checkout main
#>
[Management.Automation.Cmdlet('Out', 'Git')]
[ValidatePattern('^git checkout')]
param()

begin {
    $gitCheckoutLines = @()
    $switchedToNewBranch = "^Switched to a new branch '(?<b>[^']+)'"
}

process {
    $gitCheckoutLines += $gitOut
}

end {

    
    if ($($gitCheckoutLines) -match $switchedToNewBranch) {        
        foreach ($line in $gitCheckoutLines) {
            if ($line -match $switchedToNewBranch) {
                [PSCustomObject]@{
                    BranchName = $matches.b
                    PSTypeName = 'git.checkout.newbranch'
                    GitRoot    = $GitRoot
                }        
                break
            }
        }        
    }
    elseif ($gitCheckoutLines -match "Switched to branch '(?<b>[^']+)'")
    {
        $gitCheckoutInfo = @{PSTypeName='git.checkout.switchbranch';GitRoot=$GitRoot;GitOutputLines=$gitCheckoutLines;Modified=@()}
        foreach ($checkoutLine in $gitCheckoutLines) {
            if ($checkoutLine -match "Switched to branch '(?<b>[^']+)'") {
                $gitCheckoutInfo.BranchName = $matches.b
            }
            elseif ($checkoutLine -match '^Your branch') {
                $gitCheckoutInfo.Status = $checkoutLine
            }
            elseif ($checkoutLine -match '^(?<ct>\w)\s+(?<fn>\S+)') {
                if ($matches.ct -eq 'M') {
                    $gitCheckoutInfo.modified += (Get-Item $matches.fn -ErrorAction SilentlyContinue)
                }
            }
        }
        [PSCustomObject]$gitCheckoutInfo
    }
    elseif ($gitCheckoutLines -match "Already on '(?<b>[^']+)'") {
        $gitCheckoutInfo = @{PSTypeName='git.checkout.alreadyonbranch';GitRoot=$GitRoot;GitOutputLines=$gitCheckoutLines}
        foreach ($checkoutLine in $gitCheckoutLines) {
            if ($checkoutLine -match "Already on '(?<b>[^']+)'") {
                $gitCheckoutInfo.BranchName = $matches.b
            }
            elseif ($checkoutLine -match '^Your branch') {
                $gitCheckoutInfo.Status = $checkoutLine
            }
        }
        [PSCustomObject]$gitCheckoutInfo
    }
    else {
        $gitCheckoutLines
    }
}
