﻿function Use-Git
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
    [Alias('git','realgit','gitreal')]
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

    dynamicParam {
        # To get dynamic parameters, we need to look at our invocation
        $myInv = $MyInvocation

        # and peek up the callstack.
        $callstackPeek = @(Get-PSCallStack)[-1]
        $callingContext =
            if ($callstackPeek.InvocationInfo.MyCommand.ScriptBlock) {
                @($callstackPeek.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
                    param($ast)
                        $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                        $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and
                        $ast -is [Management.Automation.Language.CommandAst]
                },$true))[0]
            }
        
        # This will give us something to validate against, so we don't get dynamic parameters for everything
        $ToValidate = 
            if (-not $callingContext -and 
                $callstackPeek.Command -like 'TabExpansion*' -and 
                $callstackPeek.InvocationInfo.BoundParameters.InputScript
                ) {
                $callstackPeek.InvocationInfo.BoundParameters.InputScript.ToString()
            } 
            elseif ($callingContext) {
                $callingContext.CommandElements -join ' '
            }
            elseif ($myInv.Line) {                
                $myInv.Line.Substring($myInv.OffsetInLine - 1) -replace '\|\s{0,}$'
            }
        
        # If there's nothing to validate, there are no dynamic parameters.
        if (-not $ToValidate) { return }

        # Get dynamic parameters that are valid for this command
        $dynamicParameterSplat = [Ordered]@{
            CommandName='Use-Git'
            ValidateInput=$ToValidate
            DynamicParameter=$true
            DynamicParameterSetName='__AllParameterSets'
            NoMandatoryDynamicParameter=$true
        }        
        $myDynamicParameters = Get-UGitExtension @dynamicParameterSplat
        if (-not $myDynamicParameters) { return }
        
        # Here's where things get a little tricky.
        # we want to make as much muscle memory work as possible, so we don't wany any dynamic parameter that is not "fully" mapped.
        # So we need to walk over each command element.
        
        if (-not ($callingContext -or ($callstackPeek.Command -like 'TabExpansion*'))) {
            # (bonus points - within Pester, we cannot callstack peek effectively, and need to use the invocation line)
            # Therefore, when testing dynamic parameters, assign to a variable (because parenthesis and pipes may make this an invalid ScriptBlock)
            $callingContext = try {
                    [scriptblock]::Create($ToValidate).Ast.EndBlock.Statements[0].PipelineElements[0]
            } catch { 
                # If we failed to create the script block, the error is noise.
                $err = $_
                Write-Debug -Message "Failed to create script block from '$ToValidate' : $($err.Exception.Message)"                
            }
            if ((-not $callingContext) -and $error.Count) { $error.RemoveAt(0)}
        }
        foreach ($commandElement in $callingContext.CommandElements) {
            if (-not $commandElement.parameterName) { continue } # that is a Powershell parameter
            foreach ($dynamicParam in @($myDynamicParameters.Values)) {
                $dynamicParameterAliases = $dynamicParam.Attributes.AliasNames
                if (
                    (
                        # If it started with this name
                        $dynamicParam.Name.StartsWith($commandElement.parameterName, 'CurrentCultureIgnoreCase') -and 
                        # but was not the full parameter name, we might want to remove it.
                        $dynamicParam.Name -ne $commandElement.parameterName
                    ) -and # To be as sure as we can be, 
                    (   
                        # we only remove the parameter if it has no aliases                        
                        (-not $dynamicParameterAliases) -or # or
                        (             
                            # the dynamic parameter had aliases        
                            $dynamicParameterAliases.Attributes.AliasNames -and                            
                            $(
                                # at least one starts with the parameter name
                                $AliasesLikeElement = $dynamicParam.Attributes.AliasNames -like "$($commandElement.parameterName)*"
                                # and does not contain the exact parameter name.
                                $AliasesLikeElement -and $AliasesLikeElement -notcontains $commandElement.parameterName
                            )
                        )
                    )
                ) {
                    $null = $myDynamicParameters.Remove($dynamicParam.Name)
                }
            }
        }
        $myDynamicParameters    
    }

    begin {
        $myInv = $MyInvocation
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

        $gitArgsArray = [Collections.ArrayList]::new()
        if ($GitArgument.Length) {
            $gitArgsArray.AddRange($GitArgument)
        }

        :nextCommandElement foreach ($commandElement in $callingContext.CommandElements) {            
            if (-not $commandElement.parameterName) { $argumentNumber++; continue }
            $paramName = $commandElement.parameterName                        
            if ($paramName -in 'd', 'c', 'v') {
                # Insert the argument into the list
                $gitArgsArray.Insert(
                    $argumentNumber - 1, # ( don't forget to subtract one, because the command name is an element)
                    $commandElement.Extent.ToString()
                )
                if ($paramName -eq 'c') {
                    $ConfirmPreference = 'none' # so set confirm preference to none
                }
                $VerbosePreference = 'silentlyContinue'
                $DebugPreference   = 'silentlyContinue'
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

        $pipedInDirectories = $false

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
                    $pipedInDirectories = $true
                    $directories += Get-Item -LiteralPath $in.Fullname # If the input was a directory, keep track of it.
                } else {
                    # Otherwise, see if it was a path and it was a directory
                    if ((Test-Path $in -ErrorAction SilentlyContinue) -and
                        (Get-Item $in -ErrorAction SilentlyContinue) -is [IO.DirectoryInfo]) {
                        $pipedInDirectories = $true
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

            $dirCount++

            if (-not $script:RepoRoots[$dir]) {             # and see if we have a repo root
                $script:RepoRoots[$dir] =
                    @("$(& $script:CachedGitCmd rev-parse --show-toplevel *>&1)") -like "*/*" -replace '/', [io.path]::DirectorySeparatorChar
                if (-not $script:RepoRoots[$dir] -and      # If we did not have a repo root
                    -not ($gitArgument -match "(?>$($RepoNotRequired -join '|'))") # and we are not doing an operation that does not require one
                ) {
                    Write-Verbose "'$($dir)' is not a git repository" # write that there is no repo to verbose (#21 , #198, #204)
                    Pop-Location # pop back out of the directory
                    continue nextDirectory # and continue to the next directory.
                }
            }
            
            # Walk over each input for each directory
            :nextInput foreach ($inObject in $InputDirectories[$dir]) {
                # Continue if there was no input and we were not the first step of the pipeline that was not a directory.
                if (-not $inObject -and (
                        $myInv.PipelinePosition -gt 1
                ) -and -not $pipedInDirectories) { continue }                
                
                $AllGitArgs = @(@($GitArgument) + $inObject)    # Then we collect the combined arguments

                $GitCommand = "git $AllGitArgs"

                $validInputExtensions = Get-UGitExtension -CommandName Use-Git -ValidateInput $GitCommand

                # Get any arguments from extensions
                $extensionOutputs = @(
                    Get-UGitExtension -CommandName Use-Git -Run -Parameter $paramCopy -Stream -ValidateInput $GitCommand
                )

                # By default, we want to run git
                $RunGit = $true
                # with whatever strings came back from extensions as additional arguments.
                $extensionArgs = @()
                
                # So we walk over each output from the extensions
                foreach ($extensionOutput in $extensionOutputs) {
                    if ($extensionOutput -is [string]) {
                        # and accumulate string arguments.
                        $extensionArgs += $extensionOutput
                    } else {
                        # However, if we have non-string arguments
                        $extensionOutput # output them directly
                        $RunGit = $false # and do not run git.
                    }
                }

                # If we don't want to run git, continue.
                if (-not $RunGit) { continue }
                
                if ($inObject -isnot [string] -and 
                    $inObject.ToString -isnot [Management.Automation.PSScriptMethod]) {
                    Write-Verbose "InputObject was not a string or customized object, not passing down to git."
                    $inObject = $null
                }

                 # Then we collect the combined arguments
                $AllGitArgs = @(                    
                    $GitArgument[0]
                    foreach ($xa in $extensionArgs) {
                        if (-not $xa.AfterInput) {
                            $xa
                        }
                    }
                    if ($GitArgument.Length -gt 1) {
                        $GitArgument[1..($gitArgument.Length - 1)]
                    }
                    $inObject
                    foreach ($xa in $extensionArgs) {
                        if ($xa.AfterInput) {
                            $xa
                        }
                    }                    
                )
                
                $AllGitArgs = @($AllGitArgs -ne '')             # (skipping any empty arguments)
                $OutGitParams = @{GitArgument=$AllGitArgs}      # and prepare a splat (to save precious space when reporting errors).

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

                # If -WhatIf was passed, $WhatIfPreference will be true.
                if ($WhatIfPreference) {
                    # If that's the case, return the command line we would execute.
                    "git $AllGitArgs"
                }

                # otherwise, if we have indicated we do not want to -Confirm, don't prompt.
                elseif (($ConfirmPreference -eq 'None' -and (-not $paramCopy.Confirm)) -or
                    $PSCmdlet.ShouldProcess("$pwd : git $allGitArgs") # otherwise, prompt for confirmation to run.
                ) {
                    $eventSourceIds = @("Use-Git","Use-Git $allGitArgs")
                    $messageData = [Ordered]@{
                        GitCommand = @(@("git") + $AllGitArgs) -join ' '
                        GitRoot = "$pwd"
                    }                    

                    $null =
                        foreach ($sourceIdentifier in $eventSourceIds) {
                            New-Event -SourceIdentifier $sourceIdentifier -MessageData $messageData
                        }

                    if ($myInv.InvocationName -in 'realgit', 'gitreal') {
                        & $script:CachedGitCmd @AllGitArgs *>&1
                    } else {
                        & $script:CachedGitCmd @AllGitArgs *>&1       | # Then we run git, combining all streams into output.
                                                                        # then pipe to Out-Git, which will
                            Out-Git @OutGitParams # output git as objects.

                            # These objects are decorated for the PowerShell Extended Type System.
                            # This makes them easy to extend and customize their display.
                            # If Out-Git finds one or more extensions to run, these can parse the output.
                    }
                }

            }


            Pop-Location # After we have run, Pop back out of the location.
        }
        if ($dirCount -gt 1) {
            Write-Progress -completed -Status "$allGitArgs " -Activity " " -Id $progId
        }
    }
}
