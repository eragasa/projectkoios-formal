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
| Paper A fields and optimized geometry | strict-positive sampled parent, global real rotation, momentum-dependent comparison, canonical spectral and Pauli decompositions, continuous correlation optimization, actual loss sublevel sets, and full-plane/rectangle intersection and distance specialization | Ragasa2026a exact loss geometry | `BG-RAGASA2026A-DEF-001` through `BG-RAGASA2026A-DEF-021` implemented; `BG-RAGASA2026A-THM-001` through `BG-RAGASA2026A-THM-026` proved conditionally; rectangle transfer requires explicit containment; zero scientific instantiations and certificates | `BandGauge/Papers/Ragasa2026A` |
| Rank-two algebra | trace/traceless decomposition for real symmetric `2 × 2` matrices | Ragasa2026a exact loss geometry | complex Hermitian trace centering implemented; real-symmetric specialization unassessed | `BandGauge/Foundations` |
| Rank-two algebra | real `SO(2)` conjugation, Pauli-coordinate Frobenius pairing, second-harmonic maximum, and canonical half-open maximizing angle | same | implemented as `BG-FOUNDATION-DEF-001` through `BG-FOUNDATION-DEF-009`; proved as `BG-FOUNDATION-THM-001` through `BG-FOUNDATION-THM-007` | `BandGauge/Foundations` |
| Quadratic geometry | common-curvature loss formulas and ellipse centers/radii | Ragasa2026a | source-specific statement not selected | `BandGauge/Geometry` |
| Finite Fourier | transform normalization, inversion, Parseval, and conjugate symmetry | Ragasa2026a/c | unassessed | `BandGauge/Fourier` |
| Locality | nonzero Fourier support/power as a representation-locality quantity | Ragasa2026a/b | exact abstraction not selected | `BandGauge/Fourier` |
| Projection | an explicit finite-range matrix field whose spectral projection is not a finite Fourier polynomial | Ragasa2026b | witness inventoried; Lean representation unassessed | `BandGauge/Projection` |
| Continuum Fourier | normalized torus integral and Parseval specialization | Ragasa2026a/b | unassessed; deferred until discrete conventions freeze | `BandGauge/Fourier` |
| Special functions | Jacobi–Anger expansion and Bessel parity/product identities | Ragasa2026a/b | unassessed; deferred | `BandGauge/SpecialFunctions` |
| Tail bounds | factorial coefficient and complete-shell tail estimates | Ragasa2026b | unassessed; deferred | `BandGauge/SpecialFunctions` |

## Required library-search record

Before creating a repository-owned definition, record:

1. the exact mathematical signature required by the source;
2. Mathlib declarations inspected and why they do or do not fit;
3. the immutable Physlib revision inspected, if relevant;
4. any missing lemma and its smallest reusable statement;
5. whether the result belongs downstream here or is a later upstream candidate; and
6. the chosen namespace and import boundary.

Do not create a compatibility facade or duplicate a library definition merely to match publication notation.
