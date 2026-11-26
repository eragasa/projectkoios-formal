# Owner-repository and computational-contract source records

Read-only inspections of owner repositories, computational conventions, and implementation contracts. These records identify inspected sources and limitations; they do not transfer ownership, theorem status, scientific validity, or publication authority.

<a id="aud-src-007"></a>

## `AUD-SRC-007` — Periodic1D Architecture v3 centered-even convention inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-007` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-008"></a>

## `AUD-SRC-008` — KSD 2-D/3-D complete metric-shell protocol inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-008` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-009"></a>

## `AUD-SRC-009` — Rank-two unitary-conjugation band-invariance statement selection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-009` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Identity record | [`AUD-SRC-008`](#aud-src-008) |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The rank-two conjugation module uses the same immutable KSD inspection identity, access mode,
dirty-state limitation, and five file hashes recorded above. Its consumer-facing statement was
selected from these exact locators:

- orthogonal 2-D protocol, lines 70--85: momentum-dependent unitary similarity preserves band
  spectra, while locality and post-truncation representation cost can differ;
- orthogonal 3-D protocol, lines 69--82: the corresponding 3-D spectrum/locality and operator-versus-
  eigenvalue boundary;
- nonorthogonal 2-D protocol, lines 69--73: pointwise eigenvalues of rotated rank-two fields agree
  exactly while Fourier support can differ; and
- nonorthogonal 3-D protocol, lines 34--37: complete reference and rotated rank-two fields are
  pointwise unitarily equivalent before truncation.

The generic spectrum step is a thin specialization of Mathlib theorem
`Unitary.spectrum_star_left_conjugate` at pinned Mathlib commit
`56a005855ea17e0b0958f73ec801ae140b0a1679`, tree
`0db52fa68e6b0c5b917c22bc6383325391a00610`, file
`Mathlib/Algebra/Star/Unitary.lean`, lines 479--483, file SHA-256
`2048264165355c0466762359dbbd2429dc5f8580f092e97b7676cd1ea4f7aab3`.
Formal adds source-neutral rank-two scalar-plus-Pauli coordinate consequences and the pointwise
lower/upper-band-field corollary; it makes no priority claim for unitary spectral invariance.

The exact unitary and the equality identifying the conjugated matrix with supplied post-conjugation
Pauli coordinates are hypotheses. The module does not construct, parse, or authenticate a runtime
gauge, floating-point orthonormality test, eigensolver, ordered eigenvalue array, band tracker,
momentum mesh, Fourier inventory, external artifact, physical model, or acceptance decision.
Pointwise field equality on a supplied finite index type does not authenticate the external mesh
or establish continuum regularity or coverage.

<a id="aud-src-010"></a>

## `AUD-SRC-010` — Normalized product-torus factorization statement selection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-010` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Identity record | [`AUD-SRC-008`](#aud-src-008) |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The normalized product-torus module uses the same immutable KSD inspection identity, access mode,
dirty-state limitation, and orthogonal 2-D/3-D file hashes recorded above. The statement family was
selected from these exact locators:

- orthogonal 2-D protocol, lines 414--435: the constant-frame flat parent, uniform integration on
  `T²`, the asserted `J₀(a)²` comparator, and the explicit separation between that analytic
  comparator and finite-mesh evidence; and
- orthogonal 3-D protocol, lines 359--381: the constant-frame flat parent, the explicit assertion
  that uniform integration on `T³` factorizes, the asserted `J₀(2a/3)³` comparator, and the same
  analytic-versus-finite-mesh boundary.

The reusable integration step is a thin specialization of pinned Mathlib theorems
`MeasureTheory.integral_fintype_prod_eq_prod` and
`MeasureTheory.integral_fintype_prod_eq_pow` at Mathlib commit
`56a005855ea17e0b0958f73ec801ae140b0a1679`, tree
`0db52fa68e6b0c5b917c22bc6383325391a00610`, file
`Mathlib/MeasureTheory/Integral/Pi.lean`, lines 105--126, file SHA-256
`43c50a9d9a683b2050e145154410a7260c3dd84f3ec3010630cc6b90572afcd9`.
The unit-circle normalization is recorded in
`Mathlib/MeasureTheory/Integral/IntervalIntegral/Periodic.lean`, lines 230--236, file SHA-256
`9aea999167a463bbd43b9989cf51a5cf8e6e1cf09ec474b7bfd0c6c051a8dae5`.
No novelty or priority claim is made for finite-product Fubini factorization or normalized Haar
measure.

