<#
.SYNOPSIS
    Stops the container.
.DESCRIPTION
    This script is called when the container is about to stop.

    It can be used to perform any necessary cleanup before the container is stopped.
#>
param()
"Container now exiting, thank you for using ugit!" | Out-Host
