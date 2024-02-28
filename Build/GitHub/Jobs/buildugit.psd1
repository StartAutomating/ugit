@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        },
        @{
            name = 'GitLogger'
            uses = 'GitLogging/GitLoggerAction@main'
            id = 'GitLogger'
        },
        @{
            name = 'Use PSSVG Action'
            uses = 'StartAutomating/PSSVG@main'
            id = 'PSSVG'
        },
        'RunPipeScript',
        'RunPiecemeal',
        'RunEZOut',
        @{
            name = 'Run HelpOut'
            uses = 'StartAutomating/HelpOut@master'
            id = 'HelpOut'
        },
        @{
            name = 'PSA'
            uses = 'StartAutomating/PSA@main'
            id = 'PSA'
        }        
    )
}