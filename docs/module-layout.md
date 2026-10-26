# Planned module layout

The listed semantic families under `ProjectKoios/BandGauge/` contain documentation only unless an existing `.lean` file is explicitly listed in the theorem manifest. Existing directories reserve cohesive ownership boundaries; proposed families are created only after exact statement selection. Narrow source-specific computational crosswalks live separately under `ProjectKoios/Crosswalks/` only after their exact constants, immutable owner revision, and proof boundary have been selected. `ProjectKoios/QuantumMechanics/` and `ProjectKoios/SolidState/` are separate publication-independent families for reusable exact algebra. Neither a directory nor a paper plan announces an implemented API.

The implemented quantum-mechanics families separate source-neutral finite-dimensional and finite-difference algebra from concrete systems. `FiniteDimensional/` owns compression residuals, additive decomposition identifiability, reduction bases, spin embeddings, and Frobenius model-class fitting. `FiniteDifference/` owns the centered one-dimensional stencil, complex exponential translation modes, scalar-twisted and periodic cycles, the doubled-cycle odd-extension bridge to Dirichlet boundaries, and symbolic constant-region/finite-barrier transfer algebra. `HarmonicOscillator/` owns the exact QHO mechanisms, while `Piab1d/` owns only the concrete one-dimensional box specialization. None owns runtime arrays, binary64 evidence, continuum spectral completeness, unbounded-operator domains, self-adjointness, discretization convergence, or retained-result acceptance. See the respective module READMEs.

| Directory | Intended ownership | Explicit exclusions |
|---|---|---|
| `Foundations/` | finite index types, support vocabulary, state-space/frame/gauge definitions, rank-two real rotations and Pauli coordinates, and standard second-harmonic optimization | paper-specific thresholds and numerical records |
| `Bloch/` | pointwise reciprocal-group sewing, covariant operator fields, sewing-compatible alignments, aligned difference fields, and abstract periodic retained-rank-two finite samples | silently treating `L²` classes as pointwise boundary data, claiming topology from sewing diagnostics, or claiming a Bloch--Floquet construction from a periodic potential |
| `Geometry/` | admissible-set geometry, alignment losses, metric separation, and rank-two finite-dimensional consequences | unreviewed generalization to arbitrary rank or scalar field, or finite decision enumeration |
| `Hilbert/` | reusable real Hilbert-space residual-ball geometry and finite rank-two weighted Frobenius algebra | substituting bounded-operator norm for the papers' Frobenius losses |
| `Alignment/` *(proposed)* | finite-rank gauge actions, special-orthogonal/unitary alignment, exact recovery, and reviewed Procrustes/Kabsch results | paper channel labels, Fourier truncation, or treating unequal-rank isometries as unitary gauge equivalence |
| `Decision/` | finite dominance, Pareto efficiency, threshold feasibility, minimum-cost attainment, robustness, and empty-set classification | plot triangulation, convexification, KKT assumptions, or continuum-frontier claims |
| `Certificates/` | exact decidable rational-center and rational-enclosure schemas, and later finite interval-table, coverage, and mask certificate soundness bridges | production runtime execution, unbound publication data, or scientific validation |
| `Fourier/` | implemented convention-neutral finite reconstruction/truncation, two-sided finite-abelian inversion, Parseval, exact Hilbert- and matrix-Frobenius tail identities, Hermitian pairing, and constant/uniform rank-two paper normalization; later nonuniform-weight, physical-shell and source-mesh specializations, and continuum analysis | Wannier90 execution, calculator output, sampled evidence, or silently identifying the generic group with a publication mesh |
| `Projection/` | retained low-eigenpair compression, invariant-subspace reconstruction, residual/leakage bounds, and finite-support consequences | conflating projection with gauge change, disentanglement, Fourier conversion, or truncation |
| `SpecialFunctions/` | later Jacobi–Anger, Bessel, and shell-tail infrastructure | premature dependencies before finite/continuum foundations are fixed |
| `Papers/` | thin source crosswalks and eventual theorem instantiations | duplicated foundational proofs and ownership of publication prose |

Source-specific crosswalks remain outside the BandGauge semantic hierarchy:

| Directory | Intended ownership | Explicit exclusions |
|---|---|---|
| `Crosswalks/PhysKit/` | exact source-specific constants and thin consequences for the immutable PhysKit `FccBainCoordinateBridge3D` matrix contract | mirroring the PhysKit package tree, importing Python, verifying NumPy execution, supplying a runtime superclass, or claiming crystallographic or physical applicability |

## Quantum-mechanics modules

| Directory | Intended ownership | Explicit exclusions |
|---|---|---|
| `ProjectKoios/QuantumMechanics/FiniteDimensional/` | source-neutral finite-dimensional algebra, including rectangular reduction bases, retained projectors, reduced-coordinate Hamiltonians, exact two-state spin lifts, Frobenius-optimal spin-independent projection, and standard Pauli residual identities | runtime arrays, eigensolver execution, binary64 error claims, serialized-artifact validity, authored coefficient matrices, time-reversal implementations, and physical interpretation or adequacy |

