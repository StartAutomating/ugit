<#
.Synopsis
    Git FileName Extension
.Description
    This extension runs on any command that includes the argument -name-only.

    It will attempt to treat each name as a file.
    
    If that fails, it will output a Git.Object.Name.
.EXAMPLE
    git diff --name-only
#>
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("\s{1,}--name-only")]        # that is run when the --name-only switch is used
[OutputType([IO.FileInfo])]
[OutputType('Git.FileInfo')]
[OutputType('Git.Object.Name')]
param(
)

begin {
    
    $allLines = @()
    $relatedCommit = $null 
}

process {
    if ($_ -like 'warning:*') {
        return
    }
    $allLines += $_
    # Git log loves to return the commit message _and_ the name
    if ($gitCommand -like 'git log*') { 
        # Thus the git log extension should handle this, unless --oneline was passed
        if ($gitCommand -notlike '*--oneline*') {
            return            
        }
        # In which case, we ignore all lines that start with a hash
        if ($_ -match '^[a-f0-9]{6,}') {
            $relatedCommit = $matches.0
            return
        }       
    }
    
    $gitName = "$_"
    $potentialPath = Join-Path $gitRoot $gitName
    if (Test-Path $potentialPath) {
        $pathItem = Get-Item $potentialPath 
        $pathItem | 
            Add-Member NoteProperty GitRoot $gitRoot -Force -PassThru | 
            Add-Member NoteProperty GitCommand $gitCommand -Force
        if ($relatedCommit) {
            $pathItem | 
                Add-Member NoteProperty CommitHash $relatedCommit -Force
        }
        $pathItem.pstypenames.insert(0,'Git.FileInfo')
        $pathItem
    } else {
        [PSCustomObject][Ordered]@{
            PSTypeName = 'Git.Object.Name'
            Name = "$_"
            GitRoot = $gitRoot
            GitCommand = $gitCommand
        }
    }

}