---
name: Consol Generator — stato sviluppo
description: Stato attuale del tool consol-generator.html e API consol-api.py per la gestione documenti consolidamento Canada
type: project
---

## Architettura

- `chuck/Canada/consol-generator.html` — UI browser, servito da `python3 -m http.server 8080`
- `chuck/Canada/consol-api.py` — API Python su porta 8766, avviata da LaunchAgent
- LaunchAgent: `~/Library/LaunchAgents/com.columbia.consol-api.plist`
- Template Excel: `~/Downloads/canada_3/` (Load List + Consol Report)

## Funzionalità implementate (2026-03-26)

- **Generazione Load List** (POST /generate-ll): openpyxl, preserva loghi e grafica originale
- **Generazione Consol Report** (POST /generate-cr): openpyxl, fix MergedCell
- **Charges panel**: per shipper — Rate W/M, O/F Prepaid/Collect, R* ACI, Inland, HBL, Customs, VGM, Stuffing, Note
- **Container costs**: CMA (default 4310), Lusped EXW EUR, Transplus (default 635), ROE, Extra
- **Colonna Description of Goods**: nel charges panel, pre-compilata dalla distinta (col F)
- **Upload fattura PDF** (POST /parse-invoice): pdfplumber estrae descrizione merce, HS code, invoice_no. Attivato via `<label for=...>` (non button+click, che Safari blocca)

## Fix critici applicati

- `cgi` rimosso da import (eliminato in Python 3.13 → API non si avviava)
- MergedCell Consol Report: sc()/nc() con try/except AttributeError
- File input PDF: usa `<label htmlFor>` invece di button+`.click()` — compatibile tutti i browser
- `no-store` meta tag per evitare cache browser del HTML

## Come riavviare l'API

```bash
pkill -f consol-api.py
cd /Users/royrigamonti/chuck/Canada && /opt/anaconda3/bin/python3 consol-api.py &
```

**Why:** Dopo ogni modifica al file .py il LaunchAgent usa il vecchio processo in memoria — occorre pkill manuale.
**How to apply:** Suggerire sempre pkill+restart dopo modifiche a consol-api.py.

## Todo aperti per prossima sessione

- [ ] Testare parse-invoice con più tipi di fattura (non solo Cristini)
- [ ] Verificare che lo shipper "cristini" venga abbinato correttamente nella distinta prova
- [ ] Eventuali altre implementazioni da Roy domani
