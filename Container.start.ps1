<#
.SYNOPSIS
    Starts the container.
.DESCRIPTION
    Starts a container.

    This script should be called from the Dockerfile as the ENTRYPOINT (or from within the ENTRYPOINT).

    It should be deployed to the root of the container image.

    ~~~Dockerfile
    # Thank you Microsoft!  Thank you PowerShell!  Thank you Docker!
    FROM mcr.microsoft.com/powershell
    # Set the shell to PowerShell (thanks again, Docker!)
    SHELL ["/bin/pwsh", "-nologo", "-command"]
    # Run the initialization script.  This will do all remaining initialization in a single layer.
    RUN --mount=type=bind,src=./,target=/Initialize ./Initialize/Container.init.ps1

    ENTRYPOINT ["pwsh", "-nologo", "-file", "/Container.start.ps1"]
    ~~~
#>
# using namespace 'ghcr.io/startautomating/ugit'

param()

if ($args) {
    # If there are arguments, output them (you could handle them in a more complex way).
    "$args" | Out-Host
} else {
    # If there are no arguments, see if there is a Microservice.ps1
    if (Test-Path './Microservice.ps1') {
        # If there is a Microservice.ps1, run it.
        . ./Microservice.ps1
    }
}

# If you want to do something when the container is stopped, you can register an event.
# This can call a script that does some cleanup, or sends a message as the service is exiting.
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    if (Test-Path /Container.stop.ps1) {
        & /Container.stop.ps1
    }
} | Out-Null