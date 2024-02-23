<#
.SYNOPSIS
    Gets what was not a Git Command
.DESCRIPTION
    If the git output is not a git command, this will output the command name.
#>
if ($this -match "^git:\s'(?<cmd>.+?)' is not a git command.") {
    return $matches.cmd
}