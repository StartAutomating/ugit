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
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("^git remote")]                  # that is run when the switch -o is used.
[OutputType('git.remote.name','git.remote.uri', 'git.remote')]
param(   )

begin {
    $remoteLines = @()
}

process {
    $remoteLines += $_
}

end {
    if ($gitArgument -match '--(?>n|dry-run)') {
        return $remoteLines
    }

    if ($remoteLines[0] -like 'usage:*') {
        return $remoteLines
    }

    switch -Regex ($gitCommand) {
        'git remote\s{0,}$' {
            return [PSCustomObject][Ordered]@{
                PSTypename    = 'git.remote.name'
                RemoteName = $remoteLines -join ' ' -replace '\s'
                GitRoot       = $gitRoot
            }
        }
        'git remote get-url (?<RemoteName>\S+)\s{0,}$' {
            return [PSCustomObject][Ordered]@{
                PSTypename       = 'git.remote.url'
                RemoteName    = $matches.RemoteName
                RemoteUrl     = $remoteLines -join ' ' -replace '\s'
                GitOutputLines   = $remoteLines                                
                GitRoot          = $gitRoot
            }
        }
        'git remote show (?<RemoteName>\S+)\s{0,}$' {
            $remoteName       = $matches.RemoteName
            $gitRemoteUrls    = [ordered]@{
                PSTypeName    = 'git.remote.urls'                
            }
            $remoteBranches   = @()
            $localBranches    = @()
            $trackedUpstreams = @()
            $headBranch       = 
            $inSection        = ''
            foreach ($line in $remoteLines) {
                if ($line -match '^\*\sremote\s(?<RemoteName>\S+)') {

                }
                elseif ($line -match 'URL:') {
                    $purpose, $remoteUrl = $line -split 'URL:'
                    $gitRemoteUrls[$purpose -replace '\s'] = $remoteUrl -replace '\s'
                }
                elseif ($line -match '^\s{1,}HEAD branch:') {
                    $headBranch = $line -replace '^\s{1,}HEAD branch:' -replace '\s'
                }
                elseif ($line -match '^\s{2}Remote Branches:') {
                    $inSection = 'Remote Branches'
                }
                elseif ($line -match "^\s{2}Local branches configured for 'git pull':") {
                    $inSection = 'LocalBranches'
                }
                elseif ($line -match "^\s{2}Local refs configured for 'git push':") {
                    $inSection = 'LocalRefs'
                }
                elseif ($inSection -and $line -match '^\s{4}') {
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
            return $remoteLines
        }
    }
}

