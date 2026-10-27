# BandGauge Hilbert geometry

This directory owns reusable Hilbert and finite weighted-Frobenius geometry.

- `AdmissibleBalls.lean`: exact intersection and distance of two closed residual balls.
- `WeightedFrobenius.lean`: rank-two matrix fields, weighted power with coefficient `αᵢ / (2 Eref²)`, correlation, unitary invariance, and polarization.
- `OperatorLossBridge.lean`: the residual `Eref s I + λD - B`, its exact expansion, and the reduced aligned-operator loss.
- `SpectralLossBridge.lean`: the residual `Eref s + (λ - 1)d`, its exact expansion, and the reduced spectral loss.

## Boundaries

The finite weighted model remains explicit.

- The matrix layer uses the papers' Frobenius entry sum, not the bounded-operator norm.
- Source weights and reference energy remain explicit hypotheses; strict positivity and normalization are not inferred by the generic inequalities.
- Concrete source data, continuum Bloch-section spaces, and runtime evidence remain external.
- `docs/theorem-manifest.md` is the declaration ledger.
