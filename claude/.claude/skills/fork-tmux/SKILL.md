---
name: fork-tmux
description: Resume a fork of this Claude session in a new tmux session, in a new jj workspace or git worktree (or the current directory outside a repo).
argument-hint: <name> [switch]
disable-model-invocation: true
allowed-tools:
  - Bash
---

!`${CLAUDE_SKILL_DIR}/fork-tmux.sh "$0" "$1" "${CLAUDE_SESSION_ID}"`

The output above came from the fork script. Report the child_session_id,
workspace, and tmux session to the user in one short message. Do nothing else.
