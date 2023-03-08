# Formatting definitions for various outputs from Git.Remote

Write-FormatView -TypeName Git.Remote.Name -Property RemoteName -GroupByProperty GitRoot

Write-FormatView -TypeName Git.Remote.Url -Property RemoteName, RemoteUrl -GroupByProperty GitRoot
