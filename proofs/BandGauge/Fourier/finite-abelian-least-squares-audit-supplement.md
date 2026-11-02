# Finite-abelian least-squares audit supplement

Status: historical pre-checkpoint working-tree audit record, 2026-11-03. This supplement supports
`BG-FOURIER-FINITE-THM-004` and `BG-FOURIER-FINITE-THM-005`. It records the exact Lean statements,
source identities, dependency pins, and commands used in the maintainer-side verification run. It
is not a publication certificate, an independent reproduction, or evidence about a numerical
runtime.

## 1. Repository and working-tree identity

- Repository: `projectkoios-formal`
- Remote: `https://github.com/eragasa/projectkoios-formal.git`
- Worktree: `/private/tmp/projectkoios-formal-finite-abelian-least-squares`
- Branch: `work/finite-abelian-least-squares`
- Base commit: `6b8c7ec767cae6348ee818e4495edda0e1fcbfe2`
- Base tree: `df11021c2965f7eb87a7ab3af65494498376ebfe`
- Base subject: `Merge pull request #57 from eragasa/work/gauge-support-radius`
- Base commit date: `2026-11-02T05:08:26+08:00`
- Later source checkpoint: `e6dffa247e7e01e600ecc5aa64f4ff164dc0f99e`
- Later integration checkpoint on the PR #58 base: `c5393e63e6d2918f2ce8f7691faa315b2d41d6fe`

At the pre-supplement inspection the least-squares milestone was not committed and had 16 dirty
status entries: 11 modified tracked files and 5 untracked files. Creation of this supplement added a
sixth untracked file. Therefore the base commit does **not** identify the revised theorem package;
the byte hashes below identify the audited working-tree sources. The later checkpoint identities
record subsequent repository history but do not retroactively turn this maintainer-side record into
an independent reproduction, publication certificate, runtime binding, or scientific validation.
No push, merge, release, or publication is asserted by this historical record.

## 2. Toolchain and immutable dependency lock

Observed commands and outputs:

```text
$ lean --version
Lean (version 4.35.0, arm64-apple-darwin24.6.0,
commit eb6cafb7290e8bd5f2937522d8d804f58f02bafc, Release)

$ lake --version
Lake version 5.0.0-src+eb6cafb (Lean version 4.35.0)
```

`lean-toolchain` contains:

```text
leanprover/lean4:v4.35.0
```

`lake-manifest.json` resolves every package to a commit ID:

| Package | Revision |
|---|---|
| `mathlib` | `56a005855ea17e0b0958f73ec801ae140b0a1679` |
| `plausible` | `dfa4f38190d07c37e315953e08b90fe2d95b3c24` |
| `LeanSearchClient` | `d6b4c7be5be75ec4917c873ac50c756dc1436372` |
| `importGraph` | `a41f0e9a4dea23188ea9cc1c41ac9f8bbafe0b93` |
| `proofwidgets` | `df72b022e558978a1c50264cfc4d7fec86fa8e04` |
| `aesop` | `4a174c490d8707121c4a9290800489f105d85e07` |
| `Qq` | `dce0ad79c486cb1fb504af04f953c3466b0c6db8` |
| `batteries` | `66e469188fe07963e5cf666c7d4433f45b8131c5` |
| `Cli` | `c24fe6078c630e89b489bffe59b3e20ac30d12c8` |

Build-file hashes:

| SHA-256 | Path |
|---|---|
| `ca5f1f601d34c49079e38d7e7041eb0f2a9c227fbc1df0f404820069a052330c` | `lean-toolchain` |
| `56ae2d336f7e52273fc28ab89ca23eca9aa2b06556464cd96f2f8ad8518c1018` | `lakefile.toml` |
| `3b189da2837c60b3458a3d1cff6a01d584c8d8e4ee5f46b7d71053510ef98ec9` | `lake-manifest.json` |

## 3. Key formal definitions

The following are the operative definitions, reproduced from the hashed Lean sources. `G` is a
finite additive commutative group, `AddChar G ℂ` is its complex character group, and `V` is the
coefficient carrier.

