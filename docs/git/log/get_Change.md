get_Change
----------

### Synopsis
Gets the changes in a git commit

---

### Description

Gets the changes in a git commit.  This function is used to get the changes in a git commit.

The changes are returned as a PSCustomObject with the following properties:

- FilePath: The path of the file that was changed
- LinesChanged: The number of lines changed in the file
- LinesInserted: The number of lines inserted in the file
- LinesDeleted: The number of lines deleted in the file

---
