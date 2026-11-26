# Quantum-mechanics operator API map

This map records declaration-level overlap between the adopted Physlib operator stack and the
Project Koios rigged-test-space bridge. It is an architectural review, not a proof-status ledger or
a claim that the APIs already supply a self-adjoint physically applicable continuum Hamiltonian.

## Revisions inspected

- Project Koios tree: current working tree based on committed `526fbc11772411fab273e662b3b6e4f2eff3b5f4`.
- Physlib package, including `Physlib`, `PhyslibAlpha`, and `QuantumInfo` libraries:
  `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`.
- Mathlib: `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`.

## Ownership decision

Project Koios does **not** introduce a general observable structure or a second unbounded-operator
representation. General complex Hilbert-space operators remain Mathlib `LinearPMap`s,
`H →ₗ.[ℂ] H`. Physlib owns symmetry, closability, self-adjointness, spectra, and state-observable
operations. Project Koios owns only hypotheses and bridge results tied to its declared rigged-space
test carrier.

Local integration declarations mirror the adopted semantic namespace beneath `ProjectKoios`.
For example, extensions of `_root_.QuantumMechanics.SpaceDQuantumSystem` live under
`ProjectKoios.QuantumMechanics.SpaceDQuantumSystem`. The package labels `Physlib` and
`PhyslibAlpha` are dependency tiers, not declaration-namespace components. This convention does not
establish an upstream contribution plan.

The first bridge is implemented in:

- `ProjectKoios/QuantumMechanics/Operator/TestDomain.lean`
- `ProjectKoios/QuantumMechanics/Operator/SelfAdjoint.lean`

## Representation and domain map

| Mathematical role | Adopted declaration | Project Koios declaration | Disposition |
|---|---|---|---|
| Partial linear operator | `LinearPMap`, written `H →ₗ.[ℂ] H` | `testSpaceOperator` constructs one from `A : Φ →ₗ[ℂ] Φ` | Adopt upstream representation; retain constructor bridge. |
| Operator domain | `LinearPMap.domain : Submodule ℂ H` | `testDomain R` and `testSpaceOperator_domain` | Retain the included test-carrier range and identify it with the upstream domain. |
| Dense domain | `LinearPMap.HasDenseDomain` | `testSpaceOperator_dense_domain` | Existing theorem supplies the upstream predicate definitionally. |
| Formal adjoint | `LinearPMap.IsFormalAdjoint` and `LinearPMap.adjoint` (`T†`) | `IsTestSpaceFormalAdjoint`, `isFormalAdjoint_testSpaceOperator`, `testSpaceOperator_le_adjoint` | Retain only the test-space hypothesis and lift it to the upstream relation. |
| Symmetric operator | `LinearPMap.IsSymmetric` | `IsTestSpaceSymmetric`, `testSpaceOperator_isSymmetric` | Local predicate expresses symmetry before inclusion; induced operator uses Physlib directly. |
| Closable densely defined operator | `LinearPMap.IsUnbounded := HasDenseDomain ∧ IsClosable` | `testSpaceOperator_isUnbounded` | Reuse Physlib. The name does not mean “not bounded.” |
| Self-adjoint operator | Mathlib `IsSelfAdjoint`; Physlib lemmas in `Operators.Unbounded` | `testSpaceOperator_isSelfAdjoint_iff_adjoint_domain_eq` | Do not create a local self-adjointness predicate. |
| Essentially self-adjoint operator | `LinearPMap.IsEssentiallySelfAdjoint := IsSelfAdjoint T.closure` | domain criterion and dense-eigenvector specialization in `Operator/SelfAdjoint.lean` | Reuse Physlib; specialize only to included test vectors. |

## Unbounded and self-adjoint operator results

The following Physlib declarations are the primary reusable surface.

