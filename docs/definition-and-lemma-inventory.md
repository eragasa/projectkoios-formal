# Definition and lemma inventory

This inventory records both implemented first-slice declarations and future search/design needs. The theorem manifest remains authoritative for existing APIs. “Unassessed” means that no complete Mathlib/Physlib search or exact Lean signature review has yet been recorded.

| Area | Candidate concept or lemma | Source need | Library status | Intended folder |
|---|---|---|---|---|
| Finite geometry | feasible pair bounds set distance; common witness implies zero distance | Ragasa2026c witness/separation proposition | implemented as `BG-DEF-001`; `BG-THM-001/002` are proved | `BandGauge/Geometry` |
| Finite geometry | positive certified lower bound implies disjointness | same | proved as `BG-THM-003` | `BandGauge/Geometry` |
| Topology | disjoint nonempty compact sets attain positive distance under the required metric hypotheses | same | proved as `BG-THM-004` using `IsCompact.prod`, `IsCompact.exists_isMinOn`, and continuity of `edist` | `BandGauge/Geometry` |
| Finite geometry | nonempty finiteness and real/extended distance bridge | same | `BG-THM-005` and `BG-THM-006` proved; `BG-DEF-002` implemented | `BandGauge/Geometry` |
| Finite geometry | spectral and restricted aligned-operator loss sublevel sets on one domain | Ragasa2026c admissible-set definitions | `BG-DEF-003/004` implemented; `BG-THM-007/008` proved | `BandGauge/Geometry` |
| Finite geometry | reduced rank-two losses, ellipses, exact distance, and candidate-rectangle transfer | Ragasa2026a exact loss geometry | `BG-DEF-005` through `BG-DEF-017` implemented; `BG-THM-009` through `BG-THM-034` proved; residual derivations and abstract sampled-parent infrastructure are in `BandGauge/Hilbert` and `BandGauge/Bloch`; the exact conditional operator/spectral fields, continuous correlation optimization, and canonical admissible-set geometry are instantiated in `BandGauge/Papers/Ragasa2026A`; concrete data remain open | `BandGauge/Geometry` |
| Bloch sewing and finite samples | reciprocal-group sewing, covariant operators, abstract Hermitian rank-two sampled Hamiltonians, trace centering, and unitary common-power fields | Ragasa2026c sewing requirements and Ragasa2026a rank-two fields | `BG-BLOCH-DEF-001` through `BG-BLOCH-DEF-011` implemented; `BG-BLOCH-THM-001` through `BG-BLOCH-THM-011` proved; no Bloch--Floquet construction from a potential | `BandGauge/Bloch` |
| Hilbert geometry | closed residual balls, exact intersection criterion, attainment, and set distance | classical normed/Hilbert-space geometry; later Ragasa2026a/c Frobenius-loss instantiation | `BG-HILBERT-DEF-001/002` implemented and `BG-HILBERT-THM-001` through `BG-HILBERT-THM-004` proved | `BandGauge/Hilbert` |
| Weighted finite residual algebra | rank-two complex operator fields and real spectral fields, source-normalized powers, polarization, cross-term cancellation, and scalar-loss bridges | Ragasa2026a losses and Supplementary S1.1 | `BG-HILBERT-DEF-003` through `BG-HILBERT-DEF-012` implemented; `BG-HILBERT-THM-005` through `BG-HILBERT-THM-015` proved; exact conditional operator fields and a canonical exact finite Hermitian spectral diagonalization are supplied by the Paper A module; periodic-potential construction and concrete-data binding remain open | `BandGauge/Hilbert` |
| Exact rank-two certificates | exact rational-center and rational-enclosure schemas and Boolean checkers for a positive-scale spectral witness, full-ellipse containment, and strict separation | Ragasa2026a scalar loss geometry and future runtime binding | `BG-CERT-DEF-001` through `BG-CERT-DEF-013` implemented; `BG-CERT-THM-001` through `BG-CERT-THM-009` proved, including `7/10 < 1/√2 < 71/100`; this generic module alone supplies no source instance or parser binding | `BandGauge/Certificates` |
| Paper A fields, optimized geometry, and certificate binding | strict-positive sampled parent, global real rotation, momentum-dependent comparison, canonical spectral and Pauli decompositions, continuous correlation optimization, actual loss sublevel sets, full-plane/rectangle geometry, explicit scalar-certificate binding, and the exact equal-weight constructed false positive | Ragasa2026a exact loss geometry | `BG-RAGASA2026A-DEF-001` through `BG-RAGASA2026A-DEF-024` implemented; `BG-RAGASA2026A-THM-001` through `BG-RAGASA2026A-THM-028` are conditional bridges; `BG-RAGASA2026A-THM-029` through `BG-RAGASA2026A-THM-034` bind and check the exact two-observation analytic construction, its exact positive admissible-set distance, and its resolution corollary; three source-specific conclusions and one certificate are checked, but no runtime artifact, four-state-parent result, material validation, or parser binding is claimed | `BandGauge/Papers/Ragasa2026A` |
| Finite reduction bases | rectangular basis `Φ`, orthonormal-column equation, projector `Φ Φᵀ`, reduced Hamiltonian `Φᵀ H Φ`, full-space embedding, and exact `Hemb = P H P` bridge | source-neutral algebra motivated by the PIAB1D retained-subspace contract | `QM-REDUCTION-DEF-001` through `QM-REDUCTION-DEF-003` implemented; `QM-REDUCTION-THM-001` through `QM-REDUCTION-THM-006` proved; runtime arrays, binary64 orthogonality, and serialized evidence remain external | `QuantumMechanics/FiniteDimensional` |
| Finite rank-one resolvent algebra | conjugated outer products, complex rank-one updates, scalar resolvent denominator, determinant factorization, exact singularity criterion, Sherman--Morrison inverse, attractive-sign secular equation, Hermitian specialization, and resolvent-constructed eigenvector equation | source-neutral finite algebra motivated by the impurity-defect-1D analytical-oracle calculation | `QM-RESOLVENT-DEF-001` through `QM-RESOLVENT-DEF-008` implemented and `QM-RESOLVENT-THM-001` through `QM-RESOLVENT-THM-014` proved; root existence/uniqueness, numerical root-finding, runtime arrays, spectra, retained evidence, and physical-defect applicability remain external | `QuantumMechanics/FiniteDimensional` |
| Finite spin embeddings, projection, and Pauli residuals | two-state lift `A ⊗ₖ I₂`, spin injections and pullbacks, partial spin trace, exact Frobenius-optimal half-trace projection, fixed points, Pythagorean and uniqueness results, standard Pauli channels, Hermiticity, and exact collinear/general residual powers | source-neutral algebra motivated by the impurity-spin-spaces calculation | `QM-SPIN-DEF-001` through `QM-SPIN-DEF-003`, `QM-SPIN-PROJECTION-DEF-001` through `QM-SPIN-PROJECTION-DEF-004`, and `QM-SPIN-PAULI-DEF-001` through `QM-SPIN-PAULI-DEF-005` implemented; `QM-SPIN-THM-001` through `QM-SPIN-THM-014`, `QM-SPIN-PROJECTION-THM-001` through `QM-SPIN-PROJECTION-THM-019`, and `QM-SPIN-PAULI-THM-001` through `QM-SPIN-PAULI-THM-017` proved; authored coefficient matrices, runtime values, spin-frame rotations, time reversal, spectra, and physical adequacy remain external | `QuantumMechanics/FiniteDimensional` |
| Finite block folding and extraction-route commutativity | normalized finite-character folding, orbital-block lift, unit-modulus row phases, finite block-hopping supercells, exact Bloch-fiber block diagonalization, coordinate pullbacks, energy-reference correction, defect subtraction, and spin-lift commutativity | source-neutral algebra motivated by the matched and independent-route impurity-defect-1D protocols | `SS-FOLDING-DEF-001` through `SS-FOLDING-DEF-009` and `SS-ROUTE-DEF-001` through `SS-ROUTE-DEF-002` implemented; `SS-FOLDING-THM-001` through `SS-FOLDING-THM-016` and `SS-ROUTE-THM-001` through `SS-ROUTE-THM-010` proved; runtime Fourier matrices, twist representatives, authored hopping blocks, truncation inventories, tolerances, spectra, and artifact bindings remain external | `SolidState/FiniteLattice` |
| Finite lattice-gauge loops | ordered link paths, endpoint covariance, closed-loop conjugation, commutative loop and plaquette invariance, Bargmann-product and principal-phase invariance, matrix Wilson conjugation and determinant invariance, plus rank-one projector-product/trace crosswalks | source-neutral exact algebra motivated by the immutable periodic-1D/2D protocols | `SS-GAUGE-DEF-001` through `SS-GAUGE-DEF-016` implemented and `SS-GAUGE-THM-001` through `SS-GAUGE-THM-023` proved; runtime overlap matrices, runtime normalization, loop construction, sewing selection, phase unwrapping, eigenphase spectra, Chern integrality, continuum topology, Wannier90 execution, numerical meshes, and physical applicability remain external | `SolidState/FiniteLattice` |
| Rank-two algebra | trace/traceless decomposition for real symmetric `2 × 2` matrices | Ragasa2026a exact loss geometry | complex Hermitian trace centering implemented; real-symmetric specialization unassessed | `BandGauge/Foundations` |
| Rank-two algebra | real `SO(2)` conjugation, Pauli-coordinate Frobenius pairing, second-harmonic maximum, and canonical half-open maximizing angle | same | implemented as `BG-FOUNDATION-DEF-001` through `BG-FOUNDATION-DEF-009`; proved as `BG-FOUNDATION-THM-001` through `BG-FOUNDATION-THM-007` | `BandGauge/Foundations` |
| Quadratic geometry | common-curvature loss formulas and ellipse centers/radii | Ragasa2026a | source-specific statement not selected | `BandGauge/Geometry` |
| Aligned operator comparison | a sewn Hermitian retained-reference field minus a sewing-compatible unitary pullback of a sewn Hermitian candidate field is a sewn Hermitian difference field | Paper 3 higher-rank composite-band protocol and its formalization plan | planned; pullback covariance already proved as `BG-BLOCH-THM-002`, but the difference and Hermiticity closure statements are not selected declarations | `BandGauge/Bloch` |
| Spectral reconstruction | exact retained invariant-subspace compression and reconstruction; later approximate isometric eigenpair residual bounds | Paper 3 higher-rank composite-band protocol; numerical eigensolver extension remains external | planned; exact finite Hermitian diagonalization exists in the Paper A layer, but no ambient-parent-to-retained-reference certificate API is selected | `BandGauge/Projection` |
| Finite fidelity decisions | weak-all/strict-any minimization dominance, efficient weak improvers, Pareto sufficiency for coordinatewise thresholds, relaxed-threshold monotonicity, and minimum-cost attainment | Paper 3 higher-rank composite-band protocol and Paper 2 finite decision landscape | `BG-DECISION-DEF-001` through `BG-DECISION-DEF-009` implemented and `BG-DECISION-THM-001` through `BG-DECISION-THM-013` proved for an abstract finite decision type; concrete objective tables, interval comparisons, common Paper 3 thresholds, and source/runtime schemas remain open | `BandGauge/Decision` |
| Finite objective certificates | exact dominance, exact threshold feasibility, exact nondominated masks, then outward-rounded interval objectives and exhaustive decision/mesh coverage | future immutable computational export | exact total-table checks are implemented as `BG-CERT-DEF-014` through `BG-CERT-DEF-016`, with soundness/completeness bridges `BG-CERT-THM-010` through `BG-CERT-THM-012`; interval comparison, external coverage, parser binding, and concrete objective tables remain open | `BandGauge/Certificates` |
| Tetrahedral tight binding | normalized `sp³` Hadamard transform, `sp³s⋆` identity extension, two-sublattice ten-orbital transform, tetrahedral bond phases and structure factors, abstract Vogl parameter slots, structural zeros, and Hermitian block assembly | Vogl et al. (1983) equations and calculation-owned bulk-silicon technical note; standard finite matrix algebra | `SS-TB-DEF-001` through `SS-TB-DEF-019` implemented and `SS-TB-THM-001` through `SS-TB-THM-035` proved; no empirical values, numerical spectra, Python binding, or material validation encoded | `SolidState/TightBinding` |
| Finite Fourier | transform normalization, inversion, Parseval, conjugate symmetry, exact full-minus-truncated hopping-tail identity, and fixed-unitary equivariance | Ragasa2026a/c and spectral-bridge/tight-binding comparison plan | convention-neutral reconstruction/truncation and an explicit finite-abelian conjugated-forward/unconjugated-inverse transform implemented as `BG-FOURIER-DEF-001` through `BG-FOURIER-DEF-019`; exact retained/omitted decomposition, two-sided inversion, inner-product and power Parseval, reconstructed residual-to-omitted-power identity, Hermitian coefficient pairing, negation-closed truncation preservation, Hermitian reconstruction, entrywise matrix Parseval, exact matrix Frobenius residual-tail equality, the constant/uniform rank-two `weight/(2Eref²)` bridge, arbitrary-finite-rank Frobenius invariance under `A ↦ Uᴴ A U`, and fixed-unitary coefficient/reconstruction/truncation commutativity proved as `BG-FOURIER-THM-001` through `BG-FOURIER-THM-047`; momentum-dependent gauges, nonuniform quadrature certification, publication-mesh, physical-shell, and runtime-evidence bindings remain open | `BandGauge/Fourier` |
| Locality | nonzero Fourier support/power as a representation-locality quantity | Ragasa2026a/b | exact omitted weight, nested-support monotonicity, Hilbert-power residual equality, and unweighted matrix Frobenius residual equality and constant/uniform paper-coefficient normalization implemented; nonuniform weights, physical-range interpretation, and source binding remain open | `BandGauge/Fourier` |
| Projection | an explicit finite-range matrix field whose spectral projection is not a finite Fourier polynomial | Ragasa2026b | witness inventoried; Lean representation unassessed | `BandGauge/Projection` |
| Continuum Fourier | normalized torus integral and Parseval specialization | Ragasa2026a/b | unassessed; deferred until discrete conventions freeze | `BandGauge/Fourier` |
| Special functions | Jacobi–Anger expansion and Bessel parity/product identities | Ragasa2026a/b | unassessed; deferred | `BandGauge/SpecialFunctions` |
| Tail bounds | factorial coefficient and complete-shell tail estimates | Ragasa2026b | unassessed; deferred | `BandGauge/SpecialFunctions` |
| Quantum state representatives | normalized complex vectors and unit-modulus phase changes | source-neutral foundation; exact Shankar crosswalk deferred | `QM-STATE-DEF-001/002` implemented; no ray quotient or full postulate claim | `QuantumMechanics` |
| Finite pure-state measurement | finite bounded operation family, supplied norm completeness, Born weights, phase invariance, and positive-probability update | source-neutral foundation; exact Shankar crosswalk deferred | `QM-MEASUREMENT-DEF-001` through `003`, `QM-MEASUREMENT-LEM-001` through `003`, and `QM-MEASUREMENT-THM-001` through `003` implemented and proved; no continuous-outcome or general observable claim | `QuantumMechanics/Measurement` |
| Ordinary Dirac objects | ordinary kets/bras, brackets, bounded rank-one outer products, and normalized projector laws | source-neutral Hilbert-space mathematics | `QM-DIRAC-DEF-001` through `006`, `QM-DIRAC-LEM-001` through `006`, and `QM-DIRAC-THM-001/002` implemented and proved; no generalized-ket claim | `QuantumMechanics` |
| Rigged Hilbert-space core | continuous dense test-space inclusion, linear generalized bras, conjugate-linear generalized kets, and injective Hilbert embeddings into both functional orientations | source-neutral functional analysis; concrete test spaces and textbook crosswalk deferred | `QM-RIGGED-DEF-001` through `005`, `QM-RIGGED-LEM-001` through `005`, and `QM-RIGGED-THM-001/002` implemented and proved; nuclearity, concrete test spaces, and generalized spectral completeness remain open | `QuantumMechanics` |
| Test-domain partial operators | included test submodule, range equivalence, induced partial operator, dense domain, domain invariance, formal-adjoint lift, and containment in the maximal adjoint | source-neutral functional analysis; concrete Hamiltonian and textbook crosswalk deferred | selected Mathlib's `LinearPMap`, `LinearPMap.IsFormalAdjoint`, `LinearPMap.adjoint`, `IsFormalAdjoint.le_adjoint`, closedness, and closability APIs rather than defining a competing unbounded-operator type; `QM-OPERATOR-DEF-001` through `005`, `QM-OPERATOR-LEM-001` through `005`, and `QM-OPERATOR-THM-001` through `003` implemented and proved; adjoint equality, closedness, essential self-adjointness, and spectral results remain open | `QuantumMechanics/Operator` |
| QHO Hermite analysis | physicists' Hermite recurrence, differential equation, Gaussian derivatives, and pointwise dimensionless QHO eigenfunction identity | standard exact Hermite/QHO mathematics; computational-source formula crosswalk | implemented as `QHO-HERMITE-DEF-001` through `QHO-HERMITE-DEF-007`, `QHO-HERMITE-LEM-001` through `QHO-HERMITE-LEM-011`, and `QHO-HERMITE-THM-001/002`; normalization, orthogonality, completeness, and operator-domain claims remain open | `QuantumMechanics/HarmonicOscillator` |
| QHO finite ladder | retained annihilation, creation, number, commutator, energy, and direct Hamiltonian matrices | computational ladder convention and exact finite algebra | implemented as `QHO-LADDER-DEF-001` through `QHO-LADDER-DEF-006`; supporting identities `QHO-LADDER-LEM-001` through `QHO-LADDER-LEM-008`; exact boundary commutator `QHO-LADDER-THM-001` | `QuantumMechanics/HarmonicOscillator` |
| QHO truncation distortion | compression nonmultiplicativity and highest-state Hamiltonian reconstruction defect | exact finite-matrix mechanism required before source migration | implemented as `QHO-TRUNCATION-DEF-001` through `QHO-TRUNCATION-DEF-004`, `QHO-TRUNCATION-LEM-001` through `QHO-TRUNCATION-LEM-005`, and `QHO-TRUNCATION-THM-001` through `QHO-TRUNCATION-THM-003`; no numerical-result acceptance or continuum-error claim | `QuantumMechanics/HarmonicOscillator` |
| QHO finite comparison | exact Gram-isometry implication, symmetric pullback, and diagonal/off-diagonal Frobenius decomposition | finite comparison algebra used by the owner calculation | implemented as `QHO-COMPARISON-DEF-001` through `QHO-COMPARISON-DEF-006`, `QHO-COMPARISON-LEM-001` through `QHO-COMPARISON-LEM-005`, and `QHO-COMPARISON-THM-001/002`; the eigendecomposition or runtime matrices are not verified | `QuantumMechanics/HarmonicOscillator` |
| QHO finite difference | centered stencil, sampled diagonal potential, and symmetry | computational-source finite-difference convention | implemented as `QHO-FINITE-DIFFERENCE-DEF-001` through `QHO-FINITE-DIFFERENCE-DEF-004` and `QHO-FINITE-DIFFERENCE-LEM-001` through `QHO-FINITE-DIFFERENCE-LEM-004`; no consistency or convergence theorem | `QuantumMechanics/HarmonicOscillator` |
| Finite-dimensional compression | consistent, unmatched, and discarded-sector residuals | reusable exact algebra shared by controlled model systems | `QM-COMPRESSION-DEF-001` through `DEF-004`, `LEM-001`, and `THM-001/002` implemented; the discarded-sector equality requires explicit idempotence and commutation | `QuantumMechanics/FiniteDimensional` |
| Decomposition identifiability | exact additive shift and nonuniqueness | reusable operator-analysis semantics | `QM-IDENTIFIABILITY-DEF-001/002` and `THM-001/002` implemented; no physical assignment or statistical-identifiability claim | `QuantumMechanics/FiniteDimensional` |
| Finite model-class fitting | coordinate masks, diagonal/tridiagonal fits, scalar diagonal mean, unrestricted exact fit | reusable exact counterpart of declared Frobenius model classes | `QM-MODEL-FIT-DEF-001` through `DEF-008`, `LEM-001` through `LEM-003`, and `THM-001` through `THM-006` implemented | `QuantumMechanics/FiniteDimensional` |
| Centered Dirichlet finite difference | real interior-coordinate stencil, symmetry, and exact inverse-square spacing scaling | reusable source-neutral finite-difference convention | `QM-FD-DEF-001/002`, `LEM-001`, and `THM-001/002` implemented; no continuum consistency or convergence theorem | `QuantumMechanics/FiniteDifference` |
| Exponential lattice modes | complex translation character, centered-difference eigenvalue, periodicity, sine-normalized antisymmetric Dirichlet combination, and reality bridge | reusable foundation intended for later Bloch translation work | `QM-EXPONENTIAL-DEF-001` through `DEF-005`, `LEM-001`, and `THM-001` through `THM-008` implemented; no Bloch--Floquet theorem | `QuantumMechanics/FiniteDifference` |
| Finite Dirichlet mode matrix | zero-ghost neighbor values, complex-linear difference operator, exact matrix realization, finite exponential eigenvector, and Hermiticity | reusable exact finite bridge | `QM-DIRICHLET-MATRIX-DEF-001` through `DEF-007`, two supporting endpoint lemmas, and `THM-001` through `THM-005` implemented; no runtime-array identification | `QuantumMechanics/FiniteDifference` |
| Twisted and periodic finite cycles | scalar-twisted wrapped neighbors, exact matrix and corner realization, unit-circle Hermiticity, compatible characters, canonical real-angle twists, and PBC as twist one | reusable boundary-condition representation layer | `QM-TWISTED-DEF-001` through `DEF-010`, `LEM-001/002`, `THM-001` through `THM-012`, `QM-PERIODIC-DEF-001` through `DEF-006`, and `THM-001` through `THM-010` implemented; scalar real-space twist is not yet identified with reciprocal-fiber Bloch sewing | `QuantumMechanics/FiniteDifference` |
| Doubled-cycle odd extension | zero boundary fixed points, reflected-negative extension, reflection oddness, and exact periodic-to-Dirichlet restriction | reusable boundary-sector bridge | `QM-ODD-EXTENSION-DEF-001` through `DEF-006`, `LEM-001/002`, and `THM-001` through `THM-005` implemented; the proved operator bridge is restriction to the first interior half, not a Bloch--Floquet theorem | `QuantumMechanics/FiniteDifference` |
| Constant lattice regions and finite barriers | constant-potential residuals, reciprocal character superpositions, determinant-one one-site transfer matrices, finite transfer products, piecewise left/barrier/right specialization, and exact interface-state propagation | classical exact finite-difference and transfer-matrix algebra; source-neutral methodology infrastructure | `QM-CONSTANT-REGION-DEF-001` through `DEF-003`, `LEM-001/002`, `THM-001` through `THM-004`, `QM-TRANSFER-DEF-001` through `DEF-003`, `THM-001` through `THM-005`, `QM-BARRIER-DEF-001` through `DEF-003`, `THM-001` through `THM-011`, `QM-BARRIER-MATCHING-DEF-001` through `DEF-005`, and `THM-001` through `THM-008` implemented; interface-coordinate existence/uniqueness excludes coincident reciprocal roots, while no constrained scattering-amplitude solution, flux probability, infinite-barrier limit, continuum convergence, or retained numerical claim is supplied | `QuantumMechanics/FiniteDifference` |
| PIAB1D finite realization | scaled Dirichlet stencil, cyclic corner closure and its exact source-neutral periodic-matrix bridge, exponential Dirichlet endpoint, local recurrence, real-representability, and finite matrix eigenpair | dirty computational crosswalk; exact source-neutral mathematics | `PIAB1D-FD-DEF-001`, `PIAB1D-FD-THM-001/002`, `PIAB1D-BOUNDARY-DEF-001/002`, `LEM-001`, `THM-001` through `THM-004`, and `PIAB1D-SPECTRUM-DEF-001` through `DEF-007`, `THM-001` through `THM-019` implemented; convergence and runtime binding remain open | `QuantumMechanics/Piab1d` |
| Exact integral coordinate bridge | fixed FCC--Bain `3 × 3` integer matrices, two-sided inverse products, determinant one, induced mutual inverses, and bijectivity modulo every positive finite size | `projectkoios-physkit` `FccBainCoordinateBridge3D` at commit `7157dcedd0d220673d443c1c025e35a6fd1ffa7a` | source constants implemented as `PKF-PHYSKIT-DEF-001` through `PKF-PHYSKIT-DEF-007`; exact results proved as `PKF-PHYSKIT-THM-001` through `PKF-PHYSKIT-THM-005`; uses Mathlib matrix multiplication, `det_fin_three`, ring-homomorphic matrix mapping, `mulVec_mulVec`, and `ZMod`; no owner runtime-object or `numpy.int64` execution binding | `Crosswalks/PhysKit` |

