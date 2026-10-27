<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# Publication evidence acceptance contract

Contract: `PKF-BG-EVIDENCE-CONTRACT/1`.

This contract defines Formal's acceptance boundary for compact immutable publication evidence. It is not a production schema, artifact, checked certificate, scientific validation, publication claim, or execution authorization.

The computational owner owns the producer, strict schema, canonical serializer, independent verifier, and retained artifacts. Formal may bind only a separately reviewed compact export. No current Paper A, B, or C runtime output satisfies this contract.

## Coordinate weights

Reusable theorems may quantify over positive normalized weights. A concrete package must use an a-priori rule independent of observed losses, thresholds, pass/fail status, or Pareto outcome.

| Code | Rule | Required evidence |
|---|---|---|
| `uniform-counting` | normalized counting/Haar measure on a complete finite group or uniform mesh | exact cardinality and `αᵢ = 1/|G|` |
| `geometric-cell` | normalized cell volumes from a frozen geometric rule | geometry, convention, complete cells, normalization, reproducible derivation |
| `moment-quadrature` | exactness for a frozen finite moment class | target measure, basis, exact constraints, feasibility certificate, deterministic tie rule |
| `optimized-quadrature` | global minimization of a preregistered quadrature-error objective | objective, function class, positivity floor, symmetry constraints, global-optimum certificate, tie rule |

A prospective optimized rule may solve

\[
\min_{\alpha\in\Delta_\varepsilon}\max_{f\in\mathcal F}
\left|\sum_i\alpha_i f(k_i)-\int f\,d\nu\right|,
\qquad
\Delta_\varepsilon=\{\alpha:\sum_i\alpha_i=1,\ \alpha_i\ge\varepsilon>0\}.
\]

The measure, calibration class, constraints, and tie rule must be fixed before evaluating candidates. A numerical optimizer alone does not prove global optimality.

Weights optimized against candidate losses are design variables, not evaluation weights. Final fidelity still uses a separate a-priori rule.

Each weight record contains:

- mode code and immutable rule identity;
- mesh-point identifier;
- exact rational value or outward-rounded rational interval;
- strict-positivity and normalization checks;
- required geometry, moment, optimization, symmetry, and tie inputs; and
- reproducible derivation or optimization certificate.

Missing provenance, post-hoc tuning, unresolved positivity, or failed normalization is ineligible.

### Audited source dispositions

Current sources permit only the following weight rules.

- Paper A general loss, commit `99a46cb59d0c6f27ada7d709f194996ef9619d9f`, `docs/publications/papers/Ragasa2026a/v3/manuscript.tex:558-563`: positive normalized weights are theorem parameters; no concrete a-priori rule is stated.
- Paper A construction, same source lines `857-860`: two equal weights support `uniform-counting`; lines `1273-1282` use exact uniform quadrature only for the ordinary-lattice Parseval check.
- Paper B, same commit, `docs/publications/papers/Ragasa2026b/v2/manuscript.tex:611-623`: orbit weights follow the symmetry contract; lines `712-724` select equal-weight triangular and FCC controls. These are not post-hoc evaluation weights.
- Paper C D1, commit `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`, `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex:461-481`; lines `1469-1473`: raw sample and aggregate weights are equal. Immediate D1 evidence must use `uniform-counting`.

## Support semantics

Each support record selects one primary class.

| Code | Meaning | Required data | Nonclaim |
|---|---|---|---|
| `arbitrary-finite` | explicit finite subset | complete ordered members | no closure, shell, locality, or physical range |
| `negation-closed` | finite support closed under negation | members and closure check | not necessarily a complete shell |
| `complete-metric-shell` | all modes through a metric radius, including ties | metric, coordinates, radius/index, tie rule, completeness check | not automatically a physical hopping range |
| `source-hopping-range` | source-defined retained range | immutable definition, lattice/basis, units, membership rule | not automatically a metric shell |

Symmetry-orbit closure is additional. Hermitian truncation separately requires negative-mode/conjugate-transpose pairing and negation closure. Support enlargement, shell refinement, and physical-range refinement are different relations.

## Package envelope

Field names below specify meaning. The owner may choose serialization only after freezing a strict schema and canonical bytes.

### Identity

Identity fields bind canonical bytes.

- contract and owner-schema versions;
- unique package identifier;
- creation timestamp and producer version;
- canonical serialization algorithm;
- digest algorithm, package digest, and referenced-payload digests; and
- status: development, candidate, retained, independently verified, or superseded.

Filenames and timestamps are not artifact identity. Digest mismatch rejects the package.

### Source provenance

For every input:

- repository, descriptive branch, full commit, relative path, and byte digest;
- producing-run dirty state;
- source role; and
- external governed evidence/reference identity when available.

Uncommitted bytes may be development context but cannot support retained publication evidence.

### Tool and execution provenance

Execution provenance binds the producer and verifier.

- producer and independent-verifier revisions;
- dependency lock;
- numerical backend and precision;
- deterministic seed or no-randomness declaration;
- command/configuration digest;
- relevant hardware/resource record; and
- disposition of every mandatory gate.

### Finite domain and mesh

The finite inventory must be complete and explicit.

