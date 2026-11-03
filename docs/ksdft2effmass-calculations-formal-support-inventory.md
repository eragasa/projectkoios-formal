# `ksdft2effmass/calculations` formal-support inventory

This inventory identifies reusable exact mathematics near KSD calculations. It does not verify a calculation, runtime, artifact, numerical result, or scientific interpretation.

## Owner inspection

The inventory used one read-only dirty worktree.

- Repository: `ksdft2effmass`
- Worktree: `/Users/eugene/worktrees/ksdft2effmass-source-package-ownership-cleanup`
- Branch: `work/source-package-ownership-cleanup`
- Commit: `25161d7f55c708a464c18ea8d5d0fd6152ff86a6`
- Whole-worktree status count: 645
- `calculations/` status count: 34
- Access: read-only

The commit is an immutable baseline. Some inspected calculation documents were dirty or untracked. The hashes below identify inspected bytes; they do not make unavailable dirty bytes reproducible or place them in the commit.

### Later implementation-oriented inspection

A later read-only inspection broadened the inventory from calculation documents to the current KSD mathematical implementation graph.

- Repository: `ksdft2effmass`
- Checkout: `/Users/eugene/repos/ksdft2effmass`
- Branch: `work/monograph-current-library-capabilities`
- Commit: `4835e7bf9161729cc8f0537bcc13db083896a6ae`
- Tree: `fd641fb8a4efe7a5ef4d5da9c49f126e1e03e355`
- Whole-worktree status count: 112
- Access: read-only

The specifically inspected implementation paths were clean relative to that commit, but the checkout as a whole was not clean. The immutable blob hashes and path-level scope are recorded in `docs/source-audit.md`. This inspection supports backlog discovery only: it does not authenticate dirty sibling files, runtime arrays, external artifacts, or source-specific theorem applicability.

## Historical Formal state

This table records the state when the first-pass inventory was written.

| Formal state | Identity | Coverage |
|---|---|---|
| Base BandGauge harness | `26603110e9d64cd51c9101eff68060307f258a18`; dirty primary worktree | finite Fourier, rank-two losses, admissible geometry, finite decisions, certificates |
| QHO checkpoint | `002e1a2b4167acf9fe467a4f3da733c23dfd28e1`; clean | Hermite, finite ladder, finite difference, pullback, discrepancy decompositions |
| PIAB1D checkpoint | `2b2f9c05d13e693fc575b6b27e8ef4aedc5fb5d1`; clean | finite modes, compression, nonidentifiability, model-class fitting |
| FCC--Bain bridge | `289f119460c0418d1b09e5eb184e293efc164443`; clean | integer bridge, determinant one, modular bijection |
| Projection/nonlocality slice | local uncommitted worktree at `26603110...` | projection destroys finite support in one exact two-band example |
| Vogl slice | local uncommitted worktree at `26603110...` | tetrahedral transforms, structure factors, abstract Hermitian block model |

Later consolidation integrated QHO, PIAB1D, FCC--Bain, spin, folding, Vogl, finite measurement, arbitrary-rank Fourier, rank-one resolvent, gauge-loop, and projector--Bargmann checkpoints through `e6c9ad895eeb84608eb43292eacffd5d4d552b6e`. Projection/nonlocality remained outside that branch. These are integration facts, not release or evidence promotion.

Canonical `main` at the later inspection was `80145602d4d84e26a4c5ccd7bbd362618598e39b`. Separate review-pending worktrees contain cyclic quotient-radius proofs and finite-rank character-gauge/fixed-subspace proofs. Their successful local builds and audits do not make them canonical declarations: independent review, correction if required, and separately authorized integration remain outstanding.

## Calculation-family assessment

Each family is classified by existing support, next exact work, and boundary.

