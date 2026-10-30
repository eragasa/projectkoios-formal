# Owner-source audit

This ledger records immutable source identities, locators, byte hashes, and dirty-state limits. It does not transfer source ownership or proof status.

## Final inspected identity

The final inspection resolved one clean immutable source revision.

- Owner repository: `ksdft2effmass`
- Branch: `work/paper-3-higher-rank-extension`
- Commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Final worktree status: clean.
- Identity basis: local branch, immutable commit, and cited-byte hashes; upstream tracking is irrelevant.
- Access: read-only; no owner file, index, branch, worktree, or configuration was changed.

Source directories use lowercase paper suffixes; Lean placeholders use uppercase A/B/C. Inspection began at `593cfca64b19b34fc37f450a38419d1cf6e67a15` with relevant uncommitted changes. Another process integrated those bytes, so identity and status were re-resolved. A later unrelated protocol path briefly appeared and disappeared; cited publication paths remained clean. The final cited files are clean bytes at `99a46c…`, and no concurrent change is attributed to this audit.

## Later attribution reinspection

A later read-only inspection for `BG-PLAN-001` found the same branch and HEAD, but both `Ragasa2026c/v1/manuscript.md` and `manuscript.tex` had new unstaged changes. Only the committed revision is used by the statement-selection packet. The later dirty attribution wording is neither copied nor treated as owner-approved evidence here.

This later observation does not retroactively change the worktree state recorded during the original audit. It records a new dirty-state limitation for subsequent source use.

## Inspected files and final-byte SHA-256

These hashes bind the exact publication bytes.

| SHA-256 | Owner-repository path |
|---|---|
| `c8e71adaf9aa9194b65ebb2b610479265befb9356e07a5587bf886a2ba1652f8` | `docs/publications/papers/Ragasa2026a/v3/README.md` |
| `65d838e09fcaf9bb97a16d43fd3a751cf875c974e57c61e9144ed1d1825d0f24` | `docs/publications/papers/Ragasa2026a/v3/claim-and-commitment-inventory.md` |
| `2565cf464adb9da72061cad9a3e42d94834e22455bdce7fbba2cf6452572e340` | `docs/publications/papers/Ragasa2026a/v3/manuscript.tex` |
| `b993c8f35249a3decedd0039f956c15a24ca7ffe11ada0dbb821ece435bb6b42` | `docs/publications/papers/Ragasa2026a/v3/supplementary.tex` |
| `b12ac427ac2e0322e4d5362ee5bd70bec3ea427802f5e3d0dd2156bc0852665b` | `docs/publications/papers/Ragasa2026b/v2/README.md` |
| `d8d5951d8d7ed75355b5d94f37fcbddc70c1466897a5770dbe9f877e60016daf` | `docs/publications/papers/Ragasa2026b/v2/manuscript.tex` |
| `f2fa27a11936a470130022ba8bdf76fdd6b2e22d9323d13a005c31f9888ddd93` | `docs/publications/papers/Ragasa2026c/v1/README.md` |
| `153992c3567c40c18d48e52897280be49cf4e0b8c2efac562dc0e96a092cabad` | `docs/publications/papers/Ragasa2026c/v1/manuscript.md` |
| `b76cd37c244a0d2ec023fa37449b3e65bd9ae16255917858811be784603e9e0d` | `docs/publications/papers/Ragasa2026c/v1/appendices/A-1-extracted-evidence-boundary.md` |
| `40b4658e2a074fcb75431d10642f689caf54b5671f4d03d793aaadc7c4ded8f2` | `docs/publications/papers/Ragasa2026c/v1/appendices/A-2-d1-p0-g0-isolation-gap-certificate.tex` |

Hashes identify inspected bytes; they do not transfer ownership or evidence into this repository.

## Later Paper 3 protocol planning inspection

A later read-only planning inspection used a different immutable owner revision:

