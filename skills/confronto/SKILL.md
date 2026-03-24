# Skill: /confronto

## Quando usare questa skill
Quando Roy scrive `/confronto "mese anno - mese anno"` o varianti simili.
Esempi validi:
- `/confronto "febbraio 2025 - febbraio 2026"`
- `/confronto "feb 25 - feb 26"`
- `/confronto "marzo 2025 - marzo 2026"`

## Parametri
Formato: `[mese1] [anno1] - [mese2] [anno2]`
- Accetta nomi completi (febbraio) o abbreviazioni (feb)
- Accetta anni a 2 o 4 cifre (25 → 2025, 26 → 2026)
- Se mancano, chiedi: "Quale confronto vuoi? Es: febbraio 2025 - febbraio 2026"

## Mappatura mesi
| Nome | Abbreviazione BI | N° mese |
|------|-----------------|---------|
| gennaio | gen | 1 |
| febbraio | feb | 2 |
| marzo | mar | 3 |
| aprile | apr | 4 |
| maggio | mag | 5 |
| giugno | giu | 6 |
| luglio | lug | 7 |
| agosto | ago | 8 |
| settembre | set | 9 |
| ottobre | ott | 10 |
| novembre | nov | 11 |
| dicembre | dic | 12 |

---

## Procedura Completa

### Step 1 — Estrai dati dal periodo "vecchio" (sped.xlsx, se è 2025)

Se il primo periodo è 2025, usa Python su `/Users/royrigamonti/chuck/Genova/sped.xlsx`:

```python
import pandas as pd
df = pd.read_excel('/Users/royrigamonti/chuck/Genova/sped.xlsx', sheet_name=0)
df['Competenza'] = pd.to_datetime(df['Competenza'], errors='coerce')
mask = (df['Competenza'].dt.year == ANNO) & (df['Competenza'].dt.month == MESE_NUM)
periodo = df[mask]

rcol = 'Ricavi Sped e Raggruppate (DP)'
ccol = 'Costi Sped e Raggruppate (DP)'
mcol = 'Saldo Totale Sped'

# Totali
ricavi = periodo[rcol].sum()
costi = periodo[ccol].sum()
mol = periodo[mcol].sum()
mol_pct = mol / ricavi * 100
n_sped = len(periodo)

# Per servizio
svc = periodo.groupby('Servizio').agg(
    N=('Spedizione', 'count'),
    Ricavi=(rcol, 'sum'),
    Costi=(ccol, 'sum'),
    MOL=(mcol, 'sum')
).copy()
svc['MOL%'] = svc['MOL'] / svc['Ricavi'] * 100
```

### Step 2 — Estrai dati dal BI per confronto YoY

Naviga al BI Qlik Sense e seleziona il mese del secondo periodo (o entrambi se necessario).
Segui la procedura della skill `dati-bi` per login e navigazione.

**URL Dashboard**: `https://beoneanalytics.novasystems.it/sense/app/142567b7-4344-4e56-8943-7f5710260b65/sheet/2d53e597-a111-40bb-8622-3654469c8bc0/state/analysis`

Dopo aver selezionato il mese, leggi dal snapshot:
- `KPI Nessun titolo Ricavi 2026 (DP) [VAL_2026]` e `[VAL_2025] Ricavi 2025`
- `KPI Nessun titolo Costi 2026 (DP) [VAL_2026]` e `[VAL_2025] Costi 2025`
- `KPI Nessun titolo Saldo 2026 (DP) [VAL_2026]` e `[VAL_2025] Saldo 2025`
- `KPI Nessun titolo Saldo % 2026 [VAL%_2026]` e `[VAL%_2025] Saldo % 2025`
- `Grafico a barre Traffico [N_2025] [N_2026]`
- `Grafico a torta Incidenza Ricavi Aereo [X]% Marittimo [Y]%`
- `Grafico a torta Incidenza Saldo Aereo [X]% Marittimo [Y]%`

**Nota**: il BI mostra sempre 2026 vs 2025. Se il confronto richiesto è diverso (es. 2024 vs 2025), adatta la logica.

### Step 3 — Calcola delta

```
delta_ricavi = ricavi_2 - ricavi_1
delta_ricavi_pct = (ricavi_2 / ricavi_1 - 1) * 100
delta_mol = mol_2 - mol_1
delta_mol_pct = (mol_2 / mol_1 - 1) * 100
delta_molp = molp_2 - molp_1  # in pp
delta_sped = sped_2 - sped_1
delta_sped_pct = (sped_2 / sped_1 - 1) * 100
```

### Step 4 — Genera HTML e salva

Salva in: `/Users/royrigamonti/chuck/Genova/confronto-[mese]-[anno1]-vs-[anno2].html`

Il report HTML deve includere:
1. **Header** con titolo e badge "Confronto YoY"
2. **5 delta card** in cima: Spedizioni, Ricavi, Costi, MOL€, MOL%
   - Colore verde (▲) se miglioramento, rosso (▼) se peggioramento
   - MOL€ su = verde; MOL% su = verde; costi su = rosso (trend negativo)
3. **Barre comparative visive** — Ricavi, Costi, MOL, Spedizioni (periodo1 vs periodo2)
4. **Tabella servizi** del periodo 1 (se dati da sped.xlsx disponibili)
5. **Mix Aereo/Marittimo** del periodo più recente (da BI)
6. **3 insight box** — volume, marginalità, mix
7. **Tabella riepilogo** con tutti i KPI, delta e trend
8. **Footer** con fonte dati e data elaborazione

### Stile HTML (dark theme — usare questo esatto CSS)
```css
:root {
  --bg: #0d1117; --surface: #161b22; --border: #30363d;
  --accent: #58a6ff; --green: #3fb950; --red: #f85149;
  --yellow: #e3b341; --text: #e6edf3; --muted: #8b949e;
  --card-bg: #1c2128;
}
```

Usa lo stesso stile del file esistente:
`/Users/royrigamonti/chuck/Genova/febbraio-2025-vs-2026.html`
come riferimento per struttura e CSS completo.

### Step 5 — Apri il file
```bash
open /Users/royrigamonti/chuck/Genova/confronto-[mese]-[anno1]-vs-[anno2].html
```

---

## Note Tecniche
- sped.xlsx contiene SOLO dati 2025 (colonna `Competenza`)
- Per confronti che coinvolgono solo 2026 o anni futuri, usa esclusivamente il BI
- Il BI mostra KPI 2026 (DP) vs 2025 come riferimento fisso — sfrutta questa struttura
- I valori di MOL% nel BI sono già in percentuale (es. 20,8%)
- I valori MOL% in sped.xlsx sono in decimale (0.208) → moltiplica × 100
- Se la sessione Playwright è già attiva, salta il login e naviga direttamente
- Valore medio per spedizione = Ricavi totali / N spedizioni (utile per il report)

## Output Atteso
File HTML salvato + messaggio a Roy con:
- Percorso file
- 3-4 takeaway chiave (bullet point)
- Eventuale alert se MOL% < 20% o costi crescono > ricavi
