---
name: feedback_icloud_output
description: Dopo ogni skill che produce un file HTML/PDF, chiedere se Roy vuole copiarlo su iCloud Drive per accesso da iPhone
type: feedback
---

Al termine di ogni skill che produce un file di output (HTML, PDF, tabella), chiedere sempre: "Vuoi che copi il file su iCloud Drive per aprirlo su iPhone?"

**Why:** Roy vuole poter aprire i report (consol, analisi, infografiche) direttamente dall'iPhone tramite Files app, senza passare dal Mac.

**How to apply:** Dopo aver creato il file, aggiungere sempre la domanda. Se risponde sì, copiare il file in `~/Library/Mobile Documents/com~apple~CloudDocs/` (iCloud Drive root) o in una sottocartella specifica se indicata. Non copiare automaticamente senza conferma.
