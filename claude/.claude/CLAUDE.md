Follow these instructions for any task that you are doing, unless user specifically asks for the opposite.

# Avoid using git commands that modify the state if .jj/ dir is present

Repositories with a `./jj` folder use jj as VCS on top of git. This means that using git commands that modify git's state (commit, stash, fetch, checkout, etc.) can break jj.
Read-only commands (log, branch --list, diff, etc.) are OK to use.

# Avoid removing files or directories with rm

Instead, use `bash ~/.claude/skills/utils/delete.sh <path>`
