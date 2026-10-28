# BandGauge alignment

This directory owns exact finite-rank frame and retained-coordinate alignment algebra.

- `FiniteFrame.lean`: rectangular complex frames, ambient projectors, compression and reconstruction, and right-unitary retained-coordinate changes.
- `Family.lean`: singleton, identity, global-unitary, and complete pointwise-unitary alignment families with exact feasibility semantics.
- `FamilySeparation.lean`: explicit strict-inclusion witnesses and counterexamples to reverse feasibility transfer.

## Boundaries

- Frame orthonormality is an exact hypothesis; no runtime matrix is certified orthonormal.
- Right-unitary changes preserve the ambient projector and reconstructed compressed operator.
- The current API concerns equal retained rank and unitary fiber equivalences.
- Feasibility transfers from a smaller family to a larger family only through an explicit inclusion.
- Supplied nonidentity and two-point witnesses show that reverse feasibility transfer fails in general.
- It does not select an alignment, establish Fourier locality, bind an optimizer or eigensolver, or validate a physical model.
- `docs/theorem-manifest.md` is the declaration ledger.
