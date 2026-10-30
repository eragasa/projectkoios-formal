# Module layout

Directories define semantic ownership only. A Lean API exists only when `docs/theorem-manifest.md` lists a declaration.

## BandGauge

BandGauge separates reusable algebra from paper bindings.

| Directory | Owns | Excludes |
|---|---|---|
| `Foundations/` | finite rank-two rotations, Pauli coordinates, exact band values, Frobenius perturbation algebra, and elementary optimization | paper data, thresholds, runtime eigensolvers, and rank-normalized Weyl claims |
| `Bloch/` | pointwise sewing, covariant fields, compatible alignment, aligned operator differences, conditional pointwise self-adjointness closure, exact action/operator-norm bounds, same-alignment subtraction and Lipschitz stability, finite samples | alignment selection, comparisons across different gauges without a bridge, runtime norm inference, Bloch--Floquet derivation, spectral conclusions, topology, `L²` point values |
| `Geometry/` | admissible sets, compact distance attainment and zero/positive separation criteria, and rank-two loss geometry | unreviewed rank/scalar generalization |
| `Hilbert/` | residual balls, finite reference/interpolation/conversion/deliberate-truncation residual identities and pointwise/maximum/RMS norm bounds, and weighted Frobenius algebra | runtime stage authentication, scalar error additivity, or replacement by a fixed bounded-operator norm |
| `Alignment/` | rectangular complex frames, ambient projectors, compression/reconstruction, right-unitary coordinate changes, exact unitary-Procrustes polar-witness optimality, and explicit identity/global/pointwise alignment families | Fourier truncation, runtime orthonormality, SVD/rank/tolerance verification, optimizer correctness, gauge selection, and unequal-rank unitary claims |
| `Decision/` | finite dominance, feasibility, minimum cost, first-passing cutoffs, common-candidate spectral--operator compatibility, exact finite-maximum aligned-operator budgets and same-alignment stability, precise separation, disjoint composition, and tagged recombination of upper-bounded error channels and nonnumeric structural requirements, the narrow and consumer-extended four-stage finite-maximum residual adapters, explicit component-budget synthesis under total headroom, concrete-to-generic schema adaptation, exact attainment for nonempty finite alignment families, conditional central/witness equivalence with separate minimizer-channel conformance, finite-inventory metric-separation converses, conformant model embeddings, and outcome classification | study-specific complete error taxonomies, external inventory coverage, cross-gauge comparison without a bridge, continuum frontiers, runtime optimizer correctness, physical adequacy, and KKT claims |
| `Certificates/` | exact schemas, checkers, and soundness bridges | runtime execution and unbound publication data |
| `Fourier/` | finite transforms, centered-even integer inventories and negative-Nyquist removal, Parseval, support, truncation, exact residual-channel power and root-mean-square tail bridges, pointwise and finite-maximum ambient-norm tail bounds, Hermitian pairing, fixed-unitary equivariance, character-phase shifts, pointwise-gauge boundaries, and exact finite gauge–truncation counterexamples | NumPy FFT/`fftshift` identity, matrix-Frobenius maximum specialization without an explicit representation bridge, arbitrary pointwise-gauge convolution/support formulas, runtime interpolation or mesh identity, Wannier90 |
| `Projection/` | compression, reconstruction, leakage, and support consequences | conflation with gauge, Fourier, or truncation |
| `SpecialFunctions/` | later Jacobi--Anger, Bessel, and tail results | premature dependency adoption |
| `Papers/` | thin source contracts and instantiations | duplicated reusable proofs |

## Crosswalks

Crosswalk modules bind narrow immutable constants.

| Directory | Owns | Excludes |
|---|---|---|
| `Crosswalks/PhysKit/` | immutable exact FCC--Bain constants and consequences | Python execution, package mirroring, physical applicability |

## Quantum mechanics

Quantum modules separate general mathematics from controlled models.

| Module | Owns | Excludes |
|---|---|---|
| `State.lean` | normalized representatives and phase shifts | ray quotients and full postulates |
| `Measurement/FinitePureState.lean` | finite operations and explicit norm completeness | general observables and continuous outcomes |
| `Dirac.lean` | typed ordinary bras, kets, brackets, and rank-one operators | generalized eigenvectors |
| `RiggedHilbertSpace.lean` | test-space inclusion and generalized functional embeddings | nuclearity and spectral completeness |
| `Operator/TestDomain.lean` | dense partial operators and formal-adjoint containment | closedness, adjoint equality, self-adjointness, spectra |
| `FiniteDimensional/` | compression, reduction, fitting, resolvents, and spin algebra | runtime data and physical interpretation |
| `FiniteDifference/` | exact lattice, boundary, transfer, and barrier algebra | continuum convergence and numerical scattering |
| `HarmonicOscillator/` | exact Hermite, ladder, truncation, and comparison algebra | runtime and continuum validation |
| `Piab1d/` | finite one-dimensional box specialization | general finite-difference ownership |

Reduction bases use `Φ`, retained projector `P = Φ Φᵀ`, and complement `Q = I - P`. Spin indices are orbital-major `ι × Fin 2` and use `A ⊗ₖ I₂`.

## Solid state

Solid-state modules remain finite and source-neutral.

| Directory | Owns | Excludes |
|---|---|---|
| `SolidState/FiniteLattice/` | finite folding, route identities, gauge loops, projector--Bargmann crosswalk | runtime arrays, topology, Wannier90, material claims |
| `SolidState/TightBinding/` | exact tetrahedral `sp³`/`sp³s⋆` transforms and abstract Vogl blocks | empirical values, spectra, DFT/Wannier evidence, silicon validation |

## Import direction

Imports flow from reusable foundations toward thin bindings.

```text
Foundations -> Bloch, Geometry, Hilbert, Fourier, Projection
Projection + Alignment + Fourier + Hilbert -> Decision
Geometry + Decision -> Certificates -> thin Papers bindings
FiniteDimensional spin algebra -> SolidState/FiniteLattice
FiniteLadder -> TruncationDistortion
FiniteDifference -> Piab1d
State -> Measurement and Dirac -> RiggedHilbertSpace -> Operator/TestDomain
TetrahedralSp3 -> TetrahedralSp3sStar and TetrahedralStructureFactors -> VoglSp3sStar
```

Actual imports remain narrower than this sketch. Root modules must not become catch-all re-export surfaces.

## Promotion

Create a module family only after:

1. selecting an exact declaration;
2. reviewing existing library APIs;
3. confirming ownership and import direction; and
4. adding a manifest entry.

Placeholder directories are not supported APIs.
