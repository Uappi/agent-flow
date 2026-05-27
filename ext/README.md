# Product extensions (`ext/`)

Optional overlays for product-specific workflows. The AgentFlow **core** (`personas/`, `skills/`, `rules/` at `.agents/` root) stays generic.

## Layout

```
ext/<product-id>/
├── README.md
├── ROUTING.md          # Maestro reads when product is active
├── personas/
├── skills/
├── rules/
├── prompts/
└── templates/
```

## Activation

At boot, `skills/product-profile.md` detects signals in the **work repository** (not in `.agents/`) and writes `activeProducts` to session memory.

Maestro and `skills/dispatch.md` load `ext/<product-id>/` assets **only** when that id is in `activeProducts` or the task brief names the product.

## Frontmatter on extension files

```yaml
product: uappi-v2
scope: specifics-sync   # dispatch rule/skill filter
```

## Available extensions

| Product | Folder | Signals (summary) |
|---------|--------|-------------------|
| Uappi v2 | `ext/uappi-v2/` | Client: `especifico/` + `.wapstore/build` — Core: `wapstore/wapstore` remote or `core/wapstore/` |

See `docs/guide/product-extensions.md` to add a new product.
