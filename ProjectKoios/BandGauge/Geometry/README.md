# BandGauge geometry

This folder owns admissible-set geometry, witness/separation results, alignment losses, and reviewed rank-two finite-dimensional consequences.

## Implemented module

`AdmissibleSets.lean` owns these declarations:

- `BG-DEF-001` — extended nonnegative admissible-set distance; status `implemented`.
- `BG-THM-001` — feasible-pair upper bound; status `proved`.
- `BG-THM-002` — common-witness zero distance; status `proved`.
- `BG-THM-003` — certified positive separation; status `proved`.
- `BG-THM-004` — compact attainment and positive distance; status `proved`.

`docs/theorem-manifest.md` is the authoritative ID-to-declaration table.

The extended codomain keeps the empty-set boundary nonfinite rather than silently reporting a real zero. No real-valued nonempty specialization, spectral/operator sublevel-set instantiation, or rank-two loss geometry is implemented yet.

Compactness, positivity, parameter-domain, rank, scalar-field, scientific-error-budget, separation-resolution, and admissible-alignment assumptions must remain explicit. See `docs/theorem-manifest.md` for authoritative declaration status and `proofs/BandGauge/Geometry/` for human-readable proof dossiers.
