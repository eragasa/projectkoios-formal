# BandGauge alignment

This directory owns exact finite-rank frame and retained-coordinate alignment algebra.

- `FiniteFrame.lean`: rectangular complex frames, ambient projectors, compression and reconstruction, and right-unitary retained-coordinate changes.
- `Family.lean`: singleton, identity, global-unitary, and complete pointwise-unitary alignment families with exact feasibility semantics.
- `FamilySeparation.lean`: explicit strict-inclusion witnesses and counterexamples to reverse feasibility transfer.
- `UnitaryProcrustes.lean`: exact complex-unitary right Procrustes objectives, polar-witness global minimality, and positive-definite uniqueness.
- `FiniteMeshProcrustes.lean`: summed pointwise Procrustes objectives, local-witness global minimality and conditional uniqueness, constant/identity comparisons, exact known-inverse controls, and the matrix-unitary bridge into the alignment-family hierarchy.
- `GaugeIdentity.lean`: separate gauge-family, represented-dimension, action-side, and inner-product-convention identities; identity/composition laws for the exact metric-isometry equation; and named right-action conjugation, composition, conjugate-transpose, and Hermiticity laws.
- `ExactGaugeConstruction.lean`: dimension-independent exact construction `F'=F₀G`, `H'=GᴴDG`, including orthonormality and complex-spectrum preservation and known-inverse frame/operator recovery by `Gᴴ`.

## Boundaries

- Frame orthonormality is an exact hypothesis; no runtime matrix is certified orthonormal.
- The represented dimension is derived from the retained index type; it is not unrelated string or integer metadata.
- The current supported group family is unitary, but group family, action side, inner-product convention, sample domain, and global-versus-pointwise restriction remain separate concepts.
- The Euclidean inner-product convention labels the retained-coordinate metric; it does not assert concrete-frame orthonormality or validity.
- Right-unitary changes preserve the ambient projector and reconstructed compressed operator.
- Exact `F'=F₀G`, `H'=GᴴDG` construction preserves frame orthonormality and the complex spectrum and is exactly recoverable with `Gᴴ`; this set-spectrum equality does not authenticate ordered runtime eigenvalues.
- In the current column-frame convention, retained-space gauge matrices act from the right. The `left` vocabulary constructor does not define an untyped left action.
- `IsMetricUnitary metric gauge` records only `gaugeᴴ * metric * gauge = metric`; the identity and multiplication theorems prove algebraic closure for a fixed metric, while positive definiteness, metric adjoints, metric-aware objectives, and runtime verification remain separate.
- `rightGaugeConjugate` is the Euclidean compressed-form congruence `Uᴴ H U`; it composes in right-action order and preserves Hermiticity without asserting frame orthonormality, invertibility, or a nonorthonormal coordinate-endomorphism law.
- The current API concerns equal retained rank and unitary fiber equivalences.
- `U(1)` remains a valid group identity, while scalar represented-operator conjugation is exactly trivial by `BG-FOURIER-THM-049`; group membership does not require duplicate numerical channels.
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
