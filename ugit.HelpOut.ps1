#requires -Module HelpOut
$ugitLoaded = Get-Module ugit
if (-not $ugitLoaded) {
    $ugitLoaded = Get-ChildItem -Recurse -Filter "*.psd1" | Where-Object Name -like 'ugit*' | Import-Module -Name { $_.FullName } -Force -PassThru
}
if ($ugitLoaded) {
    "::notice title=ModuleLoaded::ugit Loaded" | Out-Host
} else {
    "::error:: ugit not loaded" |Out-Host
}
if ($ugitLoaded) {
    Save-MarkdownHelp -Module $ugitLoaded.Name -PassThru -ScriptPath Extensions -ReplaceScriptName '\.UGit\.Extension\.ps1$' -ReplaceScriptNameWith "-Extension" |
        Add-Member NoteProperty CommitMessage "Updating docs" -Force -PassThru
}
