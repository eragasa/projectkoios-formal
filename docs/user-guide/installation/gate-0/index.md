# Gate 0 qualification checklist

## Review outcome

`ReviewOutcome: NO_BLOCKING_FINDINGS`

`ImplementationDisposition: QUALIFIED_ENVIRONMENT; IMPLEMENTATION_UNAUTHORIZED`

The isolated Apple ARM64 environment passed the bounded qualification scope for a future exact-direct-matrix v2 implementation. This closes the environment-capability gate only. Checker implementation, repository dependency addition, commit, push, release, evidence promotion, scientific validation, and publication remain separately protected.

The retained local assessment is `gate-0/2026-11-08/evidence/gate-0-assessment.md` under the external qualification root. Probe logs and installed artifacts are not repository evidence and must not be committed. Checked runtime-certificate count remains zero.

## Qualified entry state

- clean detached worktree at commit `1c12934be61b3ebdc59a94b87822cb94c7951540`, tree `1d4309c12050a7d2517dd525b9ec6034d787dd6c`;
- v2 schema SHA-256 `2d9bf4c4ee051a0600491a723b6c8438e5d03e133b5a2c604a0901e4c88ef050`;
- v1 retained only for audit replay, SHA-256 `665e2e2661fb0c472425879657cc1533823b96a1812ad6cb8726ddcc83263a14`;
- Lean `4.35.0`, Mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679`, and all Lake revisions immutable;
- `lake build`, pin inspection, admission audit, and audit-coverage check passed; and
- no parser, checker, certificate fixture corpus, native conformance record, or finalizer implementation exists.

## Decision status

| Decision | Qualified status |
|---|---|
| Official MAX-licensed Mojo wheels | accepted for isolated local qualification only; never commit or redistribute wheels, `.mojoc`, runtime files, or compiled Mojo binaries |
| Repository distribution form | source-only project output plus approved source dependencies and immutable acquisition records |
| Mojo arbitrary precision | Decimo 0.16.0 source at commit `c49b209ae9d115372b1d76f39ab414f073e8df3a`; selected BigInt/Rational route qualified; dependency addition remains protected |
| Mojo SHA-256 | pure-Mojo capability probe passed standard, padding-boundary, million-byte, and all-octet vectors; checker source remains uncreated |
| Mojo formatter | `mblack==26.7.0` plus four formatter dependencies are hash-locked; the seven-package environment also includes the Mojo compiler and standard-library packages; offline recreation and format checks passed |
| Rust standalone distribution | Rust 1.99.1 ARM64 archive verified and installed in an isolated prefix |
| Cargo graph and feature set | exact lock and 15-crate external graph resolved, vendored, licensed, role-reviewed, and exercised offline |
| Python support route | package-empty CPython 3.14 environment qualified for deterministic fixture and mutation support only |
| Capability probes | Lean, Rust, Mojo, Decimo, and Python support probes completed; qualification binaries were deterministic |
| Implementation | not authorized and not started |

## Qualified capability results

### Byte boundary

- Mojo `FileHandle.read()` was rejected because arbitrary bytes can fail UTF-8 decoding.
- Mojo `FileHandle.read_bytes()` and Rust chunked reads preserved the exact 2 MiB all-octet fixture.
- Short final reads, repeated EOF reads, exact-boundary acceptance, and 2 MiB plus one byte refusal passed.
- Both routes reject before extending the retained body beyond the configured limit.

Parser-specific duplicate, ordering, canonical-encoding, and failure-precedence cases remain implementation-suite obligations because no parser exists.

### Exact arithmetic

Both native capability routes passed:

- canonical rational normalization and exact addition/multiplication;
- rational-complex equality, conjugation, multiplication, and imaginary cancellation;
- one-MiB integer magnitude and rational arithmetic;
- fixed-width overflow characterization and explicit checked/preflight policy; and
- exactly six normalized rational operations per entry at `n = 1` and `n = 16`, giving counts 6 and 1,536.

Mojo fixed-width `Int` wraps on overflow. A future checker must guard size and schedule arithmetic before conversion, subtraction, multiplication, allocation, or indexing.

### SHA-256

Both independent routes agreed with the system reference for:

- empty and `abc` vectors;
- the quick-brown-fox and one-million-`a` vectors where applicable;
- lengths around 55/56/63/64 bytes and additional multi-block boundaries;
- embedded NUL and every-octet data; and
- the exact 2 MiB fixture.

Rust uses the reviewed `sha2` crate. Mojo uses independent local pure-Mojo source. Neither route supplies digest code or semantic intermediates to the other.

### Determinism and independence

- two clean Rust release builds were byte-identical;
- two cache-cleared Mojo builds of each probe were byte-identical;
- two source-precompiled Decimo outputs were byte-identical;
- Rust and Mojo dependency, feature, license, and native-file inventories are retained; final binaries have direct-linkage records, while the full dynamic-loader inventories are explicitly pre-final supporting evidence;
- the compiled selected Decimo route has no Rust, GMP, or MPFR symbols or linked libraries; and
- Decimo's optional MPFR/GMP and CLI FFI sources remain prohibited from the future checker route.

Unavoidable compilers, runtimes, loaders, and system libraries are inventoried platform dependencies, not shared semantic implementations.

## Command status

The exact successful **qualification** commands, working directories, environment variables, expected outputs, exit semantics, and final probe hashes are frozen in the external `frozen-qualification-command-registry.md`.

The following remain `UNFROZEN` because the corresponding implementation artifacts do not exist:

- parser/checker build and test commands;
- schema-valid and adversarial fixture-corpus commands;
- native conformance-record generation;
- Rust/Mojo differential acceptance;
- Lean certificate finalization;
- release, publication, and evidence-promotion commands.

Architecture documents must not invent those commands before successful local execution.

## Implementation-time gates

A separately authorized implementation must still demonstrate:

- fresh, separate Rust and Mojo contexts with specification-only initial access;
- independent original-byte parsing and digest computation;
- no shared parser, canonicalizer, rational implementation, native semantic library, FFI, generated schema, or semantic intermediate;
- the exact v2 failure ordering and failure-dominates-missing rule;
- all canonical integer, rational, complex, matrix, and digest rejection cases;
- preallocation checks for the 256-byte input, 1 MiB derived-magnitude, 1 MiB body, 64 KiB envelope, and 2 MiB native-record limits;
- exact row-major `6*n*n` schedule records;
- deterministic conformance-record serialization; and
- Lean-only authoritative finalization.

Passing Gate 0 does not authenticate runtime execution or establish scientific applicability, adequacy, novelty, production evidence, or publication status.
