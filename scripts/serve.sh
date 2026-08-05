#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${JEKYLL_PORT:-4000}"
mkdir -p "$ROOT/temp"
RUNTIME_CONFIG="$(mktemp "$ROOT/temp/jekyll-local.XXXXXX.yml")"

cleanup() {
  rm -f "$RUNTIME_CONFIG"
}

trap cleanup EXIT

if [ -n "${JEKYLL_PUBLIC_URL:-}" ]; then
  printf 'site_url: "%s"\nincremental: false\n' "$JEKYLL_PUBLIC_URL" > "$RUNTIME_CONFIG"
  printf 'Site URL: %s\n' "$JEKYLL_PUBLIC_URL"
  printf 'Stylesheet: %s/assets/css/default.css\n' "$JEKYLL_PUBLIC_URL"
else
  printf 'incremental: false\n' > "$RUNTIME_CONFIG"
  printf 'Links: root-relative — works from any address on port %s\n' "$PORT"
fi

cd "$ROOT"
bundle exec jekyll serve \
  --config "$ROOT/_config.yml,$ROOT/_config.local.yml,$RUNTIME_CONFIG" \
  --host 0.0.0.0 \
  --port "$PORT" \
  "$@"
