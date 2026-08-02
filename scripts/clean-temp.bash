#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP="$ROOT/temp"

if [[ -d "$TEMP" ]]; then
  shopt -s dotglob nullglob
  files=("$TEMP"/*)
  ((${#files[@]})) && rm -rf -- "${files[@]}"
fi
