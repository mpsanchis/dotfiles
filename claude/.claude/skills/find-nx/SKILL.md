---
name: find-nx
description: Use whenever a log contains `node_modules/nx` or `node_modules/.pnpm/nx*`, or any error happens in a repository that uses nx to build. It is easier to parse the source typescript code than the compiled JS in node_modules.
---

# find-nx

The nx source code is available locally at ~/development/nx.

When debugging nx-related errors, read the TypeScript source files there instead of the compiled JavaScript in node_modules. The source is much easier to understand and navigate.

The source layout follows the nx monorepo structure under `packages/`.
