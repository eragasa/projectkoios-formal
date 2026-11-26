# Continuum Schrödinger API map

This map fixes the first Project Koios continuum single-particle convention against the adopted
Physlib APIs. It records what is already upstream, what the local bridge proves, and what remains
blocked. It does not establish physical applicability to Coulombic, periodic, many-electron, or DFT
Hamiltonians.

## Revisions inspected

- Physlib package: `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`.
- Mathlib: `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`.
- Project Koios base commit: `526fbc11772411fab273e662b3b6e4f2eff3b5f4`, plus the current
  uncommitted operator bridge.

## Adopted continuum convention

The first continuum layer reuses `QuantumMechanics.SpaceDQuantumSystem d` rather than defining a
second Schrödinger-system structure.

| Role | Adopted declaration | Convention |
|---|---|---|
| Configuration space | `Space d` | Euclidean `d`-space from Physlib. |
| Measure | `volume` | Lebesgue volume. |
| Hilbert space | `SpaceDHilbertSpace d` | Complex `L²` classes modulo almost-everywhere equality. |
| Regular core | `SchwartzSubmodule d` | Dense invariant domain for the implemented momentum operators. |
| Mass | `SpaceDQuantumSystem.m` with `hm : 0 < m` | Exact positive real parameter. |
| Potential | `SpaceDQuantumSystem.potential : Space d → ℝ` | Real scalar multiplication potential. |
| Kinetic energy | `SpaceDQuantumSystem.kineticOperator` | `(2m)⁻¹p²`; each momentum component already contains `ℏ`. |
| Potential energy | `SpaceDQuantumSystem.potentialOperator` | Maximal multiplication operator by `Complex.ofReal ∘ potential`. |
| Hamiltonian | `SpaceDQuantumSystem.hamiltonianOperator` | Partial-map sum of kinetic and potential operators. Its domain is their intersection. |

This convention fixes the formal carrier and coefficients only. It does not select a material,
external field, boundary condition, particle number, or unit system beyond Physlib's supplied
constants.

## Hilbert-space and regularity APIs

| Area | Adopted declaration | Status and use |
|---|---|---|
| `L²` carrier | `SpaceDHilbertSpace` | Adopt directly. Project Koios must not define another continuum wavefunction quotient. |
| Function membership | `SpaceDHilbertSpace.MemHS` | Use when proving a concrete function defines an `L²` class. |
| Schwartz inclusion | `SchwartzSubmodule`, `schwartzIncl`, `schwartzEquiv` | Adopt as the initial differential-operator core. |
| Sobolev subspace | `SpaceDHilbertSpace.SobolevSubmodule d s` | Available as a dense submodule defined through `MemSobolev s 2`. |
| Schwartz-to-Sobolev inclusion | `schwartzSubmodule_le_sobolevSubmodule` | Establishes that the current core lies in every upstream Sobolev submodule. |
| Sobolev density | `SobolevSubmodule.dense` | Available directly. |
| Sobolev nesting | `SobolevSubmodule.antitone` | Available directly. |

At the pinned revision, Physlib's momentum module explicitly records as TODO both extension of the
momentum operator to `H¹` and its self-adjointness there. Momentum squared is likewise implemented on
the Schwartz domain rather than as the maximal `H²` realization. Therefore the first Project Koios
Hamiltonian uses the Schwartz core. It must not relabel that operator as the `H²` Schrödinger
operator.

## Multiplication operators

`QuantumMechanics.SpaceDHilbertSpace.mulOperator` (`𝓜 μ f`) already supplies the maximal
multiplication operator. Relevant declarations are:

| Declaration | Meaning |
|---|---|
| `mem_mulOperator_domain_iff` | Domain membership is exactly square-integrability of `fψ`. |
| `mulOperator_apply_ae` | Operator action agrees almost everywhere with pointwise multiplication. |
| `mulOperator_hasDenseDomain` | An almost-everywhere strongly measurable multiplier has dense maximal domain. |
| `mulOperator_domain_eq_top` | An almost-everywhere bounded multiplier has full domain. |
| `mulOperator_domain_ge_of_hasTemperateGrowth` | A temperate multiplier's maximal domain contains the Schwartz submodule. |
| `mulOperator_adjoint_eq_conj` | The adjoint is multiplication by the conjugate multiplier. |
| `mulOperator_isSelfAdjoint_ofReal` | A measurable real multiplier is self-adjoint. |
| `mulOperator_isClosed` | The maximal measurable multiplication operator is closed. |
| `mulOperator_add_ge` | Multiplication by `f + g` extends the partial-map sum; domain equality is not automatic. |

