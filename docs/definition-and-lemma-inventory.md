# Definition and lemma inventory

This is a search and design inventory, not an API commitment. “Unassessed” means that no complete Mathlib/Physlib search or exact Lean signature review has yet been recorded.

| Area | Candidate concept or lemma | Source need | Library status | Intended folder |
|---|---|---|---|---|
| Finite geometry | common witness implies zero infimum distance | Ragasa2026c witness/separation proposition | unassessed | `BandGauge/Foundations` or `BandGauge/Geometry` |
| Finite geometry | positive certified lower bound implies disjointness | same | unassessed | `BandGauge/Geometry` |
| Topology | disjoint nonempty compact sets attain positive distance under the required metric hypotheses | same | likely related Mathlib infrastructure; exact API unassessed | `BandGauge/Geometry` |
| Rank-two algebra | trace/traceless decomposition for real symmetric `2 × 2` matrices | Ragasa2026a exact loss geometry | unassessed | `BandGauge/Foundations` |
| Rank-two algebra | real `SO(2)` conjugation and second-harmonic correlation | same | unassessed | `BandGauge/Geometry` |
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
