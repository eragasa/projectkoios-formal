# Harmonic-oscillator upstream reuse and remaining bridges

This is a bounded API/reuse audit, not a new oscillator formalization or a claim of mathematical
novelty. The declaration manifest remains authoritative for repository theorem status. This pass
changes documentation only: no Lean declarations, dependency pins, or namespace roots are changed.

## Identity and scope

| Surface | Inspected identity and limits |
|---|---|
| Formal | `projectkoios-formal`, branch `review/conjugate-linear-coordinate-algebra`, base HEAD `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; pre-existing dirty/untracked work preserved; not an immutable snapshot |
| Mathlib | commit `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`; detached, source checkout clean; read-only inspection |
| Physlib package | commit `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`; detached, source checkout clean; includes `Physlib` and `PhyslibAlpha`; read-only source inspection |
| Toolchain | Lean `4.36.0`, commit `611c117bfaf7b7ae1cfcf246ce6fba31e8f509e9`; Lake `5.0.0-src+611c117`; dependency lock unchanged |
| Local scope | all twelve `HarmonicOscillator/*.lean` modules' declaration/import inventory, with focused inspection of the continuum, basis, packaging, spectral, finite, and certificate bridges; the generic spin-density Hilbert adapter where it supplies shared expansion semantics |
| Upstream scope | Physlib's Cartesian and legacy one-dimensional oscillator modules, `Mathematics/SpecialFunctions/PhysHermite.lean`, Alpha's oscillator ladder/vacuum and raw sequence files, the relevant Alpha ladder-system interfaces, and named Mathlib APIs below |

Searches also checked oscillator-related paths across the pinned package. Classical oscillator and
Sinc/Duhamel Cauchy-data APIs are not quantum Hilbert-space Hamiltonian replacements. This is not an
exhaustive search of every possible equivalent lemma or a review of newer revisions. Dependency
build products were populated through Lake; no owner source was edited or dependency updated.

## Domain handling is already upstream

There is no general superiority claim for a local "domain-aware approach" over Physlib or Alpha.
Different upstream layers address different mathematical questions:

| Layer | Actual carrier and reuse decision |
|---|---|
| Physlib Cartesian oscillator | `QuantumMechanics.HarmonicOscillator d`, `Q.HS = SpaceDHilbertSpace d`, and `Q.hamiltonian : Q.HS →ₗ.[ℂ] Q.HS`; reuse the explicit partial-operator domain |
| Physlib/Alpha Schwartz ladder system | `Q.loweringCLM` and `Q.raisingCLM` preserve Schwartz space; Alpha's `Q.toLadderSystem` bundles these same operators as algebraic endomorphisms of that invariant carrier |
| Alpha vacuum | `Q.vacuumGaussian : 𝓢(Space d, ℂ)` and `Q.hasVacuum_vacuumGaussian`; an anisotropic, nonzero annihilated Gaussian, not by itself a normalized Hilbert basis or completeness proof |
| Alpha unbounded spectral/evolution library | selected through the actual self-adjoint closure and its domain-aware theorem; already reused by `SpectralEvolution.lean` |
| Alpha raw sequence oscillator | source algebra on `ℕ → ℂ` and a coherent-state `ℓ²` construction; not a continuum-domain theorem or a bounded operator on all `ℓ²`; see the public-export limitation below |

Unitary evolution may act on all Hilbert vectors while its generator/derivative statements require
operator-domain membership. A vector's `L²` membership alone does not justify applying the unbounded
Hamiltonian. Conversely, algebra on an invariant Schwartz carrier need not repeat a domain subtype
at every operation. These are compatible upstream designs, not competing physical models.

## Reuse and local responsibility

Paths in the upstream column are relative to the pinned package or Mathlib repository above.
Declaration names, not an informal module description alone, determine the fit.

| Local module | Upstream reuse and exact local responsibility |
|---|---|
| `Continuum.lean` | Reuses Physlib `HarmonicOscillator/Basic.lean`, `NumberOperator.lean`, and `Eigenstates.lean`: `Q.hamiltonian`, Schwartz inclusion/action/inner-product identities, `Q.eigenstate`, `Q.eigenstates_orthonormal`, and `Q.hamiltonian_eigenstate`. Adds the exact core-domain statement, domain-safe symmetry/closability bridge, legacy-to-Cartesian carrier equivalence, and checked dimension-one density/essential self-adjointness. |
| `QuantumSystem.lean` | Uses Physlib `QuantumSystem.mkESA` only after the local checked essential-self-adjointness proof. `(oneDimensionalQuantumSystem Q).ℋ = Q.hamiltonian.closure` is `rfl`; no alternate self-adjoint extension or Hamiltonian is selected. |
| `SpectralEvolution.lean` | Selects the existing Alpha Cayley spectral measure/theorem, including `unboundedSpectralTheorem_of_essentiallySelfAdjoint`, and the shared physical-time adapter. Does not introduce a spectral-measure or strong-group abstraction. |
| `HilbertBasis.lean` | The family is directly `Q.eigenstate (fun _ => n)`. Mathlib `HilbertBasis.mk`, `hasSum_repr`, coefficient inner products, and Parseval supply the expansion infrastructure. Local statements transfer the actual core action to its closure, derive domain-conditioned coefficient moments, and connect the same partial sums to graph norm, Physlib `LinearPMap.expectedValue`, and cutoff-energy bounds. |
| `FiniteLadder.lean` | Exact finite matrices and their highest-retained-state commutator defect. These are not a second continuum oscillator and do not inherit an infinite-dimensional commutator by deleting its boundary term. A continuum ladder compression crosswalk is not supplied here. |
| `TruncationDistortion.lean` | Exact matrix-compression nonmultiplicativity and the finite ladder-product Hamiltonian boundary defect. Retains the distinction between the direct diagonal Hamiltonian and its finite ladder-product reconstruction. |
| `HermiteEigenfunction.lean` | Historical real-polynomial, unnormalized dimensionless pointwise interface. There is genuine polynomial overlap with Physlib `Polynomial.physHermite`; see the checked candidate bridge below. It is not the carrier or eigenstate definition used by the continuum chain. |
| `FiniteSpectralCompression.lean` | Reuses the existing diagonal matrix, actual Physlib-derived eigenstate basis, Mathlib `Orthonormal.inner_sum`, `LinearMap.isometryOfInner`, `Matrix.toEuclideanCLM`, and `LinearIsometry.adjoint_comp_self`. Adds an explicit domain lift, intertwining, compression, quadratic-energy equality, and the `K+1`-term partial-sum crosswalk. |
| `FiniteSpectralResidual.lean` | Reuses that exact compression plus Mathlib Euclidean norm identities, finite minimum selection, orthonormal coefficient extraction, and `NormedSpace.normalize`. Adds the application-specific residual transport, retained-level proximity, and explicitly gap-conditioned orthogonal-component bounds. |
| `FiniteResidualCertificate.lean` | Reuses the same residual and carrier; exact rational real/imaginary data are mapped into complex Euclidean coefficients. Mathlib complex norm squares, endpoint absolute-value bounds, and normalization connect checked finite arithmetic to conditional continuum guarantees. It does not implement a second Hamiltonian, rational-complex field, parser, or physical-scale enclosure producer. |
| `FiniteDifference.lean` | A source-neutral finite kinetic stencil and sampled diagonal potential, with exact symmetry proofs. Not identified with the continuum operator or the Hermite-basis spectral compression. |
| `FiniteComparison.lean` | Finite real sampled Gram/injection/pullback algebra under an explicit exact Gram-normalization premise. It does not establish continuum completeness, quadrature accuracy, or sampled-state identification. |

The generic `SpinDensity/HilbertBasis.lean` adapter already uses Mathlib's `HilbertBasis.hasSum_repr`
for strong convergence and rank-one continuous maps for finite projections. The oscillator binding
instantiates that existing infrastructure; it does not prove a second generic Hilbert expansion
or identify a numerical/KS basis with the oscillator by definition.

### Why the dimension-one local proof still has a role

At this pin, Physlib `HarmonicOscillator/Basic.lean:335–348` contains
`hamiltonian_essentially_self_adjoint : InformalLemma` and
`toQuantumSystem : InformalDefinition`. The probe verifies those types: they are metadata, not
proofs of essential self-adjointness or a bundled quantum system to substitute for the checked
construction.

The legacy `OneDimension/Completeness.lean:eigenfunction_completeness` has an explicit integral-form
Plancherel hypothesis. The local final density argument instead reuses upstream orthogonality and
Fourier-zero infrastructure with checked pointwise Fourier injectivity. Neither an informal
statement nor the legacy theorem with its premise omitted replaces that proof. The conditional
higher-dimensional dense-span gate remains unchanged.

## Concrete duplication and the smallest next refactor

Physlib already defines the **physicists'** Hermite polynomials in
`Physlib/Mathematics/SpecialFunctions/PhysHermite.lean:64`, over `ℤ`, and supplies
`physHermite_succ`, `derivative_physHermite`, and `physHermite_succ'`.
Mathlib's separate `Polynomial.hermite` uses the probabilists' convention, but that is not a reason
to ignore Physlib's physicists' API.

The temporary probe kernel-checks, for every `n`,

```lean
ProjectKoios.QuantumMechanics.HarmonicOscillator.physicistsHermitePolynomial n =
  (Polynomial.physHermite n).map (Int.castRingHom ℝ)
```

This is a verified diagnostic candidate, **not a newly promoted repository declaration**. The
current continuum/certificate chain already uses Physlib's normalized eigenstates, not this legacy
polynomial definition, so the duplication does not block that chain.

The smallest subsequent refactor is to install an audited coefficient-map bridge and route eligible
legacy recurrence/derivative proofs through upstream results while preserving the existing
`QHO-HERMITE-*` names, IDs, and propositions. Do not silently redefine or remove the old construction,
relabel historical `THM` results, or equate its unnormalized dimensionless Gaussian with a normalized
physical eigenstate. Such an eigenfunction identification additionally requires scale,
normalization, scalar, and representative conventions. This pass deliberately performs no migration.

## Ready upstream candidates and unresolved boundaries

- Alpha `QuantumMechanics/HarmonicOscillator/LadderSystem.lean` exports `Q.toLadderSystem` and
  `toLadderSystem_N_toLinearMap`; `Vacuum.lean` exports `Q.vacuumGaussian` and
  `hasVacuum_vacuumGaussian`. Both the ordinary sequence module and the Schwartz vacuum target
  compiled in the bounded dependency API probe: 6,723 jobs, not a repository-wide Formal build.
  The number-operator identification and Gaussian-vacuum theorem have only `propext`,
  `Classical.choice`, and `Quot.sound` in their named reports.
- These Schwartz APIs should be inspected/reused for future ladder or vacuum work rather than
  defining another ladder-system abstraction. A `HasVacuum` witness is not a normalized state,
  dense-span theorem, or complete eigenbasis. The Alpha algebraic occupation/symmetric-power
  interfaces do not discharge the ambient Hilbert-space completeness obligation merely by
  constructing finite-dimensional vacuum-generated spans.
- A future finite ladder/continuum crosswalk must establish the applicable Schwartz/operator-domain
  lift and use upstream raising/lowering eigenfunction identities. Raising the highest retained
  state exits the retained span. The Hamiltonian's exact finite-span intertwining must not be
  copied unchanged to the raising operator; its exterior term or explicit compression is essential.
- The raw sequence file `PhyslibAlpha/QuantumMechanics/QuantumHarmonicOscillator.lean` compiles, but
  the inspected advertised names `aLin` and `coherentState_ℓ2` are **private** at this pin. Direct
  public-name import checks fail; environment inspection finds
  `_private.PhyslibAlpha.QuantumMechanics.QuantumHarmonicOscillator.0.aLin` and the analogous
  `coherentState_ℓ2` name. Do not reference private implementation names or create compatibility
  facades. Reconsider its use only through an available public API at an intentionally reviewed
  revision; no dependency change or upstream contribution is authorized by this audit.
- Even a public sequence API would still need coefficient/Hilbert/domain identification before
  transferring unbounded operator conclusions to the selected spatial continuum closure.
- Higher-dimensional completeness, identification of the chosen spectral measure with the concrete
  eigenbasis, converse closure-domain characterization, physical-scale enclosure production,
  runtime parsing, and scientific applicability remain separate obligations. No ready replacement
  for the combined local approximation/certificate bridge was found in the bounded inspected
  oscillator surfaces; this is not a claim of exhaustive library absence or novel mathematics.

## Reproducible diagnostic probes

Save the following as `/tmp/QhoReuseProbe.lean` and run `lake env lean /tmp/QhoReuseProbe.lean`.
The probe is outside repository-owned Lean sources and does not add public declarations or manifest
rows. Its three named reports contain only `propext`, `Classical.choice`, and `Quot.sound`.

```lean
import ProjectKoios.QuantumMechanics.HarmonicOscillator
import Physlib.Mathematics.SpecialFunctions.PhysHermite
import PhyslibAlpha.QuantumMechanics.HarmonicOscillator.Vacuum
import PhyslibAlpha.QuantumMechanics.QuantumHarmonicOscillator

open Polynomial
namespace QhoReuseProbe

lemma legacyHermite_eq_mapped_physHermite (n : ℕ) :
    ProjectKoios.QuantumMechanics.HarmonicOscillator.physicistsHermitePolynomial n =
      (Polynomial.physHermite n).map (Int.castRingHom ℝ) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [ProjectKoios.QuantumMechanics.HarmonicOscillator.physicistsHermitePolynomial_succ,
      Polynomial.physHermite_succ, Polynomial.map_sub, Polynomial.map_mul,
      ← Polynomial.derivative_map, ← ih]
    simp [two_smul, add_mul]

example (Q : QuantumMechanics.HarmonicOscillator 1) :
    (ProjectKoios.QuantumMechanics.HarmonicOscillator.oneDimensionalQuantumSystem Q).ℋ =
      Q.hamiltonian.closure := rfl

example (Q : QuantumMechanics.HarmonicOscillator 1) (n : ℕ) :
    ProjectKoios.QuantumMechanics.HarmonicOscillator.oneDimensionalEigenstateHilbertBasis Q n =
      (Q.eigenstate (fun _ => n) : Q.HS) := by
  simpa only [ProjectKoios.QuantumMechanics.HarmonicOscillator.oneDimensionalEigenstateFamily] using
    ProjectKoios.QuantumMechanics.HarmonicOscillator.oneDimensionalEigenstateHilbertBasis_apply Q n

#print axioms legacyHermite_eq_mapped_physHermite
#check QuantumMechanics.HarmonicOscillator.hamiltonian_essentially_self_adjoint
#check QuantumMechanics.HarmonicOscillator.toQuantumSystem
#check QuantumMechanics.HarmonicOscillator.eigenstates_orthonormal
#check QuantumMechanics.HarmonicOscillator.hamiltonian_eigenstate
#check QuantumMechanics.OneDimension.HarmonicOscillator.eigenfunction_completeness
#check HilbertBasis.mk
#check HilbertBasis.hasSum_repr
#check HilbertBasis.tsum_inner_mul_inner
#check LinearMap.isometryOfInner
#check Orthonormal.inner_sum
#check Matrix.toEuclideanCLM
#check LinearIsometry.adjoint_comp_self
#check NormedSpace.norm_normalize
#check abs_le_max_abs_abs

#check QuantumMechanics.HarmonicOscillator.toLadderSystem
#check QuantumMechanics.HarmonicOscillator.toLadderSystem_N_toLinearMap
#check QuantumMechanics.HarmonicOscillator.vacuumGaussian
#check QuantumMechanics.HarmonicOscillator.hasVacuum_vacuumGaussian
-- Sequence-oscillator declarations are private at this pin; inspected in a separate export probe.
#print axioms QuantumMechanics.HarmonicOscillator.toLadderSystem_N_toLinearMap
#print axioms QuantumMechanics.HarmonicOscillator.hasVacuum_vacuumGaussian

end QhoReuseProbe
```

The separate export probe `/tmp/QhoAlphaExportsProbe.lean` is:

```lean
import PhyslibAlpha.QuantumMechanics.QuantumHarmonicOscillator
import Lean
open Lean Elab Command in
run_elab do
  for (n, _) in (← getEnv).constants.toList do
    let s := n.toString
    if s.endsWith ".aLin" || s.endsWith ".coherentState_ℓ2" then
      logInfo m!"{n}"
```

Probe SHA-256 values:

- `QhoReuseProbe.lean`: `8c4a25a584c727cdd1e9380a3948dcb86cc395fe6dbb64d8c35534970a338391`;
- `QhoAlphaExportsProbe.lean`: `709ca283ec83a9888d0ef5315dfd21be7234a303306b013129c49cb10390a3f4`.

Evidence is recorded at [`AUD-VAL-096`](../audit/trusted-base-audit.md#aud-val-096) through
[`AUD-VAL-098`](../audit/trusted-base-audit.md#aud-val-098). The preceding exact formal-tree full build
is [`AUD-VAL-093`](../audit/trusted-base-audit.md#aud-val-093); this documentation-only audit does not
claim a new repository-wide build, public theorem, dependency adoption, release, or publication.
