---
name: cerca-mail
description: Cerca email su Outlook (roy@columbiatransport.it) e Gmail (roy.rigamonti@gmail.com) usando linguaggio naturale. Usare quando Roy dice "trova mail su X", "cerca mail da Y", "cerca dove ho scritto Z", "ultime mail su [topic]".
---

# Skill: cerca-mail

## Scopo
Trovare email rilevanti su entrambi gli account di Roy senza che lui debba ricordare
su quale account si trova l'informazione.

## Account disponibili
- **Outlook**: roy@columbiatransport.it (MS365 MCP) — email operative, team, clienti, spedizioni
- **Gmail**: roy.rigamonti@gmail.com (Gmail MCP) — comunicazioni personali e backup

## Procedura

1. **Analizza la richiesta** — estrai:
   - Keyword / topic (es. "quotazione", "CMA CGM", "booking 26/300166")
   - Mittente specifico se menzionato (es. "da mirella", "da john")
   - Periodo se menzionato (es. "ultima settimana", "febbraio", "ieri")
   - Tipo di mail (inviata, ricevuta, entrambe)

2. **Cerca su Outlook** via `mcp__claude_ai_ms365__outlook_email_search`
   - Usa `query` per keyword
   - Usa `sender` se mittente specificato
   - Usa `afterDateTime` / `beforeDateTime` se periodo specificato
   - Default: limit 10

3. **Cerca su Gmail** via `mcp__claude_ai_Gmail__gmail_search_messages`
   - Stessa query in parallelo
   - Solo se la richiesta è ambigua su quale account (altrimenti solo Outlook per argomenti business)

4. **Presenta risultati** in tabella unificata:

```
RISULTATI RICERCA — "[keyword]"
================================

| # | Data | Da | A | Subject | Account | Preview |
|---|------|----|---|---------|---------|---------|
| 1 | ... | ... | ... | ... | Outlook/Gmail | primi 80 char |

Trovate: X su Outlook, Y su Gmail
```

5. **Chiedi**: "Vuoi che apra una mail specifica per il contenuto completo?"
   - Se sì: usa `read_resource` con l'URI della mail selezionata

## Regole di Routing

| Tipo ricerca | Dove cercare |
|--------------|-------------|
| Spedizioni, clienti, team, fornitori | Solo Outlook |
| Personale, generico, non-business | Gmail + Outlook |
| Mittente con @columbiatransport.it | Solo Outlook |
| Non specificato | Outlook prima, Gmail se pochi risultati |

## Esempi di Richiesta → Parametri

| Roy dice | query | sender | afterDateTime |
|----------|-------|--------|--------------|
| "trova mail su spedizione 26/300166" | "26/300166" | — | — |
| "mail da mirella su FCL Canada" | "FCL Canada" | "mirella" | — |
| "cerca dove ho parlato di montreal la settimana scorsa" | "montreal" | — | "last week" |
| "ultime 5 mail non lette" | — | — | — (usa isRead filter) |
| "mail con quotazione da CMA CGM" | "quotazione CMA CGM" | — | — |

## Quality Checklist
- [ ] Cercato su Outlook (obbligatorio per argomenti business)
- [ ] Risultati in tabella con data, mittente, subject, preview
- [ ] Offerto di aprire mail specifica per contenuto completo
- [ ] Mai inviare, rispondere o modificare email senza conferma esplicita Roy
