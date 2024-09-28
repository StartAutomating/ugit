<#
.SYNOPSIS
    Gets the trailer of a commit
.DESCRIPTION
    Gets the trailers of a commit.  Git trailers are key-value pairs that are appended to the end of a commit message.
.LINK
    https://git-scm.com/docs/git-interpret-trailers
#>

$lineNumber = 0
$gitTrailers = [Ordered]@{}
foreach ($commitMessageLine in $this.CommitMessage -split '(?>\r\n|\n)') {
    $lineNumber++
    if ($commitMessageLine -notmatch '\s{0,}(?<k>\S+):\s(?<v>[\s\S]+$)' -or $lineNumber -eq 1) {
        continue
    }
    if (-not $gitTrailers[$matches.k]) {
        $gitTrailers[$matches.k] = $matches.v
    } else {
        $gitTrailers[$matches.k] = @($gitTrailers[$matches.k]) + $v
    }                 
}
return $gitTrailers