<#
.SYNOPSIS
    Parses git blame output
.DESCRIPTION
    Parses the output of git blame.
.EXAMPLE    
    git blame ugit.psd1    
#>
[Management.Automation.Cmdlet("Out","Git")]            # It's an extension for Out-Git
[ValidatePattern("^u?git blame",Options='IgnoreCase')] # when the pattern is "git blame"
param()

begin {
    $gitBlameOutput = @()
    $blameHeaderPattern = @(
        '(?<CommitHash>[0-9a-f]{8})\s'
        
        # If your filename contains parenthesis, this may not work, and you'll only have yourself to blame.
        '(?:(?<FileName>[\S-[\(]]+)\s)?' 
        
        '\((?<WhoWhenWhat>.+?)\)'
    ) -join ''
    $blameRevision = @($gitCommand -split '\s' -notmatch '^--')[-1]
}

process {
    $gitBlameOutput += $gitout    
}

end {
    $blameObjects = @(
        foreach ($gitBlameLine in $gitBlameOutput) {
            if ($gitBlameLine -notmatch $blameHeaderPattern) { continue }
            $lineContent  = $gitBlameLine -replace $blameHeaderPattern            
            $commitMatch = [Ordered]@{} + $matches
            $whoWhenWhat = $commitMatch.WhoWhenWhat -split '\s+'
            
            [PSCustomObject][Ordered]@{
                PSTypeName = 'git.blame'
                CommitHash = $commitMatch.CommitHash
                CommitDate = ($whoWhenWhat[-4..-2] -join ' ') -as [DateTime]
                Line       = $whoWhenWhat[-1]
                File       = $matches.File
                Revision   = $blameRevision
                Content    = $lineContent
                GitRoot    = $GitRoot
                Author     = $whoWhenWhat[0..$(
                    ($whoWhenWhat.Length - 5)
                )] -join ' '
                GitOutputLines = $gitBlameLine
            }
        }
    )

    if ($blameObjects) {
        $blameObjects
    } else {
        $gitBlameOutput
    }
}

