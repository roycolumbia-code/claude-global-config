#!/bin/bash
# pull-config-github.sh
# Sincronizza config Claude e vault all'avvio — git pull su tutti i repo

DIRS=(
    "/Users/royrigamonti/.claude"
    "/Users/royrigamonti/Chuck/.claude"
    "/Users/royrigamonti/chuck/IIB"
)

for DIR in "${DIRS[@]}"; do
    if [ ! -d "$DIR/.git" ]; then
        continue
    fi
    cd "$DIR" || continue
    git pull --quiet --rebase 2>/dev/null
done