Formal fixes the carrier to a finite function type into Mathlib's `UnitAddCircle` and fixes the
measure to the finite product of its standard total-mass-one Haar measure. It proves the exact
factorization of supplied coordinate-separable complex fields and exponentials of supplied
coordinatewise additive complex phases, including square and cube corollaries. It deliberately
does not by itself identify either one-dimensional factor with `J₀`, identify KSD's half-open
reduced coordinates with `UnitAddCircle`, authenticate the external phase formula or amplitude
scaling, parse a runtime field, validate quadrature, compare a finite mesh to the integral,
establish convergence, or certify either KSD comparator. The current checked runtime-certificate
count remains zero.

<a id="aud-src-012"></a>

## `AUD-SRC-012` — Harmonic-oscillator computational crosswalk inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-012` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-013"></a>

## `AUD-SRC-013` — PIAB1D computational crosswalk inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-013` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-014"></a>

## `AUD-SRC-014` — Symbolic finite-barrier scope

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-014` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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
<a id="aud-src-015"></a>

## `AUD-SRC-015` — PhysKit FCC--Bain coordinate-bridge inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-015` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

### Periodic3D rank-N Bain quotient-admission request

A later read-only inspection recorded the consuming KSD context:

- repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-periodic23-rank2-ragasa-metric-extension`;
- branch: `work/periodic23-rank2-ragasa-metric-extension`;
- HEAD: `0bef3dc574648ac60e4014962da75077ded3b4b2`;
- tree: `d957c541e73f78a312107ddb62cf3eb9fff8514f`;
- whole-worktree status count when recorded: 124 entries; and
- access mode: read-only.

The directly relevant file,
`calculations/periodic3d_rankN_bain_path/geometry-common-state-space.md`, was untracked. Its
inspected working-byte SHA-256 was
`6b9c019b86b0a66d6581742e76d6ef6f6d21a8b50ce442ea366b59f58c45b9fd`. It states the already
immutable PhysKit matrix constants, calls for an independent finite-quotient proof, and keeps
unsupported mixed quotients unresolved. Because the file was untracked, the byte hash is only a
provisional locator and the bytes cannot be reconstructed from the recorded KSD commit. The exact
matrix authority remains the immutable PhysKit source above.

The new Formal result proves exact lattice preservation, quotient finiteness for positive diagonal
periods, cubic admission, the mixed condition `N₂ = N₃ ∧ N₁ ∣ N₂`, and quotient bijectivity after
both forward and inverse preservation proofs. It does not bind a runtime mesh, validate execution,
prove numerical convergence, or establish a scientific conclusion.

<a id="aud-src-016"></a>

## `AUD-SRC-016` — Calculation-support and finite-folding inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-016` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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
<a id="aud-src-017"></a>

## `AUD-SRC-017` — Tetrahedral `sp³s⋆` algebra inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-017` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-018"></a>

## `AUD-SRC-018` — Rank-one analytical-oracle inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-018` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-019"></a>

## `AUD-SRC-019` — Finite periodic gauge-loop inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-019` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

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

<a id="aud-src-021"></a>

