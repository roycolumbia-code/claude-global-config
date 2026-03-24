---
name: consol
description: Ricostruisce il cargo list di una consolidata verso Montreal cercando le email operative. Input: numero consol. Output: tabella + file HTML.
---

# Skill: consol

## Scopo
Dato un numero di consolidata (es. `/consol 11`), cerca le email operative → ricostruisce il cargo list → produce tabella markdown + file HTML dark-theme.

---

## Procedura

1. **Cerca su Outlook** le email contenenti "Consol #[N]" o "consol [N]"
   - Query: `"Consol #[N]"` oppure `"consol [N]"`
   - Focus su thread tra team interno e angela.caballero@axxessintl.com
   - Includi soggetti con: "loading plan", "cargo list", "update", "week"
   - Leggi almeno 5-10 email per avere il quadro completo

2. **Estrai per ogni shipper:**
   - Mittente (nome azienda)
   - Consegnatario (nome azienda o "—" se non specificato)
   - Merce / colli / CBM (se indicati)
   - Stato aggiornato (confermato, in attesa, rimosso/spostato)

3. **Produci tabella markdown** (nel messaggio)

4. **Crea file HTML** in `chuck/Genova/consol-[N].html`

---

## Ricerca Email — Parametri

| Campo | Valore |
|-------|--------|
| Query principale | `"Consol #[N]"` |
| Query alternativa | `"consol [N]"` |
| Mittente interno | simona@ o team Columbia |
| Controparte | axxessintl.com |
| Temi correlati | "loading plan", "cargo", "week 13" (adatta per numero consol) |

Leggi i thread completi per ricostruire lo **stato più recente** (le email più nuove sovrascrivono quelle vecchie).

---

## Formato Output Tabella (nel messaggio)

```
## Consol #[N] — Cargo List (stato al [data ultima email])
Booking: [booking ID] | Equipment: [tipo] | Destinazione: Montreal

| Mittente | Consegnatario | Merce / Colli | Stato |
|----------|--------------|---------------|-------|
| AZIENDA A | DEST A | 12 PLT / ~XX cbm | ✅ Confermato |
| AZIENDA B | DEST B | 6 PLT | ⚠️ In attesa |
| AZIENDA C | DEST C | — | ❌ Spostato a Consol #[N+1] |

**Note:** [note operative: cut-off, problemi, upgrade equipment]
```

---

## File HTML — Struttura

Crea `chuck/Genova/consol-[N].html` con:
- **Dark theme** (background #0d1117, testo #e6edf3)
- **Header**: "Consol #[N] — Cargo List" + booking + data aggiornamento
- **Tabella** con colori stato:
  - Verde `#238636` → ✅ Confermato / In magazzino
  - Giallo `#d29922` → ⚠️ In attesa / Da confermare
  - Rosso `#da3633` → ❌ Rimosso / Spostato
- **Sezione Note** per info operative (booking, equipment, cut-off)
- **Footer** con data generazione

---

## Legenda Stato

| Simbolo | Significato |
|---------|-------------|
| ✅ | In magazzino / Confermato |
| ⚠️ | In attesa conferma shipper o documenti |
| ❌ | Rimosso / Spostato a consol successiva |

---

## Checklist Pre-Output

- [ ] Lette almeno 5 email del thread consol
- [ ] Identificato il booking number
- [ ] Distinzione chiara tra shippers confermati, in attesa e rimossi
- [ ] Tabella markdown prodotta nel messaggio
- [ ] File HTML creato in chuck/Genova/consol-[N].html
- [ ] MEMORY.md del vault aggiornato con il file prodotto (sezione "Report e Output Prodotti")
