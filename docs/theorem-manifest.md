# Theorem manifest

Current repository status. Only the first table inventories declarations that exist in Lean.

| Lean declaration | Kind | Proof status | Scientific content | Assumptions / authorities |
|---|---|---|---|---|
| `ProjectKoios.Formal.harnessCompiles : True` | theorem | exact proof (`trivial`) | none; harness smoke test only | Lean kernel and pinned imports |
| `ProjectKoios.BandGauge.Papers.Ragasa2026A.placeholder` | definition | metadata definition | none | records zero statements, zero proved scientific theorems, zero checked certificates |
| `ProjectKoios.BandGauge.Papers.Ragasa2026B.placeholder` | definition | metadata definition | none | same |
| `ProjectKoios.BandGauge.Papers.Ragasa2026C.placeholder` | definition | metadata definition | none | same |

## Planning inventory — not Lean declarations

The identifiers below organize source review only. They are not theorem names, encoded statements, or proof-completion claims.

| Planning ID | Candidate theorem family | Source crosswalk | Tentative ownership | Status |
|---|---|---|---|---|
| `BG-PLAN-001` | witnesses and certified separation | Ragasa2026C | `BandGauge/Geometry` | source inventoried; exact Lean statement not selected |
| `BG-PLAN-002` | rank-two exact loss geometry | Ragasa2026A | `BandGauge/Geometry` | source inventoried; definitions and assumptions not frozen |
| `BG-PLAN-003` | spectral projection can destroy finite hopping support | Ragasa2026B | `BandGauge/Projection` | witness inventoried; representation and proof plan unassessed |
| `BG-PLAN-004` | discrete residual–locality identity | Ragasa2026A | `BandGauge/Fourier` | candidate family only; discrete convention not frozen |

See `definition-and-lemma-inventory.md`, `witness-catalog.md`, and `roadmap.md` for planning details.

## Totals

- Scientific theorem statements in Lean: **0**
- Proved scientific theorems in Lean: **0**
- Admitted scientific statements: **0**
- Repository-owned exact certificate checkers: **0**
- Checked scientific certificates: **0**
- Publication placeholders: **3**

Publication theorem prose inventoried in `publication-crosswalk.md` is not a Lean declaration and must not be counted as formalized or proved.
