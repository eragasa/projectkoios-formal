# Repository architecture

This directory records the repository-level architecture of `projectkoios-formal`.
It complements the mathematical module inventory and certificate contracts; it does not change a
Lean theorem's status or make an external artifact admissible evidence.

## Architecture decision

Decision status: operator-authorized for planning on 2026-11-04; implementation, toolchain
installation, dependencies, commits, and publication remain separately gated. Mojo is mandatory in
Phase 1 because it is an anticipated long-term migration target for computational Python code outside
this repository; that motivation does not transfer computational ownership to Formal. Python remains
present here only for bounded fixture tooling during that transition.

The repository is a co-located polyglot verification sidecar with four deliberately different
language roles:

| Area | Role | Authority |
|---|---|---|
| [Lean](lean/index.md) | exact semantics, original-byte authentication, theorem applications, authoritative result, and soundness | mathematical and acceptance authority |
| [Rust](rust/index.md) | independently implemented native parser/checker route and deterministic conformance record | required Phase 1 conformance gate; not theorem authority |
| [Mojo](mojo/index.md) | independently implemented native parser/checker route and deterministic conformance record | required Phase 1 conformance gate; not theorem authority |
| [Python](python/index.md) | synthetic fixture construction, mutation testing, and inspection | non-authoritative tooling only |

Rust and Mojo are both mandatory Phase 1 gates. Missing, malformed, failing, or disagreeing native
conformance records prevent `ACCEPTED_EXACT_BINDING`. Lean alone emits the authoritative result and
must bind both native records before acceptance. Native routes validate theorem inputs; they do not
claim to execute or prove Lean theorem declarations.

Both native implementations are owned here because the certificate contract and exact theorem
profile are Formal-owned. Computational repositories remain owners of numerical production, owner
schemas, scientific interpretation, and retained production artifacts. They may invoke a future
checker as an offline sidecar, but must not import Formal as a runtime library.

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

Only the architecture documentation, source-neutral v1/v2 specifications, and existing Lean harness
are present. No Rust, Mojo, or Python source root, parser, checker, executable, fixture corpus, native
conformance record, or accepted
result has been created. A local inventory performed on 2026-11-04 found Rust and Mojo toolchains
absent; that observation is inventory evidence, not a durable toolchain pin. The checked
runtime-certificate count remains zero.
