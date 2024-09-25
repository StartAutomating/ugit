# Thank you Microsoft!  Thank you PowerShell!  Thank you Docker!
FROM mcr.microsoft.com/powershell

# Set the shell to PowerShell
SHELL ["/bin/pwsh", "-nologo", "-command"]

# Run the initialization script
RUN --mount=type=bind,src=./,target=/Initialize ./Initialize/Container.init.ps1

ENTRYPOINT [ "/bin/pwsh", "-nologo", "-noexit","-file", "./Container.start.ps1" ]