```lean
abbrev CoefficientField (Mode V : Type*) := Mode → V

def truncateCoefficients [Zero V] [DecidableEq Mode]
    (support : Finset Mode) (coefficients : CoefficientField Mode V) :
    CoefficientField Mode V :=
  fun mode => if mode ∈ support then coefficients mode else 0

def finiteCharacterPhase (momentum : G) (mode : AddChar G ℂ) : ℂ :=
  mode momentum

noncomputable def finiteFourierCoefficient [AddCommMonoid V] [Module ℂ V]
    (field : G → V) (mode : AddChar G ℂ) : V :=
  (Fintype.card G : ℂ)⁻¹ •
    ∑ momentum, conj (mode momentum) • field momentum

noncomputable def finiteFourierReconstruction [AddCommMonoid V] [Module ℂ V]
    (coefficients : AddChar G ℂ → V) (momentum : G) : V :=
  finiteReconstruction finiteCharacterPhase coefficients momentum

def finiteFourierPower [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V) : ℝ :=
  ∑ momentum, (inner ℂ (field momentum) (field momentum)).re

def CoefficientSupportedOn [Zero V]
    (support : Finset Mode) (coefficients : CoefficientField Mode V) : Prop :=
  ∀ mode, mode ∉ support → coefficients mode = 0
```

Thus the forward transform is normalized and conjugated, reconstruction is unnormalized with the
positive character, and power is an unnormalized finite sum. In this convention Parseval is:

```lean
theorem finiteFourier_parseval [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V) :
    finiteFourierPower field = (Fintype.card G : ℝ) *
      finiteFourierPower (finiteFourierCoefficient field)
```

This is the source of the single factor `|G|` in `BG-FOURIER-FINITE-THM-004`.

## 4. Complete milestone declarations

Namespace and variables:

```lean
namespace ProjectKoios.BandGauge.Fourier.FiniteAbelian

variable {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
```

### `BG-FOURIER-FINITE-LEM-003`

```lean
lemma truncateCoefficients_supportedOn
    [Zero V]
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → V) :
    CoefficientSupportedOn support
      (truncateCoefficients support coefficients)
```

### `BG-FOURIER-FINITE-LEM-004`

```lean
lemma finiteFourierPower_sub_supported_eq
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ))
    (coefficients candidate : AddChar G ℂ → V)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteFourierPower (fun mode => coefficients mode - candidate mode) =
      finiteFourierPower
          (fun mode => coefficients mode -
            truncateCoefficients support coefficients mode) +
        finiteFourierPower
          (fun mode => truncateCoefficients support coefficients mode -
            candidate mode)
```

### `BG-FOURIER-FINITE-THM-004`

```lean
theorem finiteFourierReconstruction_error_decomposition
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V)
    (support : Finset (AddChar G ℂ))
    (candidate : AddChar G ℂ → V)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteFourierPower
        (fun momentum => field momentum -
          finiteFourierReconstruction candidate momentum) =
      finiteFourierPower
          (fun momentum => field momentum - finiteFourierReconstruction
            (truncateCoefficients support
              (finiteFourierCoefficient field)) momentum) +
        (Fintype.card G : ℝ) * finiteFourierPower
          (fun mode => truncateCoefficients support
              (finiteFourierCoefficient field) mode - candidate mode)
```

### `BG-FOURIER-FINITE-THM-005`

```lean
theorem finiteFourierTruncation_leastSquares
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V)
    (support : Finset (AddChar G ℂ))
    (candidate : AddChar G ℂ → V)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction
          (truncateCoefficients support
            (finiteFourierCoefficient field)) momentum) ≤
      finiteFourierPower
        (fun momentum => field momentum -
          finiteFourierReconstruction candidate momentum) ∧
    (finiteFourierPower
        (fun momentum => field momentum -
          finiteFourierReconstruction candidate momentum) =
      finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction
          (truncateCoefficients support
            (finiteFourierCoefficient field)) momentum) ↔
      candidate =
        truncateCoefficients support (finiteFourierCoefficient field))
```

