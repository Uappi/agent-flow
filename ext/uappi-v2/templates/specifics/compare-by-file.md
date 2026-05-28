# Análise por arquivo — specifics sync

Data da análise: {YYYY-MM-DD}
Projeto:
Versão instalada:
Versão alvo:
Quantidade de arquivos em especifico/:

---

## Arquivo

Caminho:

### Descrição do específico

O que o override do cliente faz.

### Comportamento do core

Comportamento no core na tag informada.

### Diferença

Resumo objetivo da divergência.

### Classificação MCP

- ADDITION | IDENTICAL | MODIFIED

### Sub-classificação

- Customização própria | Correção do core | Implementação customizada | Código legado | Artefato gerado | NEEDS CLASSIFICATION

Marcadores: [ESPECÍFICO PERMANENTE] | [ESPECÍFICO TEMPORÁRIO] | nenhum

### Impacto

- Baixo | Médio | Alto

### Justificativa

Por que esta classificação.

### Sugestão de alteração

Patch ou merge sugerido (preservar blocos específicos). Omitir se IDENTICAL ou ADDITION sem ação.

```diff
(sugestão opcional)
```

---

(repetir seção **Arquivo** para cada arquivo analisado)

## Resumo

| Métrica | Contagem |
|---------|----------|
| Total | |
| IDENTICAL | |
| ADDITION | |
| MODIFIED | |

## Ações recomendadas

- IDENTICAL: candidatos a remoção de `especifico/` se override não for necessário
- MODIFIED: revisar merge sugerido antes de aplicar
