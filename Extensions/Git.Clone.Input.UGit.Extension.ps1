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

# Employ a sparse-checkout.
# Only files in the toplevel directory will be present by default.
# Sparse checkout can be configured with git sparse-checkout.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$Sparse,

# Create a shallow clone with a history truncated to the specified number of commits
[Parameter(ValueFromPipelineByPropertyName)]
[uint32]
$Depth,

# Create a shallow clone with a history after the specified time.
[Parameter(ValueFromPipelineByPropertyName)]
[Datetime]
$Since,

# One or more filters
[Parameter(ValueFromPipelineByPropertyName)]
[string[]]
$Filter,

# If set, will clone nothing.
# This means not checking out, filtering everything from the tree, and using sparse checkout 
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$Nothing
)

# If we're cloning nothing, it means:
if ($Nothing) {
    $NoCheckout = $true # * No checking out
    $Sparse = $true # * Sparse checkouts only
    $filter = "tree:0" # * Pick nothing from the tree
    $Depth = 1 # * With a depth of 1.
}

if ($Depth) {
    '--depth'
    "$Depth"
}

if ($NoCheckout) {'--no-checkout'}

if ($Sparse) {'--sparse'}

if ($Since) {"--shallow-since=$($Since.ToString('o'))"}

if ($filter) {
    foreach ($gitFilter in $filter) {
        "--filter=$gitFilter"
    }
}

if ($gitArgument -notcontains '--progress') {
    '--progress'
}