The finite group is nonempty because its group structure supplies an identity element. This is the
fact used to discharge `Fintype.card G ≠ 0` in the uniqueness proof; finiteness alone would not be
enough.

## 5. Source hashes

These hashes were recomputed after the referee-driven article edits and before this supplement was
created.

| SHA-256 | Path |
|---|---|
| `2f9f7fd8c9575d1592e2867946d84d3fb21b8ae8fcab91951b407b837b4cc5fb` | `ProjectKoios/BandGauge/Fourier/FiniteAbelian/LeastSquares.lean` |
| `bf6d001e8ff31b9006236af59a3c9767791e17a5353b7d582db92f29cc24bb6f` | `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Convolution.lean` |
| `030a5bbd3809508db2d51a0aa9832c64c5f17e09edd34670b7aca72d2b6ef8bb` | `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Parseval.lean` |
| `8196123872848140878a6b5b1fc9cad5faf495a57a0b6cabe7859de93b6a89b7` | `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Reconstruction.lean` |
| `b416b3304259237754f4b2bd25c1ab334b625d8e8500f32729af4d11ad197f21` | `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Transform.lean` |
| `b1e4cd7e5a66edccc07ff6e27310e0de1a6e457e9f8f15eb49af2ed93ffff673` | `ProjectKoios/Audit.lean` |
| `45b0347af2b25dfaa863616088a645601a3ea7a56b88d5be79322c535305df39` | `proofs/BandGauge/Fourier/BG-FOURIER-FINITE-THM-004-reconstruction-error-decomposition.tex` |
| `dbaea3f15a9dc2063b1b6adf8e64ec277c8fdd313ba9bc946fac933adb8a5b4a` | `proofs/BandGauge/Fourier/BG-FOURIER-FINITE-THM-005-truncation-least-squares.tex` |
| `25632937bfacc5e70398f721c157a39dfa5ab7a55724c4afd848c7569886f37b` | `proofs/BandGauge/Fourier/finite-abelian-least-squares.bib` |

A SHA-256 hash authenticates bytes only. It does not establish correctness, provenance of a
mathematical claim, interval containment, runtime execution, or scientific validity.

## 6. Reproduction commands and observed outputs

All commands below were run from the worktree root on 2026-11-03. The `.lake` cache was reused;
`lake update` was not run.

### Targeted Lean build

```text
$ lake build ProjectKoios.BandGauge.Fourier.FiniteAbelian.LeastSquares ProjectKoios.Audit
[ProjectKoios/Audit.lean emitted the expected #print axioms reports]
Build completed successfully (3880 jobs).
exit status: 0
```

This is an affected-target build, not a repository-wide release build.

### Admission audit

```text
$ ./scripts/audit.sh
audit passed: no admitted declaration markers in repository-owned Lean sources
exit status: 0
```

### Audit coverage

```text
$ ./scripts/check-audit-coverage.py
audit coverage check passed: 881 proved theorem/lemma rows; 885 unique named axiom reports
exit status: 0
```

### Dependency pins

```text
$ ./scripts/check-pins.py
pin check passed: mathlib=56a005855ea17e0b0958f73ec801ae140b0a1679; 9 resolved revisions are commit IDs
exit status: 0
```

### Whitespace check

```text
$ git diff --check
exit status: 0
```

The empty output before the exit status is the expected successful result.

## 7. Focused `#print axioms` evidence

The exact probe was:

```lean
import ProjectKoios.BandGauge.Fourier.FiniteAbelian.LeastSquares
#print axioms ProjectKoios.BandGauge.Fourier.FiniteAbelian.truncateCoefficients_supportedOn
#print axioms ProjectKoios.BandGauge.Fourier.FiniteAbelian.finiteFourierPower_sub_supported_eq
#print axioms ProjectKoios.BandGauge.Fourier.FiniteAbelian.finiteFourierReconstruction_error_decomposition
#print axioms ProjectKoios.BandGauge.Fourier.FiniteAbelian.finiteFourierTruncation_leastSquares
```

Running `lake env lean /tmp/LeastSquaresAxioms.lean` returned exit status 0 and reported, for each of
the four declarations:

