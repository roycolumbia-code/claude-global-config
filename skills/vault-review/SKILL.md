---
name: vault-review
description: Analisi vault Columbia Transport via sub-agente. Legge dati esistenti, calcola ottimizzazioni MOL, scrive report in 3-Resources/Agenti-Claude/. Non usa il thread principale per l'analisi.
---

# Skill: /vault-review

## Quando usare questa skill

Usala quando l'utente chiede:
- "analizza il vault"
- "aggiorna AnalisiMarginalita"
- "cosa posso ottimizzare"
- qualsiasi analisi su MOL, clienti, spedizioni Columbia Transport

## Procedura

### Step 1 — Leggi contesto (tu, thread principale)
Leggi questi file in ordine:
1. `~/chuck/IIB/MEMORY.md` — stato corrente
2. `~/chuck/IIB/2-Areas/Columbia-Transport/KPI-Dashboard.md` — KPI attivi

### Step 2 — Spawna sub-agente con Agent tool

Invia al sub-agente questo prompt (sostituendo i dati reali):

```
Sei un analista freight forwarding per Columbia Transport (Genova).
Hai accesso al vault Obsidian in ~/chuck/IIB/

TASK: Analizza marginalita' servizi e proponi ottimizzazioni MOL.

LEGGI questi file:
- ~/chuck/IIB/2-Areas/Columbia-Transport/Marginalita-Servizi.md
- ~/chuck/IIB/1-Projects/LogisticaTessile/_INDEX.md
- ~/chuck/IIB/3-Resources/Mercati/Sea-LCL.md
- ~/chuck/IIB/3-Resources/Mercati/Air-Freight.md
- ~/chuck/IIB/3-Resources/Agenti-Claude/AnalisiMarginalita.md (storico)

PRODUCI:
1. Stato MOL attuale per servizio (con dati reali se disponibili)
2. Top 3 azioni concrete per aumentare MOL nei prossimi 90 giorni
3. Clienti/rotte da abbandonare (MOL < soglia)
4. Clienti/rotte da sviluppare (MOL alto + potenziale)

SCRIVI risultati in: ~/chuck/IIB/3-Resources/Agenti-Claude/AnalisiMarginalita.md
Aggiorna la sezione "Ultimo Report" con data odierna.
NON rispondere al thread principale — scrivi solo nel file.
```

### Step 3 — Conferma all'utente
Dopo che il sub-agente ha finito, di' all'utente:
> "Report aggiornato in `3-Resources/Agenti-Claude/AnalisiMarginalita.md`"
> Riassumi in 3 bullet i punti chiave trovati.

## Output atteso

- File aggiornato in vault
- Summary di 3 righe nel thread principale
- Nessun dato ridondante nel thread

## Note

- Se mancano dati granulari (revenue per spedizione), il sub-agente usa stime da benchmark settore e lo dichiara esplicitamente
- Aggiorna sempre `MEMORY.md` con nuovi KPI calcolati
