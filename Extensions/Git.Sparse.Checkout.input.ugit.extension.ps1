<#
.SYNOPSIS
    git sparse-checkout input extension
.DESCRIPTION
    Extends the parameters for git sparse-checkout, making it easier to use from PowerShell.
.EXAMPLE
    git sparse-checkout -FileFilters *.ps1,*.psm1
#>
[ValidatePattern('^git\s{1,}sparse-checkout')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# The list of file filters to use.
# Filters that start with * or *. will be converted to **.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('FileFilters')]
[string[]]
$FileFilter,

# The list of directory filters to use
# If provided with a file filter, the directory filter will be used as a parent directory filter.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('DirectoryFilters')]
[string[]]
$DirectoryFilter
)

if ($FileFilter) {
    "set"
    "--no-cone"
    $FileFilter -replace '^\*{0,1}\.', '**.'
    if ($DirectoryFilter) {
        $DirectoryFilter -replace '^[\\/]{0,1}', '/' -replace '\*{0,1}$', '**'     
    }
}
elseif ($DirectoryFilter) {
    "set"
    "--cone"
    $DirectoryFilter -replace '^[\\/]{0,1}', '/' 
}