| Family | Existing exact support | High-value next theorem or bridge | Boundary |
|---|---|---|---|
| ICMSEP admissible sets | finite separation, rank-two losses, finite decisions, exact checkers | exact rational certificate decoding after schema freeze | no JSON, Python, chronology, or scientific acceptance claim |
| QHO1D | Hermite, ladder defect, finite differences, Gram pullback, discrepancy split | `JᵀHJ-D = Jᵀ(HJ-JD)` under `JᵀJ=I` | no box/grid convergence or binary64 residual claim |
| PIAB1D | exact finite modes, compression, fitting, rectangular basis algebra | full mode completeness and constant-weight invariance | no refinement-rate, eigensolver, or serialized-matrix claim |
| Mathieu1D/rank-one Fourier | finite transform, Parseval, truncation, Hermitian pairing, and exact equal-weight least-squares optimality and uniqueness of support truncation over a complete uniform finite-abelian inventory | phase invariance, exact Mathieu matrix Hermiticity, and an owner-specific applicability bridge identifying the runtime design with the exact inventory | no NumPy-solve, numerical-rank, conditioning, binary64 route-agreement, sampled-gap, cutoff, or package claim |
| Periodic rank-two and cross-dimensional | rank-two alignment, sewing, Fourier tails, decisions, source-neutral complete finite metric shells with exact square/triangular/simple-cubic/FCC indices and exact integer-lattice Euclidean radii satisfying the squared-index, inversion, triangle, elementwise `R_A + 2 R_U`, and complete-shell inclusion bounds, exact pointwise complex-unitary lower/upper-band invariance from supplied coordinate witnesses, exact binary product-mesh 2-D/3-D witnesses separating pointwise band equality from zero-mode Fourier locality with positive omitted power, arbitrary-dimension/arbitrary-rank finite-periodic lattice matrix-Frobenius least-squares optimality and direct onsite/nononsite power partition with explicit 1-D/2-D/3-D specializations, normalized finite product-torus factorization, the normalized positive sine-phase one-circle `J₀` identity, and exact 2-D `J₀(a)²` and 3-D `J₀(2a/3)³` scaling laws | owner-specific period/reciprocal-basis/matrix-axis/support/gauge binding, finite-character/centered-representative quotient-radius compatibility across modular seams, disjoint/exhaustive runtime onsite classification and direct-sum binding, owner-specific torus-coordinate/phase/measure and analytic-comparator binding, and calculation-specific certificates after schema freeze | no runtime gauge/eigensolver/mesh/basis or external-inventory authentication, NumPy solve, numerical rank or conditioning, binary64 summation or route agreement, quadrature or finite-to-continuum certification, external `J₀` comparator binding, physical hopping-range inference, tolerance claim, or material transfer across families |
| Higher-rank D1 | arbitrary-rank frame/compression covariance, exact finite-rank analytic-parent qualification, exact right-unitary gauge construction, fixed-unitary Fourier invariance, Procrustes minimality under supplied polar witnesses, finite-mesh alignment-family semantics, and finite matrix algebra | polar transport and seam closure, principal-angle frame/projector identities, approximate fixed-subspace compression, general-rank spectral perturbation, quantitative gauge-tail bounds, and authenticated runtime binding | schema-free summaries, numerical SVD ranks, binary64 orthonormality, and sampled objectives are not evidence |
| Synthetic strain and coordinates | exact FCC--Bain matrices, determinant and inverse identities, general integer-lattice quotient admission certificates, finite positive diagonal quotients, cubic-quotient admission, and the exact mixed-modulus condition `N₂=N₃ ∧ N₁∣N₂` | owner-specific binding of the selected runtime periods/common-cell convention, plus area/volume, reciprocal-map, and shell-symmetry identities | geometry and exact quotient algebra only; no runtime mesh, convergence, elasticity, phase-stability, or execution claim |
| Spin spaces | spin lift, partial-trace projection, Pauli residuals | basis-permutation, spin-rotation, and time-reversal identities | no authored `4×4` data or runtime result binding |
| 1-D defects and independent routes | finite folding, route commutativity, and source-neutral twisted cyclic finite-difference algebra | exact conjugacy between uniform-link and seam-localized twist gauges, multidimensional seam consistency, and a weighted nonunitary-transform theorem under explicit metric hypotheses | no parent, defect, truncation, observable, or binary64 validation |
| Finite-rank defect oracle | rank-one determinant, inverse, resolvent, and supplied-root eigenvector | spectral-order positivity, local-Green-function monotonicity, root existence/uniqueness/count, rank-`r` determinant/Woodbury generalization, and Feshbach residual bounds | no bisection, bracket, root, trend, or finite-to-infinite-volume certification |
| Blind alignment | supporting matrix algebra | polar partial-isometry identifiability and completion equivalence | numerical thresholds remain external |
| 2-D defect stages | reusable folding and projector algebra | two-direction seam consistency, `D₄`/`D₂` covariance, axis swaps | no authorization journal, runtime, schema, or evidence validation |
| Periodic topology/Wannier controls | gauge-loop cancellation, Wilson-determinant invariance, and projector--Bargmann trace identity | nonzero-overlap hypotheses, plaquette/Wilson gauge invariance with orientation, discrete Chern integrality, branch-safe unwrapping, Wilson--Chern equivalence, rectangular-isometry/disentanglement semantics, and exact `_u.mat`/`_hr.dat` convention bridges | no topological classification, Wannier obstruction, Wannier90 execution, or mesh validation follows from the existing finite identities |
| Continuum refinement/optimizer basin | small exact finite identities only | selected finite-to-continuum theorem with explicit regularity, stability, and quadrature hypotheses; effective-mass curvature and remainder bounds only after a physical model is fixed | do not formalize observed finite refinement, optimizer basins, or regression trends as exact or scientific claims |
| Bulk silicon/Vogl | abstract tetrahedral `sp³s⋆` and Hermitian block algebra | authenticated QE/Wannier90 representation bindings, general-rank spectral/operator error transfer, and model-specific effective-mass hypotheses if selected | no QE/Wannier90, Table 1, spectrum, convergence, silicon applicability, or effective-mass validation |

