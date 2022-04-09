<#
.SYNOPSIS
    git pull extension
.DESCRIPTION

.EXAMPLE
    git pull
#>
[Management.Automation.Cmdlet("Out", "Git")]
[ValidatePattern("^git (?>pull|fetch)")]
[OutputType('git.pull.fastforward', 'git.pull.nochange')]
param(
[Parameter(ValueFromPipeline)]
[string]
$GitOut
)

<#
From https://github.com/StartAutomating/RoughDraft
   432138e..9df4f8d  main       -> origin/main
 * [new tag]         v0.3.1     -> v0.3.1
Updating 432138e..9df4f8d
Fast-forward
 CHANGELOG.md                                    |  13 ++-
 Convert-Media.ps1                               |  37 +++++++--
 Edit-Media.ps1                                  |  95 ++++++++++++++-------
 Extension/DrawSubtitle.RoughDraft.Extension.ps1 |  78 ++++++++++++++++++
 Extension/Resize.RoughDraft.Extension.ps1       |  11 ++-
 Extension/Subtitler.RoughDraft.Extension.ps1    | 105 ++++++++++++++++++++++++
 RoughDraft.psd1                                 |  13 ++-
 Show-Media.ps1                                  |   2 +-
 8 files changed, 309 insertions(+), 45 deletions(-)
 create mode 100644 Extension/DrawSubtitle.RoughDraft.Extension.ps1
 create mode 100644 Extension/Subtitler.RoughDraft.Extension.ps1
#>

begin {
    $pullLines = @()
}

process {
    $pullLines += $gitOut
}

end {
    if ($pullLines -match 'Already up to date.') {
        [PSCustomObject]@{UpToDate=$true;GitRoot=$GitRoot;PSTypeName='git.pull.no.update'}
    }
    elseif ($pullLines -match '^Fast-forward$') {
        $gitPullOut = @{PSTypeName='git.pull.fastforward';GitRoot=$gitRoot;Changes=@();NewFiles=@()}
        
        foreach ($pl in $pullLines) {
            if ($pl -match '^From http') {
                $null, $gitPullOut.GitUrl = $pl -split ' '
            }

            if ($pl -match '\[new tag\]\S+(?<t>\S+)') {
                if (-not $gitPullOut.NewTags)  {
                    $gitPullOut.NewTags = @()
                }
                $gitPullOut.NewTags += $matches.t
            } elseif ($pl -match '\s+(?<o>[0-9a-f]+)\.\.(?<n>[0-9a-f]+)\s+(?<dest>\S+)\s+->\s+(?<src>\S+)') {
                $gitPullOut.SourceBranch      = $matches.src
                $gitPullOut.DestinationBranch = $matches.dest
            }

            if ($pl -match '^Updating (?<o>[0-9a-f]+)\.\.(?<n>[0-9a-f]+)') {
                $gitPullOut.LastCommitHash = $matches.o
                $gitPullOut.CommitHash = $matches.n
            }
            elseif ($pl -match '^\s\d+') # If the line starts with a space and digits 
            { 
                # It's the summary.  Split it on commas and remove most of the rest of the text.
                foreach ($linePart in $pl -split ',' -replace '[\s\w\(\)-[\d]]') {
                    
                    if ($linePart.Contains('+')) { 
                        # If the part contains +, it's insertions.
                        $gitPullout.Insertions = $linePart -replace '\+' -as [int]
                    }                     
                    elseif ($linePart.Contains('-')) 
                    {
                        # If the part contains -, it's deletions.
                        $gitPullout.Deletions = $linePart -replace '\-' -as [int]
                    } 
                    else
                    {
                        # Otherwise, its the file change count.
                        $gitPullout.FilesChanged = $linePart -as [int]
                    }
                }                
            }
            elseif ($pl -match 'create\smode\s(?<mode>\d+)\s(?<FilePath>\S+)') {
                $gitPullOut.NewFiles += $matches.FilePath
            }
            
            if ($pl -like ' *|*') {
                $nameOfFile, $fileChanges =  $pl -split '\|'
                $nameOfFile = $nameOfFile -replace '^\s+' -replace '\s+$'                
                $match = [Regex]::Match($fileChanges, "(?<c>\d+)\s(?<i>\+{0,})(?<d>\-{0,})")
                $linesChanged  = $match.Groups["c"].Value -as [int]
                $linesInserted = $match.Groups["i"].Length
                $linesDeleted  = $match.Groups["d"].Length
                $gitPullOut.Changes +=
                    [PSCustomObject][Ordered]@{
                        FilePath      = $nameOfFile
                        LinesChanged  = $linesChanged
                        LinesInserted = $linesInserted
                        LinesDeleted  = $linesDeleted
                    }
            }
        }
        $gitPullOut.NewFiles = @(foreach ($nf in $gitPullOut.NewFiles) {
            
            try { Get-Item (Join-Path $gitPullOut.GitRoot $nf ) -ErrorAction SilentlyContinue } catch { $null } 
        })
        $gitPullOut.GitOutputLines = $pullLines
        [PSCustomObject]$gitPullOut
    }
    else {
        $pullLines
    }
}

