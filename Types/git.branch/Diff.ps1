param()

$firstArg, $restOfArgs =
if (-not $args) {
    git remote | git remote show | Select-Object -ExpandProperty HeadBranch -First 1  
} else {
    $args | Select-Object -First 1
    $args | Select-Object -Skip 1
}

$restOfArgs = @($restOfArgs)

Push-Location $this.GitRoot
git diff "$($firstArg)..$($this.BranchName)" @restOfArgs
Pop-Location