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
| — | `ProjectKoios.BandGauge.Papers.Ragasa2026A.placeholder` | definition | metadata definition | none | records zero paper-specific statements, zero proved paper-specific theorems, zero checked certificates |
| — | `ProjectKoios.BandGauge.Papers.Ragasa2026B.placeholder` | definition | metadata definition | none | same |
| — | `ProjectKoios.BandGauge.Papers.Ragasa2026C.placeholder` | definition | metadata definition | none | same; generic foundational clauses do not constitute a paper-namespace instantiation |

A proved theorem ID remains bound to its exact Lean proposition. A different proposition receives a new declaration and ID and may use earlier theorems as dependencies.

## Planning inventory — not Lean declarations

The planning identifiers below organize broader source families. They are not theorem names or claims that an entire family is complete; a status cell may refer to separately listed statement IDs that already exist.

| Planning ID | Candidate theorem family | Source crosswalk | Tentative ownership | Status |
|---|---|---|---|---|
| `BG-PLAN-001` | witnesses and certified separation | Ragasa2026C | `BandGauge/Geometry` | extended representation implemented; four mathematical clauses proved as `BG-THM-001` through `BG-THM-004`; real-valued bridge and paper-specific instantiation remain open |
| `BG-PLAN-002` | rank-two exact loss geometry | Ragasa2026A | `BandGauge/Geometry` | source inventoried; definitions and assumptions not frozen |
| `BG-PLAN-003` | spectral projection can destroy finite hopping support | Ragasa2026B | `BandGauge/Projection` | witness inventoried; representation and proof plan unassessed |
| `BG-PLAN-004` | discrete residual–locality identity | Ragasa2026A | `BandGauge/Fourier` | candidate family only; discrete convention not frozen |

See `definition-and-lemma-inventory.md`, `BandGauge/Geometry/witness-separation-statement-selection.md`, `witness-catalog.md`, and `roadmap.md` for planning details.

The declaration table is the sole proof-status ledger. Add one row for each new definition or theorem. Do not duplicate live theorem counts in other documents.

Publication theorem prose inventoried in `publication-crosswalk.md` is not a Lean declaration and is not formalized or proved unless a declaration row identifies it.
