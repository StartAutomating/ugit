<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
    git stash list
#>
[Management.Automation.Cmdlet("Out","Git")]           # It's an extension for Out-Git
[ValidatePattern("^git stash",Options='IgnoreCase')] # when the pattern is "git branch"
param(

)

begin {
    $stashLines = @()
}

process {
    $stashLines += $_
}

end {
    $stashOutputHandled = $false
    
    
    foreach ($stashLine in $stashLines) {
        if ($stashLine -eq 'No local changes to save') {
            return [PSCustomObject][Ordered]@{
                PSTypeName = 'git.stash.nothing'
                GitRoot = $GitRoot
                GitCommand = $GitCommand
                GitOutputLines = $stashLines
            }
            
        }

        if ($GitCommand -match '^git stash list') {
            if ($stashLine -match '^stash\@\{(?<Number>\d+)\}:\s{0,}(?<Message>.+$)') {
                $stashOutputHandled = $true
                [PSCustomObject][Ordered]@{
                    PSTypeName = 'git.stash.entry'
                    Number  = [int]$matches.Number
                    Message = $matches.Message
                    GitRoot = $GitRoot
                    GitCommand = $GitCommand
                    GitOutputLines = $stashLines
                }
            }
        }

        if ($GitCommand -eq 'git stash' -and 
            $stashLine -match 'Saved working directory and index state\s{0,}(?<Message>.+$)') {
            $stashOutputHandled = $true
            [PSCustomObject][Ordered]@{
                PSTypeName = 'git.stash.entry'
                Number  = [int]0
                Message = $matches.Message
                GitRoot = $GitRoot
                GitCommand = $GitCommand
                GitOutputLines = $stashLines
            }                        
        }
    }

    if (-not $stashOutputHandled) {
        $stashLines
    }
}
