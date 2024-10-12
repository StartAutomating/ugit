<#
.SYNOPSIS
    Extracts Jira ticket numbers from commit messages.
.DESCRIPTION
    Extracts Jira ticket numbers from commit messages.  
    
    Returns a list of objects with the ProjectName and TicketNumber properties.
.EXAMPLE
    # Get the Jira ticket information from the current branch.
    git log -CurrentBranch | Where-Object JiraTicket
#>
foreach ($match in [Regex]::new("(?<ProjectName>\S+)-(?<TicketNumber>\d+)").Matches($this.CommitMessage)) {
    [PSCustomObject][Ordered]@{
        ProjectName = $match.Groups['ProjectName'].Value
        TicketNumber = [int]$match.Groups['TicketNumber'].Value
    }
}