The reduction-basis module uses `Φ` for the reduced-to-full map, `P = Φ Φᵀ` for the retained
projector, and reserves `Q = I - P` for the complementary projector. The spin modules use
orbital-major product indices `ι × Fin 2`, the exact lift `A ⊗ₖ I₂`, and the half-partial-trace
projection onto that lift's range. The Pauli-residual module owns standard two-state Pauli matrices
and abstract orbital-coefficient residual identities, but not authored calculation matrices or
physical spin assumptions. These modules are imported by the audit surface but are not re-exported
through the package root.

## Solid-state modules

| Directory | Intended ownership | Explicit exclusions |
|---|---|---|
| `ProjectKoios/SolidState/FiniteLattice/` | normalized finite-character folding, cell-major block supercells, exact finite Bloch-fiber diagonalization, and coordinate/alignment/energy-shift/defect route algebra | runtime Fourier matrices, representative-selection code, hopping truncations, numerical eigenspectra, tolerances, serialized evidence, and physical applicability |
| `ProjectKoios/SolidState/TightBinding/` | exact tetrahedral `sp³` and `sp³s⋆` basis transforms, exact bond-phase structure factors, abstract nearest-neighbor parameter slots, structural zeros, and Hermitian block assembly | accepted empirical parameter values, numerical eigenspectra, Python/runtime validation, DFT or Wannier evidence, material adequacy, novelty, and publication claims |

The cyclic one-dimensional specialization uses `ZMod N`. General finite-abelian declarations are
source-neutral reusable infrastructure; the calculation crosswalk relies only on the cyclic case
and explicit coordinate-change premises. The solid-state modules are audited but not re-exported
through `ProjectKoios.lean`; future bridges must be reviewed explicitly.

## Dependency direction

The intended direction is:

```text
Foundations ──→ Bloch
      ├───────→ Alignment
      ├───────→ Geometry
      ├───────→ Hilbert
      ├───────→ Fourier
      └───────→ Projection

Bloch + Alignment ──→ sewn aligned differences and reference-fiber losses
Projection + Alignment + Fourier + Hilbert ──→ Decision
Geometry + Decision ──→ Certificates ──→ Papers through explicit bindings
Bloch + reviewed measure/regularity contracts ──→ later Hilbert section spaces
Foundations + Fourier ──→ later SpecialFunctions
QuantumMechanics/FiniteDimensional/SpinEmbedding ──→ SolidState/FiniteLattice route identities
Mathlib finite-character and matrix APIs ──→ SolidState/FiniteLattice folding
reviewed semantic modules ──→ thin Papers instantiations

TetrahedralSp3 ──→ TetrahedralSp3sStar
       └─────────→ TetrahedralStructureFactors ──→ VoglSp3sStar
TetrahedralSp3sStar ─────────────────────────────→ VoglSp3sStar
```

Actual imports must remain narrower than this sketch. No root module should become a catch-all re-export merely because a directory exists.

The harmonic-oscillator import direction is:

```text
FiniteLadder ──→ TruncationDistortion
HermiteEigenfunction ──→ TruncationDistortion (finite/analytic energy crosswalk only)
FiniteDifference          (independent exact stencil layer)
FiniteComparison          (independent exact comparison layer)
```

The narrow `ProjectKoios.QuantumMechanics.HarmonicOscillator` module imports only these five semantic modules.

The PIAB1D and reusable import direction is:

```text
FiniteDifference/CenteredDirichlet1D ─┐
FiniteDifference/ExponentialMode1D ────┴→ FiniteDifference/DirichletMatrixMode1D
FiniteDifference/DirichletMatrixMode1D ─→ FiniteDifference/TwistedCyclic1D
FiniteDifference/TwistedCyclic1D ───────→ FiniteDifference/OddExtension1D
FiniteDifference/TwistedCyclic1D ───────→ Piab1d/FiniteDifference ─→ Piab1d/Spectrum
FiniteDifference/ExponentialMode1D ──────→ FiniteDifference/ConstantPotential1D
FiniteDifference/ConstantPotential1D ────→ FiniteDifference/FiniteBarrier1D
FiniteDifference/FiniteBarrier1D ────────→ FiniteDifference/BarrierMatching1D
FiniteDimensional/*                         (source-neutral operator analysis)
```

`ExponentialMode1D` and `TwistedCyclic1D` prove translation-character and scalar real-space
boundary algebra intended for a later reviewed Bloch bridge. The scalar twist is not definitionally
the reciprocal-fiber sewing contract in `BandGauge/Bloch`; these modules do not establish
Bloch--Floquet theory or identify a phase with a runtime momentum. `ConstantPotential1D` and
`FiniteBarrier1D` and `BarrierMatching1D` keep potentials, energies, roots, amplitudes, and widths
symbolic. The latter isolates the explicitly named left-incident algebraic convention and proves
interface-coordinate existence/uniqueness away from coincident reciprocal roots; it does not solve
the constrained reflection/transmission amplitudes numerically, attach flux probabilities, or
identify a finite barrier with a hard-wall boundary.

## Naming and promotion

A documentation folder becomes a Lean module family only after:

1. an exact theorem or definition is selected;
2. existing library APIs are inventoried;
3. ownership and import direction are reviewed; and
4. the theorem manifest receives a statement-level entry.

Placeholder README files are not supported import surfaces. Theorem IDs and proof dossiers
follow semantic families. Paper IDs are reserved for genuinely source-specific
instantiations and must not be used merely because a paper motivated a reusable theorem.
