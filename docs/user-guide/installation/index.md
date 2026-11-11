# Installation and environment qualification

This guide records the installation boundary for the Formal harness and the planned exact-direct-matrix v2 pilot. It is an audit guide, not blanket authorization to install software.

## Current disposition

- Lean is installed locally and the repository pins Lean and Mathlib immutably.
- Rust 1.99.1 and Mojo 1.2.0 are installed only in the external isolated Gate 0 workspace.
- Exact Rust dependencies, official Mojo wheels, formatter dependencies, and Decimo source were hash-locked, license-reviewed, and qualified for their bounded roles.
- A package-empty Python 3.14 environment passed deterministic fixture and mutation capability probes.
- The source-only distribution model remains mandatory: no official Mojo wheel, `.mojoc` package, MAX runtime file, or compiled Mojo binary may be committed or distributed from this repository.
- Gate 0 reports no blocking environment finding, but exact-direct-matrix v2 implementation remains **unauthorized and unstarted**.
- No parser, checker, implementation fixture corpus, conformance record, or runtime certificate exists. Checked runtime-certificate count remains zero.

Do not interpret a successful installation or capability probe as theorem completion, runtime authentication, scientific validation, evidence promotion, or publication authorization.

## Guides

- [Platform baseline](platform/index.md)
- [Lean and Lake](lean/index.md)
- [Rust](rust/index.md)
- [Mojo](mojo/index.md)
- [Python and uv](python/index.md)
- [Gate 0 qualification](gate-0/index.md)

## Authority boundary

Lean is the sole theorem authority for the planned pilot. Rust and Mojo are mandatory independent conformance routes. Python is limited to deterministic fixture generation, mutation testing, diagnostics, and orchestration. Rust and Mojo must independently consume the original body and envelope bytes and may not share semantic implementations, parsers, rational arithmetic, SHA-256 code, generated schemas, FFI, or semantic intermediates.

## Protected actions

The following still require explicit authorization even when described here:

- installing or upgrading any additional toolchain or package;
- adding or changing a repository dependency or lockfile;
- expanding or rerunning probes outside the qualified bounded scope;
- creating implementation source or fixtures;
- committing, pushing, releasing, publishing, or promoting evidence.

Qualified tools and probe outputs remain outside repository and system toolchain paths. Their presence does not change formal, certificate, numerical, scientific, or publication status.
