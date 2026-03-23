#!/bin/bash
# Carica MEMORY.md del vault Columbia Transport all'avvio sessione
# Output su stdout -> Claude lo vede come contesto iniziale

VAULT="$HOME/chuck/IIB"
MEMORY="$VAULT/MEMORY.md"
CLAUDE_CTX="$VAULT/CLAUDE.md"

if [ ! -f "$MEMORY" ]; then
  exit 0
fi

echo "=== VAULT COLUMBIA TRANSPORT - CONTESTO CARICATO ==="
echo ""
echo "--- CLAUDE.md (contesto fisso) ---"
head -60 "$CLAUDE_CTX" 2>/dev/null
echo ""
echo "--- MEMORY.md (stato evolutivo) ---"
cat "$MEMORY"
echo ""
echo "=== FINE CONTESTO VAULT ==="
echo "Vault path: $VAULT"
echo "Agenti disponibili: $(ls "$VAULT/3-Resources/Agenti-Claude/" 2>/dev/null | tr '\n' ', ')"