## `AUD-SRC-021` — Finite Fourier least-squares motivation

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-021` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The source-neutral finite-abelian least-squares milestone was selected after a read-only inspection
of `ksdft2effmass` worktree
`/private/tmp/ksdft2effmass-periodic1d-rank1-first-pass-certificate`, branch
`work/periodic1d-rank1-first-pass-certificate`, at immutable commit
`ca052e6571ea10dfbfc3f51be47ffdb08e5313d0` and tree
`447d0634ab6fa09782d50afa899f45e38c156809`. The worktree had 20 dirty-status entries from bounded
certificate prototype and scope work; the cited paths were clean at the commit.

| SHA-256 | Owner-repository path |
|---|---|
| `f350d69c246be13c3d31a81fa0983e34c036bb9f8839079d6db7587eab99e659` | `python/src/ksdft2effmass/analysis/hopping_fits.py` |
| `8f7244046d772716ed7f5c60022385c2c7b9a99d841489971a00783ae2bcaf7e` | `python/src/ksdft2effmass/solidstate/hopping_transforms.py` |
| `f93c074ab0e97c448cee02ba5ea955fe4c1c85373fea7b4cce67b66295ed15ce` | `python/src/ksdft2effmass/periodic1d/fourier_locality/analysis.py` |
| `f0040494d5b57062d9d9c974952f591f3b5d220c59a02d3cfe1c4d55d10c707c` | `calculations/periodic1d/rank1/fourier-locality/numerical-control-decision.md` |

The exact crosswalk is
`docs/BandGauge/ksdft2effmass/finite-fourier-least-squares-crosswalk.md`. The Lean results establish
an exact finite equal-weight least-squares theorem only. They authenticate no runtime character
inventory, NumPy solve, design rank, conditioning, binary64 coefficient, route agreement, threshold,
artifact, or scientific conclusion.

<a id="aud-src-022"></a>

## `AUD-SRC-022` — Finite periodic-lattice matrix least-squares applicability

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-022` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The lattice specialization was compared read-only with `ksdft2effmass` branch
`work/periodic23-rank2-ragasa-metric-extension` at commit
`0bef3dc574648ac60e4014962da75077ded3b4b2` and tree
`d957c541e73f78a312107ddb62cf3eb9fff8514f`. The worktree had 81 dirty-status entries. The cited
Periodic2D/3D rank-two and rank-N Python sources were tracked and clean at that commit; their hashes
and exact paths are recorded in
`docs/BandGauge/ksdft2effmass/finite-periodic-lattice-matrix-least-squares-crosswalk.md`. The
Periodic3D rank-N baseline working copy was modified, so only its committed bytes at the recorded
commit are cited immutably.

Formal models the mesh as a finite quotient of reciprocal-lattice coordinates and records the
reciprocal basis separately. The proved matrix-Frobenius least-squares result is uniform in finite
lattice dimension and finite matrix rank, with explicit 1-D, 2-D, and 3-D corollaries. It does not
authenticate a KSD mesh, basis, gauge, matrix array, character inventory, support, numerical solve,
conditioning result, binary64 value, execution artifact, or scientific conclusion.

<a id="aud-src-023"></a>

## `AUD-SRC-023` — Finite periodic-lattice onsite/nononsite power partition

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-023` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The direct-power partition was selected after a read-only inspection of `ksdft2effmass` branch
`work/source-code-cleanup-audit` at immutable commit
`4626f56b159bd15a548d00317bdfda9e367fd2f8`, tree
`16bc9400b94203aaaa605c027f5a0e04b37a56e9`. The initial status inspection at that revision was
clean. During the audit another process advanced and dirtied the same worktree, so all cited source
bytes and line locators are resolved from the immutable commit rather than the later working copy.

At that revision, both periodic-2D and periodic-3D rank-N summary paths computed nononsite power as
`max(0.0, total - onsite_power)` in their `analysis.py` and `fourier_reference.py` files. Their
result contracts checked `total = onsite + nononsite` only through a binary64 absolute tolerance.
The exact file hashes and locators are recorded in
`docs/BandGauge/ksdft2effmass/finite-periodic-lattice-matrix-least-squares-crosswalk.md`.

Formal instead defines nononsite power by a direct exact sum over every nonidentity lattice
coefficient and proves total power equals onsite plus nononsite power, uniformly in finite dimension
and matrix rank, with named 1-D, 2-D, and 3-D corollaries. The theorem neither diagnoses a retained
runtime artifact nor verifies Python summation, IEEE-754 subtraction, mesh coverage, support/gauge
binding, thresholds, or scientific consequences.

<a id="aud-src-024"></a>

## `AUD-SRC-024` — Provisional Periodic2D/3D rank-N analytic-parent crosswalk

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-024` |
| Status | `provisional` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A read-only inspection on 2026-11-02 examined the active KSD rank-first development worktree:

