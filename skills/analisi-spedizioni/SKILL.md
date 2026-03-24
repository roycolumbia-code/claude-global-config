---
name: analisi-spedizioni
description: Analizza il file sped.xlsx con dati spedizioni 2025 Columbia Transport. Usare quando Roy chiede conteggi, margini, breakdown per cliente/corrispondente/rotta/servizio. Trigger: "quante spedizioni", "MOL su", "quanto abbiamo fatto con X", "analisi per Y", "percentuale di Z".
---

# Skill: analisi-spedizioni

## File Sorgente
```
Path: /Users/royrigamonti/chuck/genova/sped.xlsx
Sheet: Sheet1
Righe: 4.163 (+ 1 header) — anno 2025
```

## Mappa Colonne (indice 0-based)

| Indice | Nome campo | Valori tipici |
|--------|-----------|---------------|
| 1 | Spedizione (ID) | "01-2025-100001" |
| 3 | Tipo Trasporto | Aereo (2.975), Marittimo (1.188) |
| 4 | Settore Traffico | Export (3.722), Import (441) |
| 5 | Data Sped. | datetime |
| 7 | Servizio | Export Aereo, Crosstrade Aereo, Export Mare, Import Mare, Crosstrade Mare, Import Aereo |
| 9 | Committente | cliente (es. Thibaut Inc., La Marzocco, Richloom) |
| 10 | Tipo Pratica | HAWB, AWB, MAWB, HBL Isolata, House Bill of Lading, Completo |
| 18 | Ricavi (EUR) | float |
| 19 | Costi (EUR) | float |
| 20 | Saldo Totale (EUR) | float — MOL reale per spedizione |
| 21 | Saldo % | float — MOL % reale |
| 38 | Corrispondente | Mid America (546), John S James (423), Kilroy (137), Boc International (121), Pioneer (115), Expeditors (74) |
| 41 | Mittente | shipper name |
| 45 | Destinatario | consignee name |
| 49 | Zona Partenza | Milano Provincia, Firenze, Bologna, Lecco, Brescia, Bergamo, Venezia, Monza Brianza |
| 51 | Zona Arrivo | Stati Uniti America (473), Milano Provincia, Monza Brianza |
| 52 | Commerciale | sales person (Giulia, Erika, Lidia — spesso vuoto nel file) |
| 62 | Riferimento Mittente | numero pratica mittente (es. "MXP", numero ordine) |

## Dizionario Sinonimi — Linguaggio Naturale → Filtro

| Roy dice | Colonna | Filtro |
|----------|---------|--------|
| "Kilroy" | [38] Corrispondente | contiene "Kilroy" |
| "John S James" / "JSJ" | [38] Corrispondente | contiene "James" |
| "Mid America" | [38] Corrispondente | contiene "Mid America" |
| "Thibaut" | [9] Committente o [45] Destinatario | contiene "Thibaut" |
| "La Marzocco" | [9] Committente | contiene "Marzocco" |
| "MXP" | [62] Riferimento Mittente | contiene "MXP" |
| "aereo" | [3] Tipo Trasporto | == "Aereo" |
| "mare" / "marittimo" | [3] Tipo Trasporto | == "Marittimo" |
| "export" | [4] Settore Traffico | == "Export" |
| "import" | [4] Settore Traffico | == "Import" |
| "crosstrade" | [7] Servizio | contiene "Crosstrade" |
| "FCL" | [10] Tipo Pratica | == "Completo" |
| "LCL" / "groupage" | [10] Tipo Pratica | in ["HBL Isolata", "House Bill of Lading"] |
| "MAWB" | [10] Tipo Pratica | == "MAWB" |
| "AWB diretto" | [10] Tipo Pratica | == "AWB" |
| "HAWB" | [10] Tipo Pratica | == "HAWB" |

## Procedura

1. **Identifica** cosa vuole Roy:
   - **Conteggio**: "quante spedizioni con X"
   - **MOL/Margine**: "quanto guadagnamo su X", "MOL per servizio"
   - **Breakdown %**: "percentuale X vs Y", "mix aereo/mare"
   - **Ranking**: "top 10 clienti per fatturato/margine"
   - **Confronto**: "X vs Y in termini di volumi/margine"
   - **Drill-down**: "spedizioni di Thibaut via JSJ"

2. **Scrivi ed esegui** Python con openpyxl (o pandas se disponibile):
   - Usa `Bash` tool con python3
   - Applica i filtri dalla mappa sopra
   - Calcola aggregazioni richieste

3. **Presenta** in tabella ordinata — sempre includere:
   - N. spedizioni
   - Ricavi totali (EUR)
   - Costi totali (EUR)
   - MOL totale (EUR)
   - MOL % medio

4. **Chiudi** con 1-2 insight strategici basati sui numeri.

## Template Python Base

```python
import openpyxl
wb = openpyxl.load_workbook('/Users/royrigamonti/chuck/genova/sped.xlsx')
ws = wb['Sheet1']
rows = list(ws.iter_rows(min_row=2, values_only=True))

# Esempio: filtra per corrispondente Kilroy
filtered = [r for r in rows if r[38] and 'Kilroy' in str(r[38])]

# Aggregazione MOL
n = len(filtered)
ricavi = sum(r[18] or 0 for r in filtered)
costi  = sum(r[19] or 0 for r in filtered)
mol    = sum(r[20] or 0 for r in filtered)
mol_pct = (mol / ricavi * 100) if ricavi else 0

print(f"Spedizioni: {n}")
print(f"Ricavi:  EUR {ricavi:,.2f}")
print(f"Costi:   EUR {costi:,.2f}")
print(f"MOL:     EUR {mol:,.2f} ({mol_pct:.1f}%)")
```

## Output Formato Standard

```
ANALISI SPEDIZIONI — [filtro applicato]
=========================================

| Segmento | N. Sped | Ricavi (EUR) | Costi (EUR) | MOL (EUR) | MOL % |
|----------|---------|-------------|------------|-----------|-------|
| ...      | ...     | ...         | ...        | ...       | ...   |

TOTALE: X spedizioni | EUR yyy ricavi | MOL EUR zzz (W%)

INSIGHT:
- ...
- ...
```

## Quality Checklist
- [ ] Filtro applicato correttamente (verificare con conteggio plausibile)
- [ ] Numeri in EUR con separatore migliaia punto, decimali virgola
- [ ] MOL % calcolato su ricavi (non su costi)
- [ ] Insight strategici inclusi (non solo numeri)
- [ ] Se risultato anomalo (MOL negativo, 0 spedizioni): verificare filtro prima di mostrare
