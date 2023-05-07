<#
.Synopsis
    git help all
.Description
    Returns git help --all as objects.
.Example
    git help -a
.EXAMPLE
    git help --all
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern('^git help -(?>a|-all)')]
[OutputType('git.command')]
param()

begin {
    $category = ''
}

process {
    if ($gitOut -match '^\S' -and $gitOut -notmatch '^See') {
        $category = "$gitOut"
        return
    }

    if ($gitOut -match '^See') { return }
    if ($gitOut -match '^\s{0,}$') { return }
    $null, $name, $description = "$gitOut" -split "\s+", 3

    [PSCustomObject][Ordered]@{
        PSTypeName = 'git.command'
        Name = $name
        Description = $description
        Category = $category
    }
}
