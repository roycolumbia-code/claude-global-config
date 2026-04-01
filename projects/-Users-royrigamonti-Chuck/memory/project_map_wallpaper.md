---
name: map-wallpaper — sfondo Mac con mappa città del giorno
description: Tool Python che ogni mattina scarica tile OpenStreetMap di una città casuale e la imposta come sfondo del Mac
type: project
---

## Percorsi

- Script: `/Users/royrigamonti/chuck/map-wallpaper/map-wallpaper.py`
- Output immagini: `/Users/royrigamonti/Pictures/map-wallpaper/`
- LaunchAgent: `/Users/royrigamonti/Library/LaunchAgents/com.columbia.map-wallpaper.plist`
- Log: `/tmp/map-wallpaper.log`

## Come funziona

- Eseguito ogni mattina alle 08:00 via LaunchAgent (`StartCalendarInterval Hour=8`)
- Sceglie una città casuale (es. Mumbai, Tokyo…), scarica tiles OpenStreetMap (tema voyager)
- Imposta come sfondo macOS via:
  1. **Metodo 1:** PyObjC/NSWorkspace (API nativa, richiede `AppKit`)
  2. **Metodo 2 (fallback):** `osascript` con timeout esplicito di 30 secondi

## Fix 2026-04-01

- Problema: `osascript` andava in timeout → `AppleEvent scaduto (-1712)`
- Soluzione: timeout esplicito `subprocess.run(..., timeout=30)` + fallback chain NSWorkspace → osascript
- Confermato funzionante: `✓ Sfondo impostato!`

## Dipendenze

- `requests` (installato in `/Users/royrigamonti/Library/Python/3.9/`)
- LaunchAgent usa `/usr/bin/python3` (Python 3.9 di sistema)
- **Nota:** `AppKit` non disponibile su sistema Python → usa sempre il fallback osascript

## Come riavviare manualmente

```bash
launchctl unload ~/Library/LaunchAgents/com.columbia.map-wallpaper.plist
launchctl load ~/Library/LaunchAgents/com.columbia.map-wallpaper.plist
# oppure per test immediato:
/usr/bin/python3 /Users/royrigamonti/chuck/map-wallpaper/map-wallpaper.py
```

**Why:** Parte dell'ambiente di lavoro quotidiano Roy — ogni mattina sfondo diverso con mappa geografica.
**How to apply:** Se Roy segnala "il wallpaper non si è aggiornato", controllare `/tmp/map-wallpaper.log` e verificare che il LaunchAgent sia caricato.
