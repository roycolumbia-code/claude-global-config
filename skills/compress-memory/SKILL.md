---
name: compress-memory
description: Comprime il contesto della sessione corrente in MEMORY.md del vault. Elimina ridondanze, aggiorna KPI, mantiene solo info utili per sessioni future. Minimizza token futuri.
---

# Skill: /compress-memory

## Quando usare questa skill

Usala quando:
- La sessione e' lunga e il contesto si sta riempiendo
- Sono state prese decisioni importanti da ricordare
- Sono stati calcolati nuovi KPI o dati reali
- L'utente dice "salva il contesto" o "aggiorna la memoria"

## Procedura

### Step 1 — Raccogli dalla sessione corrente
Identifica nella conversazione attuale:
- Decisioni di business prese
- Nuovi dati/KPI calcolati (con valori esatti)
- Problemi risolti e come
- Todo emersi

### Step 2 — Leggi MEMORY.md attuale
`~/chuck/IIB/MEMORY.md`

### Step 3 — Aggiorna MEMORY.md

Aggiorna le sezioni rilevanti:

**Sezione "Decisioni di Business Registrate"**: aggiungi con data
**Sezione "KPI Baseline"**: aggiorna valori se ora disponibili dati reali
**Sezione "Pattern Identificati"**: aggiungi nuovi pattern trovati
**Sezione "Todo Aperti"**: aggiungi nuovi, chiudi completati con [x]
**Sezione "Agenti Claude Attivi"**: aggiorna tabella se creati nuovi agenti

### Regole di compressione

- NON duplicare info gia' in CLAUDE.md (contesto fisso)
- NON scrivere "durante questa sessione ho..." — scrivi solo il fatto
- USA formato tabella per dati numerici
- ELIMINA entry MEMORY.md con piu' di 90 giorni senza aggiornamenti
- MAX 150 righe totali MEMORY.md — se superi, archivia in 4-Archives/

### Step 4 — Conferma

Di' all'utente:
> "MEMORY.md aggiornato. [N] nuove decisioni, [N] KPI aggiornati, [N] todo aggiunti."
> Token salvati nelle prossime sessioni: stima basata su righe eliminate/compresse.

## Output

- `~/chuck/IIB/MEMORY.md` aggiornato
- Nessun file nuovo creato (solo aggiornamento)
- Conferma sintetica nel thread
