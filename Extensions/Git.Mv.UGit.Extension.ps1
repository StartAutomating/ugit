<#
.Synopsis
    Git Move Extension
.Description
    Outputs git mv as objects.
.EXAMPLE
    git mv .\OldName.txt .\NewName.txt
.EXAMPLE
    git mv .\OldName.txt .\NewName.txt --verbose
#>
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("^git mv")]                  # that is run when the switch -o is used.
[OutputType([IO.FileInfo])]
param(   )

begin {
    $moveLines = @()
}

process {
    $moveLines += $gitOut
}

end {
    if ($gitArgument -match '--(?>n|dry-run)') {
        return $moveLines
    }

    # Take all non-dashed arguments to git.
    $cmd,                 # The first is 'mv'
        $source,          # The second is the source
            $dest,        # The third is the detination.
                $null   = # (ignore anything else)
                $gitArgument -notlike '-*'

    if (-not (Test-Path $dest)) { return $moveLines }

    $destItem = Get-Item $dest -ErrorAction SilentlyContinue
    @(if ($destItem -is [IO.DirectoryInfo]) {
        $destItem
    } elseif ($destItem) {
        $destItem
    } else {
        return $moveLines
    }) |
        Add-Member NoteProperty Source (Join-Path $gitRoot $source) -Force -PassThru |
        Add-Member NoteProperty Destination $destItem.FullName -Force -PassThru |
        Add-Member NoteProperty GitRoot $gitRoot -Force -PassThru |
        Add-Member NoteProperty GitCommand $gitCommand -Force -PassThru
}