- owner repository: `ksdft2effmass`;
- branch: `work/paper-3-d1-calculator`;
- commit: `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`;
- protocol path: `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex`;
- protocol SHA-256 at that commit: `160b61b2c2dc87e7628524c710c779f8e3b2c547f0a2d228615300aa06bdce0b`;
- sibling README SHA-256 at that commit: `bf6693582c805aab485b5d3f17b55a6142f8e7adb4a4f7fb8eadb5ff365756dd`.

The worktree was dirty during this inspection: the protocol and sibling README had
uncommitted science-only edits, while the inspected Python implementation matched the
immutable commit. The immutable committed protocol was therefore used for planning. This
later inspection does not replace the publication-source identity or cited-byte hashes
recorded above, and it does not transfer development calculator output into retained
publication evidence.

## Periodic1D Architecture v3 centered-even convention inspection

The abstract centered-even finite-mode module was selected after a read-only inspection of the
exact KSD PR #80 merge tree:

- owner repository: `ksdft2effmass`;
- merged topic branch: `work/v3-component-coherence`;
- topic head: `30c548906595fffc137a2fd8e5c9a7b3e2d7446d`;
- merge commit: `d8e7d1db3eaf16332e691427fb9d5949325badd6`;
- merge tree: `23e6b97f3eddb074ab190f2576a4c2fff24e29f6`;
- access mode: read-only `git show` export of the merge tree into
  `/tmp/ksdft2effmass-phase4-d8e7d1d`;
- dirty-state limitation: the ordinary local KSD checkout was at another revision with 112
  short-status entries and was not used as byte authority or modified.

| SHA-256 at the PR #80 merge tree | Owner-repository path | Inspection use |
|---|---|---|
| `8f7244046d772716ed7f5c60022385c2c7b9a99d841489971a00783ae2bcaf7e` | `python/src/ksdft2effmass/solidstate/hopping_transforms.py` | centered-even FFT indexing, centered-origin factor, and negative-Nyquist deletion context |
| `dd1fc629ad538f00a54f1ddd7ca2ab38ba2795402a9c8fd30fbb2d9ae7f8f51c` | `python/src/ksdft2effmass/solidstate/reciprocal_paths.py` | owner-declared half-open centered coordinate convention; not an exact runtime-value binding |
| `30c3e69db41fa771e69558176b9286db63438a61014b20fc90c076b6a56388ca` | `calculations/periodic1d/rank1/fourier-locality/protocol.md` | rank-one construction/evaluation and conversion-versus-truncation boundary |
| `3d34c9a7aa09b4eba04ed45b1a14dbdb9d4329bb701b2d8236b3a3e310c47da8` | `calculations/periodic1d/rank2/composite-band-alignment-locality/protocol.md` | rank-two centered-even and residual-channel context |
| `72cc76242ec8c983edcf49ce60ea494e6c0ed63cee62bbfc766686075b428baf` | `docs/architecture/v3/ksdft2effmass/periodic1d/formal.md` | Formal/KSD ownership and future certificate boundary |

The resulting Lean declarations are source-neutral exact finite algebra. They do not identify
NumPy `fft`, `fftshift`, the centered-origin factor, binary64 coefficient arrays, runtime frames,
serialized bytes, retained results, or KSD certificate payloads with the abstract coefficient
function. The negative-Nyquist operation is formalized as a singleton deletion whose missing
reconstruction term is explicit. Its normalized removed-block power is distinct from both
off-mesh reconstruction error and later ordinary support-truncation tails. The current runtime
checked-certificate count remains zero.

## KSD 2-D/3-D complete metric-shell protocol inspection

The complete metric-shell module was selected after a read-only immutable-tree inspection of the
current KSD 2-D/3-D protocol family:

- owner repository: `ksdft2effmass`;
- inspected branch: `work/periodic23-band-equivalence-artifact-ownership`;
- immutable commit: `fcfc4d5fa76b08c040a02c97a109eb5f5fc06e48`;
- immutable tree: `fe8b47b33fcf0b24c5b28f8799ed220e3f6d7d20`;
- access mode: read-only `git show` exports into `/tmp/ksd-metric-shell-fcfc4d5f`;
- dirty-state limitation: the ordinary worktree contained 169 status entries from an active
  uncommitted ownership migration, including modified and deleted calculation-workflow files, so
  working-tree bytes were not used as authority and no owner file, index, branch, or configuration
  was changed.

