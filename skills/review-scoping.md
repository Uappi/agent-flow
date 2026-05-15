---
shortDescription: Groups a file list into LOC-bounded review blocks respecting module co-location.
usedBy: [contextualizer]
version: 0.1.0
lastUpdated: 2026-05-14
---

## Purpose

Large changesets cannot be reviewed in a single pass without quality degradation. This skill defines how to partition a file list into review blocks that stay within LOC limits while keeping files from the same module together — so each review pass has coherent scope and the reviewer can reason about the change locally.

## Procedure

1. Receive a list of changed files with their LOC counts.
2. Sort files: group files in the same directory together. Across directories, order by descending LOC.
3. Assign files to blocks greedily: add the next file to the current block if it fits within the 1500 LOC limit. Open a new block when the limit would be exceeded.
4. If a single file exceeds 1500 LOC and cannot be split further, place it alone in its own block and flag it as oversized.
5. Deliver the blocks in this format:

   ```
   ## Review Blocks

   ### Block N (LOC: ~N)
   - path/to/file
   - path/to/file
   ```

## Guardrails

- Never split files from the same directory across blocks unless the directory alone exceeds 1500 LOC.
- Never silently omit a file — every file in the input must appear in exactly one block.
- If a single file exceeds 1500 LOC, report it as oversized rather than forcing it into a block with other files.
