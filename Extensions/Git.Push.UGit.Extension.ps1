<#
.SYNOPSIS
    git push
.DESCRIPTION
    Outputs git push as objects.
.EXAMPLE
    git push
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern("^git push")]
[OutputType('git.push.info')]
param()

begin {
    $pushLines = @() # Create a list for all of the lines from a git push.
    # This regular expression looks for 3 spaces and two sets of hex digits, separated by two periods.
    # We will use this to see if the push was succesful.
    $pushCommitHashRegex = '\s{3}(?<o>[a-f0-9]+)\.\.(?<n>[a-f0-9]+)\s{0,}'
}

process {
    # Add each line to the list of lines from git push.
    $pushLines += $gitOut
}

end {
    if (-not ($pushLines -match $pushCommitHashRegex)) { # If the push has no lines with a commit hash
        $pushLines # output directly.
        return
    }

    # Create a hashtable to store output
    $pushOutput = [Ordered]@{PSTypeName='git.push.info'}
    
    foreach ($pl in $pushLines) {
        if ($pl -match '^To http') {
            $to, $GitUrl = $pl -split ' '
            # Pick out the url from the line starting with To http
            $pushOutput.GitUrl = $GitUrl -join ' '
        }
        
        if ($pl -match $pushCommitHashRegex) {
            # The line with the commit hash has the prior hash and the current has
            $pushOutput.LastCommitHash = $matches.o
            $pushOutput.CommitHash = $matches.n
            # Followed by the source and destination branch, separated by ->
            $pushOutput.SourceBranch, $pushOutput.DestinationBranch = $pl -replace $pushCommitHashRegex -split '\s+->\s+'
        }
    }
    # Output our hashtable as a property bag.
    [PSCustomObject]$pushOutput
}