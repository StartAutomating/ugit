<#
.SYNOPSIS
    git commit extension
.DESCRIPTION
    Returns output from succesful git commits as objects.
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern("^git commit")]
[OutputType('git.commit.info')]
param()

begin {
    $commitLines = @()
}

process {
    $commitLines += $gitOut
}

end {
    if ($commitLines -match '[a-f0-9]+\]') {
        $commitInfo = [Ordered]@{FilesChanged=0;Insertions=0;Deletions=0;GitRoot=$GitRoot;PSTypeName='git.commit.info'}
        for ($cln = 0; $cln -lt $commitLines.Length; $cln++) {
            if ($commitLines[$cln] -match '^\[(?<n>\S+)\s(?<h>[a-f0-9]+)\]') {
                $commitInfo.BranchName = $matches.n
                $commitInfo.CommitHash = $matches.h
                $commitInfo.CommitMessage = $commitLines[$cln] -replace '^\[[^\]]+\]\s+'
            }
            elseif ($commitLines[$cln] -match '^\s\d+') {
                foreach ($commitLinePart in $commitLines[$cln] -split ',' -replace '[\s\w\(\)-[\d]]') {
                    if ($commitLinePart.Contains('+')) {
                        $commitInfo.Insertions = $commitLinePart -replace '\+' -as [int]
                    } elseif ($commitLinePart.Contains('-')) {
                        $commitInfo.Deletions = $commitLinePart -replace '\-' -as [int]
                    } else {
                        $commitInfo.FilesChanged = $commitLinePart -as [int]
                    }
                }                
            } 
            elseif ($commitInfo.BranchName) {
                $commitInfo.CommitMessage += [Environment]::NewLine + $commitLines[$cln]
            }
        }
        [PSCustomObject]$commitInfo
    } else {
        $commitLines
    }
}
