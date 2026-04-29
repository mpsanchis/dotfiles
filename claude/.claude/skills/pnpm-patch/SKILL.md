---
name: pnpm-patch
description: Patches a JS dependency in a repo that uses pnpm. Use when user asks to patch a dependency, or pnpm-patch a dependency.
---

# pnpm-patch

## Instructions

### Step 1: Check if there is already an existing patch

Run `pnpm patch <dependency>`, and see if it returns an error. If it returns an error such as:
```
The directory /path/to/repo/node_modules/.pnpm_patches/<dependency>@<version> is not empty
```

it means that there is already a patch, and it has to be deleted and re-created (step 2).

If it does not return an error, go to Step 3.

### Step 2: [Only if Step 1 threw an error] Delete existing patch

If the user wants to edit the patch, read the existing patch first, to understand what it does.

Once you know what it does and you can modify it later, you can proceed by deleting the patch. To be sure you might have to delete it from several places:
1. Remove node_modules/.pnpm_patches/<dependency> dir
2. Remove patch from pnpm-workspace.yaml and package.json at root
3. Remove patch from patches/ dir at root

Then re-create the `node_modules` and `pnpm-lock` withouth the patch by:
- `rm pnpm-lock.yaml`
- `pnpm i`

And now you can attempt `pnpm patch <dependency` again.

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
