---
shortDescription: Path mapping from client especifico/ to GitLab core at release tag.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

- The client overrides directory on disk MUST be named `especifico/` — do not expect `specifics/` on the client.
- Core counterparts MUST be read from GitLab project `agenciawebart/wapstore/wapstore` at the resolved release tag unless the task brief supplies another project path.
- `CORE_PATH` MUST be `core/` + relative path after stripping the `especifico/` prefix (example: `especifico/wapstore/classes/Foo.class.php` → `core/wapstore/classes/Foo.class.php`).
- **`target_release`** MUST come from the task brief (`Versão alvo do core (tag)`). Without it, stop.
- **`installed_release`** MAY be read from `.wapstore/build` for the report header only.
- Reports MUST be saved under `.memory/docs/specifics-sync/YYYY-MM-DD/`.

## Rationale

Client clouds mirror Wapstore layout under `especifico/` while the canonical core lives in the shared GitLab repo. Fixed mapping avoids comparing against compiled `bin/` and keeps overrides traceable to a single tag.
