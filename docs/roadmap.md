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

`BG-PLAN-002` now includes reduced scalar squared and real losses, normalized correlation, irreducible-floor and nonnegativity bounds, below-floor emptiness, square-root recovery, threshold equivalence, the operator radius, explicit ellipse conditions, the exact full-plane intersection criterion and Euclidean distance, explicit containment-based transfer to a closed candidate rectangle, the generic finite weighted Frobenius correlation inequality `|b| ≤ κ`, operator and spectral residual-to-scalar-loss bridges, abstract periodic sampled-parent infrastructure, conditional exact Paper A operator and canonical spectral-field bridges, and canonical exact Pauli extraction, continuous correlation-harmonic optimization with a canonical half-open maximizing angle, the reduced matrix-loss bridge centered at `μmax`, and canonical full-plane/candidate-rectangle admissible-set intersection and distance specializations. Construction from a periodic potential, concrete publication-data binding, and numerical verification remain open.

Each declaration requires a source crosswalk and named axiom report.

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

Thin paper modules may instantiate reviewed foundational theorems, after which the publication crosswalk can name exact Lean declarations. Paper status remains separate from formal theorem status, numerical evidence status, and publication authorization.

## Stop conditions

Stop and request review when:

- the source theorem or proof assumptions are ambiguous;
- a proposed statement changes rank, dimension, scalar field, domain, or alignment family;
- a required dependency lacks an immutable compatible revision;
- numerical data would need to be treated as exact without a checker boundary; or
- work would require modifying an owner repository or performing a protected action.