| Area | Declaration | Use in Project Koios |
|---|---|---|
| Symmetry/adjoint | `LinearPMap.isSymmetric_iff_le_adjoint` | Converts symmetry to adjoint containment once density is known. Existing local formal-adjoint theorem is more directly suited to paired test operators. |
| Closability | `LinearPMap.IsSymmetric.isClosable` | Establishes closability of symmetric dense test-space operators. |
| Dense closable package | `LinearPMap.IsSymmetric.isUnbounded_iff_hasDenseDomain` | Used by `testSpaceOperator_isUnbounded`. |
| Closure | `LinearPMap.IsSymmetric.closure` | Available after local symmetry and density; no local duplicate is planned. |
| Self-adjoint domain criterion | `LinearPMap.IsSymmetric.isSelfAdjoint_iff` | Used by `testSpaceOperator_isSelfAdjoint_iff_adjoint_domain_eq`. |
| Essential self-adjoint domain criterion | `LinearPMap.IsSymmetric.isEssentiallySelfAdjoint_iff` | Used by the local closure-domain criterion. |
| Defect-number criterion | `LinearPMap.IsSymmetric.isEssentiallySelfAdjoint_of_defectNumber_eq_zero` | Adopt for future continuum domain proofs when deficiency spaces can be controlled. |
| Dense eigenvectors | `LinearPMap.IsSymmetric.isEssentiallySelfAdjoint_of_dense_span_eigenvectors` | Specialized to eigenvectors supplied in the Project Koios test carrier. |
| Range criterion | `LinearPMap.IsSymmetric.isSelfAdjoint_of_range_eq_top` | Candidate route for concrete Hamiltonians via surjectivity of `T ± i`. |
| Self-adjoint consequences | `LinearPMap.IsSelfAdjoint.isSymmetric`, `.isClosed`, `.isUnbounded`, `.isEssentiallySelfAdjoint` | Reuse directly; no Project Koios wrappers planned. |
| Unique extension | `LinearPMap.IsEssentiallySelfAdjoint.unique_self_adjoint_extension` | Reuse when a concrete test-domain operator is proved essentially self-adjoint. |
| Unitary covariance | `LinearPMap.unitaryConj`, `LinearPMap.unitaryConj_isSelfAdjoint` | Candidate basis/frame covariance API; active physical spin rotations still require convention-specific bindings. |

## Spectrum and resolvent map

Physlib's `Operators.SpectralTheory.Basic` already defines:

- `LinearPMap.resolvent`;
- `regularityDomain` and `IsLowerBound`;
- `deficiencySubspace` and `defectNumber`;
- `numericalRange`;
- `resolventSet` and `spectrum`;
- `pointSpectrum`, `residualSpectrum`, and `continuousSpectrum`.

For symmetric operators, `Operators.SpectralTheory.Symmetric` supplies a real numerical range,
reality of the point spectrum, and essential-self-adjointness criteria. For self-adjoint operators,
`Operators.SpectralTheory.SelfAdjoint` supplies:

- `LinearPMap.IsSelfAdjoint.resolventSet_eq_regularityDomain`;
- `mem_resolventSet_of_im_ne_zero`;
- `sub_smul_surjective`;
- `spectrum_real`;
- `residualSpectrum_eq_empty`; and
- `unitaryConj_isSelfAdjoint`.

**Decision:** use these declarations directly. Project Koios should add only theorems connecting a
specific Hamiltonian construction or source convention to them.

## PhyslibAlpha unbounded spectral-theorem stack

PhyslibAlpha builds a continuum spectral layer on the same Mathlib `LinearPMap` and Physlib
self-adjointness predicates. The principal declarations are in
`PhyslibAlpha.ProbabilisticTheory.HilbertSpace.Unbounded`:

| Role | Declaration | Disposition |
|---|---|---|
| Weak-operator PVM | `QuantumMechanics.WOTSpectralMeasure` | Adopt for unbounded spectral theory; do not replace with a local PVM. |
| Stable-to-Alpha bridge | `SpectralMeasure.toWOT` | Converts Physlib's norm-additive `SpectralMeasure` to the weak-operator form. |
| Weak reconstruction | `QuantumMechanics.IsWeakSpectralResolution` | Adopt as the operator-on-domain reconstruction predicate. |
| Self-adjoint spectral data | `QuantumMechanics.SelfAdjointSpectralTheorem` | Adopt; includes self-adjointness and weak reconstruction. |
| Domain-aware spectral data | `QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem` | Adopt; additionally identifies the operator domain with the finite second-moment domain. |
| Self-adjoint spectral measure | `QuantumMechanics.cayleyRealSpectralMeasure` | Upstream construction from a self-adjoint `LinearPMap`. |
| Unbounded spectral theorem | `QuantumMechanics.unboundedSpectralTheorem` | Direct theorem for self-adjoint `LinearPMap`s. |
| Essentially self-adjoint core | `QuantumMechanics.unboundedSpectralTheorem_of_essentiallySelfAdjoint` | Directly applies after the Project Koios dense-eigenvector or future domain proof; no local wrapper is needed yet. |
| Maximal spectral integral | `WOTSpectralMeasure.maximalSpectralIntegral` | Upstream unbounded operator reconstructed from a weak PVM. |
| Measurable spectral integral | `WOTSpectralMeasure.measurableSpectralIntegral` | Upstream functional-calculus surface with explicit domains. |

These declarations correct the narrower conclusion one would reach by inspecting only Physlib's
stable `Operators.SpectralTheory.SpectralMeasure` file. The stable file defines the norm-additive PVM
structure but not its association to a self-adjoint operator; PhyslibAlpha supplies that association,
domain reconstruction, and spectral integrals.

**Decision:** Project Koios will consume the Alpha spectral theorem directly after proving a concrete
operator self-adjoint or essentially self-adjoint. It will not introduce a parallel spectral-theorem
record or spectral-integral construction.

## Expected values and dispersion

| Quantity | Adopted declaration | Boundary |
|---|---|---|
| Expectation | `LinearPMap.expectedValue T ψ : ℝ` | Defined as `re ⟪ψ,Tψ⟫`; it does not require `‖ψ‖ = 1`. |
| Symmetric expectation identity | `LinearPMap.expectedValue_eq_inner` | Used by `testSpaceOperator_inner_eq_expectedValue`. |
| Centered vector | `LinearPMap.centered` | Reuse directly. |
| Variance | `LinearPMap.variance` | Reuse directly from `StateObservables.Variance`; state normalization remains an explicit hypothesis in formulas that need it. |
| Standard deviation | `LinearPMap.standardDeviation` | Reuse directly. |

**Decision:** no Project Koios `Observable`, expectation, variance, or standard-deviation definition
is planned. A physical observable will be represented by a `LinearPMap` together with the required
symmetry or self-adjointness proof.

## Spectral measures and measurements

`Physlib.QuantumMechanics.Operators.SpectralTheory.SpectralMeasure` defines
`SpectralMeasure α H`, a projection-valued `VectorMeasure` with:

- `SpectralMeasure.isStarProjection`;
- `SpectralMeasure.univ`;
- `SpectralMeasure.comp_self`;
- `SpectralMeasure.comp_of_disjoint`;
- `SpectralMeasure.comp_eq_of_inter`; and
- `SpectralMeasure.commute`.

The stable module itself does not construct a spectral measure from a self-adjoint `LinearPMap`.
PhyslibAlpha supplies the continuum construction through `WOTSpectralMeasure`,
`cayleyRealSpectralMeasure`, and `unboundedSpectralTheorem`. It also supplies:

- `WOTSpectralMeasure.scalarMeasure`, the complex matrix-coefficient measure;
- `WOTSpectralMeasure.diagonalMeasure`, the positive vector-state measure;
- `diagonalMeasure_apply_eq_norm_sq`, identifying measurable-event weight with the squared norm of
  the projected vector; and
- `diagonalMeasure_univ`, whose total mass is `‖x‖²` and hence is one for a normalized state.

Therefore:

- adopt stable `SpectralMeasure` where norm-additive PVM data are already available;
- adopt PhyslibAlpha `WOTSpectralMeasure` for unbounded continuum spectral theory;
- reuse the upstream scalar and diagonal measures for Born probabilities rather than defining new
  measures; and
- keep continuum PVM measurements distinct from `QuantumInfo` finite POVMs while documenting any
  later finite-dimensional bridge.

## Quantum-system packaging

