@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        },        
        @{
            name = 'PSA'
            uses = 'StartAutomating/PSA@main'
            id = 'PSA'
        }        
    )
}