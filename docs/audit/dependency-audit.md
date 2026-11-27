# Dependency audit

This audit records the selected immutable Lean, Mathlib, and Physlib dependency identities.

| Decision ID | Decision |
|---|---|
| [`AUD-DEP-001`](#aud-dep-001) | selected Lean/Mathlib/Physlib toolchain identity |
| [`AUD-DEP-002`](#aud-dep-002) | selected Mathlib API roles |
| [`AUD-DEP-003`](#aud-dep-003) | Physlib package adoption and compatibility boundary |
| [`AUD-DEP-004`](#aud-dep-004) | Laurent-polynomial obstruction requires no new dependency |
| [`AUD-DEP-005`](#aud-dep-005) | LeanCondensedMatter inspected as proof provenance, not adopted |

<a id="aud-dep-001"></a>

## Selected toolchain (`AUD-DEP-001`)

The repository uses one pinned Lean, Mathlib, and Physlib-compatible toolchain.

- Lean: `leanprover/lean4:v4.36.0`
- Mathlib: `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`
- Physlib package: `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`
- Physlib libraries available from that package: `Physlib`, `PhyslibAlpha`, and `QuantumInfo`
- Transitive revisions: `lake-manifest.json`
- Generated state: `.lake/`, ignored

All direct dependencies are pinned to immutable commits. The manifest records immutable resolved
commits for every transitive dependency, even where an upstream package declares a branch input.

<a id="aud-dep-002"></a>

## Mathlib selections (`AUD-DEP-002`)

Current modules reuse the following APIs.

- Finite Hermitian spectra: `Matrix.IsHermitian.eigenvalues`, `eigenvectorUnitary`, and `conjStarAlgAut_star_eigenvectorUnitary` from `Mathlib.Analysis.Matrix.Spectrum`.
- Ordered Hermitian perturbation: symmetric-map eigenbases, Birkhoff--von Neumann decomposition of doubly stochastic matrices, finite rearrangement inequalities, orthonormal-basis Parseval identities, adjoints, and basis-independent trace/Hilbert--Schmidt sums from pinned Mathlib's `Spectrum`, `Birkhoff`, `Rearrangement`, and `Trace` modules.
- Matrix and block algebra: finite multiplication, `Matrix.fromBlocks`, conjugate transpose, Hermitian predicates, `Complex.normSq`, and complex exponential norm identities.
- Fourier algebra: finite additive characters, orthogonality, and Pontryagin duality.
- Normalized product-torus integration: `UnitAddCircle`, its standard total-mass-one Haar measure, finite product measures, `integral_fintype_prod_eq_prod`, and `integral_fintype_prod_eq_pow` from pinned Mathlib's `IntervalIntegral.Periodic` and `Integral.Pi` modules.
- Zeroth-Bessel integral: Mathlib's `Complex.besselJ`, `regularizedHGFun`, `Gamma_nat_eq_factorial`, cosine-power integrals, dominated convergence for interval integrals, exponential-series summation, periodic interval translation, and `UnitAddCircle.intervalIntegral_preimage`. Pinned Mathlib does not itself expose the resulting full-angle or normalized-circle `J₀` theorem.
- Quantum partial operators: Mathlib `LinearPMap`, formal adjoints, maximal adjoints, closedness, and closability APIs.

The spectral construction is exact and noncomputable. It is not an eigensolver or numerical certificate. Local Pauli and tetrahedral matrices encode model conventions absent from the inspected generic APIs.

<a id="aud-dep-004"></a>

## Laurent-polynomial projection obstruction (`AUD-DEP-004`)

The selected Ragasa2026b algebraic slice requires a complex Laurent polynomial indexed by
`ℤ`, exact convolution coefficients, finite coefficient support, support containment under
multiplication, and maximum-support arguments. The pinned Mathlib revision supplies these
through `LaurentPolynomial`, `AddMonoidAlgebra.coeff_mul`,
`AddMonoidAlgebra.support_coeff_mul_subset`, `Finsupp.support_nonempty_iff`,
`Finset.max'_mem`, `Finset.le_max'`, and pointwise addition of finite supports.
`Mathlib.Algebra.MonoidAlgebra.Degree` was inspected for support/degree infrastructure, but
no specialized theorem was found that directly excludes a Laurent-polynomial square whose
largest nonzero exponent is odd. The repository-owned private helper proves only the needed
extreme-coefficient convolution fact, while public `BG-PROJECTION-THM-002` preserves the
source assumption `Δt ≠ 0`.

`LaurentPolynomial.C`, `LaurentPolynomial.T`, and standard `2 × 2` matrix notation encode
the parent exactly. `BG-PROJECTION-THM-001` verifies its square directly. For the
unit-circle bridge, Mathlib supplies `LaurentPolynomial.eval₂`,
`LaurentPolynomial.exists_T_pow`, `Polynomial.eq_zero_of_infinite_isRoot`,
`Set.Icc_infinite`, and `Circle.exp_injOn_Icc`. `BG-PROJECTION-THM-003` composes these to
prove the exact Laurent-evaluation injectivity needed by the paper proof. The remaining
projector identities use only matrix/scalar ring algebra and the already proved parent
square. No Physlib API is needed, no new dependency is adopted, and these declarations are
not proposed upstream in the current work.

<a id="aud-dep-005"></a>

## LeanCondensedMatter source inspection (`AUD-DEP-005`)

`naoki-cpp/LeanCondensedMatter` is not adopted as a package dependency. Its immutable inspection
identity and the Apache-2.0 attribution for the local full-angle `J₀` proof architecture are recorded
as [`AUD-SRC-011`](source-library-provenance.md#aud-src-011).

<a id="aud-dep-003"></a>

## Physlib compatibility and adoption (`AUD-DEP-003`)

Physlib is adopted at an immutable revision compatible with Lean 4.36.0 and the selected Mathlib
commit.

- Repository: `https://github.com/leanprover-community/PhysLib.git`
- Revision: `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`
- Lean: 4.36.0
- Resolved Mathlib: `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`

### Compatibility decision

- **Migration adjustments:** in the exact-source-tree probe, two proof steps became redundant under
  changed simplification, and four definitions depending on noncomputable losses received explicit
  `noncomputable` markers.
- **Representative API imports:** the probe covered unbounded operators, self-adjoint spectral
  theory, spectral measures, expected values, Sobolev and tensor-product Hilbert spaces,
  three-dimensional angular momentum, Alpha spin-half and spin-orbit APIs, POVMs, CPTP channels,
  and entanglement.
- **Confirmed declarations:** `unboundedSpectralTheorem`,
  `unboundedSpectralTheorem_of_essentiallySelfAdjoint`,
  `DomainAwareSelfAdjointSpectralTheorem.expUnitaryGroup`, and
  `UnitaryOneParameterGroup.stoneEquiv` were present at the pinned revision.
- **Validation evidence:** current affected-target and repository-wide results are recorded as
  [`AUD-VAL-001`](trusted-base-audit.md#aud-val-001) through
  [`AUD-VAL-009`](trusted-base-audit.md#aud-val-009).
- **Boundary:** compatibility checks establish package and import compatibility, not semantic
  fitness for a particular Project Koios declaration.

### Adopted binding evidence

#### Finite quantum information

- **Adopted APIs:** `KetUpToPhase`, `MState`, `POVM`, `ProbDistribution`, and `CPTPMap` from
  `QuantumInfo`.
- **Recorded consequences:** pure-ray density matrices, POVM probabilities, CPTP composition,
  measurement-discard classicalization, tensor products, partial traces, product channels, and the
  pure-state separability criterion.
- **Validation:** see [`AUD-VAL-007`](trusted-base-audit.md#aud-val-007).
- **Boundary:** the binding introduces no competing carriers and establishes neither
  source-postulate fidelity nor physical applicability.

#### Angular momentum and finite spin orbit

- **Adopted APIs:** stable Physlib's three-dimensional Cartesian orbital-angular-momentum operators
  and PhyslibAlpha's standard spin-half and spin-orbit representations.
- **Recorded consequences:** exact Schwartz domains, domain invariance, symmetry, dense closability,
  Cartesian commutators with `Constants.ℏ`, the Project Koios/Physlib Pauli crosswalk,
  `Jᵢ=σᵢ/2`, dimensionless finite `L·S` eigenvalues, the spin-half doublet, and Landé's interval
  rule.
- **Validation:** see [`AUD-VAL-008`](trusted-base-audit.md#aud-val-008).
- **Boundary:** the binding proves no essential self-adjointness for the continuum operators, no
  continuum identification of the finite `ℏ=1` representation, and no dimensional or DFT
  spin-orbit Hamiltonian.

#### Global spin frames and induced rotations

- **Adopted APIs:** Mathlib's `SU(2)` and special-orthogonal matrix groups together with
  PhyslibAlpha's `StandardModel.su2AdjointMatrix` and its checked multiplication, inverse,
  orthogonality, and Pauli-conjugation identities.
- **Recorded consequences:** an exact `SU(2) → SO(3)` group homomorphism, determinant one for the
  induced real rotation, covariance of the ordered Pauli basis, and active column-oriented
  covariance of orbital-valued Pauli coefficients.
- **Validation:** see [`AUD-VAL-016`](trusted-base-audit.md#aud-val-016) and
  [`AUD-VAL-017`](trusted-base-audit.md#aud-val-017).
- **Boundary:** this finite global-frame binding proves neither surjectivity nor the double-cover
  kernel, and introduces no position-dependent spin frame, continuum spin density, DFT binding, or
  dimensional spin--orbit Hamiltonian.

#### Finite pointwise spinor density matrices

- **Adopted APIs:** Mathlib complex matrices, `Matrix.PosSemidef`,
  `Matrix.posSemidef_vecMulVec_self_star`, finite sums, and matrix trace. QuantumInfo was inspected
  for its finite normalized-state and positive-matrix conventions; its `MState` carrier is not used
  because a local spin-density matrix generally has trace `n(r)`, not trace one.
- **Recorded consequences:** pointwise spinor outer products and cross outer products,
  real-occupation-weighted finite sums, Hermiticity, positive semidefiniteness under nonnegative
  occupations, exact trace formulas, and the exact outer-product difference decomposition.
- **Validation:** see [`AUD-VAL-031`](trusted-base-audit.md#aud-val-031),
  [`AUD-VAL-032`](trusted-base-audit.md#aud-val-032), and the bounded stability descendant
  [`AUD-VAL-036`](trusted-base-audit.md#aud-val-036) through
  [`AUD-VAL-038`](trusted-base-audit.md#aud-val-038).
- **Boundary:** this layer has no measure space, `Lᵖ` carrier, spatial basis, integration,
  discretization error, convergence, or physical normalization claim.

#### Representative-safe continuum spin density

- **Adopted APIs:** the separate finite pointwise spinor density algebra, Mathlib matrix-valued
  `Lp`, continuous-linear-map composition on `Lp`, `ContinuousLinearMap.holder`/`holderL` for the
  `L² × L² → L¹` Hölder product, Mathlib `HilbertBasis` and rank-one continuous maps for countable
  partial-sum projections, `lp.norm_rpow_eq_tsum` for Parseval and the orthonormal Pythagorean
  identity for exact coefficient-tail residuals, complex matrix trace and Hermiticity, and the pinned
  PhyslibAlpha-backed global `SU(2)` frame and Pauli algebra.
- **Recorded consequences:** matrix-valued complex `L¹` spin-density classes, active continuum
  rotation and group laws, almost-everywhere Hermiticity, positive semidefiniteness under explicit
  nonnegative occupations, and global collinearity, particle and Pauli magnetization traces,
  particle-density invariance, induced `SO(3)` magnetization covariance, exact representative-safe
  Pauli reconstruction, occupation-weighted spinor outer-product densities, explicit
  componentwise/full-matrix/fixed-occupation-family `L² → L¹` error bounds, explicit finite-index
  continuum-spinor reconstruction from supplied basis functions and coefficients, an idempotent
  strongly complete projection contract, its canonical construction from a countable Mathlib
  Hilbert basis, a concrete one-dimensional oscillator/Hermite eigenstate instance, and convergence
  transfer to matrix, particle, and magnetization densities, exact coefficient-tail orbital errors,
  projection norm contraction, full matrix-density tail error budgets, and positive-real-exponent
  cutoff rates from supplied summable global weighted coefficient moments. The moment comparison
  reuses Mathlib `Summable.tsum_le_tsum_of_inj` and `Real.rpow_le_rpow`. For the oscillator selected
  closure domain, the coordinate identity reuses Physlib's eigenstate equation, `LinearPMap.le_closure`,
  and self-adjointness/symmetry; Hamiltonian-image Parseval derives the summable `p=2` moment and
  inverse-linear orbital/full matrix-density error bounds rather than assuming a moment budget.
- **Source adaptation:** candidate literature record [`AUD-SRC-001`](source-literature.md#aud-src-001)
  supplies Ullrich equations (3)--(5); the formal carrier uses equivalence classes and explicit
  real occupations rather than unqualified pointwise fields.
- **Validation:** see [`AUD-VAL-031`](trusted-base-audit.md#aud-val-031) and
  [`AUD-VAL-032`](trusted-base-audit.md#aud-val-032) for the separated finite/continuum tree, plus
  [`AUD-VAL-036`](trusted-base-audit.md#aud-val-036) through
  [`AUD-VAL-056`](trusted-base-audit.md#aud-val-056) for the Hölder stability, finite-family
  convergence-transfer, finite-basis reconstruction, projection-contract, Hilbert-basis, and
  oscillator/Hermite descendants. Quantitative truncation identities and full density-tail budgets
  are validated separately in [`AUD-VAL-061`](trusted-base-audit.md#aud-val-061) through
  [`AUD-VAL-064`](trusted-base-audit.md#aud-val-064). Conditional weighted-moment rates and cutoff
  guarantees are validated in [`AUD-VAL-065`](trusted-base-audit.md#aud-val-065) through
  [`AUD-VAL-068`](trusted-base-audit.md#aud-val-068). The selected oscillator closure-domain
  moment derivation and rates are validated in
  [`AUD-VAL-069`](trusted-base-audit.md#aud-val-069) through
  [`AUD-VAL-072`](trusted-base-audit.md#aud-val-072). Identification with the domain-valued partial
  sums used for graph-norm and energy-expectation convergence is validated in
  [`AUD-VAL-073`](trusted-base-audit.md#aud-val-073) through
  [`AUD-VAL-076`](trusted-base-audit.md#aud-val-076).
- **Boundary:** no occupation constraint is inferred; the finite-basis reconstruction map does not
  identify a Kohn--Sham or numerical basis with the adopted Mathlib Hilbert-basis carrier; only the
  one-dimensional oscillator eigenstate family is currently bound. No coefficient provenance,
  varying-occupation convergence, representability converse, local frame, exchange-correlation
  functional/potential, continuum SOC Hamiltonian, numerical Hamiltonian-norm certificate, or
  physical applicability is inferred.

#### Continuum spinor-to-scalar Kohn--Sham density binding

- **Adopted APIs:** the existing real scalar `ContinuumDensity`, its orbital-density construction,
  the representative-safe quantum-mechanics continuum spin-density matrix and basis-convergence
  layers, Mathlib `Complex.reCLM`, and continuity of the `L¹` integral.
- **Recorded consequences:** real `L¹` particle densities from two-component complex `L²` spinors,
  finite real-occupation-weighted sums, almost-everywhere nonnegativity under explicit
  nonnegative occupations, exact equality between the complex matrix trace and the complexification
  of the scalar density, and density-integral/particle-number identities under explicit spinor
  normalization and occupation-sum hypotheses, transfer of matrix-density convergence to real
  scalar-density convergence, generic Hilbert-basis and oscillator/Hermite convergence, and
  particle-number integral convergence, exact weighted coefficient-tail integral deficits, and
  integral upper bounds under nonnegative occupations. These bounds do not order densities
  pointwise and do not imply energy convergence or computed numerical tail certificates.
  Summable global coefficient-moment budgets now additionally yield inverse-power integral-deficit
  rates and sufficient tolerance cutoff conditions. Their summability and bounds remain supplied
  in the generic layer. For the concrete oscillator, actual selected-closure-domain components now
  derive the `p=2` moment and yield an explicit inverse-square particle-number deficit in terms of
  squared Hamiltonian-image norms, with nonnegative fixed occupations. This is not an
  energy-expectation identity, numerical certificate, or converse domain characterization.
- **Validation:** see [`AUD-VAL-031`](trusted-base-audit.md#aud-val-031) through
  [`AUD-VAL-033`](trusted-base-audit.md#aud-val-033) for the original trace/normalization bridge and
  [`AUD-VAL-057`](trusted-base-audit.md#aud-val-057) through
  [`AUD-VAL-060`](trusted-base-audit.md#aud-val-060) for finite-basis convergence and integral transfer;
  [`AUD-VAL-061`](trusted-base-audit.md#aud-val-061) through
  [`AUD-VAL-064`](trusted-base-audit.md#aud-val-064) for exact truncation deficits and tail identities;
  [`AUD-VAL-065`](trusted-base-audit.md#aud-val-065) through
  [`AUD-VAL-068`](trusted-base-audit.md#aud-val-068) for moment-conditioned rates and cutoff guarantees;
  [`AUD-VAL-069`](trusted-base-audit.md#aud-val-069) through
  [`AUD-VAL-072`](trusted-base-audit.md#aud-val-072) for oscillator-domain-derived inverse-square deficits.
- **Boundary:** this continuum binding does not derive normalization or occupation sums, identify
  the oscillator basis as a Kohn--Sham eigenbasis, or add an exchange-correlation functional,
  effective potential, self-consistency equation, continuum SOC Hamiltonian, representability
  theorem, or scientific-applicability claim.

#### Continuum Schrödinger and hydrogenic operators

- **Adopted carrier:** Physlib's `SpaceDQuantumSystem` is reused unchanged.
- **Validation:** see [`AUD-VAL-001`](trusted-base-audit.md#aud-val-001).
- **Recorded consequences:** symmetry of the Schwartz-core momentum square and kinetic operator;
  exact Hamiltonian domain under an explicit maximal-potential-domain inclusion; dense closability
  for temperate real potentials; and exact `L²` or almost-everywhere action on Schwartz-domain
  wavefunctions.
- **Hydrogenic specialization:** Physlib's unregularized `-k/‖x‖` Hamiltonian is symmetric and
  densely closable using its polynomially bounded Schwartz subdomain.
- **Boundary:** no exact singular-potential domain, essential-self-adjointness theorem for the
  Coulomb operator, spectrum, or physical hydrogen validation is inferred.

#### One-dimensional oscillator, spectral theorem, and evolution

The [pinned upstream-reuse audit](../api-maps/harmonic-oscillator.md) maps the twelve local modules
to exact adopted/candidate APIs. The selected continuum Hamiltonian and eigenstates are already
Physlib's; domain awareness is not a competing local framework. Alpha's public Schwartz ladder and
anisotropic-vacuum modules compile at the current pin (bounded dependency target probe: 6,723 jobs).
The raw sequence module also compiles, but the inspected advertised `aLin` and `coherentState_ℓ2`
names are private, not public adapter targets. A scratch kernel-checked coefficient-map identity
identifies genuine legacy Hermite-polynomial duplication; no public definition/ID migration or new
API adoption is performed. See [`AUD-VAL-096`](trusted-base-audit.md#aud-val-096) through
[`AUD-VAL-098`](trusted-base-audit.md#aud-val-098) for the bounded source, probe, and documentation
checks. This adds no package/dependency change or full-build claim.

- **Validation:** see [`AUD-VAL-002`](trusted-base-audit.md#aud-val-002) through
  [`AUD-VAL-005`](trusted-base-audit.md#aud-val-005) for affected targets and
  [`AUD-VAL-009`](trusted-base-audit.md#aud-val-009) for the exact convention-root repository-wide
  build.
- **Recorded continuum consequences:** the general essential-self-adjointness theorem remains
  conditional on a checked `d`-dimensional eigenstate dense-span premise. In dimension one, the
  legacy eigenfunctions are transported across an explicit `L²` carrier equivalence, and the
  integral-form Plancherel premise is replaced by checked pointwise Fourier-integral injectivity,
  yielding unconditional completeness and essential self-adjointness.
- **Recorded spectral consequences:** PhyslibAlpha's Cayley-transform spectral measure is selected
  for the exact self-adjoint closure; its domain-aware spectral theorem and weak reconstruction are
  proved.
- **Recorded coefficient-regularity consequences:** Physlib's core eigenstate equation and
  `LinearPMap.le_closure` transfer the eigenstate equation to the exact selected closure; symmetry
  and Mathlib Hilbert-coordinate Parseval identify `‖H̄ψ‖² = ∑ Eₖ²|cₖ|²` for actual domain vectors.
  The physical convention `Eₖ = ℏω₀(k+1/2)` yields a derived summable `p=2` moment bounded by
  `4‖H̄ψ‖²/(ℏω₀)²`. See [`AUD-VAL-069`](trusted-base-audit.md#aud-val-069) through
  [`AUD-VAL-072`](trusted-base-audit.md#aud-val-072). No alternate operator or spectral abstraction
  is introduced.
- **Recorded graph/energy consequences:** the same oscillator coefficient truncation is now lifted
  into the actual selected closure domain. Its Hamiltonian image equals the partial sum of `H̄ψ`,
  giving `‖Pₙψ-ψ‖ + ‖H̄Pₙψ-H̄ψ‖ → 0` for domain targets. Inner-product continuity yields convergence
  of Physlib `LinearPMap.expectedValue`, reused directly from
  `Physlib/QuantumMechanics/Operators/StateObservables/ExpectedValue.lean`. Nonzero targets give
  eventual nonzero partial sums and convergent Rayleigh quotients; unit-norm domain targets give
  convergence of norm-rescaled partial-sum energy expectations. The genuinely summable first energy
  moment now identifies discarded raw energy exactly; positive ordered oscillator eigenvalues and
  Hamiltonian-image Parseval give the bound `‖H̄ψ‖²/E_N`. Normalized energy bounds explicitly use a
  positive retained squared-norm lower bound and retain the normalization-defect term. Both raw and
  normalized bounds supply sufficient algebraic tolerance-cutoff conditions, not numerical cutoff
  selection or norm/energy certificates. No competing expectation carrier
  or bundled graph-space/operator abstraction is introduced. See
  [`AUD-VAL-073`](trusted-base-audit.md#aud-val-073) through
  [`AUD-VAL-076`](trusted-base-audit.md#aud-val-076) for graph/energy convergence and
  [`AUD-VAL-077`](trusted-base-audit.md#aud-val-077) through
  [`AUD-VAL-080`](trusted-base-audit.md#aud-val-080) for quantitative discarded-energy identities,
  retained-norm-safe normalized bounds, cutoff conditions, and their targeted/audit/document checks.
- **Recorded finite-compression consequences:** the existing
  `retainedHarmonicOscillatorHamiltonian` is reused unchanged, mapped from `ℝ` to `ℂ` at scale `ℏω₀`.
  Mathlib `Orthonormal.inner_sum` and `LinearMap.isometryOfInner` supply a Euclidean coefficient
  isometry with an explicit selected-closure-domain lift. `Matrix.toEuclideanCLM` reuses the finite
  matrix action, and `LinearIsometry.adjoint_comp_self` gives exact adjoint compression. Intertwining,
  equal quadratic energies, and equality to the existing `K+1`-term domain partial sum are proved.
  See [`AUD-VAL-081`](trusted-base-audit.md#aud-val-081) through
  [`AUD-VAL-085`](trusted-base-audit.md#aud-val-085) for affected-target, new repository-wide,
  axiom/admission, and schematic/document evidence. No alternate Hamiltonian, full-space resolution
  of identity, sampled-grid/quadrature/float binding,
  or numerical eigensolver claim is introduced.
- **Recorded finite-residual consequences:** eigenpair residuals of that same retained matrix
  reuse the exact domain-safe intertwining and Euclidean isometry for continuum transport and
  residual norm equality. Mathlib `PiLp.norm_eq_of_L2` supplies coordinatewise norm comparison,
  `Finite.exists_min` gives a nearest retained energy, and `Orthonormal.inner_right_fintype` extracts
  the selected coefficient. Unit coefficient norm is explicit for energy proximity. A positive
  gap from the trial energy to every other retained level controls the orthogonal component without
  a normalization assumption; this is not a phase-fixed eigenvector error or an omitted continuum
  tail bound. The existing finite `OrthogonalCompression` residuals compare operators, not eigenpairs,
  and are not duplicated. Those analytic lemmas alone do not implement a numerical residual checker
  or authenticate solver reports. Validation is recorded at
  [`AUD-VAL-086`](trusted-base-audit.md#aud-val-086) through
  [`AUD-VAL-090`](trusted-base-audit.md#aud-val-090).
- **Recorded exact-data residual checking:** `FiniteResidualCertificate` consumes rational
  real/imaginary components, rational scale endpoints and trial energy, and a claimed raw squared
  budget `B`. The checker computes mass `S` and the maximum squared endpoint error sum; acceptance
  requires positive mass, ordered endpoints, nonnegative `B`, and a sum at most `B`. Mathlib
  `Complex.sq_norm`, `EuclideanSpace.norm_sq_eq`, and `abs_le_max_abs_abs` connect those computations
  to the actual finite residual only under a separately proved enclosure of physical `ℏω₀`.
  Mathlib `NormedSpace.normalize`, `Real.le_sqrt`, and the existing domain-safe isometry/residual
  bridge yield a unit continuum vector, normalized residual at most `sqrt (B/S)`, and retained-level
  proximity. Synthetic accepted/rejected cases use `decide +kernel`; no native-computation proof
  primitive, parser, float/solver-data binding, enclosure producer, gap checker, or new operator/state
  abstraction is adopted. See [`AUD-VAL-091`](trusted-base-audit.md#aud-val-091) through
  [`AUD-VAL-095`](trusted-base-audit.md#aud-val-095) for validation and exact fixture execution.
- **Recorded evolution consequences:** Project Koios fixes `U(t)=exp(-itH/ℏ)` by reparameterizing
  PhyslibAlpha's `exp(isH)` group and proves all-time domain-vector derivatives, domain invariance,
  generator commutation, and equality with the evolution generated by the packaged quantum-system
  Hamiltonian.
- **Boundary:** no identification of the Hilbert eigenbasis with the selected Cayley spectral
  measure, converse closure-domain characterization, Kohn--Sham total-energy convergence,
  numerical propagator or unrestricted continuum Hamiltonian-moment/energy-expectation certificate,
  measured time unit, or physical-model
  validation is established. Normalized finite-cutoff energy interpretation is eventual for
  nonzero targets or at a selected cutoff with the required positive retained-norm bound; no
  unit-vector claim is made about vanishing early cutoffs and no normalized-energy monotonicity
  theorem is asserted.

The previous Lean 4.35.0 probe of Physlib revision
`adc97f054083132000567cb09ff8f7b1f073400d` remains historical evidence only. It is not the adopted
revision.

## Conclusion

- Physlib is now an explicit pinned dependency.
- `PhyslibAlpha` and `QuantumInfo` are libraries of the same pinned package, not separate Lake
  dependencies.
- Existing Project Koios declarations continue to compile against the upgraded Mathlib revision.
- New quantum-mechanics layers must inspect and reuse the adopted Physlib and QuantumInfo APIs rather
  than create competing abstractions.
- Import compatibility does not establish source fidelity, physical applicability, or upstream
  contribution readiness.
