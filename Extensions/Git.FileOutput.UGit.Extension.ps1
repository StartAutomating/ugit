<#
.Synopsis
    Git FileOutput Extension
.Description
    This extension runs on any command that includes the argument -o, followed by a single space.
    
    When the command is finished, this will attempt to file the argument provided after -o, and return it as a file.
.EXAMPLE
    git archive -o My.zip
#>
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("-o\s{0}")]                  # that is run when the switch -o is used.
param(
)

end {
    # Walk over each argument
    for ($i = 0 ; $i -lt $GitArgument.Length; $i++) {
        if ($GitArgument[$i] -eq '-o' -and   # If the argument is -o
            $i -lt ($GitArgument.Length - 1) # and it's not the last argument
        ) {
            $fileName = $GitArgument[$i + 1] # treat the next argument as the filename
            Get-Item $fileName -ErrorAction SilentlyContinue # and attempt to get the file.
        }
    }
}
