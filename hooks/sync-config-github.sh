#!/bin/bash
# sync-config-github.sh
# Sincronizza config Claude su GitHub — eseguito ad ogni Stop
# Push solo se ci sono modifiche (altrimenti nessun overhead)

DIRS=(
    "/Users/royrigamonti/.claude"
    "/Users/royrigamonti/Chuck/.claude"
    "/Users/royrigamonti/chuck/IIB"
)

for DIR in "${DIRS[@]}"; do
    # Salta se non è un repo git
    if [ ! -d "$DIR/.git" ]; then
        continue
    fi

    cd "$DIR" || continue

    # Verifica se ci sono modifiche non committate
    if ! git diff --quiet HEAD 2>/dev/null || git status --porcelain 2>/dev/null | grep -q .; then
        git add -A
        git commit -m "auto-sync $(date '+%Y-%m-%d %H:%M')" --quiet
        git push --quiet 2>/dev/null
    fi
done
