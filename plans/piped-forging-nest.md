# Fix EML parsing nei frontend packing-extractor e canadaconsol-generator

## Contesto

L'API `packing-api.py` (porta 8767) parsa correttamente i file `.eml` — testato con tutti i 12 EML della cartella `canada docs`, produce 9 righe. Il problema è nei due frontend HTML che non inviano o non gestiscono correttamente i file EML.

## Diagnosi

### canadaconsol-generator.html

1. **`handlePdfDrop` (riga 594)**: URL API hardcoded `http://localhost:8767` — se il tool è acceduto via LAN (`192.168.1.71:8080`), il browser del collega chiama `localhost` sulla SUA macchina → fallisce silenziosamente
2. **MIME type (riga 588)**: usa `f.type || 'application/octet-stream'` — i browser non riconoscono `.eml`, quindi MIME è `octet-stream`. L'API gestisce il fallback via estensione, ma è fragile
3. **`handleInvoicePdf` (riga 397)**: invia con `Content-Type: application/pdf` fisso — se l'utente carica un EML qui, viene trattato come PDF e fallisce

### packing-extractor.html

1. **API URL (riga 181)**: usa `window.location.hostname` — corretto per LAN
2. **MIME (riga 216)**: `mimeFor('eml')` → `'message/rfc822'` — corretto
3. **Status display (riga 331)**: confronta `source_file === fq.file.name`, ma per EML `source_file` è il nome dell'allegato PDF interno (es. `royer pl 260286.pdf`), non il nome dell'EML → status mostra "—" invece di "✓", ma i dati vengono comunque caricati nella tabella

L'ipotesi principale per il packing-extractor: potrebbe funzionare ma mostrare status confusi. Oppure c'è un errore JavaScript non visibile. Aggiungo logging diagnostico.

## Piano

### 1. canadaconsol-generator.html — Fix URL e MIME

**File**: `/Users/royrigamonti/chuck/Canada/canadaconsol-generator.html`

- Riga 594: cambiare `fetch('http://localhost:8767/parse-docs', ...)` → usare hostname dinamico: `fetch('http://'+window.location.hostname+':8767/parse-docs', ...)`
- Riga 588: aggiungere detect estensione `.eml` prima del fallback MIME:
  ```js
  var mime = f.type || '';
  if (!mime || mime === 'application/octet-stream') {
    var ext = f.name.split('.').pop().toLowerCase();
    if (ext === 'eml') mime = 'message/rfc822';
    else if (ext === 'docx') mime = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    else mime = 'application/octet-stream';
  }
  ```

### 2. packing-extractor.html — Fix status display per EML

**File**: `/Users/royrigamonti/chuck/Canada/packing-extractor.html`

- Riga 331: migliorare il match `source_file` per EML: se il file caricato è `.eml`, considerare "ok" se QUALUNQUE riga ha `source_file` contenente un allegato (non serve match esatto nome EML)
- Aggiungere `console.log` diagnostico nel catch del fetch per debugging

### 3. Verifica end-to-end

- Riavviare packing-api.py (già fatto con fix DDT e merge dedup)
- Testare da browser:
  - Aprire `http://localhost:8080/Canada/packing-extractor.html`
  - Caricare un `.eml` dalla cartella canada docs
  - Verificare che righe appaiano nella tabella
  - Ripetere per `canadaconsol-generator.html`
