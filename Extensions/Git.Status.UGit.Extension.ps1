[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern('^git status')]
param(

)

begin {
    <#
    If any of these parameters are used, we will skip processing.
    #>
    $SkipIf = 'porcelain' -join '|' 
    if ($gitCommand -match "\s-(?>$SkipIf)")      { break }

    $statusLines = @()
}

process {
    $statusLines += "$gitOut"
}

end {
    $gitStatusOut = [Ordered]@{
        PSTypeName = 'Git.Status'
        BranchName = ''
        Status     = ''
        Staged     = @()
        Unstaged   = @()
        Untracked  = @()
        GitRoot    = $GitRoot
    }

    $inPhase     = ''

    for ($sln = 0; $sln -lt $statusLines.Length; $sln++) {
        if ($sln -eq 0) {
            $gitStatusOut.BranchName = @($statusLines[$sln] -split ' ' -ne '')[-1] 
            continue
        }
        if ($statusLines[$sln] -like '*not staged for commit:*') {
            # When on a new branch with no upstream, this comes first.
            $inPhase = 'Unstaged'
            continue
        }
        if ($statusLines[$sln] -like "Changes to be committed:*") {
            $inPhase = 'Staged'
        }
        if ($statusLines[$sln] -like "Untracked files:*") {
            $inPhase = 'Untracked'
            continue
        }
        
        if ($sln -eq 1 -and -not $inPhase) {
            $gitStatusOut.Status = $statusLines[$sln]
            continue
        }
    

        

        if ($statusLines[$sln] -match '^\s+\(') { continue }
        if ($statusLines[$sln] -match '^\s+' -and $inPhase) {
            $trimmedLine = $statusLines[$sln].Trim()
            $changeType = 
                if ( $trimmedLine -match "^([\w\s]+):") {
                    $matches.1
                } else {
                    ''
                }
            $changePath = $trimmedLine -replace "^[\w\s]+:\s+"
            if ($inPhase -eq 'untracked') {
                $gitStatusOut.$inPhase += Get-Item -ErrorAction SilentlyContinue -Path $changePath
            } else {
                $gitStatusOut.$inPhase += [PSCustomObject]@{
                    ChangeType = $changeType -replace '\s'
                    Path       = $changePath
                    File       = Get-Item -ErrorAction SilentlyContinue -Path $changePath
                }
            }
            
        }
    }

    $gitStatusOut.StatusLines = $statusLines
    if ($gitStatusOut.BranchName) {
        [PSCustomObject]$gitStatusOut
    } else {
        $statusLines
    }
}


