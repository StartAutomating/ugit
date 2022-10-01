<#
.SYNOPSIS
    git init extension
.DESCRIPTION
    Outputs git init as objects (unless, -q or --quiet are passed)
.EXAMPLE
    git init # Initialize the current directory as a repository
#>
[Management.Automation.Cmdlet("Out","Git")]           # It's an extension for Out-Git
[ValidatePattern("^git init",Options='IgnoreCase')] # when the pattern is "git init"
[OutputType('git.init')]
param()

begin {
    <#
    If any of these parameters are used, we will skip processing.
    #>
    $SkipIf = 'q', '-quiet' -join '|'    
    if ($gitCommand -match "\s-(?>$SkipIf)")      { break }
}
process {
    if ($gitOut -match 'Initialized empty Git repository in (?<Location>.+$)') {
        $fixPath = $matches.Location -replace '[\\/]', ([IO.Path]::DirectorySeparatorChar)
        $gitInitOut = [Ordered]@{
            PSTypeName     = 'git.init'
            GitRoot        = "$fixPath"
            GitOutputLines = $gitOut
            GitCommand     = $gitCommand
        }
        [PSCustomObject]$gitInitOut
    }
}

