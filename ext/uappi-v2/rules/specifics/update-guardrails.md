---
shortDescription: Safe update rules when merging core into especifico/.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

- MUST classify before suggesting any change.
- MUST NOT replace entire files from core without analysis.
- MUST NOT remove customization without documenting impact.
- MUST suggest incremental merge for MODIFIED files.
- MUST ask the user before applying patches to disk (compare mode is read-only).
- MUST treat all client differences as intentional until classified otherwise.

## Rationale

Overrides extend or patch core classes; destructive sync breaks client clouds in production.
