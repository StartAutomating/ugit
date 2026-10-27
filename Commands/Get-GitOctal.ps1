function Get-GitOctal {
    <#
    .SYNOPSIS
        Gets Git Octal strings
    .DESCRIPTION
        Gets Git Octal strings as the current output encoding.
    #>
    [Alias('git.octal')]
    param(
    # An octal string
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $OctalString
    )

    process {
        # So we want to decode an octal string from git.
        [Regex]::Replace(
            # First we trim leading and trailing quotes.  Easy.
            $OctalString -replace '^"|"$',
            # Then we look for any sequence of slash + 3 digits [0-7]
            "(?:\\[0-7]{3}){1,}",
            # And replace them with this short script
            {                        
                param($match)
                # We want them back as UTF8
                $OutputEncoding.GetString(
                    # But these bytes are encoded with                            
                    # [ISO-8859-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1)
                    [Text.Encoding]::GetEncoding('ISO-8859-1').GetBytes(
                        # The match contains the sequence
                        @(
                            foreach (
                                # so we split it up
                                # (which removes the slash)
                                $octalByte in $match -split '\\' -ne ''
                            ) {
                                # then we convert each byte in base 8
                                [Convert]::ToByte($octalByte,8) -as
                                    [char] # and make it a character
                            }
                        ) -join '' # then we join our characters,
                    ) # get their bytes,
                ) # and output the replaced string.
            }
        )        
    }
}