## Implemented bounded targets

Four bounded theorem families were integrated after the first pass.

### Spin embedding

The spin layer is exact and source-neutral.

- Pullback through either selected-spin injection returns the orbital matrix; cross-spin blocks vanish.
- The two injections are orthogonal isometries.
- `A ⊗ I₂` preserves multiplication, adjoint, and Hermiticity; doubles trace and squared Frobenius norm; and is injective.
- Half-partial-trace projection is idempotent, trace/Hermiticity preserving, orthogonal, and least-distance.
- Pauli channels give exact collinear and three-channel residual formulas.

### Folding and routes

The folding layer covers finite group and route algebra.

- Normalized finite-character folding matrices are unitary.
- Row phases preserve both products.
- Translation-invariant block hopping diagonalizes into the full finite Bloch inventory.
- `G = ZMod N` supplies the cyclic specialization.
- Coordinate pullback commutes with aligned subtraction, energy shifts, defect subtraction, and spin lift under the stated premises.

### Rank-one resolvent

The resolvent layer is conditional on finite exact premises.

- Determinant factorization and scalar singularity criterion.
- Sherman--Morrison formula with explicit invertibility and nonzero denominator.
- Hermitian real-coupling specialization.
- Nonzero resolvent vector for nonzero source.
- Exact eigenvalue equation at a supplied secular zero.

Root existence, uniqueness, monotonicity, and infinite-volume behavior remain unproved.

### Gauge loops

The gauge layer proves finite invariance only.

- Unit-valued vertex gauges cancel along paths.
- Closed products transform by basepoint conjugation.
- Scalar plaquette and Bargmann products are phase invariant.
- Matrix Wilson determinants are invariant under pointwise unitary conjugation.
- Unit-normalized rank-one projector products yield the exact Bargmann trace identity.

