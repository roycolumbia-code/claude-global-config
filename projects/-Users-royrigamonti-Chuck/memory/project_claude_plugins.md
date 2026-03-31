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

**Why:** La fonte ufficiale Anthropic era assente — rischio di vedere novità community ma perdere release notes critiche.
**How to apply:** In `/newsclaude`, sempre leggere changelog GitHub di `anthropics/claude-code` come primo step, prima di cercare community plugins.
