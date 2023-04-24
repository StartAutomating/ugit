foreach ($attr in $this.ScriptBlock.Attributes) {
    if ($attr -is [Management.Automation.ValidatePatternAttribute]) {
        $attr.RegexPattern
    }
}