```text
depends on axioms: [propext, Classical.choice, Quot.sound]
```

There are no repository-owned `axiom` declarations or `sorry` admissions in these results. The
reported dependencies are the accepted Lean/Mathlib logical dependencies; this dossier does not
claim axiom freedom.

## 8. Owner-source comparison boundary

The source-neutral theorem was motivated by read-only comparison with `ksdft2effmass` worktree
`/private/tmp/ksdft2effmass-periodic1d-rank1-first-pass-certificate`, branch
`work/periodic1d-rank1-first-pass-certificate`, at commit
`ca052e6571ea10dfbfc3f51be47ffdb08e5313d0` and tree
`447d0634ab6fa09782d50afa899f45e38c156809`. That worktree had 20 dirty-status entries; the cited
paths were clean at that commit.

| SHA-256 | Owner-repository path |
|---|---|
| `f350d69c246be13c3d31a81fa0983e34c036bb9f8839079d6db7587eab99e659` | `python/src/ksdft2effmass/analysis/hopping_fits.py` |
| `8f7244046d772716ed7f5c60022385c2c7b9a99d841489971a00783ae2bcaf7e` | `python/src/ksdft2effmass/solidstate/hopping_transforms.py` |
| `f93c074ab0e97c448cee02ba5ea955fe4c1c85373fea7b4cce67b66295ed15ce` | `python/src/ksdft2effmass/periodic1d/fourier_locality/analysis.py` |
| `f0040494d5b57062d9d9c974952f591f3b5d220c59a02d3cfe1c4d55d10c707c` | `calculations/periodic1d/rank1/fourier-locality/numerical-control-decision.md` |

The relation is `compares-with`, not `formalizes` or `validates`. The Lean declarations do not
identify runtime arrays with `G → V`; prove design-matrix rank or conditioning; authenticate NumPy,
SciPy, FFT, or binary64 execution; establish route agreement; certify a support threshold; or
validate a materials-science conclusion.

## 9. Review chronology and scope

1. **Initial independent technical review.** It confirmed the normalization, support split,
   minimality, uniqueness, evidence boundaries, audit registration, and owner-source branch/HEAD.
   It requested correction of the supporting declaration from theorem/`THM` to lemma/`LEM`, fuller
   dossier metadata, the finite-group nonemptiness wording, and stale inventory wording. Verdict:
   `CHANGES_REQUIRED` / merge `BLOCK`.
2. **Corrections and focused independent rereview.** The declaration classification and dossier
   metadata were corrected. The rereview found no remaining blocking issue and recorded
   `FindingDisposition: NO_ACTION_REQUIRED`, merge verdict `OK`, and
   `ReviewOutcome: NO_BLOCKING_FINDINGS`. It explicitly did not authorize commit, push,
   publication, release, evidence promotion, or scientific claims.
3. **Substantial article-style rewrite.** Both dossiers were later rewritten as computational
   materials mini-articles with full mathematics and integrated prior art. This rewrite postdated
   the focused technical rereview.
4. **Current referee-driven revision.** The articles were revised to add an explicit written
   Hilbert-valued inversion/Parseval argument, correct citation scope, define the vector-valued
   approximation space, state the exact decomposition in the least-squares theorem, distinguish
   finite-dimensional Bodmann applicability, and separate reported mechanization from independent
   reproduction. This supplement was created in response to the request for an independently
   auditable evidence record.

The current article revision and this supplement have **not yet received a new independent
rereview**. Maintainer-side command execution is reported above but must not be described as an
independent reproduction.

## 10. Evidence disposition

- Exact theorem status: proved in Lean under the displayed assumptions.
- Admissions: none in repository-owned Lean sources.
- Logical dependencies: `propext`, `Classical.choice`, and `Quot.sound`.
- Runtime-certificate status: not applicable; no runtime certificate is created or admitted.
- Numerical-validation status: not established.
- Scientific-applicability status: conditional on an owner-specific exact bridge.
- Novelty or priority: not claimed.
- Publication status: not established.
