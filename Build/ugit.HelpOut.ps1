#requires -Module HelpOut

Push-Location ($PSScriptRoot | Split-Path)
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
    $SaveMarkdownHelpParams = @{
        Module= $ugitLoaded.Name
        ScriptPath='Extensions'
        ReplaceScriptName='\.UGit\.Extension\.ps1$'
        ReplaceScriptNameWith="-Extension"
    }
    Save-MarkdownHelp @SaveMarkdownHelpParams -PassThru
}
Pop-Location