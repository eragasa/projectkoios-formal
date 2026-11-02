# Module layout

Directories define semantic ownership only. A Lean API exists only when `docs/theorem-manifest.md` lists a declaration.

## BandGauge

BandGauge separates reusable algebra from paper bindings.

| Directory | Owns | Excludes |
|---|---|---|
| `Foundations/` | finite rank-two rotations, Pauli coordinates, exact band values, complex-unitary spectrum/trace/determinant/band invariance, Frobenius perturbation algebra, elementary optimization, and exact finite-rank analytic-parent structure-factor/order/gap bounds | runtime gauge or coordinate-witness authentication, Python/NumPy execution, binary64 values, paper data, thresholds, eigensolvers, band tracking, meshes, alignment recovery, scientific applicability, and rank-normalized Weyl claims |
| `Bloch/` | pointwise sewing, covariant fields, compatible alignment, aligned operator differences, conditional pointwise self-adjointness closure, exact action/operator-norm bounds, same-alignment subtraction and Lipschitz stability, finite samples | alignment selection, comparisons across different gauges without a bridge, runtime norm inference, Bloch--Floquet derivation, spectral conclusions, topology, `L²` point values |
| `Geometry/` | admissible sets, compact distance attainment and zero/positive separation criteria, and rank-two loss geometry | unreviewed rank/scalar generalization |
| `Hilbert/` | residual balls, finite reference/interpolation/conversion/deliberate-truncation residual identities and pointwise/maximum/RMS norm bounds, and weighted Frobenius algebra | runtime stage authentication, scalar error additivity, or replacement by a fixed bounded-operator norm |
| `Alignment/` | rectangular complex frames, ambient projectors, compression/reconstruction, separate finite gauge-family/dimension/action/inner-product identities, the exact metric-isometry equation and its identity/composition laws, right-unitary coordinate changes and right-conjugation/Hermiticity laws, exact unitary-Procrustes polar-witness optimality, finite-mesh summed objectives, exact known-inverse controls, matrix-unitary embeddings, and explicit identity/global/pointwise alignment families | an untyped left-action formula, metric-aware adjoints or objectives, Fourier truncation, runtime mesh or orthonormality authentication, SVD/rank/tolerance verification, unconditional polar construction, optimizer correctness, gauge selection, and unequal-rank unitary claims |
| `Decision/` | finite dominance, feasibility, minimum cost, first-passing cutoffs, common-candidate spectral--operator compatibility, exact finite-maximum aligned-operator budgets and same-alignment stability, precise separation, disjoint composition, and tagged recombination of upper-bounded error channels and nonnumeric structural requirements, the narrow and consumer-extended four-stage finite-maximum residual adapters, explicit component-budget synthesis under total headroom, concrete-to-generic schema adaptation, exact attainment for nonempty finite alignment families, conditional central/witness equivalence with separate minimizer-channel conformance, finite-inventory metric-separation converses, conformant model embeddings, and outcome classification | study-specific complete error taxonomies, external inventory coverage, cross-gauge comparison without a bridge, continuum frontiers, runtime optimizer correctness, physical adequacy, and KKT claims |
| `Certificates/` | exact schemas, checkers, and soundness bridges | runtime execution and unbound publication data |
| `Fourier/FiniteAbelian/` | convention-neutral reconstruction and truncation; explicit finite-abelian transforms, inversion, Parseval, Hermitian pairing, matrix-Frobenius identities, coefficient-support monotonicity, exact matrix-product convolution, finite-support addition, exact equal-weight least-squares optimality of support truncation, direct onsite/nononsite Frobenius-power partition, and a finite-periodic reciprocal-lattice application layer with arbitrary finite dimension/rank plus explicit 1-D/2-D/3-D specializations | runtime mesh or reciprocal-basis authentication, FFT implementations, serialized coefficient arrays, gauge selection, design-matrix rank, numerical least-squares solvers, conditioning, binary64 summation or route agreement, continuum decay, and physical locality |
| `Fourier/Gauge/` | fixed-unitary equivariance, character-phase and pointwise-gauge boundaries, exact pointwise-unitary triple convolution, finite-support inclusion, and a complete-shell radius bound under explicit subadditivity/inversion hypotheses, plus gauge–truncation counterexamples and binary product-mesh 2-D/3-D ordered-band/locality separation | runtime gauge recovery, optimizer behavior, support equality, external shell authentication, continuum decay, and physical locality |
| `Fourier/Support/` | centered-even inventories and negative-Nyquist removal; exact complete metric shells, attained-radius/no-skipped-shell semantics, complete-shell addition/inversion under supplied radius hypotheses, and reduced-coordinate square/triangular/simple-cubic/FCC indices | NumPy FFT/`fftshift` identity, external inventory authentication, identification of squared indices with a subadditive radius, source-defined hopping range, and physical units |
| `Fourier/Torus/` | normalized finite product-torus measure, coordinate-factorized averages, and normalized one-circle sine-phase `J₀` identities and finite product powers | external coordinate or phase binding, quadrature, continuum Parseval, finite-to-continuum convergence, and runtime comparator authentication |
| `Fourier/Residual/` | exact deliberate-truncation power and root-mean-square tails, pointwise and finite-maximum ambient-norm bounds, and constant/uniform rank-two weighting | runtime interpolation, nonuniform quadrature certification, matrix-Frobenius maximum specialization without a representation bridge, and scientific error budgets |
| `Projection/` | compression, reconstruction, leakage, and support consequences; `LaurentObstruction.lean` owns the exact Ragasa2026b two-band Laurent core and `SpectralProjectionRange.lean` owns its unit-circle, projector, and finite-support-destruction proof | conflation with gauge, Fourier, or truncation, or generalizing the exact counterexample into a universal projection claim |
| `SpecialFunctions/` | source-neutral exact special-function identities, beginning with the attributed full-angle `J₀` exponential-integral proof | broad external-package dependency, unproved Jacobi--Anger generalization, shell tails, runtime values, or scientific interpretation |
| `Papers/` | thin source contracts and instantiations | duplicated reusable proofs |

## Crosswalks

Crosswalk modules bind narrow immutable constants.

| Directory | Owns | Excludes |
|---|---|---|
| `Crosswalks/PhysKit/` | immutable exact FCC--Bain constants, uniform-modulus consequences, positive diagonal-quotient finiteness, and exact mixed-modulus admission criteria | Python execution, package mirroring, runtime mesh identity, convergence, physical applicability |

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
| `SolidState/FiniteLattice/` | finite folding, route identities, gauge loops, projector--Bargmann crosswalk, integer-lattice preservation certificates, full-rank integer-quotient finiteness, and induced quotient-map bijectivity | runtime arrays, runtime mesh authentication, topology, Wannier90, material claims |
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
