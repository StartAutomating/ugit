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

        Use-Git will combine errors and output, 
    .NOTES        
        For almost everything git does, calling Use-Git is the same as calling git directly.

        The exceptions are short, single-character parameters, like -v and -d.
        These get mapped to PowerShell parameters, like -Verbose and -Debug.
        To ensure a parameter is passed to git, instead of interpreted as as PowerShell parameter, simply enclose it in quotes.
    .LINK
        Out-Git
    #>
    [Alias('git')]
    [CmdletBinding(PositionalBinding=$false)]
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
    }

    process {
        # First, we need to take any input and figure out what directories we are going into.
        $directories = @()
        $inputObject = 
            @(foreach ($in in $inputObject) {
                if ($in -is [IO.FileInfo]) { # If the input is a file
                    $in.Fullname             # return the full name of that file.
                } elseif ($in -is [IO.DirectoryInfo]) {
                    $directories += $in.Fullname # If the input was a directory, keep track of it.
                } else {
                    # Otherwise, see if it was a path and it was a directory
                    if ((Test-Path $in -ErrorAction SilentlyContinue) -and 
                        (Get-Item $in -is [IO.DirectoryInfo] -ErrorAction SilentlyContinue)) {
                        $directories += Get-Item $in -is [IO.DirectoryInfo]
                    } else {
                        $in
                    }
                }
            })

        # git sometimes like to return information along standard error, and CI/CD and user defaults sometimes set $ErrorActionPreference to 'Stop'
        # So we change $ErrorActionPreference before we call git, just in case.
        $ErrorActionPreference = 'continue'
        
        # Now, we will force there to be at least one directory (the current path).
        # This makes the code simpler, because we are always going thru a loop.
        if (-not $directories) {
            $directories = @($pwd)
        } else {
            # It also gives us a change to normalize the directories into their full paths.
            $directories = @(foreach ($dir in $directories) { $dir.Fullname }) 
        }

        
        # For each directory we know of, we
        foreach ($dir in $directories) {
            $AllGitArgs = @(@($GitArgument) + $InputObject) # collect the combined arguments
            $OutGitParams = @{GitArgument=$AllGitArgs}      # and prepare a splat (to save precious space when reporting errors).
            Push-Location -LiteralPath $dir                 # Then we Push into that directory  
                & $script:CachedGitCmd @AllGitArgs *>&1       | # then we run git, combining all streams into output.
                    Tee-Object -Variable global:lastGitOutput | # We store that output in $global:lastGitOutput, using Tee-Object
                                                                # then pipe to Out-Git, which will
                    Out-Git @OutGitParams # output git as objects.
                                        
                    # These objects are decorated for the PowerShell Extended Type System.
                    # This makes them easy to extend and customize their display.
                    # If Out-Git finds one or more extensions to run, these can parse the output.

            Pop-Location # After we have run, Pop back out of the location.
        }
    }
}