## Reduction-basis library-search record

- Required signature: a rectangular real matrix `Φ : Matrix ι κ ℝ`, the exact premise
  `Φᵀ Φ = I`, and typed constructions `Φ Φᵀ`, `Φᵀ H Φ`, and
  `Φ (Φᵀ H Φ) Φᵀ`.
- Mathlib inspected at pinned revision `56a005855ea17e0b0958f73ec801ae140b0a1679`:
  `Matrix.HasOrthogonalCols` records pairwise orthogonality but not unit column norms;
  `Orthonormal` is the canonical vector-family predicate; square orthogonal/unitary matrix APIs do
  not represent a genuinely rectangular injection. The module therefore introduces no duplicate
  orthonormality predicate and uses the source equation `Φᵀ Φ = I` directly.
- Reused Mathlib infrastructure: rectangular matrix multiplication, transpose, `mulVec`,
  `Matrix.IsSymm`, and transpose-of-product lemmas. No missing upstream lemma was required.
- Physlib was not relevant because the required exact finite matrix APIs are already supplied by
  pinned Mathlib; no Physlib dependency was adopted.
- Ownership: the source-neutral constructions belong under
  `ProjectKoios.QuantumMechanics.FiniteDimensional`; PIAB1D dimensions, runtime arrays, and evidence
  binding remain downstream obligations.

