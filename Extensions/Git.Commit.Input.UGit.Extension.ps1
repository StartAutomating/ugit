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
# The title of the commit.  If -Message is also provided, this will become part of the -Body
[Alias('Subject')]
[string]
$Title,

# The commit message.
[string]
$Message,

# The type of the commit.  This uses the conventional commits format.
# https://www.conventionalcommits.org/en/v1.0.0/#specification
[ArgumentCompleter({
    param ( $commandName,
    $parameterName,
    $wordToComplete,
    $commandAst,
    $fakeBoundParameters )
    if ($wordToComplete) {
        @($ugit.ConventionalCommits.Types) -like "$WordToComplete*" -replace '^', "'" -replace '$',"'"
    } else {
        $ugit.ConventionalCommits.Types -replace '^', "'" -replace '$',"'"
    }
})]
[string]
$Type,

# The scope of the commit.  This uses the conventional commits format.
# https://www.conventionalcommits.org/en/v1.0.0/#specification
[string]
$Scope,

# A description of the commit.  This uses the conventional commits format.
# https://www.conventionalcommits.org/en/v1.0.0/#specification
[string]
$Description,

# The footer for the commit.  This uses the conventional commits format.
# https://www.conventionalcommits.org/en/v1.0.0/#specification
[string]
$Footer,

# The body of the commit.
[string]
$Body,

# Any git trailers to add to the commit.
# git trailers are key-value pairs you can use to associate metadata with a commit.
# As this uses --trailer, this requires git version 2.33 or greater.
[Alias('Trailer','CommitMetadata','GitMetadata')]
[Collections.IDictionary]
$Trailers = [Ordered]@{},

# If set, will amend an existing commit.
[switch]
$Amend,

# The commit date.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Date','Time','DateTime','Timestamp')]
[datetime]
$CommitDate,

# If provided, will mark this commit as a fix.
# This will add 'Fixes #...' to your commit message.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Fixes','Fixed')]
[string[]]
$Fix,

# If provided, will mark this commit as a close.
# This will add 'Closes #...' to your commit message.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Closed','Closes')]
[string[]]
$Close,

# If provided, will mark this commit as a resolution.
# This will add 'Resolves #...' to your commit message.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Resolves','Resolved')]
[string[]]
$Resolve,

# If provided, will mark this commit as referencing an issue.
# This will add 'Re #...' to your commit message.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Re','Regard','Regards','Regarding','References')]
[string[]]
$Reference,

# If provided, will mark this commit as co-authored by one or more people.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('CoAuthor','CoAuthors')]
[ValidateScript({
    if ($_ -notmatch "(?<Author>[^\<\>]+)\<(?<Email>[^\<\>]+)\>") {
        throw "Co-Authored-By must be in the format 'Name <Email>'"
    }
    return $true
})]
[string[]]
$CoAuthoredBy
)

$MyParameters =  [Ordered]@{} + $PSBoundParameters

# git commit -m can accept multiple messages, but the first message is somewhat special.
# (trailers cannot exist in the first message, and it's considered the subject by many other parts of git)

# So we want several potential things to become "-m", and we have to do this in the right order.

$Fixes = @(
    $IssuePattern = '^\#?\d+$'
    $IssueReplace = "^\#?"
    if ($Close) {
        $Close -match $IssuePattern -replace $IssueReplace, "Closes #"
    }
    if ($Fix) {
        $Fix -match $IssuePattern -replace $IssueReplace, "Fixes #"
    }
    if ($Resolve) {
        $Resolve -match $IssuePattern -replace $IssueReplace, "Resolves #"
    }
    if ($Reference) {
        $Reference -match $IssuePattern -replace $IssueReplace, "re #"
    }
)  -join ', '

# First up is Convential Commits
if ($type) #  (if -Type was provided)
{
    if (-not $Description) {
        if ($Title) {
            $Description = $title
            $title = ''
        }
        elseif ($Message) {
            $Description = $Message
            $Message = ''
        }
        elseif ($body) {
            $Description = $Body
            $Message = ''
        }
    }
    "-m"
    # construct a conventional commit message.
    "${type}$(if ($scope) { "($scope)" }): $Description$(if ($Fixes) { " ( $fixes )"})" 
}

# If title was provided, pass it as a message
elseif ($Title) {
    if ($Fix) {
        if ($Title) {"-m";"$title$(if ($Fixes) { " ( $fixes )"})"}
    } else {
        if ($Title) {"-m";$title}
    }
}

# If -Message was provided, pass that as a message, too.
if ($Message) {
    "-m"
    $message
}

# If Body was provided, it counts as a message.
if ($Body) {"-m";$body}
elseif (
    # f someone passed description but not type, that should also count.    
    $Description -and -not $type
) {
    "-m";$Description
}

if ($Footer) {
    "-m";$Footer
}

# If CoAuthoredBy was provided, add it as a trailer.
if ($CoAuthoredBy) {
    if (-not $trailers['Co-authored-by']) {
        $Trailers['Co-authored-by'] = @()
    }
    $Trailers['Co-authored-by'] += $CoAuthoredBy
}

if ($Trailers.Count) {    
    foreach ($kv in $Trailers.GetEnumerator()) {
        foreach ($val in $kv.Value) {
            "--trailer=$($kv.Key -replace ':','_colon_' -replace '\s', '-')=$val"
        }        
    }
}

if ($amend) {
    "--amend"   
}

if ($CommitDate) {
    "--date"        
    $CommitDate.ToString("o")
}