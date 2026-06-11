---
shortDescription: camelCase rules, table formatting, line-length, paragraph spacing, and writing style.
scope: api-doc
product: uappi-v3/backend
version: 0.1.0
lastUpdated: 2026-06-02
---

## Statement

### Field name casing

API field names must always be `camelCase` in examples, tables, and parameter descriptions.

### Table formatting

Use simple dividers (`| --- |`) without alignment markers (`:`). Do not bold field names inside table cells.

### Permissions

Do not use tables for permissions. Describe required scopes (READ/WRITE) directly in prose within the Description section.

### Line length

Maximum 140–155 characters per line for readability in the doc renderer.

### Line breaks

Never break a line mid-sentence without a closing period (`.`). Each line must end at a natural sentence boundary.

### Paragraph spacing

Always use double line breaks (two blank lines) between paragraphs to ensure correct HTML rendering — single breaks are collapsed during conversion.

### Writing style for DOC pages

- Prefer explanatory, flowing text oriented to feature understanding.
- Use domain/business entity names first; avoid class-level inventory as primary content.
- Keep internal implementation terms only when they are necessary for API consumers.
- Avoid excessive jargon and English naming in headings/body when a clear Portuguese term exists.
- Include `Regras Importantes` and `Endpoints Relacionados` only if they improve comprehension; do not force these sections mechanically.
- Keep permission details concise. Prefer a dedicated `## Permissão` section only when access rules are central to understanding the module; otherwise avoid repeating middleware/scope boilerplate.
- Avoid scope-redundant labels in titles (e.g. `Privado`, `Private`, `Pública`) when the page is already nested under `API Privada` or `API Pública` in the menu.
- For very long error codes/tokens inside tables, insert soft break points (`<wbr>`) to avoid layout overflow in the rendered docs.
- In public endpoint pages, prefer behavior-oriented wording over middleware names unless the middleware behavior itself is part of the endpoint contract.

## Rationale

Consistent formatting prevents rendering failures in the documentation system and aligns output with the existing house style.
