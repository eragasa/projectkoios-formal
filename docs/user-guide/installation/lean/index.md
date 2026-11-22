# Lean and Lake installation

Lean is the existing formal authority. The repository layout remains under `ProjectKoios/`; the planned polyglot pilot must not move Lean sources into a new `lean/src/` tree.

## Immutable repository pins

| Item | Pin |
|---|---|
| Lean toolchain | `leanprover/lean4:v4.35.0` |
| Lean commit reported locally | `eb6cafb7290e8bd5f2937522d8d804f58f02bafc` |
| Mathlib revision | `56a005855ea17e0b0958f73ec801ae140b0a1679` |
| `lean-toolchain` SHA-256 | `ca5f1f601d34c49079e38d7e7041eb0f2a9c227fbc1df0f404820069a052330c` |
| `lakefile.toml` SHA-256 | `56ae2d336f7e52273fc28ab89ca23eca9aa2b06556464cd96f2f8ad8518c1018` |
| `lake-manifest.json` SHA-256 | `3b189da2837c60b3458a3d1cff6a01d584c8d8e4ee5f46b7d71053510ef98ec9` |

`lake-manifest.json` records the resolved transitive dependency revisions. It is a resolution record, not by itself proof that a remote, cache, checkout, or binary is authentic.

## Existing local inventory

The retained inventory and authorized correction pass reported:

```text
elan 4.2.3 (b6cec7e10 2026-06-08)
Lake version 5.0.0-src+eb6cafb (Lean version 4.35.0)
Lean 4.35.0, arm64-apple-darwin24.6.0, commit eb6cafb..., Release
```

The Lean binary's reported target baseline differs from the host kernel version and must be retained as toolchain identity rather than rewritten as the host target.

## Installation proposal

Installing or changing Elan or a Lean toolchain remains protected. In an authorized environment:

```sh
elan toolchain install leanprover/lean4:v4.35.0
lean --version
lake --version
```

First inspect `elan show` and remove any unrelated directory override only through a separately reviewed command; do not mutate an intentional user override blindly. Do not run `lake update` as an installation step: it can rewrite dependency resolution. Use the committed manifest and inspect it before fetching or building.

## Validation

From the repository root:

```sh
python3 scripts/check-pins.py
lake build
./scripts/audit.sh
git diff --check
git status --short
```

A valid qualification requires:

1. the selected Lean identity to match `lean-toolchain`;
2. every Lake dependency to resolve to the committed immutable revision;
3. a clean build;
4. the axiom and `sorry` audit to pass truthfully;
5. generated `.lake/build` state to remain ignored; and
6. no claim that Lean authenticated external runtime execution.

The last validated audit before this guide reported 1,086 proved theorem/lemma rows and 1,090 unique named axiom reports, with no admitted declaration markers. Re-run the audit rather than treating those counts as permanent.
