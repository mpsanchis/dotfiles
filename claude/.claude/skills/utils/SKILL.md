---
name: utils
description: Utility scripts for common file system operations. Use when you need to delete files or directories and encounter permission errors with `rm`, or when any other skill instructs you to use these utilities.
---

# utils

This skill provides helper shell scripts for file system operations that require elevated or pre-approved permissions.

## Scripts

### `delete.sh` — Remove files and directories

**Path**: `~/.dotfiles/claude/.claude/skills/utils/delete.sh`

**Purpose**: Wraps `rm -rf` to delete files and directories. Use this script whenever you need to remove files or directories. **Do NOT use `rm` directly** — it will result in a permission error. Always delegate deletions to this script.

**Usage**:
```bash
bash ~/.dotfiles/claude/.claude/skills/utils/delete.sh <path> [<path2> ...]
```

**Examples**:
```bash
# Delete a single file
bash ~/.dotfiles/claude/.claude/skills/utils/delete.sh path/to/file.txt

# Delete a directory recursively
bash ~/.dotfiles/claude/.claude/skills/utils/delete.sh path/to/directory/

# Delete multiple targets at once
bash ~/.dotfiles/claude/.claude/skills/utils/delete.sh dist/ node_modules/ build/
```

> **Important**: Always use this script for any file or directory removal. Never call `rm` directly.
