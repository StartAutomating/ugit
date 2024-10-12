git.log.get_JiraTicket()
------------------------

### Synopsis
Extracts Jira ticket numbers from commit messages.

---

### Description

Extracts Jira ticket numbers from commit messages.  

Returns a list of objects with the ProjectName and TicketNumber properties.

---

### Examples
Get the Jira ticket information from the current branch.

```PowerShell
git log -CurrentBranch | Where-Object JiraTicket
```

---
