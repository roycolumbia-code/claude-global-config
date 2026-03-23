# Piano: Aggiunta Dazi Doganali al Cash Flow Budget 2026

## Stato task precedente
La compilazione principale è COMPLETATA. I dati Jan/Feb/Mar sono scritti nelle righe 4-24.
Righe dazi (6 e 12) erano state lasciate a 0 per "policy 2026" — l'utente ora chiede di compilarle.

---

## Task attivo: Dazi Doganali

### Conto da leggere
`08-83-09-000001-Diritti Doganali` (conto patrimoniale, non economico):
- **Dare (DP)** = pagamenti a dogana → riga 12 Excel (Dazi Doganali costi)
- **Avere (DP)** = rimborsi da clienti → riga 6 Excel (Incassi Dazi Doganali)

### Dati YTD già noti (Jan-11Mar 2026)
| | Dare | Avere | Netto |
|--|------|-------|-------|
| YTD | 2.763.575,98 | 2.809.080,67 | -45.504,69 |

### Approccio: LORDO SEPARATO (scelto dall'utente)
- Row 6 = Avere mensile (rimborsi incassati da clienti)
- Row 12 = Dare mensile (pagamenti effettuati a dogana)

### Steps
1. Bilancio → Filter Mese = gen → leggi Dare e Avere di 08-83-09-000001
2. Bilancio → Filter Mese = feb → leggi Dare e Avere
3. Mar = YTD - gen - feb (YTD: Dare=2.763.575,98, Avere=2.809.080,67)
4. Scrivi con openpyxl:
   - ws.cell(row=6, col=2/3/4) = Avere gen/feb/mar
   - ws.cell(row=12, col=2/3/4) = Dare gen/feb/mar

### File Excel
`/Users/royrigamonti/chuck/BI/CASH FLOW BUDGET 2026.xlsx`
- Row 6: Incassi Dazi Doganali (ricavi)
- Row 12: Dazi Doganali (costi)

---

## Contesto originale (archivio)

Il file `/Users/royrigamonti/chuck/BI/CASH FLOW BUDGET 2026.xlsx` contiene una tabella mensile (Jan-Dic) con righe di ricavi e costi operativi da compilare mensualmente. I dati provengono da due fonti nel BI BeOne Analytics (Qlik Sense):
- **Ricavi Aereo/Mare** → Cruscotto Direzionale (Dashboard)
- **Costi operativi** → Finance 01_ > Bilancio

La compilazione coprirà tutti i mesi disponibili nel 2026 (Gennaio, Febbraio, e Marzo parziale se dati presenti).

---

## Struttura Excel (file: CASH FLOW BUDGET 2026.xlsx, sheet: Cash Flow Mensile)

| Riga | Categoria | Fonte BI |
|------|-----------|----------|
| 2 | Starting Balance | Manuale (END Balance mese precedente) |
| 4 | Incassi Spedizioni Aeree | Cruscotto Direzionale > Ricavi Aereo |
| 5 | Incassi Spedizioni Mare | Cruscotto Direzionale > Ricavi Mare |
| 6 | Dazi Doganali | = 0 (eliminati per policy 2026) |
| 7 | Altri Ricavi Logistici | 20-Valore Produzione meno aereo+mare |
| 10 | Costo Personale | 22-05 |
| 11 | Dazi Doganali (costo) | = 0 |
| 12 | Affitto Ufficio/Magazzino | 22-02-03-000005 o altra voce da verificare con scroll |
| 13 | Assicurazioni | 22-02-03-000001 (Spese Assic. Diverse) |
| 14 | Marketing & Pubblicità | 22-02-02-000001 + 000002 + 000013 |
| 15 | Travel & Trasferte | 22-04 (da espandere con scroll) |
| 16 | Spese IT/Software | 22-02-03-000002 (Contratti Assistenza) |
| 17 | Telefonia & Internet | 22-02-03-000004 (Spese Telefoniche) |
| 18 | Consulenze Legali/Fiscali | 22-02-03-000003 (Legali E Consulenze Varie) |
| 19 | Spese Bancarie | 24-Oneri Finanziari |
| 20 | Carburante & Trasporti | 22-02-02-000003 (Spese Circolazione Automezzi) |
| 21 | Manutenzione Mezzi/Attrezzature | 22-02-01-000004 (Costi Manutenzione E Riparazioni) |
| 22 | Utilities (Luce, Gas, Acqua) | 22-02-01-000003 (Energ. Elet. - Acqua - Gas) |
| 23 | Altri Costi Operativi | Residuo: 22-01, 22-02-01-000005+7, 22-02-02-000010, 22-02-03-000006+8+9, 22-09, 23, 27, 28 |

---

## Mapping conti identificati (struttura Bilancio Qlik)

