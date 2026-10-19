# BandGauge Hilbert geometry

This folder owns reusable Hilbert-space geometry intended for later instantiation with
the publications' finite weighted Frobenius residual spaces.

`AdmissibleBalls.lean` owns:

- `BG-HILBERT-DEF-001` — closed residual-budget ball; status `implemented`.
- `BG-HILBERT-DEF-002` — nonnegative center-gap distance formula; status `implemented`.
- `BG-HILBERT-THM-001` — exact two-ball intersection criterion; status `proved`.
- `BG-HILBERT-THM-002` — universal pairwise-distance lower bound; status `proved`.
- `BG-HILBERT-THM-003` — explicit center-line attainment; status `proved`.
- `BG-HILBERT-THM-004` — exact real admissible-set distance; status `proved`.

`WeightedFrobenius.lean` owns:

- `BG-HILBERT-DEF-003` — finite retained-rank-two complex matrix field; status `implemented`.
- `BG-HILBERT-DEF-004` — weighted squared Frobenius residual with the source coefficient
  `αᵢ / (2 Eref²)`; status `implemented`.
- `BG-HILBERT-DEF-005` — weighted real Frobenius correlation; status `implemented`.
- `BG-HILBERT-THM-005` — nonnegativity; status `proved`.
- `BG-HILBERT-THM-006` — weighted Frobenius Cauchy–Schwarz; status `proved`.
- `BG-HILBERT-THM-007` — invariance under pointwise unitary conjugation; status `proved`.
- `BG-HILBERT-THM-008` — common power `κ` implies correlation magnitude at most `κ`;
  status `proved`.
- `BG-HILBERT-DEF-006` — constant retained-rank-two identity field; status `implemented`.
- `BG-HILBERT-THM-009` — real polarization of weighted Frobenius power; status `proved`.
- `BG-HILBERT-THM-010` — traceless fields are Frobenius-orthogonal to identity; status
  `proved`.

`OperatorLossBridge.lean` owns:

- `BG-HILBERT-DEF-007` — matrix residual `Eref s I + λD - B`; status `implemented`.
- `BG-HILBERT-DEF-008` — its source-normalized weighted squared loss; status `implemented`.
- `BG-HILBERT-THM-011` — exact shift/power/correlation expansion; status `proved`.
- `BG-HILBERT-THM-012` — common-power specialization to
  `s² + κλ² - 2bλ + κ`; status `proved`.
- `BG-HILBERT-THM-013` — equality with the existing reduced scalar aligned-operator
  loss at normalized correlation `b/κ`; status `proved`.

`SpectralLossBridge.lean` owns:

- `BG-HILBERT-DEF-009` — finite retained-rank-two real spectral field; status `implemented`.
- `BG-HILBERT-DEF-010` — source-normalized weighted spectral power; status `implemented`.
- `BG-HILBERT-DEF-011` — residual `Eref s + (λ - 1)d`; status `implemented`.
- `BG-HILBERT-DEF-012` — its source-normalized squared loss; status `implemented`.
- `BG-HILBERT-THM-014` — centered residual expansion; status `proved`.
- `BG-HILBERT-THM-015` — equality with the existing reduced scalar spectral loss;
  status `proved`.

The weighted layer uses the papers' Frobenius entry sum, not the bounded-operator norm.
The source's strictly positive normalized weights and positive reference energy imply the
weaker sign premises used by the proved inequalities. The operator scalar-loss expansion
is now checked for abstract finite fields satisfying the declared trace, power, and
correlation hypotheses. The operator and spectral scalar-loss expansions are checked for abstract finite fields
satisfying the declared centering, trace, power, and correlation hypotheses.
Identification with scientific source data and a continuum Bloch-section Hilbert space
remain open.

`docs/theorem-manifest.md` is the authoritative declaration ledger.
