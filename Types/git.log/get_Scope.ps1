<#
.SYNOPSIS
    Gets the scope of a conventional commit
.DESCRIPTION
    Gets the scope of a conventional commit, based on the commit message.
.LINK
    https://www.conventionalcommits.org/en/v1.0.0/#summary
#>
if ($this.CommitMessage -match '^(?<Type>[^\r\n]+?):\s{0,}(?<Message>[^\r\n]+)') {
    $matchType = $Matches.Type    
    if ($matchType -match '\(') {
        $matchType -replace '.+?\(' -replace '\)\s{0,}$'
    } else {
        return ''
    }
} else {
    return ''
}