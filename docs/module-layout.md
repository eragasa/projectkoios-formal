# Planned module layout

The listed semantic families under `ProjectKoios/BandGauge/` contain documentation only unless an existing `.lean` file is explicitly listed in the theorem manifest. Existing directories reserve cohesive ownership boundaries; proposed families are created only after exact statement selection. Neither a directory nor a paper plan announces an implemented API.

The implemented `ProjectKoios/QuantumMechanics/HarmonicOscillator/` family is source-neutral. It owns exact physicists' Hermite polynomial/function identities, retained finite ladder algebra, generic matrix-compression leakage, the explicit top-state Hamiltonian reconstruction defect, finite-difference symmetry, and supporting finite comparison algebra. It does not own runtime arrays, binary64 evidence, `L²` normalization or completeness, unbounded-operator domains, self-adjointness, discretization convergence, or retained-result acceptance. See its [module README](../ProjectKoios/QuantumMechanics/HarmonicOscillator/README.md).

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
reviewed semantic modules ──→ thin Papers instantiations
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

## Naming and promotion

A documentation folder becomes a Lean module family only after:

1. an exact theorem or definition is selected;
2. existing library APIs are inventoried;
3. ownership and import direction are reviewed; and
4. the theorem manifest receives a statement-level entry.

Placeholder README files are not supported import surfaces. Theorem IDs and proof dossiers
follow semantic families. Paper IDs are reserved for genuinely source-specific
instantiations and must not be used merely because a paper motivated a reusable theorem.
