# BandGauge Bloch sewing

This directory owns pointwise finite-fiber sewing contracts and rank-two sampled-field algebra.

- `Sewing.lean`: sewing data, sewn sections and operators, compatible alignments, and covariance.
- `PeriodicRankTwo.lean`: retained rank-two fibers, trace centering, Hermiticity, unitary conjugation, weighted power, and correlation bounds.

## Boundaries

The transport convention maps coordinates at `k` to coordinates at `g • k`.

- The layer is pointwise; it defines no continuity, measurability, Sobolev, or `L²` section space.
- It does not derive Bloch--Floquet decomposition from a periodic potential.
- Pointwise sewing is not inferred from an `L²` equivalence class.
- `docs/theorem-manifest.md` is the declaration ledger.