| SHA-256 at `fcfc4d5f…` | Owner-repository path | Inspection use |
|---|---|---|
| `fbf444cb4d485e09db63df6a27e6b3e8e6c7fdaac54cdfba04fa16ad06ccda69` | `experiments/model-adequacy/periodic2d/band-equivalence-versus-hopping-locality/experimental-protocol.tex` | square signed-permutation orbits, squared radius, equal-radius shell retention, and no-skipped-support requirement |
| `2f730d6db77a0f7f4fe64e1b3c95c31a9aea8ed02fa1885f82660adc96f5f0c3` | `experiments/model-adequacy/periodic3d/band-equivalence-versus-hopping-locality/experimental-protocol.tex` | cubic signed-permutation orbits, block-count cost, nesting, and no-skipped-support requirement |
| `819ba806b9ff193b1c88a6e5ea5619c78d17589cd18ebc5980b4e874a746a736` | `experiments/model-adequacy/periodic2d_nonorthog/band-equivalence-versus-hopping-locality/experimental-protocol.tex` | triangular metric index `R₁²+R₁R₂+R₂²` and metric-preserving orbit requirement |
| `cb9a26fce5729e6922c034e7673a1426b4d9cd086abcd4d7a92ce3088f880ad1` | `experiments/model-adequacy/periodic3d_nonorthog/band-equivalence-versus-hopping-locality/experimental-protocol.tex` | normalized FCC index `R₁²+R₂²+R₃²+R₁R₂+R₁R₃+R₂R₃` and metric-preserving orbit requirement |
| `498c0d9ec3477055f2807dd9f48057352de1a4646ecd0c74cde4d0e3804c951e` | `experiments/model-adequacy/band-equivalence-dimensional-comparison/comparison-protocol.md` | complete-shell consumption and discrete shell--scale decision boundary |

The Lean module proves source-neutral finite support mathematics. It does not identify a KSD
serialized inventory with the declared `Finset`, admit an external point group, prove runtime orbit
coverage, convert a metric shell to a source-defined hopping range, authenticate block counts, or
establish numerical convergence, scientific acceptance, or material validity. The formula
specializations use dimensionless reduced integer coordinates and do not encode lattice constants,
units, basis connectivity, or calculated output.

## Harmonic-oscillator computational crosswalk inspection

The harmonic-oscillator modules are source-neutral exact mathematics. Their computational
crosswalk was selected after a read-only inspection of the clean local owner worktree:

- owner repository: `ksdft2effmass`;
- branch: `work/source-package-ownership-cleanup`;
- commit: `2229777163882c3452b950b8b21db86c7ea43511`;
- dirty state at inspection: clean;
- access mode: read-only; no owner-repository bytes, index, branch, or configuration were changed.

| SHA-256 | Owner-repository path | Crosswalk use |
|---|---|---|
| `d8558ec63f7f05335e28f3f982ed700fd54c88aae6c65aaa77862049d97ba745` | `python/src/ksdft2effmass/operators/ladder_operators.py` | finite ladder convention |
| `d8782535073b1b0bdbe7abdc2bee230c985472a881be911eca1a50bd99c2f33c` | `python/src/ksdft2effmass/operators/finite_differences.py` | centered finite-difference convention |
| `b75d07a13b617adde68a43cd7f83ae5d1092df5ccdc55ff37782003cc4b4f998` | `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/model.py` | dimensionless QHO/Hermite formulas |
| `ce9a4242285d4734431287299791b00d471f95ae37a9226f539d661f53c6b697` | `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/comparison.py` | finite comparison and pullback context |
| `1ad7a6fc021f7ebbd16ca8487e782e513f31afb677ee7a01fe4f3a41c059f4c7` | `calculations/research-monograph/harmonic-oscillator/protocol.md` | retained calculation protocol context |
| `77f2875ae663871074e18ea2bc8f8ed43541f30484d2cfe84d30b3cb6d184da1` | `calculations/research-monograph/harmonic-oscillator/report.md` | retained numerical-result context only |
| `5ccc6491881072dfa95943ebe479157b84315357dad17220f87894bf495be120` | `calculations/research-monograph/harmonic-oscillator/SHA256SUMS` | retained-evidence manifest context only |

