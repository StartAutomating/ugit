<#
.Synopsis
    Diff Extension
.Description
    Outputs git diff entries as objects
#>
[Management.Automation.Cmdlet("Out","Git")]         # It  extends Out-Git
[ValidatePattern("^git (?>diff|stash show(?:\s\d+)? -(?>p|-patch))",Options='IgnoreCase')] # when the pattern is "git diff"
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

        $diffObject = [Ordered]@{
            PSTypeName='git.diff'
            ChangeSet=@()
            GitOutputLines = $OutputLines
            Binary=$false
            GitRoot = $gitRoot
        }

        foreach ($outputLine in $OutputLines) {
            $outputLineCount++
            if ($outputLineCount -eq 1) {
                $diffObject.From, $diffObject.To  = $outputLine -replace '^diff --git ' -split '[ab]/' -ne ''
                $fromPath = Join-Path $gitRoot $diffObject.From
                $toPath   = Join-Path $gitRoot $diffObject.To
                if (Test-Path $toPath) {
                    $diffObject.File = Get-Item $toPath
                } elseif (Test-Path $fromPath) {
                    $diffObject.File = Get-Item $fromPath
                }
            }
            if (-not $diffRange -and $outputline -match 'index\s(?<fromhash>[0-9a-f]+)..(?<tohash>[0-9a-f]+)') {
                $diffObject.FromHash, $diffObject.ToHash = $Matches.fromhash, $Matches.tohash
            }
            if ($outputLine -like 'Binary files *differ') {
                $diffObject.Binary = $true
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


