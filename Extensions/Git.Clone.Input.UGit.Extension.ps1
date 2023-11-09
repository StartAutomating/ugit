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
.EXAMPLE
    # We can also clone more quickly by only picking a certain number of commits
    git clone https://github.com/Microsoft/vscode.git -Depth 1
    # (of course, this will make the history lie to you,
    # by saying everything was changed whenever anything was changed)
#>
[ValidatePattern('^git clone')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# If set, will not check out files from the respository.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$NoCheckout,

# Create a shallow clone with a history truncated to the specified number of commits
[Parameter(ValueFromPipelineByPropertyName)]
[uint32]
$Depth,

# Create a shallow clone with a history after the specified time.
[Parameter(ValueFromPipelineByPropertyName)]
[Datetime]
$Since
)

if ($Depth) {
    '--depth'
    "$Depth"
}

if ($NoCheckout) {
    '--no-checkout'
}

if ($Since) {
    "--shallow-since=$($Since.ToString('o'))"
}

if ($gitArgument -notcontains '--progress') {
    '--progress'
}