#!/usr/bin/env bash
set -euo pipefail
file=$(jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null || echo "")

if [ -z "$file" ]; then exit 0; fi

protected_patterns=(
  "\.env$"
  "\.env\."
  "\.pem$"
  "\.key$"
  "\.p12$"
  "\.pfx$"
  "secrets/"
  "credentials\.json$"
  "\.netrc$"
  "\.aws/credentials"
  "\.ssh/"
)

for pattern in "${protected_patterns[@]}"; do
  if echo "$file" | grep -qiE "$pattern"; then
    echo "BLOCKED: '$file' è un file protetto. Spiega perché questa modifica è necessaria prima di procedere." >&2
    exit 2
  fi
done
exit 0
