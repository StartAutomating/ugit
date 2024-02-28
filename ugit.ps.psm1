$CommandsPath = Join-Path $PSScriptRoot Commands
[include('*-*.ps1')]$CommandsPath

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$MyModule.pstypenames.insert(0,$MyModule.Name)
$ExecutionContext.SessionState.PSVariable.Set($MyModule.Name, $myModule)

$newDriveSplat = @{PSProvider='FileSystem';ErrorAction='Ignore';Scope='Global'}
New-PSDrive -Name $MyModule.Name -Root ($MyModule | Split-Path) @newDriveSplat

if ($home) {
    $myMyModule = "My$($myModule.Name)"
    $myMyModuleRoot = Join-Path $home $myMyModule
    if (Test-Path $myMyModuleRoot) {
        New-PSDrive -Name $myMyModule -Root $myMyModuleRoot @newDriveSplat
    }
}

Export-ModuleMember -Function * -Alias * -Variable $MyModule.Name