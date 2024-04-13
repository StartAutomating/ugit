FROM mcr.microsoft.com/powershell
ENV PSModulePath ./Modules
COPY . ./Modules/ugit
RUN pwsh -c "New-Item -Path /root/.config/powershell/Microsoft.PowerShell_profile.ps1 -Value 'Import-Module ugit' -Force"
RUN apt-get update && apt-get install -y git curl ca-certificates libc6 libgcc1

