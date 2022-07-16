<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
    git stash list
#>
[Management.Automation.Cmdlet("Out","Git")]           # It's an extension for Out-Git
[ValidatePattern("^git stash",Options='IgnoreCase')] # when the pattern is "git branch"
param(

)

begin {
    $stashLines = @()
    $outputBase = [Ordered]@{GitRoot=$GitRoot;Gitcommand=$GitCommand}
}

process {
    $stashLines += $_
}

end {
    $stashOutputHandled = $false
    
    $stashLineNumber = 0
    $gitStashOut     = [Ordered]@{
        GitRoot = $GitRoot
        GitCommand = $GitCommand
        GitOutputLines = $stashLines
    }


    if ($GitCommand -match 'stash show(?:\s\d+)? -(?>p|-patch)') {        
        return
    }


    $inPhase     = ''
    foreach ($stashLine in $stashLines) {
        $stashLineNumber++
        if ($stashLine -eq 'No local changes to save') {
            return [PSCustomObject]([Ordered]@{
                PSTypeName = 'git.stash.nothing'                
            } + $gitStashOut)
        }

        if ($GitCommand -match '^git stash list') {
            if ($stashLine -match '^stash\@\{(?<Number>\d+)\}:\s{0,}(?<Message>.+$)') {
                $stashOutputHandled = $true
                [PSCustomObject]([Ordered]@{
                    PSTypeName = 'git.stash.entry'
                    Number  = [int]$matches.Number
                    Message = $matches.Message                    
                } + $gitStashOut)
            }
        }

        if ($GitCommand -eq 'git stash' -and 
            $stashLine -match 'Saved working directory and index state\s{0,}(?<Message>.+$)') {
            $stashOutputHandled = $true
            [PSCustomObject]([Ordered]@{
                PSTypeName = 'git.stash.entry'
                Number  = [int]0
                Message = $matches.Message
            } + $gitStashOut)                                     
        }

        if ($GitCommand -match '^git stash (?>pop|apply)') {
            if ($stashLineNumber -eq 1) {
                $gitStashOut.BranchName = @($stashLine -split ' ' -ne '')[-1] 
            }
            if ($stashLine -like '*not staged for commit:*') {
                # When on a new branch with no upstream, this comes first.
                $inPhase = 'Unstaged'
                continue
            }
            if ($stashLine -like "Changes to be committed:*") {
                $inPhase = 'Staged'
                continue
            }
            if ($stashLine -like "Untracked files:*") {
                $inPhase = 'Untracked'
                continue
            }

            if ($stashLineNumber -eq 2 -and -not $inPhase) {
                $gitStashOut.Status = $stashLine
                continue
            }

            if ($stashLine -match '^\s+\(') { continue }
            if ($stashLine -match '^\s+' -and $inPhase) {
                $trimmedLine = $stashLine.Trim()
                $changeType = 
                    if ( $trimmedLine -match "^([\w\s]+):") {
                        $matches.1
                    } else {
                        ''
                    }
                $changePath = $trimmedLine -replace "^[\w\s]+:\s+"
                if ($inPhase -eq 'untracked') {
                    $gitStashOut.$inPhase += Get-Item -ErrorAction SilentlyContinue -Path $changePath
                } else {
                    $gitStashOut.$inPhase += [PSCustomObject]@{
                        ChangeType = $changeType -replace '\s'
                        Path       = $changePath
                        File       = Get-Item -ErrorAction SilentlyContinue -Path $changePath
                    }
                }                
            }            
        }

        if ($stashLine -match '^Dropped refs/stash\@\{(?<Number>\d+)\}\s\((?<CommitHash>[a-f0-9]+)\)') {
            $dropInfo = [Ordered]@{
                Number = [int]$matches.Number
                CommitHash = $matches.CommitHash
            }
            
            if ($GitCommand -match '^git stash drop') {
                return [PSCustomObject]([Ordered]@{
                    PSTypeName = 'git.stash.drop'
                } + $dropInfo + $gitStashOut)
            } else {
                $gitStashOut.Dropped = [PSCustomObject]([Ordered]@{
                    PSTypeName = 'git.stash.drop'                    
                } + $dropInfo)
            }
        }
    }

    if ($GitCommand -match '^git stash (?<action>(?>apply|pop))') {
        $stashOutputHandled = $true
        [PSCustomObject]([Ordered]@{
            PSTypeName = "git.stash.apply"
        } + $gitStashOut)
    }

    if (-not $stashOutputHandled) {
        $stashLines
    }
}
