---
name: fork-tmux
description: Create a jj workspace and resume a fork of this Claude session in a new tmux session.
argument-hint: <name> [switch]
disable-model-invocation: true
allowed-tools:
  - Bash
---

!`${CLAUDE_SKILL_DIR}/fork-tmux.sh "$0" "$1" "${CLAUDE_SESSION_ID}"`

The output above came from the fork script. Report the child_session_id,
workspace, and tmux session to the user in one short message. Do nothing else.
