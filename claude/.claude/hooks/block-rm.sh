#!/bin/sh
# PreToolUse hook: block direct rm and point Claude to delete.sh
cmd=$(jq -r '.tool_input.command // empty')
case "$cmd" in
  rm|"rm "*)
    echo "Direct rm is not allowed. Use: bash ~/.claude/scripts/delete.sh <path> [<path2> ...]" >&2
    exit 2
    ;;
esac
exit 0
