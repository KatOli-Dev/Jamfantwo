#!/usr/bin/env bash
set -euo pipefail

SESSION="World"
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SERVE_COMMAND=""
printf -v SERVE_COMMAND '%q' "$ROOT/scripts/serve.sh"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Session $SESSION already exists. Attaching..."
  tmux attach-session -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -c "$ROOT" -n Terminal
tmux new-window -t "$SESSION" -c "$ROOT" -n Editor "hx"
tmux new-window -t "$SESSION" -c "$ROOT" -n Agent "claude --no-chrome"
tmux new-window -t "$SESSION" -c "$ROOT" -n Server "exec $SERVE_COMMAND"
tmux new-window -t "$SESSION" -c "$ROOT" -n Monitor "htop"

tmux select-window -t "$SESSION:Agent"

tmux attach-session -t "$SESSION"
