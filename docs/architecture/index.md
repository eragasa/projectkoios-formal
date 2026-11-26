# Repository architecture

This directory records the repository-level architecture of `projectkoios-formal`.
It complements the mathematical module inventory and certificate contracts; it does not change a
Lean theorem's status or make an external artifact admissible evidence.

## Architecture decision

Decision status: operator-authorized for planning on 2026-11-04; implementation, toolchain
installation, dependencies, commits, and publication remain separately gated. Mojo is mandatory in
Phase 1 because it is an anticipated long-term migration target for computational Python code outside
this repository; that motivation does not transfer computational ownership to Formal. Python remains
present here only for bounded non-authoritative support tooling, including proof-document assembly
and any separately authorized synthetic-fixture work.

The repository is a co-located polyglot verification sidecar with four deliberately different
language roles:

| Area | Role | Authority |
|---|---|---|
| [Lean](lean/index.md) | exact semantics, original-byte authentication, theorem applications, authoritative result, and soundness | mathematical and acceptance authority |
| [Rust](rust/index.md) | independently implemented native parser/checker route and deterministic conformance record | required Phase 1 conformance gate; not theorem authority |
| [Mojo](mojo/index.md) | independently implemented native parser/checker route and deterministic conformance record | required Phase 1 conformance gate; not theorem authority |
| [Python](python/index.md) | proof-document assembly and separately authorized synthetic fixture construction, mutation testing, and inspection | non-authoritative tooling only |

Rust and Mojo are both mandatory Phase 1 gates. Missing, malformed, failing, or disagreeing native
conformance records prevent `ACCEPTED_EXACT_BINDING`. Lean alone emits the authoritative result and
must bind both native records before acceptance. Native routes validate theorem inputs; they do not
claim to execute or prove Lean theorem declarations.

Both native implementations are owned here because the certificate contract and exact theorem
profile are Formal-owned. Computational repositories remain owners of numerical production, owner
schemas, scientific interpretation, and retained production artifacts. They may invoke a future
checker as an offline sidecar, but must not import Formal as a runtime library.

## Diagram convention

Architecture schematics use fenced Mermaid diagrams. Do not introduce ASCII-art flowcharts or box
schematics; Mermaid source keeps the diagram reviewable in Markdown and renderable by repository
browsers and documentation tooling.

## Governing documents

- [Repository layout](repo-layout.md)
- [Lean architecture](lean/index.md)
- [Rust architecture](rust/index.md)
- [Mojo architecture](mojo/index.md)
- [Python architecture](python/index.md)
- [Authenticated external matrix/frame binding contract](../BandGauge/ksdft2effmass/authenticated-external-matrix-frame-binding-contract.md)
- [Exact direct-matrix schema index](../../specification/certificates/exact-direct-matrix/index.md)
- [KSD-facing exact synthetic pilot plan](../BandGauge/ksdft2effmass/exact-synthetic-direct-matrix-pilot-plan.md)
- [Authority boundaries](../authority-boundaries.md)
- [Certificate policy](../certificates.md)

The source-neutral normative byte grammars are owned under `specification/`. Version 1 retains the
reviewed single-replay grammar for audit only. Version 2 defines fixed Rust and Mojo conformance
records, failure-dominates-missing precedence, and cycle-free Lean finalization. Version 2 remains
unimplemented; its independent review findings were corrected, focused rereview found no blocking
issue, and the normative schema is frozen.

## Independence requirement

Rust and Mojo must independently implement parsing, canonicalization, digest verification, exact
rational-complex arithmetic, Hermiticity, and derived quantities from the same original bytes. They
may share the public contract, literal standard vectors, and reviewed fixture corpus, but not source
code, generated parser code, native libraries, foreign-function calls, or serialized semantic values.
Their implementation and review histories must identify any shared compiler, cryptographic, package,
or operating-system dependency so agreement is not overstated as fully independent. Initial Rust and
Mojo implementations must be produced in separate fresh contexts from the public schema only; neither
implementation context may read or translate the other route's source before both pass their own
unit, canonical-vector, and adversarial suites. Cross-reading begins only at the differential-review
stage and must be recorded.

## Current status

The repository contains the architecture documentation, source-neutral v1/v2 specifications, the
existing Lean harness, and one standard-library-only Python proof-document builder under
`src/python/projectkoios/formal/documents/proofs/`. No Rust or Mojo source root, certificate parser,
checker, implementation fixture corpus, native conformance record, or accepted result has been
created. The Python document builder compiles and assembles LaTeX dossiers; it is not part of the
certificate or scientific-computation path.

The external 2026-11-08 Gate 0 workspace qualified checksum-pinned Rust 1.99.1, Mojo 1.2.0, a
hash-locked Cargo graph, source-built Decimo, an independent pure-Mojo SHA-256 route, and a
package-empty Python support environment on Apple ARM64. Those installations, sources, executables,
and logs are capability-probe artifacts outside the repository, not checker implementation or
certificate evidence. Gate 0 found no blocking environment issue; implementation and dependency
addition remain unauthorized. The checked runtime-certificate count remains zero.
