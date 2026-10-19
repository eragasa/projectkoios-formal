<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# BandGauge Fourier analysis

This folder owns finite/discrete Fourier algebra, Wannier-gauge hopping support, exact truncation-tail identities, and locality results. Continuum Fourier analysis remains deferred and must be reviewed separately.

Implemented first slice:

- `FiniteReconstruction.lean` defines coefficient fields, exact support truncation, finite reconstruction with an explicit caller-supplied phase kernel, omitted weight, and the retained/omitted decomposition;
- `BG-FOURIER-THM-005` proves the exact full-minus-truncated finite tail identity;
- `BG-FOURIER-THM-006/007` prove that complex-linear maps commute with finite reconstruction and coefficient truncation;
- `BG-FOURIER-THM-008` proves omitted nonnegative weight is antitone as support grows;
- `FiniteAbelianTransform.lean` fixes a separate explicit finite-abelian convention: conjugated-character coefficients with forward normalization `1 / |G|` and unconjugated-character reconstruction;
- `BG-FOURIER-THM-009/010` prove the exact character kernel and finite Fourier inversion for fields valued in any complex module;
- `FiniteParseval.lean` proves the reverse coefficient-reconstruction identity, the inner-product and power Parseval identities, retained/omitted coefficient-power decomposition, and the exact equality between reconstructed truncation-residual power and `|G|` times omitted coefficient power;
- `BG-FOURIER-THM-021` is the convention-frozen finite residual-tail identity for arbitrary complex Hilbert-space-valued fields;
- `HermitianPairing.lean` proves negative-mode/conjugate-transpose pairing for Hermitian matrix fields, preservation under negation-closed support truncation, and Hermiticity of full and truncated reconstructions;
- `MatrixFrobenius.lean` proves entrywise matrix Parseval and the exact equality between reconstructed matrix Frobenius residual power and `|G|` times omitted coefficient Frobenius power;
- `RankTwoWeightedBridge.lean` factors the exact rank-two coefficient `weight/(2Eref²)` and proves that uniform finite averaging cancels `|G|`, leaving exactly `1/(2Eref²)` times omitted matrix Frobenius power.

The first module keeps its phase kernel explicit and therefore selects no Fourier convention. The finite-abelian specialization selects its sign and normalization in its declarations, but does not identify `G` with a publication mesh. The weighted bridge applies only to a constant momentum weight, with uniform averaging as a specialization; it does not replace a nonuniform quadrature. Physical shell/range semantics, external mesh and evidence binding, and continuum convergence remain open.

## Library-search record

The required first signature was finite synthesis in an arbitrary complex module, exact restriction to a `Finset` support, and an exact complement-tail identity. Mathlib's `Finset.sum_add_sum_compl` supplies the finite partition, while linear-map sum and scalar-commutation lemmas supply the functorial results. `Mathlib.Analysis.Fourier.FiniteAbelian.Orthogonality` and `PontryaginDuality` were inspected; their complex-character orthogonality, character-cardinality, and basis APIs support the explicit finite-abelian inversion specialization. No missing library lemma was required for this slice. Physlib revision `adc97f054083132000567cb09ff8f7b1f073400d` remains unadopted and is not needed here. The implementation therefore stays in `BandGauge/Fourier` with narrow Mathlib complex-module and finite-sum imports.

Every future specialization must declare its sign, normalization, index group, domain, support rule, conjugate closure, and finite-versus-continuum setting. Wannier90 execution remains external, and a sampled transform is not a continuum certificate.
