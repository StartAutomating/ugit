Extensions/Git.Commit.Input.UGit.Extension.ps1
----------------------------------------------




### Synopsis
Git Commit Input



---


### Description

Makes Git Commit easier to use from PowerShell by providing parameters for the -Message, -Title, -Body, and -Trailers



---


### Examples
> EXAMPLE 1

```PowerShell
git commit -Title "Fixing Something"
```
> EXAMPLE 2

"}


---


### Parameters
#### **Message**

The message used for the commit






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **Title**

The title of the commit.  If -Message is also provided, this will become part of the -Body






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **Body**

The body of the commit.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **Trailers**

Any git trailers to add to the commit.
git trailers are key-value pairs you can use to associate metadata with a commit.
As this uses --trailer, this requires git version 2.33 or greater.






|Type           |Required|Position|PipelineInput|Aliases                                   |
|---------------|--------|--------|-------------|------------------------------------------|
|`[IDictionary]`|false   |named   |false        |Trailer<br/>CommitMetadata<br/>GitMetadata|



#### **Amend**

If set, will amend an existing commit.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
Extensions/Git.Commit.Input.UGit.Extension.ps1 [-Message <String>] [-Title <String>] [-Body <String>] [-Trailers <IDictionary>] [-Amend] [<CommonParameters>]
```
