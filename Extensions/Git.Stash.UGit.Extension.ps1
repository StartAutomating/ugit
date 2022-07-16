<#
.SYNOPSIS
    git stash extension
.DESCRIPTION
    Manages git code stashes.  Returns objects wherever possible.
.EXAMPLE
    git stash list
#>
[Management.Automation.Cmdlet("Out","Git")]           # It's an extension for Out-Git
[ValidatePattern("^git stash",Options='IgnoreCase')] # when the pattern is "git branch"
param()

begin {
    # Prepare to collect of the output lines
    $stashLines = @()
}

process {
    # Accumulate each output line when it comes it.
    $stashLines += $_
}

end {
    # If we don't know how to handle output, we want to output normally.
    # So keep track if we know.
    $stashOutputHandled = $false
    
    # If the command is stash show --patch,
    if ($GitCommand -match 'stash show(?:\s\d+)? -(?>p|-patch)') {
        # the diff extension will actually be handling things.        
        return
    }
    
    # Create a base output object
    $gitStashOut     = [Ordered]@{
        GitRoot = $GitRoot
        GitCommand = $GitCommand
        GitOutputLines = $stashLines
    }

    if ($GitCommand -match '^git stash (?>apply|pop)') {
        $gitStashOut += [Ordered]@{
            Unstaged = @()
            Untracked = @()
            Staged = @()
        }
    }

    # When popping or applying a stash,
    # we will need to know which line we're on
    $stashLineNumber = 0
    # and which phase we are in.
    $inPhase     = ''

    # Walk over all stash lines.
    foreach ($stashLine in $stashLines) {
        # Increment the counter
        $stashLineNumber++
        # If the line is "No local changes to save"
        if ($stashLine -eq 'No local changes to save') {
            # return a 'git.stash.nothing' object.
            return [PSCustomObject]([Ordered]@{
                PSTypeName = 'git.stash.nothing'                
            } + $gitStashOut)
        }

        # If the command was git stash list,
        if ($GitCommand -match '^git stash list') {
            # match lines that describe a stash,
            if ($stashLine -match '^stash\@\{(?<Number>\d+)\}:\s{0,}(?<Message>.+$)') {
                # indicate output was handled,
                $stashOutputHandled = $true
                # and output a 'git.stash.entry' for that line.
                [PSCustomObject]([Ordered]@{
                    PSTypeName = 'git.stash.entry'
                    Number  = [int]$matches.Number
                    Message = $matches.Message
                } + $gitStashOut)
            }
        }

        # If the command was git stash (and it saved),
        if ($GitCommand -eq 'git stash' -and
            $stashLine -match 'Saved working directory and index state\s{0,}(?<Message>.+$)') {
            # mark output as handled
            $stashOutputHandled = $true
            # and return a stash entry object.
            [PSCustomObject]([Ordered]@{
                PSTypeName = 'git.stash.entry'
                Number  = [int]0
                Message = $matches.Message
            } + $gitStashOut)                                     
        }

        # If we are popping or applying a stash
        if ($GitCommand -match '^git stash (?>pop|apply)') {
            # The first line contains the branch name
            if ($stashLineNumber -eq 1) {
                # (in the last word).
                $gitStashOut.BranchName = @($stashLine -split ' ' -ne '')[-1] 
            }
            # Everything else returns like git status.
            # use certain lines to indicate we are changing phases
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

            # The second line should contain the status
            if ($stashLineNumber -eq 2 -and -not $inPhase) {
                $gitStashOut.Status = $stashLine
                continue
            }

            # We can ignore lines that begin with whitespace and parenthesis
            if ($stashLine -match '^\s+\(') { continue }
            # Lines that start with whitespace tell us what files were applied
            if ($stashLine -match '^\s+' -and $inPhase) {
                $trimmedLine = $stashLine.Trim()
                $changeType = 
                    # The changetype will be in parenthesis
                    if ( $trimmedLine -match "^([\w\s]+):") {
                        $matches.1
                    } else {
                        ''
                    }
                # The path of the change will be the content after the colon
                $changePath = $trimmedLine -replace "^[\w\s]+:\s+"
                # store the file in the appropriate collection on the object.
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

        # If the stash line indicates a dropped ref
        if ($stashLine -match '^Dropped refs/stash\@\{(?<Number>\d+)\}\s\((?<CommitHash>[a-f0-9]+)\)') {
            # Create the drop info
            $dropInfo = [Ordered]@{
                Number = [int]$matches.Number
                CommitHash = $matches.CommitHash
            }
            
            # If the command was 'git stash drop'
            if ($GitCommand -match '^git stash drop') {
                # return the drop info
                return [PSCustomObject]([Ordered]@{
                    PSTypeName = 'git.stash.drop'
                } + $dropInfo + $gitStashOut)
            } else {
                # Otherwise, add this to the gitStashOutput.
                $gitStashOut.Dropped = [PSCustomObject]([Ordered]@{
                    PSTypeName = 'git.stash.drop'                    
                } + $dropInfo)
            }
        }
    }

    # If the command was git stash apply or pop
    if ($GitCommand -match '^git stash (?>apply|pop)') {
        # indicate output was handled
        $stashOutputHandled = $true
        # and return a 'git.stash.apply' object.
        [PSCustomObject]([Ordered]@{
            PSTypeName = "git.stash.apply"
        } + $gitStashOut)
    }

    # If we still had nothing handling output
    if (-not $stashOutputHandled) {
        $stashLines # output the stash lines as-is.
    }
}
