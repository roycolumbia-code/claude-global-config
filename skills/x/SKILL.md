---
name: x
description: "Morning intelligence feed. Legge Gmail (roy.rigamonti@gmail.com) per email su Claude, skill, hook, agent, setup. Valuta importanza in autonomia e installa media/alta priorità senza chiedere. Chiude con DM Slack a Roy con recap completo. Usa quando invocato con /x o dal LaunchAgent mattutino delle 08:15."
---

# Skill: /x — Morning Intelligence Feed

## Scopo

Ogni mattina (o su invocazione manuale `/x`) esegue in autonomia:

1. Legge Gmail per email rilevanti
2. Valuta ogni email (LOW / MEDIUM / HIGH)
3. Installa automaticamente i contenuti MEDIUM e HIGH
4. Invia DM Slack a Roy con il recap

---

## Step 1 — Leggi le email

Usa il plugin Gmail MCP. Se non autenticato, esegui prima l'autenticazione:
- Tool: `mcp__plugin_sales_gmail__authenticate`

Cerca email con questi criteri:
- **Mittente**: from:roy.rigamonti@gmail.com
- **Data**: ultime 24 ore (o dall'ultimo run se disponibile)
- **Keywords** in oggetto o corpo: `claude`, `skill`, `hook`, `agent`, `mcp`, `plugin`, `setup`, `config`, `automation`, `prompt`, `tool`

Per ogni email trovata estrai:
- Oggetto
- Corpo (testo completo)
- Eventuali allegati .md / .json / codice inline

---

## Step 2 — Valuta l'importanza

Per ogni email assegna un punteggio:

### HIGH — Installa subito
- Contiene codice completo di una skill (frontmatter YAML + istruzioni)
- Contiene hook config pronto per settings.json
- Contiene agent prompt già strutturato
- Contiene un blocco JSON di configurazione MCP

### MEDIUM — Installa se chiaro
- Concept di skill con abbastanza dettagli per implementare
- Idea di hook con trigger e azione definiti
- Link a strumento/plugin con istruzioni d'uso
- Template o snippet riutilizzabile

### LOW — Solo nota nel recap
- Idee vaghe senza implementazione
- Link senza contesto
- Promemoria generici
- Cose già installate

---

## Step 3 — Installa (MEDIUM e HIGH, senza chiedere)

### 3a — Skill nuova o aggiornata

1. Determina il nome slug (lowercase, no spazi, es: `my-skill`)
2. Crea directory: `~/.claude/skills/[slug]/`
3. Scrivi `~/.claude/skills/[slug]/SKILL.md` con:
   ```
   ---
   name: "[Nome leggibile]"
   description: "[Descrizione + trigger quando usarla]"
   ---
   [Contenuto estratto/sintetizzato dall'email]
   ```
4. Se la skill include script, crea `~/.claude/skills/[slug]/scripts/` e popola

### 3b — Hook (modifica settings.json)

File target: `~/.claude/settings.json`

1. Leggi il file corrente
2. Aggiungi/aggiorna la chiave `hooks` con la nuova configurazione
3. Formato hook:
   ```json
   {
     "hooks": {
       "[EventName]": [
         {
           "matcher": "[pattern]",
           "hooks": [{"type": "command", "command": "[cmd]"}]
         }
       ]
     }
   }
   ```
4. Scrivi il file aggiornato

### 3c — Agent prompt

1. Crea file `~/.claude/agents/[slug].md` (crea la dir se non esiste)
2. Scrivi il prompt strutturato dell'agente

### 3d — MCP server (unica eccezione: chiedi conferma)

Se l'email suggerisce di installare un nuovo MCP server via npm/pip:
- **NON installare automaticamente**
- Includi nel recap Slack come "Richiede conferma manuale"
- Descrivi il comando da eseguire

---

## Step 4 — Invia DM Slack a Roy

Usa `mcp__plugin_slack_slack__slack_search_users` per trovare Roy se il suo ID non è noto.
Poi usa `mcp__plugin_slack_slack__slack_send_message`.

**Canale/destinatario**: cerca user con nome "Roy" o "roy.rigamonti" nel workspace.

**Formato del messaggio DM:**

```
🔍 *Morning Intelligence Feed* — [DATA]

*Email analizzate:* [N]
*Installati:* [N] • *Saltati (LOW):* [N]

---
*✅ INSTALLATI:*
• [nome-skill] — Skill creata in ~/.claude/skills/[slug]/
• [nome-hook] — Hook aggiunto a settings.json
• ...

*⏭️ SALTATI (LOW):*
• "[oggetto email]" — motivo breve
• ...

*⚠️ RICHIEDE CONFERMA:*
• MCP: [nome] — `[comando da eseguire]`
```

Se non ci sono email rilevanti:
```
🔍 *Morning Intelligence Feed* — [DATA]
Nessuna email rilevante nelle ultime 24h.
```

---

## Note operative

- **Idempotente**: prima di installare, controlla se la skill/hook esiste già. Se esiste e il contenuto è uguale, skip. Se è un aggiornamento, sovrascrivi e segnala nel recap.
- **Nessuna interazione**: non chiedere conferma a meno di MCP npm install
- **Log errori nel recap**: se un'installazione fallisce, segnalalo nel DM Slack invece di bloccarsi
- **Timezone**: Roy è in Europe/Rome