The Lean declarations do not copy or validate the owner repository's generated artifacts,
SciPy execution, binary64 values, array serialization, or retained result. The formal
parameter `K` denotes the highest retained number-state index and therefore a dimension
of `K + 1`; an owner API that accepts a retained dimension `N` corresponds to `K = N - 1`
when `N > 0`.

Mathlib's `Polynomial.hermite` was inspected and is the probabilists' convention. The
formalization therefore defines the physicists' recurrence directly rather than silently
identifying the conventions. This is a convention choice, not a claim of source-text
fidelity to a physics reference. No governed textbook source has yet been admitted for
normalization, orthogonality, completeness, self-adjointness, or spectral completeness.

## PIAB1D computational crosswalk inspection

The PIAB1D formalization was prepared from source-neutral exact algebra after a read-only
inspection of an actively restructured owner worktree:

- owner repository: `ksdft2effmass`;
- branch: `work/source-package-ownership-cleanup`;
- base commit: `2229777163882c3452b950b8b21db86c7ea43511`;
- dirty-state limitation: 172 status entries were present at inspection; the canonical
  `calculations/piab1d/`, `model_systems/piab1d/`, and `analysis/operators/` ownership changes were
  uncommitted and therefore are not immutable owner evidence;
- access mode: read-only from this formal worktree; no owner bytes, index, branch, or configuration
  were changed by the formalization task.

| SHA-256 of inspected dirty-worktree bytes | Owner-repository path | Crosswalk use |
|---|---|---|
| `2038fa182a6618d759cd20ef09dd54003fb7336bad4c435a8aa9d423e7a3f68d` | `python/src/ksdft2effmass/model_systems/piab1d/model.py` | finite analytical and difference conventions |
| `7b4fd044c0e90c9527220da9df89c71305f68dded2085e37ba586b4b1ba30e57` | `python/src/ksdft2effmass/model_systems/piab1d/evaluation.py` | represented grid-evaluation context |
| `c57314766cd79c43dd80385f0c20ca42a5eac914dc41999bf99b06e46ace448c` | `python/src/ksdft2effmass/analysis/operators/compression_residuals.py` | compression-residual semantics |
| `4d8e9810d392f62d0d64a412a4dede6f96be61743b5548b629ff916d84a5ffac` | `python/src/ksdft2effmass/analysis/operators/eigenpair_diagnostics.py` | exact-residual versus numerical-diagnostic boundary |
| `14eeb46747ca4d458d143063726f948634598a7a4ef1f33c62b8bc5c48edd36c` | `python/src/ksdft2effmass/analysis/operators/decomposition_identifiability.py` | additive decomposition semantics |
| `3e566d523fb8daccce414242e4b0f51596e74bcdfac011a14482cf534d627ada` | `python/src/ksdft2effmass/analysis/operators/model_fitting.py` | declared finite model classes and Frobenius loss |
| `85dd2b11225278194aedce6346cfb93ec6358e0c5df8a4009ff0567bb0b833ed` | `calculations/piab1d/input.json` | illustrative calculation parameters only |
| `fdc708803ccb2f3eb44ab9d5c4b3608fb49ce5b00177e219669d9666df5703db` | `calculations/piab1d/protocol.md` | interpretation and authority boundaries |

These hashes fingerprint the dirty bytes that were inspected, but they do not make those bytes
recoverable, immutable, or independently reproducible and do not upgrade them to source authority.
The Lean theorems do not accept the retained JSON, binary64 arrays, eigensolver
output, observed convergence orders, or plots. The exponential, scalar-twisted/PBC, and
odd-extension layers are deliberately more general than the current PIAB1D calculation. They prove
source-neutral finite real-space boundary algebra; they are not inferred from the dirty runtime
implementation. A later reviewed theorem may connect scalar translation characters to reciprocal-
fiber Bloch sewing, but no such identification or Bloch--Floquet theorem is claimed here.

