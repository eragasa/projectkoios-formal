# BandGauge Bloch sewing

This directory owns pointwise finite-fiber sewing contracts and rank-two sampled-field algebra.

- `Sewing.lean`: sewing data, sewn sections and operators, compatible alignments, and covariance.
- `AlignedDifference.lean`: operator-field subtraction, aligned reference-minus-candidate fields, sewing closure, and exact zero/recovery identities.
- `PeriodicRankTwo.lean`: retained rank-two fibers, trace centering, Hermiticity, unitary conjugation, weighted power, and correlation bounds.

## Boundaries

The transport convention maps coordinates at `k` to coordinates at `g • k`.

- The layer is pointwise; it defines no continuity, measurability, Sobolev, or `L²` section space.
- It does not derive Bloch--Floquet decomposition from a periodic potential.
- Aligned differences do not select an alignment or establish self-adjointness, spectral adequacy, or numerical validity.
- Pointwise sewing is not inferred from an `L²` equivalence class.
- `docs/theorem-manifest.md` is the declaration ledger.
