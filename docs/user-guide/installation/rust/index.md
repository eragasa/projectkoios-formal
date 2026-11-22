# Rust installation and qualification

Rust is a mandatory but non-authoritative conformance route for exact-direct-matrix v2. On 2026-11-08, Rust 1.99.1 was installed in an isolated local prefix and passed the bounded Gate 0 capability suite. This qualification does not authorize checker implementation, repository dependency addition, commit, release, or evidence promotion.

## Qualified toolchain

| Item | Qualified identity |
|---|---|
| Rust | `rustc 1.99.1` |
| Cargo | `cargo 1.99.1` |
| Host/target | `aarch64-apple-darwin` |
| Manifest date | 2026-10-15 |
| Standalone `.tar.xz` SHA-256 | `30976378b6aaefd1861ba475905c6ba22a44c981418ce52285006af26337f98c` |

The checksum-pinned standalone archive was installed outside system and repository paths. The qualified prefix contains `rustc`, Cargo, rustfmt, Clippy, and the ARM64 macOS standard library. Installed executable hashes and direct linkage are retained externally.

The earlier 106-byte smart-fetch cache entry with SHA-256 `a6e37b75bf6b40c61a1f4f667ac856272bf9d7ba0399ddb5c825d1c29d58e056` is not a Rust archive and remains rejected.

## Exact Cargo graph

Direct semantic dependencies are:

| Crate | Version | Role | Crate archive SHA-256 |
|---|---:|---|---|
| `num-bigint` | 0.4.8 | arbitrary-precision signed integers | `c89e69e7e0f03bea5ef08013795c25018e101932225a656383bd384495ecc367` |
| `num-rational` | 0.4.2 | normalized exact rationals | `f83d14da390562dca69fc84082e73e548e1ad308d24accdedd2720017cb37824` |
| `num-traits` | 0.2.19 | bounded numeric traits | `071dfc062690e90b734c0b2273ce72ad0ffa95f0c74596bc250dcfd960262841` |
| `sha2` | 0.11.1 | SHA-256 | `47d7069beb7d6ac7b9acd1039986e73443f24234f41074da099d6f994ac9ad19` |
| `hex` | 0.4.3 | lowercase digest encoding | `7f24254aa9a54b5c858eaee2f5bccdb46aaf0e486a595ed5fd8f86ba55232a70` |

The exact lock SHA-256 is:

```text
71686f35deb043ceb0304ac27d2eb29c65c130112f2a796201d9797910ba0524
```

Cargo resolved 16 packages total—one local probe package and 15 external crates. Every archive checksum matched the lock. The graph was vendored and built offline with explicit minimum direct features.

The retained audit records:

- MIT, Apache-2.0, or dual MIT/Apache-2.0 license identities and license-file hashes;
- complete normal/build/target feature trees;
- dependency role disposition;
- build scripts (`libc/build.rs` and `num-traits/build.rs`);
- native-source/archive/shared-library absence; and
- unsafe/FFI occurrence counts for review, not as proof of safety.

A lockfile is still a resolution record, not proof of source authenticity, correctness, or suitability. Adding this graph to the repository remains separately protected.

## Qualified commands and results

The probe passed:

```text
cargo fmt -- --check
cargo clippy --offline --locked --all-targets --all-features -- -D warnings
cargo test --offline --locked --all-targets --all-features
cargo build --offline --locked --release
```

Exact working directories, environment variables, tool paths, and expected outputs are frozen in the external Gate 0 command registry.

Two clean release builds in distinct target directories were byte-identical. The final bounded-reader probe binary SHA-256 was:

```text
bc9e46a3585c8b9d5ea2280e3fe05a35f15f500cea1819efc57ab23386a6fd8b
```

Its direct dynamic linkage was limited to:

```text
/usr/lib/libSystem.B.dylib
/usr/lib/libiconv.2.dylib
```

## Capability results

The Rust route passed:

- chunked arbitrary-byte reads, short final read, zero-length EOF, and post-EOF zero read;
- exact 2 MiB acceptance and 2 MiB plus one byte refusal before extending retained storage;
- SHA-256 empty, `abc`, one-million-`a`, padding-boundary, and all-octet vectors;
- signed arbitrary-precision integer and normalized rational arithmetic;
- exact rational-complex equality, conjugation, and multiplication;
- one-MiB integer magnitude and rational arithmetic;
- checked fixed-width overflow;
- exact row-major six-operation schedules at `n = 1` and `n = 16`, with counts 6 and 1,536; and
- deterministic release output.

The 2 MiB all-octet fixture digest was:

```text
91d3beb88a9b2f778a6c44a1c53b63d3c79931845a9aef84b3fb414610bd1938
```

## Remaining implementation obligations

No Rust parser, checker, conformance serializer, fixture corpus, or Lean finalizer exists. A separately authorized implementation must still demonstrate all malformed and noncanonical encoding rejections, schema failure precedence, size arithmetic before allocation, every v2 capacity, deterministic conformance-record serialization, and independent comparison with Mojo.

Rust emits a conformance record only. It does not execute or replace the Lean theorem and cannot authenticate runtime origin or establish scientific adequacy.