## Symbolic finite-barrier scope

The constant-region and finite-barrier modules are source-neutral exact lattice algebra. They were
not copied from, and are not presented as validation of, a retained owner-repository barrier
calculation. Their potential values, energy, character roots, amplitudes, and natural-number
barrier width remain universally quantified. The exact transfer result propagates a supplied global
lattice state whose recurrence holds at every barrier site. The matching layer represents symbolic
lead amplitudes as interface states and proves coordinate existence/uniqueness away from coincident
reciprocal roots. It does not solve the constrained left-incident reflection/transmission system,
attach flux probabilities, compute numerical transmission or reflection, establish continuum
convergence, or prove a finite-barrier-to-Dirichlet limit. Any publication attribution or numerical
binding requires a separate immutable source and crosswalk review.
## PhysKit FCC--Bain coordinate-bridge inspection

The authorized exact source crosswalk for `FccBainCoordinateBridge3D` used:

- owner repository: `projectkoios-physkit`;
- local checkout: `/Users/eugene/repos/physkit`;
- branch observed during inspection: `main`;
- immutable commit: `7157dcedd0d220673d443c1c025e35a6fd1ffa7a`;
- immutable tree: `49889a01edcee57742efca568ef4ee68c9dd2bfa`;
- access mode: read-only `git show` for every cited byte.

The owner worktree was dirty during inspection because unrelated finite-periodic cleanup
was in progress. Those changes were neither inspected as source authority nor modified.
The fixed FCC--Bain files cited below were read from the immutable commit:

| SHA-256 | Owner-repository path |
|---|---|
| `8bc4e9f0c957899a9b9c14ab75ece4aa8c82945ecb6524f0c1ecbb10067b8072` | `src/python/projectkoios/physkit/periodic/lattice/bain/bridge.py` |
| `c27ee93a3bc5bb162355cce0233a7003e5e5a44423d29b4076eccab604946090` | `docs/architecture/projectkoios/physkit/periodic/lattice/bain/bridge/FccBainCoordinateBridge3D/index.md` |
| `ec1b633163e26682ddbc6d9ed48f78ca0015593913427480ba3034f90166f1c8` | `tests/projectkoios/physkit/periodic/lattice/bain/bridge/test__FccBainCoordinateBridge3D__contract.py` |

The Lean crosswalk copies only the two fixed integer matrices and proves their exact
algebraic consequences over `ℤ` and `ZMod n`. It does not import PhysKit, verify a live
Python object, prove signed-64-bit batch execution free of overflow, establish that an
external lattice uses the declared bases, or validate a crystallographic or physical
interpretation.
## Calculation-support and finite-folding inspection

A later read-only calculation inventory and finite-folding crosswalk used another immutable
owner revision:

