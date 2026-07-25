#!/usr/bin/env bash
set -euo pipefail

SESSION="World"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Session $SESSION already exists. Attaching..."
  tmux attach-session -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -c "$ROOT" -n Terminal
tmux new-window -t "$SESSION" -c "$ROOT" -n Editor "hx"
tmux new-window -t "$SESSION" -c "$ROOT" -n Agent "opencode --continue"
tmux new-window -t "$SESSION" -c "$ROOT" -n Server "bundle exec jekyll serve"

tmux select-window -t "$SESSION:Agent"

tmux attach-session -t "$SESSION"
