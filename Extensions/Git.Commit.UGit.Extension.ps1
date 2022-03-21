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
    # If it doesn't look like the commit lines had a commit hash, output them directly
    if (-not ($commitLines -match '[a-f0-9]+\]')) {
        $commitLines
    }    
    else 
    {
        # Otherwise initialize commit information
        $commitInfo = [Ordered]@{
                FilesChanged = 0
                Insertions   = 0
                Deletions    = 0
                GitRoot      = $GitRoot
                PSTypeName   = 'git.commit.info'
        }
        # and walk over each line in the commit output.
        for ($cln = 0; $cln -lt $commitLines.Length; $cln++) {
            # If the line has the branch name and hash
            if ($commitLines[$cln] -match '^\[(?<n>\S+)\s(?<h>[a-f0-9]+)\]') { 
                $commitInfo.BranchName    = $matches.n # set .BranchName,
                $commitInfo.CommitHash    = $matches.h # set .CommitHash                                                       
                $commitInfo.CommitMessage =            # and set .CommitMessage to the rest of the line.
                    $commitLines[$cln] -replace '^\[[^\]]+\]\s+' 
            }
            elseif ($commitLines[$cln] -match '^\s\d+') # If the line starts with a space and digits 
            { 
                # It's the summary.  Split it on commas and remove most of the rest of the text.
                foreach ($commitLinePart in $commitLines[$cln] -split ',' -replace '[\s\w\(\)-[\d]]') {
                    
                    if ($commitLinePart.Contains('+')) { 
                        # If the part contains +, it's insertions.
                        $commitInfo.Insertions = $commitLinePart -replace '\+' -as [int]
                    }                     
                    elseif ($commitLinePart.Contains('-')) 
                    {
                        # If the part contains -, it's deletions.
                        $commitInfo.Deletions = $commitLinePart -replace '\-' -as [int]
                    } 
                    else
                    {
                        # Otherwise, its the file change count.
                        $commitInfo.FilesChanged = $commitLinePart -as [int]
                    }
                }                
            } 
            elseif ($commitInfo.BranchName) # Otherwise, if we already know the branch name
            {
                # add the line to the commit message.
                $commitInfo.CommitMessage += [Environment]::NewLine + $commitLines[$cln]
            }
        }
        # After we have walked thru all lines, output the commit info.
        [PSCustomObject]$commitInfo
    }
}
