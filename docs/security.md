# ugit security

ugit takes security seriously.  

If you feel like there is a serious concern, please file an issue.

Repository access is not something to be given lightly.

Because ugit is a powerful wrapper for git, it makes various operations considerably easier.

This can be useful for forensics, as it makes it easier to inspect logs.

It can be useful for automation, as it helps save steps when working with git.

Anything that effectively automates anything also has a dual-use potential for attack.

ugit is a module for PowerShell that will be commonly run in a terminal or action.

If an attacker can run this module and access your repository, security boundaries have already been crossed.

To slightly mitigate potential impact, ugit will generate events that can be logged or used to trigger action.

To see these events, use `Get-Event`.

### Pull Request Review

We will not accept pull requests that have not been reviewed for security impact.

1. We will not accept pull requests that transmit data to unknown hosts.
2. We will not accept pull requests that call unrelated or unknown commands.
3. We will not accept pull requests that use obfuscation or minification techniques.

We will not limit our review to only these concerns.
