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

## /newsclaude skill — stato aggiornato

- File: `/Users/royrigamonti/Chuck/.claude/skills/newsclaude/SKILL.md`
- Aggiornato: 2026-03-31 — aggiunta **Fonte A (Anthropic Ufficiale)** come prima fonte prioritaria
- Fonti attive: A=Anthropic ufficiale (changelog+releases), B=Google, C=HackerNews, D=GitHub API
- Output sempre include sezione `📣 Aggiornamenti Ufficiali Anthropic` in cima
- Output mandato su Slack canale `D0AHK8Z5Q05` (DM Roy)

**Why:** La fonte ufficiale Anthropic era assente — rischio di vedere novità community ma perdere release notes critiche.
**How to apply:** In `/newsclaude`, sempre leggere changelog GitHub di `anthropics/claude-code` come primo step, prima di cercare community plugins.

## /updates skill (creata 2026-03-31)

- File: `/Users/royrigamonti/Chuck/.claude/skills/updates/SKILL.md`
- Cosa fa: controlla tutti i plugin Claude Code + ruFlo per aggiornamenti, li installa autonomamente
- Schedulato ogni **lunedì ore 08:00** via `it.columbiatransport.claude-monday` LaunchAgent
- LaunchAgent: `/Users/royrigamonti/Library/LaunchAgents/it.columbiatransport.claude-monday.plist`
- Comando: `claude --dangerously-skip-permissions -p "Esegui /updates ..."`
- Log: `/tmp/claude-monday-updates.log`

### Note operative /updates (da 2026-04-06)

**Problema:** `claude plugin list/update` fallisce dentro sessione Claude Code (`--enable-auto-mode` flag).
**Workaround:** usare `env -i PATH="$PATH" HOME="$HOME" claude plugin <cmd>` — bypassa l'env contaminato.

**53 plugin con "not found":** I plugin di `claude-plugins-official` (es. vercel, superpowers, figma, playwright, context7…) restituiscono "Plugin X not found" su update. Non è un errore critico — i plugin funzionano regolarmente, ma il marketplace li ha rinominati o riorganizzati. Non rimuoverli senza conferma Roy.

**16 plugin aggiornabili** da marketplace alternativi (awesome-claude-plugins, thedotmack, superpowers-marketplace, ecc.) — questi si aggiornano normalmente.

## ruFlo (claude-flow)

- Versione attuale: **v3.5.51** (aggiornato 2026-04-06)
- Versione precedente: v3.5.48 (2026-03-31)
- Configurato via `~/Chuck/.mcp.json` con `@latest`
- npx cache: `~/.npm/_npx/85fb20e3e7e3a233/node_modules/@claude-flow/cli/` (path cambia ad ogni update)
- Per trovare la versione in cache: `find ~/.npm/_npx -name "package.json" -path "*/@claude-flow/cli/package.json"`

## /x skill — Morning Intelligence Feed (creata 2026-04-07)

- File: `~/.claude/skills/x/SKILL.md`
- Cosa fa: legge Gmail per email da `roy.rigamonti@gmail.com` con keyword `claude/skill/hook/agent/mcp/setup/automation`, valuta importanza (LOW/MEDIUM/HIGH), installa MEDIUM+HIGH in autonomia, invia DM Slack con recap
- Gmail account connesso: `roycolumbia@gmail.com` (non Outlook — originariamente richiesto per Outlook ma implementato via Gmail MCP)
- Flusso self-send Roy: manda email da `roy.rigamonti@gmail.com` → `roycolumbia@gmail.com` con idee/skill/hook → `/x` le processa
- **Nota:** al primo run (07/04/2026) nessuna email rilevante trovata — solo 2 forward hotel del 2016

## Integrazione Slack

- Connector UUID: `e365ebe0-705c-46e4-a626-603a5f7d5f30`
- User ID Roy: `U0AHS9QV8TE`
- DM channel Roy: `D0AHK8Z5Q05`
- Usato da: /newsclaude (report settimanale), /x (morning feed), notifiche email filtrate