- owner repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-source-package-ownership-cleanup`;
- branch: `work/source-package-ownership-cleanup`;
- commit: `25161d7f55c708a464c18ea8d5d0fd6152ff86a6`;
- whole-worktree status count at inventory inspection: 645 entries;
- `calculations/` status count at inventory inspection: 34 entries; and
- access mode: read-only.

| SHA-256 | Owner-repository path at `25161d7f…` |
|---|---|
| `85c20bcacfe46e5e844abfb2b493ef2e178f50e36640a1a00bc2bdedb6ee44ff` | `calculations/research-monograph/impurity-defect-1d/protocol.md` |
| `e6dafe3ad7de7cc876b640df2535adab4d26e888d95bcc40c1b7d2a8be5c8760` | `calculations/research-monograph/impurity-defect-1d-independent-route/protocol.md` |

These sources motivate only the abstract finite block-folding and route-commutativity signatures.
The Lean declarations do not bind their Python arrays, floating-point Fourier matrices, twist
representatives, finite-size sequences, observables, tolerances, or retained evidence.
## Tetrahedral `sp³s⋆` algebra inspection

A separate read-only inspection supplied the exact algebraic conventions for the
publication-independent solid-state modules:

- scientific source: P. Vogl, H. P. Hjalmarson, and J. D. Dow, “A semi-empirical
  tight-binding theory of the electronic structure of semiconductors,” *Journal of
  Physics and Chemistry of Solids* 44 (1983), DOI
  `10.1016/0022-3697(83)90064-1`;
- inspected PDF SHA-256:
  `3bee3702162b8d2a60543cdbfbb7ff188770b69e2af104f998ef68ba472e7c39`;
- calculation owner repository: `ksdft2effmass`;
- inspected worktree branch: `work/source-package-ownership-cleanup`;
- inspected `HEAD`: `daf3e3fa175955babbe7cca0530412bc6700d6f4`;
- dirty-state limitation: the worktree had 639 short-status entries at the final identity
  check, and every calculation path listed below was untracked; therefore the path and
  byte hash, not `HEAD`, identify each inspected calculation-owned source byte sequence;
- access mode for this formalization task: read-only; no KSD file, index, branch,
  configuration, or generated result was changed.

| SHA-256 | Calculation-owner path |
|---|---|
| `fd7fb8eeeed4b223423fca53e8fcc2c215c0bd20937650da04c04b83ab764214` | `calculations/Si/bulk/technical-report/technical-report.tex` |
| `c3bd48418573c98b37efc7e6a405b46ba733cf1c166fb60d9beb3377aa91c356` | `calculations/Si/bulk/analysis/controls/vogl-sp3s-star/vogl1983_lcao_sp3sstar/model.py` |
| `77d1766661d76778239a13e45e701c892c2ee4db0f74c43fb21df292da60ef27` | `calculations/Si/bulk/analysis/controls/vogl-sp3s-star/table1.json` |
| `839caed7cd4c499173719d3950ab7d3636418de84f622b84f5fef233f75f25ef` | `calculations/Si/bulk/analysis/controls/vogl-sp3s-star/source-audit.md` |

The Lean declarations independently encode the published finite algebra: the normalized
Hadamard transform, its `s⋆` identity extension, tetrahedral bond phases, the four
structure-factor combinations, 13 abstract real parameter slots, the published hopping
pattern, and Hermitian block assembly. They do not copy Gist or notebook source code.
The accepted Table 1 JSON is recorded above only to delimit the nearby computational
context: none of its 208 values is embedded or certified by the current Lean modules.
No numerical eigenspectrum, Python execution, DFT/Wannier output, parameter accuracy,
material adequacy, novelty, or publication conclusion is transferred into Formal.

## Rank-one analytical-oracle inspection

The finite rank-one resolvent module was motivated by a later read-only inspection of a clean
calculation subdirectory inside an otherwise dirty owner worktree:

- owner repository: `ksdft2effmass`;
- checkout: `/Users/eugene/repos/ksdft2effmass`;
- branch: `work/monograph-current-library-capabilities`;
- immutable commit: `4835e7bf9161729cc8f0537bcc13db083896a6ae`;
- whole-worktree dirty-state limitation: 112 short-status entries at inspection;
- scoped status: no dirty entry under
  `calculations/research-monograph/impurity-defect-1d-analytical-oracle/`; and
- access mode: read-only; no owner file, index, branch, worktree, or configuration was changed.

| SHA-256 | Owner-repository path at `4835e7b…` |
|---|---|
| `55b8d2533541ea5b24fc2abc7a909f5b417eb815112f0ec6e150ed9a92edf339` | `calculations/research-monograph/impurity-defect-1d-analytical-oracle/protocol.md` |
| `a4281b2bd95ced8b642cc6115f99decd6b599d29f611144a83cb20c4ee943ce3` | `calculations/research-monograph/impurity-defect-1d-analytical-oracle/README.md` |
| `bebc93e8609e7f63aaff81fb5556119756f54d8238f1aeeb1654fccf323a5e93` | `calculations/research-monograph/impurity-defect-1d-analytical-oracle/analytical_oracle_calculation/run_experiment.py` |

The inspected source uses the attractive update `V_g = -g |v⟩⟨v|`, the scalar equation
`1 - g⟨v|(H₀-EI)⁻¹|v⟩ = 0`, and a vector reconstructed by applying that finite resolvent to `v`.
The Lean module proves the reusable conditional finite-matrix algebra behind those expressions. It
does not copy or bind the source matrix, vector, energy interval, coupling, root, bisection logic,
floating-point tolerances, normalization, eigenvalue output, serialized artifacts, or plots. It
also does not prove existence or uniqueness of a secular root, monotonicity, a bound-state count,
an infinite-volume statement, or physical applicability.

## Finite periodic gauge-loop inspection

The finite gauge-loop module was motivated by a read-only inspection of immutable periodic
protocols and a later immutable Wilson-loop utility:

- owner repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-source-package-ownership-cleanup`;
- branch observed at the later inspection: `work/source-package-ownership-cleanup`;
- later inspected commit: `cf36da4387062c4daad87e6a0d77bf336551be67`;
- later whole-worktree dirty-state limitation: 1,292 short-status entries;
- the two historical protocol paths were absent from that later checkout and commit, so their bytes
  were read with `git show` from immutable commit
  `25161d7f55c708a464c18ea8d5d0fd6152ff86a6`; and
