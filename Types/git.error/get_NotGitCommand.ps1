if ($this -match "^git:\s'(?<cmd>.+?)'is not a git command.") {
    return $matches.cmd
}