<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# Publication evidence acceptance contract

## Status and authority

Contract identifier: `PKF-BG-EVIDENCE-CONTRACT/1`.

This document freezes the Project Koios Formal acceptance requirements for a compact,
immutable publication-evidence package. It is a verification-sidecar contract, not a
production serialization schema, retained numerical result, checked certificate,
scientific validation, publication claim, or authorization to mutate an owner repository.

The computational owner repository remains responsible for its producer, canonical
serializer, strict machine-readable schema, independent verifier, and retained artifacts.
This repository may later parse or bind a compact export only through separately reviewed
code and Lean theorems. `projectkoios-references` remains responsible for canonical
bibliography identity.

No current Paper A, B, or C output satisfies this complete contract. In particular, dirty
owner worktrees and ignored or replaceable development summaries are not eligible
publication evidence.

## Frozen policy decisions

### Coordinate weights

Reusable Lean statements may quantify over arbitrary strictly positive normalized
weights, because that is the source-faithful mathematical interface. A concrete
publication-evidence package, however, must not contain freely chosen or post-hoc weights.
Every accepted weight vector must be determined by a frozen rule that is independent of
the observed pass/fail or Pareto result.

The permitted determination modes are:

| Code | A-priori determination rule | Required evidence |
|---|---|---|
| `uniform-counting` | normalized counting/Haar measure on the declared complete finite group or uniform mesh | exact mesh cardinality and `αᵢ = 1/|G|` for every point |
| `geometric-cell` | normalized cell volumes, such as a frozen Voronoi or symmetry-reduced integration rule | exact geometry/convention, complete cells, normalization, and reproducible derivation |
| `moment-quadrature` | weights solve frozen exactness conditions for a declared finite function/moment class | target measure, moment basis, exact constraints, feasibility certificate, and deterministic tie rule |
| `optimized-quadrature` | weights minimize a preregistered quadrature-error functional over a fixed feasible set | objective, function class, positivity floor, symmetry constraints, solver certificate or independently checked global optimum, and deterministic tie rule |

For example, an optimized quadrature may solve

\[
  \min_{\alpha\in\Delta_\varepsilon}
  \max_{f\in\mathcal F}
  \left|\sum_i\alpha_i f(k_i)-\int f\,d\nu\right|,
  \qquad
  \Delta_\varepsilon=
  \left\{\alpha:\sum_i\alpha_i=1,\ \alpha_i\ge\varepsilon>0\right\},
\]

with the target measure `ν`, finite calibration class `𝓕`, positivity floor, symmetry
constraints, and tie-breaking rule fixed before evaluating scientific candidates.
Finite moment classes can lead to exact linear, quadratic, or conic certificate
obligations; a numerical optimizer alone is not proof of global optimality.

Weights optimized directly to reduce a candidate's reported operator or spectral loss are
not evaluation weights. If scientifically useful, they are explicit design variables and
must become part of the finite decision identifier. Final fidelity must still be evaluated
with a separate a-priori weight rule from the table above. This prevents a candidate from
improving merely by moving weight away from unfavorable mesh points.

A package may invoke uniform averaging only when its declared a-priori rule establishes

\[
  \alpha_i=\frac{1}{|G|}
\]

for every mesh point. `BG-FOURIER-THM-032` is then available as a specialization. The
theorem is not a justification for replacing a nonuniform rule by uniform weights.

Every weight record must provide:

- the determination-mode code and immutable rule identity;
- a stable mesh-point identifier;
- an exact rational value, or a conservative outward-rounded rational interval;
- a proof/check that its lower endpoint is strictly positive;
- the declared normalization rule and an exact proof/check of that rule;
- all geometric, moment, optimization, symmetry, and tie-breaking inputs required by the
  selected mode; and
- an independently reproducible derivation or optimization certificate.

Missing a-priori provenance, post-hoc tuning, an interval that does not establish strict
positivity, or unresolved normalization makes the weight vector ineligible for an
accepted publication result.

### Audited source dispositions

The current immutable sources support narrower choices than the reusable arbitrary-weight
mathematics:

- **Ragasa2026A general loss:** at `ksdft2effmass` commit
  `99a46cb59d0c6f27ada7d709f194996ef9619d9f`,
  `docs/publications/papers/Ragasa2026a/v3/manuscript.tex:558-563` introduces positive
  raw objective weights and normalization but does not state an a-priori derivation rule.
  Those general weights are therefore theorem parameters, not yet eligible concrete
  publication inputs under this contract.
- **Ragasa2026A constructed false positive:** the same source at lines `857-860` requires
  two equally weighted observations. This supports `uniform-counting` for that exact
  finite construction. Lines `1273-1282` separately invoke exact uniform quadrature only
  for the finite ordinary-lattice Parseval check.
- **Ragasa2026B bond-orbit controls:** at the same commit,
  `docs/publications/papers/Ragasa2026b/v2/manuscript.tex:611-623` requires orbit weights
  to be fixed by the selected symmetry contract, and lines `712-724` select explicit
  equal-weight triangular and FCC controls. These are model/symmetry weights, not
  permission to tune evaluation weights after observing fidelity.
- **Ragasa2026C D1 protocol:** at `ksdft2effmass` commit
  `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`,
  `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex:461-481`
  makes equal raw sample weights mandatory, and lines `1469-1473` require equal aggregate
  weights in the alignment record. The immediate D1 evidence contract should therefore
  use exact `uniform-counting`, not weight optimization.

Thus no current paper requires post-hoc evaluation-weight optimization. Optimized
quadrature remains a prospective method for a future nonuniform mesh and would require a
separately reviewed protocol before use.

### Support semantics

Every support record must select exactly one primary semantic class:

| Code | Meaning | Minimum additional data | Nonclaim |
|---|---|---|---|
| `arbitrary-finite` | an explicitly listed finite subset of the declared mode inventory | complete ordered member list | no closure, shell, locality, or physical-range claim |
| `negation-closed` | a finite support closed under mode negation | member list and checked negation closure | not necessarily a complete shell or physical range |
| `complete-metric-shell` | all modes through a declared metric radius, with equal-radius ties retained | metric, coordinate convention, radius/shell index, tie rule, and checked completeness | not automatically a physical hopping range |
| `source-hopping-range` | a source-specific retained hopping range | immutable source definition, lattice/basis convention, units, and exact membership rule | not automatically a metric shell |

Additional symmetry-orbit closure may be declared, but it does not replace the primary
class. Hermitian truncation requires the separately checked negative-mode/conjugate-
transpose pairing and negation closure used by `BG-FOURIER-THM-023/025`.

Support enlargement, complete-shell refinement, and physical-range refinement are
separate relations. A package must not silently smooth their discrete steps or infer
continuum coverage.

## Required package envelope

A conforming package contains the following logical records. Field names below specify
required meaning; the owner repository may choose its serialization only after freezing a
strict schema and canonical byte representation.

### 1. Contract and artifact identity

- contract identifier `PKF-BG-EVIDENCE-CONTRACT/1`;
- owner schema name and immutable schema version;
- globally unique package identifier;
- package creation timestamp and producer version;
- canonical serialization algorithm;
- digest algorithm and digest of the canonical package bytes;
- digest of every externally retained payload referenced by the package; and
- explicit status: development, candidate, retained, independently verified, or
  superseded.

Mutable labels, timestamps, or filenames are not artifact identity. A digest mismatch is
a hard rejection.

### 2. Source provenance

For every scientific or computational input:

- owner repository identity;
- descriptive branch name;
- full immutable commit hash;
- repository-relative path;
- byte digest at that commit;
- dirty-state declaration from the producing run;
- source role, such as protocol, model definition, threshold source, or producer code;
  and
- any external governed evidence or reference identifier once available.

A branch or tag without a commit is insufficient. Uncommitted source bytes may be
recorded as development context but cannot support a retained publication binding.

### 3. Tool and execution provenance

- producer executable and version/commit;
- independent-verifier executable and version/commit;
- dependency lock identity;
- numerical backend and precision mode;
- deterministic seed or explicit statement that no randomness is used;
- command/configuration digest;
- hardware/resource record when numerically relevant; and
- success, failure, or unresolved disposition for every mandatory integrity gate.

A successful process exit is not a substitute for mandatory scientific and integrity
gates.

### 4. Finite domain and mesh

