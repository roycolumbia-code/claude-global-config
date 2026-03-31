---
name: Canada Tools Suite — stato sviluppo
description: Stato attuale di tutti i tool HTML+API nella cartella chuck/Canada per la gestione consolidamenti, packing list, HS codes e container loading
type: project
---

## Cartella base

`/Users/royrigamonti/chuck/Canada/`

## Tool attivi (2026-03-30)

| File | Scopo | API/Porta |
|------|-------|-----------|
| `canadaconsol-generator.html` | Generazione documenti consolidamento Canada (rinominato da consol-generator.html) | API 8766 |
| `consol-generator.html` | Versione precedente — lasciata sul disco, non usare | API 8766 |
| `packing-extractor.html` | Estrazione packing list da PDF/DOCX/EML/MSG | API 8767 |
| `hs-classifier.html` | Classificazione doganale USA (Tab1: descrizione→HTS10; Tab2: codice→descrizione) | API 8767 (packing-api.py) |
| `container-loader.html` | Piano di carico 3D (Three.js) — opzioni 40'Std, 40'HC, 20'Std | HTTP server 8080 |
| `columbia-website-v4c.html` | Sito web Columbia — servito su 8080 | HTTP server 8080 |
| `packing-api.py` | API Python 8767: /parse-docs, /load-wip, /generate-xlsx, /classify-hs, /lookup-hs | porta 8767 |
| `consol-api.py` | API Python 8766: /generate-ll, /generate-cr, /parse-invoice | porta 8766 |

## Template Excel

- `distinta-container-template.xlsx` — Italiano, 16 colonne (2026-03-30: aggiunte "Data Pick up" e "T/T")
- `container-packing-list-template.xlsx` — Inglese, 16 colonne (2026-03-30: aggiunte "Pick Up Day" e "T/T")
- `container-packing-list-template.xlsx` — template originale download

## LaunchAgents (auto-start al boot Mac)

```
~/Library/LaunchAgents/com.columbia.consol-api.plist
  → /opt/anaconda3/bin/python3 consol-api.py  (porta 8766)
  → log: /tmp/consol-api.log

~/Library/LaunchAgents/com.columbia.containerloader.plist
  → /usr/bin/python3 -m http.server 8080  (server statico HTML)
  → log: /tmp/containerloader.log
  → workdir: /Users/royrigamonti/chuck/Canada
```

**Nota critica Anaconda:** consol-api.plist usa `/opt/anaconda3/bin/python3` — se si ripristina su un altro Mac, Anaconda DEVE essere installato sullo stesso path. packing-api.py usa invece path separato (LaunchAgent packing-api da verificare).

## Come riavviare le API

```bash
# consol-api (dopo modifica consol-api.py)
pkill -f consol-api.py && cd /Users/royrigamonti/chuck/Canada && /opt/anaconda3/bin/python3 consol-api.py &

# packing-api (dopo modifica packing-api.py)
pkill -f packing-api.py && cd /Users/royrigamonti/chuck/Canada && /opt/anaconda3/bin/python3 packing-api.py &
```

**Why:** Il LaunchAgent usa il processo già in memoria — `pkill` manuale necessario dopo ogni modifica.

## Funzionalità consol-api (8766)

- **POST /generate-ll** — genera Load List (openpyxl, preserva loghi)
- **POST /generate-cr** — genera Consol Report (fix MergedCell)
- **POST /parse-invoice** — pdfplumber estrae descrizione merce, HS code, invoice_no
- Charges panel: Rate W/M, O/F, ACI, Inland, HBL, Customs, VGM, Stuffing, Note
- Container costs: CMA, Lusped EXW, Transplus, ROE, Extra

## Funzionalità packing-api (8767)

- **POST /parse-docs** — parse PDF/DOCX/EML/MSG, parser italiano (Para/Rossini/Sirtori/Forasassi)
- **POST /load-wip** — carica WIP Excel per aggiunta incrementale documenti
- **POST /generate-xlsx** — genera Excel template compilato
- **POST /classify-hs** — chiama claude CLI subprocess per classificazione HTS10 USA
- **POST /lookup-hs** — reverse lookup codice HTS10 → descrizione EN+IT

## Accesso LAN colleghi

URL: `http://192.168.1.71:8080/` (Mac Mini fisso, sempre acceso)

## Todo aperti

- [ ] Verificare LaunchAgent separato per packing-api.py (esistente?)
- [ ] Testare parse-invoice con più tipi di fattura oltre Cristini
- [ ] Verificare colonne "Data Pick up" e "T/T" funzionino correttamente nel container-loader tool
- [ ] packing-api.py: aggiungere estrazione dimensioni dal testo body dell'EML quando non c'è PDF allegato (richiesta 2026-03-31 — es. mail "New Look New LCL Shipment to Montreal.eml" in ~/Downloads/ritiri_canada/)

## Note bug risolti recenti

- **2026-03-31:** Evoca North PDF — gross weight mancante in tabella estratta → fix pattern tabellare Vitrifrigo/Evoca in `_parse_italian_doc()`
- **2026-03-30:** MIME type EML mismatch → fix in canadaconsol-generator.html (detection per estensione .eml)
- **2026-03-30:** Exception handling parse_pdf + _handle_parse → aggiunta gestione errori per PDF non validi

**Why:** Canada è il mercato di espansione principale 2026 — questi tool sono usati da tutto il team operativo.
**How to apply:** Quando Roy chiede aggiornamenti ai tool Canada, sempre consultare questa lista di files e porte prima di modificare.
