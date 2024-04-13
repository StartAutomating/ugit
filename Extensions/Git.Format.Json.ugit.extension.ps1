<#
.SYNOPSIS
    git json format
.DESCRIPTION
    Parses the output of git format, if the results are a series of json objects
.EXAMPLE
    git branch --format "{'ref':'%(refname:short)','parent':'%(parent)'}"
#>
[Management.Automation.Cmdlet("Out","Git")]   # It's an extension for Out-Git
[ValidatePattern("\s-{2}format.+?[\[\{].+?[\]\}]", Options = 'IgnoreCase,IgnorePatternWhitespace'
)]
param()


process {
    $gitOutJson = try { 
        if ($gitOut) { $gitOut | ConvertFrom-Json}
    } catch {
        $null
    }
    if ($gitOutJson) {
        $gitOutJson
        return
    }
    else {
        return $gitOut
    }
}
