$CommandsPath = Join-Path $PSScriptRoot Commands
:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$CommandsPath" -Filter "*-*.ps1" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . $file.FullName
}

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$MyModule.pstypenames.insert(0,$MyModule.Name)
$ExecutionContext.SessionState.PSVariable.Set($MyModule.Name, $myModule)

Export-ModuleMember -Function * -Alias * -Variable $MyModule.Name
