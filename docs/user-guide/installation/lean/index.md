# Lean and Lake installation

Lean is the existing formal authority. The repository layout remains under `ProjectKoios/`; the planned polyglot pilot must not move Lean sources into a new `lean/src/` tree.

## Immutable repository pins

| Item | Pin |
|---|---|
| Lean toolchain | `leanprover/lean4:v4.36.0` |
| Lean commit reported locally | `611c117bfaf7b7ae1cfcf246ce6fba31e8f509e9` |
| Mathlib revision | `fc4f59e577feb1a4956671bc04ac18aaaf8cd842` |
| Physlib revision | `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd` |
| `lean-toolchain` SHA-256 | `582a63f8f9c5128067b688778c1051cf1464c3ca9d57b9325025c051c29b774a` |
| `lakefile.toml` SHA-256 | `b7cd33fa996f803dffae8d96218c8b5e4d71a511bc7487a697984f5208531298` |
| `lake-manifest.json` SHA-256 | `4854285512498c87dc59f0e4d675212f0afcb7b8b65eafc91fbf47a5bbd667c5` |

`lake-manifest.json` records the resolved transitive dependency revisions. It is a resolution record, not by itself proof that a remote, cache, checkout, or binary is authentic.

## Existing local inventory

The retained inventory and authorized correction pass reported:

```text
elan 4.2.3 (b6cec7e10 2026-06-08)
Lake version 5.0.0-src+611c117 (Lean version 4.36.0)
Lean 4.36.0, arm64-apple-darwin24.6.0, commit 611c117..., Release
```

The Lean binary's reported target baseline differs from the host kernel version and must be retained as toolchain identity rather than rewritten as the host target.

## Installation proposal

Installing or changing Elan or a Lean toolchain remains protected. In an authorized environment:

```sh
elan toolchain install leanprover/lean4:v4.36.0
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
