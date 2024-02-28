#requires -Module PSSVG
Push-Location ($PSScriptRoot | Split-Path)   
$psChevron = 
    svg.symbol -Id psChevron -Content @(
        svg.polygon -Points (@(
            "40,20"
            "45,20"
            "60,50"
            "35,80"
            "32.5,80"
            "55,50"
        ) -join ' ')
    ) -ViewBox 100, 100 -PreserveAspectRatio $false

$assetsPath = Join-Path $pwd assets

if (-not (Test-Path $assetsPath)) {
    $null = New-item -ItemType Directory -Path $assetsPath
}

svg -ViewBox 300, 100 @(
    $psChevron
    svg.use -Href '#psChevron' -Fill '#4488ff' -X 30% -Y 37.5% -Width 10% -Height 25%        
    
    svg.text -X 50% -Y 50% -TextAnchor 'middle' -DominantBaseline 'middle' -Content @(
        SVG.tspan -FontSize .5em -Content 'u'
        SVG.tspan -FontSize 1em -Content 'git' -Dx -.25em
    ) -FontFamily 'serif' -Fill '#4488ff' -FontSize 4em 
) -OutputPath (Join-Path $assetsPath ugit.svg)

Pop-Location