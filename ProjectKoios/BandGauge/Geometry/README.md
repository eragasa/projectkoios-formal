# BandGauge geometry

This directory owns admissible-set and rank-two loss geometry.

- `AdmissibleSets.lean`: extended and real set distance, common witnesses, certified separation, compact attainment, zero-distance/intersection equivalence, positive-distance/disjointness equivalence, and threshold sublevel sets.
- `RankTwoLoss.lean`: reduced spectral and aligned-operator losses, ellipse criteria, exact distances, and candidate-rectangle transfer.

## Boundaries

The geometry retains all source assumptions.

- Empty-set behavior remains explicit through the extended-distance API.
- Rank, scalar field, compactness, positivity, parameter domain, alignment family, error budgets, and separation resolution remain explicit assumptions.
- Paper-field identification and numerical certificates remain external.
- `docs/theorem-manifest.md` owns declaration IDs and status; `proofs/BandGauge/Geometry/` contains dossiers.
