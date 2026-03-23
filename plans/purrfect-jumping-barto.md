# Piano: Fix font e separazione tick markers / numeri minuti

## Context
L'utente vuole che il clock corrisponda al design di stile.png. Attualmente ci sono due problemi:
1. Il font `Fragment Mono` è monospaziale, mentre il design richiede un font sans-serif rotondo (simile a Futura/Gill Sans)
2. I numeri dei minuti (0.92) si sovrappongono alle tacche (0.88–0.95), invece di stare dentro di esse

Esiste anche un bug latente: il calcolo dell'angolo per le label non sottrae 90°, quindi le label sono ruotate di 90° rispetto alla posizione corretta (es. "12" appare a ore 3 invece che a ore 12).

## File da modificare
`/Users/royrigamonti/Chuck/BauhasClock/Sources/Views/ClockView.swift`

---

## Modifiche in `drawHourMarkers`

Spostare le tacche verso il bordo esterno del cerchio per lasciare spazio ai numeri dei minuti:

| Parametro | Prima | Dopo |
|-----------|-------|------|
| Outer distance | `geom.radius * 0.95` | `geom.radius * 1.00` |
| Inner distance | `geom.radius * 0.88` | `geom.radius * 0.93` |

---

## Modifiche in `drawHourAndMinuteLabels`

### 1. Fix angoli (bug)
Aggiungere l'offset `-90°` per allineare correttamente 12 in cima:

```swift
// Ore (1-12): prima   Double(index) * 30
// Ore (1-12): dopo    Double(index + 1) * 30 - 90
let angle = Angle(degrees: Double(index + 1) * 30 - 90)

// Minuti (05-55): prima   Double(index) * 30
// Minuti (05-55): dopo    Double(index + 1) * 30 - 90
let angle = Angle(degrees: Double(index + 1) * 30 - 90)
```

### 2. Riposizionamento radiale

| Layer | Prima | Dopo |
|-------|-------|------|
| Tacche (outer) | 0.95 | 1.00 |
| Tacche (inner) | 0.88 | 0.93 |
| Numeri minuti  | 0.92 ⚠️ (overlap!) | **0.87** |
| Numeri ore     | 0.75 | **0.70** |

### 3. Font
Sostituire `Fragment Mono` (monospaziale) con un font sans-serif di sistema:

```swift
// Prima
.font(.custom("Fragment Mono", size: geom.radius * 0.12))

// Dopo (ore - più grandi)
.font(.system(size: geom.radius * 0.13, design: .default).bold())

// Dopo (minuti - più piccoli)
.font(.system(size: geom.radius * 0.075, design: .default))
```

---

## Struttura radiale finale (dall'esterno all'interno)

```
1.00 ── bordo cerchio / outer delle tacche
0.93 ── inner delle tacche
0.87 ── numeri minuti (05, 10, 15 … 55)
0.70 ── numeri ore (1–12)
0.00 ── centro
```

---

## Verifica
```bash
cd /Users/royrigamonti/Chuck/BauhasClock
swift build        # deve compilare senza errori
swift run BauhasClock  # visuale: 12 in cima, tacche all'esterno, minuti tra tacche e ore
```
