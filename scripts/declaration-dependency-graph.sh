#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

# The graph reader imports the compiled audit module so its environment contains every audited
# declaration. Graph generation is deliberately read-only with respect to compiled Lake artifacts
# and dependency materialization: it consumes an Audit artifact from an already validated build and
# never builds or updates one. It writes only ignored graph outputs under `.lake/build/audit/`.
audit_olean=".lake/build/lib/lean/ProjectKoios/Audit.olean"
if [[ ! -f "$audit_olean" ]]; then
  echo "error: $audit_olean is unavailable" >&2
  echo "graph generation requires an existing validated ProjectKoios.Audit artifact" >&2
  echo "this script will not create or refresh compiled Lake artifacts" >&2
  exit 1
fi

lake env lean scripts/DeclarationDependencyGraph.lean

# Rendering is convenient but non-gating; DOT and JSON generation does not require Graphviz.
if command -v dot >/dev/null 2>&1; then
  dot -Tsvg \
    .lake/build/audit/declaration-dependencies.dot \
    -o .lake/build/audit/declaration-dependencies.svg
  dot -Tsvg \
    .lake/build/audit/module-dependencies.dot \
    -o .lake/build/audit/module-dependencies.svg
  dot -Tsvg \
    .lake/build/audit/quantum-mechanics-dependencies.dot \
    -o .lake/build/audit/quantum-mechanics-dependencies.svg
fi

echo "declaration dependency graph written to:"
echo "  .lake/build/audit/declaration-dependencies.json"
echo "  .lake/build/audit/declaration-dependencies.dot"
echo "  .lake/build/audit/declaration-dependencies-full.dot"
echo "  .lake/build/audit/module-dependencies.dot"
echo "  .lake/build/audit/quantum-mechanics-dependencies.dot"
if [[ -f .lake/build/audit/declaration-dependencies.svg ]]; then
  echo "rendered human views:"
  echo "  .lake/build/audit/declaration-dependencies.svg"
  echo "  .lake/build/audit/module-dependencies.svg"
  echo "  .lake/build/audit/quantum-mechanics-dependencies.svg"
fi