- mesh identifier and finite cardinality;
- dimension, lattice, reciprocal-coordinate, endpoint, and representative conventions;
- exact ordered point identifiers and coordinates, or conservative rational coordinate
  enclosures;
- declared finite-group law when finite-abelian Fourier theorems are invoked;
- construction, withheld, and refinement roles;
- exhaustive-coverage statement limited to the declared finite inventory; and
- the complete coordinate-weight record specified above.

A finite mesh establishes no continuum Brillouin-zone claim.

### 5. Representation and operator data

- ambient and retained dimensions and ranks;
- matrix shape, index order, scalar representation, basis/frame identity, and units;
- positive reference energy `E_ref`, represented exactly or by a conservative interval;
- retained projectors/subspaces and reconstruction data when a spectral bridge is used;
- Hermiticity, rank, isolation, and residual checks required by the selected protocol;
- parent, retained-reference, aligned, interpolated, and truncated operator identities;
  and
- explicit distinction among oracle, retained-subspace, alignment, interpolation, and
  truncation errors.

Eigenvalues alone do not establish a retained-subspace or operator bridge. At degeneracy,
the package must use projectors, clusters, or multisets unless labeled eigenvectors are
separately justified.

### 6. Alignment and sewing

- admissible alignment family (`SO(r)`, `U(r)`, isometric compression, or another
  source-defined family);
- left/right action and adjoint orientation;
- global versus pointwise dependence;
- stable alignment identifier used by every objective channel;
- rank, isometry/unitarity, sewing, regularity, symmetry, and gauge-family gate results;
- failure disposition when any mandatory gate fails; and
- leakage data for unequal-rank compression.

The same candidate representation, support, and admissible alignment must satisfy all
joint-fidelity thresholds. Per-channel choices cannot be combined into a fictitious joint
witness.

### 7. Fourier and support record

- forward and inverse signs and normalization;
- finite index group and representative convention;
- coefficient ordering and complete declared mode inventory;
- selected primary support semantic code;
- exact support member list and membership rule;
- negation/conjugate closure result;
- shell metric, tie handling, and symmetry-orbit data when applicable; and
- retained and omitted coefficient-power summaries with their normalization.

Use of the uniform rank-two residual-tail theorem additionally requires the exact uniform
weight identity. Nonuniform momentum weights currently have no repository theorem that
identifies their weighted residual with the unweighted coefficient tail.

### 8. Decision and objective table

- complete finite decision inventory and stable decision identifiers;
- representation cost and every objective channel for every decision;
- exact rational values or conservative outward-rounded rational intervals;
- thresholds with source, units, and strict/non-strict comparison convention;
- weak-all/strict-any minimization dominance convention;
- claimed nondominated mask;
- minimum feasible cost and witness identifier when claimed;
- explicit common-witness result for joint thresholds; and
- refinement/stability records required by the protocol.

A componentwise envelope is not an attainable decision unless one listed decision realizes
all of its coordinates. Plot triangulations, convex hulls, or interpolated surfaces do not
add decisions to the inventory.

### 9. Checker and crosswalk result

- checker repository and immutable commit;
- checker entry point and configuration digest;
- formal repository, commit, Lean toolchain, Mathlib revision, and theorem IDs used;
- accepted, rejected, or unresolved result for each obligation;
- exact rejected/unresolved reason codes;
- independent-verifier result over the canonical bytes; and
- publication claim/source locations to which an accepted conclusion is crosswalked.

A package is not a concrete checked scientific certificate until its identity, complete
input binding, checker result, and target-proposition bridge are all present.

## Fail-closed rules

The verifier must reject, rather than guess or repair, when any of the following occurs:

1. unknown contract or owner-schema version;
2. missing mandatory field or unrecognized mandatory enumeration value;
3. noncanonical serialization or digest mismatch;
4. missing full commit, source path, or source-byte digest;
5. retained status derived from dirty or uncommitted source bytes;
6. duplicate or noncanonical mesh, mode, alignment, or decision identifiers;
7. unresolved mesh coverage or a mismatch between declared cardinality and inventory;
8. nonpositive weight, unresolved weight positivity, or failed normalization;
9. a weight vector without a permitted a-priori determination mode, reproducible
   derivation, or required optimization certificate;