Principal phase invariance does not prove nonvanishing, unwrapping, topology, or a Wannier obstruction.

### Exact finite Fourier least squares

The finite-abelian layer proves a coefficient-space Pythagorean identity and transports it through
finite Parseval. For any exact candidate supported on a declared character support, reconstruction
error equals truncation error plus `|G|` times the retained coefficient mismatch. Consequently,
exact Fourier truncation is the least-squares minimizer, and equality occurs exactly at the
truncated coefficient field.

The immutable KSD source locators and applicability boundary are recorded in
`docs/BandGauge/ksdft2effmass/finite-fourier-least-squares-crosswalk.md`. The theorem does not
validate a NumPy solve, runtime inventory, numerical full rank, conditioning, binary64 route
agreement, threshold, artifact, or scientific interpretation.

### Finite-periodic lattice matrix application layer

The lattice layer instantiates the finite abelian group as `(d : D) → ZMod (N d)`, records a
`Module.Basis D ℝ (D → ℝ)` separately as exact reciprocal geometry, and lifts the generic result to
explicit entrywise matrix-Frobenius power. One parametric proof covers arbitrary finite dimension
and rank, with named periodic 1-D, 2-D, and 3-D corollaries; orthogonal and nonorthogonal bases do
not change finite-character orthogonality.

The exact owner-source locators and nine remaining applicability obligations are recorded in
`docs/BandGauge/ksdft2effmass/finite-periodic-lattice-matrix-least-squares-crosswalk.md`. No theorem
chooses a gauge, authenticates runtime periods, basis vectors, matrix axes, arrays, equal weights,
support, or character normalization, or validates a numerical execution or scientific claim.

### Exact onsite/nononsite matrix-power partition

For an exact finite matrix coefficient field, the finite-abelian layer defines onsite power at the
additive identity and nononsite power by a direct sum over the erased identity coefficient. It proves
nononsite nonnegativity and the exact partition `total = onsite + nononsite`. The lattice layer gives
one arbitrary-dimension/rank theorem and named periodic 1-D, 2-D, and 3-D corollaries.

The immutable KSD source locators motivating this contract are recorded in
`docs/BandGauge/ksdft2effmass/finite-periodic-lattice-matrix-least-squares-crosswalk.md`. Formal does
not establish IEEE-754 correctness, certify Python `sum` or `math.fsum`, authenticate runtime
classification or arrays, or prove that any retained calculation contains a subtraction-induced
false zero.

## Prioritized remaining proof obligations

The implementation-oriented inspection separates four kinds of remaining work.

### 1. Reusable exact finite mathematics

1. Polar neighbor transport, sequential transport, periodic closure distribution, uniqueness under nonsingular overlaps, and an explicit rank-deficient boundary.
2. Principal-angle identities connecting optimal Procrustes frame error, overlap singular values, and projector error.
3. Approximate fixed-subspace compression bounds, including a bound of the form
   `‖CᴴHC - UᴴFᴴHFU‖_F ≤ 2 ‖H‖op ‖C-FU‖_F` under explicit isometry hypotheses, plus separate projector/leakage terms when retained subspaces differ.
4. General-rank Hermitian spectral perturbation from operator and matrix-Frobenius error, with maximum and root-mean-square eigenvalue consequences kept distinct.
5. Quantitative `ℓ¹`/`ℓ²` gauge-convolution and omitted-power bounds for gauges without finite Fourier support.
6. Exact twist-gauge conjugacy and seam consistency.
7. Later, claim-driven topology, defect-root, Feshbach, and continuum/effective-mass theorem families.

### 2. Source-specific representation bridges

1. Identify KSD's centered `fft`/`fftshift`, origin phase, positive reconstruction phase, tensor-axis order, and negative-Nyquist convention with the exact finite-character transform.
2. Bind product-quotient characters to wraparound-compatible radii and authenticate supplied square, triangular, cubic, and FCC shell inventories.
3. Bind runtime frames, projectors, represented operators, action side, units, bases, energy references, and matrix axes to the exact carrier.
4. Give separate semantics for square unitary Wannier matrices, rectangular isometries, disentanglement maps, `_hr.dat` degeneracy weights, and localization outputs.

