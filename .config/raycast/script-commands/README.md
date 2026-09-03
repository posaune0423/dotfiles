# Raycast Script Commands

Raycast loads script commands from directories registered under
**Raycast Settings → Extensions → Script Commands → Add Directories**. Register
`~/.config/raycast/script-commands` once; the installer keeps that path linked to this
directory, so scripts committed here appear in Raycast on every machine.

Each script needs the Raycast metadata header. Minimal Bash example:

```bash
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Hello
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 👋

echo "hello"
```

Keep scripts free of tokens and machine-specific paths. Read secrets from the environment
or from an untracked file such as `~/.config/raycast/script-commands.local/`.
