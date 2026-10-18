# BandGauge geometry

This folder owns admissible-set geometry, witness/separation results, alignment losses, and reviewed rank-two finite-dimensional consequences.

## Implemented modules

`AdmissibleSets.lean` owns these declarations:

- `BG-DEF-001` — extended nonnegative admissible-set distance; status `implemented`.
- `BG-THM-001` — feasible-pair upper bound; status `proved`.
- `BG-THM-002` — common-witness zero distance; status `proved`.
- `BG-THM-003` — certified positive separation; status `proved`.
- `BG-THM-004` — compact attainment and positive distance; status `proved`.
- `BG-THM-005` — nonempty-set finiteness; status `proved`.
- `BG-DEF-002` — proof-gated real admissible-set distance; status `implemented`.
- `BG-THM-006` — real/extended representation bridge; status `proved`.
- `BG-DEF-003` — spectral admissible set; status `implemented`.
- `BG-DEF-004` — restricted aligned-operator admissible set; status `implemented`.
- `BG-THM-007` — joint loss bounds force zero distance; status `proved`.
- `BG-THM-008` — certified separation excludes joint adequacy; status `proved`.

`RankTwoLoss.lean` owns these declarations:

- `BG-DEF-005` — Euclidean rank-two parameter plane; status `implemented`.
- `BG-DEF-006` — reduced spectral squared loss; status `implemented`.
- `BG-DEF-007` — reduced aligned-operator squared loss; status `implemented`.
- `BG-THM-009` — irreducible operator-loss lower bound; status `proved`.
- `BG-THM-010` — below-floor budget implies operator-set emptiness; status `proved`.
- `BG-DEF-008` — normalized scalar correlation; status `implemented`.
- `BG-THM-011` — normalized-correlation magnitude bound; status `proved`.
- `BG-THM-012` — irreducible-floor nonnegativity; status `proved`.
- `BG-THM-013` — aligned-operator squared-loss nonnegativity; status `proved`.

`docs/theorem-manifest.md` is the authoritative ID-to-declaration table.

The extended codomain keeps the empty-set boundary nonfinite rather than silently reporting a real zero. The threshold-defined sublevel-set layer and reduced scalar rank-two loss formulas are implemented. Their derivation from the paper's matrix residuals, the matrix-level correlation bound `|b| ≤ κ`, and the ellipse geometry remain open.

Compactness, positivity, parameter-domain, rank, scalar-field, scientific-error-budget, separation-resolution, and admissible-alignment assumptions must remain explicit. See `docs/theorem-manifest.md` for authoritative declaration status and `proofs/BandGauge/Geometry/` for human-readable proof dossiers.
