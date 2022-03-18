<#
.Synopsis
.Description

#>
# It's an extension
[Runtime.CompilerServices.Extension()]
# that extends Out-Git
[Management.Automation.Cmdlet("Out","Git")]
# when the pattern is "git fetch,merge,checkout, or pull"
[ValidatePattern("^git (?:fetch|merge|checkout|pull)")]
param(
)

begin {
    $percentLine = [Regex]::new(@'
(?<Activity>[^:]+):(?<PercentComplete>\d+)%(?<Status>.+$)
'@, 'IgnoreCase,IgnorePatternWhitespace','00:00:01')
    $progressId = Get-Random
}

process {
    $lineHasPercent = $percentLine.Match($gitOut)
    if ($lineHasPercent.Success) {
        Write-Progress "$($lineHasPercent.Groups["Activity"]) " "$($lineHasPercent.Groups["Status"])" -PercentComplete $lineHasPercent.Groups["PercentComplete"].Value -Id $progressId
    }
    if ($steppablePipelines -and $steppablePipelines.Length -eq 1) {
        $gitOut
    }
}

end {
    Write-Progress " " " " -Completed -Id $progressId
}