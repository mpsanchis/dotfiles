#!/usr/bin/env python3

import subprocess

def run(cmd, capture=False):
    """
    Run a shell command.
    If capture=True, return stdout as a string.
    Otherwise, just execute it.
    """
    if capture:
        return subprocess.run(
            cmd, shell=True, capture_output=True, text=True, check=True
        ).stdout.strip()
    else:
        subprocess.run(cmd, shell=True, check=True)


def bookmark_exists(name):
    """Return True if `jj b l <name>` returns non-empty."""
    return bool(run(f"jj b l {name}", capture=True))


def main():
    needs_main = bookmark_exists("main")
    needs_master = bookmark_exists("master")

    if needs_main or needs_master:
        run("jj git fetch")   # fetch once

    if needs_main:
        run("jj b m main --to=main@origin")

    if needs_master:
        run("jj b m master --to=master@origin")


if __name__ == "__main__":
    main()