`Physlib.QuantumMechanics.QuantumSystem.Basic` defines `QuantumSystem`, bundling a complex Hilbert
space and a self-adjoint Hamiltonian, and `QuantumSystem.mkESA`, which packages the closure of an
essentially self-adjoint operator. The concrete declaration
`ProjectKoios.QuantumMechanics.HarmonicOscillator.oneDimensionalQuantumSystem` now uses this
constructor for the proved one-dimensional oscillator core. A generic test-space operator should
not automatically be promoted to a Hamiltonian.

## Time evolution and Stone APIs

Two upstream layers must be kept distinct.

1. Stable Physlib defines `UnitaryOneParameterGroup` for **norm-continuous** groups of bounded
   operators and proves the bounded-generator correspondence through
   `UnitaryOneParameterGroup.generator`, `ofSelfAdjoint`, and `stoneEquiv`.
2. PhyslibAlpha defines `WOTSpectralMeasure.StrongUnitaryOneParameterGroup` for **strongly
   continuous** groups and constructs `expUnitaryGroup` from a weak spectral measure.
   `DomainAwareSelfAdjointSpectralTheorem.expUnitaryGroup` attaches this group to a self-adjoint
   unbounded operator. The `Flow/Stone`, `Flow/StoneAPI`, and `Flow/StoneInvariance` modules prove
   derivative, generator-domain, and domain-invariance results. The `Existence` subtree develops
   candidate-generator, essential-self-adjointness, and reconstruction ingredients for the converse
   direction.

**Decision:** bounded norm-continuous dynamics use stable Physlib. Continuum unbounded Hamiltonian
dynamics use the PhyslibAlpha domain-aware spectral theorem and strong group. Project Koios must not
collapse these continuity or boundedness regimes.

## Remaining Project Koios gaps

The adopted dependencies provide substantially more than the initial stable-module survey, but
Project Koios still lacks:

1. arbitrary-dimensional oscillator completeness or another route to essential self-adjointness
   beyond the packaged one-dimensional system; the generic `SpaceDQuantumSystem` bridge still
   proves only symmetry and closability on an exact Schwartz core under explicit potential
   hypotheses;
2. essential-self-adjointness infrastructure for physically important singular interactions; the
   unregularized Coulomb bridge currently proves symmetry and dense closability only;
3. a spectral eigenfunction expansion or spectral-coordinate identification for the oscillator;
4. a continuum measurement API connecting normalized Project Koios states to upstream diagonal
   spectral measures; and
5. a bridge from continuum orbitals to Project Koios DFT densities.

The physical convention is fixed in `QuantumMechanics/Evolution/Schrodinger.lean` as
`U(t)=exp(-itH/ℏ)`, implemented by passing `-t/ℏ` to PhyslibAlpha's `exp(isH)` group. The packaged
one-dimensional oscillator closure is bound to the concrete domain-aware Cayley spectral theorem
and this physical evolution in `HarmonicOscillator/SpectralEvolution.lean`.

These are implementation gates, not invitations to add competing abstractions. PhyslibAlpha APIs
are adopted dependencies but remain Alpha surfaces; compatibility does not establish physical
semantics or long-term upstream stability.

## Next admissible additions

1. Use the adopted `SpaceDQuantumSystem` and Schwartz-core convention recorded in
   `api-maps/continuum-schrodinger.md`; do not introduce another continuum carrier.
2. Continue the checked dense-eigenstate route for the continuum harmonic oscillator beyond
   `d = 1`; the one-dimensional result is unconditional through direct pointwise Fourier-integral
   injectivity, while higher dimensions may require a tensor-product route or another adopted
   range, defect-number, analytic-vector, or perturbation criterion.
3. Build continuum measurement semantics from the concrete spectral measure without conflating a
   diagonal measure with a normalized state or a POVM outcome API.
4. Pursue a spectral eigenfunction expansion only after choosing and proving the required spectral
   coordinate transform; the domain-aware measure alone does not identify Hermite coefficients.
5. Keep the continuum-to-DFT density claim blocked until the orbital carrier, evaluation semantics,
   integrability, and occupation conventions are explicit.