10. post-hoc evaluation-weight tuning against candidate losses, thresholds, or the
    reported Pareto outcome;
11. a uniform-weight claim without exact equality and its declared counting/Haar rule;
12. nonpositive or unit-inconsistent `E_ref`;
13. matrix shape, rank, basis, frame, Hermiticity, projector, or isolation mismatch;
14. failed alignment, sewing, regularity, symmetry, or gauge-family integrity;
15. subtraction of operators without a common-fiber alignment identity;
16. missing support semantic class or incomplete support membership record;
17. split equal-radius ties in a declared complete metric shell;
18. missing negation closure where Hermitian truncated reconstruction is claimed;
19. incomplete decision/objective coverage;
20. Pareto or threshold comparison based on interval overlap;
21. different representations, supports, or alignments used for the two channels of a
    claimed joint witness;
22. failed independent verification; or
23. a finite result labeled as continuum evidence.

Interval overlap produces `unresolved`, not dominance, feasibility, infeasibility, pass,
or failure. A negative finite-domain conclusion additionally requires exhaustive declared
coverage or a separately checked global certificate.

## Acceptance levels

The following levels must remain distinct:

1. **identity-bound** — immutable sources and canonical bytes are identified;
2. **schema-validated** — the owner schema and all structural integrity gates pass;
3. **numerically verified** — the independent verifier reproduces the declared bounded
   computations;
4. **formally checked** — exact exported data pass a Lean-connected checker whose
   soundness theorem proves the stated conclusion;
5. **crosswalked** — that conclusion is linked to a reviewed publication proposition;
6. **scientifically assessed** — applicability and interpretation have undergone their
   separately governed review.

Advancing one level does not imply any later level. In particular, formal checking does
not establish physical applicability or publication acceptance.

## Current checker mapping

| Existing infrastructure | What it can consume | Missing package boundary |
|---|---|---|
| `RankTwoSeparation.lean` | exact rational scalar certificate | field/matrix derivation, canonical serialization, source and artifact binding |
| `RankTwoSeparationEnclosure.lean` | rational enclosure of an algebraic center | conservative computational enclosure for curvature and source binding |
| `RankTwoSeparationBox.lean` | exact rational joint enclosure of positive `κ` and nonnegative `μ`, with uniform witness, containment, and separation conclusions | field derivation, canonical serialization, source and artifact binding |
| `Ragasa2026A/CertificateBridge.lean` and `KappaEnclosureBridge.lean` | exact hypotheses connecting checked scalars or scalar intervals to canonical finite fields | concrete runtime publication matrices, weights, `κ`, `μmax`, thresholds, and parser binding |
| `Certificates/FinitePareto.lean` | a total finite exact objective table | external inventory coverage, interval semantics, parser, and retained table binding |
| finite Fourier modules | exact finite-group fields, supports, and constant/uniform-weight specializations | publication mesh/group identification, nonuniform-weight theorem, physical support meaning, and artifact binding |

These are implemented verification components, not evidence packages. The retained
runtime evidence-package count remains zero. The exact Paper A two-observation analytic
certificate and its degenerate-`κ` regression are source constructions encoded in Lean,
not runtime evidence packages.

## First binding gate

Before this repository binds its first Paper A, B, or C result, all of the following must
be available at immutable revisions:

1. an owner-approved scientific protocol;
2. a strict owner serialization schema and canonical serializer;
3. a fail-closed producer;
4. an independent direct-formula verifier;
5. one retained package satisfying this contract;
6. complete source, mesh, a-priori weight derivation, support, alignment, and decision
   coverage as applicable;
7. conservative interval treatment of floating results;
8. a reviewed parser/checker boundary in this repository;
9. exact theorem hypotheses connecting parsed data to the target proposition; and
10. a publication crosswalk naming the bounded conclusion and all residual assumptions.

Until those gates pass, development output may guide implementation but must not be
counted as a checked publication certificate or immutable formal evidence.

## Versioning

Changing field meaning, weight policy, support semantic codes, canonical identity rules,
comparison semantics, or rejection behavior requires a new major contract version.
Adding an optional field with unchanged acceptance meaning may use a documented minor
revision. Historical packages remain interpreted only under the exact contract and owner
schema versions they declare.
