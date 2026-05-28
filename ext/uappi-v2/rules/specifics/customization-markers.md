---
shortDescription: Identify and preserve ESPECÍFICO comment markers in client overrides.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-27
---

## Statement

Customizações são identificadas por comentários no código:

- `ESPECÍFICO`
- `ESPECÍFICO TEMPORÁRIO`
- `[ESPECÍFICO PERMANENTE]` / `ESPECÍFICO PERMANENTE`
- `[ESPECÍFICO TEMPORÁRIO]` / `ESPECÍFICO TEMPORÁRIO`

Trechos com esses marcadores são customização legítima — prioridade máxima na preservação.

Não: sobrescrever ou remover sem análise.

Ausência de marcador **não** prova que não é customização — usar também:

- arquivos em `especifico/`;
- arquivos só no cliente;
- alterações significativas vs core.

Em dúvida: assumir possível customização; sinalizar; evitar sobrescrita automática.

## Rationale

Espelha `regras/identificacao-de-customizacao.mdc`.
