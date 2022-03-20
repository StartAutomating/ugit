Write-FormatView -TypeName Git.Log -Property GitUserName, CommitDate, CommitMessage -Wrap

Write-FormatView -TypeName Git.Log -Property GitUserName, CommitDate, CommitHash, CommitMessage -Wrap -Name IncludeCommitHash

Write-FormatView -TypeName Git.Merge.Log -Property GitUserName, CommitDate, MergeHash, CommitMessage -Wrap 