# Skill: /dati-bi

## Quando usare questa skill
Usala quando Roy scrive `/dati-bi [mese] [anno]` o chiede dati dal BI Qlik Sense.
Esempi validi: `/dati-bi gennaio 2026`, `/dati-bi febbraio 2026`, `/dati-bi marzo 2026`

## Parametri
- **mese**: nome del mese in italiano (gennaio, febbraio, marzo, ecc.)
- **anno**: anno a 4 cifre (es. 2026)
- Se mancano, chiedi: "Per quale mese e anno vuoi i dati?"

## Mappatura mesi → abbreviazione Qlik
| Mese | Abbreviazione |
|------|---------------|
| gennaio | gen |
| febbraio | feb |
| marzo | mar |
| aprile | apr |
| maggio | mag |
| giugno | giu |
| luglio | lug |
| agosto | ago |
| settembre | set |
| ottobre | ott |
| novembre | nov |
| dicembre | dic |

## URL e Credenziali
- **Login URL**: `https://beoneanalytics.novasystems.it:8443/login/login.aspx?proxyRestUri=https%3a%2f%2fbeoneanalytics.novasystems.it%3a4243%2fqps%2f&targetId=bc1a845b-7971-4c72-92fe-f65dde4e3b67`
- **Dashboard URL**: `https://beoneanalytics.novasystems.it/sense/app/142567b7-4344-4e56-8943-7f5710260b65/sheet/2d53e597-a111-40bb-8622-3654469c8bc0/state/analysis`
- **Username**: `cltsara`
- **Password**: `sara2026`

## Procedura step-by-step

### Step 1 — Naviga al login
Usa `mcp__plugin_playwright_playwright__browser_navigate` con la Login URL.

### Step 2 — Inserisci credenziali e accedi
Usa `mcp__plugin_playwright_playwright__browser_fill_form` per compilare Username e Password, poi `mcp__plugin_playwright_playwright__browser_click` sul pulsante Login.

### Step 3 — Naviga al Dashboard
Dopo il login, usa `mcp__plugin_playwright_playwright__browser_navigate` con la Dashboard URL.
Attendi che la pagina carichi (il titolo diventa "Cruscotto Direzionale_ - Dashboard | Foglio - Qlik Sense").

### Step 4 — Seleziona Anno
1. Prendi uno snapshot con `mcp__plugin_playwright_playwright__browser_snapshot` per trovare il ref del heading "Anno Competenza"
2. Clicca su "Anno Competenza" heading
3. Nel popup, clicca sulla row con l'anno richiesto (es. "2026 Opzionale")
4. Clicca il pulsante "Conferma selezione" (testid: `actions-toolbar-confirm`)

### Step 5 — Seleziona Mese
1. Prendi uno snapshot per trovare il ref del heading "Mese Competenza"
2. Clicca su "Mese Competenza" heading
3. Nel popup, clicca sulla row con l'abbreviazione del mese (es. "gen Opzionale" per gennaio)
4. Clicca il pulsante "Conferma selezione" (testid: `actions-toolbar-confirm`)

### Step 6 — Leggi i dati
Prendi uno snapshot finale. I dati sono leggibili direttamente dall'accessibility tree negli elementi `application`:
- **Ricavi**: cerca `KPI Nessun titolo Ricavi [anno] (DP) [valore]`
- **Costi**: cerca `KPI Nessun titolo Costi [anno] (DP) [valore]`
- **Saldo/MOL**: cerca `KPI Nessun titolo Saldo [anno] (DP) [valore]`
- **Saldo %/MOL%**: cerca `KPI Nessun titolo Saldo % [anno] [valore]`
- **Incidenza Ricavi**: cerca `Grafico a torta Incidenza Ricavi Aereo [x]% Marittimo [y]%`
- **Incidenza Saldo**: cerca `Grafico a torta Incidenza Saldo Aereo [x]% Marittimo [y]%`
- **Traffico/Spedizioni**: cerca `Grafico a barre Traffico` — i numeri dopo le etichette mese sono le spedizioni

### Step 7 — Formatta e presenta
Presenta i dati in questo formato:

```
## BI Report — [Mese] [Anno]

### KPI Principali
| Indicatore | Valore |
|------------|--------|
| Ricavi | X,XXM |
| Costi | X,XXM |
| MOL (Saldo) | XXX,Xk |
| MOL% | XX,X% |

### Mix Aereo / Marittimo
| Metrica | Aereo | Marittimo |
|---------|-------|-----------|
| Ricavi | XX.X% | XX.X% |
| Saldo | XX.X% | XX.X% |

### Traffico
| Mese | Spedizioni |
|------|------------|
| [mese] | XXX |
```

