Write-FormatView -TypeName Git.Reference.Log -Property Name, '#', Hash, Command, Message -VirtualProperty @{
    '#' = { $_.'Number' + ' '}
    Name = { $_.Name }
    Command = { $_.Command + ':'}
}  -AlignProperty @{
    Name = 'Right'
    '#'  = 'Left'
    Command ='Right'
    Message = 'Left'
}