- owner repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-periodic23-rank2-ragasa-metric-extension`;
- branch: `work/periodic23-rank2-ragasa-metric-extension`;
- checked-out commit: `0a5ef2b8d15a82f7271ce3e1b194f759c63c6ee9`;
- dirty-state limitation: 428 short-status entries were present, and all four cited files below
  were untracked. The hashes identify only the inspected working-tree bytes. They are not immutable
  commit locators and must be refreshed against a reviewed owner commit before any release claim.

| SHA-256 of inspected untracked bytes | Owner-repository path | Locator and crosswalk use |
|---|---|---|
| `16f88ea8bcba5f2c1a12bda5abcc8aa4284f6e19fae4f71971bd62656661b718` | `python/src/ksdft2effmass/periodic2d/rankN/band_equivalence_hopping_locality/model.py` | lines 35 and 137–169: declared `1.9` bound, structure factor, orbital coordinates, and retained/exterior energies |
| `b886fae702c9f44449255fa52b837df6837ce531f6fe521b49aa729ebfaa27ea` | `python/src/ksdft2effmass/periodic3d/rankN/band_equivalence_hopping_locality/model.py` | lines 35 and 137–169: dimension-parallel formulas |
| `8cb6faf776281589c6c49b6d5cde9c9532ac0d746ff5aa0ba0d3600c6ba3ef50` | `calculations/periodic2d/rankN/recommended-baseline.md` | lines 53–94: exact analytic-parent formulas, bounded structure factor, `1.9` external gap, and retained ordering claim |
| `c0da1a4bc65187d4af0ea5d5114b0c2a3fca45d0dd71dd3f5135cc54f27c5bd2` | `calculations/periodic3d/rankN/recommended-baseline.md` | lines 49–85: dimension-parallel analytic-parent formulas and claims |

A final read-only identity recheck on 2026-11-02 found 430 short-status entries because unrelated
owner work continued concurrently; the branch, checked-out commit, four untracked classifications,
and four byte hashes above were unchanged. Neither count is a clean-source claim.

`BG-FOUNDATION-DEF-017` through `BG-FOUNDATION-DEF-021`,
`BG-FOUNDATION-LEM-001` through `BG-FOUNDATION-LEM-003`, and
`BG-FOUNDATION-THM-026` through `BG-FOUNDATION-THM-031` plus
`BG-FOUNDATION-THM-033` through `BG-FOUNDATION-THM-037` validate the source-neutral exact mathematics
behind those formulas. The
finite bond inventory is represented by an abstract nonempty finite type, and the reciprocal
phase is supplied exactly. The resulting structure factor lies in `[-1,1]`; selected orbital
coordinates lie in `[-1,1]`; the retained and exterior energies are bounded by `7/10` and `13/5`;
the external gap is therefore at least `19/10`; and adjacent retained energies differ by at least
`7/(10(r-1))`.

This crosswalk does **not** prove that Python or NumPy evaluates these definitions exactly, that a
runtime bond or mesh inventory matches the abstract finite type, that binary64 trigonometric values
satisfy exact identities, that sampled minima equal continuum minima, or that any eigensolver,
Procrustes fit, transport, Fourier transform, support selection, artifact, or scientific conclusion
is valid. No KSD file was modified during the inspection.

<a id="aud-src-025"></a>

## `AUD-SRC-025` — Provisional Periodic2D/3D rank-N exact gauge-construction crosswalk

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-025` |
| Status | `provisional` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A read-only inspection on 2026-11-02 examined the active KSD rank-first development worktree:

- owner repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-periodic23-rank2-ragasa-metric-extension`;
- branch: `work/periodic23-rank2-ragasa-metric-extension`;
- checked-out commit: `0a5ef2b8d15a82f7271ce3e1b194f759c63c6ee9`;
- dirty-state limitation: 438 short-status entries were present, and both cited model files were
  untracked. Their hashes identify only the inspected working-tree bytes, not immutable commit
  blobs. They must be refreshed against a reviewed owner commit before any source-fidelity or
  release claim.

| SHA-256 of inspected untracked bytes | Owner-repository path | Locator and crosswalk use |
|---|---|---|
| `16f88ea8bcba5f2c1a12bda5abcc8aa4284f6e19fae4f71971bd62656661b718` | `python/src/ksdft2effmass/periodic2d/rankN/band_equivalence_hopping_locality/model.py` | lines 249–272: `F'=F₀G`, `H'=GᴴDG`, and returned known inverse `Gᴴ` |
| `b886fae702c9f44449255fa52b837df6837ce531f6fe521b49aa729ebfaa27ea` | `python/src/ksdft2effmass/periodic3d/rankN/band_equivalence_hopping_locality/model.py` | lines 249–272: dimension-parallel construction |

A final read-only recheck on 2026-11-02 confirmed the same branch, checked-out commit, 438-entry
status count, untracked classifications, and byte hashes. This is not a clean-source claim.

`BG-ALIGNMENT-LEM-001/002` and `BG-ALIGNMENT-THM-069/071` validate the source-neutral exact algebra
behind those formulas for arbitrary finite ambient and retained types. Given an exact orthonormal
reference frame, exact finite complex unitary `G`, and exact represented operator `D`, the
construction preserves frame orthonormality and the complex spectrum. Right multiplication of the
constructed frame by `Gᴴ` recovers the reference frame, and right-gauge conjugation by `Gᴴ`
recovers `D`.

This crosswalk does **not** prove that a NumPy array is unitary or orthonormal, that the Python
Givens circuit equals the exact supplied `G`, that conjugate-transpose or matrix products were
computed without floating-point error, that an eigensolver returned the exact or correctly ordered
spectrum, or that Procrustes recovery, meshes, Fourier transforms, retained artifacts, or scientific
conclusions are valid. No KSD file was modified during the inspection.

<a id="aud-src-027"></a>

## `AUD-SRC-027` — KSD five-stage matrix/frame binding lifecycle source

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-027` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The authenticated external matrix/frame binding recommendation preserves the five-stage calculation
contract from a clean immutable KSD source:

