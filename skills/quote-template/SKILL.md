---
name: quote-template
description: Genera una quotazione rapida per cliente Columbia Transport partendo dal buying esistente. Usare quando l'utente fornisce costi di acquisto e vuole costruire una tariffa da proporre al cliente.
---

# Skill: quote-template

## Logica di Calcolo

```
Selling = Buying + Margine
Margine % = (Selling - Buying) / Selling * 100
MOL spedizione = Selling - Buying (tutti i componenti)
```

Margini target per servizio (da Marginalita-Servizi.md):
| Servizio | MOL % target |
|----------|-------------|
| Aereo AWB diretto | 25-35% |
| LCL consolidati | 18-28% |
| Aereo MAWB | 15-20% |
| FCL import/export | 8-18% |

## Procedura

1. Chiedi: **"Servizio?"** (FCL / LCL / Aereo AWB / Aereo MAWB)
2. Chiedi: **"Rotta?"** (POL -> POD)
3. Chiedi: **"Buying costs?"** (ocean/air freight + handling + altri)
4. Chiedi: **"Cliente e' price-sensitive o priorita' e' il servizio?"**
5. Calcola selling con margine target
6. Mostra breakdown completo per approvazione
7. Genera testo email quotazione (usa skill email-cliente)

## Output Formato

```
QUOTAZIONE — [Servizio] | [Rotta]
----------------------------------------
Buying:
  - Ocean/Air freight:  EUR ___
  - Handling origine:   EUR ___
  - Handling destino:   EUR ___
  - Altro:              EUR ___
  TOTALE BUYING:        EUR ___

Selling proposto:
  - Ocean/Air freight:  EUR ___
  - Handling:           EUR ___
  - Altro:              EUR ___
  TOTALE SELLING:       EUR ___

MOL:                    EUR ___ (___%)
Validita':              [data]
Transit time:           [giorni]
```

## Quality Checklist
- [ ] MOL % rientra nel target per il servizio
- [ ] Tutti i costi di buying inclusi (no voci dimenticate)
- [ ] Validita' offerta specificata
- [ ] Approvazione Roy prima di inviare al cliente