- access mode: read-only; no owner file, index, branch, worktree, or configuration was changed.

| SHA-256 | Owner-repository path and immutable revision |
|---|---|
| `fa8d0fa13d8e6fc116622e8cd33205903b340f695cda411c75e89ac500fcd1a3` | `calculations/research-monograph/periodic-1d/protocol.md` at `25161d7f…` |
| `691b54662eedf510e67c059216cc1da6d92a6a349996491c7ce861e280e33df4` | `calculations/research-monograph/periodic-2d/protocol.md` at `25161d7f…` |
| `36bb668f0268ae8a93dc93021e9d141b2b42401c93cde657feef926d03272429` | `python/src/ksdft2effmass/solidstate/wilson_loops.py` at `cf36da4…` |

The protocols discuss overlap transport, reciprocal sewing, closed holonomy, gauge attacks, and
finite reciprocal-mesh diagnostics. The later utility compares supplied Wilson-loop eigenphase
spectra but does not construct overlap matrices, select loop orientation, infer gauge, unwrap
branches, or establish topology. The Lean gauge-loop module proves only reusable exact finite
cancellation, conjugation, Bargmann-product/phase invariance, and Wilson-determinant invariance.
The source-neutral projector crosswalk separately freezes an explicit start-plus-tail ordering,
proves Hermiticity and idempotence under an explicit unit-norm premise, and identifies the ordered
rank-one projector-product trace with the Bargmann product. These modules do not copy or bind
runtime arrays, infer normalization from floating-point data, execute the utility, validate
eigenphases, certify a mesh, establish Chern integrality or continuum topology, prove a Wannier
obstruction, execute Wannier90, or establish physical applicability.

## Complex-unitary right-Procrustes inspection

The exact right-action objective and polar-witness result were selected after a bounded literature,
consumer-contract, and pinned-Mathlib inspection.

### Mathematical source

- Nicholas J. Higham, *Functions of Matrices: Theory and Computation*, SIAM, 2008,
  ISBN `978-0-898716-46-7`, Chapter 8, Theorem 8.6;
- chapter DOI: `10.1137/1.9780898717778.ch8`;
- author-maintained book metadata:
  `https://nhigham.com/functions-of-matrices-theory-and-computation/`; and
- author-maintained explanatory background, “What is the Polar Decomposition?”, 2020-07-28:
  `https://nhigham.com/2020/07/28/what-is-the-polar-decomposition/`.

Higham's convention is adapted, not silently copied: the Formal objective is explicitly
`minimize ‖candidate * gauge - reference‖_F²` with a right-acting complex unitary and cross matrix
`candidateᴴ * reference`. The real special-orthogonal determinant constraint and generalized
metric/indefinite polar decompositions are outside this module.

