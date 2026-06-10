#!/usr/bin/env python3
"""Shared utilities for jj-g* scripts."""

import subprocess
import sys


# ---------------------------------------------------------------------------
# Shell execution
# ---------------------------------------------------------------------------

def is_workspace_stale():
    """Check if the jj working copy is stale."""
    try:
        subprocess.run(
            "jj status", shell=True, capture_output=True, text=True, check=True
        )
        return False
    except subprocess.CalledProcessError as e:
        err_msg = (e.stderr or "") + (e.stdout or "")
        return "stale" in err_msg.lower() and "update-stale" in err_msg.lower()


def run(cmd, capture=False):
    """
    Run a shell command, with automatic stale-workspace recovery.
    Returns stdout (stripped) if capture=True, else None.
    Raises CalledProcessError on unrecoverable failure.
    """
    try:
        if capture:
            return subprocess.run(
                cmd, shell=True, capture_output=True, text=True, check=True
            ).stdout.strip()
        else:
            subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        # Check if the failure is due to a stale working copy
        is_stale = False
        if capture:
            err_msg = (e.stderr or "") + (e.stdout or "")
            if "stale" in err_msg.lower() and "update-stale" in err_msg.lower():
                is_stale = True
        else:
            if is_workspace_stale():
                is_stale = True

        if is_stale:
            print("Working copy is stale. Running `jj workspace update-stale`...", file=sys.stderr)
            try:
                subprocess.run("jj workspace update-stale", shell=True, check=True)
            except subprocess.CalledProcessError:
                print("Failed to update stale working copy.", file=sys.stderr)
                raise e  # Raise the original error

            # Retry
            if capture:
                return subprocess.run(
                    cmd, shell=True, capture_output=True, text=True, check=True
                ).stdout.strip()
            else:
                subprocess.run(cmd, shell=True, check=True)
        else:
            raise e


# ---------------------------------------------------------------------------
# Repo checks
# ---------------------------------------------------------------------------

def assert_jj_repo():
    """Exit with an error if the current directory is not inside a jj repo."""
    res = subprocess.run(
        "jj root --ignore-working-copy",
        shell=True, capture_output=True, text=True
    )
    if res.returncode != 0:
        err = res.stderr.strip() if res.stderr else 'Error: There is no jj repo in "."'
        print(err, file=sys.stderr)
        sys.exit(1)


# ---------------------------------------------------------------------------
# Bookmark helpers
# ---------------------------------------------------------------------------

def is_bookmark_line(line):
    """Return True if a line from `jj b l` represents a local bookmark."""
    stripped = line.strip()
    if not stripped:
        return False
    if stripped.startswith("@origin") or stripped.startswith("@git"):
        return False
    return True


def parse_bookmarks(output):
    """Parse bookmark names from the output of `jj b l`."""
    bookmarks = []
    for line in output.splitlines():
        if is_bookmark_line(line):
            bookmarks.append(line.split(":", 1)[0].strip())
    return bookmarks


def get_bookmarks_at_parent():
    """Return the list of local bookmark names at the parent commit (@-)."""
    output = run("jj b l -r @-", capture=True)
    return parse_bookmarks(output)


def get_single_bookmark_at_parent(action="operate on"):
    """
    Return the single bookmark name at @-.
    Exits with an error if there are zero or more than one.
    """
    bookmarks = get_bookmarks_at_parent()
    if len(bookmarks) == 0:
        sys.exit("Error: No bookmarks in parent commit (@-).")
    elif len(bookmarks) > 1:
        bookmark_list = "\n  - ".join(bookmarks)
        sys.exit(
            f"Error: More than one bookmark in parent commit (@-). "
            f"Could not determine the one to {action}.\n\n"
            f"Found {len(bookmarks)} bookmarks:\n  - {bookmark_list}"
        )
    return bookmarks[0]


def bookmark_exists(name):
    """Return True if a bookmark with the given name exists."""
    return bool(run(f"jj b l {name}", capture=True))


def detect_main_branch():
    """
    Return 'main' or 'master' depending on which bookmark exists.
    Exits with an error if neither is found.
    """
    output = run("jj b l", capture=True)
    all_names = parse_bookmarks(output)
    if "main" in all_names:
        return "main"
    elif "master" in all_names:
        return "master"
    sys.exit("Error: Could not find a 'main' or 'master' bookmark.")
