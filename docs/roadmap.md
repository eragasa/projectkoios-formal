# Formalization roadmap

This roadmap orders future work by mathematical dependency. It is not an authorization to implement a theorem, adopt a dependency, execute a scientific calculation, or claim a paper complete.

## R0 — documentation and layout

**Completed startup scope.** Establish authority boundaries, conventions, provenance, theorem planning, trusted-base policy, the horizontal ecosystem relationship, the bounded agent workflow, and documentation-only module folders. The no-theorem condition below describes the R0 checkpoint; later R1 work has now added two foundational declarations.

Exit evidence:

- documentation links resolve;
- planned entries remain distinct from Lean declarations;
- pin, build, and admission/axiom audits pass; and
- no scientific theorem count changes.

## Optional tooling track — read-only and non-gating

Candidate Lean skills, language-server bridges, MCP servers, and proof-search wrappers may be evaluated from authoritative sources at immutable revisions. The deferred candidate list currently records `leanprover/skills` and `cameronfreer/lean4-skills` for later consideration without adoption. An evaluation records license, toolchain compatibility, commands, data access, mutation behavior, and limitations before adoption.

Agent tooling is not part of the logical trusted base, does not replace the repository checks, and must not block statement selection or foundational proof work. Repository-owned configuration or dependency adoption requires separate review.

## R1 — statement selection and finite foundations

Candidate work:

- review exact definitions of finite support, admissible sets, witnesses, and set distance;
- inventory existing Mathlib/Physlib APIs without adopting Physlib implicitly;
- select one exact source theorem and record its assumption delta;
- identify applicable References-owned canonical identities and exact source locators without creating a duplicate bibliography; and
- record namespace and declaration names before encoding.

- `BG-PLAN-001`: declaration IDs and statuses are listed in `theorem-manifest.md`. Concrete paper loss formulas and certificate data remain open.
- `BG-BLOCH-PLAN-001`: pointwise unitary sewing, sewn sections/operators, alignment pullback, an abstract periodic rank-two finite-sample interface, trace centering, and unitary common-power/correlation bridges and Hermiticity preservation are implemented. Construction from a periodic potential, quotient-torus, continuity/measurability, Hilbert-section, and integration contracts remain open.
- `BG-HILBERT-PLAN-001`: exact two-ball geometry, finite rank-two weighted Frobenius algebra, operator and spectral residual expansions, and equalities with both reduced scalar losses are implemented. The Bloch layer supplies abstract sampled-parent infrastructure, and the Paper A module conditionally instantiates the exact operator fields, a canonical exact finite Hermitian spectral diagonalization, and a canonically extracted exact Pauli-coordinate correlation harmonic with continuous maximum. Construction from a periodic potential and binding to concrete publication data remain open.

## R2 — finite witness and rank-two algebra

Candidate theorem families:

1. witness and certified-separation bookkeeping for explicitly stated metric-space assumptions;
2. rank-two exact loss geometry under the source's real-rotation and positivity assumptions;
3. finite/discrete Fourier residual–locality identities; and
4. an explicit spectral-projection support-loss example.

`BG-PLAN-002` now includes reduced scalar squared and real losses, normalized correlation, irreducible-floor and nonnegativity bounds, below-floor emptiness, square-root recovery, threshold equivalence, the operator radius, explicit ellipse conditions, the exact full-plane intersection criterion and Euclidean distance, explicit containment-based transfer to a closed candidate rectangle, the generic finite weighted Frobenius correlation inequality `|b| ≤ κ`, operator and spectral residual-to-scalar-loss bridges, abstract periodic sampled-parent infrastructure, conditional exact Paper A operator and canonical spectral-field bridges, and canonical exact Pauli extraction, continuous correlation-harmonic optimization with a canonical half-open maximizing angle, the reduced matrix-loss bridge centered at `μmax`, canonical full-plane/candidate-rectangle admissible-set intersection and distance specializations, exact rational-center and rational-enclosure certificate checkers for witness/containment/separation, an exact enclosure of `1 / √2`, and conditional bridges from accepted certificates to the canonical finite fields. Construction from a periodic potential, concrete publication-data and runtime-parser binding, proof that the field-derived `μmax` matches the source algebraic value, and concrete certificate verification remain open.

Each declaration requires a source crosswalk and named axiom report.

## R2.5 — finite spectral bridge and exhaustive fidelity decisions

The proposed architecture and its authority boundaries are recorded in
[`BandGauge/higher-rank-composite-band-formalization-plan.md`](BandGauge/higher-rank-composite-band-formalization-plan.md).
It follows Paper 3's committed synthetic ambient-parent, retained-reference, internal-gauge,
alignment, finite-Fourier, and support-truncation protocol. A later low-eigenpair or Wannier90
extension is kept separate because the current D1 protocol supplies analytic frames and explicitly
does not execute Wannier90.

Dependency-ordered candidate work:

1. sewing-compatible aligned-difference closure, Hermiticity, and frame-consistent loss semantics;
2. exact ambient-parent compression, retained-projector, and internal-gauge equivalence;
3. exact P0 inverse-gauge recovery and the reviewed full-rank pointwise alignment consequence;
4. finite Fourier inversion, Parseval, full-minus-truncated hopping-tail, error-decomposition,
   and Hermitian perturbation identities;
5. per-alignment finite support/operator/spectral objective tables and Pareto soundness and
   completeness under weak improvement with one strict improvement; and
