<#
.SYNOPSIS
    Gets the date of a git log
.DESCRIPTION
    Gets the commit date of a git log entry.
#>
return [datetime]::ParseExact($this.CommitDateString.Trim(), "ddd MMM d HH:mm:ss yyyy K", [cultureinfo]::InvariantCulture)