**Decision:** all scalar potentials use the upstream maximal multiplication operator. Project Koios
will not introduce a restricted potential operator unless a later core theorem explicitly requires
one and records its relation to the maximal operator.

## Momentum and kinetic operators

Physlib defines each momentum component `𝓟 i` on `SchwartzSubmodule d`, proves that it preserves that
submodule, and proves symmetry and dense-domain closability. `momentumSqOperator` is the finite sum
of the restricted component squares and has domain exactly `SchwartzSubmodule d`.

The upstream surface did not expose symmetry of `momentumSqOperator` or of
`SpaceDQuantumSystem.kineticOperator`. The local module
`ProjectKoios/QuantumMechanics/Operator/Schrodinger.lean` now proves:

- `ProjectKoios.QuantumMechanics.momentumComponentSq_isSymmetric`;
- `ProjectKoios.QuantumMechanics.momentumSqOperator_isSymmetric`;
- `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.kineticOperator_isSymmetric`; and
- `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.kineticOperator_apply_schwartz`, identifying
  its exact action on an included Schwartz wavefunction.

These are domain-sensitive results. They do not identify the Schwartz-core kinetic operator with a
maximal self-adjoint Laplacian.

## Hamiltonian domain and symmetry

For the partial-map sum, the domain is

`kineticOperator.domain ⊓ potentialOperator.domain`.

The local bridge provides two levels of hypotheses:

1. `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_domain_eq_schwartz_of_potential_domain_ge`
   assumes directly that the maximal potential domain contains `SchwartzSubmodule d`.
2. `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_domain_eq_schwartz`
   derives that premise from `potential.HasTemperateGrowth`.

Measurability and domain inclusion remain logically separate:

- `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_isSymmetric` needs only
  almost-everywhere strong measurability of the real potential, because the upstream maximal
  potential operator is then self-adjoint;
- `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_isUnbounded_of_potential_domain_ge`
  additionally needs Schwartz-domain inclusion to establish a dense common domain; and
- `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_isUnbounded` supplies both
  premises from temperate growth.

Physlib's `IsUnbounded` means “densely defined and closable”; it does not mean “not bounded.” The
same local module also proves the mirrored
`SpaceDQuantumSystem.potentialOperator_apply_schwartz_ae` and
`SpaceDQuantumSystem.hamiltonianOperator_apply_schwartz_ae`, so the maximal potential and
operator-sum Hamiltonian are tied to their expected almost-everywhere actions without choosing
pointwise representatives of `L²` classes.

## Why temperate growth is only a first convention

`Function.HasTemperateGrowth` requires smoothness and polynomial bounds on every iterated
derivative. It covers many smooth polynomially controlled potentials and ensures that multiplication
preserves the Schwartz test framework. It excludes important singular potentials, including the
Coulomb function at the origin.

It is a sufficient condition, not the proposed final physical potential class. Other layers may use:

- bounded measurable real potentials, whose multiplication domain is all of `L²`;
- relative-boundedness or quadratic-form hypotheses for singular potentials; or
- an explicitly reviewed Coulomb Hamiltonian API.

The first singular specialization is now present in
`ProjectKoios/QuantumMechanics/Operator/Hydrogen.lean`. Physlib proves that its unregularized
`-k/‖x‖` potential is almost-everywhere strongly measurable and that the Hamiltonian domain contains
a dense polynomially bounded Schwartz submodule in every dimension. The local bridge combines those
facts with general Hamiltonian symmetry to prove dense closability. It does **not** claim that the
Hamiltonian domain is the full Schwartz submodule.

Those extensions must preserve the distinction between operator sums, maximal realizations,
closures, and form sums.

## Existing concrete-model status

- `Physlib.QuantumMechanics.FreeParticle.Basic` defines the Schwartz-core free Hamiltonian, but no
  checked essential-self-adjointness theorem was identified in the inspected surface.
