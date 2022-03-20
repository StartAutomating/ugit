<#
.Synopsis
    Diff Extension
.Description
    Outputs git diff entries as objects
#>
# It  extends Out-Git
[Management.Automation.Cmdlet("Out","Git")]
# when the pattern is "git diff"
[ValidatePattern("^git diff",Options='IgnoreCase')]
[OutputType('Git.Diff','Git.Diff.ChangeSet')]
param()

begin {
    # Diff messages are spread across many lines, so we need to keep track of them.    
    $lines = [Collections.Queue]::new()
    $allDiffLines = [Collections.Queue]::new()
    function OutDiff {
        param([string[]]$OutputLines)

        
        if (-not $OutputLines) { return }
        $outputLineCount = 0
        $diffRange  = $null
        $diffObject = [Ordered]@{PSTypeName='git.diff';ChangeSet=@()}
        foreach ($outputLine in $OutputLines) {
            $outputLineCount++
            if ($outputLineCount -eq 1) {
                $diffObject.From, $diffObject.To  = $outputLine -replace '^diff --git ' -split '[ab]/' -ne ''
            }
            if (-not $diffRange -and $outputline -match 'index\s(?<fromhash>[0-9a-f]+)..(?<tohash>[0-9a-f]+)') {
                $diffObject.FromHash, $diffObject.ToHash = $Matches.fromhash, $Matches.tohash
            }
            if ($outputLine -like "@@*@@*") {
                if ($diffRange) {
                    $diffObject.ChangeSet += [PSCustomObject]$diffRange
                }
                
                $extendedHeader = $outputLine -replace '^@@[^@]+@@' -replace '^\s+'
                $diffRange = [Ordered]@{
                    PSTypeName='git.diff.range';
                    Changes=@(if ($extendedHeader) {$extendedHeader});
                    Added=@();
                    Removed=@()
                }
                $diffRange.LineStart,
                $diffRange.LineCount,
                $diffRange.NewLineStart,
                $diffRange.NewLineCount = 
                    @($outputLine -replace '\s' -split '[-@+]' -ne '' -split ',')[0..3] -as [int[]]
                continue
            }

            if ($diffRange) {
                $diffRange.Changes += $outputLine
                if ($outputLine.StartsWith('+')) {
                    $diffRange.Added += $outputLine -replace '^+'
                }
                elseif ($outputLine.StartsWith('-')) {
                    $diffRange.Removed += $outputLine -replace '^+'
                }
            }

            if ($outputLineCount -eq $OutputLines.Length) {
                $diffObject.ChangeSet += [PSCustomObject]$diffRange
            }
        }
        [PSCustomObject]$diffObject
    }
}


process {    
    if ("$gitOut" -like 'diff*' -and $lines) {
        OutDiff $lines.ToArray()
        $lines.Clear()
    }
    $lines.Enqueue($gitOut)
    $allDiffLines.Enqueue($gitOut)
}

end {
    OutDiff $lines.ToArray()
}