### 3. Rigorous numerical certificates

Any application must freeze a proposition-specific exact or outward-rounded schema, producer identity, independent verifier, complete objective inventory, ordering and finite-value rules, and fail-closed checker. SHA-256 authenticates retained bytes only. No binary64 value becomes exact rational evidence merely by serialization.

### 4. Convergence and scientific validation

Mesh convergence, finite-to-continuum limits, effective-mass curvature, material adequacy, topology, transferability, threshold selection, and publication conclusions require separate analytical hypotheses, retained numerical evidence, and scientific review. They are not consequences of finite algebra or software tests.

## Priority

Completed historical integration includes QHO, PIAB1D, FCC--Bain, spin, folding, fixed-unitary Fourier invariance, rank-one resolvent algebra, gauge loops, and projector--Bargmann algebra.

The next dependency order is:

1. independently review the cyclic-radius and finite-rank character/fixed-subspace worktrees before any integration;
2. prove polar transport and the principal-angle frame/projector bridge;
3. prove approximate fixed-subspace compression and general-rank spectral-error transfer;
4. prove the exact KSD centered-FFT/product-quotient binding; and
5. freeze one KSD proposition-specific certificate contract before implementing or admitting runtime evidence.

Topology/Wannier, defect/Feshbach, and continuum/effective-mass programs follow only when a concrete owner claim selects their hypotheses. Checked runtime-certificate count remains zero.

## Nonclaims

This inventory does not authorize KSD mutation, execution, evidence promotion, commit, push, release, or publication. It does not formalize:

- floating arrays, tolerances, fits, eigensolver residuals, plots, or serialized runtime values;
- JSON parsing or SHA-256 computation in Lean;
- independent Python verifier execution;
- QE or Wannier90 execution;
- continuum or infinite-volume conclusions inferred from finite sweeps; or
- scientific validity, uncertainty, novelty, or publication readiness.

## Inspected calculation-document hashes

These SHA-256 values bind the working-tree bytes used in the first pass.

