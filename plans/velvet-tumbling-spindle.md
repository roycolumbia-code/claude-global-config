# Piano: Mappatura Completa Cruscotto Direzionale Qlik Sense

## Contesto
Roy vuole una mappa completa di tutte le pagine (sheets) del Cruscotto Direzionale su Qlik Sense (BeOne Analytics), così da poter rispondere a domande dirette senza dover navigare manualmente ogni volta. Attualmente la skill `/dati-bi` copre solo la prima sheet "Dashboard". Le altre pagine potrebbero contenere dati aggiuntivi (dettaglio per cliente, per rotta, per periodo, ecc.).

## Obiettivo
Esplorare tutte le sheet disponibili nel app Qlik Sense `142567b7-4344-4e56-8943-7f5710260b65`, documentare struttura e dati disponibili per ogni pagina.

---

## Fasi di Esecuzione

### Fase 1 — Login e accesso dashboard
1. Naviga a login URL Qlik Sense
2. Inserisci credenziali (`cltsara` / `sara2026`)
3. Naviga al Dashboard URL principale

### Fase 2 — Enumerazione sheet
1. Prendi snapshot della pagina per identificare il menu laterale delle sheet
2. Identifica tutte le voci disponibili nel pannello di navigazione a sinistra
3. Documenta i nomi di tutte le sheet

### Fase 3 — Esplorazione sistematica ogni sheet
Per ciascuna sheet:
1. Naviga alla sheet
2. Prendi screenshot (visivo) + snapshot (accessibility tree per dati leggibili)
3. Salva screenshot in `/Users/royrigamonti/chuck/bi-map/[nome-sheet].png`
4. Estrai dall'accessibility tree: tutti i KPI, grafici, filtri, dimensioni disponibili

### Fase 4 — Documentazione
Crea file Markdown `/Users/royrigamonti/chuck/bi-map/MAPPA-BI.md` con:
- Elenco sheet con descrizione
- Per ogni sheet: KPI/metriche disponibili, dimensioni di filtro, tipo di visualizzazioni
- Note su come accedere a ciascun dato via Playwright

---

## File Critici
- Skill esistente: `/Users/royrigamonti/Chuck/.claude/skills/dati-bi/SKILL.md` — da aggiornare dopo mappatura
- Output: `/Users/royrigamonti/chuck/bi-map/MAPPA-BI.md` (nuovo)
- Screenshot per sheet: `/Users/royrigamonti/chuck/bi-map/*.png`

## URL e Credenziali (dalla skill)
- Login: `https://beoneanalytics.novasystems.it:8443/login/login.aspx?...`
- Dashboard base: `https://beoneanalytics.novasystems.it/sense/app/142567b7-4344-4e56-8943-7f5710260b65/`
- App ID: `142567b7-4344-4e56-8943-7f5710260b65`

## Verifica
- MAPPA-BI.md creato e leggibile
- Almeno uno screenshot per ogni sheet trovata
- Skill `/dati-bi` aggiornata con le nuove sheet mappate