- mesh identity, cardinality, and ordered point inventory;
- dimension, lattice, reciprocal-coordinate, endpoint, and representative conventions;
- exact coordinates or rational enclosures;
- finite-group law when finite-abelian theorems are used;
- construction, withheld, and refinement roles;
- finite-inventory coverage statement; and
- complete coordinate-weight record.

A finite mesh establishes no continuum claim.

### Representation and operators

Operator data must preserve representation identity.

- ambient and retained dimensions/ranks;
- shapes, index order, scalar encoding, basis/frame identity, and units;
- positive exact or interval `E_ref`;
- retained projectors/subspaces and reconstruction data;
- required Hermiticity, rank, isolation, and residual checks;
- parent, retained, aligned, interpolated, and truncated identities; and
- separate oracle, subspace, alignment, interpolation, and truncation errors.

Eigenvalues alone do not establish a subspace bridge. Degeneracy requires projectors, clusters, or multisets unless labeled eigenvectors are justified.

### Alignment and sewing

One alignment record serves every objective channel.

- admissible family and rank;
- left/right action and adjoint orientation;
- global or pointwise dependence;
- one stable alignment identifier for every channel;
- unitarity/isometry, sewing, regularity, symmetry, and family gates;
- failure dispositions; and
- leakage for unequal-rank compression.

One candidate, support, and alignment must satisfy joint thresholds.

### Fourier and support

Fourier and support conventions remain explicit.

- signs, normalization, finite group, and representatives;
- coefficient order and complete mode inventory;
- support class, members, and membership rule;
- negation/conjugate closure;
- shell metric, tie, and orbit data; and
- retained/omitted power summaries.

The uniform residual-tail specialization requires exact uniform weights. No current theorem equates a nonuniform weighted residual with the unweighted coefficient tail.

### Decision and objectives

The decision table is a complete finite ledger.

- complete finite decision inventory and stable IDs;
- cost and all objective channels for every decision;
- exact values or outward-rounded intervals;
- threshold source, units, and comparison convention;
- weak-all/strict-any dominance;
- claimed nondominated mask;
- minimum feasible cost and witness, when claimed;
- common-witness result; and
- required refinement/stability records.

A componentwise envelope, interpolation, hull, or plot does not add an attainable decision.

### Checker and crosswalk

The checker record binds exact conclusions to source claims.

- checker repository, commit, entry point, and configuration digest;
- Formal commit, Lean/Mathlib revisions, and theorem IDs;
- accepted, rejected, or unresolved result for each obligation;
- reason codes;
- independent-verifier result over canonical bytes; and
- bounded publication proposition and source locator.

## Fail-closed rules

Reject on:

- unknown version, field, or enumeration; missing mandatory data; noncanonical bytes; or digest mismatch;
- missing immutable source identity, dirty retained source, or duplicate/noncanonical identifiers;
- mesh-cardinality or coverage mismatch;
- nonpositive, unnormalized, post-hoc, or unjustified weights;
- false uniform-weight claim;
- nonpositive or unit-inconsistent `E_ref`;
- shape, rank, basis, frame, Hermiticity, projector, isolation, alignment, sewing, regularity, symmetry, or family failure;
- operator subtraction without a common-fiber alignment;
- absent support class, incomplete membership, split equal-radius ties, or missing negation closure for a Hermitian claim;
- incomplete decision/objective coverage;
- dominance or threshold decisions from overlapping intervals;
- different candidate choices across joint channels;
- failed independent verification; or
- finite evidence labeled as continuum evidence.

Interval overlap is `unresolved`. A negative finite-domain conclusion requires exhaustive declared coverage or a separate global certificate.

## Acceptance levels

Six levels remain independent.

1. `identity-bound`
2. `schema-validated`
3. `numerically-verified`
4. `formally-checked`
5. `crosswalked`
6. `scientifically-assessed`

No level implies the next.

## Current checker mapping

Existing checkers still lack runtime package bindings.

| Infrastructure | Accepts | Missing boundary |
|---|---|---|
| `RankTwoSeparation.lean` | exact rational scalar certificate | field derivation, serialization, source/artifact binding |
| `RankTwoSeparationEnclosure.lean` | rational center enclosure | conservative input enclosures and binding |
| Paper A bridge modules | exact hypotheses connecting checked scalars to finite fields | concrete matrices, weights, parameters, thresholds, parser |
| `Certificates/FinitePareto.lean` | total finite exact objective table | inventory coverage, interval semantics, parser, retained table |
| finite Fourier modules | exact finite-group fields and supports | publication mesh, nonuniform weighting, physical support, artifact binding |

These are verification components, not evidence packages. The runtime checked-certificate count is zero.

## First binding gate

The first Paper A, B, or C binding requires immutable:

1. owner-approved protocol;
2. strict schema and canonical serializer;
3. fail-closed producer;
4. independent direct-formula verifier;
5. one retained conforming package;
6. complete applicable source, mesh, weight, support, alignment, and decision coverage;
7. conservative intervals for floating results;
8. reviewed Formal parser/checker boundary;
9. exact theorem hypotheses connecting data to the proposition; and
10. publication crosswalk with residual assumptions.

## Versioning

A change to meaning, weight policy, support classes, canonical identity, comparison semantics, or rejection behavior requires a new major version. Optional fields with unchanged acceptance meaning may use a documented minor revision. Historical packages remain tied to their declared contract and owner-schema versions.
