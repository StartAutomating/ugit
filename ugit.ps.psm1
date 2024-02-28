$CommandsPath = Join-Path $PSScriptRoot Commands
[include('*-*.ps1')]$CommandsPath

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$MyModule.pstypenames.insert(0,$MyModule.Name)
$ExecutionContext.SessionState.PSVariable.Set($MyModule.Name, $myModule)

New-PSDrive -Name $MyModule.Name -PSProvider FileSystem -ErrorAction Ignore -Scope Global -Root ($MyModule | Split-Path)

Export-ModuleMember -Function * -Alias * -Variable $MyModule.Name