# BandGauge Bloch sewing

This directory owns pointwise finite-fiber sewing contracts and rank-two sampled-field algebra.

- `Sewing.lean`: sewing data, sewn sections and operators, compatible alignments, and covariance.
- `AlignedDifference.lean`: operator-field subtraction, aligned reference-minus-candidate fields, sewing closure, exact zero/recovery identities, and conditional pointwise self-adjointness closure.
- `AlignedDifferenceBounds.lean`: exact unitary-pullback action/operator-norm preservation, aligned-difference norm bounds, subtraction identities, and same-alignment Lipschitz stability.
- `PeriodicRankTwo.lean`: retained rank-two fibers, trace centering, Hermiticity, unitary conjugation, weighted power, and correlation bounds.

## Boundaries

The transport convention maps coordinates at `k` to coordinates at `g • k`.

- The layer is pointwise; it defines no continuity, measurability, Sobolev, or `L²` section space.
- It does not derive Bloch--Floquet decomposition from a periodic potential.
- Aligned-difference self-adjointness requires complete fiber spaces and explicit pointwise self-adjointness hypotheses; it does not select an alignment, authenticate runtime operators, or establish spectral adequacy or numerical validity.
- The norm bounds use exact continuous-linear-map norms and one common supplied alignment. They do not compare different alignments, infer runtime norm bounds, or imply eigenvalue, continuum, or scientific adequacy claims.
- Pointwise sewing is not inferred from an `L²` equivalence class.
- `docs/theorem-manifest.md` is the declaration ledger.
