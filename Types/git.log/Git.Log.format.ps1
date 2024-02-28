Write-FormatView -TypeName Git.Log -Property GitUserName, CommitDate, CommitMessage -Wrap -AlignProperty @{
    "CommitDate" = "Right"
    "CommitMessage" = "Left"
}

Write-FormatView -TypeName Git.Log -Property GitUserName, CommitDate, CommitHash, CommitMessage -Wrap -Name IncludeCommitHash  -AlignProperty @{
    "CommitDate" = "Right"
    "CommitHash" = "Left"
    "CommitMessage" = "Left"
}

Write-FormatView -TypeName Git.Merge.Log -Property GitUserName, CommitDate, MergeHash, CommitMessage -Wrap   -AlignProperty @{
    "CommitDate" = "Right"
    "CommitHash" = "Left"
    "MergeHash"  = "Left"
    "CommitMessage" = "Left"
}