## Note tecniche
- Qlik Sense è lento a caricarsi: se il snapshot mostra solo `img` senza testo, aspetta qualche secondo e riprova con un altro snapshot
- Dopo il login, la sessione rimane attiva per la durata della conversazione
- Se il mese richiesto risulta "Escluso" nel filtro, significa che non ci sono dati per quel mese/anno — avvisare Roy
- Se già loggato dalla sessione corrente, salta Step 1-2 e vai direttamente a Step 3
- Se errore "no sessioni disponibili" al login: la sessione precedente è ancora attiva (timeout ~30 min). In alternativa prova a navigare direttamente all'URL del Dashboard — se la sessione è ancora valida carica senza login.

---

## Mappa Completa Sheet (8 totali)

> Mappa dettagliata: `/Users/royrigamonti/chuck/bi-map/MAPPA-BI.md`
> Screenshot per ogni sheet: `/Users/royrigamonti/chuck/bi-map/*.png`

| # | Sheet | Sheet ID | Contenuto chiave |
|---|-------|----------|-----------------|
| 1 | **Dashboard** | `2d53e597-a111-40bb-8622-3654469c8bc0` | KPI globali (Ricavi/Costi/Saldo/Saldo%), torte aereo/mare, trend mensile, traffico |
| 2 | **Tipo Trasporto** | `323b3e97-8f1f-4d6e-86ca-4936fc67f8c5` | Trellis Aereo \| Marittimo per mese. Metriche: Redditività, Spedizioni, Colli, Kg, m³ |
| 3 | **Analisi Traffico** | `182c99c6-c411-4a93-ad2a-d6d31d196781` | KPI volumi (Spedizioni 3,84k, Peso 8,18M, m³ 16,65k), trend settimanale multi-anno, top clienti per colli, rese |
| 4 | **Analisi Redditività** | `0b01ebc9-3cb8-48bb-80e5-ecc0ca147511` | KPI Ricavi/Costi/Saldo YTD, trend settimanale, confronto Aereo vs Marittimo |
| 5 | **Pivot Clienti** | `790a0b1a-0a35-4800-a901-84a06859f52b` | Tabella pivot cliente × Saldo/Saldo%/Ricavi/Costi/Spedizioni, drill-down per tipo/settore |
| 6 | **Confronto Anni** | `f5489bf2-f1bf-4e4a-95f4-e81d9035d7a3` | Delta YoY mese per mese: Saldo/Ricavi/Costi 2026 vs 2025. Dimensione configurabile. |
| 7 | **Dettaglio Spedizioni** | `45c57e43-7d6d-4842-94fa-dcb1124b5bf5` | Tabella riga per riga ogni spedizione: ID, tipo, servizio, cliente, date, pratica |
| 8 | **What's New** | `UuTvM` | Changelog piattaforma. No dati di business. |

### URL Diretti per Sheet
```
Base: https://beoneanalytics.novasystems.it/sense/app/142567b7-4344-4e56-8943-7f5710260b65/sheet/[SHEET_ID]/state/analysis

Dashboard:           sheet/2d53e597-a111-40bb-8622-3654469c8bc0/state/analysis
Tipo Trasporto:      sheet/323b3e97-8f1f-4d6e-86ca-4936fc67f8c5/state/analysis
Analisi Traffico:    sheet/182c99c6-c411-4a93-ad2a-d6d31d196781/state/analysis
Analisi Redditività: sheet/0b01ebc9-3cb8-48bb-80e5-ecc0ca147511/state/analysis
Pivot Clienti:       sheet/790a0b1a-0a35-4800-a901-84a06859f52b/state/analysis
Confronto Anni:      sheet/f5489bf2-f1bf-4e4a-95f4-e81d9035d7a3/state/analysis
Dettaglio Spedizioni:sheet/45c57e43-7d6d-4842-94fa-dcb1124b5bf5/state/analysis
```

### Quale sheet usare per rispondere a domande comuni
| Domanda | Sheet consigliata |
|---------|-------------------|
| KPI mese/anno (Ricavi, MOL, MOL%) | 1 — Dashboard |
| Aereo vs Marittimo per metrica | 2 — Tipo Trasporto |
| Quante spedizioni / quanto volume | 3 — Analisi Traffico |
| Top clienti per ricavi | 4 — Analisi Redditività |
| MOL/Ricavi per cliente specifico | 5 — Pivot Clienti |
| Come stiamo vs anno scorso | 6 — Confronto Anni |
| Dettaglio singola spedizione | 7 — Dettaglio Spedizioni |
