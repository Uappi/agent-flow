# Product extensions (`ext/`)

The AgentFlow core stays generic. Product-specific workflows live under `.agents/ext/<product-id>/` and activate only when the work repository matches detection signals.

## Boot

`skills/product-profile.md` runs after memory load and writes to the session file:

```markdown
## Product Context

activeProducts: [uappi-v2]
```

## Adding a product

1. Create `ext/<product-id>/` with `README.md`, `ROUTING.md`, and assets.
2. Add frontmatter `product: <product-id>` and `scope: <task-category>` on rules/skills.
3. Register signals in `skills/product-profile.md`.
4. Document triggers in `ext/<product-id>/README.md`.
5. If Maestro should route prompts, add a section to `personas/maestro.md` or keep all routes in `ROUTING.md` (preferred).

## Dispatch

`skills/dispatch.md` loads extension personas from `ext/<product>/personas/` and injects extension rules/skills only when the product is active.

## Uappi v2

See `ext/uappi-v2/README.md` and `docs/guide/specifics-sync.md`.