```
20-Valore Produzione         → Ricavi totali (Economico DP, valore negativo = credito)
22-05                        → Costo Personale
22-02-01-000003              → Utilities (Energ. Elet. - Acqua - Gas)
22-02-01-000004              → Manutenzione
22-02-01-000005              → Vigilanza (→ Altri Costi)
22-02-01-000007              → Pulizia Ufficio (→ Altri Costi)
22-02-02-000001+000002+000013 → Marketing (Pubblicitarie + Promozionali + Fiere)
22-02-02-000003              → Carburante (Spese Circolazione Automezzi)
22-02-02-000010              → Spese Acquisizione (→ Marketing o Altri Costi)
22-02-03-000001              → Assicurazioni
22-02-03-000002              → IT/Software (Contratti Assistenza)
22-02-03-000003              → Consulenze Legali/Fiscali
22-02-03-000004              → Telefonia
22-02-03-000006              → Associative (→ Altri Costi)
22-02-03-000008              → Valori Bollati (→ Altri Costi)
22-02-03-000009              → Donazioni (→ Altri Costi)
22-04                        → Travel/Trasferte (da verificare con scroll)
22-09                        → Altri Costi (da verificare con scroll)
24-Oneri Finanziari          → Spese Bancarie
27-Proventi Straordinari     → (→ Altri Ricavi o escludere)
28-Oneri Straordinari        → (→ Altri Costi)
```

**Affitto**: probabilmente in 22-02-03 (mancano ~85k su 176k totale del gruppo) → da identificare scrollando il Bilancio durante esecuzione.

---

## Steps di Esecuzione

### Step 1 — Scroll Bilancio per completare mapping
1. Nel tab Finance 01_ Bilancio, applicare filtro `Anno Registrazione = 2026`
2. Scrollare il pivot table per vedere:
   - Voci mancanti di 22-02-03 (cercare Affitto/Locazioni)
   - Contenuto di 22-04 (espandere → verifica Travel/Trasferte)
   - Contenuto di 22-05 (espandere → conferma Personale)
   - Contenuto di 22-09 (espandere → identificare voce)
   - Contenuto di 20-Valore Produzione (espandere → vedere sottovoci ricavi)

### Step 2 — Estrazione dati mensili dal Bilancio
Per ogni mese disponibile (Jan, Feb, Mar 2026):
1. Applicare filtro `Anno Registrazione = 2026` + `Mese Registrazione = N`
2. Estrarre tutti i valori `Economico (DP)` per i conti mappati
3. Raccogliere in dizionario Python: `{ mese: { conto: valore } }`

### Step 3 — Estrazione ricavi aereo/mare dal Cruscotto Direzionale
1. Navigare al Cruscotto Direzionale > Dashboard (tab già aperto)
2. Filtrare per Anno 2026
3. Per ogni mese: estrarre Ricavi Aereo e Ricavi Mare

### Step 4 — Scrittura Excel con openpyxl
File: `/Users/royrigamonti/chuck/BI/CASH FLOW BUDGET 2026.xlsx`

```python
import openpyxl

# Mappa colonne mesi: Jan=col2, Feb=col3, Mar=col4, ...
MONTH_COL = { 1: 2, 2: 3, 3: 4, ... }

# Mappa righe categorie
ROW_MAP = {
  'aeree': 4,
  'mare': 5,
  'dazi_rv': 6,  # = 0
  'altri_rv': 7,
  'personale': 10,
  'dazi_costo': 11,  # = 0
  'affitto': 12,
  'assicurazioni': 13,
  'marketing': 14,
  'travel': 15,
  'it': 16,
  'telefonia': 17,
  'consulenze': 18,
  'banca': 19,
  'carburante': 20,
  'manutenzione': 21,
  'utilities': 22,
  'altri': 23
}
```

---

## Voci incerte / da verificare in esecuzione

| Voce | Incertezza | Fallback |
|------|-----------|---------|
| Affitto | Non trovato nei 176k di 22-02-03 visibili | Sommare tutti i non-mappati di 22-02-03 |
| 22-04 | Contenuto sconosciuto (116k YTD) | Mettere in Travel o Altri Costi |
| 22-09 | Contenuto sconosciuto (49k YTD) | Mettere in Altri Costi |
| 20-Valore Produzione | Potrebbe avere sottovoci | Usare Cruscotto per split aereo/mare |
| March 2026 | Dati parziali (al 11/03) | Compilare con dato disponibile, nota in cella |

---

## Voci non presenti nel Bilancio Qlik

Le seguenti righe Excel NON hanno un conto diretto nel Bilancio e vengono impostate a zero o gestite diversamente:
- **Dazi Doganali (ricavi)**: = 0 (policy aziendale 2026)
- **Dazi Doganali (costi)**: = 0

---

## Verifica post-scrittura

1. Aprire `/Users/royrigamonti/chuck/BI/CASH FLOW BUDGET 2026.xlsx` e controllare:
   - Le righe Totale RICAVI e Totale COSTI si aggiornano correttamente (formule esistenti)
   - Il CASH FLOW NETTO è coerente con i dati MOL da MEMORY.md
   - Per Gennaio: Ricavi ~EUR 600-700k, Personale ~EUR 75-85k (1/12 di EUR 905k)
2. Cross-check Gennaio: confrontare Totale Ricavi con sped.xlsx proporzioni mensili

---

*Creato: 2026-03-11*
