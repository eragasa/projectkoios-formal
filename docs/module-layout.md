# Module layout

Directories define semantic ownership only. A Lean API exists only when `docs/theorem-manifest.md` lists a declaration.

## Repository-level specifications

| Directory | Owns | Excludes |
|---|---|---|
| `specification/certificates/` | source-neutral normative certificate byte grammars, semantic decoding, lifecycle, dispositions, and conformance fixtures | consumer-specific adapters, checker implementations, runtime evidence, and scientific admission |

## BandGauge

BandGauge separates reusable algebra from paper bindings.

| Directory | Owns | Excludes |
|---|---|---|
| `Foundations/` | finite rank-two rotations, Pauli coordinates, exact band values, complex-unitary spectrum/trace/determinant/band invariance, Frobenius perturbation algebra, elementary optimization, exact finite-rank analytic-parent structure-factor/order/gap bounds, canonical decreasing Hermitian eigenvalue vectors with separate maximum/RMS error carriers and characteristic-polynomial zero-error criteria, a direct maximum-form Weyl/operator-norm bound, and a separate unnormalized Hoffman--Wielandt square-sum plus dimension-normalized RMS/Frobenius bound | runtime gauge or coordinate-witness authentication, Python/NumPy execution, binary64 values, paper data, thresholds, eigensolvers, degeneracy/band tracking, meshes, alignment recovery, and scientific applicability |
| `Bloch/` | pointwise sewing, covariant fields, compatible alignment, aligned operator differences, conditional pointwise self-adjointness closure, exact action/operator-norm bounds, same-alignment subtraction and Lipschitz stability, finite samples | alignment selection, comparisons across different gauges without a bridge, runtime norm inference, Bloch--Floquet derivation, spectral conclusions, topology, `L²` point values |
| `Geometry/` | admissible sets, compact distance attainment and zero/positive separation criteria, and rank-two loss geometry | unreviewed rank/scalar generalization |
| `Hilbert/` | residual balls, finite reference/interpolation/conversion/deliberate-truncation residual identities and pointwise/maximum/RMS norm bounds, and weighted Frobenius algebra | runtime stage authentication, scalar error additivity, or replacement by a fixed bounded-operator norm |
| `Alignment/` | rectangular complex frames, ambient projectors, compression/reconstruction, separate finite gauge-family/dimension/action/inner-product identities, the exact metric-isometry equation and its identity/composition laws, right-unitary coordinate changes, right-conjugation/Hermiticity/complex-spectrum laws, distinct-dimension conjugate-linear coordinate actions, independent invertible basis changes, algebraic conjugate-linear metric compatibility, conjugate-linear composition, exact `F'=F₀G`, `H'=GᴴDG` construction and known-inverse recovery, exact unitary-Procrustes polar-witness optimality, neighbor/sequential/periodic-seam transport from supplied polar witnesses with conditional known-gauge exact closure, orthonormal-frame polar principal values in `[0,1]`, exact frame/projector defect identities and factor-two bounds, finite-mesh summed objectives, exact known-inverse controls, matrix-unitary embeddings, and explicit identity/global/pointwise alignment families | an untyped left-action formula, metric-aware adjoints or objectives, positivity/Hermiticity/bijectivity/isometry/antiunitarity inferred from the conjugate-linear metric equation, a general symmetry framework, Fourier truncation, runtime mesh, ordered-eigenvalue, eigensolver, orthonormality, SVD, principal-angle-array, transport-loop, or seam-closure authentication, numerical rank/tolerance verification, unconditional polar construction, perturbative transport stability, closure distribution, optimizer correctness, gauge selection, and unequal-rank unitary claims |
| `Decision/` | finite dominance, feasibility, minimum cost, first-passing cutoffs, common-candidate spectral--operator compatibility, exact finite-maximum aligned-operator budgets and same-alignment stability, precise separation, disjoint composition, and tagged recombination of upper-bounded error channels and nonnumeric structural requirements, the narrow and consumer-extended four-stage finite-maximum residual adapters, explicit component-budget synthesis under total headroom, concrete-to-generic schema adaptation, exact attainment for nonempty finite alignment families, conditional central/witness equivalence with separate minimizer-channel conformance, finite-inventory metric-separation converses, conformant model embeddings, and outcome classification | study-specific complete error taxonomies, external inventory coverage, cross-gauge comparison without a bridge, continuum frontiers, runtime optimizer correctness, physical adequacy, and KKT claims |
| `Certificates/` | Lean-level certificate semantics, checkers, and soundness bridges implementing or refining separately reviewed top-level specifications | ownership of normative external byte grammars, runtime execution, and unbound publication data |
| `Fourier/FiniteAbelian/` | convention-neutral reconstruction and truncation; explicit finite-abelian transforms, inversion, Parseval, Hermitian pairing, matrix-Frobenius identities, coefficient-support monotonicity, exact matrix-product convolution, finite-support addition, exact equal-weight least-squares optimality of support truncation, direct onsite/nononsite Frobenius-power partition, and a finite-periodic reciprocal-lattice application layer with arbitrary finite dimension/rank plus explicit 1-D/2-D/3-D specializations | runtime mesh or reciprocal-basis authentication, FFT implementations, serialized coefficient arrays, gauge selection, design-matrix rank, numerical least-squares solvers, conditioning, binary64 summation or route agreement, continuum decay, and physical locality |
| `Fourier/Gauge/` | fixed-unitary equivariance, character-phase and pointwise-gauge boundaries, exact pointwise-unitary triple convolution, finite-support inclusion, complete-shell radius bounds and their one-dimensional finite-cyclic quotient-radius specialization, plus rank-two, generic arbitrary-finite-dimensional, exact finite-rank analytic-parent, arbitrary finite-abelian character-gauge, and finite periodic product-lattice gauge–locality separation witnesses with canonical nonzero unit-frequency coordinate characters and exact selected coefficients, plus a conditional fixed-subspace ambient-frame compression bridge preserving orthonormality, the retained projector, and pointwise complex spectra | ordered eigenvalues or multiplicities beyond explicitly proved rank-two formulas, runtime gauge recovery, optimizer behavior, support equality, runtime mesh/FFT/basis authentication, DFT or Wannier90 execution, continuum decay, and physical locality |
| `Fourier/Support/` | centered-even inventories and negative-Nyquist removal; exact complete metric shells, attained-radius/no-skipped-shell semantics, complete-shell addition/inversion under supplied radius hypotheses, reduced-coordinate square/triangular/simple-cubic/FCC indices, explicit integer-lattice radii with exact squared-index, inversion, triangle, elementwise `R_A + 2 R_U`, and complete-shell inclusion bounds, plus a seam-compatible quotient-seminorm radius on complex characters of `ZMod n` | NumPy FFT/`fftshift` identity, external inventory authentication, equality with a selected centered representative, multidimensional product-quotient bindings to lattice geometries, source-defined hopping range, and physical units |
| `Fourier/Torus/` | normalized finite product-torus measure, coordinate-factorized averages, and normalized one-circle sine-phase `J₀` identities and finite product powers | external coordinate or phase binding, quadrature, continuum Parseval, finite-to-continuum convergence, and runtime comparator authentication |
| `Fourier/Residual/` | exact deliberate-truncation power and root-mean-square tails, pointwise and finite-maximum ambient-norm bounds, and constant/uniform rank-two weighting | runtime interpolation, nonuniform quadrature certification, matrix-Frobenius maximum specialization without a representation bridge, and scientific error budgets |
| `Projection/` | compression, reconstruction, exact compressed-action reproduction residuals with invariant-range semantics under orthonormality, matrix-`L2Operator` and mixed Frobenius/operator approximate frame and projector-sandwich mismatch bounds, separate maximum and dimension-normalized Hoffman--Wielandt RMS ordered-spectrum transfer through frame compression, plus a separate frame/projector residual bound relative to a zero-residual reference; `LaurentObstruction.lean` owns the exact Ragasa2026b two-band Laurent core and `SpectralProjectionRange.lean` owns its unit-circle, projector, and finite-support-destruction proof | runtime orthonormality/leakage/eigensolver authentication, conflation with gauge, Fourier, or truncation, or generalizing the exact counterexample into a universal projection claim |
| `SpecialFunctions/` | source-neutral exact special-function identities, beginning with the attributed full-angle `J₀` exponential-integral proof | broad external-package dependency, unproved Jacobi--Anger generalization, shell tails, runtime values, or scientific interpretation |
| `Papers/` | thin source contracts and instantiations | duplicated reusable proofs |

