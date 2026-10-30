# BandGauge alignment

This directory owns exact finite-rank frame and retained-coordinate alignment algebra.

- `FiniteFrame.lean`: rectangular complex frames, ambient projectors, compression and reconstruction, and right-unitary retained-coordinate changes.
- `Family.lean`: singleton, identity, global-unitary, and complete pointwise-unitary alignment families with exact feasibility semantics.
- `FamilySeparation.lean`: explicit strict-inclusion witnesses and counterexamples to reverse feasibility transfer.
- `UnitaryProcrustes.lean`: exact complex-unitary right Procrustes objectives, polar-witness global minimality, and positive-definite uniqueness.
- `FiniteMeshProcrustes.lean`: summed pointwise Procrustes objectives, local-witness global minimality and conditional uniqueness, constant/identity comparisons, exact known-inverse controls, and the matrix-unitary bridge into the alignment-family hierarchy.

## Boundaries

- Frame orthonormality is an exact hypothesis; no runtime matrix is certified orthonormal.
- Right-unitary changes preserve the ambient projector and reconstructed compressed operator.
- The current API concerns equal retained rank and unitary fiber equivalences.
- Feasibility transfers from a smaller family to a larger family only through an explicit inclusion.
- Supplied nonidentity and two-point witnesses show that reverse feasibility transfer fails in general.
- The Procrustes objective is `‖candidate * gauge - reference‖_F²`, with cross matrix `candidateᴴ * reference`.
- An exact polar witness proves global minimality; uniqueness requires a positive-definite factor and is not claimed for rank-deficient factors.
- On a finite mesh, one supplied witness per point minimizes the summed objective; summed uniqueness requires every local positive factor to be positive definite.
- The known-inverse route is an explicit exact zero-objective control, not a universal ground truth or an authenticated practical optimizer.
- Matrix unitarity is converted to a linear isometry by proving the adjoint identities; no unavailable direct coercion is assumed.
- It does not construct or authenticate a runtime SVD, numerical rank, tolerance, null-space completion, optimizer output, or certificate.
- It does not select an alignment, establish Fourier locality, bind an optimizer or eigensolver, or validate a physical model.
- `docs/theorem-manifest.md` is the declaration ledger.