## Rank-one-resolvent library-search record

- Required signature: a finite complex matrix `A`, vectors `u` and `v`, an update
  `A + λ |u⟩⟨v|`, the scalar `1 + λ⟨v|A⁻¹|u⟩`, determinant and inverse identities under
  explicit invertibility/nonzero premises, and the attractive self-update specialization.
- Mathlib inspected at pinned revision `56a005855ea17e0b0958f73ec801ae140b0a1679`:
  `Matrix.det_add_replicateCol_mul_replicateRow` supplies the determinant update;
  `Matrix.mul_nonsing_inv`, `Matrix.nonsing_inv_mul`, and
  `Matrix.isUnit_det_of_right_inverse` supply finite inverse bridges; row/column and
  `vecMulVec` multiplication lemmas supply the rank-one contractions. Weinstein--Aronszajn,
  Woodbury, and Schur-complement APIs were also inspected, but no existing declaration packaged the
  exact conjugated-vector Sherman--Morrison and secular-root signatures required here.
- The module introduces only named connecting definitions for the conjugated outer product,
  resolvent contraction, denominator, inverse candidate, and attractive-sign specialization. It
  reuses Mathlib's determinant and nonsingular-inverse infrastructure rather than defining a second
  matrix inverse.
- Physlib was not adopted because pinned Mathlib supplies all required finite matrix algebra.
- Ownership: source-neutral exact finite rank-one algebra belongs under
  `ProjectKoios.QuantumMechanics.FiniteDimensional`; numerical root searches, runtime arrays,
  retained spectra, source-specific defect parameters, and physical applicability remain
  downstream obligations.

