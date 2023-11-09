<#
.SYNOPSIS
    Git Clone extended input
.DESCRIPTION
    Extends the input for git clone.

    By default, if --progress is not found, it will be added to any git clone.
.EXAMPLE
    git clone https://github.com/MDN/content.git # This is a big repo.  Progress bars will be very welcome.
.EXAMPLE
    # If we don't check things out, cloning is faster.
    git clone https://github.com/PowerShell/PowerShell -NoCheckout 
    # (of course, that's because we're not copying files, just history)
#>
[ValidatePattern('^git clone')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# If set, will not check out files from the respository.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$NoCheckout
)

if ($NoCheckout) {
    '--no-checkout'
}

if (
    $gitArgument -notcontains '--progress'
) {
    '--progress'
}