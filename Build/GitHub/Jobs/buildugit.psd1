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
        },
        @{
            'name'='Log in to the Container registry'
            'uses'='docker/login-action@master'
            'with'=@{
                'registry'='${{ env.REGISTRY }}'
                'username'='${{ github.actor }}'
                'password'='${{ secrets.GITHUB_TOKEN }}'
            }
        },
        @{
            'name'='Extract metadata (tags, labels) for Docker'
            'id'='meta'
            'uses'='docker/metadata-action@master'
            'with'=@{
                'images'='${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}'
            }
        },
        @{
            name = 'Build and push Docker image (from main)'
            if   = '${{github.ref_name == ''main'' || github.ref_name == ''master'' || github.ref_name == ''latest''}}'
            uses = 'docker/build-push-action@master'
            'with'=@{
                'context'='.'
                'push'='true'
                'tags'='latest'
                'labels'='${{ steps.meta.outputs.labels }}'
            }
        },
        @{
            name = 'Build and push Docker image (from branch)'
            if   = '${{github.ref_name != ''main'' && github.ref_name != ''master'' && github.ref_name != ''latest''}}'
            uses = 'docker/build-push-action@master'
            with = @{
                'context'='.'
                'push'='true'
                'tags'='${{ steps.meta.outputs.tags }}'
                'labels'='${{ steps.meta.outputs.labels }}'
            }
        }        
    )
}