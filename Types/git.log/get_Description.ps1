<#
.SYNOPSIS
    Gets the description of a commit
.DESCRIPTION
    Gets the description of a conventional commit, or the first line of the commit message.
.LINK
    https://www.conventionalcommits.org/en/v1.0.0/#summary
#>
if ($this.CommitMessage -match '^(?<Type>[^\r\n]+?):\s{0,}(?<Message>[^\r\n]+)') {
    return $Matches.Message    
} else {
    $firstLine, $null = $this.CommitMessage -split '(?>\r\n|\n)'
    return $firstLine
}
