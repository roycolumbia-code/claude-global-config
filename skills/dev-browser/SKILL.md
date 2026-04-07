---
name: dev-browser
description: "Riferimento a dev-browser: tool che dà a Claude controllo reale del browser via Playwright in sandbox QuickJS. Usa quando vuoi che un agente Claude esegua automazione browser completa (login, navigazione, scraping, form) senza rischi sul sistema host."
---

# dev-browser — Playwright in Sandbox per Agenti Claude

Fonte: @NainsiDwiv50980 su X (2 apr 2026)

## Cos'è

Invece di screenshot + click approssimati, `dev-browser` permette agli agenti Claude di scrivere **vero codice Playwright** che gira in una sandbox QuickJS.

**Differenza chiave:**
- Prima: Claude vede uno screenshot e indovina le coordinate
- Con dev-browser: Claude scrive `goto()`, `click()`, `fill()`, `evaluate()`, `scrape()`, `screenshot()` — come farebbe uno sviluppatore

## Caratteristiche

| Feature | Dettaglio |
|---------|-----------|
| Sandbox | QuickJS — nessun accesso al filesystem host |
| API | Playwright completa |
| Tab persistenti | Login una volta, riuso il contesto |
| Multi-script | Workflow concatenati |
| Connessione | Può collegarsi a Chrome esistente |
| Sicurezza | Potere Playwright + isolamento sandbox |

## Benchmark vs alternative

| Tool | Tempo | Costo | Turni | Successo |
|------|-------|-------|-------|---------|
| **dev-browser** | 3m 53s | $0.88 | 29 | 100% |
| Playwright MCP | più lento | più caro | più turni | - |
| Chrome extensions | - | - | - | - |

## Quando usarlo

- Agent che deve fare login + navigare + estrarre dati
- QA automatizzato di siti web
- Scraping senza overhead MCP
- Workflow multi-step su web app (es. compilare form, estrarre report)
- Claude che opera dashboard reali

## Installazione

```bash
npm install dev-browser
```
*(Richiede conferma prima di installare)*

Poi dire a Claude: **"usa dev-browser per..."**

## Use case esempio

> "Apri X, scorri il feed, estrai i tweet con >1000 like, restituisci JSON"

Claude scrive il codice Playwright, la sandbox lo esegue, restituisce il JSON. Tutto in un run.

## Vs computer-use attuale

Roy ha già `mcp__computer-use__*` installato. `dev-browser` è complementare:
- **computer-use**: per app desktop native (Finder, Mail, Excel)  
- **dev-browser**: per web app — più veloce, più preciso, meno costoso per task browser-only
