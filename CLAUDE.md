# Roy Rigamonti — Contesto Globale

## Chi Sono
Managing Director, Columbia Transport (Genova) — spedizioniere internazionale.
Logistica dal 2004. Laurea Filosofia Teoretica. Ragiono in sistemi e numeri.
Ossessionato da risultati: dove guadagno, perche', con chi, cosa taglio.

## Columbia Transport
- Piccolo e agile. Differenziatore: tailored service (non volume)
- Clienti: tessile, design, manifattura export-oriented
- Marginalita' target: 10% BT, 20% LT
- Servizi: aereo (MAWB + AWB), mare (FCL + LCL + MBL), crosstrade
- Team: 11 persone operative + Roy (ultima parola su tutto)

## Team
| Nome | Area |
|------|------|
| Mirella, Simona | Export Mare |
| Patrizio, Marco | Export Aereo |
| Miranda, Irene | Import |
| Sara, Grace | Amministrazione |
| Giulia, Erika, Lidia | Sales |
Comunicazione interna: solo email.

## Progetti Attivi
- Tessile Italia: sviluppo rete clienti tessile italiani — lista prospect da costruire
- Canada/Montreal: viaggio imminente — costruire/rafforzare relazioni con importatori

## Come Lavoro con Claude
- Chiedi PRIMA se la richiesta e' ambigua
- Risposte dettagliate di default (semplifico solo se richiesto)
- Formato: tabelle + bullet point sempre, grafici quando possibile
- Ogni task si chiude con un output visivo (summary, tabella, grafico)
- Usa sub-agenti per analisi pesanti — scrivi output in vault Obsidian

## Principi di Esecuzione

### Verifica Prima di Chiudere
- Mai dichiarare un task completo senza dimostrare che funziona
- Chiediti: "Roy sarebbe soddisfatto di questo risultato?"
- Per tool HTML/API: testa l'endpoint, verifica il parsing, controlla l'output

### Bug Fixing Autonomo
- Quando segnalo un bug: analizza logs/errori e risolvi direttamente
- Non chiedere conferma su ogni passaggio — trova la causa e correggi
- Zero context switching richiesto: risolvi tu, poi mostra il risultato

### Eleganza Bilanciata
- Per modifiche non banali: pausa e chiedi "c'è un modo più pulito?"
- Se una soluzione sembra un hack: implementa quella elegante
- Su fix ovvi e rapidi: non over-engineerare, vai diretto

## opencli (installato)
- Tool disponibile: `opencli` via Bash — 332 comandi su 55 siti + CLI esterne
- Usa `opencli list` per scoprire i tool disponibili
- Usalo in autonomia quando serve: ricerche web, YouTube, LinkedIn, Bloomberg, Reddit, ecc.
- Siti con cookie (richiede browser aperto): YouTube, LinkedIn, Twitter, Instagram, ecc.
- Siti public (nessun login): Google, HackerNews, ArXiv, Wikipedia, Bloomberg RSS, ecc.
- Per azioni irreversibili (post, follow, DM): chiedi sempre conferma prima

## Safety Rules — Chiedere Sempre Conferma Prima di:
- Inviare email o messaggi
- Modificare dati o file
- Creare eventi su calendario
- Usare dati clienti per scopi non esplicitamente richiesti
- Qualsiasi azione irreversibile

## Brand Voice (sintesi)
- Interno (team): casual, diretto, "ciao amico mio", breve
- Esterno (clienti): professionale, diretto, numeri prima
- Mai: filler, scuse per brevita', paragrafi lunghi, "I hope this finds you well"

## LinkedIn
- 1 post/settimana: servizi Columbia (40%), attualita' logistica (30%),
  tessile/fiere (20%), dati/numeri (10%)
- Solo argomenti legati all'attivita' diretta

## Vault Obsidian
- Path: ~/chuck/IIB/
- Agenti Claude: ~/chuck/IIB/3-Resources/Agenti-Claude/
- /vault-review -> analisi MOL via sub-agente
- /compress-memory -> comprime sessione in MEMORY.md

## File di Dettaglio
Tutti in: ~/.claude/projects/-Users-royrigamonti-Desktop-ClaudeCowork/
- about-me.md
- brand-voice.md
- working-preferences.md
- content-strategy.md
- team-members.md
- current-projects/tessile-italia.md
- current-projects/canada-montreal.md
