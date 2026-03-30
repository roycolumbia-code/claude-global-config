---
name: Preferenze Tool LAN
description: Come Roy vuole che vengano costruiti i tool HTML per i colleghi
type: feedback
---

Tutti i nuovi tool HTML per i colleghi devono rispettare questi criteri:

**Why:** I tool sono usati quotidianamente da operativi non tecnici via browser sulla LAN.

**How to apply:**
- Servire sempre su porta 8080 (Mac Mini fisso) — non chiedere l'indirizzo, è sempre 192.168.1.71:8080
- Aggiungere sempre download PDF con tutte le info raggruppate (jsPDF + autotable)
- Dark theme con design system interno (--bg:#0f1117, --surface:#1a1d27, --accent:#4f8ef7)
- Input: drag-and-drop file + click per selezionare, accettare PDF/DOCX/EML/MSG
- Output: card visive con info-grid + tabella righe + summary strip numerica
- Backend Python: aggiungere endpoint in `packing-api.py` (ThreadingHTTPServer porta 8767)
