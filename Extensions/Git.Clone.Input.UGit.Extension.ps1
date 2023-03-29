<#
.SYNOPSIS
    Git Clone extended input
.DESCRIPTION
    Extends the input for git clone.

    By default, if --progress is not found, it will be added to any git clone.
.EXAMPLE
    git clone https://github.com/MDN/content.git # This is a big repo.  Progress bars will be very welcome.
#>
[ValidatePattern('^git clone')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
)

if ($gitArgument -notcontains '--progress') {
    '--progress'
}