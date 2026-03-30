---
name: IMA — Cliente e Tool
description: I.M.A. Industria Macchine Automatiche S.p.A. come shipper ricorrente; tool ima-extractor dedicato alle loro fatture
type: project
---

I.M.A. Industria Macchine Automatiche S.p.A. (Bologna) è un cliente/shipper con un flusso export regolare verso gli USA (IMA NORTH AMERICA INC.).

**Why:** Le fatture IMA hanno un formato specifico (SP PAYM / 260325 style) con struttura non standard rispetto agli altri shipping document italiani. Serve un tool dedicato.

**How to apply:** Il tool `ima-extractor.html` (porta 8080 LAN) gestisce questo cliente. Il backend `/parse-ima` in `packing-api.py` (porta 8767) usa `_parse_ima_document()` che:
- Estrae sempre destinazione "IMA NORTH AMERICA INC. — USA"
- Parser specifico per formato fattura IMA (p1 header + tail pages per line items)
- Download PDF generato lato client con jsPDF + autotable
- Accessibile: http://192.168.1.71:8080/ima-extractor.html

Tool creato: 2026-03-30.
