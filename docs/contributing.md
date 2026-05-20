# ugit contribution guide

Contributions are welcome!

You can contribute by:

* Filing an issue
* Starting a discussion
* Writing code and submitting a pull request

If you just want to contribute thoughts or ideas, that's fine.  We love new ideas!

If you're contributing code, please read the rest of this guide.

## ugit code contributions

We welcome code changes!

* Please file an issue first, or refer to an open issue.
* Please use inline help.

Here's how you can update ugit:

### Extending git

Most changes will be to the `/Extensions`:  These describe how we work with ugit.

There are two types of extensions:  Input and Output extensions.

* Input Extensions allow us to extend parameters
  * They must have a `[Management.Automation.Cmdlet('Use','Git')]` attribute
  * They must have a `[ValidatePattern]` attribute that matches the base git command line
  * They should be named `*.input.ugit.extension.ps1`
  * They must be named `*.ugit.extension.ps1`
  * They should return any additional arguments to git
* Output extensions allow us to parse output
  * They must have a `[Management.Automation.Cmdlet('Out','Git')]` attribute
  * They must have a `[ValidatePattern]` attribute that matches the base git command line
  * They must be named `*.ugit.extension.ps1`
  * They should parse output and return objects
  * Objects returned should use a PSTypeName to describe their type
    * This allows return objects to be extended and formatted.

### Extending Types and Formatting

Types and Formatting definitions are defined beneath `/Types`.

They are authored with the help of [EZOut](https://github.com/StartAutomating/EZOut)

* The name of the directory is the type name.
* Formatting will be described in a `*.format.ps1` file.  
* All other files extend the type.
  * `SomeMethod.ps1` describes a method
  * `get_SomeProperty.ps1` describes a property get
  * `set_SomeProperty.ps1` describes a property set
  * `Alias.psd1` describes any aliase properties or methods
  * `DefaultDisplay.txt` describes the default display properties


### Commit Format

Because this is a git project, we prefer to leverage it and have high standards for our git.

1. Please use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
2. Please note all work related to an issue by number.

You can do this in ugit with the extended parameters of `git commit`

~~~PowerShell
git commit -type feat -Scope area -Title "Short note" -Description "Longer note" -Fix 123
~~~

FYI, `-Fix` can take a range of issues.

~~~PowerShell
# Passing a list of issues
git commit -type feat -Scope area -Title "Short note" -Description "Longer note" -Fix 123, 456

# Being fancy and using the range operator 
git commmit -type feat -Scope area -Title "Title" -Description "Body" -Fix (123..125)
~~~

That stated, we prefer to intermingle fixes as little as possible.

Please also try to avoid merges followed by appended commits.  

We have found that this easy error makes the commit history harder to follow, especially on GitHub.

We understand that we are all error prone, and do not expect perfect git structure.  

Please try to keep our `git log` useful.

Thank you for considering contributing.  Please help!
