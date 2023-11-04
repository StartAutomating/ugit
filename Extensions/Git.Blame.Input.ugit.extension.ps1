<#
.SYNOPSIS
    Extends git blame's parameters
.DESCRIPTION
    Extends the parameters for git blame.
#>
[ValidatePattern('^git blame')]
[Management.Automation.Cmdlet("Use","Git")]
[CmdletBinding(PositionalBinding=$false)]
param(
# The line number (and relative offset)
[Parameter(ValueFromPipelineByPropertyName)]
[int[]]
$LineNumber,

# The blame pattern to look for.
[Parameter(ValueFromPipelineByPropertyName)]
[string[]]
$Pattern
)

process {
    
    # All git of these git blame parameters need to be after the input object:
    foreach ($gitArgToBe in @(
            if ($LineNumber) { # If a -LineNumber was provided
                # turn each pair into a range
                for ($LineNumberNumber = 0; $LineNumberNumber -lt $LineNumber.Length; $LineNumberNumber++) {                    
                    "-L" # (this will be specified by git blame's real parameter, '-L')
                    "$(
                        if ($LineNumberNumber -lt ($LineNumber.Length - 1)) {                            
                            "$($lineNumber[$LineNumberNumber]),$($lineNumber[$LineNumberNumber + 1])"       
                        } else {
                            # if there was only one of a pair, only grab that line.
                            "$($lineNumber[$LineNumberNumber]),1"
                        }
                    )"
                }
            }

            if ($Pattern) { # If a -Pattern was provided
                foreach ($linePattern in $pattern) {
                    "-L" # this also becomes '-L' in git blame
                    "$linePattern"
                }
            }
    )) {    
        $gitArgToBe | Add-Member NoteProperty AfterInput $true -Force -PassThru
    }
}