## Spin-embedding library-search record

- Required signature: finite complex orbital matrices, the exact Kronecker lift `A ⊗ₖ I₂`,
  rectangular selected-spin injections, conjugate-transpose sandwiches, and the Frobenius norm used
  by the calculation-level contract.
- Mathlib inspected at pinned revision `56a005855ea17e0b0958f73ec801ae140b0a1679`:
  `Mathlib.LinearAlgebra.Matrix.Kronecker` supplies `Matrix.kronecker_apply`,
  `conjTranspose_kronecker`, `mul_kronecker_mul`, and `trace_kronecker`;
  `Mathlib.Analysis.Matrix.Normed` supplies the scoped Frobenius norm and
  `Matrix.frobenius_norm_def`; `Mathlib.LinearAlgebra.Matrix.Hermitian` supplies
  `Matrix.IsHermitian`. No repository-owned replacement for these APIs was introduced.
- The selected-spin injection, pullback, partial spin trace, and exact half-trace projection are
  source-neutral connecting constructions absent from the inspected Mathlib API. Their exact
  entrywise, fixed-point, trace, and Hermiticity identities are proved in `SpinEmbedding.lean` and
  `SpinIndependentProjection.lean` rather than assumed. Mathlib has no inspected standard Pauli
  matrix API, so `SpinPauliResidual.lean` declares the three explicit `Fin 2` matrices and proves
  their required Hermiticity and Frobenius identities entrywise.
