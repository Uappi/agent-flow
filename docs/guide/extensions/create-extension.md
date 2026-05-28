# Guia: criar uma extensão de produto

Como adicionar um fluxo específico de produto sem poluir o orquestrador genérico. Tudo que for **do produto** fica em `ext/<product-id>/`; o core só registra a detecção e, quando necessário, o gatilho mínimo de pré-dispatch.

- Índice: [README.md](README.md)
- Layout e extensões existentes: `ext/README.md`

## Quando usar

- Novo produto ou plataforma com personas, regras ou prompts próprios.
- Fluxos que dependem de sinais no repositório de trabalho (pastas, arquivos, remote Git).
- Qualquer coisa que **não** deva valer para todos os projetos AgentFlow.

## Princípios

1. **Core genérico** — Maestro, dispatch e boot não duplicam o playbook da extensão; leem `ROUTING.md`.
2. **Ativação por sinais** — `skills/product-profile.md` detecta o repo e grava `activeProducts` na sessão.
3. **Guias de uso** em `docs/guide/extensions/`; detalhes técnicos no `README.md` da extensão.

## Estrutura da pasta

```text
ext/<product-id>/
├── README.md           # visão geral e detecção
├── ROUTING.md          # Maestro lê quando o produto está ativo
├── personas/
├── skills/
├── rules/
├── prompts/
└── templates/
```

## Passo a passo

### 1. Criar `ext/<product-id>/`

Escolha um id estável (ex.: `uappi-v2`, `meu-saas`). Inclua pelo menos `README.md` e `ROUTING.md`.

### 2. Definir sinais de detecção

No `README.md`, documente quando a extensão deve ativar (ex.: pasta `especifico/` + `.wapstore/build` no cliente).

Registre a mesma lógica em `skills/product-profile.md`:

- Avalie o repositório de trabalho (não `.agents/`).
- Defina `repoKind` ou campos equivalentes no bloco `## Product Context` da sessão.
- Adicione o id em `activeProducts` quando os sinais baterem.

### 3. Escrever `ROUTING.md`

Este arquivo é a fonte de verdade para o Maestro:

| Seção | Conteúdo |
| :--- | :--- |
| Prompt → persona | Primeira linha do prompt ou intenção equivalente |
| Gates | O que bloqueia dispatch (tipo de repo, campos obrigatórios) |
| Apply / pós-análise | Se houver segunda fase (ex.: Coder após confirmação) |
| Caminhos | Personas e skills sob `ext/<product-id>/`, nunca na raiz do core |

**Preferência:** manter rotas só em `ROUTING.md`, sem copiar para `personas/maestro.md`.

### 4. Personas, skills, regras, templates

- **Personas** em `ext/<product-id>/personas/`.
- **Skills** com frontmatter `product: <product-id>` e, se aplicável, `scope: <categoria>`.
- **Regras** em `ext/<product-id>/rules/<categoria>/` com o mesmo `product` e `scope`.
- **Prompts** em `ext/<product-id>/prompts/` — texto que o usuário cola no chat.
- **Templates** de saída em `ext/<product-id>/templates/`.

O `skills/dispatch.md` injeta regras/skills da extensão quando o produto está em `activeProducts` ou nomeado no brief.

### 5. Pré-dispatch (se o fluxo exigir)

Em `skills/pre-dispatch-check.md`, registre apenas o **mínimo** no core:

- Gatilho (primeira linha do prompt).
- Campos obrigatórios genéricos ou remissão a `ext/<product-id>/ROUTING.md`.

Detalhes (URLs GitLab, nomes de projeto, etc.) ficam na extensão.

### 6. Boot e greeting (opcional)

Se o fluxo deve aparecer no menu do boot, adicione uma linha em `skills/boot.md` **apenas** com o gatilho e o caminho do prompt — sem playbook longo.

Alternativa futura: ler triggers de cada `ext/*/README.md`.

### 7. Guia de uso

Crie `docs/guide/extensions/<nome-em-ingles>.md` (ex.: `uappi-v2-specifics-compare.md`), no mesmo padrão dos demais guias em `docs/guide/`.

Atualize `docs/guide/extensions/README.md` com o link.

### 8. Listar em `ext/README.md`

Inclua o produto na tabela “Available extensions”.

## Frontmatter de exemplo

```yaml
---
shortDescription: ...
usedBy: [minha-persona]
product: meu-produto
scope: minha-categoria
version: 0.1.0
lastUpdated: 2026-05-27
---
```

## Checklist

- [ ] `ext/<product-id>/README.md` e `ROUTING.md`
- [ ] Sinais registrados em `skills/product-profile.md`
- [ ] Persona/skill/regra com `product` no frontmatter
- [ ] Prompt pronto em `ext/<product-id>/prompts/`
- [ ] Guia em `docs/guide/extensions/`
- [ ] Nenhum playbook duplicado no Maestro além do bloco genérico `ext/`

## Exemplo de referência

Extensão completa: `ext/uappi-v2/` — comparador de `especifico/` vs core no GitLab. Guia de uso: [uappi-v2-specifics-compare.md](uappi-v2-specifics-compare.md).
