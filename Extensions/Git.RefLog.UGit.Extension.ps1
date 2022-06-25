<#
.SYNOPSIS
    git reflog
.DESCRIPTION
    Outputs git reflog as objects.
.EXAMPLE
    git reflog
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern("^git reflog")]
[OutputType('git.reference.log')]
param()

begin {
    $refLogLines = @() # Create a list for all of the lines from a git reflog.
    # Declare a regex to match each one.
    $refLogRegex = [Regex]::new("^(?<CommitHash>[a-f0-9]+)\s{0,}(?<Name>[^@]+)@\{(?<Number>\d+)\}:\s{1,}(?<CommitMessage>.+)$")
}

process {
    # Add each line to the list of lines from git reflog.
    $refLogLines += $gitOut
}

end {
    if (-not $refLogLines) { return }
    if ($refLogLines -notmatch $refLogRegex) {
        return $refLogLines
    }

    foreach ($refLogLine in $refLogLines) {
        $matched = $refLogLine -match $refLogRegex
        $refExtract = [Ordered]@{} + $matches
        $refExtract.Remove(0)
        $refExtract.PSTypeName = 'Git.Reference.Log'
        [PSCustomObject]$refExtract
    }        
}