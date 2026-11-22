# Rust architecture

## Role

Rust is a required independently implemented native conformance route for Phase 1. It should provide:

- bounded byte-oriented parsing with no permissive fallback;
- canonical encoding checks;
- domain-separated SHA-256 verification;
- exact integer, rational, and rational-complex computation;
- exact Hermiticity and theorem-input validation;
- deterministic first-failure classification; and
- deterministic conformance-record serialization through a narrow offline command-line interface.

Rust does not execute Lean theorem declarations, emit the authoritative result, or establish
scientific admission. Missing or failing Rust conformance prevents Lean acceptance.

## Planned source layout

```text
rust/
├── Cargo.toml
├── Cargo.lock
├── rust-toolchain.toml
├── src/
└── tests/
```

The package should default to denying unsafe code. Any exception requires a localized justification
and independent review. Network access, plugins, dynamic schema discovery, runtime owner adapters,
and foreign-function calls into the Mojo route are out of scope.

## Type-state boundary

The public core should make invalid state transitions difficult to express:

```text
RawInput
  -> ParsedCanonicalPackage
  -> AuthenticatedPackage
  -> ValidatedExactMatrices
  -> ValidatedTheoremInputs
  -> ConformanceRecord
```

Parsing must not return an authenticated or semantically validated type. Exact matrices must not be
constructible from unnormalized rationals. A passing conformance record must not be constructible
without every required native premise. `ACCEPTED_EXACT_BINDING` is not a Rust type or Rust output.

## Dependencies and supply chain

Standard-library-only implementation is not presumed. Arbitrary-precision integer/rational
arithmetic and reviewed SHA-256 will normally require crates. Every dependency must be necessary,
license-compatible, version-pinned, checksum-verified, represented in `Cargo.lock`, and reviewed for
its role in the trusted or conformance surface. Git dependencies require immutable commit revisions.
The exact Rust compiler version, target, installer source, and distribution checksum must be recorded.

Rust and Mojo must not share implementation libraries, generated parser code, foreign-function
calls, or serialized semantic intermediates. Agreement is meaningful only when their parsing,
digest, arithmetic, and semantic routes are independently implemented from the public contract.

## Required quality gates

Gate 0 froze locally passing capability-probe commands for formatting, Clippy with warnings denied,
offline locked tests and builds, dependency/license inspection, bounded raw-byte input, exact
arithmetic, SHA-256 vectors, and deterministic release output.

Before the mandatory Rust route can participate in an accepted result, the separately authorized
implementation must additionally freeze passing commands for:

- parser fuzzing or an equivalently bounded adversarial corpus;
- implementation-specific unsafe-code inspection;
- canonical fixture and mutation-corpus reproduction;
- deterministic conformance-record serialization; and
- byte-for-byte differential comparison with Lean and Mojo.

## Current status

No `rust/` source root or checker exists. The external 2026-11-08 Gate 0 workspace qualified Rust
1.99.1 for `aarch64-apple-darwin`, the checksum-pinned standalone distribution, and a vendored exact
Cargo graph containing 15 external crates. The capability probe passed format, Clippy, offline tests,
release build, exact arithmetic, SHA-256, byte-boundary, overflow, schedule, linkage, and
deterministic-build checks. See the [Rust installation guide](../../user-guide/installation/rust/index.md).

The external probe is not repository implementation. Adding the compiler constraint, Cargo graph,
source, or lock to the repository requires separate authorization.
