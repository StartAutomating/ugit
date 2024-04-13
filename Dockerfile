FROM mcr.microsoft.com/powershell
ENV PSModulePath ./Modules
COPY . ./Modules/ugit
RUN apt-get update && apt-get install -y git curl ca-certificates libc6 libgcc1
RUN pwsh -c "if (-not (Test-Path \$Profile)) { New-Item -ItemType File -Path \$Profile -Force }"
RUN pwsh -c "Add-Content -Path \$Profile -Value 'Import-Module ugit'"