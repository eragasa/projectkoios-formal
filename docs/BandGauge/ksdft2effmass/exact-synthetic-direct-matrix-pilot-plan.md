# KSD-facing exact synthetic direct-matrix pilot plan

## Status

This is a consumer-facing planning and crosswalk document. It does not own certificate bytes or
semantics. The Formal-owned normative schemas are:

- [`PKF-EXACT-DIRECT-MATRIX-PILOT/1`](../../../specification/certificates/exact-direct-matrix/v1.md);
- [`PKF-EXACT-DIRECT-MATRIX-PILOT/2`](../../../specification/certificates/exact-direct-matrix/v2.md).

Version 1 is frozen for audit retention only. Version 2 is the frozen sole future implementation
target and requires Lean authority plus mandatory independent Rust and Mojo conformance records.
Version 2 remains unimplemented.

No parser, checker, executable, source root, fixture corpus, native conformance record, checked
package, or retained runtime certificate currently exists. Checked runtime-certificate count: zero.

## KSD motivation and boundary

The pilot was motivated by the authenticated external matrix/frame binding candidate in
[`authenticated-external-matrix-frame-binding-contract.md`](authenticated-external-matrix-frame-binding-contract.md).
It tests only exact self-contained rational-complex Hermitian matrix pairs. It does not ingest KSD
runtime artifacts and does not authenticate floating-point data, NumPy/SciPy behavior, FFT/DFT,
Wannier90, eigensolvers, meshes, frames, gauges, normalization, ordering, degeneracy handling,
applicability, or scientific adequacy.

KSD retains ownership of production schemas, serializers, verification, runtime bindings,
interpretation, and scientific admission. Formal owns the source-neutral certificate schemas,
offline checkers if separately authorized, synthetic fixtures, exact theorem bindings, and
soundness statements.

No KSD repository may be mutated or executed under this plan. No private source byte, generated
publication artifact, or runtime-produced matrix may be copied into Formal.

## Authenticated planning source

The five-stage KSD calculation boundary was inspected read-only at:

- repository: `ksdft2effmass`;
- commit: `b0af45f4eea97ee41eb0e2ae23a35a986a6c6e78`;
- tree: `3b5e66c797d0ffa1fa1ad9d9a6d3f603f243f4c3`;
- inspected blob: `cfebcdfdb0d3d8316f38b0383d42642e2fbf3cd7`;
- inspected-byte SHA-256: `aabe8c6e005e6605ca4e2fec7103985f1ad303d2f41ff76fce1bbd4867aa74e4`.

Those identities motivate the workflow boundary only. They are not payloads in the synthetic schema
and do not constitute runtime evidence.

## Pilot objectives

1. Exercise canonical exact body and detached-envelope parsing.
2. Exercise domain-separated SHA-256 authentication without self-reference.
3. Derive rational-complex matrix semantics and exact Hermiticity.
4. Bind the five pinned maximum and RMS theorem declarations without conflating them.
5. Derive Frobenius-power audit data rather than trusting producer aggregates.
6. Require independent Rust and Mojo validation of the same original bytes.
7. Make Lean the sole authoritative finalizer.
8. Preserve fail-closed accepted, unresolved, and rejected outcomes.
9. Retain only permitted synthetic fixtures and checker audit metadata.
10. Leave all KSD scientific and runtime admission unchanged.

## Repository architecture

The planned co-located language roles are defined in [`../../architecture/index.md`](../../architecture/index.md):

- Lean: exact semantics, theorem authority, native-record comparison, and final result;
- Rust: mandatory independent native conformance record;
- Mojo: mandatory independent native conformance record;
- Python: non-authoritative synthetic fixture, mutation, inspection, and orchestration tooling.

Rust and Mojo must independently parse the original body and envelope. They may not share parser,
digest, canonicalization, rational-arithmetic, generated schema, native-library, FFI, or semantic-
intermediate implementation code. Initial implementations must be produced in separate fresh
contexts from the normative v2 schema before differential review.

## Proposed implementation boundary

If separately authorized, implementation is co-located in this repository under the planned layout:

```text
ProjectKoios/Formal/ExternalBinding/ExactDirectMatrix/  # Lean authority
rust/crates/exact-direct-matrix/                        # Rust conformance
mojo/src/exact_direct_matrix/                           # Mojo conformance
python/src/projectkoios_formal/                         # non-authoritative tools
fixtures/exact-direct-matrix/v2/                        # synthetic vectors
```

The existing Lean source layout under `ProjectKoios/` remains unchanged. No `lean/src/` root is
introduced. Generated build output remains ignored.

## Implementation gates

### Gate 0: clean base and supply chain

- obtain separate implementation and toolchain-installation authorization;
- start from an identified clean Formal revision in a dedicated worktree;
- freeze exact toolchain versions, targets, distribution sources, checksums, licenses, and platform
  runtime inventory;
- accept no floating or unreviewed dependency;
- freeze exact language-specific and cross-language commands; and
- preserve the independently reviewed frozen v2 schema; any amendment requires renewed review.

### Gate 1: canonical bytes and digests

- implement bounded canonical primitives independently in Lean, Rust, and Mojo;
- implement independent SHA-256 routes;
- check standard and domain-separated vectors; and
- review overflow, end-of-file, allocation, and resource-limit behavior.

### Gate 2: exact semantics

- independently implement normalized retained rational-complex values;
- derive row-major matrices, exact Hermiticity, `A-B`, semantic digests, and Frobenius power;
- enforce the v2 six-operation-per-entry schedule; and
- prove Lean cast, conjugation, Hermiticity, and Frobenius bridges.

### Gate 3: theorem authority and native conformance

- instantiate all five pinned Lean declarations;
- preserve pointwise, maximum, square-sum, squared-RMS, and RMS conclusions distinctly;
- emit canonical Rust and Mojo conformance records only; and
- make Lean reparse and compare both records before acceptance.

### Gate 4: fixtures and finalization

- add canonical acceptance and adversarial fixture bytes;
- demonstrate failure-dominates-missing precedence;
- demonstrate byte-for-byte deterministic native records and Lean results; and
- keep Python outputs non-authoritative.

### Gate 5: audit and review

- run all pinned build, test, type, lint, package-audit, admission, axiom, conflict, and ignore checks;
- obtain fresh independent review of all three checker routes, fixtures, and soundness statements;
- record remaining trust and applicability limits; and
- do not increment runtime-certificate counts or claim production readiness.

## Stop conditions

Stop before or during implementation if:

- v2 field order, variants, precedence, or resource semantics remain ambiguous;
- Mojo cannot provide independently reviewable exact integers/rationals, SHA-256, or deterministic
  bounded behavior without an unreviewed trust expansion;
- either native route depends on the other implementation;
- exact Hermiticity would be replaced by tolerance checks;
- an eigensolver value or producer aggregate would enter the proof boundary;
- the source or dependency base becomes dirty, floating, unlicensed, or unauthenticated;
- a fixture would contain external, private, restricted, or runtime-produced bytes; or
- work would exceed the separately authorized implementation, installation, execution, retention,
  commit, push, evidence-promotion, or publication scope.

## Current disposition

Planning only. The v1 and v2 schemas are now Formal-owned under `specification/`. Independent review
identified one v1 and four v2 blocking specification findings; the corrections were incorporated and
a focused rereview found no blocking issue. Version 1 is frozen for audit retention only. Version 2
is frozen as the sole future implementation target and remains unimplemented. This plan does not
promote evidence or alter KSD's five-stage calculation contract.
