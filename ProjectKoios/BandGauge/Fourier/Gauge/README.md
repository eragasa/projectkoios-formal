<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-->

# Fourier gauge actions

This family owns exact gauge-action results at the Fourier boundary.

- `UnitaryEquivariance.lean`: Frobenius invariance and Fourier commutation for one fixed finite-rank unitary.
- `PointwiseGauge.lean`: character-phase mode shifts, scalar-conjugation triviality, pointwise conjugation, coefficient separation, and pointwise Frobenius invariance.
- `PointwiseConvolution.lean`: conjugate-transpose mode reversal, the exact pointwise-unitary triple-convolution law, its finite-support inclusion, and the complete-shell radius bound `R_A + 2 R_U` under explicit inversion-invariance and subadditivity hypotheses.
- `CyclicQuotientRadius.lean`: specialization of that support bound to the quotient-seminorm radius on complex characters of a finite cyclic momentum group.
- `TruncationCounterexample.lean`: a rank-two two-point witness where a pointwise swap gauge creates a nonzero odd mode and does not commute with zero-mode truncation.
- `ProductLocalitySeparation.lean`: the finite-dimensional binary-product lift, with exact ordered-band equality, truncation noncommutation, positive omitted Frobenius power, and 2-D/3-D corollaries.
- `FiniteRankLocalitySeparation.lean`: arbitrary-finite-dimensional two-point witnesses for every operator changed by a supplied unitary, with pointwise equality of complex spectra, zero-mode truncation noncommutation, and positive omitted Frobenius power; specializations include coordinate projectors and the exact diagonal analytic parent on every `Fin N`, `N ≥ 2`, with `parentScale ∈ [0, 1]` and a swap of its first two strictly ordered bands.
- `CharacterLocalitySeparation.lean`: an exact rational two-coordinate character mixer, extended by the identity to arbitrary retained dimension, which places the coefficient `(12/25) * (right - left)` at a selected character on any finite abelian momentum mesh; a retained-zero/omitted-character support therefore has zero parent omitted power, strictly positive gauged omitted power, and pointwise-equal complex spectra.
- `LatticeCharacterLocalitySeparation.lean`: source-neutral specialization of the character-gauge theorem to `FinitePeriodicLatticeMesh`, including an explicit unit-frequency character on every selected coordinate of period at least two, its exact generated coefficient, canonical zero-mode separation, and complete caller-supplied radius-shell cutoffs.
- `FixedSubspaceRepresentationBridge.lean`: conditional ambient-to-retained representation bridge: the character right action preserves frame orthonormality and the ambient projector, transforms compressed operators by exact right-gauge conjugation, preserves pointwise complex spectra, and transfers both the exact selected coefficient and the canonical zero-versus-positive omitted-power separation to compression fields exactly bound to the finite-rank parent.

Fixed-unitary equivariance alone does not cover momentum-dependent gauges; the triple-convolution
law describes their exact finite coefficient mixing. Its support results are inclusions relative to
declared finite supports. The generic radius corollary uses a supplied subadditive nonnegative radius
over the complete finite character inventory. `CyclicQuotientRadius.lean` discharges those radius
laws for a one-dimensional finite cyclic quotient using the quotient seminorm.
`Support/LatticeRadius.lean` separately supplies radii for the square, triangular, simple-cubic, and
normalized FCC infinite integer-coordinate indices; product-quotient bindings to those geometries
remain separate. The finite-rank separation witnesses concern complex spectra as sets; they do not
claim ordered eigenvalue equality or multiplicity bookkeeping. The analytic-parent specialization
fixes one exact structure-factor value and does not assert a runtime momentum field. The
character-gauge lattice specialization either accepts an exact supplied character or constructs a
unit-frequency character from a selected exact product-mesh coordinate; it still takes radius and
cutoff as exact caller-supplied data. The fixed-subspace bridge additionally requires an exact binding
between an ambient compression field and the constant finite-rank parent. These results do not bind
those exact inputs to FFT ordering, a reciprocal basis, a runtime gauge array, DFT/Wannier90
execution, or a serialized `ksdft2effmass` artifact. None of these layers establishes physical
hopping range, continuum decay, runtime gauge recovery, convergence, or scientific adequacy.