- owner repository: `ksdft2effmass`;
- checkout: `/Users/eugene/worktrees/ksdft2effmass-si-right-handed-kpoint`;
- branch: `work/si-right-handed-kpoint`;
- commit: `b0af45f4eea97ee41eb0e2ae23a35a986a6c6e78`;
- tree: `3b5e66c797d0ffa1fa1ad9d9a6d3f603f243f4c3`;
- path: `calculations/periodic1d/rank2/band-equivalence-versus-hopping-locality/protocol.md`;
- Git blob: `cfebcdfdb0d3d8316f38b0383d42642e2fbf3cd7`;
- SHA-256 of commit bytes: `aabe8c6e005e6605ca4e2fec7103985f1ad303d2f41ff76fce1bbd4867aa74e4`;
- worktree state during inspection: clean.

The source separates simulation, independent simulation verification, analysis of verified output,
independent analysis verification, and plotting from verified analysis. The Formal recommendation
preserves that order and no-overwrite authority boundary; it does not claim that the stages have
executed, that a conforming external export exists, or that any KSD result is formally checked.

<a id="aud-src-028"></a>

## `AUD-SRC-028` — KSD mathematical implementation backlog inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-028` |
| Status | `current` |
| Source class | Owner-repository or computational-contract inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A later read-only inspection examined mathematical implementation paths in the current KSD checkout to identify remaining proof obligations rather than to establish source-specific applicability.

- owner repository: `ksdft2effmass`;
- checkout: `/Users/eugene/repos/ksdft2effmass`;
- branch: `work/monograph-current-library-capabilities`;
- checked-out commit: `4835e7bf9161729cc8f0537bcc13db083896a6ae`;
- tree: `fd641fb8a4efe7a5ef4d5da9c49f126e1e03e355`;
- dirty-state limitation: 112 short-status entries were present;
- path-level limitation: the specifically listed paths had no short-status entries, so the hashes below identify immutable blobs at the checked-out commit. This does not make the rest of the checkout clean.

