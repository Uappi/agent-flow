---
shortDescription: Paths to documentation registration files that must be validated and written before the task is complete.
scope: api-doc
product: uappi-v3
version: 0.2.0
lastUpdated: 2026-06-02
---

## Statement

Validate the publication flow before drafting any page. The following files govern how documentation is registered and served:

| File | Role |
| :--- | :--- |
| `apis/api.uappi.com.br/src/resources/documentation-repositories/menu-map.php` | Top-level menu map |
| `apis/api.uappi.com.br/src/resources/documentation-repositories/files/public-api/public-api.php` | Public API registry |
| `apis/api.uappi.com.br/src/resources/documentation-repositories/files/private-api/private-api.php` | Private API registry |
| `apis/api.uappi.com.br/src/app/Console/Commands/IndexDocumentationCommand.php` | Indexation command |
| `apis/api.uappi.com.br/src/app/Services/Documentation/GetDocumentationProcess.php` | Serving process |

Inspect these files before writing. Identify where the new page must be registered and in which registry file. Do not assume the correct placement from similar features alone.

Writing the registry entry is **not optional**. The appropriate `DocumentationDMC` / `DocumentationItemDMC` entry in the target registry file MUST be written or updated as part of the deliverable. Documentation that is written but not registered is **incomplete**, regardless of how complete the Markdown files are.

### Registry entry structure

Each registry file returns an array of `DocumentationDMC` families. Each family contains one or more `DocumentationItemDMC` items. Each item holds an array of doc-page keys that map directly to folder paths under `documentation-files/`.

Excerpt (from `review.php` — items omitted for brevity):

```php
<?php

use App\Services\Clients\DocumentationDMC;
use App\Services\Clients\DocumentationItemDMC;

return [

  new DocumentationDMC('Avaliações', [
    new DocumentationItemDMC('Avaliações de Produto', '/private-api/user/product/review', [
      'private-api/review/review-doc',
      'private-api/review/product/get-product-review',
      'private-api/review/product/list-product-review',
      'private-api/review/product/status-product-review',
      'private-api/review/product/remove-product-review',
    ]),
    // ... other DocumentationItemDMC items omitted for brevity
  ])

];
```

The key `'private-api/review/product/get-product-review'` maps to `documentation-files/private-api/review/product/get-product-review/pt-BR.md`. Every key in the array must match its actual folder path exactly — a mismatched key silently breaks frontend navigation.

## Rationale

Skipping publication flow registration results in docs that are written but never served. Registration MUST happen as part of the same deliverable as the Markdown files — not as a follow-up step.
