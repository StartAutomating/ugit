function Get-GitFunction
{
    <#
    .SYNOPSIS
        Gets Git Functions
    .DESCRIPTION
        Gets git functions.

        Gets any functions or aliases named git.*
    .NOTES        
        These functions may be called directly.

        They will be called when ugit matches the longest valid name.

        This returns an enumerable.
        
        New commands can be found by iterating over the output.
    .EXAMPLE
        function git.hello.world {
            "hello world"
        }
        git hello world
    .EXAMPLE
        function git.last.time {
            git log -n 1 | 
                Select-Object -ExpandProperty CommitDate
        }
        git last time
    .EXAMPLE
        function git.last.year {
            param(
            $Then = [DateTime]::Now.AddYears(-1),
            $Now = [DateTime]::Now,            
            )

            git log -Since $Then -Before $now
        }
        git last year
    #>
    [Alias(
        'GitFunction','GitFunctions','Get-GitFunctions',
        'git.func','git.function', 'git.functions'
    )]
    param()
    
    # For a wildcard only extension pattern, 
    # we can return a list `,` with the enumerator
    # This is extra handy because when we enumerate the list,
    # we get the _current_ commands that match the pattern.

    # We limit ourselves to aliases and functions because they are the fastest to look up.
    return ,($ExecutionContext.SessionState.InvokeCommand.GetCommands(
        'git.*',
        'Alias,Function',
        $true
    ))
}
