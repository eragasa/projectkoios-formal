<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-20
-->

# `ksdft2effmass` mathematical representation class architecture plan

## Status and authority boundary

This document is a verification-side recommendation for an owner-side design plan. It is
not an accepted `ksdft2effmass` architecture, an implementation patch, a schema migration,
a retained computational artifact, a formal proof, or authorization to change or publish
the owner repository.

The proposed architecture is intended to align the computational representations used by
Ragasa2026A--C with the mathematical objects and hypotheses used by the manuscripts and
by `projectkoios-formal`. It deliberately does not make Lean a runtime dependency of
`ksdft2effmass`. The governing cross-repository rule, which also applies to
`projectkoios-physkit` and the `projectkoios.numerics` and
`projectkoios.optimization` packages, is recorded in
[`../../ecosystem-architecture.md`](../../ecosystem-architecture.md#executable-verification-boundary-for-computational-peers).

The bounded review used immutable source objects from:

- Papers A and B implementation: repository `ksdft2effmass`, commit
  `99a46cb59d0c6f27ada7d709f194996ef9619d9f`;
- Paper C higher-rank implementation and manuscript sources: repository
  `ksdft2effmass`, commit `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`.

The inspected owner checkouts were dirty. Dirty and ignored files were not treated as
immutable evidence. Any owner-side implementation must re-audit the selected clean base
revision before work begins.

## Review result

- Technical review outcome: `CHANGES_REQUIRED` for a common Paper A--C mathematical
  representation hierarchy.
- Immediate operator request from this document: `NONE`.
- Owner-side next step: prepare a concrete, bounded implementation plan and request
  operator approval before modifying production classes or schemas.

The existing paper-specific calculations are not declared invalid by this review. The
finding is that their current classes do not yet form one reusable type system that keeps
spaces, representations, transformations, evidence, diagnostics, and finite decisions
mathematically distinct.

## Design objectives

The owner-side architecture should:

1. make the represented domain, vector space, rank, basis, and representation role
   explicit;
2. represent projection, compression, gauge action, alignment, Fourier conversion,
   truncation, and reconstruction as distinct transformations;
3. prevent matrix subtraction or error comparison before a common-space identification
   has been declared;
4. distinguish numerical arrays from evidence that they satisfy Hermiticity, isometry,
   unitarity, sewing, rank, support, or coverage conditions;
5. share rank- and dimension-generic machinery across Papers A--C;
6. retain paper-specific model laws and campaign controls as thin configurations;
7. preserve explicit failure, unresolved, not-applicable, and cap-exhausted outcomes;
8. preserve old serialized records until a separately reviewed schema migration is
   approved;
9. expose enough immutable identity for a later certificate bridge without claiming that
   a Python object is a Lean proof; and
10. keep computational runtime ownership in `ksdft2effmass`.

## Architecture rule: shallow inheritance, explicit composition

Do not introduce one universal `MathematicalObject` superclass. Start from several narrow
abstract base classes. Use inheritance only for stable behavioral interfaces. Use
composition for mathematical structure, transformation history, evidence, diagnostics,
and publication records.

Recommended Python mechanisms are:

- abstract base classes for domains, fields, representations, transformations,
  alignment strategies, analyzers, and decision problems;
- narrow `Protocol` interfaces for capabilities such as metric geometry;
- frozen, slotted, preferably final dataclasses for concrete values and records;
- discriminated unions for qualified, deficient, unresolved, not-applicable, and
  cap-exhausted results; and
- versioned discriminator fields for serialization rather than Python subclass names.

Do not subclass NumPy arrays. A NumPy-backed leaf object should own or reference an
immutable validated array while implementing a semantic-neutral field interface.

## Proposed package boundary

A candidate package layout for owner review is:

```text
python/src/ksdft2effmass/analysis/
  matrix_field/                    # existing numerical kernels and diagnostics
  operator_representation/         # proposed semantic representation layer
    domains.py
    spaces.py
    fields.py
    identities.py
    representations.py
    transformations.py
    evidence.py
    alignment.py
    support.py
    errors.py
    decisions.py
    results.py
```

`analysis.matrix_field` should remain responsible for generic array calculations such as
matrix-field errors, perturbation diagnostics, structure residuals, and refinement.
`analysis.operator_representation` would state what those arrays represent and how one
representation was obtained from another.

This package name and ownership boundary require owner approval. Extending
`analysis.matrix_field` directly is a defensible alternative, but it risks mixing
semantic representation identity with low-level numerical diagnostics.

## Abstract computational field hierarchy

```text
FiniteDomainABC
├── CenteredUniformMeshDomain
├── ShiftedEvaluationMeshDomain
└── FiniteTranslationDomain

MatrixFieldABC
├── SquareMatrixFieldABC
│   ├── OperatorFieldABC
│   ├── ProjectorFieldABC
│   └── GaugeFieldABC
├── RectangularMatrixFieldABC
│   └── FrameFieldABC
└── FourierBlockFieldABC
```

A minimal interface can follow this shape:

```python
from __future__ import annotations

from abc import ABC, abstractmethod

from projectkoios.numerics.numpy.typing import Complex128Array


class FiniteDomainABC(ABC):
    @property
    @abstractmethod
    def identity(self) -> str: ...

    @property
    @abstractmethod
    def cardinality(self) -> int: ...


class MatrixFieldABC(ABC):
    @property
    @abstractmethod
    def domain(self) -> FiniteDomainABC: ...

    @property
    @abstractmethod
    def values(self) -> Complex128Array: ...

    @property
    @abstractmethod
    def source_dimension(self) -> int: ...

    @property
    @abstractmethod
    def target_dimension(self) -> int: ...
```

These interfaces establish domain and shape. They must not infer exact Hermiticity,
unitarity, isometry, projector identities, periodicity, or sewing from the array type.

The field hierarchy should distinguish:

- square operator fields;
- rectangular frame or isometry fields;
- square gauge fields acting within one retained fiber; and
- coefficient fields indexed by translations rather than momenta.

A gauge field is not itself an operator representation merely because both use square
matrices.

## Mathematical property evidence

Mathematical properties should be attached through immutable evidence records rather than
through optimistic subclass names. Candidate records include:

```text
HermiticityEvidence
IsometryEvidence
UnitarityEvidence
ProjectorEvidence
ConstantRankEvidence
PeriodicityEvidence
SewingEvidence
CoverageEvidence
SupportClosureEvidence
TransformationIdentityEvidence
```

Every evidence record should identify:

- the field or representation to which it applies;
- the stage at which it was evaluated;
- the method and tolerance or exact certificate convention;
- the finite domain covered;
- the resulting disposition; and
- any retained bound, interval, or failure location.

Evidence modes must distinguish at least:

```text
analytic-identity-declared
checked-exact-certificate
checked-outward-interval-certificate
numerical-diagnostic
unresolved
not-applicable
```

An analytic declaration in Python is provenance for a formula, not by itself a formal
proof. A tolerance-qualified numerical diagnostic is not interchangeable with a Lean
hypothesis asserting an exact property.

## Representation hierarchy

```text
OperatorRepresentationABC
├── BlochOperatorRepresentationABC
│   ├── AmbientBlochRepresentation
│   ├── RetainedBlochRepresentation
│   ├── GaugeTransformedBlochRepresentation
│   ├── AlignedBlochRepresentation
│   └── ReconstructedBlochRepresentation
└── CellHoppingRepresentationABC
    ├── CompleteFourierRepresentation
    └── TruncatedFourierRepresentation
```

The concrete stages should be sibling implementations of a suitable abstract base. A
Fourier representation is not a subtype of a Bloch representation; the two are related by
a Fourier transform. Similarly, an aligned field is related to its source by an alignment
map rather than by object inheritance.

Every representation should carry an immutable identity such as:

```python
from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class RepresentationIdentity:
    representation_id: str
    domain_id: str
    space_id: str
    basis_id: str
    rank: int
```

The final owner design should additionally bind scalar field, coordinate convention,
energy reference, and source artifact identity where applicable.

`space_id` and `basis_id` have different roles. Two matrices may act on isomorphic spaces
while still requiring a declared basis transformation before entrywise subtraction.

## Transformation hierarchy

```text
RepresentationMapABC[Source, Target]
├── SpectralProjectorConstruction
├── FrameConstruction
├── FrameCompression
├── GaugeConjugation
├── AlignmentTransformation
├── FiniteFourierConversion
├── SupportTruncation
└── FourierReconstruction
```

Each transformation result should retain:

- the source and target representation identities;
- the transformation convention and orientation;
- all supplied witnesses, frames, gauges, or supports;
- the construction or solver method identity;
- applicable residual and rank evidence;
- a disposition; and
- enough provenance to prevent a result from being rebound to different arrays.

This makes the computational chain correspond to the mathematical chain

\[
H_p
\longrightarrow P
\longrightarrow F
\longrightarrow F^\dagger H_pF
\longrightarrow G^\dagger(F^\dagger H_pF)G
\longrightarrow \widehat H_R
\longrightarrow \widehat H_R\mathbf 1_{R\in S}
\longrightarrow H_S(k).
\]

Projection, frame selection, compression, gauge transformation, alignment, Fourier
conversion, support truncation, and reconstruction must remain distinct even when one
calculator currently performs several of them in sequence.

## Alignment strategy hierarchy

Alignment channels should be strategies, not subclasses of representations:

```text
AlignmentStrategyABC
├── IdentityAlignment
├── GlobalRealRotationAlignment
├── GlobalUnitaryProcrustesAlignment
├── PointwiseUnitaryProcrustesAlignment
├── ParallelTransportAlignment
└── SuppliedAnalyticInverseGaugeAlignment
```

Use a discriminated result union:

```text
AlignmentSelectionResult
├── QualifiedAlignmentSelection
├── RankDeficientAlignmentSelection
├── NumericallyUnresolvedAlignmentSelection
└── NotApplicableAlignmentSelection
```

The common qualified record should retain the selected transformation field or constant
transformation, its source and target identities, objective definition, weighting rule,
rank evidence, integrity diagnostics, and orientation.

For Paper C, the natural strategy mapping is:

| Channel | Strategy role |
|---|---|
| A0 | identity/no corrective alignment |
| A1 | one global unitary Procrustes alignment |
| A2 | pointwise unitary Procrustes alignment |
| A3 | supplied inverse of the analytic generating gauge |

A0--A3 remain protocol channel identifiers. They do not justify four independent
representation type hierarchies.

## Support hierarchy

The publication evidence contract requires one primary support semantic class. Model it
with sibling concrete types:

```text
SupportABC
├── ArbitraryFiniteSupport
├── NegationClosedSupport
├── CompleteMetricShellSupport
└── SourceHoppingRangeSupport
```

Do not make `CompleteMetricShellSupport` inherit from `NegationClosedSupport`, even if a
specific shell is negation closed. Such inheritance would erase the required primary
semantic classification. Additional properties should be composed as evidence:

```text
NegationClosureEvidence
CompleteOrbitEvidence
MetricShellCompletenessEvidence
SourceRangeBinding
```

A support ladder is a separate object containing an ordered, finite, fully declared
inventory. Its costs must keep block count, support radius, and shell index distinct:

```python
@dataclass(frozen=True, slots=True)
class SupportCost:
    retained_block_count: int
    maximum_support_radius: float | None
    shell_index: int | None
```

Paper C's one-dimensional symmetric ranges should declare the appropriate primary
semantic class explicitly. They should not be called a physical hopping range unless the
source protocol establishes that interpretation.

## Error and loss architecture

Recommended behavioral bases are:

```text
ErrorMeasureABC
├── FrobeniusErrorMeasure
├── OperatorNormErrorMeasure
├── OrderedSpectrumErrorMeasure
└── WeightedFrobeniusLossMeasure
```

The scalar result records themselves should use composition rather than deep inheritance.
Every error result must state:

- source and target representation identities;
- comparison domain;
- matrix or spectral object;
- norm;
- aggregation rule;
- rank normalization, if any;
- energy normalization;
- evaluation weights and weight-rule identity; and
- interval or floating-point disposition.

The descriptive rank-normalized Frobenius channel
\(\lVert\Delta\rVert_F/\sqrt r\) must remain separate from a general eigenvalue-error
bound. Valid general perturbation channels use the operator norm or rank-unnormalized
Frobenius norm. A specialized normalized bound requires separately proved structure.

Paper A/B's legacy `ErrorChannels` should therefore be retained only through an explicit
legacy adapter. Paper C's newer `MatrixFieldErrorSummary`,
`MatrixPerturbationBoundDiagnostics`, and `MatrixFieldComparisonDiagnostics` are a better
starting point for the shared implementation.

## Finite decision architecture

```text
FiniteDecisionProblemABC
├── ThresholdDecisionProblem
├── FirstPassingDecisionProblem
└── FiniteParetoDecisionProblem
```

Recommended value objects include:

```text
FiniteObjectivePoint
ThresholdDecisionResult
EarlierCutoffAuditEntry
FirstPassAudit
JointThresholdDecisionResult
ParetoAssessment
MinimumFeasibleCostResult
```

The rules are:

- a first pass checks every earlier declared cutoff unless monotonicity has been proved;
- a joint pass uses the same representation, support, cutoff, and alignment witness for
  all channels;
- an interval-overlapping threshold comparison is unresolved;
- `cap-exhausted` is a resolved outcome for the declared finite inventory;
- a Pareto set contains attainable sampled objective vectors only; and
- a rendered triangulation is not a continuum feasible or Pareto surface.

## Parameterized families

Paper B's strain calculations should use separate abstractions for parameter paths and
parameterized families:

```text
ParameterPathABC
├── BainPath
└── OtherDeclaredFinitePath

ParameterizedRepresentationFamilyABC
```

A parameterized family returns ordinary representation nodes and transformation edges at
each declared parameter value. Strain envelopes, transition brackets, and extrema are
analysis results over the finite path; they are not new operator representations.

## Mapping of current classes

| Paper | Current class or function | Recommended role |
|---|---|---|
| A | `AxisSymmetricFourStateParent` | implementation of an analytic `BlochOperatorLawABC` |
| A | `SeparableSineRotation` | implementation of an analytic `GaugeLawABC` |
| A | `FrameTransportDiagnostic` | shared transport-qualification result |
| A | `restricted_alignment` | `GlobalRealRotationAlignment` strategy |
| A | `PointDiagnostic` | aggregate composed from premise, alignment, Fourier, error, and decision records |
| A/B | `ErrorChannels` | explicit legacy adapter only |
| A/B | `FirstPassingDecision` | replace with exhaustive `FirstPassAudit` in a new schema |
| B | `BandEquivalenceLocalityCase` | composition of geometry, parent law, and gauge-normalization specifications |
| B | `MetricGeometry` | retain as a narrow capability protocol |
| B | `SignedPermutationShell*` | `CompleteMetricShellSupport` and `SupportLadder` implementations |
| B | `ShellScaleDecisionPoint` | shared finite objective point |
| B | `ShellScaleCaseDecisionLandscape` | finite sampled decision inventory, not a continuum surface |
| B | strain records | parameter-path analysis records |
| C | `HigherRankD1SampledFields` | replace internally with a composed `CaseRepresentationBundle` |
| C | `HigherRankD1ModelConstructor` | analytic representation-pipeline implementation |
| C | A1/A2 selection classes | shared alignment-result variants |
| C | `HigherRankD1FourierDiagnostics` | shared Fourier-qualification record |
| C | `HigherRankD1SupportDiagnostics` | composition of support, truncation, reconstruction, and error results |
| C | `HigherRankD1ParetoPoint` | shared finite objective point |
| C | `analysis.matrix_field.diagnostics` | preferred generic numerical layer |

## Paper instantiations

### Ragasa2026A

The Paper A pipeline should instantiate:

1. an ambient Bloch operator law;
2. a retained frame and retained Bloch representation;
3. a momentum-dependent gauge-transformed comparison representation;
4. a declared global real-rotation alignment strategy;
5. weighted spectral and Frobenius loss measures; and
6. finite or analytic compatibility and separation decisions.

Fourier diagnostics may be attached, but they are not prerequisites of the core
compatibility theorem unless the particular result explicitly uses them.

### Ragasa2026B

Paper B extends the aligned retained representation through:

1. finite Fourier conversion;
2. a complete coefficient representation;
3. a declared complete-shell support ladder;
4. support truncation and reconstruction;
5. interpolation, truncation, and total error channels; and
6. finite attainable objective and Pareto decisions.

Cell--orbital, Bloch, spectral, retained-frame, and cell-hopping representations should
remain explicitly named. A diagonal spectral array is not an operator in the parent
orbital basis without its eigenvector map.

### Ragasa2026C

Paper C generalizes rank, gauge class, and alignment strategy while retaining the same
representation graph. The D1 P0/G0 calculation should use:

1. an ambient analytic parent representation;
2. a retained projector and reference frame;
3. a retained operator in reference coordinates;
4. a generated internal gauge and attacked representation;
5. A0--A3 alignment strategies applied to the same identified source objects;
6. Fourier conversion, explicit symmetric support, and reconstruction; and
7. common matrix/spectral error and finite decision records.

The architecture must remain capable of representing moving projectors, complex `U(r)`
gauges, unequal-rank isometric compression, leakage, and Wannier90-supplied frames without
pretending that these extensions are already implemented or formally verified.

## Computational-to-formal correspondence

| Formal object or hypothesis | Owner-side computational representation |
|---|---|
| finite momentum type or mesh | `FiniteDomainABC` implementation |
| matrix field \(k\mapsto H(k)\) | `OperatorFieldABC` |
| Hermiticity hypothesis | `HermiticityEvidence` |
| retained projector \(P(k)\) | `ProjectorFieldABC` plus projector evidence |
| retained frame \(F(k)\) | `FrameFieldABC` plus isometry/sewing evidence |
| gauge \(G(k)\) | `GaugeFieldABC` plus unitarity evidence |
| \(F^\dagger H F\) | `FrameCompression` transformation |
| \(G^\dagger D G\) | `GaugeConjugation` transformation |
| admissible alignment | `AlignmentStrategyABC` plus qualified result |
| finite Fourier coefficients | `CompleteFourierRepresentation` |
| support \(S\) | one primary `SupportABC` implementation |
| truncated reconstruction | `SupportTruncation` and `FourierReconstruction` |
| weighted loss | error-measure specification and immutable weight identity |
| finite Pareto set | finite objective inventory and checked dominance mask |
| first passing cutoff | exhaustive ordered cutoff audit |
| theorem applicability | explicit premise or certificate bundle |

A future serialized formalization bridge may cite stable theorem IDs and bind their
premises to immutable evidence. It must not infer formal validity merely because an object
implements an abstract base class.

## Validation and substitutability rules

Many current records use `type(value) is ConcreteClass` or exact-instance helper checks.
Those checks conflict with a reusable inheritance hierarchy.

The owner plan should apply these rules:

1. use `isinstance(value, AbstractContract)` for in-memory substitutability;
2. validate all semantic invariants in concrete leaf constructors;
3. use exact discriminator/version checks only at serialization boundaries;
4. do not accept an arbitrary subclass merely because its field names match a schema;
5. serialize through explicit tagged unions rather than Python qualified class names; and
6. mark concrete schema records final when extension would change their meaning.

Inheritance should not be introduced into the existing schema simply by relaxing every
exact-type check. The abstract layer and schema layer need separate validation policies.

## Findings that the owner plan must address

### Representation stages are bundled

`HigherRankD1SampledFields` stores parent operators, frames, gauges, reference operators,
and attacked operators together. The defining transformations are represented mainly by
array equalities. The replacement should retain explicit source/target identities and
transformation edges.

### Legacy error semantics are unsuitable as a base

Paper A/B's `ErrorChannels.maximum_hamiltonian` is rank-normalized Frobenius error and is
not a general eigenvalue perturbation bound. The common abstraction must retain that
quantity only under an explicit descriptive name and add rank-unnormalized Frobenius or
operator-norm certificate channels.

### Legacy first-pass semantics are incomplete

The existing `FirstPassingDecision` retains the passing cutoff and immediate predecessor.
That is insufficient without monotonicity. A new result must retain every earlier declared
cutoff or a separately proved monotonicity certificate.

### Exact-type checks block abstract substitution

Exact concrete-type validation is useful at a frozen schema boundary but prevents common
ABC implementations from being substituted. The owner plan must separate internal
interfaces from serialized leaf types.

### Numerical qualification is not formal proof

Class names must not cause tolerance-qualified arrays to be mistaken for exact Hermitian,
unitary, periodic, or isometric objects. Data, evidence mode, and formal certificate
status must remain separate.

### Generic diagnostics remain duplicated

Paper C already introduces reusable matrix-field diagnostics, while paper-specific
residual, Fourier, support, and Pareto records still duplicate generic mathematics. The
plan should select one shared layer and make paper packages thin adapters.

## Proposed migration sequence

### Phase 0: owner design decision

Before implementation, the owner should approve:

- package ownership and dependency direction;
- the list of abstract interfaces;
- identity and evidence semantics;
- whether the initial migration targets Paper C or Paper A/B;
- schema-versioning policy; and
- explicit non-goals.

Recommended choice: introduce a semantic `analysis.operator_representation` layer above
`analysis.matrix_field`, then adapt Paper C first because it already uses the newer
generic diagnostics.

### Phase 1: neutral interfaces and identities

Add domains, spaces, field interfaces, representation identities, and NumPy-backed leaf
adapters without changing numerical results or serialized schemas.

### Phase 2: transformation graph

Add explicit compression, gauge, alignment, Fourier, truncation, and reconstruction
records. Demonstrate the graph on one Paper C D1 case while retaining the existing
calculator as the numerical oracle.

### Phase 3: shared evidence and diagnostics

Move or adapt generic structure, error, Fourier, support, and refinement diagnostics to
the common layer. Preserve numerical and exact/interval evidence modes.

### Phase 4: Paper C migration

Express A0--A3 through common alignment strategies and build case results from shared
representations and transformations. Require result equivalence against the frozen
legacy calculation before replacing any schema.

### Phase 5: Paper A/B adapters and schema proposal

Adapt the rank-two family, metric-shell supports, strain paths, finite objective points,
and Pareto decisions. Propose a new schema identity for corrected error and first-pass
semantics. Do not silently reinterpret existing fields.

### Phase 6: certificate export boundary

Only after the computational schema is frozen, define an optional evidence export that
binds source identity, mesh, support, weights, alignment, objectives, intervals, and
witness identity to the verification-side contract. Lean remains outside the owner
runtime dependency graph.

## Minimum owner-side tests

The implementation plan should require tests for:

1. domain, space, basis, and representation identity mismatches;
2. prohibition of comparison before an alignment or common-basis map is supplied;
3. frame compression and gauge-conjugation orientation;
4. qualified, rank-deficient, unresolved, and not-applicable alignment outcomes;
5. support primary-class exclusivity and negation-closure evidence;
6. separate block-count, radius, and shell-index costs;
7. complete Fourier reconstruction and truncation decomposition;
8. the normalized-Frobenius perturbation counterexample
   \(A=\operatorname{diag}(1,0), B=0\);
9. nonmonotone pass sequences requiring all earlier cutoffs to be audited;
10. separate channel passes that do not share one joint witness;
11. interval-overlapping comparisons returning unresolved;
12. finite Pareto masks containing only attained objective vectors;
13. legacy-to-new adapter equivalence where semantics are unchanged;
14. rejection of semantic changes under an old schema identity; and
15. a verifier path that reconstructs identities and objectives independently of the
    producer's aggregate result.

## Proposed approval checkpoint

The owner-side planning session should present the operator with:

1. the selected package and dependency diagram;
2. the exact abstract-base and leaf-class inventory;
3. the Paper A--C migration crosswalk;
4. schema compatibility and migration consequences;
5. implementation phases with bounded file sets;
6. validation and regression strategy;
7. unresolved design choices;
8. explicit exclusions, including no runtime Lean dependency; and
9. the first proposed implementation checkpoint.

Approval of that plan would authorize only the stated owner-side implementation scope. It
would not approve scientific claims, runtime evidence, formal theorem applicability,
publication, release, commit, push, or merge unless those actions are separately named.
