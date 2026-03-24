---
name: korea
description: Elabora quotazioni aeree da agenti coreani e produce il testo interno pronto da copiare. Usare quando Roy scrive /korea e incolla la mail dell'agente.
---

# Skill: korea

## Scopo
Ricevi la quotazione aerea coreana + dati spedizione → calcoli → output pronto da copiare, NIENT'ALTRO.

---

## Formato Output (SEMPRE QUESTO ESATTO TESTO)

```
Ciao ragazze, per questa fatturiamo:
Nolo: $X
Fob: $Y
Grazie, ciao.
```

---

## Regole di Calcolo

### Nolo
Formula: `(Air rate + FSC + SSC + THC + 0.45) × kg_totali`

- Somma tutte le tariffe per kg: Air rate + FSC + SSC + THC
- Aggiungi 0.45 di profitto per kg
- Moltiplica per il peso totale KG indicato nei dati spedizione
- Formatta con separatore migliaia (punto) e 2 decimali, simbolo `$`
- Esempio: `$12.479,67`

### Fob
Formula: `Doc fee + Hangover pallets + 100`

- Somma Doc fee + costo Hangover pallets (valore fisso indicato, non moltiplicato)
- Aggiungi USD 100 di profitto
- Formatta con separatore migliaia (punto) e 2 decimali, simbolo `$`

### Peso da usare
Il totale KG indicato nei dati spedizione (es. `2,511.0 KG` → 2511.0 kg).
Non usare mai pesi parziali o stimati.

### Formato numeri
- Separatore migliaia: `.` (punto)
- Separatore decimali: `,` (virgola)
- Simbolo: `$` (sempre davanti)
- Esempio corretto: `$3.456,78`

---

## Procedura

1. Estrai dal testo: Air rate, FSC, SSC, THC, Doc fee, Hangover pallets (valore), kg totali
2. Calcola Nolo internamente (non mostrare nell'output)
3. Calcola Fob internamente (non mostrare nell'output)
4. Produci SOLO il testo finale — niente spiegazioni, calcoli, commenti extra

**Eccezione:** se Roy chiede esplicitamente "mostrami il dettaglio" o "spiega il calcolo", allora mostra i passaggi.

---

## Esempio

**Input:**
```
Air rate: USD 3.20/kg
FSC: USD 0.50/kg
SSC: USD 0.10/kg
THC: USD 0.30/kg
Doc fee: USD 65/B/L
Hangover pallets: USD 120 (requested 2 pallets)

PIECE # 12 CTN / 2,511.0 KG / 110*110*110*12
```

**Calcolo interno:**
- Tariffa totale/kg: 3.20 + 0.50 + 0.10 + 0.30 + 0.45 = 4.55
- Nolo: 4.55 × 2511.0 = 11.425,05
- Fob: 65 + 120 + 100 = 285,00

**Output:**
```
Ciao ragazze, per questa fatturiamo:
Nolo: $11.425,05
Fob: $285,00
Grazie, ciao.
```

---

## Checklist Pre-Output

- [ ] Tutte le voci tariffarie estratte: Air rate, FSC, SSC, THC
- [ ] 0.45 aggiunto al totale tariffe/kg
- [ ] Peso KG corretto dai dati spedizione
- [ ] Nolo = somma tariffe × kg, formato corretto
- [ ] Fob = Doc fee + Hangover pallets (valore) + 100, formato corretto
- [ ] Formato numeri: punto migliaia, virgola decimali, simbolo $
- [ ] Output: solo il testo, niente altro
