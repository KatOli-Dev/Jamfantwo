#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${JEKYLL_PORT:-4000}"
read -r LAN_IP _ < <(hostname -I 2>/dev/null || true)
LAN_IP="${LAN_IP:-127.0.0.1}"
PUBLIC_URL="${JEKYLL_PUBLIC_URL:-http://${LAN_IP}:${PORT}}"
mkdir -p "$ROOT/temp"
RUNTIME_CONFIG="$(mktemp "$ROOT/temp/jekyll-local.XXXXXX.yml")"

cleanup() {
  rm -f "$RUNTIME_CONFIG"
}

trap cleanup EXIT

printf 'site_url: "%s"\nincremental: false\n' "$PUBLIC_URL" > "$RUNTIME_CONFIG"
printf 'LAN address: %s:%s\n' "$LAN_IP" "$PORT"
printf 'Site URL: %s\n' "$PUBLIC_URL"
printf 'Stylesheet: %s/assets/css/default.css\n' "$PUBLIC_URL"

cd "$ROOT"
exec bundle exec jekyll serve \
  --config "$ROOT/_config.yml,$ROOT/_config.local.yml,$RUNTIME_CONFIG" \
  --host 0.0.0.0 \
  --port "$PORT" \
  "$@"
