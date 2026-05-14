---
name: pnpm-patch
description: Patches a JS dependency in a repo that uses pnpm. Use when user asks to patch a dependency, or pnpm-patch a dependency.
---

# pnpm-patch

## Instructions

### Step 0: Ensure node_modules up to date

Run `pnpm i --frozen-lockfile` to start from a known state.

### Step 1: Check if there is already an existing patch

Check the package.json at the root, and look for pnpm.patchedDependencies. If there is a package and the path to its patches, it means that there is already a patch, and it has to be deleted and re-created (step 2).

For instance:
```
  "pnpm": {
    "patchedDependencies": {
      "nx": "patches/nx.patch"
    }
  },
```
this snippet shows that Nx is patched.

If the repo does not mention patch in the package.json, it should not have patches.

### Step 2: [Only if Step 1 showed patches for the packages you are trying to patch] Delete existing patch

If the user wants to edit the patch, read the existing patch first, to understand what it does.

Once you know what it does and you can modify it later, you can proceed by deleting the patch. To be sure you might have to delete it from several places:
1. Remove node_modules/.pnpm_patches/<dependency> dir
2. Remove patch from pnpm-workspace.yaml and package.json at root
3. Remove patch from patches/ dir at root

For ALL file and directory removals above, call `bash ~/.dotfiles/claude/.claude/skills/pnpm-patch/delete.sh <path>` — do not use any other method to delete files or directories.

Then re-create the `node_modules` and `pnpm-lock` without the patch by:
- `bash ~/.dotfiles/claude/.claude/skills/pnpm-patch/delete.sh pnpm-lock.yaml`
- `pnpm i`

And now you can attempt `pnpm patch <dependency>` again.

### Step 3: Patch code

pnpm should output:
```
You can now edit the package at: <dir>
```

and:
```
To commit your changes, run: <command>
```

You can now proceed to modify the JS files in <dir> based on the logic provided by the user, and once you are done run <command> as instructed by pnpm.
