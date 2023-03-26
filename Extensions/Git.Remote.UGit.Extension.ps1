<#
.Synopsis
    Git Remotes Extension
.Description
    Outputs git remotes as objects.
.EXAMPLE
    git remote
.EXAMPLE
    git remote | git remote get-url
.EXAMPLE
    git remote | git remote show
#>
[Management.Automation.Cmdlet("Out","Git")]       # It's an extension for Out-Git
[ValidatePattern("^git remote")]                  # that is run when the command starts with git remote.
[OutputType('git.remote.name','git.remote.uri', 'git.remote')]
param(   )

begin {
    $remoteLines = @()
}

process {
    $remoteLines += $_
}

end {
    
    if ($gitArgument -match '--(?>n|dry-run)' -or # If the arguments matched --n or --dry-run or
        $remoteLines[0] -like 'usage:*'           # the output lines started with usage:
    )  {
        return $remoteLines # return the output directly.
    }

    # git remote can do a few different things
    switch -Regex ($gitCommand) {
        'git remote\s{0,}$' {
            # With no other parameters, it returns the remote name.
            foreach ($remoteLine in $remoteLines) {
                if (-not $remoteLine.Trim()) {
                    continue
                }
                [PSCustomObject][Ordered]@{
                    PSTypename    = 'git.remote.name'
                    RemoteName = $remoteLine -join ' ' -replace '\s'
                    GitRoot       = $gitRoot
                }
            }
        }
        'git remote get-url (?<RemoteName>\S+)\s{0,}$' {

            foreach ($remoteline in $remoteLines) {
                if (-not $remoteLine.Trim()) {
                    continue
                }
                # With get-url, it returns the URL
                return [PSCustomObject][Ordered]@{
                    PSTypename       = 'git.remote.url'
                    RemoteName    = $matches.RemoteName
                    RemoteUrl     = $remoteLines -join ' ' -replace '\s'
                    GitOutputLines   = $remoteLines                                
                    GitRoot          = $gitRoot
                }
            }            
        }
        'git remote show (?<RemoteName>\S+)\s{0,}$' {
            # With show, it returns _a lot_ of stuff.  We want to track: 
            $remoteName       = $matches.RemoteName
            # * Each named URL
            $gitRemoteUrls    = [ordered]@{
                PSTypeName    = 'git.remote.urls'                
            }
            # * All remote branches
            $remoteBranches   = @()
            # * All local branches
            $localBranches    = @()
            # * All tracked upstream branches
            $trackedUpstreams = @()
            # * The Head branch
            $headBranch       = ''            
            $inSection        = ''
            # We go thru each line returned by git remote show
            foreach ($line in $remoteLines) {
                if ($line -match '^\*\sremote\s(?<RemoteName>\S+)') {
                    # We can ignore the first line (we already know the remote name)
                }
                elseif ($line -match 'URL:') {
                    # Lines containing URL: can be split into a purpose and URL.
                    $purpose, $remoteUrl = $line -split 'URL:'
                    $gitRemoteUrls[$purpose -replace '\s'] = $remoteUrl -replace '\s'
                }
                elseif ($line -match '^\s{1,}HEAD branch:') {
                    # The head branch line is helpfully marked.
                    $headBranch = $line -replace '^\s{1,}HEAD branch:' -replace '\s'
                }
                elseif ($line -match '^\s{2}Remote Branches:') {
                    # as are the names of each section
                    $inSection = 'Remote Branches'
                }
                elseif ($line -match "^\s{2}Local branches configured for 'git pull':") {
                    $inSection = 'LocalBranches'
                }
                elseif ($line -match "^\s{2}Local refs configured for 'git push':") {
                    $inSection = 'LocalRefs'
                }
                elseif ($inSection -and $line -match '^\s{4}') {
                    # Within each section, we'll want capture a branch name and status
                    if ($inSection -eq 'Remote Branches') {
                        $remoteBranch, $status, $null = $line -split '\s{1,}' -ne ''
                        $remoteBranches += [PSCustomObject][Ordered]@{
                            PSTypename = 'git.remote.branch'
                            BranchName = $remoteBranch
                            Status     = $status
                        }
                    }
                    elseif ($inSection -eq 'Local Branches') {
                        $localBranch, $status = $line -split '\s{1,}' -ne ''
                        $status = $status -join ' '
                        $localBranches += [PSCustomObject][Ordered]@{
                            PSTypename = 'git.remote.local.branch'
                            BranchName = $localBranch
                            Status     = $status
                        }
                    }
                    elseif ($inSection -eq 'LocalRefs') {
                        $localBranch, $status = $line -split '\s{1,}' -ne ''
                        $status = $status -join ' '
                        $trackedUpstreams += [PSCustomObject][Ordered]@{
                            PSTypename = 'git.remote.tracked.upstream'
                            BranchName = $localBranch
                            Status     = $status
                        }
                    }
                }                
            }

            # Now we can return a custom object with all of the data from git.remote.show, and let the formatter do the work.
            return [PSCustomObject][Ordered]@{
                PSTypename       = 'git.remote.show'
                RemoteName       = $remoteName
                HeadBranch       = $headBranch
                RemoteURLs       = [PSCustomObject]$gitRemoteUrls
                RemoteBranches   = $remoteBranches
                LocalBranches    = $localBranches
                TrackedUpstreams = $trackedUpstreams
                GitOutputLines   = $remoteLines
                GitRoot          = $gitRoot
            }
        }

        default {
            # If it wasn't any scenario we know how to parse, return the lines as-is.
            return $remoteLines
        }
    }
}

