<#
.SYNOPSIS
    Gets the changes in a git commit
.DESCRIPTION
    Gets the changes in a git commit.  This function is used to get the changes in a git commit.
    
    The changes are returned as a PSCustomObject with the following properties:
    
    - FilePath: The path of the file that was changed
    - LinesChanged: The number of lines changed in the file
    - LinesInserted: The number of lines inserted in the file
    - LinesDeleted: The number of lines deleted in the file    
#>
return @(foreach ($outLine in $this.GitOutputLines) {
    if ($outLine -notlike ' *|*') { continue }
    $nameOfFile, $fileChanges =  $outLine -split '\|'
    $nameOfFile = $nameOfFile -replace '^\s+' -replace '\s+$'
    $match = [Regex]::Match($fileChanges, "(?<c>\d+)\s(?<i>\+{0,})(?<d>\-{0,})")
    $linesChanged  = $match.Groups["c"].Value -as [int]
    $linesInserted = $match.Groups["i"].Length
    $linesDeleted  = $match.Groups["d"].Length  
    [PSCustomObject][Ordered]@{
        PSTypeName = 'git.log.change'
        FilePath      = $nameOfFile
        LinesChanged  = $linesChanged
        LinesInserted = $linesInserted
        LinesDeleted  = $linesDeleted
    }
})
