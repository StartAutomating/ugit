<#
.SYNOPSIS
    git status extension
.DESCRIPTION
    Returns git status as an object.

    git status provides a lot of useful information.
.EXAMPLE
    # Get the status of the current repository
    git status
.EXAMPLE
    # Get the untracked files
    git status |
        Select-Object -ExpandProperty Untracked
.EXAMPLE
    # Get the status of the repo in the current directory
    git status .
.EXAMPLE
    # Get untracked files in the current directory
    git status . |
        Select-Object -ExpandProperty Untracked
.EXAMPLE
    # See all git status can do
    git status | Get-Member
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern('^git status')]
param()

begin {
    <#
    If any of these parameters are used, we will skip processing.
    #>
    $SkipIf = 'porcelain' -join '|'
    if ($gitCommand -match "\s-(?>$SkipIf)") { break }

    $statusLines = @()
}

process {
    # collect all the status lines
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
        Unmerged   = @()
        GitRoot    = $GitRoot
        WorkingDirectory = if ("$PWD".StartsWith($GitRoot)) {
            $pwd
        } else {
            $gitRoot
        }
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
        if ($statusLines[$sln] -like "Unmerged*:*") {
            $inPhase = 'Unmerged'
            continue
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

            # If git quotes a status line, 
            # it means there are octal encoded characters in the path            
            if ($changePath -match '^"' -and $changePath -match '"$') {
                # So we want to change our change path.
                $changePath = [Regex]::Replace(
                    # First we trim leading and trailing quotes.  Easy.
                    $changePath -replace '^"|"$',
                    # Then we look for any sequence of slash + 3 digits [0-7]
                    "(?:\\[0-7]{3}){1,}",
                    # And replace them with this short script
                    {                        
                        param($match)
                        # We want them back as UTF8
                        [Text.Encoding]::UTF8.GetString(
                            # But these bytes are encoded with                            
                            # [ISO-8859-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1)
                            [Text.Encoding]::GetEncoding('ISO-8859-1').GetBytes(
                                # The match contains the sequence
                                @(
                                    foreach (
                                        # so we split it up
                                        # (which removes the slash)
                                        $octalByte in $match -split '\\' -ne ''
                                    ) {
                                        # then we convert each byte in base 8
                                        [Convert]::ToByte($octalByte,8) -as
                                            [char] # and make it a character
                                    }
                                ) -join '' # then we join our characters,
                            ) # get their bytes,
                        ) # and output the replaced string.
                    }
                )
            }
            $resolvedChangePath =
                try {
                    $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($changePath)
                    $resolvedFile = [IO.FileInfo]"$resolvedPath"
                    if ($resolvedFile.Length) {
                        $resolvedFile
                    } elseif (
                        $resolvedDirectory = [IO.DirectoryInfo]"$resolvedPath"
                    ) {
                        $resolvedDirectory
                    }                   
                } catch {
                    Write-Verbose "Could not resolve path '$changePath' : $_"
                }
            if ($inPhase -eq 'untracked') {                
                $gitStatusOut.$inPhase += $resolvedChangePath
            } else {
                $gitStatusOut.$inPhase += [PSCustomObject]@{
                    ChangeType = $changeType -replace '\s'
                    Path       = $changePath
                    File       = $resolvedChangePath
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


