#requires -module ugit

describe ugit {
    it "Updates git" {
        (Get-Command git) -is [Management.Automation.AliasInfo] | Should -be $true
    }

    context 'git log' {
        it 'Can get log entries as objects' {
            $logEntry = git log -n 1 
            $logEntry.commitHash | Should -not -be $null
            $logEntry.CommitDate | Should -BeLessThan ([DateTime]::now)
        }
    }
}
