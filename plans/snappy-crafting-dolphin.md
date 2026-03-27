# Piano: HS Classifier Tool

## Contesto
Roy ha il PDF completo HTSUS 2026 (4498 pag). Vuole un tool HTML dove descrive
un prodotto in italiano e ottiene codice HS + aliquota dazi USA.

## Approccio
**Frontend-only HTML** che chiama Anthropic API direttamente da JavaScript.
- Nessun nuovo server Python necessario
- API key inserita una volta → salvata in localStorage
- Tool servito via `http://192.168.1.71:8080/hs-classifier.html`

## File da creare
`~/chuck/Canada/hs-classifier.html`

## Funzionamento
1. Prima apertura: modale per inserire API key Anthropic → localStorage
2. Campo testo: descrizione prodotto in italiano (es. "pompa idraulica per macchine agricole")
3. Tasto "Classifica" → chiama `claude-haiku-4-5-20251001` con prompt esperto
4. Risposta strutturata (JSON):
   - `hs_code` — 10 cifre HTS USA
   - `description_en` — descrizione ufficiale HTS
   - `duty_rate` — aliquota Column 1 General (es. "Free" o "3.5%")
   - `notes` — dazi aggiuntivi rilevanti (Section 301 China, Section 232 acciaio, ecc.)
   - `confidence` — high/medium/low
   - `reasoning` — breve spiegazione classificazione

## UI
- Design coerente con gli altri tool (dark slate, stile container-loader)
- Area input testo grande
- Card risultato con codice HS evidenziato, aliquota in badge colorato
- Storico ultime 5 ricerche (localStorage)
- Pulsante "Copia codice HS"

## Note importanti
- Aliquote Column 1 General = quelle per Italia/UE (non USMCA, non Column 2)
- Il modello ha conoscenza HTSUS aggiornata al training cutoff (ago 2025)
- Tool avvisa che le aliquote IEEPA/executive order 2025 vanno verificate separatamente
