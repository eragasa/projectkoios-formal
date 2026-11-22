# Platform baseline

The initial inventory was taken on 2026-11-04, the bounded Gate 0 probes completed on 2026-11-08, and missing command provenance was retained during the authorized correction pass. This baseline is host-specific and must be repeated for every retained implementation or release environment.

## Recorded host

| Item | Recorded value |
|---|---|
| Operating system | macOS 26.5.1, build `25F80` |
| Kernel | Darwin 25.5.0 |
| Machine | Apple M4, `Mac16,13` |
| Architecture | ARM64 / `arm64` |
| SDK | macOS 26.5 |
| C/C++ compiler | Apple clang 21.0.0 |
| Linker | `ld-1267` |
| Loader | `/usr/lib/dyld` |
| Base system library | `/usr/lib/libSystem.B.dylib` |
| Homebrew | 7.0.7 |

The platform passed the bounded Lean, Rust `aarch64-apple-darwin`, Mojo Apple-silicon, and Python support qualification. This is an environment-capability result, not runtime authentication, scientific validation, release qualification, or evidence promotion.

Retained dynamic-loader inventories include `/usr/lib/libSystem.B.dylib`, Rust's direct `/usr/lib/libiconv.2.dylib` dependency, and the MAX-licensed Mojo runtime dylibs. These unavoidable platform/runtime components are recorded trust inputs; they do not supply a shared Rust/Mojo semantic implementation.

## Repeatable inventory commands

The following commands were run for Gate 0. Rerun them only in an authorized qualification or release session and retain their complete output:

```sh
sw_vers
uname -a
uname -m
sysctl -n hw.model
system_profiler SPHardwareDataType
xcrun --show-sdk-version
xcrun --find clang
clang --version
ld -version_details
brew --version
```

For each retained executable:

```sh
file PATH_TO_EXECUTABLE
shasum -a 256 PATH_TO_EXECUTABLE
otool -L PATH_TO_EXECUTABLE
codesign -dvv PATH_TO_EXECUTABLE
```

Record the exact compiler target, deployment target, loader, and every dynamically linked library. Static linkage, where available, does not remove trust in the operating-system loader, kernel, compiler target, or runtime.

## Isolation requirements

- Use a dedicated, clean Formal worktree.
- Keep toolchains, wheelhouses, Cargo caches, compiler caches, and virtual environments outside tracked source paths.
- Never reuse Rust or Mojo semantic libraries across the two native routes.
- Treat generated build output as disposable and ignored.
- Record absolute toolchain roots and executable digests in retained qualification evidence; do not commit machine-local absolute paths into portable configuration.

The current dedicated planning worktree is:

```text
/Users/eugene/worktrees/projectkoios-formal-exact-direct-matrix-v2
```

At the time of the Gate 0 inventory it was detached and clean at commit `1c12934be61b3ebdc59a94b87822cb94c7951540`, tree `1d4309c12050a7d2517dd525b9ec6034d787dd6c`.
