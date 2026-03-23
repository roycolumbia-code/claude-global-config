#!/bin/bash
# Claude Code webhook hook for Claude Remote - Stop event

PORT="${CLAUDE_REMOTE_PORT:-8765}"
HOOK_SERVER_URL="http://localhost:${PORT}/hook"
TMUX_SESSION=""
if [ -n "$TMUX" ]; then
    TMUX_SESSION=$(tmux display-message -p '#S')
fi

PROJECT="$(basename "$PWD")"
TIMESTAMP=$(date +%s)
JSON=$(cat <<JSONEOF
{"event":"Stop","project":"$PROJECT","tmux_session":"$TMUX_SESSION","timestamp":$TIMESTAMP}
JSONEOF
)
API_KEY="${CLAUDE_REMOTE_API_KEY:-}"
if [ -n "$API_KEY" ]; then
    curl -s -X POST "$HOOK_SERVER_URL"         -H "Content-Type: application/json"         -H "X-API-Key: $API_KEY"         -d "$JSON"         > /dev/null 2>&1 &
else
    curl -s -X POST "$HOOK_SERVER_URL"         -H "Content-Type: application/json"         -d "$JSON"         > /dev/null 2>&1 &
fi
exit 0