6. outward-rounded interval objective tables with explicit rank, depth, alignment, support, and
   momentum-mesh coverage.

The semantic finite-decision foundation is now implemented as `BG-DECISION-DEF-001`
through `BG-DECISION-DEF-009` and `BG-DECISION-THM-001` through
`BG-DECISION-THM-013`. It proves weak-all/strict-any dominance properties, finite
existence of efficient weak improvers, Pareto sufficiency for coordinatewise threshold
feasibility, feasibility monotonicity, minimum-cost attainment, minimum-cost
antitonicity under relaxed thresholds, and an exhaustive logical two-channel outcome
classification. Exact Boolean dominance, threshold, and nondominated-mask checks and
their soundness/completeness bridges are also implemented as `BG-CERT-DEF-014` through
`BG-CERT-DEF-016` and `BG-CERT-THM-010` through `BG-CERT-THM-012`. Concrete Paper B/C
objective tables, interval comparison semantics, external inventory/mesh coverage, parser
binding, and retained evidence remain open.

The finite Fourier foundation is implemented as `BG-FOURIER-DEF-001` through
`BG-FOURIER-DEF-015` and `BG-FOURIER-THM-001` through `BG-FOURIER-THM-032`. The
convention-neutral layer proves exact support restriction, retained/omitted decomposition,
the full-minus-truncated finite tail identity, complex-linear-map commutation, and
antitonicity of omitted nonnegative weight under support enlargement. A separate explicit
finite-abelian specialization uses conjugated-character coefficients normalized by
`1 / |G|`, unconjugated-character reconstruction, and proves both transform directions,
inner-product and power Parseval, coefficient-power decomposition, and the exact equality
between full-minus-truncated reconstructed Hilbert power and `|G|` times omitted coefficient
power. Negative-mode/conjugate-transpose pairing, its preservation under negation-closed
truncation, and Hermiticity of the resulting reconstruction are also proved. The
unweighted entrywise matrix Frobenius Parseval and residual-tail identities are now exact.
For constant weights, the exact rank-two coefficient `weight/(2Eref²)` is bridged to the
matrix identity; uniform averaging cancels the transform cardinality and leaves
`1/(2Eref²)` exactly. `PKF-BG-EVIDENCE-CONTRACT/1` now freezes the publication-evidence
policy: concrete evaluation weights must be determined a priori by normalized counting,
geometric-cell, moment-exact, or certified optimized quadrature rules, and every support
must declare its semantic class. Nonuniform weighted Parseval, concrete weight derivation,
physical shell membership, publication-mesh identification, and external source binding
remain open.

A common `τ_E`/`τ_O` intersection, minimum-cost threshold surface, approximate eigenpair binding,
and Wannier90 witness layer are later separately reviewed extensions, not statements already
selected by the D1 protocol. The first concrete instance must use an immutable owner revision and a
declared finite mesh. It may establish only a bounded finite-domain result. Unequal-rank
compression, gap-dependent subspace perturbation, and continuum Brillouin-zone claims remain later
separately reviewed work.

## R3 — continuum Fourier analysis

Candidate work:

- quotient-torus or fundamental-domain representation compatible with the pointwise sewing contract;
- torus measure and Fourier normalization;
- Parseval/Plancherel specialization;
- relation between onsite projection, global alignment, and nonzero Fourier weight; and
- precise hypotheses connecting finite and continuum statements.

Discrete results must not be promoted to continuum results by analogy.

## R4 — special functions and tail bounds

Candidate work:

- Jacobi–Anger expansions;
- Bessel coefficient identities;
- shell-resolved Fourier coefficients; and
- factorial or constrained-series tail bounds.

This stage follows, rather than precedes, the finite and continuum convention work.

## R5 — publication instantiation

Thin paper modules may instantiate reviewed foundational theorems, after which the publication crosswalk can name exact Lean declarations. Paper A now has conditional exact-center and interval-enclosure certificate bridges, but no concrete publication certificate, retained-data binding, or parser binding. Paper status remains separate from formal theorem status, numerical evidence status, and publication authorization.

The proposed publication narratives are recorded in
[`BandGauge/Papers/ragasa-series-research-plan.md`](BandGauge/Papers/ragasa-series-research-plan.md),
with detailed plans for
[Paper A](BandGauge/Papers/Ragasa2026A/paper-and-proof-plan.md),
[Paper B](BandGauge/Papers/Ragasa2026B/paper-and-proof-plan.md),
[Paper C](BandGauge/Papers/Ragasa2026C/paper-and-proof-plan.md), and a
[planning-only Paper D](BandGauge/Papers/Ragasa2026D/paper-and-proof-plan.md).
Paper A also has a prospective
[diagnostic-usefulness study](BandGauge/Papers/Ragasa2026A/diagnostic-usefulness-study-plan.md).
These paper narratives do not determine formal module ownership: reusable proofs are
organized by mathematical semantics, and publication modules remain thin source-specific
consumers. Paper D has no audited source or Lean namespace and remains planning-only until
the owner repository establishes both.

## Stop conditions

Stop and request review when:

- the source theorem or proof assumptions are ambiguous;
- a proposed statement changes rank, dimension, scalar field, domain, or alignment family;
- a required dependency lacks an immutable compatible revision;
- numerical data would need to be treated as exact without a checker boundary; or
- work would require modifying an owner repository or performing a protected action.
