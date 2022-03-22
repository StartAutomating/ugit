<#
.SYNOPSIS
    git push
.DESCRIPTION
    Outputs git push as objects.
.EXAMPLE
    git push
#>
[Management.Automation.Cmdlet("Out","Git")]
[ValidatePattern("^git push")]
[OutputType('git.push')]
param(

)

begin {
    $pushLines = @()
}

process {
    $pushLines += $gitOut
}

end {
    if (-not ($pushLines -match '^To http')) {
        $pushLines
        return
    }
<#
To https://github.com/StartAutomating/RoughDraft.git
   963ae1e..b8ddde6  ImprovingCachingAndMoreExtensions -> ImprovingCachingAndMoreExtensions

#>
    $pushOutput = [Ordered]@{PSTypeName='git.push'}
    $pushCommitHashRegex = '\s{3}(?<o>[a-f0-9]+)\.\.(?<n>[a-f0-9]+)\s{0,}'
    foreach ($pl in $pushLines) {
        if ($pl -match '^To http') {
            $to, $GitUrl = $pl -split ' '
            $pushOutput.GitUrl = $GitUrl -join ' '
        }
        
        if ($pl -match $pushCommitHashRegex) {
            $pushOutput.LastCommitHash = $matches.o
            $pushOutput.CommitHash = $matches.n
            $pushOutput.SourceBranch, $pushOutput.DestinationBranch = $pl -replace $pushCommitHashRegex -split '\s+->\s+'             
        }
    }
    [PSCustomObject]$pushOutput
}