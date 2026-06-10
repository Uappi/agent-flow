---
shortDescription: Scannability rules for description and body sections — paragraphs, line breaks, bold, headings, lists, and tables.
scope: api-doc
product: uappi-v3
version: 0.1.0
lastUpdated: 2026-06-02
---

## Statement

These rules apply primarily to **description and body prose** — the sections that explain what an endpoint does, its business rules, and its behaviors.
They do NOT apply with the same strictness to tables, code blocks, or headings, which have their own structural constraints.

### Paragraph structure

Each paragraph MUST contain exactly one idea. When a second idea appears, start a new paragraph.

Paragraphs in description sections SHOULD be 2–3 lines maximum in the rendered view (accounting for the narrow content div). Writers MUST NOT merge independent ideas into a single long paragraph to avoid visible breaks.

Lead with the conclusion or key fact first, then provide supporting detail. Supporting context that does not change the core statement SHOULD be placed at the end or omitted.

### Line breaks

Lines MUST NOT break mid-sentence. Every line must end at a natural sentence boundary (period, colon introducing a list, or equivalent punctuation).

Lines MUST NOT exceed 155 characters. If a sentence would exceed this limit, restructure it — split into two sentences or rephrase — rather than breaking it in the middle.

Always use a **double line break** (`\n\n`) between paragraphs. A single `\n` is collapsed by the Markdown-to-HTML converter and produces no visible spacing.

### Bold

Bold (`**text**`) MUST be reserved for key phrases that convey meaning in isolation — a reader skimming only bolded words should absorb the core message.

Do NOT bold full sentences, generic verbs, or decorative emphasis. Bold is not a substitute for a clear topic sentence.

### Headings

Use `###` subheadings to divide a section when it covers two or more distinct topics. Each heading MUST indicate where the reader is going, not just name the current section.

MUST NOT use headings to dress up a single short paragraph. A heading is only justified when readers may want to navigate directly to that subsection.

### Lists

Use bullet lists (`-`) for three or more independent items of the same category. Use numbered lists only for ordered sequences (steps, priority order, decision flow).

MUST NOT use lists for two items that would read more naturally as a sentence with "and". MUST NOT write list items that are full paragraphs — if an item requires multiple sentences, promote it to a subheading with body text.

### Spacing and sentence length

Individual sentences SHOULD span at most two rendered lines inside the narrow content div. Sentences that run longer MUST be broken into two sentences.

When a section genuinely requires longer content (error maps, multi-branch business rules), scannability still applies: structure with headings and lists rather than compressing into dense prose. The rule is to organize clearly, not to truncate.

### Tables

Use tables for comparative or associative data where readers need to locate and compare values quickly (field names, types, defaults, error codes).

MUST NOT use prose paragraphs to convey information that naturally fits a table. MUST NOT use tables for content that flows logically as a list (three or fewer single-attribute items).

## Rationale

The documentation is rendered in a narrow content div where long, undivided prose becomes a wall of text. Scannability techniques let readers locate the information they need without reading everything — they skim headings, absorb bolded phrases, and stop at the relevant paragraph. Without these constraints, description sections accumulate dense blocks that slow every reader regardless of their goal.
