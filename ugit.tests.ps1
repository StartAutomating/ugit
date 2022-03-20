#requires -module ugit

describe ugit {
    it "Updates git" {
        (Get-Command git) -is [Management.Automation.AliasInfo] | Should -be $true
    }
}
