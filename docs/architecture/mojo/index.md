# Mojo architecture

## Role

Mojo is a required independently implemented native conformance route for Phase 1. It consumes the
same original body and envelope bytes as Rust and independently reproduces:

- canonical parsing decisions;
- domain-separated SHA-256 digests;
- normalized exact rational-complex semantics;
- exact Hermiticity and theorem-input validation;
- deterministic first-failure classification; and
- canonical conformance records.

Mojo does not execute Lean theorem declarations, emit the authoritative result, or establish
scientific admission. Missing or failing Mojo conformance prevents Lean acceptance. Mojo must not
call the Rust parser/checker, import Rust-produced semantic objects, or treat a Rust record as its
input.

## Planned source layout

```text
mojo/
├── pyproject.toml
├── uv.lock
├── src/
└── tests/
```

The exact Mojo package version, target platform, installation source, resolved artifact checksum, and
locked environment must be recorded. Virtual environments and compiler caches are generated state
and must remain ignored.

## Capability gate

Before source creation, a bounded Gate 0 probe must establish:

1. checked byte I/O and end-of-file behavior;
2. fixed-width overflow behavior;
3. an independently reviewable SHA-256 route;
4. arbitrary-precision signed integer support;
5. normalized exact rational arithmetic;
6. exact rational-complex equality and conjugation;
7. deterministic bounded allocation and the frozen `6*n*n` normalized-operation schedule;
8. deterministic binaries and tests on the pinned platform;
9. available format, lint, test, and package-audit commands; and
10. an implementation route that does not use Rust FFI or Rust-produced intermediates.

If Mojo lacks an independently reviewable arbitrary-precision integer/rational or SHA-256 facility,
Phase 1 must stop for a reviewed dependency or in-language implementation plan. Mojo may not be
silently demoted to an optional or shadow route: changing its mandatory status requires an explicit
architecture revision. FFI to Rust does not satisfy independence.

## Type-state boundary

Mojo should mirror semantic states, not Rust implementation details:

```text
RawInput
  -> ParsedCanonicalPackage
  -> AuthenticatedPackage
  -> ValidatedExactMatrices
  -> ValidatedTheoremInputs
  -> ConformanceRecord
```

A passing conformance record must not be constructible from raw, merely parsed, or unauthenticated
input. `ACCEPTED_EXACT_BINDING` is not a Mojo type or Mojo output.

## Required quality gates

Before the mandatory Mojo route can participate in an accepted result, Gate 0 must freeze locally
passing commands for:

- formatting, linting, and compile-time checks available in the pinned toolchain;
- build and unit tests on the pinned target;
- bounded adversarial parser testing;
- dependency and license audit;
- canonical fixture reproduction; and
- byte-for-byte differential comparison with Lean and Rust.

## Current status

No `mojo/` source root exists. A local inventory on 2026-11-04 found Mojo, Pixi, Magic, and Modular
tooling absent. Floating official documentation reported Mojo 1.2.0 installable through `uv`, but no
version or artifact is selected by this repository and the required exact-arithmetic and SHA-256
capabilities have not been demonstrated locally.
