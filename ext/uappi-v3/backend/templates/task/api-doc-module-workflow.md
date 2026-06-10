---
product: uappi-v3/backend
scope: api-doc
version: 0.2.0
lastUpdated: 2026-06-02
---

# Workflow: Documentar Módulo (Visão Geral)

Páginas de visão geral (geralmente com `method: DOC`) introduzem o módulo ou grupo de rotas antes dos endpoints na navegação. Use este checklist junto aos modelos de documentação do projeto.

## 0. Modo lote (várias páginas de visão geral no mesmo pedido)

- Construir a mesma ideia de **inventário** descrito no workflow de endpoint, focado em páginas de contexto/módulo.
- **Tom e densidade** alinhados entre todas as páginas de visão geral do lote (mesmo peso de parágrafos, uso de listas, nível de jargão).
- Se o lote misturar páginas de visão geral + endpoints, trate as de visão geral **primeiro** para fixar a linguagem de domínio.

## 1. Fonte estrutural

- Consulte a pasta de modelos de documentação do projeto para selecionar o modelo de visão geral/DOC.
- Siga as regras globais: um único título de primeiro nível (`#`), hierarquia de títulos até `###` e remover comentários de instrução antes do merge.

## 2. Onde gravar

Consulte o `README.ai.md` ou guia de documentação do projeto para saber o caminho exato onde os arquivos devem ser salvos.

## 3. Registro e Menu

- Garanta que a página de visão geral esteja registrada na posição correta (geralmente em primeiro lugar na família ou grupo) nos arquivos de configuração de menu/navegação.

## 4. Tom e conteúdo

- Priorizar **narrativa** e valor para quem consome a documentação; evitar listas puramente técnicas se puder explicar o fluxo de negócio.
- **Visão geral:** O que é o módulo no contexto da plataforma e qual o objetivo principal.
- **Entidades envolvidas:** Use linguagem de domínio clara; evite nomes de classes internas como substitutos de explicação.
- **Notas e considerações:** Opcional; use para limites, pré-requisitos ou avisos transversais.

## 5. Evidência

- Cruzar com rotas e fluxos reais quando a página afirmar comportamento (controllers, requests, serviços).
- Se algo não for verificável no repositório, marcar como dúvida ou lacuna — não apresentar como fato.

## 6. Antes de considerar pronto

- [ ] Frontmatter e seções corretos para o renderizador de documentação do projeto.
- [ ] Registro em menus/navegação na posição esperada.
- [ ] Sem comentários de instrução do modelo no arquivo final.
- [ ] Nenhuma inferência apresentada como comportamento confirmado.
