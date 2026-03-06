#!/usr/bin/env python3

import subprocess
import sys

def run(cmd, capture=False):
    """Run a shell command. Returns stdout if capture=True."""
    if capture:
        return subprocess.run(
            cmd, shell=True, capture_output=True, text=True, check=True
        ).stdout.strip()
    else:
        subprocess.run(cmd, shell=True, check=True)

def is_bookmark_line(line):
    """Check if a line represents a bookmark (not a remote tracking line)."""
    stripped = line.strip()
    if not stripped:
        return False
    # Skip lines that start with @origin or @git (remote tracking)
    if stripped.startswith("@origin") or stripped.startswith("@git"):
        return False
    return True

def main():
    # Step 1: Get bookmarks from the parent commit
    bookmarks_output = run("jj b l -r @-", capture=True)

    # Step 2: Parse bookmark names, filtering out remote tracking lines
    bookmarks = []
    for line in bookmarks_output.splitlines():
        if is_bookmark_line(line):
            bookmark_name = line.split(":", 1)[0]
            bookmarks.append(bookmark_name)

    # Step 3: Check number of bookmarks
    if len(bookmarks) == 0:
        sys.exit("Error: No bookmarks in parent commit.")
    elif len(bookmarks) > 1:
        bookmark_list = "\n  - ".join(bookmarks)
        sys.exit(
            f"Error: More than one bookmark in parent commit. "
            f"Could not determine the one to push.\n\n"
            f"Found {len(bookmarks)} bookmarks:\n  - {bookmark_list}"
        )
    
    # Step 4: Push the single bookmark
    bookmark_to_push = bookmarks[0]
    print(f"Pushing bookmark: {bookmark_to_push}")
    run(f"jj git push -b {bookmark_to_push}")

if __name__ == "__main__":
    main()

