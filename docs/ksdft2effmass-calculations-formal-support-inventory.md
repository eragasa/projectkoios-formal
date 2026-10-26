# `ksdft2effmass/calculations` formal-support inventory

## Purpose

This is a first-pass, publication-independent inventory of places where exact Lean
statements could support calculation contracts owned by `ksdft2effmass`. It does not
promote a calculation, numerical result, source claim, or scientific interpretation to
a theorem. It does not identify Python execution, binary64 arrays, JSON parsing,
external-calculator output, plots, hashes, or retained evidence packages with Lean
values.

The inventory separates four cases:

1. **existing exact support** — a relevant theorem family already exists in a clean
   Formal checkpoint or in a separately identified local Formal worktree;
2. **high-value candidate** — the calculation states reusable exact mathematics that is
   a good fit for Lean;
3. **supporting candidate** — exact formalization is possible, but it is not the
   calculation's main current evidentiary gap; and
4. **numerical/runtime boundary** — formalization must not be presented as validating
   the calculation result.

## Owner-source identity and dirty-state limitation

The inspected calculation owner was:

- repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-source-package-ownership-cleanup`;
- branch: `work/source-package-ownership-cleanup`;
- commit at inspection: `25161d7f55c708a464c18ea8d5d0fd6152ff86a6`;
- whole-worktree status count at inspection: 645 entries;
- `calculations/` status count at inspection: 34 entries; and
- access mode for this inventory: read-only.

Another KSD session was performing a non-destructive cleanup concurrently. The commit is
an immutable baseline, but some inspected calculation documents were dirty or untracked
working-tree bytes. The byte hashes in the final section identify exactly what this
inventory read; they do not claim that all files belong to commit `25161d7f...`.

## Existing Formal support considered

The following Formal states were considered separately. They are not silently combined
into one branch or release.

| Formal state | Identity and status | Relevant coverage |
|---|---|---|
| Base BandGauge harness | commit `26603110e9d64cd51c9101eff68060307f258a18`; primary worktree dirty | finite Fourier inversion and Parseval, Hermitian pairing, rank-two alignment/loss, admissible-set geometry, finite decisions, and certificate semantics |
| QHO checkpoint | clean commit `002e1a2b4167acf9fe467a4f3da733c23dfd28e1` | Hermite polynomial/eigenfunction identities, finite ladder boundary defect, finite-difference symmetry, Gram-normalized injection, pullback, and exact discrepancy decompositions |
| PIAB1D checkpoint | clean commit `2b2f9c05d13e693fc575b6b27e8ef4aedc5fb5d1` | finite Dirichlet/cyclic matrices, exact discrete modes and eigenvalues, compression residuals, decomposition nonidentifiability, and finite model-class fitting |
| FCC--Bain bridge | clean commit `289f119460c0418d1b09e5eb184e293efc164443` | exact integer coordinate bridge, determinant one, and modular bijectivity |
| Projection/nonlocality slice | local uncommitted worktree based at `26603110...` | exact two-band example in which spectral projection destroys finite hopping support |
| Vogl `sp3s*` slice | local uncommitted worktree based at `26603110...` | tetrahedral transforms, structure factors, structural zeros, and Hermiticity of the abstract Vogl block Hamiltonian |

A local-only or uncommitted Formal slice is evidence of implemented local work, not a
published or integrated theorem dependency.

## Calculation-family assessment

### 1. ICMSEP controlled admissible-set packages

**Owners:** `calculations/ICMSEP2026/conference/paper_1/` and its M1--M3 children.

**Existing support is already strong.** The current BandGauge harness covers the central
exact layers:

- finite admissible-set intersection and separation geometry;
- rank-two real-rotation alignment and Pauli-coordinate loss formulas;
- finite Pareto, threshold, first-pass, and minimum-cost semantics;
- exact finite Fourier reconstruction, truncation, Parseval, and Hermitian pairing; and
- checked separation-certificate implications.

**Remaining formal opportunity:** define a deliberately narrow certificate-decoding
boundary for exact rational or integer fields, then prove that a successfully decoded
M3 certificate satisfies the already formalized abstract checker premises. This would
check certificate content, not Python execution, JSON parsing, floating-point values,
chronology, or scientific acceptance.

**Disposition:** existing theorem support should be integrated and crosswalked before
new mathematics is added.

### 2. QHO1D and the retained harmonic-oscillator calculation

**Owners:** `calculations/qho1d/` and
`calculations/research-monograph/harmonic-oscillator/`.

**Existing support is strong.** The QHO checkpoint already formalizes the exact
Hermite--Gaussian eigenfunction expression, finite ladder identities, the highest-state
truncation defect, finite-difference matrix symmetry, sampled Gram normalization,
operator pullback, and diagonal/off-diagonal Frobenius splitting.

**Small high-confidence addition:** formalize the calculation-facing a-posteriori
identity

\[
J^{\mathsf T}HJ-D = J^{\mathsf T}(HJ-JD)
\]

under `JᵀJ = I`. This directly supports the current QHO1D report without claiming a
finite-box, discretization, spectral, or binary64 bound.

**Not a Lean claim at present:** the observed box/grid convergence rates, cancellation
between error channels, sampled condition numbers, and reported numerical residuals.

### 3. PIAB1D residual and refinement calculation

**Owner:** `calculations/piab1d/`.

**Existing support is very strong.** The PIAB1D checkpoint already covers the exact
Dirichlet matrix, cyclic corner difference, finite sine/exponential eigenmodes and
cosine eigenvalues, consistent compression, discarded-sector identity, decomposition
nonuniqueness, and several nested finite model-class projection identities. This
inventory worktree additionally gives a source-neutral rectangular-basis layer: `Φ`
maps reduced coefficients into the full space, `P = Φ Φᵀ`,
`Hred = Φᵀ H Φ`, and `Hemb = Φ Hred Φᵀ = P H P`. It proves coefficient round-trip
under `Φᵀ Φ = I`, projector idempotence and symmetry, and symmetry preservation by
reduction and embedding. The notation reserves `Q = I - P` for the complementary
projector, matching the PIAB1D protocol.

**Remaining formal opportunities:**

- prove completeness, distinctness, and orthogonality of the canonical finite
  Dirichlet modes over the declared index range;
- package the full finite spectral decomposition rather than individual eigenpairs; and
- add an exact theorem for constant quadrature-weight invariance of the projector,
  compressed Hamiltonian, and residual matrices.

**Not a Lean claim at present:** observed second-order refinement, high-index dispersion
values, binary64 eigensolver residuals, serialized matrices, or retained run validity.

### 4. Mathieu1D and the planned rank-one compatible control

**Owners:** `calculations/mathieu1d/` and
`calculations/periodic1d/rank1/fourier-locality/`.

**Existing support:** the generic finite Fourier, reconstruction, Parseval, truncation,
and Hermitian-pairing theorems apply to the scalar transform contract. They already
support the fact that a complete transform followed by its inverse reconstructs the
finite mesh and that omitted power is an exact finite tail.

**High-value additions:**

- scalar phase conjugation leaves a rank-one represented Hamiltonian unchanged, which
  formally justifies treating global, pointwise, and known-inverse phase channels as
  inapplicable rather than distinct calculations;
- the exact finite Mathieu plane-wave matrix is Hermitian for real Fourier-potential
  coefficients;
- matched complete-mesh equal-weight least squares equals discrete Fourier coefficient
  selection when the design matrix is the complete character table; and
- energy shifts change only the zero-displacement coefficient, while spatial
  translations multiply coefficients by phases without changing scalar spectra.

**Not a Lean claim at present:** sampled gaps, conditioning, withheld-mesh errors,
finite-cutoff adequacy, binary64 tolerances, or retained package verification.

### 5. Periodic rank-two and cross-dimensional BandGauge calculations

**Owners:** `calculations/periodic1d/rank2/`, `calculations/periodic2d/rank2/`,
`calculations/periodic3d/rank2/`, and
`calculations/band-equivalence-dimensional-comparison/`.

**Existing support is substantial.** Rank-two rotation, pointwise spectrum bounds,
sewing preservation, unitary-conjugation invariance, finite matrix Fourier transforms,
Hermitian hopping pairing, residual tails, admissible geometry, and finite decision
semantics are already represented in the BandGauge harness.

**Important local-only support:** the projection/nonlocality slice gives an exact
nearest-neighbor two-band parent whose lower-band projector sandwich has no finite
matrix Fourier support. It is directly relevant to projection-induced locality claims,
but remains uncommitted and unintegrated.

**Remaining additions:**

- a reusable theorem that unitary conjugation preserves the characteristic polynomial
  or eigenvalue multiset for arbitrary finite rank;
- exact separation of finite-cyclic transform, ordinary-lattice truncation, and
  off-mesh interpolation errors;
- matched direct-versus-mediated matrix Fourier fitting for general finite rank; and
- calculation-specific certificate bridges only after schemas and exact certificate
  fields are frozen.

**No cross-family theorem should transfer numerical tolerances or material meaning.**
The dimensional comparison can consume common abstract definitions, but each family's
geometry, mesh, and evidence identity remain separate.

### 6. Higher-rank one-dimensional composite-band calculation

**Owner:** `calculations/periodic1d/rankN/composite-band-alignment-locality/`.

This is a **high-value formal gap** because the calculation explicitly extends beyond
rank two while the strongest existing alignment theorems are rank-two-specific.

Candidate reusable theorem families are:

- arbitrary finite-rank unitary conjugation preserves Hermiticity, trace, Frobenius
  power, characteristic polynomial, and spectrum;
- endpoint sewing and periodic gauge transformations preserve projector fields;
- finite-group matrix Fourier inversion, block Hermitian pairing, and exact truncation
  tails for arbitrary internal rank;
- the known-inverse oracle gives zero aligned residual exactly;
- pointwise complete alignment cannot be silently substituted for one-global-unitary
  alignment; and
- polar/Procrustes alignment optimality under explicitly stated rank and metric
  hypotheses.

Formal work should begin with general finite-rank invariance and Fourier identities,
not with the current schema-free numeric summary. Strict schemas, retained execution,
and producer-independent verification remain KSD obligations.

### 7. Synthetic strain and lattice-coordinate calculations

**Owners:** `calculations/periodic2d/rank2/strain-locality/` and
`calculations/periodic3d/rank2/strain-locality/`.

**Existing support:** the clean FCC--Bain crosswalk proves exact invertibility and
unimodularity of the fixed integer coordinate bridge used by PhysKit.

**Supporting additions:**

- the declared two-dimensional rhombic path preserves area;
- the declared three-dimensional Bain deformation preserves volume when that is an
  actual protocol premise;
- reciprocal/direct coordinate maps are mutual inverses under explicit nonzero
  determinant hypotheses;
- shell membership is preserved by the declared point-group actions; and
- geometry-only coordinate transformations remain distinct from response-Hamiltonian
  assumptions.

These would support geometry contracts only. They would not prove elasticity,
phase stability, silicon applicability, or numerical locality trends.

### 8. Spin-space embedding calculation

**Owner:** `calculations/research-monograph/impurity-spin-spaces/`.

This was the **best bounded new Formal target** found in the first pass. Its embedding,
spin-independent projection, and Pauli-residual slices are now implemented under
`ProjectKoios/QuantumMechanics/FiniteDimensional/`.

Implemented exact theorem families:

- pullback of `A ⊗ I₂` through either selected-spin injection returns `A`, while the
  cross-spin block is zero;
- the selected-spin injections are mutually orthogonal isometries;
- the lift preserves conjugate transpose, Hermiticity, and multiplication, doubles
  trace, and is injective;
- `‖A ⊗ I₂‖_F² = 2 ‖A‖_F²` for Mathlib's scoped Frobenius norm;
- the spin-independent map is exactly `(Tr_spin M / 2) ⊗ I₂`; it is idempotent,
  fixes exactly the spin-degenerate lifts, preserves trace and Hermiticity, is
  Frobenius-orthogonal, and is the unique least-distance representative; and
- standard Pauli channels have zero partial spin trace and satisfy the exact collinear
  and general three-channel squared Frobenius residual formulas.

Remaining proposed theorem families:

- declared basis permutations and spin rotations give reversible unitary coordinate
  changes and preserve Hermiticity, trace, spectrum, and Frobenius magnitude; and
- the declared antiunitary time-reversal transformation fixes the authored
  `i A_j ⊗ σ_j` construction under explicit real-antisymmetry premises.

Implemented ownership:
`ProjectKoios/QuantumMechanics/FiniteDimensional/SpinEmbedding.lean`,
`SpinIndependentProjection.lean`, and `SpinPauliResidual.lean`.

The modules remain abstract in the orbital index and do not embed the calculation's
authored `4×4` matrices or numerical results.

### 9. One-dimensional defect extraction and independent routes

**Owners:** `calculations/research-monograph/impurity-defect-1d/` and
`impurity-defect-1d-independent-route/`.

The source crosswalk is to `calculations/research-monograph/impurity-defect-1d/protocol.md`
and `calculations/research-monograph/impurity-defect-1d-independent-route/protocol.md` at the
immutable inspected KSD commit recorded above. The implementation is deliberately more general
than those one-dimensional protocols and does not bind their runtime values.

The bounded folding and route-commutativity slice is now implemented in
`ProjectKoios/SolidState/FiniteLattice/`:

- the normalized finite-character cell and orbital-block folding matrices have
  orthonormal columns and rows;
- caller-supplied unit-modulus row phases preserve both products of the cell and block
  folding matrices;
- a finite translation-invariant block-hopping supercell is block diagonalized exactly
  into its complete finite Bloch-fiber inventory;
- `G = ZMod N` gives the explicit one-dimensional cyclic specialization;
- aligned subtraction and scalar energy-reference removal commute with isometric
  coordinate pullback;
- defect subtraction commutes with folding after the pristine folded operator is
  explicitly identified; and
- orbital coordinate pullback commutes with the exact two-state spin-degenerate lift.

Remaining theorem families include a source-specific quotient-seam/twist assembly
crosswalk, structured representation-compatibility types, and the weighted nonunitary
construction where `G = F W^{1/2}`, the inverse is `W^{-1/2}F†`, and transformed
Hermitian operators are self-adjoint in the induced metric `G†G = W`.

The implemented theorems do not validate retained parents, defect plants, representative
selection, hopping truncation, finite-size sequences, observables, or binary64 route
comparisons.

### 10. Finite-rank analytical defect oracle

**Owner:** `calculations/research-monograph/impurity-defect-1d-analytical-oracle/`.

This target is split into layers:

1. exact rank-one determinant/resolvent algebra;
2. the resolvent-constructed eigenvector equation at a secular root;
3. positivity and monotonicity of the local resolvent below the finite host edge; and
4. uniqueness and bound-state-count consequences.

**Implemented finite layer:** `RankOneResolvent.lean` proves the first two layers for arbitrary
finite complex matrices. It includes the determinant factorization, exact scalar singularity
criterion, Sherman--Morrison formula with an explicit nonzero denominator, Hermitian real-coupling
specializations, nonvanishing of the resolvent vector for a nonzero source, and the exact
eigenvalue equation at a supplied secular zero of `H-EI`.

The latter two layers still require careful finite spectral-order APIs and must not be inferred
from numerical bisection. The special spin-degenerate case should use an equal-rank projector
theorem, not individual eigenvector identity.

Current Formal support establishes only the exact conditional oracle mathematics. It does not
check bisection execution, brackets, retained numerical roots, or finite-size trends.

### 11. Blind alignment

**Owner:** `calculations/research-monograph/impurity-defect-1d-blind-alignment/`.

**Supporting formal opportunity:** characterize the SVD/polar partial isometry and prove
what is identifiable on its range. In particular, different unitary completions can
disagree globally while giving the same compressed operator on the identified sector.
The global-phase quotient for full-rank maps is also a clean exact equivalence relation.

This is lower priority than spin embedding and supercell folding because the protocol's
rank thresholds, condition-number stops, angle tolerance, noise sensitivity, and energy
anchor are numerical policies. Lean should not certify those binary64 inferences without
an explicit exact certificate boundary.

### 12. Two-dimensional defect stages

**Owner:** `calculations/research-monograph/impurity-defect-2d/`.

Potential exact support reuses the one-dimensional folding program and adds:

- Kronecker-product construction of two-dimensional folding maps;
- seam/twist consistency in two periodic directions;
- `D₄` and `D₂` covariance of oriented defect blocks;
- axis-swap covariance under an explicit permutation;
- nested model-class orthogonal projections; and
- route-order commutativity when the constructors are pure and their bridge is exact.

The 2-D package is large and evidence-rich. Formalization should target its reusable
mathematics, not its authorization journals, process schedules, schemas, hashes,
runtimes, memory observations, or accepted result bytes.

### 13. Periodic 1-D/2-D topology and Wannier controls

**Owners:** `calculations/research-monograph/periodic-1d/` and `periodic-2d/`.

**Existing support:** finite Fourier/Hermitian identities, sewing contracts, rank-two
rotation, and the local projection/nonlocality counterexample cover part of the exact
layer. The finite gauge-loop slice now additionally proves:

- pointwise unit-valued link transformations cancel internally along ordered paths;
- closed products transform by basepoint conjugation and are invariant for commutative links;
- oriented four-edge plaquettes are invariant under scalar pointwise gauge changes;
- Bargmann overlap products and their principal complex arguments are independent of
  pointwise unit-modulus state phases;
- matrix Wilson products transform by conjugation under pointwise unitary frame changes; and
- determinants of those finite Wilson products are gauge invariant;
- rank-one state outer products are Hermitian and become idempotent under an explicit unit-norm
  premise;
- ordered products of those rank-one matrices are pointwise-phase invariant; and
- the ordered projector-product trace is exactly the corresponding Bargmann product, so their
  principal phases agree and are pointwise-phase invariant.

**Remaining high-value exact addition:** separable Kronecker-sum spectra and degenerate projectors
satisfy the declared product identities. The projector/Bargmann crosswalk is now implemented with
an explicit start-plus-tail ordering and does not infer state normalization from runtime data.

A general Chern integrality or Wannier-obstruction theorem is a separate, much larger
analytic project. It must not be replaced by the proved finite-mesh gauge invariance.
External overlap construction, loop orientation, boundary sewing, phase unwrapping, Wilson
eigenphase extraction, Wannier90 convergence, native parsing, optimized spreads, and hopping tails
remain runtime/numerical evidence.

### 14. Continuum-refinement and optimizer-basin packages

**Owners:** `impurity-defect-1d-continuum-refinement/` and
`periodic-2d-optimizer-basin/`.

These packages are dominated by finite numerical refinement, stopping rules, external
optimization, retained endpoint classification, and exploratory statistics. Formal
support should be limited to reusable exact subidentities such as:

- the second derivative of a finite hopping dispersion at the band edge;
- low-sector/cross-sector block decomposition by an exact projector; and
- invariance of exact-equivalence classes under the declared finite symmetry group.

Formalizing the observed refinement boundary, basin occupancy, right-censored regression,
Wannier convergence, or continuum crossover is **not recommended** without a separately
stated mathematical theorem and checkable hypotheses.

### 15. Bulk silicon and the Vogl control

**Owners:** `calculations/Si/bulk/` and historical `calculations/bulk-silicon/`.

**Existing local support:** the isolated Vogl slice formalizes exact tetrahedral `sp3`,
`sp3s*`, structure-factor, structural-zero, and Hermitian block identities using
abstract real parameters. It deliberately contains no accepted Table 1 row.

**Further exact support could include:**

- a checked rational certificate format for selected exact parameter identities, if KSD
  later defines one;
- exact space/basis/unit metadata compatibility predicates before operator subtraction;
- abstract spectral perturbation implications from certified residual and gap bounds;
  and
- finite effective-mass stencil algebra, while leaving the actual sampled curvature and
  convergence to numerical evidence.

Formal cannot establish QE/Wannier90 execution, pseudopotential accuracy, cutoff/mesh
convergence, valley location, numerical eigenspectra, Table 1 transcription accuracy,
material adequacy, or silicon validation.

## Recommended order

1. **Integrate existing clean QHO, PIAB1D, and FCC--Bain checkpoints before duplicating
   them.** Rebase/review is an integration task, not new theorem work.
2. **Review the completed spin and finite-folding slices before integration.** Their abstract
   algebra is complete for the bounded scope; source-specific runtime and evidence bindings remain
   deliberately external.
3. **Generalize unitary/Fourier invariance from rank two to arbitrary finite rank.** This
   supports the rank-N and composite-band programs.
4. **Review and checkpoint the implemented rank-one resolvent defect algebra.** Keep root
   uniqueness deferred until spectral-order hypotheses are explicit.
5. **Review and checkpoint the implemented finite lattice-gauge loop invariance.** Keep its exact
   finite algebra separate from Chern integrality and general Wannier obstruction.
6. **Review and checkpoint the projector/Bargmann trace crosswalk.** Preserve its explicit
   normalization and ordering premises and do not treat it as mesh or topology validation.
7. **Only then add calculation-specific certificate bridges.** Require frozen exact
   schemas and preserve the producer/verifier/Formal boundaries.

## Nonclaims and explicit deferrals

This inventory does not claim that any KSD result has been formally verified. It does
not treat an equation copied from a protocol as source authority independent of that
protocol. It does not authorize KSD mutation, calculation execution, evidence promotion,
commit, push, publication, or release.

The following remain outside the present Formal boundary unless a later exact certificate
or theorem contract is adopted:

- floating-point arrays, tolerances, eigensolver residuals, fitted values, and plots;
- JSON/schema parsing and SHA-256 file identity;
- producer-independent Python verifier execution;
- Quantum ESPRESSO and Wannier90 execution or convergence;
- continuum, infinite-volume, or infinite-basis limits inferred from finite sweeps;
- scientific/material validity, uncertainty quantification, novelty, or publication
  readiness; and
- human acceptance and protected-action authorization.

## Inspected calculation-document hashes

The following SHA-256 values bind the working-tree bytes used in this first pass:

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
