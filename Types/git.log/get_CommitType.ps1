<#
.SYNOPSIS
    Gets the type of a conventional commit
.DESCRIPTION
    Gets the type of a conventional commit, based on the commit message.
#>
if ($this.CommitMessage -match '^(?<Type>[^\r\n]+?):\s{0,}(?<Message>[^\r\n]+)') {
    $matchType = $Matches.Type    
    if ($matchType -match '\(') {
        $this.Type -replace '\(.+$'
    } else {
        $this.Type
    }
} else {
    return ''
}