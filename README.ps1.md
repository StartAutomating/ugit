<div align='center'>
<img src='assets/ugit.svg' alt='ugit' />
<a href='https://www.powershellgallery.com/packages/ugit/'>
<img src='https://img.shields.io/powershellgallery/dt/ugit' />
</a>
<br/>
<a href='https://github.com/sponsors/StartAutomating'>❤️</a>
<a href='https://github.com/StartAutomating/ugit/stargazers'>⭐</a>
</div>

ugit (Updated Git) is a powerful PowerShell module for git that lets you: output git as objects, automate multiple repos, and extend git.

## What is ugit?

ugit is a PowerShell module that gives you an updated git.  You can use the object pipeline to pipe folders or files into git.  
If you're using one of a number of supported commands, ugit will return your git output as objects.
This enables _a lot_ of interesting scenarios, giving you and updated way to work with git.

## Getting started

~~~PowerShell
# Install ugit from the PowerShell Gallery
Install-Module ugit -Scope CurrentUser
# Then import it.
Import-Module ugit -Force -PassThru

# Once you've imported ugit, just run git commands normally.
# If ugit has an extension for the command, it will output as an object.
# These objects can be formatted by PowerShell
git log -n 5 

# To get a sense of what you can do, pipe a given git command into Get-Member.
git log -n 5 |
  Get-Member
~~~

## How ugit works:

ugit only has a few commands:

### [Use-Git](docs/Use-Git.md)

After you've imported ugit, Use-Git is what will be called when you run "git".

This happens because Use-Git is aliased to "git", and aliases are resolved first in PowerShell.

Use-Git assumes all positional parameters are arguments to Git, and passes them on directly.

This works in almost every scenario, except with some single character git options.  You can pass these in quotes.

When Use-Git outputs, it sets $global:LastGitOutput and then pipes to Out-Git.

### [Out-Git](docs/Out-Git.md)

Out-Git will attempt to take git output and return it as a useful object.

This object can then be extended and formatted by PowerShell's Extended Type System.

Out-Git accomplishes this with several extensions.  You can list extensions with Get-UGitExtension:

### Get-UGitExtension

Get-UGitExtension enables any file beneath ugit (or a module that tags ugit) named *.ugit.extension.ps1 to be treated as an extension.

In ugit, extensions signal that they apply to a given git command by adding a ```[ValidatePattern]``` attribute to the command.

If this pattern matches the given git command, the extension will run.

Get-UGitExtension is built using [Piecemeal](https://github.com/StartAutomating/Piecemeal)

## ugit examples

ugit comes packed with many examples.
You might want to try giving some of these a try.

~~~PipeScript {
   $null = Import-Module .\ugit.psd1 -Global
    @(foreach ($ugitExt in Get-UGitExtension) {
        $examples = @($ugitExt.Examples)        
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            @("### $($ugitExt.DisplayName) Example $($exampleNumber)", 
                [Environment]::Newline,
                "~~~PowerShell",                
                $examples[$exampleNumber - 1],                
                "~~~") -join [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~

## Out-Git Extensions

### Git Commands

Most extensions handle output from a single git command.

~~~PipeScript {  
  Get-UGitExtension -CommandName Out-Git |
    Where-Object DisplayName -notIn 'Git.FileOutput' |
    .InputObject {
      "[$($_.DisplayName -replace '\.', ' ')]($('docs/' + $_.DisplayName + '-Extension.md'))"
    } .BulletPoint = { $true }
}
~~~

### Additional Output Extensions

A few extensions handle output from any number of git commands, depending on the arguments.

* Git.FileName

This applies to any git command that uses --name-only.
It will attempt to return the name as a file, or as an object containing the name.

* Git.FileOutput

This applies to an git command that uses the -o flag.
It will attempt to locate any output specified by -o and return it as a file or directory.

## Use-Git Extensions

ugit also allows you to extend the input for git.

~~~PipeScript {  
  Get-UGitExtension -CommandName Use-Git |
    .InputObject {
      "[$($_.DisplayName -replace '\.', ' ')]($('docs/' + $_.DisplayName + '-Extension.md'))"
    } .BulletPoint = { $true }
}
~~~