- Physlib was not adopted because pinned Mathlib supplies all finite matrix, Kronecker, Hermitian,
  trace, and Frobenius infrastructure required by this slice.
- Ownership: abstract two-state spin-coordinate algebra belongs under
  `ProjectKoios.QuantumMechanics.FiniteDimensional`; authored `4 × 4` coefficient matrices,
  floating-point evidence, bindings from those matrices to the abstract residual identities, and
  time-reversal applicability remain downstream obligations.

## Finite-folding library-search record

- Required signature: a normalized finite cyclic/abelian character transform, an unchanged finite
  orbital block, a finite translation-invariant block-hopping operator, exact Bloch fibers, and
  conjugate-transpose coordinate pullbacks.
- Mathlib inspected at pinned revision `56a005855ea17e0b0958f73ec801ae140b0a1679`:
  finite-additive-character orthogonality and Pontryagin duality supply the complete character
  inventory; matrix Kronecker, conjugate-transpose, multiplication, and finite-sum APIs supply the
  block lift. No inspected Mathlib declaration directly packages the cell-major block-supercell
  convention or the full route-commutativity statement.
- The implementation reuses Mathlib characters and proves the normalization, block lift,
  unit-modulus phase invariance, block diagonalization, scalar-shift transport, and subtraction
  commutativity. `G = ZMod N` is exposed as the one-dimensional cyclic specialization.
