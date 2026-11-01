# BandGauge projection

This directory owns retained compression, invariant-subspace reconstruction, leakage bounds,
and spectral-projection support results. Projection remains distinct from gauge change,
disentanglement, Fourier conversion, and truncation.

`LaurentObstruction.lean` implements the algebraic core of the Ragasa2026b two-band
counterexample:

- `BG-PROJECTION-DEF-001/002` encode the Laurent radicand and nearest-neighbor parent;
- `BG-PROJECTION-THM-001` proves that the parent square is the scalar radicand; and
- `BG-PROJECTION-THM-002` proves, under the source assumption `Δt ≠ 0`, that the
  radicand has no complex Laurent-polynomial square root.

`SpectralProjectionRange.lean` completes the source proposition under a frozen convention:
finite Fourier support means representability by a complex Laurent polynomial evaluated at
`z = exp(i k)`. It provides:

- `BG-PROJECTION-THM-003`, injectivity of Laurent evaluation on the unit circle;
- `BG-PROJECTION-THM-004`, non-finite Fourier support of the positive dispersion;
- `BG-PROJECTION-THM-005/006`, the lower-band projector specification and sandwich
  identity;
- `BG-PROJECTION-THM-007`, non-finite matrix Fourier support of the embedded lower-band
  operator; and
- `BG-PROJECTION-THM-008`, the exact result that the finite-support parent has a
  lower-band projector sandwich without finite matrix Fourier support.

The result is an exact analytic counterexample. It does not claim that every spectral
projection destroys finite support, quantify hopping decay, instantiate a material model,
or consume numerical or runtime evidence.

The separate ambient-parent-to-retained-reference program is described in
[`../../../docs/BandGauge/higher-rank-composite-band-formalization-plan.md`](../../../docs/BandGauge/higher-rank-composite-band-formalization-plan.md).
