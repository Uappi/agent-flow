# Extensões de produto — índice de guias

O núcleo do AgentFlow (`personas/`, `skills/`, `rules/` na raiz de `.agents/`) permanece **genérico**. Fluxos ligados a um produto (Wapstore, Uappi, etc.) ficam em `ext/<product-id>/` e só entram em cena quando o repositório de trabalho corresponde aos sinais de detecção.

## Guias

| Guia | Objetivo |
| :--- | :--- |
| [create-extension.md](create-extension.md) | Criar e registrar uma nova extensão em `ext/` |
| [uappi-v2-specifics-compare.md](uappi-v2-specifics-compare.md) | Usar a extensão **uappi-v2** para comparar `especifico/` com o core |

## Referência rápida

- Pasta das extensões: `ext/README.md`
- Detecção no boot: `skills/product-profile.md`
- Roteamento do Maestro: `ext/<product-id>/ROUTING.md`