- Physlib was not adopted because the pinned Mathlib APIs cover this exact finite algebra.
- Ownership: abstract exact folding and route algebra belongs under
  `ProjectKoios.SolidState.FiniteLattice`; Python matrices, representative choices, numerical
  tolerances, and retained evidence remain downstream obligations.

## Finite gauge-loop library-search record

- Required signature: an ordered finite path product, pointwise inverse-left/forward-right link
  action, endpoint cancellation, closed-loop conjugation, scalar/Bargmann invariance, and
  matrix-Wilson determinant invariance.
- Mathlib inspected at pinned revision `56a005855ea17e0b0958f73ec801ae140b0a1679`:
  `List` recursion supplies the ordered path carrier; `Units` allows invertible gauge values while
  leaving link values noninvertible; `unitary`, `Unitary.toUnits`, `Matrix.unitaryGroup`, complex
  inner products, `Complex.arg`, and `Matrix.det_mul` supply the phase, frame, and determinant
  infrastructure. No inspected declaration packaged the required start-plus-tail loop convention
  or its endpoint-cancellation theorem.
- `GaugeLoops.lean` introduces only the connecting finite-path and named Bargmann/Wilson
  definitions. `ProjectorBargmann.lean` freezes the ordered state-matrix convention, reuses the
  finite rank-one matrix from `QuantumMechanics/FiniteDimensional`, proves Hermiticity and
  conditional idempotence, and identifies the ordered product trace with the Bargmann product.
  Both modules reuse Mathlib's unitary, inner-product, matrix, trace, determinant, and
  complex-argument APIs.
- Physlib was not adopted because pinned Mathlib supplies the exact algebra needed by this slice.
- Ownership: source-neutral finite link/loop algebra belongs under
  `ProjectKoios.SolidState.FiniteLattice`; numerical overlap construction, loop orientation,
  reciprocal sewing, Chern integrality, continuum topology, Wannier90 execution, mesh validity,
  retained evidence, and physical interpretation remain downstream obligations.

## Required library-search record

Before creating a repository-owned definition, record:

1. the exact mathematical signature required by the source;
2. Mathlib declarations inspected and why they do or do not fit;
3. the immutable Physlib revision inspected, if relevant;
4. any missing lemma and its smallest reusable statement;
5. whether the result belongs downstream here or is a later upstream candidate; and
6. the chosen namespace and import boundary.

Do not create a compatibility facade or duplicate a library definition merely to match publication notation.
