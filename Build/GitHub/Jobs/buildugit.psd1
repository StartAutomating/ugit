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
        @{
            name = 'Run ugit (from main)'
            if   = '${{github.ref_name == ''main''}}'
            uses = 'StartAutomating/ugit@main'
            id = 'ugitMain'
        },
        @{
            name = 'Run ugit (on branch)'
            if   = '${{github.ref_name != ''main''}}'
            uses = './'
            id = 'ugitBranch'
        }
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
            'name'='Log in to the Container registry (on branch)'            
            'uses'='docker/login-action@master'
            'with'=@{
                'registry'='${{ env.REGISTRY }}'
                'username'='${{ github.actor }}'
                'password'='${{ secrets.GITHUB_TOKEN }}'
            }
        },
        @{
            name = 'Extract Docker Metadata (for branch)'
            if   = '${{github.ref_name != ''main'' && github.ref_name != ''master'' && github.ref_name != ''latest''}}'
            'id'='meta'
            'uses'='docker/metadata-action@master'
            'with'=@{
                'images'='${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}'                
            }
        },
        @{
            name = 'Extract Docker Metadata (for main)'
            if   = '${{github.ref_name == ''main'' || github.ref_name == ''master'' || github.ref_name == ''latest''}}'
            'id'='metaMain'
            'uses'='docker/metadata-action@master'
            'with'=@{
                'images'='${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}'
                'flavor'='latest=true'
            }
        },
        @{
            name = 'Build and push Docker image (from main)'
            if   = '${{github.ref_name == ''main'' || github.ref_name == ''master'' || github.ref_name == ''latest''}}'
            uses = 'docker/build-push-action@master'
            'with'=@{
                'context'='.'
                'push'='true'
                'tags'='${{ steps.metaMain.outputs.tags }}'
                'labels'='${{ steps.metaMain.outputs.labels }}'
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