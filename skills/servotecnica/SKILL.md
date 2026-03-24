---
name: servotecnica
description: Elabora quotazioni aeree ricevute da agenti cinesi e produce il testo interno pronto da copiare e inviare al team. Usare quando Roy scrive /servotecnica e incolla la mail dell'agente.
---

# Skill: servotecnica

## Scopo
Ricevi la mail di quotazione di un agente cinese → calcoli → output pronto da copiare, NIENT'ALTRO.

---

## Formato Output (SEMPRE QUESTO ESATTO TESTO)

```
Buongiorno ragazze!
Per questa spedizione di X, i costi che abbiamo sono:

FOB: USD Y
Nolo: USD Z/kg
Spese IT: come da qt in essere

Buona giornata!!
```

---

## Regole di Calcolo

### X — Dati spedizione
Copia esattamente i dati totali della spedizione dal testo ricevuto nel formato presente.
Esempio: `10/264kgs/0.81cbm`

### Y — FOB (costi locali + profitto)
1. Per ogni shipper nel testo, somma TUTTE le voci di costo locale:
   - EXW rate
   - pick up charge
   - THC charges
   - magnetic inspection charges
   - Customs Entry Input Fee
   - qualsiasi altra voce locale
2. **THC espresso come USD/kg**: se scritto come "USD 0.08/kg based on full C.W.", moltiplicare per i kg di quello shipper specifico
3. Somma i costi locali di TUTTI gli shipper
4. Aggiungi USD 250 di profitto
5. Arrotonda ALL'ECCESSO all'USD intero (nessun decimale, mai per difetto)

**Formula:** `ceiling(sum_local_charges_tutti_shipper + 250)`

### Z — Tariffa nolo per kg
1. Prendi la tariffa A/F netta (net A/F rate) indicata nel testo
2. Aggiungi USD 0.50/kg di profitto
3. Esprimi con 2 decimali

**Formula:** `net_AF_rate + 0.50`

**NON calcolare mai il totale del nolo — solo la tariffa per kg.**

---

## Procedura

1. Leggi la mail dell'agente
2. Estrai X (dati spedizione totali)
3. Calcola FOB step-by-step (mostra il calcolo internamente per verifica, ma NON nell'output finale)
4. Calcola Z (nolo/kg)
5. Produci SOLO il testo finale — niente spiegazioni, tabelle, note extra

---

## Esempio Completo

**Input ricevuto (esempio):**
```
Shipper A: EXW USD 80, pick up USD 45, THC USD 0.08/kg on 110kgs, magnetic inspection USD 30
Shipper B: EXW USD 60, pick up USD 35, THC USD 35
Net A/F rate: USD 5.50/kg
Total: 14/110kgs/0.57cbm
```

**Calcolo interno:**
- Shipper A: 80 + 45 + (0.08 × 110) + 30 = 80 + 45 + 8.80 + 30 = 163.80
- Shipper B: 60 + 35 + 35 = 130
- Totale locale: 163.80 + 130 = 293.80
- + 250 profitto = 543.80
- Ceiling → 544... ma nell'esempio dell'utente è 476 per un caso diverso, ogni calcolo va fatto sul testo reale
- Nolo: 5.50 + 0.50 = 6.00

**Output:**
```
Buongiorno ragazze!
Per questa spedizione di 14/110kgs/0.57cbm, i costi che abbiamo sono:

FOB: USD 476
Nolo: USD 6.00/kg
Spese IT: come da qt in essere

Buona giornata!!
```

---

## Checklist Pre-Output

- [ ] X: dati spedizione copiati esatti dal testo (formato originale)
- [ ] FOB: somma TUTTE le local charges di ogni shipper (non dimenticare nessuna voce)
- [ ] THC a kg: moltiplicato per i kg corretti dello shipper
- [ ] FOB: aggiunto USD 250 profitto
- [ ] FOB: arrotondato per ECCESSO (ceiling), nessun decimale
- [ ] Nolo: solo tariffa/kg = net A/F + 0.50, con 2 decimali
- [ ] Output: solo il testo, niente altro