| SHA-256 of commit blob | Owner-repository path | Backlog use |
|---|---|---|
| `e0deceebb75d84304eb02f80d1734afc0cd36be611dbd741d63298e96de33240` | `python/src/ksdft2effmass/solid_state/band_frames.py` | finite frame, sewing, transport, and closure semantics |
| `3e5124fe785cfc75d5a2bb80030e6bccf9c4bcb82ed540de9c2a4e32b57400ea` | `python/src/ksdft2effmass/solid_state/frame_alignment.py` | pointwise SVD/Procrustes, numerical-rank, frame-defect, and projector-defect semantics |
| `a2116911da6d3cba98a2b2a0776996bdda6b9f0e3a4470fcb7ee8c8d7df5b98f` | `python/src/ksdft2effmass/solid_state/hopping_transforms.py` | centered FFT, origin phase, reconstruction, and array ordering |
| `d0e71cdba5d3f4b728b3b513e18c435b1cfc97a76674f13dee206f12785a989f` | `python/src/ksdft2effmass/solid_state/gauge_bridges.py` | distributed-link and seam-localized twist gauges |
| `36bb668f0268ae8a93dc93021e9d141b2b42401c93cde657feef926d03272429` | `python/src/ksdft2effmass/solid_state/wilson_loops.py` | Wilson products, phases, winding, and gauge invariance |
| `8266198076c4abb0ced4e74d03d9c74bab6f245fd5e7406d2a2ed6e6bfa54235` | `python/src/ksdft2effmass/analysis/wannier_localization.py` | finite localization and polarization interpretations |
| `fcfa1ea0bad66aef5914cb9a1228d8c928ff82535925347a57d898744944c08b` | `python/src/ksdft2effmass/analysis/model_adequacy/band_equivalence_locality/alignment.py` | global and pointwise alignment implementation contracts |
| `9758029e5b4d310cf75010c63d1630fa7930e7bfed2eb1a477d83e3661ef19e3` | `python/src/ksdft2effmass/analysis/model_adequacy/band_equivalence_locality/fourier.py` | multidimensional Fourier and truncation conventions |
| `8ce3a227fe3cbac045f15ed30d9e9cfebeeed4990100189bc0d134abe37a3639` | `python/src/ksdft2effmass/periodic1d/multiband_alignment/calculate.py` | multiband objective and transport production |
| `5de3a07437174022efe63dd42c34c0a8004a540e3c66359ff765e0494f394e13` | `python/src/ksdft2effmass/periodic1d/multiband_alignment/verify.py` | independent numerical recomputation boundary |
| `4d15a4b411767581c5d7195ac85329f9e8147ce7a1c632a7f5a4cedff7cb73f6` | `python/src/ksdft2effmass/integration/wannier90/unitary_matrices.py` | square-unitary versus rectangular-isometry semantics |
| `06678c72892170c566de13a01f3444ae02c4fba5aa53ec00a3065a46ebf70554` | `python/src/ksdft2effmass/integration/wannier90/hamiltonian_blocks.py` | degeneracy-weighted Hamiltonian-block reconstruction |
| `3528f2ed0ba593179b293fe49873925e299066e74498f27b918d902061c86b74` | `python/src/ksdft2effmass/periodic2d/run/topological/calculate.py` | plaquette phases, winding, and model-specific topology claims |
| `6411a6e4d6282ba66d34ab2c531ee1be1aa8d4c7450b9e7575dd627b13edcf6d` | `python/src/ksdft2effmass/campaigns/periodic_1d/defects/finite_rank_oracle/workflow.py` | finite-rank defect roots and oracle comparison |

The inspection motivates polar-transport and principal-angle theorems, approximate fixed-subspace and general-rank spectral bounds, exact FFT and twist-gauge bridges, quantitative gauge-tail bounds, and later claim-specific topology, Wannier, defect, and effective-mass programs. The source-neutral polar-transport and positive-polar principal-value frame/projector slice is implemented in `ProjectKoios/BandGauge/Alignment/PolarTransport.lean` and `ProjectKoios/BandGauge/Alignment/PrincipalAngleBridge.lean`: it consumes supplied exact polar witnesses and proves finite matrix consequences only. The source-neutral approximate-compression modules `ProjectKoios/BandGauge/Projection/ApproximateCompression.lean` and `ProjectKoios/BandGauge/Projection/MixedNormCompression.lean` prove matrix-`L2Operator` and mixed Frobenius/operator frame and projector mismatch bounds, an exact reproduction residual whose zero value characterizes invariant-range closure under exact orthonormality, a separate frame-plus-projector residual bound relative to an exact zero-residual reference, and the explicit operator-to-Frobenius norm bridge. `ProjectKoios/BandGauge/Foundations/HermitianSpectralError.lean` fixes the canonical decreasing, multiplicity-retaining Hermitian eigenvalue carrier and distinct maximum/RMS errors, proves `RMS ≤ maximum`, and characterizes zero error by characteristic-polynomial equality. `ProjectKoios/BandGauge/Foundations/HermitianEigenvaluePerturbation.lean` proves the maximum-form Weyl/operator-norm inequality by a direct finite-dimensional eigenbasis/subspace-intersection argument, while `ProjectKoios/BandGauge/Foundations/HermitianEigenvalueRmsPerturbation.lean` separately proves the unnormalized Hoffman--Wielandt square-sum bound from doubly stochastic eigenbasis overlaps and its dimension-normalized RMS consequence. `ProjectKoios/BandGauge/Projection/OrderedSpectralCompression.lean` and `ProjectKoios/BandGauge/Projection/OrderedSpectralRmsCompression.lean` transfer the distinct maximum and RMS bounds through exact orthonormal-frame compression, including the frozen right-unitary action. None of these modules proves that NumPy or SciPy implements the theorems, that runtime frames are exactly orthonormal, that runtime leakage is small, that a runtime SVD has exact rank or principal values, that runtime eigenvalues have authenticated ordering or degeneracy handling, that a runtime transport loop closes, that binary64 values satisfy exact hypotheses, that a mesh is converged, or that DFT/Wannier90 output is physically adequate. No KSD file was modified during this inspection or formalization.
