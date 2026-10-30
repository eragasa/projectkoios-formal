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

## Calculation-family assessment

Each family is classified by existing support, next exact work, and boundary.

| Family | Existing exact support | High-value next theorem or bridge | Boundary |
|---|---|---|---|
| ICMSEP admissible sets | finite separation, rank-two losses, finite decisions, exact checkers | exact rational certificate decoding after schema freeze | no JSON, Python, chronology, or scientific acceptance claim |
| QHO1D | Hermite, ladder defect, finite differences, Gram pullback, discrepancy split | `JᵀHJ-D = Jᵀ(HJ-JD)` under `JᵀJ=I` | no box/grid convergence or binary64 residual claim |
| PIAB1D | exact finite modes, compression, fitting, rectangular basis algebra | full mode completeness and constant-weight invariance | no refinement-rate, eigensolver, or serialized-matrix claim |
| Mathieu1D/rank-one Fourier | finite transform, Parseval, truncation, Hermitian pairing | phase invariance, exact Mathieu matrix Hermiticity, matched character least squares | no sampled gap, conditioning, cutoff, or package claim |
| Periodic rank-two and cross-dimensional | rank-two alignment, sewing, Fourier tails, decisions, source-neutral complete finite metric shells with exact square/triangular/simple-cubic/FCC indices, exact pointwise complex-unitary lower/upper-band invariance from supplied coordinate witnesses, and normalized finite product-torus factorization with 2-D square and 3-D cube exponential-average laws | one-circle Bessel evaluation, owner-specific torus-coordinate/phase/measure and analytic-comparator binding, owner-specific inventory and runtime-gauge binding, and calculation-specific certificates after schema freeze | no runtime gauge/eigensolver/mesh or external-inventory authentication, quadrature or finite-to-continuum certification, `J₀` identity, physical hopping-range inference, tolerance claim, or material transfer across families |
| Higher-rank D1 | arbitrary-rank fixed-unitary Fourier invariance and finite matrix algebra | pointwise gauge, alignment-family, and polar/Procrustes contracts | schema-free summaries are not evidence |
| Synthetic strain and coordinates | exact FCC--Bain bridge | area/volume, reciprocal-map, and shell-symmetry identities | geometry only; no elasticity or phase-stability claim |
| Spin spaces | spin lift, partial-trace projection, Pauli residuals | basis-permutation, spin-rotation, and time-reversal identities | no authored `4×4` data or runtime result binding |
| 1-D defects and independent routes | finite folding and route commutativity | seam/twist crosswalk and weighted nonunitary transform | no parent, defect, truncation, observable, or binary64 validation |
| Finite-rank defect oracle | rank-one determinant, inverse, resolvent, and supplied-root eigenvector | spectral-order positivity, monotonicity, uniqueness, and root count | no bisection, bracket, root, or trend certification |
| Blind alignment | supporting matrix algebra | polar partial-isometry identifiability and completion equivalence | numerical thresholds remain external |
| 2-D defect stages | reusable folding and projector algebra | two-direction seam consistency, `D₄`/`D₂` covariance, axis swaps | no authorization journal, runtime, schema, or evidence validation |
| Periodic topology/Wannier controls | gauge loops and projector--Bargmann trace identity | separable Kronecker spectra and degenerate-projector identities | no Chern integrality, unwrapping, topology, Wannier90, or mesh validation |
| Continuum refinement/optimizer basin | small exact finite identities only | none without a selected theorem | do not formalize observed finite refinement or basin statistics as exact claims |
| Bulk silicon/Vogl | abstract tetrahedral `sp³s⋆` and Hermitian block algebra | optional exact metadata predicates or perturbation implications | no QE/Wannier90, Table 1, spectrum, convergence, or silicon validation |

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

## Priority

Completed on the consolidation branch:

1. integrate QHO, PIAB1D, and FCC--Bain;
2. integrate spin and folding;
3. generalize fixed-unitary Fourier invariance;
4. integrate finite rank-one resolvent algebra;
5. integrate gauge loops; and
6. integrate projector--Bargmann algebra.

Next certificate work begins only after KSD freezes an exact schema, calculation identity, producer, independent verifier, and retained package.

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
