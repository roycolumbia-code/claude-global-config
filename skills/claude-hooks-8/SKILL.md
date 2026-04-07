---
name: claude-hooks-8
description: "Riferimento completo agli 8 hook Claude Code di @zodchiii per automatizzare sicurezza, qualità e produttività. Usa quando vuoi configurare hook in un progetto software: auto-format, blocco comandi pericolosi, protezione file, test automatici, lint, log comandi, auto-commit."
---

# 8 Claude Code Hooks — Riferimento Completo

Fonte: @zodchiii su X (3 apr 2026) — 2M visualizzazioni

> CLAUDE.md funziona ~80% delle volte. Gli hook funzionano **sempre**.

---

## Come funzionano gli hook

- **PreToolUse**: si esegue PRIMA che Claude faccia qualcosa. Exit 2 = blocca l'azione.
- **PostToolUse**: si esegue DOPO. Per cleanup, formatting, test.
- **Stop**: si esegue quando Claude termina una risposta.

**Dove vanno:**
```
.claude/settings.json          # a livello progetto (condiviso via git)
~/.claude/settings.json        # globale (tutti i progetti)
.claude/settings.local.json    # locale (non committato)
```

---

## Hook 1 — Auto-format ogni file modificato

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{"type": "command", "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null; exit 0"}]
    }]
  }
}
```
Sostituire `npx prettier --write` con `black` (Python), `gofmt` (Go), `rustfmt` (Rust).

---

## Hook 2 — Blocca comandi pericolosi

Crea `.claude/hooks/block-dangerous.sh`:
```bash
#!/usr/bin/env bash
set -euo pipefail
cmd=$(jq -r '.tool_input.command // ""')
dangerous_patterns=("rm -rf" "git reset --hard" "git push.*--force" "DROP TABLE" "DROP DATABASE" "curl.*|.*sh" "wget.*|.*bash")
for pattern in "${dangerous_patterns[@]}"; do
  if echo "$cmd" | grep -qiE "$pattern"; then
    echo "Blocked: '$cmd' matches '$pattern'. Proponi un'alternativa sicura." >&2
    exit 2
  fi
done
exit 0
```
```json
{"hooks": {"PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": ".claude/hooks/block-dangerous.sh"}]}]}}
```

> **Nota Roy**: già coperto da `cc-safety-net.js` nel settings.json globale.

---

## Hook 3 — Proteggi file sensibili

Già installato globalmente in `~/.claude/hooks/protect-files.sh`.

Blocca: `.env`, `.pem`, `.key`, `secrets/`, `credentials.json`, `.ssh/`

---

## Hook 4 — Esegui test dopo ogni modifica

```json
{"hooks": {"PostToolUse": [{"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "npm run test --silent 2>&1 | tail -5; exit 0"}]}]}}
```

---

## Hook 5 — Blocca PR se i test falliscono

Crea `.claude/hooks/require-tests-for-pr.sh`:
```bash
#!/usr/bin/env bash
if npm run test --silent; then exit 0
else
  echo "Test falliti. Correggili prima di creare una PR." >&2
  exit 2
fi
```
```json
{"hooks": {"PreToolUse": [{"matcher": "mcp__github__create_pull_request", "hooks": [{"type": "command", "command": ".claude/hooks/require-tests-for-pr.sh"}]}]}}
```

---

## Hook 6 — Auto-lint e riporta errori

```json
{"hooks": {"PostToolUse": [{"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "npx eslint --fix $(jq -r '.tool_input.file_path') 2>&1 | tail -10; exit 0"}]}]}}
```

---

## Hook 7 — Log ogni comando Bash

Crea `.claude/hooks/log-commands.sh`:
```bash
#!/usr/bin/env bash
cmd=$(jq -r '.tool_input.command // ""')
printf '%s %s\n' "$(date -Is)" "$cmd" >> .claude/command-log.txt
exit 0
```
```json
{"hooks": {"PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": ".claude/hooks/log-commands.sh"}]}]}}
```

---

## Hook 8 — Auto-commit dopo ogni task

Crea `.claude/hooks/auto-commit.sh`:
```bash
#!/usr/bin/env bash
git add -A
if ! git diff --cached --quiet; then
  git commit -m "chore(ai): apply Claude edit"
fi
exit 0
```
```json
{"hooks": {"Stop": [{"matcher": "", "hooks": [{"type": "command", "command": ".claude/hooks/auto-commit.sh"}]}]}}
```

---

## settings.json completo (da adattare al progetto)

```json
{
  "hooks": {
    "PreToolUse": [
      {"matcher": "Bash", "hooks": [
        {"type": "command", "command": ".claude/hooks/block-dangerous.sh"},
        {"type": "command", "command": ".claude/hooks/log-commands.sh"}
      ]},
      {"matcher": "Edit|Write", "hooks": [
        {"type": "command", "command": ".claude/hooks/protect-files.sh"}
      ]},
      {"matcher": "mcp__github__create_pull_request", "hooks": [
        {"type": "command", "command": ".claude/hooks/require-tests-for-pr.sh"}
      ]}
    ],
    "PostToolUse": [
      {"matcher": "Write|Edit", "hooks": [
        {"type": "command", "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null; exit 0"},
        {"type": "command", "command": "npx eslint --fix $(jq -r '.tool_input.file_path') 2>&1 | tail -10; exit 0"}
      ]}
    ],
    "Stop": [
      {"matcher": "", "hooks": [
        {"type": "command", "command": ".claude/hooks/auto-commit.sh"}
      ]}
    ]
  }
}
```