### Consumer contracts

The `projectkoios-optimization` contract was inspected read-only at immutable commit
`ef608716ae9f515f56406dd517c1a8b7487d3391`. Its current exact source locators were:

| SHA-256 | Owner-repository path |
|---|---|
| `7f76acfef497f4b8e0f012705c1da4861458c7b6625c95463e496ee61c5e5dc5` | `src/python/projectkoios/optimization/alignment/procrustes.py` |
| `355681584b1bf81088dd664e17b4a2e039c1d96acb22d1740f3588c3e6d01411` | `src/python/projectkoios/optimization/alignment/numpy/procrustes.py` |

The KSD immutable dependency pin was
`7ac5376bcb97e29f6927dda4d4ef714ed2e32140`; the pinned optimization contract source had SHA-256
`ad08a703628d3742fb3ee8086acf2720a48fe8c94b58b0a2e4a1cb0c5dd118e7`. KSD was inspected
read-only at local commit `4835e7bf9161729cc8f0537bcc13db083896a6ae`, three commits ahead of remote
`5aaff25b784c7d1bc079a3030a73be387dc11a0f`, in an otherwise dirty worktree. The cited paths were
unmodified and were read from immutable `HEAD` blobs:

| SHA-256 | Owner-repository path |
|---|---|
| `e0deceebb75d84304eb02f80d1734afc0cd36be611dbd741d63298e96de33240` | `python/src/ksdft2effmass/solid_state/band_frames.py` |
| `3e5124fe785cfc75d5a2bb80030e6bccf9c4bcb82ed540de9c2a4e32b57400ea` | `python/src/ksdft2effmass/solid_state/frame_alignment.py` |

These consumers use ordinary complex-unitary right action and cross matrix
`candidate_frame.magnitude.conj().T @ reference_frame.magnitude`. No overlap metric, Gram metric,
metric-unitary constraint, or complex-oblique gauge contract was found in the audited paths.
Rank-deficient runtime policy deliberately withholds an arbitrary null-space unitary completion.

### Mathlib feasibility and authority boundary

The implementation uses Mathlib commit `56a005855ea17e0b0958f73ec801ae140b0a1679`: matrix
spectral decomposition, positive-semidefinite/positive-definite eigenvalue signs, cyclic trace
identities, the finite unitary group, and the scoped Frobenius norm. No ready-made polar-decomposition
declaration was found. Formal therefore accepts an exact factorization witness
`candidateᴴ * reference = minimizer * positiveFactor`; it does not claim unconditional construction
of that witness from an external matrix.

The Lean result authenticates no NumPy SVD, binary64 matrix, floating numerical rank, tolerance,
runtime orthonormality check, optimizer branch, null-space completion, serialization, retained
artifact, or certificate. A positive-semidefinite witness proves mathematical global minimality.
Uniqueness requires an explicit positive-definite factor and is not inferred in the rank-deficient
case. The checked runtime-certificate count remains zero.

### Finite-mesh extension

`ProjectKoios/BandGauge/Alignment/FiniteMeshProcrustes.lean` is a source-neutral exact extension of
the same selected objective, not a new external scientific claim. It sums the local squared
objectives with equal weight, accepts one exact polar witness at every finite mesh point, and proves
pointwise and summed minimality. Equality with the summed minimum forces field equality only when
every local positive factor is positive definite. The exact known-inverse theorem is conditional on
pointwise frame equality and is labeled as a control rather than universal ground truth.

The matrix-unitary bridge does not assume a direct matrix-to-isometry coercion. It maps the matrix
to a Euclidean continuous linear map, proves the two unitary identities using conjugate-transpose/
adjoint compatibility, and then applies Mathlib's unitary linear-isometry equivalence. The bridge
places identity, constant, and arbitrary matrix-unitary fields into the already declared identity,
global, and complete alignment families. It authenticates no external mesh, runtime polar factor,
SVD, numerical rank, tolerance, optimizer, or serialized evidence.
