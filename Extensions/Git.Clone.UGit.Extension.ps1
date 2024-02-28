<#
.Synopsis
    git clone extension
.Description
    Clones a repository, and returns the result as an object.
.Example
    git clone https://github.com/StartAutomating/ugit.git
.EXAMPLE
    # Clone a large repo.
    # When --progress is provided, Write-Progress will be called.
    git clone https://github.com/Azure/azure-quickstart-templates --progress
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern('^git clone')]
[OutputType('git.clone')]
param()

begin {
    $gitCloneLines = @()
    $progId = 0
    $cloningIntoDest = "^Cloning into '(?<dest>[^']+)'"
    $dest = ''
    $progressMsg = "cloning"
}

process {
    $gitCloneLines += $gitOut
    if ($gitOut -match $cloningIntoDest) {
        $dest = $matches.dest
        $progressMsg = $matches.0
        if (-not $progId) {
            $progId = Get-Random
        }
        Write-Progress $progressMsg "  " -Id $ProgId
    }
    if ($gitOut -match '(?<p>\d+)%\s\((?<c>\d+)/(?<t>\d+)\)') {
        $status = $gitOut -replace '(?<p>\d+)%\s\((?<c>\d+)/(?<t>\d+)\)'
        if (-not $progId) {
            $progId = Get-Random
        }
        Write-Progress $progressMsg " $status $($matches.c) / $($matches.t)" -PercentComplete $matches.p -Id $ProgId
    }
}

end {
    if ($progId) {
        Write-Progress $progressMsg "$status $($matches.c) / $($matches.t)" -Completed -Id $ProgId
    }


    if ($dest) {
        $destPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($dest)
        $gitUrl = $gitArgument | Where-Object { ($_ -as [uri]).Authority}
        [PSCustomObject]@{
            PSTypeName = 'git.clone'
            GitRoot    = "$destPath"
            Directory  = Get-Item -LiteralPath $destPath
            GitUrl     = $gitUrl
        }
    } else {
        $gitCloneLines
    }
}
