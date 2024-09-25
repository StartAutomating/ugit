﻿<#
.Synopsis
    GitHub Action for ugit
.Description
    GitHub Action for ugit.  This will:

    * Import ugit and Connect-GitHub (giving easy access to every GitHub API)
    * Run all *.ugit.ps1 files beneath the workflow directory
    * Run a .ugitScript parameter.


    If you will be making changes using the GitHubAPI, you should provide a -GitHubToken
    If none is provided, and ENV:GITHUB_TOKEN is set, this will be used instead.
    Any files changed can be outputted by the script, and those changes can be checked back into the repo.
    Make sure to use the "persistCredentials" option with checkout.

#>

param(
# A PowerShell Script that uses ugit.  
# Any files outputted from the script will be added to the repository.
# If those files have a .Message attached to them, they will be committed with that message.
[string]
$UGitScript,

# If set, will not process any files named *.ugit.ps1
[switch]
$SkipUGitPS1,

# A list of modules to be installed from the PowerShell gallery before scripts run.
[string[]]
$InstallModule,

# If provided, will commit any remaining changes made to the workspace with this commit message.
[string]
$CommitMessage,

# The user email associated with a git commit.
[string]
$UserEmail,

# The user name associated with a git commit.
[string]
$UserName
)

$ErrorActionPreference = 'continue'
"::group::Parameters" | Out-Host
[PSCustomObject]$PSBoundParameters | Format-List | Out-Host
"::endgroup::" | Out-Host

$gitHubEvent = 
    if ($env:GITHUB_EVENT_PATH) {
        [IO.File]::ReadAllText($env:GITHUB_EVENT_PATH) | ConvertFrom-Json
    } else { $null }

$anyFilesChanged = $false
$moduleName = 'ugit'
$actorInfo = $null

"::group::Parameters" | Out-Host
[PSCustomObject]$PSBoundParameters | Format-List | Out-Host
"::endgroup::" | Out-Host

function InstallActionModule {
    param([string]$ModuleToInstall)
    $moduleInWorkspace = Get-ChildItem -Path $env:GITHUB_WORKSPACE -Recurse -File |
        Where-Object Name -eq "$($moduleToInstall).psd1" |
        Where-Object { 
            $(Get-Content $_.FullName -Raw) -match 'ModuleVersion'
        }
    if (-not $moduleInWorkspace) {
        Install-Module $moduleToInstall -Scope CurrentUser -Force
        Import-Module $moduleToInstall -Force -PassThru | Out-Host
    }
}
function ImportActionModule {
    #region -InstallModule
    if ($InstallModule) {
        "::group::Installing Modules" | Out-Host
        foreach ($moduleToInstall in $InstallModule) {
            InstallActionModule -ModuleToInstall $moduleToInstall
        }
        "::endgroup::" | Out-Host
    }
    #endregion -InstallModule

    if ($env:GITHUB_ACTION_PATH) {
        $LocalModulePath = Join-Path $env:GITHUB_ACTION_PATH "$moduleName.psd1"        
        if (Test-path $LocalModulePath) {
            Import-Module $LocalModulePath -Force -PassThru | Out-String
        } else {
            throw "Module '$moduleName' not found"
        }
    } elseif (-not (Get-Module $moduleName)) {    
        throw "Module '$ModuleName' not found"
    }

    "::notice title=ModuleLoaded::$ModuleName Loaded from Path - $($LocalModulePath)" | Out-Host
    if ($env:GITHUB_STEP_SUMMARY) {
        "# $($moduleName)" |
            Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
    }
}
function InitializeAction {
    #region Custom 
    #endregion Custom

    # Configure git based on the $env:GITHUB_ACTOR
    if (-not $UserName) { $UserName = $env:GITHUB_ACTOR }
    if (-not $actorID)  { $actorID = $env:GITHUB_ACTOR_ID }
    $actorInfo = Invoke-RestMethod -Uri "https://api.github.com/user/$actorID"
    if (-not $UserEmail) { $UserEmail = "$UserName@noreply.github.com" }
    git config --global user.email $UserEmail
    git config --global user.name  $actorInfo.name

    # Pull down any changes
    git pull | Out-Host
}