- `Physlib.QuantumMechanics.HarmonicOscillator.Basic` defines the oscillator Hamiltonian and records
  essential self-adjointness only as an `informal_lemma` at the adopted revision. The local mirrored
  `ProjectKoios.QuantumMechanics.HarmonicOscillator` bridge now proves its exact Schwartz domain,
  symmetry, and dense closability, and proves essential self-adjointness conditionally on dense span
  of the supplied Cartesian eigenstates. It also constructs a linear isometric equivalence from the
  legacy one-dimensional carrier to `SpaceDHilbertSpace 1`, identifies the corresponding
  eigenstates, and reproduces the final legacy completeness step using the checked function-level
  Fourier-integral injectivity theorem
  `ProjectKoios.QuantumMechanics.Fourier.ae_eq_zero_of_fourier_eq_zero`. The resulting `d = 1`
  density and essential-self-adjointness theorems are unconditional. The self-adjoint closure is
  packaged as `oneDimensionalQuantumSystem` through Physlib's `QuantumSystem.mkESA`. The older
  declarations with the integral-form Plancherel premise remain available, and
  arbitrary-dimensional completeness remains open.
- `Physlib.QuantumMechanics.Hydrogen.Basic` defines the unregularized Coulomb system and proves a
  dense Hamiltonian domain. Project Koios now proves symmetry and closability from that API, while
  Physlib's dimension-dependent essential-self-adjointness statements remain TODOs.

## Current self-adjointness boundary

The generic `SpaceDQuantumSystem` and hydrogenic bridges stop at symmetry and closability. The
harmonic-oscillator bridge has a checked arbitrary-dimensional reduction under an explicit
eigenstate dense-span premise and an unconditional dimension-one theorem. The latter uses a direct
function-level injectivity result for the pointwise Fourier integral rather than identifying it with
Mathlib's abstract `L²` Fourier isometry. Thus the adopted one-dimensional Schwartz-core oscillator
is essentially self-adjoint, and `oneDimensionalQuantumSystem` packages its closure as a
self-adjoint `QuantumSystem`. No such conclusion is claimed for the generic or hydrogenic
Hamiltonians.

Those adopted APIs are now applied directly in
`HarmonicOscillator/SpectralEvolution.lean`:

- PhyslibAlpha `unboundedSpectralTheorem_of_essentiallySelfAdjoint` supplies a concrete
  domain-aware Cayley spectral measure for the closure; and
- the thin `schrodingerEvolution` adapter reparameterizes the Alpha strong group as physical
  `U(t)=exp(-itH/ℏ)` and exposes all-time derivatives, domain invariance, and Hamiltonian
  commutation.

No competing spectral theorem or strong-group structure is introduced.

`DensityFunctionalTheory/KohnSham/ContinuumDensity.lean` now supplies the representative-safe
orbital-to-density bridge: an `L²` orbital maps to the real `L¹` class represented almost
everywhere by its squared norm, finite weighted orbital sums remain in `L¹`, and almost-everywhere
crosswalks recover the source-neutral pointwise Kohn--Sham formulas. Exact integral identities
show that normalized orbitals yield the supplied occupation sum, while keeping normalization an
explicit hypothesis. The adapter to the abstract variational model adds no continuum energy or
representability theorem.

## Remaining implementation gates

1. Extend oscillator completeness beyond `d = 1`, for example through a checked tensor-product
   route, while preserving the already proved unconditional dimension-one result.
2. Add spectral-coordinate or continuum-measurement semantics only through the concrete selected
   spectral measure; the domain-aware theorem alone does not identify an eigenfunction expansion or
   normalized outcome law.
3. The Coulomb specialization is densely closable, but its dimension-dependent
   essential-self-adjointness problem remains open.
4. For an `H²` realization, either adopt a future pinned Sobolev-domain momentum/Laplacian API or
   implement the missing local bridge under the mirrored Project Koios namespace; do not silently
   change the Schwartz-core operator's domain.
5. Add orthogonality, occupation bounds, and physically fixed particle-number constraints only as
   explicit contracts; the proved normalization-dependent integral identities do not infer them.
6. Keep this single-particle continuum layer separate from the many-electron and DFT authority
   boundaries.
