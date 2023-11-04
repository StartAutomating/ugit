Write-FormatView -TypeName git.blame -GroupByProperty GitRoot -Property CommitHash, Author, CommitDate, Line, Content -AlignProperty @{    
    'Line' = 'Right'
    'Content' = 'Left'
}