function InvokeActionModule {
    $myScriptStart = [DateTime]::Now
    $myScript = $ExecutionContext.SessionState.PSVariable.Get("${ModuleName}Script").Value
    if ($myScript) {
        Invoke-Expression -Command $myScript |
            . ProcessOutput |
            Out-Host
    }
    $myScriptTook = [Datetime]::Now - $myScriptStart
    $MyScriptFilesStart = [DateTime]::Now

    $myScriptList  = @()
    $shouldSkip = $ExecutionContext.SessionState.PSVariable.Get("Skip${ModuleName}PS1").Value
    if (-not $shouldSkip) {
        Get-ChildItem -Recurse -Path $env:GITHUB_WORKSPACE |
            Where-Object Name -Match "\.$($moduleName)\.ps1$" |            
            ForEach-Object -Begin {
                if ($env:GITHUB_STEP_SUMMARY) {
                    "## $ModuleName Scripts" |
                        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
                } 
            } -Process {
                $myScriptList += $_.FullName.Replace($env:GITHUB_WORKSPACE, '').TrimStart('/')
                $myScriptCount++
                $scriptFile = $_
                if ($env:GITHUB_STEP_SUMMARY) {
                    "### $($scriptFile.Fullname)" |
                        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
                }
                $scriptCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand($scriptFile.FullName, 'ExternalScript')                
                foreach ($requiredModule in $CommandInfo.ScriptBlock.Ast.ScriptRequirements.RequiredModules) {
                    if ($requiredModule.Name -and 
                        (-not $requiredModule.MaximumVersion) -and
                        (-not $requiredModule.RequiredVersion)
                    ) {
                        InstallActionModule $requiredModule.Name
                    }
                }
                $scriptFileOutputs = . $scriptCmd
                if ($env:GITHUB_STEP_SUMMARY) {
                    "$(@($scriptFileOutputs).Length) Outputs" |                    
                        Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
                    "$(@($scriptFileOutputs).Length) Outputs" | Out-Host
                }
                $scriptFileOutputs |
                    . ProcessOutput  | 
                    Out-Host
            }
    }
    
    $MyScriptFilesTook = [Datetime]::Now - $MyScriptFilesStart
    $SummaryOfMyScripts = "$myScriptCount $moduleName scripts took $($MyScriptFilesTook.TotalSeconds) seconds" 
    $SummaryOfMyScripts | 
        Out-Host
    if ($env:GITHUB_STEP_SUMMARY) {
        $SummaryOfMyScripts | 
            Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
    }
    #region Custom    
    #endregion Custom
}

function PushActionOutput {
    if ($anyFilesChanged) {
        "::notice::$($anyFilesChanged) Files Changed" | Out-Host        
    }
    if ($CommitMessage -or $anyFilesChanged) {
        if ($CommitMessage) {
            Get-ChildItem $env:GITHUB_WORKSPACE -Recurse |
                ForEach-Object {
                    $gitStatusOutput = git status $_.Fullname -s
                    if ($gitStatusOutput) {
                        git add $_.Fullname
                    }
                }
    
            git commit -m $ExecutionContext.SessionState.InvokeCommand.ExpandString($CommitMessage)
        }
    
        $checkDetached = git symbolic-ref -q HEAD
        if (-not $LASTEXITCODE) {
            "::notice::Pushing Changes" | Out-Host
            git push
            "Git Push Output: $($gitPushed  | Out-String)"
        } else {
            "::notice::Not pushing changes (on detached head)" | Out-Host
            $LASTEXITCODE = 0
            exit 0
        }
    }
}

filter ProcessOutput {
    $out = $_
    $outItem = Get-Item -Path $out -ErrorAction Ignore
    if (-not $outItem -and $out -is [string]) {
        $out | Out-Host
        if ($env:GITHUB_STEP_SUMMARY) {
            "> $out" | Out-File -Append -FilePath $env:GITHUB_STEP_SUMMARY
        }
        return
    }
    $fullName, $shouldCommit = 
        if ($out -is [IO.FileInfo]) {
            $out.FullName, (git status $out.Fullname -s)
        } elseif ($outItem) {
            $outItem.FullName, (git status $outItem.Fullname -s)
        }
    if ($shouldCommit) {
        "$fullName has changed, and should be committed" | Out-Host
        git add $fullName
        if ($out.Message) {
            git commit -m "$($out.Message)" | Out-Host
        } elseif ($out.CommitMessage) {
            git commit -m "$($out.CommitMessage)" | Out-Host
        }  elseif ($gitHubEvent.head_commit.message) {
            git commit -m "$($gitHubEvent.head_commit.message)" | Out-Host
        }
        $anyFilesChanged = $true
    }    
    $out
}

. ImportActionModule
. InitializeAction
. InvokeActionModule
. PushActionOutput