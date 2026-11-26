# Conjugate-linear coordinate-algebra crosswalk

## Status

This is a **provisional exact-mathematics crosswalk**, not an immutable publication-source or
runtime binding. The inspected KSD Chapter 9 file was untracked in a dirty owner worktree. The
worktree commit and tree identify only the surrounding checkout; the cited file is bound solely by
its recorded path and SHA-256. Exact source identity and dirty-state limitations are recorded in
[`AUD-SRC-029`](../../audit/source-publications.md#aud-src-029).

## Source locators

The inspected Chapter 9 bytes state:

- lines 208–226: a conjugate-linear coordinate action `x ↦ M conjugate(x)` and the algebraic metric
  equation `M† G_t M = conjugate(G_s)`;
- lines 231–236: the composition rule `(M K)(N K) = M conjugate(N)` with conjugation retained in the
  compatible middle coordinate space;
- lemma `lem:symmetry-antiunitary-basis-change`, lines 239–251, and
  `eq:symmetry-antiunitary-basis-change`, lines 243–246: the basis-change formula
  `M' = A_t⁻¹ M conjugate(A_s)`;
- `eq:symmetry-antiunitary-metric-basis-change`, lines 257–267: preservation of the metric equation
  under `G'_a = A_a† G_a A_a`; and
- lines 270–279: a source-side `2 × 2` diagnostic explaining why a norm check alone does not detect
  omission of source-coordinate conjugation.

## Formula correspondence

| Chapter 9 formula or distinction | Formal representation | Exact result |
|---|---|---|
| componentwise `Kx = conjugate(x)` | `conjugateVector` | `BG-ALIGNMENT-LEM-012`: conjugation is involutive |
| entrywise `conjugate(M)` | `entrywiseConjugate` | `BG-ALIGNMENT-LEM-013`, `015`–`017`: action, conjugate-transpose, product, and metric-congruence identities |
| conjugate-linear coordinate action `x ↦ M conjugate(x)` | `conjugateLinearCoordinateAction M` | source and target coordinate types are explicit and may differ |
| `M' = A_t⁻¹ M conjugate(A_s)` | `conjugateLinearBasisChange sourceBasis targetBasis M` | `BG-ALIGNMENT-LEM-014`: exact transformed coordinate action |
| `G' = A† G A` | `metricBasisChange basis metric` | exact congruence definition |
| `M† G_t M = conjugate(G_s)` | `IsConjugateLinearMetricCompatible sourceMetric targetMetric M` | purely algebraic predicate, without Hermitian or positivity assumptions |
| preservation of the metric equation | transformed metrics and transformed matrix above | `BG-ALIGNMENT-LEM-018`: exact cancellation for independent invertible source and target basis changes |
| `(M K)(N K) = M conjugate(N)` | composition of two `conjugateLinearCoordinateAction` values | `BG-ALIGNMENT-LEM-019`: exact linear product with distinct source, middle, and target types |
| bijectivity is additional | `IsBijectiveConjugateLinearCoordinateAction M` | separate predicate; it is not inferred from metric compatibility |

The generic declarations subsume the source's finite-dimensional algebra without encoding the
source's optional `2 × 2` diagnostic as a separate named theorem.

## Explicit nonclaims

These declarations do not establish:

- that either metric matrix is Hermitian or positive definite;
- that metric compatibility alone implies injectivity, surjectivity, bijectivity, norm
  preservation, isometry, or antiunitarity;
- that a source antiunitary or symmetry action exists physically or acts on a declared sector;
- operator covariance, representation closure, Wigner's theorem, or a general symmetry framework;
- correctness of floating-point conjugation, inversion, matrix multiplication, residual tests, or
  runtime basis metadata;
- identity between external arrays and the exact matrices supplied to Lean;
- scientific applicability, model validation, novelty, publication readiness, or retained
  evidence; or
- immutable owner-source provenance for the untracked Chapter 9 file.

A future immutable owner revision must commit the cited source bytes and refresh this crosswalk
before it can support a publication-source fidelity claim. Runtime use requires a separate
authenticated binding and checked-certificate boundary.