## Crosswalks

Crosswalk modules bind narrow immutable constants.

| Directory | Owns | Excludes |
|---|---|---|
| `Crosswalks/PhysKit/` | immutable exact FCC--Bain constants, uniform-modulus consequences, positive diagonal-quotient finiteness, and exact mixed-modulus admission criteria | Python execution, package mirroring, runtime mesh identity, convergence, physical applicability |

## Density functional theory

Density-functional modules begin with source-audited scalar variational foundations.  Orbital,
finite-basis, PAW, spin, and relativistic layers must import rather than redefine this core.

| Directory | Owns | Excludes |
|---|---|---|
| `DensityFunctionalTheory/Foundations/` | abstract real-valued density variational data, ground-state and strict-ground-state predicates, scalar-potential equivalence modulo additive constants, the strict nondegenerate Hohenberg--Kohn variational contradiction, conditional potential recovery with the model-specific shared-state uniqueness step exposed as a hypothesis, and an abstract Levy--Lieb constrained search over the explicitly representable density subtype with an infimum functional, outer variational bound, and equality at a supplied ground-state density | continuum electron function spaces, Coulomb Hamiltonians, particle-number normalization, independent minimizer-existence or uniqueness theorems, degenerate HK theory, ensemble/density-matrix relaxation, Kohn--Sham orbitals, exchange--correlation approximations, PAW, runtime solvers, numerical evidence, and scientific-validation claims |
| `DensityFunctionalTheory/KohnSham/` | supplied scalar universal, noninteracting kinetic, and Hartree functionals; exact exchange--correlation remainder reconstruction; specialization of the universal term to the abstract constrained-search energy; finite complex scalar orbital families; pointwise unit/occupation-weighted density sums; and the thin binding from source-neutral finite-basis orbital expansion to fully expanded Kohn--Sham density | noninteracting representability, continuum normalization or orthogonality, physical occupation bounds or particle-number sums, Coulomb kernels, functional derivatives, effective potentials/operators, Hamiltonian or overlap matrices, eigenvalue equations, LDA or other approximations, self-consistency, discretization error, numerical convergence, and PAW |
| `DensityFunctionalTheory/PAW/` | exact supplied finite transformation `T`, reconstructed states, transported operators `Tᴴ A T`, overlap `Tᴴ T`, Hermiticity and positivity, sesquilinear pairing transport, and generalized-eigenproblem equivalence under explicit injectivity or invertibility hypotheses | finite-rank partial-wave/projector construction, augmentation regions, compensation charges, density and total-energy decompositions, frozen-core or cutoff approximations, datasets, runtime implementation, numerical evidence, and materials claims |

