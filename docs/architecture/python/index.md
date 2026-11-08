# Python architecture

## Role

Python is non-authoritative support tooling. It may provide:

- deterministic construction of synthetic positive fixtures;
- mutation and adversarial-case generation;
- byte-layout inspection and human-readable diagnostics;
- expected-disposition tables for tests; and
- orchestration of local differential tests without deciding acceptance.

Python must not implement the authoritative parser, issue an accepted certificate result, establish
exact Hermiticity for evidence purposes, or become a runtime dependency of Rust, Mojo, or Lean.

## Planned source layout

```text
python/
├── pyproject.toml
├── uv.lock
├── src/
└── tests/
```

Any fixture generator must be deterministic from explicit inputs. Generated fixtures become
reviewable repository inputs only after their literal bytes, hashes, expected dispositions, and
generation procedure are recorded. A Python-generated expected value is not trusted merely because
two native implementations reproduce it.

## Boundary and typing rules

- Python may write only permitted synthetic fixtures and local test output.
- Python cannot read or retain private owner-source bytes for this pilot.
- Production KSD adapters remain owned by KSD, not this package.
- NumPy, SciPy, floating-point matrices, eigensolvers, and tolerance-qualified predicates are outside
  the exact Phase 1 boundary.
- Public and internal fixture models must be statically typed; strict type checking, formatting,
  linting, and tests must be frozen as exact Gate 0 commands before source creation.
- Dynamic `Any`, unchecked mapping-shaped schemas, permissive coercion, and silent unknown-field
  acceptance are prohibited in canonical fixture construction.
- Python diagnostics must be labeled non-authoritative in machine-readable and human-readable output.

## Supply chain

The Python version, target platform, installation source, `uv` version, package hashes, dependency
licenses, and exact commands must be recorded. `uv.lock` is a locked resolution record, not by itself
proof of artifact origin or toolchain authenticity.

## Current status

A local inventory on 2026-11-04 found Python 3.14.6 and `uv` 0.11.25 available, but these observed
versions are not yet repository pins. No `python/` package, command set, dependency graph, or fixture
tool has been created.
