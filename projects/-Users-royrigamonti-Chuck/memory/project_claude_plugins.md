---
name: Claude Code — plugin e tool di terze parti installati
description: Plugin, tool e integrazioni non-default installati in Claude Code, con stato, comandi e note setup
type: project
---

## Plugin installati (oltre quelli ufficiali)

### peon-ping (Warcraft/voice notifications)
- **Repo:** github.com/PeonPing/peon-ping — 4.259 ⭐
- **Stato:** DISINSTALLATO 2026-03-31 — si attivava automaticamente in modo inatteso (voci durante lavoro)
- **Come reinstallare se serve:** `brew install PeonPing/tap/peon-ping && peon-ping-setup`

### handoff (session continuity)
- **Repo:** github.com/willseltzer/claude-handoff — 37 ⭐
- **Installato:** 2026-03-31 via `claude plugin marketplace add willseltzer/claude-handoff` + `claude plugin install handoff`
- **Stato:** attivo (scope: user)
- **Comandi:** `/handoff:create` (full context), `/handoff:quick` (minimo), `/handoff:resume` (riprendi da HANDOFF.md)
- **Usa quando:** cambio sessione, raggiunge limite context, passa da Claude a altro AI agent

### call-me (phone notification)
- **Repo:** github.com/ZeframLou/call-me — 2.546 ⭐
- **Installato:** NO — richiede setup manuale
- **Requisiti:** account Telnyx (~$1/mese numero) + OpenAI API key + ngrok account (gratuito)
- **Cosa fa:** Claude chiama al telefono/smartwatch quando ha bisogno di input mentre Roy è lontano dal Mac
- **Why:** molto utile per task lunghi in autonomia (analisi, parsing, tool dev)

## Stato plugin al 2026-04-08

- **Totale installati:** 67 (65 attivi + 2 con errori)
- **Plugin con errori persistenti** (non aggiornabili, non rimuovere senza conferma Roy):
  - `Notion@claude-plugins-official` — "Plugin Notion not found in marketplace"
  - `brand-toolkit@brand-toolkit` — "Plugin brand-toolkit not found in marketplace"
- **Tutti gli altri (65):** aggiornabili normalmente con `claude plugin update "<id-completo>"`

**Nota sul workaround `env -i`:** serviva in sessioni automatizzate (LaunchAgent) dove l'ambiente era contaminato. In sessioni normali Claude Code, `claude plugin update` funziona direttamente senza workaround.

## /newsclaude skill — stato aggiornato

- File: `/Users/royrigamonti/Chuck/.claude/skills/newsclaude/SKILL.md`
- Aggiornato: 2026-03-31 — aggiunta **Fonte A (Anthropic Ufficiale)** come prima fonte prioritaria
- Fonti attive: A=Anthropic ufficiale (changelog+releases), B=Google, C=HackerNews, D=GitHub API
- Output sempre include sezione `📣 Aggiornamenti Ufficiali Anthropic` in cima
- Output mandato su Slack canale `D0AHK8Z5Q05` (DM Roy)

**Why:** La fonte ufficiale Anthropic era assente — rischio di vedere novità community ma perdere release notes critiche.

## /updates skill (creata 2026-03-31)

- File: `/Users/royrigamonti/Chuck/.claude/skills/updates/SKILL.md`
- Cosa fa: controlla tutti i plugin Claude Code + ruFlo per aggiornamenti, li installa autonomamente
- Schedulato ogni **lunedì ore 08:00** via `it.columbiatransport.claude-monday` LaunchAgent
- LaunchAgent: `/Users/royrigamonti/Library/LaunchAgents/it.columbiatransport.claude-monday.plist`
- Comando: `claude --dangerously-skip-permissions -p "Esegui /updates ..."`
- Log: `/tmp/claude-monday-updates.log`

## ruFlo (claude-flow)

- **Versione attuale: v3.5.75** (confermato 2026-04-08 via `npx @claude-flow/cli@latest --version`)
- Versione precedente: v3.5.51 (2026-04-06)
- Configurato via `~/Chuck/.mcp.json` con `@claude-flow/cli@latest`
- Cache npx si svuota automaticamente; pre-scaricata al prossimo run
- Per trovare la versione in cache: `find ~/.npm/_npx -name "package.json" -path "*/@claude-flow/cli/package.json"`

## Claude Code versioni osservate

- 2.1.89 → 2026-04-06
- 2.1.92 → 2026-04-07
- 2.1.96 → 2026-04-08

## /x skill — Morning Intelligence Feed (creata 2026-04-07)

- File: `~/.claude/skills/x/SKILL.md`
- Cosa fa: legge Gmail per email da `roy.rigamonti@gmail.com` con keyword `claude/skill/hook/agent/mcp/setup/automation`, valuta importanza (LOW/MEDIUM/HIGH), installa MEDIUM+HIGH in autonomia, invia DM Slack con recap
- Gmail account connesso: `roycolumbia@gmail.com` (non Outlook — originariamente richiesto per Outlook ma implementato via Gmail MCP)
- Flusso self-send Roy: manda email da `roy.rigamonti@gmail.com` → `roycolumbia@gmail.com` con idee/skill/hook → `/x` le processa
- **Nota:** al primo run (2026-04-07) nessuna email rilevante trovata — solo 2 forward hotel del 2016
- Schedulato ogni mattina via LaunchAgent (stesso slot di /updates o subito dopo)

## Integrazione Slack

- Connector UUID: `e365ebe0-705c-46e4-a626-603a5f7d5f30`
- User ID Roy: `U0AHS9QV8TE`
- DM channel Roy: `D0AHK8Z5Q05`
- Usato da: /newsclaude (report settimanale), /x (morning feed), notifiche email filtrate
