#requires -module ugit

describe ugit {
    it "Updates git" {
        (Get-Command git) -is [Management.Automation.AliasInfo] | Should -be $true
    }

    context 'git branch' {
        it 'Can list branches' {
            git branch |
                Select-Object -ExpandProperty BranchName |
                Should -BeLike '*'
        }
    }
    
    context 'git init' {
        it 'Can initialize repositories' {
            $randomDirName = "d$(Get-Random)"
            $null = New-Item -Path $randomDirName -ItemType Directory
            Push-Location $randomDirName
            git init | Select-Object -ExpandProperty GitRoot | Should -Match "$randomDirName[\\/]{0,}$"
            Pop-Location
            Remove-Item $randomDirName -Recurse -Force
        }
    }

    context 'git log' {
        it 'Can get log entries as objects' {
            $logEntry = git log -n 1 
            $logEntry.commitHash | Should -not -be $null
            $logEntry.CommitDate | Should -BeLessThan ([DateTime]::now)
            Get-Event -SourceIdentifier "Out-Git"
            Get-Event -SourceIdentifier "Use-Git"
        }
    }
}
