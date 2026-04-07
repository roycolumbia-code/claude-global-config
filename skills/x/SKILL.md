---
name: x
description: "Morning intelligence feed. Roy inoltra da iPhone post X / link / contenuti da roy.rigamonti@gmail.com a roy@columbiatransport.it. Legge quelle mail, valuta l'utilità per Claude Code (skill/hook/agent/MCP), installa in autonomia i contenuti validi, marca le mail come lette in Outlook, chiude con DM Slack a Roy. Usa quando invocato con /x o dal LaunchAgent mattutino delle 08:15."
---

# Skill: /x — Morning Intelligence Feed

## Scopo

Roy usa il pattern: legge X → trova qualcosa di interessante su Claude/AI → inoltra da iPhone (roy.rigamonti@gmail.com → roy@columbiatransport.it).

Ogni mattina (o su invocazione manuale `/x`) questa skill:

1. Legge tutte le email inoltrate da roy.rigamonti@gmail.com nelle ultime 24h
2. Valuta ogni email (LOW / MEDIUM / HIGH) in base al contenuto
3. Installa automaticamente i contenuti MEDIUM e HIGH
4. Marca le email come lette in Outlook (roy@columbiatransport.it)
5. Invia DM Slack a Roy con il recap

---

## Step 1 — Leggi le email

Usa il plugin Gmail MCP. Se non autenticato, esegui prima l'autenticazione:
- Tool: `mcp__plugin_sales_gmail__authenticate`

Cerca **tutte** le email inoltrate da Roy senza filtro keyword:
```
from:roy.rigamonti@gmail.com newer_than:1d
```

> Nessun filtro per oggetto o keyword — Roy inoltra qualsiasi contenuto ritenga interessante. La valutazione avviene nel Step 2.

Per ogni email trovata estrai:
- Oggetto
- Corpo (testo completo)
- URL inclusi nel corpo
- Eventuali allegati .md / .json / codice inline
- `messageId` e `threadId` (servono per Outlook nel Step 4)

Se il corpo contiene un URL GitHub o X, usa `WebFetch` o `Bash curl` per recuperare il contenuto della pagina e valutarlo meglio.

---

## Step 2 — Valuta l'importanza

Per ogni email assegna un punteggio basandoti sul **contenuto reale**, non sull'oggetto:

### HIGH — Installa subito
- Contiene codice completo di una skill (frontmatter YAML + istruzioni)
- Contiene hook config pronto per settings.json
- Contiene agent prompt già strutturato
- Contiene un blocco JSON di configurazione MCP

### MEDIUM — Installa se chiaro
- Link a repo GitHub con tool/plugin rilevante per Claude Code (vai a leggere il README)
- Concept di skill con abbastanza dettagli per implementare
- Idea di hook con trigger e azione definiti
- Template o snippet riutilizzabile
- Post X con istruzioni pratiche su Claude/AI tools

### LOW — Solo nota nel recap
- Link a post X non accessibile senza login (status 402/401)
- Idee vaghe senza implementazione
- Contenuti già installati
- Argomenti non correlati a Claude/AI/automazione

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

## Step 4 — Marca le email come lette in Outlook

Le email arrivano nella inbox di roy@columbiatransport.it (Outlook / Microsoft 365).
Usa il plugin MS365 MCP per marcarle come lette.

### Autenticazione
Se non autenticato:
```
mcp__plugin_sales_ms365__authenticate()
```

### Trova e marca le email
Dopo l'autenticazione, cerca i messaggi corrispondenti nella inbox Outlook usando oggetto + data, e marcali come letti.

- Esegui per **tutte** le email analizzate (HIGH, MEDIUM e LOW)
- Errori su singoli messaggi non bloccano il flusso — logga nel recap Slack

---

## Step 5 — Invia DM Slack a Roy

Canale/destinatario: `D0AHK8Z5Q05` (ID diretto Roy, già noto).
Usa `mcp__plugin_slack_slack__slack_send_message`.

**Formato del messaggio DM:**

```
Morning Intelligence Feed — [DATA]

Email analizzate: [N] | Installati: [N] | Saltati LOW: [N] | Richiede conferma: [N]

INSTALLATI:
- [nome-skill] — Skill creata in ~/.claude/skills/[slug]/
- [nome-hook] — Hook aggiunto a settings.json

SALTATI (LOW):
- "[oggetto email]" — motivo breve

RICHIEDE CONFERMA:
- MCP: [nome] — comando: [comando da eseguire]
```

Se non ci sono email:
```
Morning Intelligence Feed — [DATA]
Nessuna email inoltrata nelle ultime 24h.
```

---

## Note operative

- **Nessun filtro keyword nella ricerca** — ogni email da roy.rigamonti@gmail.com viene letta e valutata
- **Fetch URL** — se l'email contiene un link GitHub/Reddit/HN, vai a leggerlo prima di valutare
- **Post X non accessibili** → LOW automaticamente (status 402 senza login)
- **Idempotente**: prima di installare, controlla se la skill/hook esiste già. Se esiste e il contenuto è uguale, skip.
- **Nessuna interazione**: non chiedere conferma a meno di MCP npm/pip install
- **Log errori nel recap**: se un'installazione fallisce, segnalalo nel DM Slack
- **Timezone**: Roy è in Europe/Rome
