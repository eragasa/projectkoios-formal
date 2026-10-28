# BandGauge alignment

This directory owns exact finite-rank frame and retained-coordinate alignment algebra.

- `FiniteFrame.lean`: rectangular complex frames, ambient projectors, compression and reconstruction, and right-unitary retained-coordinate changes.

## Boundaries

- Frame orthonormality is an exact hypothesis; no runtime matrix is certified orthonormal.
- Right-unitary changes preserve the ambient projector and reconstructed compressed operator.
- The current API concerns equal retained rank and square retained-coordinate unitaries.
- It does not select a point-dependent gauge family, establish Fourier locality, bind eigensolver output, or validate a physical model.
- `docs/theorem-manifest.md` is the declaration ledger.
