Get-GitPrompt
-------------

### Synopsis
Git Prompt

---

### Description

Git friendly PowerShell prompt.

Shows current branch, modified, untracked, added, and removed files.

---

### Parameters
#### **BranchIcon**
The icon used for git branches.
By default `⑆` (OCR Branch Bank Identification [0x2446])

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

#### **SuccessIcon**
The prompt icon after a successful command.
By default, `≻` (Succeeds [0x227b])

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

#### **ErrorIcon**
By default, `≻` (Does not Succeed [0x2281])

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |

#### **HomeIcon**
The home icon.
This is displayed when the path is 
beneath the user home directory.
By default: `⌂` (House [0x2302])

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |4       |false        |

#### **BranchOpenIcon**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |5       |false        |

#### **BranchCloseIcon**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |6       |false        |

#### **JobIcon**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |7       |false        |

#### **Slash**
The icon used for slash.
This will separate directories.
By default ` ⹊ ` (Dotted Solidus [0x2e4a])

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |8       |false        |

#### **SuccessStyle**
The style to use when things succeed

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |9       |false        |

#### **ErrorStyle**
The style to use when things fail

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |10      |false        |

#### **WarningStyle**
The style to use when warning

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |11      |false        |

#### **InfoStyle**
The style to use when cyan

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |12      |false        |

#### **UnknownStyle**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |13      |false        |

#### **BoldStyle**
The style to use when bolding text.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |14      |false        |

#### **BoldStyleOff**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |15      |false        |

#### **ResetStyle**
The string used to reset styles.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |16      |false        |

#### **ShowHistoryId**
If set, will display the history ID

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Get-GitPrompt [[-BranchIcon] <String>] [[-SuccessIcon] <String>] [[-ErrorIcon] <String>] [[-HomeIcon] <String>] [[-BranchOpenIcon] <String>] [[-BranchCloseIcon] <String>] [[-JobIcon] <String>] [[-Slash] <String>] [[-SuccessStyle] <String>] [[-ErrorStyle] <String>] [[-WarningStyle] <String>] [[-InfoStyle] <String>] [[-UnknownStyle] <String>] [[-BoldStyle] <String>] [[-BoldStyleOff] <String>] [[-ResetStyle] <String>] [-ShowHistoryId] [<CommonParameters>]
```
