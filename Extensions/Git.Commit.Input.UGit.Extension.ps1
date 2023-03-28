<#
.SYNOPSIS
    Git Commit Input
.DESCRIPTION
    Makes Git Commit easier to use from PowerShell by providing parameters for the -Message, -Title, -Body, and -Trailers
.EXAMPLE
    git commit -Title "Fixing Something"
.EXAMPLE
    git commit -Title "Changing Stuff" -Trailers @{"Co-Authored-By"="SOMEONE ELSE <Someone@Else.com>"}
#>
[ValidatePattern('^git commit')]
[Management.Automation.Cmdlet('Use','Git')]
[CmdletBinding(PositionalBinding=$false)]
param(
# The message used for the commit
[string]
$Message,

# The title of the commit.  If -Message is also provided, this will become part of the -Body
[string]
$Title,

# The body of the commit.
[string]
$Body,

# Any git trailers to add to the commit.
# git trailers are key-value pairs you can use to associate metadata with a commit.
# As this uses --trailer, this requires git version 2.33 or greater.
[Alias('Trailer','CommitMetadata','GitMetadata')]
[Collections.IDictionary]
$Trailers,

# If set, will amend an existing commit.
[switch]
$Amend
)



if ($Message) {
    "-m"
    $message
}

if ($Title) {
    "-m"
    $title
}

if ($Body) {
    "-m"
    $body
}

if ($Trailers) {    
    foreach ($kv in $Trailers.GetEnumerator()) {
        foreach ($val in $kv.Value) {
            "--trailer=$($kv.Key -replace ':','_colon_' -replace '\s', '-')=$val"
        }        
    }
}

if ($amend) {
    "--amend"   
}