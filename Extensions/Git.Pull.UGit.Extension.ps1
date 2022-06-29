<#
.SYNOPSIS
    git pull extension
.DESCRIPTION
    Returns git pull as objects.
.EXAMPLE
    git pull
#>
[Management.Automation.Cmdlet("Out", "Git")]
[ValidatePattern("^git pull")]
[OutputType('git.pull.fastforward', 'git.pull.nochange')]
param(
[Parameter(ValueFromPipeline)]
[string]
$GitOut
)

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
    elseif ($pullLines -match '^Fast-forward$' -or $pullLines -match "'(?<strategy>[^']+)'\s{1}strategy\.$") {
        
        $gitPullOut = 
            if ($pullLines -match '^Fast-forward$') {
                @{PSTypeName='git.pull.fastforward';GitRoot=$gitRoot;Changes=@();NewFiles=@()}
            } else {
                foreach ($pl in $pullLines) {
                    if ($pl -match "'(?<strategy>[^']+)'\s{1}strategy\.$") {
                            @{
                                PSTypeName="git.pull.strategy";
                                Strategy=$matches.strategy;
                                GitRoot=$gitRoot;
                                Changes=@();
                                NewFiles=@()
                            }
                        break
                    }
                }                
            }
        
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

