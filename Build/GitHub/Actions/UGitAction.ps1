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

"::group::Parameters" | Out-Host
[PSCustomObject]$PSBoundParameters | Format-List | Out-Host
"::endgroup::" | Out-Host

if ($env:GITHUB_ACTION_PATH) {
    $ugitModulePath = Join-Path $env:GITHUB_ACTION_PATH 'ugit.psd1'
    if (Test-path $ugitModulePath) {
        Import-Module $ugitModulePath -Force -PassThru | Out-String
    } else {
        throw "ugit not found"
    }
} elseif (-not (Get-Module ugit)) {    
    throw "Action Path not found"
}

#region -InstallModule
if ($InstallModule) {
    "::group::Installing Modules" | Out-Host
    foreach ($moduleToInstall in $InstallModule) {
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
    "::endgroup::" | Out-Host
}
#endregion -InstallModule

"::notice title=ModuleLoaded::ugit Loaded from Path - $($ugitModulePath)" | Out-Host

$anyFilesChanged = $false
$processScriptOutput = { process { 
    $out = $_
    $outItem = Get-Item -Path $out -ErrorAction SilentlyContinue
    $fullName, $shouldCommit = 
        if ($out -is [IO.FileInfo]) {
            $out.FullName, (git status $out.Fullname -s)
        } elseif ($outItem) {
            $outItem.FullName, (git status $outItem.Fullname -s)
        }
    if ($shouldCommit) {
        git add $fullName
        if ($out.Message) {
            git commit -m "$($out.Message)"
        } elseif ($out.CommitMessage) {
            git commit -m "$($out.CommitMessage)"
        }
        $anyFilesChanged = $true
    }
    $out
} }


if (-not $UserName) { $UserName = $env:GITHUB_ACTOR }
if (-not $UserEmail) { $UserEmail = "$UserName@github.com" }
git config --global user.email $UserEmail
git config --global user.name  $UserName

if (-not $env:GITHUB_WORKSPACE) { throw "No GitHub workspace" }

git pull | Out-Host

$ugitScriptStart = [DateTime]::Now
if ($ugitScript) {
    Invoke-Expression -Command $ugitScript |
        . $processScriptOutput |
        Out-Host
}
$ugitScriptTook = [Datetime]::Now - $ugitScriptStart
"::notice title=ugitScriptRuntime::$($ugitScriptTook.TotalMilliseconds)"   | Out-Host

$ugitPS1Start = [DateTime]::Now
$ugitPS1List  = @()
if (-not $SkipugitPS1) {
    Get-ChildItem -Recurse -Path $env:GITHUB_WORKSPACE |
        Where-Object Name -Match '\.ugit\.ps1$' |
        
        ForEach-Object {
            $ugitPS1List += $_.FullName.Replace($env:GITHUB_WORKSPACE, '').TrimStart('/')
            $ugitPS1Count++
            "::notice title=Running::$($_.Fullname)" | Out-Host
            . $_.FullName |            
                . $processScriptOutput  | 
                Out-Host
        }
}
$ugitPS1EndStart = [DateTime]::Now
$ugitPS1Took = [Datetime]::Now - $ugitPS1Start
"::notice title=ugitPS1Count::$($ugitPS1List.Length)"   | Out-Host
"::notice title=ugitPS1Files::$($ugitPS1List -join ';')"   | Out-Host
"::notice title=ugitPS1Runtime::$($ugitPS1Took.TotalMilliseconds)"   | Out-Host
if ($CommitMessage -or $anyFilesChanged) {
    if ($CommitMessage) {
        dir $env:GITHUB_WORKSPACE -Recurse |
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
        "Git Push Output: $($gitPushed  | Out-String)"
    } else {
        "::notice::Not pushing changes (on detached head)" | Out-Host
        $LASTEXITCODE = 0
        exit 0
    }
}
