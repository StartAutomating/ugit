<#
.SYNOPSIS
    git simple format
.DESCRIPTION
    Parses the output of git format, if the results are a series of simple delimited fields
.EXAMPLE
    git branch --format "%(refname:short)|%(objectname)|%(parent)|%(committerdate:iso8601)|%(objecttype)"
#>
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("\s-{2}format\s\%", Options = 'IgnoreCase,IgnorePatternWhitespace'
)]
param()

begin {
    $findPropExpressions = [Regex]::new("\%\((?<prop>\w+)(?:\:(?<proptype>\w+))?\)(?<Delimiter>(?>.|$))")
    if ($findPropExpressions.Replace($gitCommand, '') -notmatch 'format\s{0,}$') { continue }
    $expectedColumns = @($findPropExpressions.Matches($gitCommand))
    $expectedColumnNames = @(
        $expectedColumns.Groups | Where-Object Name -eq 'prop' | Select-Object -ExpandProperty Value
    )
    $expectedDelimiters = @($expectedColumns.Groups |
        Where-Object Name -eq 'Delimiter' |
        Select-Object -ExpandProperty Value -Unique)
    if ($expectedDelimiters.Length -gt 2) { continue }
    $expectedDelimiter = [regex]::Escape($expectedDelimiters[0])
}
process {
    $columnNumber = 0
    $parsedFormatObject = [Ordered]@{PSTypename=@($gitOut.pstypenames)[1] -replace '--format','properties'}
    foreach ($gitOutputSegment in $gitOut -split $expectedDelimiter) {
        if ($expectedColumns[$columnNumber].Groups["proptype"].Value -eq 'iso8601') {
            $gitOutputSegment = $gitOutputSegment -as [datetime]
        }
        $parsedFormatObject[$expectedColumnNames[$columnNumber]] = $gitOutputSegment
        $columnNumber++
    }
    $parsedFormatObject.GitRoot = $GitRoot
    [PSCustomObject]$parsedFormatObject
}
