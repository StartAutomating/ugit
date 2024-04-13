<#
.SYNOPSIS
    git branch input extension
.DESCRIPTION
    Extends the parameters for git branch, making it easier to use from PowerShell.
.EXAMPLE
    git branch -Remote
#>
[ValidatePattern('^git branch')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# If set, will add the --remote flag to the command.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Remotes')]
[switch]
$Remote
)

if ($Remote) {
    "--remote"
}