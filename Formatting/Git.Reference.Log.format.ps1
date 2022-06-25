Write-FormatView -TypeName Git.Reference.Log -Property Name, '#', CommitHash, CommitMessage -VirtualProperty @{
    '#' = { $_.'Number'}
    Name = { $_.Name + '@' }
}  -AlignProperty @{
    Name = 'Right'
    '#'  = 'Left'
    CommitHash = 'Left'
    CommitMessage = 'Left'
}
