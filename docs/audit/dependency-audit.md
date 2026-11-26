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
- **Recorded evolution consequences:** Project Koios fixes `U(t)=exp(-itH/ℏ)` by reparameterizing
  PhyslibAlpha's `exp(isH)` group and proves all-time domain-vector derivatives, domain invariance,
  generator commutation, and equality with the evolution generated by the packaged quantum-system
  Hamiltonian.
- **Boundary:** no spectral eigenfunction expansion, numerical propagator, measured time unit, or
  physical-model validation is established.

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
