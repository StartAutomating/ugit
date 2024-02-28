$CommandsPath = Join-Path $PSScriptRoot Commands
[include('*-*.ps1')]$CommandsPath

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$MyModule.pstypenames.insert(0,$MyModule.Name)
$ExecutionContext.SessionState.PSVariable.Set($MyModule.Name, $myModule)

Export-ModuleMember -Function * -Alias * -Variable $MyModule.Name