# Redução de tokens

Guias para ferramentas que reduzem consumo de tokens em sessões com agentes de IA. Complementam o AgentFlow; não são obrigatórias.

| Ferramenta | Camada | Guia |
|------------|--------|------|
| **RTK** | Entrada — comprime saída de comandos no terminal antes de ir ao contexto do LLM | [install-rtk.md](./install-rtk.md) |
| **Caveman** | Saída — compacta respostas do agente; no AgentFlow, ativo no boot (`/caveman full`) | [install-caveman.md](./install-caveman.md) |

```text
Terminal → RTK → menos tokens no contexto
Agente   → Caveman → menos tokens na resposta
```

Ordem sugerida na primeira configuração: RTK na máquina → reiniciar o agente → Caveman → AgentFlow ([install-start.md](../install-start.md)).
