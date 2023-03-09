function Use-Git
{
    <#
    .SYNOPSIS
        Use Git
    .DESCRIPTION
        Calls the git application, with whatever arguments are provided.

        Arguments can be provided with -GitArgument, which will automatically be bound to all parameters provided without a name.

        Input can also be piped in.

        If the input is a directory, Use-Git will Push-Location that directory.
        Otherwise, it will be passed as a positional argument (after any other arguments).

        Use-Git will combine errors and output, so that git output to standard error is handled without difficulty.
    .NOTES
        For almost everything git does, calling Use-Git is the same as calling git directly.

        If you have any difficulties passing parameters to git, try enclosing them in quotes.
    .LINK
        Out-Git
    .Example
        # Log entries are returned as objects, with properties and methods.
        git log -n 1 | Get-Member
    .Example
        # Status entries are converted into objects.
        git status
    .Example
        # Display untracked files.
        git status | Select-Object -ExpandProperty Untracked
    .Example
        # Display the list of branches, as objects.
        git branch
    .NOTES
        Use-Git will generate two events before git runs.  They will have the source identifiers of "Use-Git" and "Use-Git $GitArgument"
    #>
    [Alias('git')]
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess,ConfirmImpact='Low')]
    param(
    # Any arguments passed to git.  All positional arguments will automatically be passed to -GitArgument.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('GitArguments')]
    [string[]]
    $GitArgument,

    # An optional input object.
    # If the Input is a directory, Use-Git will Push-Location to that directory
    # Otherwise, it will be passed as a postional argument (after any other arguments)
    [Parameter(ValueFromPipeline)]
    [PSObject[]]
    $InputObject
    )

    begin {
        if (-not $script:CachedGitCmd) { # If we haven't cahced the git command
            # go get it.
            $script:CachedGitCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand('git', 'Application')
        }
        if (-not $script:CachedGitCmd) { # If we still don't have git
            throw "Git not found"        # throw.
        }
        if (-not $script:RepoRoots) {    # If we have not yet created a cache of repo roots
            $script:RepoRoots = @{}      # do so now.
        }

        $myInv = $MyInvocation
        $callstackPeek = @(Get-PSCallStack)[1]
        $callingContext =
            if ($callstackPeek.InvocationInfo.MyCommand.ScriptBlock) {
                @($callstackPeek.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
                    param($ast)
                        $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                        $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and
                        $ast -is [Management.Automation.Language.CommandAst]
                },$true))[0]
            }

        $argumentNumber = 0

        $gitArgsArray = [Collections.ArrayList]::new($GitArgument)

        foreach ($commandElement in $callingContext.CommandElements) {
            if ($commandElement.parameterName -in 'd', 'v', 'c') {
                # Insert the argument into the list
                $gitArgsArray.Insert(
                    $argumentNumber - 1, # ( don't forget to subtract one, because the command is an element)
                    $commandElement.Extent.ToString()
                )
                if ($commandElement.parameterName -in 'd', 'c', 'v') {
                    $ConfirmPreference = 'none' # so set confirm impact to none
                    $VerbosePreference = 'silentlyContinue'
                    $DebugPreference   = 'silentlyContinue'
                }
            }
            $argumentNumber++
        }

        $GitArgument = $gitArgsArray.ToArray()

        $progId = Get-Random

        # A small number of git operations do not require a repo.  List them here.
        $RepoNotRequired = 'clone','init','version','help','-C'

        $AllInputObjects = @()
    }

    process {
        # If there was piped in input
        if ($InputObject) {
            $AllInputObjects += $InputObject # accumulate it.
        }
    }

    end {
        # First, we need to take any input and figure out what directories we are going into.
        $directories = @()
        # Next, we need to create a collection of input object from each directory.
        $InputDirectories = [Ordered]@{}


        if (
            $AllInputObjects.Length -eq 0 -and # If we had no input objects and
            $myInv.PipelinePosition -gt 1 # are not the first step in the pipeline,
        ) {
            return # we're done.
        }

        $inputObject =
            @(foreach ($in in $AllInputObjects) {
                if ($in -is [IO.FileInfo]) { # If the input is a file
                    $in.Fullname             # return the full name of that file.
                    # If there are no directories
                    if (-not $directories) {
                        # initialize the collection to contain the current directory
                        $directories += @("$pwd")
                    }

                    if ($directories) {      # If we have directories
                        # Store this file in the input object by each directory.
                        $InputDirectories[$directories[-1]] =
                            # by forcing an existing entry into a list
                            @($InputDirectories[$directories[-1]]) +
                            $in.Fullname # and adding this file name.
                    }
                } elseif ($in -is [IO.DirectoryInfo]) {
                    $directories += Get-Item -LiteralPath $in.Fullname # If the input was a directory, keep track of it.
                } else {
                    # Otherwise, see if it was a path and it was a directory
                    if ((Test-Path $in -ErrorAction SilentlyContinue) -and
                        (Get-Item $in -ErrorAction SilentlyContinue) -is [IO.DirectoryInfo]) {
                        $directories += Get-Item $in
                    } else {

                        # If there are no directories
                        if (-not $directories) {
                            # initialize the collection to contain the current directory
                            $directories += @("$pwd")
                        }
                        if ($directories) {      # If we have directories
                            # Store this file in the input object by each directory.
                            $InputDirectories[$directories[-1]] =
                                # by forcing an existing entry into a list
                                @($InputDirectories[$directories[-1]]) +
                                $in # and adding this item.
                        }
                    }
                }
            })

        # git sometimes like to return information along standard error, and CI/CD and user defaults sometimes set $ErrorActionPreference to 'Stop'
        # So we change $ErrorActionPreference before we call git, just in case.
        $ErrorActionPreference = 'continue'

        # Before we process each directory, make a copy of the bound parameters.
        $paramCopy = ([Ordered]@{} + $PSBoundParameters)
        if ($GitArgument -contains '-c' -or $GitArgument -contains '-C') {
            $paramCopy.Remove('Confirm')
        }

        # Now, we will force there to be at least one directory (the current path).
        # This makes the code simpler, because we are always going thru a loop.
        if (-not $directories) {
            if ($GitArgument -ccontains '-C') {
                $directories = $gitArgument[$GitArgument.IndexOf('-C') + 1]
            } else {
                $directories = @($pwd)
            }
        } else {
            # It also gives us a change to normalize the directories into their full paths.
            $directories = @(foreach ($dir in $directories) {
                if ($dir.Fullname) {
                    $dir.Fullname
                } elseif ($dir.Path) {
                    $dir.Path
                } else {
                    $dir
                }
            })
        }


        $dirCount, $dirTotal = 0, $AllInputObjects.Length

        # For each directory we know of, we
        :nextDirectory foreach ($dir in $directories) {
            Push-Location -LiteralPath $dir                 # push into that directory.

            # If there was no directory
            if (-not $InputDirectories[$dir]) {
                $InputDirectories[$dir] = @($null) # go over an empty collection
            }

            foreach ($inObject in $InputDirectories[$dir]) {
                if (-not $inObject -and $myInv.PipelinePosition -gt 1) { continue }
                $AllGitArgs = @(@($GitArgument) + $inObject)    # Then we collect the combined arguments
                $AllGitArgs = @($AllGitArgs -ne '')             # (skipping any empty arguments)
                $OutGitParams = @{GitArgument=$AllGitArgs}      # and prepare a splat (to save precious space when reporting errors).
                $dirCount++

                if ($WhatIfPreference) {
                    [ScriptBlock]::Create("git $($allGitArgs -join ' ')") |
                        Add-Member NoteProperty GitRoot $dir -Force -PassThru
                    Pop-Location
                    continue
                }


                if (-not $script:RepoRoots[$dir]) {             # and see if we have a repo root
                    $script:RepoRoots[$dir] =
                        @("$(& $script:CachedGitCmd rev-parse --show-toplevel *>&1)") -like "*/*" -replace '/', [io.path]::DirectorySeparatorChar
                    if (-not $script:RepoRoots[$dir] -and      # If we did not have a repo root
                        -not ($gitArgument -match "(?>$($RepoNotRequired -join '|'))") # and we are not doing an operation that does not require one
                    ) {
                        Write-Warning "'$($dir)' is not a git repository" # warn that there is no repo (#21)
                        Pop-Location # pop back out of the directory
                        continue nextDirectory # and continue to the next directory.
                    }
                }

                $OutGitParams.GitRoot = "$($script:RepoRoots[$dir])"
                Write-Verbose "Calling git with $AllGitArgs"

                if ($dirCount -gt 1) {
                    # Clamp percentage complete within 0-100
                    $percentageComplete = [Math]::Max(
                        [Math]::Min(
                            [Math]::Round(
                                ([double]$dirCount / $dirTotal) * 100
                            ), 100
                        ),
                    0)
                    Write-Progress -PercentComplete $percentageComplete -Status "git $allGitArgs " -Activity "$($dir) " -Id $progId
                }

                # If we have indicated we do not care about -Confirmation, don't prompt
                if (($ConfirmPreference -eq 'None' -and (-not $paramCopy.Confirm)) -or
                    $PSCmdlet.ShouldProcess("$pwd : git $allGitArgs") # otherwise, as for confirmation to run.
                ) {
                    $eventSourceIds = @("Use-Git","Use-Git $allGitArgs")
                    $messageData = @{
                        GitRoot = "$pwd"
                        GitCommand = @(@("git") + $AllGitArgs) -join ' '
                    }
                    $null =
                        foreach ($sourceIdentifier in $eventSourceIds) {
                            New-Event -SourceIdentifier $sourceIdentifier -MessageData $messageData
                        }
                    & $script:CachedGitCmd @AllGitArgs *>&1       | # Then we run git, combining all streams into output.
                                                                    # then pipe to Out-Git, which will
                        Out-Git @OutGitParams # output git as objects.

                        # These objects are decorated for the PowerShell Extended Type System.
                        # This makes them easy to extend and customize their display.
                        # If Out-Git finds one or more extensions to run, these can parse the output.
                }

            }


            Pop-Location # After we have run, Pop back out of the location.
        }
        if ($dirCount -gt 1) {
            Write-Progress -completed -Status "$allGitArgs " -Activity " " -Id $progId
        }
    }
}
