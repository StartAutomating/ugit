Write-FormatView -TypeName ugit.Conventional.Commit -Action {
    @(
        if ($_.README) {
            Show-Markdown $_.README
        }

        Show-Markdown -InputObject "### Conventinal Commit Types"
        Show-Markdown -InputObject (
            '* ' + $($_.Type -join ([Environment]::NewLine + '* '))
        )
    ) -join [Environment]::NewLine
}