#!/usr/bin/env bash
set -euo pipefail

name="${1:-}"
# With no skill argument, "$0" isn't substituted and the shell expands it to
# its own name (e.g. /bin/zsh), so reject those along with empty/unsafe names.
if [[ -z "$name" || "$name" == '$0' || "$name" =~ ^-?(/bin/|/usr/bin/)?(zsh|bash|sh)$ \
      || ! "$name" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "Error: no valid name provided. Usage: /fork-tmux <name> [switch]" >&2
  exit 1
fi
switch="${2:-no}"
# An unset skill argument may arrive as the literal "$1".
[[ "$switch" == '$1' ]] && switch=no
session_id="${3:-}"

if [[ -z "$session_id" ]]; then
  echo "Error: missing Claude session ID." >&2
  exit 1
fi

cwd="$(pwd -P)"
base="$(basename "$cwd")"

# <parent>/<base>-worktrees/<name>, outside the repo so it isn't snapshotted.
workspace_path="$(dirname "$cwd")/${base}-worktrees/${name}"
# tmux session names can't contain '.' or ':'.
tmux_session="$(echo "${base}-${name}" | tr '.:' '--')"

if [[ -e "$workspace_path" ]]; then
  echo "Error: workspace path already exists: $workspace_path" >&2
  exit 1
fi

if tmux has-session -t "=$tmux_session" 2>/dev/null; then
  echo "Error: tmux session already exists: $tmux_session" >&2
  exit 1
fi

mkdir -p "$(dirname "$workspace_path")"

if jj root >/dev/null 2>&1; then
  # Default base is the parent(s) of the current working-copy commit, so
  # uncommitted changes in @ are not carried over. Add `-r @` to include them.
  jj workspace add --name "$name" "$workspace_path" >&2
  vcs=jj
elif git rev-parse --show-toplevel >/dev/null 2>&1; then
  git worktree add -b "$name" "$workspace_path" >&2
  vcs=git
else
  # No VCS: just an empty directory to resume the session in.
  mkdir "$workspace_path"
  vcs=none
fi

# Pre-generate the child ID so we can report it back to the parent.
child_id="$(uuidgen | tr 'A-Z' 'a-z')"

tmux new-session -d \
  -s "$tmux_session" \
  -c "$workspace_path" \
  claude --resume "$session_id" --fork-session --session-id "$child_id"

echo "child_session_id=$child_id"
echo "workspace=$workspace_path"
echo "vcs=$vcs"
echo "tmux=$tmux_session"

case "$(echo "$switch" | tr 'A-Z' 'a-z')" in
  yes|true|switch)
    if [[ -n "${TMUX:-}" ]]; then
      tmux switch-client -t "=$tmux_session"
    else
      echo "Not switching: the current shell is not inside tmux."
    fi
    ;;
esac
