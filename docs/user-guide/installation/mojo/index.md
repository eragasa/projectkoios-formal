# Mojo installation and qualification

Mojo is a mandatory independent conformance route for exact-direct-matrix v2. On 2026-11-08, Mojo 1.2.0 was installed in an isolated local environment and passed the bounded Gate 0 capability suite. This qualification does not authorize checker implementation, repository dependency addition, binary distribution, or evidence promotion.

## Qualified compiler

| Item | Qualified identity |
|---|---|
| Mojo | `1.2.0 (2016d0cd)` |
| Platform | `macosx_13_0_arm64` |

The compiler source is published under Apache-2.0 with LLVM Exceptions. That source license does not replace the MAX license attached to official binary wheels. The inspected PyPI metadata reports `LicenseRef-MAX-Platform-Software-License`; local use remains governed by the [MAX License](https://www.modular.com/legal/max-license).

The repository distribution model is source-only. Do not commit or redistribute official Mojo wheels, MAX-licensed source copied from the wheels, `.mojoc` packages, MAX runtime files, or compiled Mojo binaries. Independently authored project `.mojo` source and approved permissively licensed dependency source may be distributed with their required notices.

## Hash-locked local environment

| Artifact | SHA-256 | Role |
|---|---|---|
| `mojo_compiler-1.2.0-py3-none-macosx_13_0_arm64.whl` | `bc1777d9b3cf4522ee213cc83876b1955499aec2aa8dd8a75ce477f0cd227a90` | compiler and runtime |
| `mojo_compiler_mojo_libs-1.2.0-py3-none-any.whl` | `3d631f7e798c11d0029c4a892ebae1f5742751fac0c526af74b45a8ae07c3acb` | compiler-matched standard library |
| `mblack-26.7.0-py3-none-any.whl` | `a7dcf3cf1a8439bacd0fc692eb75783b8fd315fcfd5260e0f74e8e5ba77e5133` | required formatter frontend |

The full locked environment also contains exact `click`, `mypy-extensions`, `pathspec`, and `platformdirs` wheels. It was recreated with index access disabled, offline mode, and required hashes. `pathspec` is MPL-2.0 tooling-only. The other formatter dependencies are permissively licensed; `mblack` package metadata declares the MAX license.

A compiler-only environment built the probes but could not run `mojo format`, reporting:

```text
unable to resolve Mojo formatter in PATH, try installing `mojo`.
```

The full seven-wheel environment is therefore required for retained formatting checks. Its package metadata identifies `mblack==26.7.0`, while the CLI banner says `mblack, 0.2.dev2`; record both values in provenance.

Exact offline-recreation commands are frozen in the external Gate 0 command registry. Do not replace them with an unconstrained `uv pip install mojo`.

## Arbitrary precision: selected Decimo route

| Item | Qualified identity |
|---|---|
| Version | `0.16.0` |
| Git commit | `c49b209ae9d115372b1d76f39ab414f073e8df3a` |
| Git tree | `26fddf26764c40d9de704b374599a9808f31c00e` |
| License | Apache-2.0 |
| Declared Mojo range | `>=1.2.0,<1.3.0` |

The selected source-built BigInt/BigUInt/Rational route passed 87 upstream tests, rational normalization and arithmetic, rational-complex identities, one-MiB magnitude probes, and exact six-operation schedules at `n = 1` and `n = 16`.

Two cache-cleared source precompilations were byte-identical, with SHA-256:

```text
770b7fa93fd1b47d3463b9d3a963c43842c80c7fecdb4991112cd97f0788095b
```

The precompiled conda `.mojoc` artifact is not an acceptable source-audit boundary and is not part of the distribution model. Decimo contains optional MPFR/GMP wrappers and CLI FFI source outside the selected modules. Those routes must not enter the checker build. The compiled capability probe had no Rust, GMP, MPFR, or `decimo_mpfr` symbols or links.

Adding Decimo source to the repository implementation remains a protected action and requires a separate exact scope and license-notice review.

## SHA-256 route

Mojo's documented `hash_bytes` defaults to a 64-bit `AHasher`; it is not SHA-256. The qualified route is an independently authored, pure-Mojo FIPS 180-4 implementation with no Rust FFI, native crypto library, Python callout, or shared generated code.

The capability source passed:

- empty, `abc`, quick-brown-fox, and one-million-`a` vectors;
- 17 padding and chunk boundaries from 1 through 4,097 bytes;
- every-octet 2 MiB input;
- one-shot and chunked file ingestion; and
- agreement with system and independent Rust SHA-256 results.

The deterministic capability binary SHA-256 was:

```text
ec7d996fca33d3fc9e3fc1da3b3d81d3dd989f83fd72fe7488cccb3ebfc21913
```

This authenticates byte equality only. It does not establish origin, extraction fidelity, semantic correctness, applicability, or scientific adequacy.

## Binary I/O and bounds

`FileHandle.read()` is prohibited for authenticated input: a binary probe failed with `Cannot construct a String from invalid UTF-8 data`.

Use `FileHandle.read_bytes()` for arbitrary bytes. The qualified route demonstrated:

- all 2,097,152 fixture bytes preserved;
- 777-byte chunking with a short final chunk;
- empty read at EOF and another empty post-EOF read;
- exact digest agreement;
- exact 2 MiB acceptance; and
- 2 MiB plus one byte refusal before appending past capacity.

The safe preappend condition is equivalent to checking `len(chunk) > file_limit - len(content)` while the retained invariant guarantees `len(content) <= file_limit`.

Mojo fixed-width `Int` wraps: the probe observed `Int.MAX + 1 == Int.MIN`. Future checker code must guard or avoid every size, schedule, allocation, and index calculation that could overflow. It must not rely on overflow exceptions.

## Build and runtime boundary

Both capability sources passed `mblack --check`, full-environment `mojo format`, and `mojo build --Werror -D ASSERT=all`. Two cache-cleared builds of each probe were byte-identical. The exact-arithmetic capability binary SHA-256 was:

```text
27ee01bd54d2929236eacfb5d7d388830ca7a4a66ed7b9898cc35703d769e9ea
```

Final direct linkage included `libKGENCompilerRTShared.dylib` and `libSystem.B.dylib`. A pre-final supporting dynamic-loader inventory also observed `libMSupportGlobals.dylib` and `libAsyncRTRuntimeGlobals.dylib`; it is not a final-binary inventory. These MAX runtime libraries belong to the qualified compiler environment, are not project semantic implementations, and must not be redistributed.

## Remaining implementation obligations

No Mojo parser, checker, conformance serializer, fixture corpus, or authoritative finalizer exists. A separately authorized implementation must still cover malformed encodings, failure ordering, all schema capacities, original-byte parsing, deterministic record serialization, and independent Rust/Mojo comparison while preserving Lean-only authority.
