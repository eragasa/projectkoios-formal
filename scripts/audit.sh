#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if rg -n --glob '*.lean' '\b(sorry|admit|axiom)\b' ProjectKoios ProjectKoios.lean; then
  echo "audit failed: found an admitted declaration marker" >&2
  exit 1
fi

lake env lean ProjectKoios/Audit.lean

echo "audit passed: no admitted declaration markers in repository-owned Lean sources"