| SHA-256 | KSD path |
|---|---|
| `f4e38e231b7dee3d4dbed18f0667493d3a9e0018d1a39d0236fe8e77bfe785cf` | `calculations/README.md` |
| `c35801f97989cb5aee265de779bc0770e1762d3188103d5089beac0dfdb90f5b` | `calculations/mathieu1d/README.md` |
| `9ba0d329d4210c546854a3c94a9c91f528e9ed6ba58251bf3551c7c6f1a422ec` | `calculations/mathieu1d/protocol.md` |
| `ad399df9279fae0e33a19a2bce841637639006e24a02407434b10e1ba1c5e8b5` | `calculations/qho1d/README.md` |
| `0455f8364b9af6e391afc799e4cdee3b248f01e051b9997263d6e424a278e0ba` | `calculations/piab1d/README.md` |
| `fdc708803ccb2f3eb44ab9d5c4b3608fb49ce5b00177e219669d9666df5703db` | `calculations/piab1d/protocol.md` |
| `c9e07e7282f881c93c849f8fbdcf75495ea1fc899763d17ceb97a2ba31ed85b5` | `calculations/periodic/multiband/README.md` |
| `090534524e58a357919fd45f3557273960b211d711f9a146d18b61e46a3d3c37` | `calculations/periodic1d/rank1/fourier-locality/protocol.md` |
| `a9231661d04e2804332ce37abef942c59b064fd984c27a77eb71afadd414864d` | `calculations/periodic1d/rank2/band-equivalence-locality/protocol.md` |
| `6fee776baf2a628be9abf35d1f34a5456706addf6c216ce85f3c2c9ba11020ed` | `calculations/periodic1d/rankN/composite-band-alignment-locality/README.md` |
| `7f70548bf18691a28814bfde8e528bcbf33892ecf7dfb7d0b38fb672e1915631` | `calculations/ICMSEP2026/conference/paper_1/README.md` |
| `012fc0293fc1f44e3655eff979c9454df47135ff4f511a57e4fab97a18ffc564` | `calculations/ICMSEP2026/conference/paper_1/constrained-admissible-sets/README.md` |
| `5458286080567bcdeffb64ab9cdb908ea8944e0f81fa2e0425058503a96f181b` | `calculations/research-monograph/impurity-spin-spaces/protocol.md` |
| `85c20bcacfe46e5e844abfb2b493ef2e178f50e36640a1a00bc2bdedb6ee44ff` | `calculations/research-monograph/impurity-defect-1d/protocol.md` |
| `e6dafe3ad7de7cc876b640df2535adab4d26e888d95bcc40c1b7d2a8be5c8760` | `calculations/research-monograph/impurity-defect-1d-independent-route/protocol.md` |
| `55b8d2533541ea5b24fc2abc7a909f5b417eb815112f0ec6e150ed9a92edf339` | `calculations/research-monograph/impurity-defect-1d-analytical-oracle/protocol.md` |
| `bd5ba95ce2b4d6b0b188179e4c4cff691f7ab2533b483efbd1bd751ebf27ad75` | `calculations/research-monograph/impurity-defect-1d-blind-alignment/protocol.md` |
| `59da7c54444965671f1dd341e876fed6518f07d1911b28d8f6d2c2972fe10075` | `calculations/research-monograph/impurity-defect-1d-continuum-refinement/protocol.md` |
| `fa8d0fa13d8e6fc116622e8cd33205903b340f695cda411c75e89ac500fcd1a3` | `calculations/research-monograph/periodic-1d/protocol.md` |
| `691b54662eedf510e67c059216cc1da6d92a6a349996491c7ce861e280e33df4` | `calculations/research-monograph/periodic-2d/protocol.md` |
| `4c79f38477508668804a25e600c8be4f0e8358dd4ea10de152768e07da966246` | `calculations/band-equivalence-dimensional-comparison/README.md` |
| `df634d295dfff6ee239401fc9cc8adc79b4e951a5f5023aa02d00f9c02e50c77` | `calculations/periodic2d/rank2/strain-locality/README.md` |
| `1234e491adbce28b2b35e47102a7a88b2ecb896053c69e4c764584021ec7d912` | `calculations/periodic3d/rank2/strain-locality/README.md` |
| `d3dd0cc01b68f33ec9c8e765bf9fb460342f9eedc94580138c264563fe4bedf1` | `calculations/research-monograph/harmonic-oscillator/README.md` |
| `362effd834fc08997cf8c8d355ce2a35c9e4aa6d5665b16b00f0fa5b6f890e9c` | `calculations/research-monograph/impurity-spin-spaces/README.md` |
| `c5a70b24b0105cbc314eaee5350c6d2ef0766531b7f6b01da706ca197491e5bd` | `calculations/research-monograph/impurity-defect-2d/README.md` |
| `d957296b75e91c95c280a74ccf20081a4bbfb5c42e722e14fe3e352d77d4cbe7` | `calculations/research-monograph/periodic-1d/README.md` |
| `8864ee1ffe42ca37b23230d72897b79ef4493cd2fa85833c4e3bfb6127ef705c` | `calculations/research-monograph/periodic-2d/README.md` |
| `1400ef7ffdf1484106be96c9f40e351c6527d24b77c252063bf1abac45e1c60e` | `calculations/research-monograph/periodic-2d-optimizer-basin/README.md` |
| `d3a9c43b86e3c646ec800c1a4adc0a9a12e80ae663d0c1597435ba5d40972d26` | `calculations/Si/bulk/README.md` |
