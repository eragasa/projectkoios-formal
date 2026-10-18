# Theorem manifest

Current repository status. Only the first table inventories declarations that exist in Lean.

| Statement ID | Lean declaration | Kind | Proof status | Scientific content | Assumptions / authorities |
|---|---|---|---|---|---|
| — | `ProjectKoios.Formal.harnessCompiles : True` | theorem | exact proof (`trivial`) | none; harness smoke test only | Lean kernel and pinned imports |
| `BG-DEF-001` | `ProjectKoios.BandGauge.Geometry.admissibleSetEDist` | definition | implemented | extended infimum distance between two admissible subsets of one metric model-parameter domain | `[MetricSpace X]`; `ENNReal`/`edist`; empty input remains nonfinite |
| `BG-THM-001` | `ProjectKoios.BandGauge.Geometry.admissibleSetEDist_le_edist_of_mem` | theorem | proved; no admissions | every feasible pair bounds admissible-set distance above | `[MetricSpace X]`; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-002` | `ProjectKoios.BandGauge.Geometry.admissibleSetEDist_eq_zero_of_mem_inter` | theorem | proved; no admissions | a common candidate in both admissible classes forces zero distance | `[MetricSpace X]`; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-003` | `ProjectKoios.BandGauge.Geometry.disjoint_of_pos_le_admissibleSetEDist` | theorem | proved; no admissions | a certified strictly positive lower bound forces disjointness | `[MetricSpace X]`; `ENNReal` lower bound; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-004` | `ProjectKoios.BandGauge.Geometry.exists_admissibleSetEDist_eq_edist_and_pos_of_compact` | theorem | proved; no admissions | nonempty compact disjoint sets attain a strictly positive distance | `[MetricSpace X]`; compactness, nonemptiness, disjointness; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-005` | `ProjectKoios.BandGauge.Geometry.admissibleSetEDist_ne_top_of_nonempty` | theorem | proved; no admissions | nonempty admissible sets have finite extended distance | `[MetricSpace X]`; nonemptiness; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-DEF-002` | `ProjectKoios.BandGauge.Geometry.admissibleSetDist` | definition | implemented | real-valued admissible-set distance with nonemptiness proofs in the interface | `[MetricSpace X]`; nonemptiness; `ENNReal.toReal` |
| `BG-THM-006` | `ProjectKoios.BandGauge.Geometry.ofReal_admissibleSetDist_eq_admissibleSetEDist` | theorem | proved; no admissions | real-to-extended conversion recovers `BG-DEF-001` | `[MetricSpace X]`; nonemptiness; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-DEF-003` | `ProjectKoios.BandGauge.Geometry.spectralAdmissibleSet` | definition | implemented | candidates satisfying the declared spectral-loss budget | `[MetricSpace X]`; real-valued loss and budget |
| `BG-DEF-004` | `ProjectKoios.BandGauge.Geometry.alignedOperatorAdmissibleSet` | definition | implemented | candidates satisfying the declared restricted aligned-operator-loss budget | `[MetricSpace X]`; real-valued loss and budget |
| `BG-THM-007` | `ProjectKoios.BandGauge.Geometry.admissibleSetEDist_eq_zero_of_loss_bounds` | theorem | proved; no admissions | one candidate satisfying both budgets forces zero admissible-set distance | one shared metric domain; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-008` | `ProjectKoios.BandGauge.Geometry.not_exists_jointly_admissible_of_pos_le_admissibleSetEDist` | theorem | proved; no admissions | certified positive separation excludes every jointly admissible candidate | one shared metric domain; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-DEF-005` | `ProjectKoios.BandGauge.Geometry.RankTwoParameter` | abbreviation | implemented | Euclidean shift/splitting-scale parameter plane | `EuclideanSpace ℝ (Fin 2)`; domain restrictions are separate |
| `BG-DEF-006` | `ProjectKoios.BandGauge.Geometry.rankTwoSpectralLossSq` | definition | implemented | reduced rank-two spectral squared loss | scalar formula; matrix-residual derivation remains external |
| `BG-DEF-007` | `ProjectKoios.BandGauge.Geometry.rankTwoAlignedOperatorLossSq` | definition | implemented | reduced rank-two aligned-operator squared loss for one correlation parameter | scalar formula; matrix-residual derivation and matrix-level correlation bound remain external |
| `BG-THM-009` | `ProjectKoios.BandGauge.Geometry.irreducibleOperatorFloor_le_rankTwoAlignedOperatorLossSq` | theorem | proved; no admissions | aligned-operator squared loss is bounded below by its irreducible floor | `0 ≤ κ`; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-010` | `ProjectKoios.BandGauge.Geometry.rankTwoAlignedOperatorAdmissibleSet_eq_empty_of_sq_lt_floor` | theorem | proved; no admissions | a squared operator budget below the irreducible floor makes the reduced operator admissible set empty | `0 ≤ κ`; strict budget inequality; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-DEF-008` | `ProjectKoios.BandGauge.Geometry.rankTwoNormalizedCorrelation` | definition | implemented | scalar normalized correlation `b / κ` | matrix-residual correlation inequality remains external |
| `BG-THM-011` | `ProjectKoios.BandGauge.Geometry.abs_rankTwoNormalizedCorrelation_le_one` | theorem | proved; no admissions | a bounded correlation normalized by a positive splitting scale has magnitude at most one | `0 < κ`; `|b| ≤ κ`; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-012` | `ProjectKoios.BandGauge.Geometry.rankTwoIrreducibleOperatorFloor_nonneg` | theorem | proved; no admissions | the irreducible operator floor is nonnegative | `0 ≤ κ`; `|μ| ≤ 1`; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| `BG-THM-013` | `ProjectKoios.BandGauge.Geometry.rankTwoAlignedOperatorLossSq_nonneg` | theorem | proved; no admissions | the reduced aligned-operator squared loss is nonnegative | `0 ≤ κ`; `|μ| ≤ 1`; axioms: `propext`, `Classical.choice`, `Quot.sound` |
| — | `ProjectKoios.BandGauge.Papers.Ragasa2026A.placeholder` | definition | metadata definition | none | records zero paper-specific statements, zero proved paper-specific theorems, zero checked certificates |
| — | `ProjectKoios.BandGauge.Papers.Ragasa2026B.placeholder` | definition | metadata definition | none | same |
| — | `ProjectKoios.BandGauge.Papers.Ragasa2026C.placeholder` | definition | metadata definition | none | same; generic foundational clauses do not constitute a paper-namespace instantiation |

A proved theorem ID remains bound to its exact Lean proposition. A different proposition receives a new declaration and ID and may use earlier theorems as dependencies.

## Planning inventory — not Lean declarations

The planning identifiers below organize broader source families. They are not theorem names or claims that an entire family is complete; a status cell may refer to separately listed statement IDs that already exist.

| Planning ID | Candidate theorem family | Source crosswalk | Tentative ownership | Status |
|---|---|---|---|---|
| `BG-PLAN-001` | witnesses and certified separation | Ragasa2026C | `BandGauge/Geometry` | see the `BandGauge.Geometry` declaration rows above; concrete paper loss formulas and certificate data remain open |
| `BG-PLAN-002` | rank-two exact loss geometry | Ragasa2026A | `BandGauge/Geometry` | scalar loss and normalized-correlation definitions plus lower-bound, emptiness, and nonnegativity consequences implemented; the matrix-residual proof of `|b| ≤ κ`, loss derivation, and ellipse geometry remain open |
| `BG-PLAN-003` | spectral projection can destroy finite hopping support | Ragasa2026B | `BandGauge/Projection` | witness inventoried; representation and proof plan unassessed |
| `BG-PLAN-004` | discrete residual–locality identity | Ragasa2026A | `BandGauge/Fourier` | candidate family only; discrete convention not frozen |

See `definition-and-lemma-inventory.md`, `BandGauge/Geometry/witness-separation-statement-selection.md`, `witness-catalog.md`, and `roadmap.md` for planning details.

The declaration table is the sole proof-status ledger. Add one row for each new definition or theorem. Do not duplicate live theorem counts in other documents.

Publication theorem prose inventoried in `publication-crosswalk.md` is not a Lean declaration and is not formalized or proved unless a declaration row identifies it.