## Quantum mechanics

Quantum modules separate general mathematics from controlled models.

| Module | Owns | Excludes |
|---|---|---|
| `State.lean` | normalized representatives and phase shifts | ray quotients and full postulates |
| `Measurement/FinitePureState.lean` | finite operations and explicit norm completeness | general observables and continuous outcomes |
| `Dirac.lean` | typed ordinary bras, kets, brackets, and rank-one operators | generalized eigenvectors |
| `RiggedHilbertSpace.lean` | test-space inclusion and generalized functional embeddings | nuclearity and spectral completeness |
| `Operator/TestDomain.lean` | dense partial operators and formal-adjoint containment | closedness, adjoint equality, self-adjointness, spectra |
| `FiniteDimensional/` | compression, reduction, fitting, resolvents, source-neutral finite-basis complex orbital-amplitude expansion, spin embeddings and projections, exact Pauli-vector algebra, scalar-plus-Pauli decomposition, fixed-basis collinearity, and exact global `SU(2)` active spin-frame rotations | runtime data, density or DFT/SOC source bindings, basis completeness or integration, induced `SO(3)` identification, position-dependent frames, and physical interpretation |
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
DFT/Foundations/Variational -> DFT/Foundations/HohenbergKohn and ConstrainedSearch -> DFT/KohnSham/FunctionalDecomposition -> DFT/KohnSham/OccupiedOrbitals
QM/FiniteDimensional/OrbitalExpansion + DFT/KohnSham/OccupiedOrbitals -> DFT/KohnSham/FiniteBasisDensity -> DFT/PAW/FiniteTransformation -> future projector augmentation and spin bindings
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
