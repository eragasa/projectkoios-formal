# BandGauge projection

This directory owns retained compression, invariant-subspace reconstruction, leakage quantities,
approximate frame/projector mismatch bounds, and spectral-projection support results. Projection
remains distinct from gauge change, disentanglement, Fourier conversion, and truncation.

`ApproximateCompression.lean` provides:

- `BG-PROJECTION-THM-009/010`, matrix-`L2Operator` compression mismatch bounds for two exact
  orthonormal frames and for the frozen right-unitary convention;
- `BG-PROJECTION-DEF-012` and `BG-PROJECTION-THM-011/013`, an exact compressed-action
  reproduction residual, its algebraic zero criterion, and its invariant-range meaning under exact
  orthonormality; and
- `BG-PROJECTION-THM-012`, a separate ambient projector-sandwich mismatch bound when retained
  projectors differ.

These results use exact finite matrices and exact orthonormality. They are operator-norm results,
not the still-open mixed operator/Frobenius estimate, and do not authenticate runtime frames,
projectors, arrays, or eigensolver output.

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
