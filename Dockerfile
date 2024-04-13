FROM mcr.microsoft.com/powershell

RUN apt-get update && apt-get install -y git curl ca-certificates libc6 libgcc1

ENV PSModulePath ./Modules

COPY . ./Modules/ugit

RUN pwsh -c "New-Item -ItemType File -Path \$Profile -Force -Value 'Import-Module ugit'"
