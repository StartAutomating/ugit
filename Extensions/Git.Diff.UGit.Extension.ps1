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
param(
)

begin {    
    $lines = @()
    function OutDiff {
        param([string[]]$OutputLines)

        if (-not $OutputLines) { return }
        $diffExtract = $OutputLines -join [Environment]::NewLine   | & ${?<Git_Diff>} -Extract        
        foreach ($diff in $diffExtract) {
            $diffObject = [Ordered]@{PSTypeName='git.diff'}
            foreach ($prop in $diff.psobject.properties) {
                if ($prop.Name -like '*_*') { continue }
                $diffObject[$prop.Name] = $prop.Value
            }            
            $diffRangeExtract = @($diff.Git_DiffRanges      | & ${?<Git_DiffRange>})            
            $diffRangeSplit   = @($diff.Git_DiffRanges      | & ${?<Git_DiffRange>} -Split) -notmatch '^\s+$'
            $diffObject.ChangeSet =  @(
                for ($diffRangeIndex = 0; $diffRangeIndex -lt $diffRangeExtract.Count; $diffRangeIndex++){
                    [PSCustomObject][Ordered]@{
                        PSTypeName   ='git.diff.range'
                        Changes      = $diffRangeSplit[$diffRangeIndex]
                        LineStart    = $diffRangeExtract[$diffRangeIndex].Groups["FromFileLineStart"].Value -as [int]
                        LineCount    = $diffRangeExtract[$diffRangeIndex].Groups["FromFileLineCount"].Value -as [int]
                        NewLineStart = $diffRangeExtract[$diffRangeIndex].Groups["ToFileLineEnd"].Value -as [int]
                        NewLineCount = $diffRangeExtract[$diffRangeIndex].Groups["ToFileLineCount"].Value -as [int]
                        Added        = @($diffRangeSplit[$diffRangeIndex] -split '(?>\r\n|\n)' -like '+*' -replace '^\+')
                        Removed      = @($diffRangeSplit[$diffRangeIndex] -split '(?>\r\n|\n)' -like '-*' -replace '^\-')
                    }
                }
            )
            [PSCustomObject]$diffObject
        }        
    }
}


process {    
    if ("$gitOut" -like 'diff*' -and $lines) {
        OutDiff $lines
        $lines = @()
    }
    $lines += "$gitOut"
}

end {
    OutDiff $lines
}


