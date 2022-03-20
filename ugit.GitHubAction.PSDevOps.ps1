#requires -Module PSDevOps
#requires -Module ugit
Import-BuildStep -ModuleName ugit
New-GitHubAction -Name "UseUGit" -Description 'Updated Git' -Action UGitAction -Icon github  -ActionOutput ([Ordered]@{
    ugitScriptRuntime = [Ordered]@{
        description = "The time it took the .ugitScript parameter to run"
        value = '${{steps.ugitAction.outputs.ugitScriptRuntime}}'
    }
    ugitPS1Runtime = [Ordered]@{
        description = "The time it took all .ugit.ps1 files to run"
        value = '${{steps.ugitAction.outputs.ugitPS1Runtime}}'
    }
    ugitPS1Files = [Ordered]@{
        description = "The .ugit.ps1 files that were run (separated by semicolons)"
        value = '${{steps.ugitAction.outputs.ugitPS1Files}}'
    }
    ugitPS1Count = [Ordered]@{
        description = "The number of .ugit.ps1 files that were run"
        value = '${{steps.ugitAction.outputs.ugitPS1Count}}'
    }
}) |
    Set-Content .\action.yml -Encoding UTF8 -PassThru
