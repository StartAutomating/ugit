Write-FormatView -TypeName Git.Status.Short -Action {
    $in = $_
    
    @(
        if ($in.Status) {
            $in.Status
        }
        foreach ($short in $in.Short) {
            @(
                foreach ($letter in $short.Staged,$short.Unstaged) {
                    switch ($letter) {
                        M { $PSStyle.Foreground.Cyan; $_}
                        R { $PSStyle.Foreground.Red;$_}
                        N { $PSStyle.Foreground.Green;$_}
                        ? { $PSStyle.Foreground.Magenta;$_}
                        default { $_ }
                    }
                }
                        
                ' '
                $short.Path
                $PSStyle.Reset
            ) -join ''
        }        
    ) -join [Environment]::NewLine
    
}

