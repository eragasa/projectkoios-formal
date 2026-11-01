<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-20
-->

# Ragasa2026A diagnostic names and Python interface recommendation

## Status and source boundary

This document recommends owner-side names and immutable Python record signatures for the
Paper A diagnostic system. It is a design recommendation, not an implementation patch,
accepted owner schema, retained artifact, or authorization to change `ksdft2effmass`.

The compatibility baseline is the immutable owner repository revision
`99a46cb59d0c6f27ada7d709f194996ef9619d9f`, especially
`band_equivalence_locality/records.py`, `refinement_records.py`, `calculation.py`, and
`fourier.py`. The inspected checkout was dirty, so only immutable `git show` objects were
used as evidence.

The exact proposed formulas are in
[`diagnostic-mathematical-specification.md`](diagnostic-mathematical-specification.md).
The interfaces below follow the owner's existing `@dataclass(frozen=True, slots=True)` and
`StrEnum` conventions. They deliberately avoid making Lean a runtime dependency.

## Naming rules

A canonical diagnostic name should identify, as applicable:

1. the mathematical object;
2. its comparator or reference;
3. the norm and normalization;
4. the aggregation, such as maximum or RMS;
5. whether it is signed, derived, or conditional; and
6. the stage, support, or finite inventory over which it is evaluated.

Do not use:

- `excess` or `inflation` unless positivity is established;
- `Weyl bound` unless the norm, coefficient, and hypotheses are valid;
- `first` unless every earlier declared cutoff was checked;
- `joint` unless the same representation and support pass every channel;
- `prevalence` without a frozen finite population and a-priori weights;
- `independent` when verifier control flow calls the producer; or
- `exact` for floating-point output or incomplete finite coverage.

## Canonical diagnostic names

The stable `A-DIAG-*` identifiers may remain unchanged. The right column gives the
recommended owner-side field or object name.

| ID | Recommended display name | Recommended Python name |
|---|---|---|
| A-DIAG-P01 | minimum retained-cluster external isolation gap | `minimum_retained_cluster_external_isolation_gap` |
| A-DIAG-P02 | minimum link-overlap singular value | `minimum_link_overlap_singular_value` |
| A-DIAG-P03 | maximum frame-orthonormality defect | `maximum_frame_orthonormality_defect` |
| A-DIAG-P04 | maximum retained-subspace invariance residual over reference energy | `maximum_retained_subspace_invariance_residual_over_energy_reference` |
| A-DIAG-P05 | maximum retained-projector reconstruction defect | `maximum_retained_projector_reconstruction_defect` |
| A-DIAG-P06 | pre-closure cycle holonomy | `preclosure_cycle_holonomies` |
| A-DIAG-P07 | maximum post-closure sewing residual | `maximum_postclosure_sewing_residual` |
| A-DIAG-P08 | stage-resolved Hermiticity defects | `hermiticity_defects_by_stage` |
| A-DIAG-A01 | restricted-correlation harmonic coefficients | `restricted_correlation_harmonic` |
| A-DIAG-A02 | canonical maximizing global-`SO(2)` angle | `canonical_maximizing_global_so2_angle` |
| A-DIAG-A03 | maximum normalized restricted-alignment correlation | `maximum_normalized_restricted_alignment_correlation` |
| A-DIAG-A04 | minimum restricted-alignment Frobenius residual | `minimum_restricted_alignment_frobenius_residual` |
| A-DIAG-A05 | restricted-alignment squared-residual floor | `restricted_alignment_squared_residual_floor` |
| A-DIAG-A06 | aligned onsite-block Frobenius residual | `aligned_onsite_block_frobenius_residual` |
| A-DIAG-A07 | comparison-minus-reference non-onsite power | `comparison_minus_reference_nononsite_power` |
| A-DIAG-A08 | maximum frame-change covariance residual over reference energy | `maximum_frame_change_covariance_residual_over_energy_reference` |
| A-DIAG-A09 | non-onsite residual/cross decomposition | `nononsite_residual_decomposition` |
| A-DIAG-F01 | maximum conjugate-pairing defect over reference energy | `maximum_conjugate_pairing_defect_over_energy_reference` |
| A-DIAG-F02 | maximum complete-transform reconstruction defect over reference energy | `maximum_complete_transform_reconstruction_defect_over_energy_reference` |
| A-DIAG-F03 | Parseval power defect | `parseval_power_defect` |
| A-DIAG-F04 | cyclic Nyquist conversion power | `cyclic_nyquist_conversion_power` |
| A-DIAG-F05 | non-onsite coefficient Frobenius power | `nononsite_coefficient_frobenius_power` |
| A-DIAG-F06 | omitted coefficient Frobenius power | `omitted_coefficient_frobenius_power` |
| A-DIAG-F07 | retained block count (field 1) | `retained_block_count` |
| A-DIAG-F07 | maximum retained support radius (field 2) | `maximum_retained_support_radius` |
| A-DIAG-F08 | complete-interpolant versus direct matrix error | `complete_interpolant_vs_direct_matrix_error` |
| A-DIAG-F09 | truncated versus complete-interpolant matrix error | `truncated_vs_complete_interpolant_matrix_error` |
| A-DIAG-F10 | truncated versus direct matrix error | `truncated_vs_direct_matrix_error` |
| A-DIAG-S01 | complete-field sorted-band discrepancy | `complete_field_sorted_band_discrepancy` |
| A-DIAG-S02 | truncated-versus-direct sorted-band error | `truncated_vs_direct_sorted_band_error` |
| A-DIAG-S03 | maximum rank-unnormalized Frobenius band-error bound | `maximum_rank_unnormalized_frobenius_band_error_bound` |
| A-DIAG-S04 | band-error-to-Frobenius-bound ratio | `band_error_to_frobenius_bound_ratio` |
| A-DIAG-S05 | first matrix-threshold-passing cutoff | `first_matrix_threshold_passing_cutoff` |
| A-DIAG-S06 | first spectral-threshold-passing cutoff | `first_spectral_threshold_passing_cutoff` |
| A-DIAG-S07 | signed comparison-minus-reference cutoff difference | `comparison_minus_reference_cutoff_difference` |
| A-DIAG-S08 | first jointly passing cutoff | `first_jointly_passing_cutoff` |
| A-DIAG-S09 | weighted sampled fraction with positive cutoff difference | `weighted_sampled_fraction_positive_cutoff_difference` |
| A-DIAG-S10 | matrix-versus-spectral cutoff comparison | `matrix_vs_spectral_cutoff_comparison` |
| A-DIAG-R01 | nested-momentum-refinement change | `momentum_refinement_change` |
| A-DIAG-R02 | signed threshold margin | `signed_threshold_margin` |
| A-DIAG-R03 | exhaustive first-pass audit | `exhaustive_first_pass_audit` |
| A-DIAG-R04 | finite-grid parameter sensitivity | `finite_grid_parameter_sensitivity` |
| A-DIAG-R05 | minimum construction/evaluation torus separation | `minimum_construction_evaluation_torus_separation` |
| A-DIAG-R06 | independent-reconstruction discrepancy | `independent_reconstruction_discrepancy` |
| A-DIAG-R07 | separate evidence-integrity gates | `evidence_integrity` |
| A-DIAG-R08 | execution-provenance identity | `execution_provenance` |
| A-DIAG-R09 | held-out amplitude-interpolant error | `heldout_amplitude_interpolant_error` |

The two `A-DIAG-F07` rows are separate fields under the existing planning identifier, not new IDs.
The split prevents block count from being confused with physical or lattice radius.

## Recommended common value objects

The following are signature proposals. Constructor validation is mandatory but omitted
from the bodies for readability.

```python
from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum


class DiagnosticDisposition(StrEnum):
    RESOLVED = "resolved"
    UNRESOLVED = "unresolved"
    NOT_APPLICABLE = "not-applicable"


class PassDisposition(StrEnum):
    PASS = "pass"
    FAIL = "fail"
    UNRESOLVED = "unresolved"
    NOT_APPLICABLE = "not-applicable"


class RepresentationKind(StrEnum):
    REFERENCE = "reference"
    COMPARISON = "comparison"


class DecisionChannel(StrEnum):
    MATRIX = "matrix"
    SPECTRAL = "spectral"
    JOINT = "joint"


class FirstPassDecisionDisposition(StrEnum):
    RESOLVED = "resolved"
    CAP_EXHAUSTED = "cap-exhausted"
    UNRESOLVED = "unresolved"
    NOT_APPLICABLE = "not-applicable"


class EvaluationWeightMode(StrEnum):
    UNIFORM_COUNTING = "uniform-counting"
    GEOMETRIC_CELL = "geometric-cell"
    MOMENT_QUADRATURE = "moment-quadrature"
    OPTIMIZED_QUADRATURE = "optimized-quadrature"


class SupportSemanticClass(StrEnum):
    ARBITRARY_FINITE = "arbitrary-finite"
    NEGATION_CLOSED = "negation-closed"
    COMPLETE_METRIC_SHELL = "complete-metric-shell"
    SOURCE_HOPPING_RANGE = "source-hopping-range"


class FieldStage(StrEnum):
    PARENT = "parent"
    RETAINED_REFERENCE = "retained-reference"
    ALIGNED_COMPARISON = "aligned-comparison"
    COMPLETE_INTERPOLANT = "complete-interpolant"
    TRUNCATED_RECONSTRUCTION = "truncated-reconstruction"


class EvidenceGateDisposition(StrEnum):
    PASS = "pass"
    FAIL = "fail"
    UNRESOLVED = "unresolved"


@dataclass(frozen=True, slots=True)
class FloatInterval:
    lower: float
    upper: float


@dataclass(frozen=True, slots=True)
class ScalarDiagnostic:
    estimate: float | None
    enclosure: FloatInterval | None
    disposition: DiagnosticDisposition
    reason_code: str | None


@dataclass(frozen=True, slots=True)
class WeightRuleIdentity:
    mode: EvaluationWeightMode
    derivation_id: str
    normalized_weight_digest: str
```

Required invariants include:

- every present float is a finite built-in `float`;
- `lower <= upper`, and a present estimate lies inside its enclosure;
- `not-applicable` has no fabricated numerical value;
- an interval overlapping a decision threshold is `unresolved`, not a pass;
- nonnegative quantities reject negative values; and
- signed quantities such as A07, A09 cross terms, S07, and R02 permit either sign.

## Premise and state-space objects

```python
@dataclass(frozen=True, slots=True)
class CycleHolonomyDiagnostic:
    cycle_id: str
    ordered_link_ids: tuple[str, ...]
    eigenphases_radians: tuple[float, ...] | None
    unitarity_defect: ScalarDiagnostic
    disposition: DiagnosticDisposition
    reason_code: str | None


@dataclass(frozen=True, slots=True)
class StageHermiticityDefect:
    stage: FieldStage
    maximum_frobenius_defect_over_energy_reference: float


@dataclass(frozen=True, slots=True)
class PremiseDiagnostics:
    # A-DIAG-P01--P08
    minimum_retained_cluster_external_isolation_gap: ScalarDiagnostic
    minimum_link_overlap_singular_value: ScalarDiagnostic
    maximum_frame_orthonormality_defect: ScalarDiagnostic
    maximum_retained_subspace_invariance_residual_over_energy_reference: ScalarDiagnostic
    maximum_retained_projector_reconstruction_defect: ScalarDiagnostic
    preclosure_cycle_holonomies: tuple[CycleHolonomyDiagnostic, ...]
    maximum_postclosure_sewing_residual: ScalarDiagnostic
    hermiticity_defects_by_stage: tuple[StageHermiticityDefect, ...]
```

The producer must validate exact stage and cycle coverage. P06 remains a sewing diagnostic;
its class name intentionally omits `topological`.

## Alignment objects

```python
@dataclass(frozen=True, slots=True)
class RestrictedCorrelationHarmonic:
    b0: float
    cosine_coefficient: float
    sine_coefficient: float
    coefficient_enclosures: tuple[FloatInterval, FloatInterval, FloatInterval] | None


@dataclass(frozen=True, slots=True)
class CanonicalGlobalSO2Alignment:
    angle_radians: float | None
    degenerate: bool
    disposition: DiagnosticDisposition
    reason_code: str | None


@dataclass(frozen=True, slots=True)
class WeightedFrobeniusResidual:
    squared_residual: float
    residual: float
    energy_reference: float
    weight_rule: WeightRuleIdentity


@dataclass(frozen=True, slots=True)
class AlignedOnsiteBlockResidual:
    frobenius_residual_per_retained_state_and_energy: float
    scalar_shift: float
    nonnegative_scale: float
    alignment_angle_radians: float


@dataclass(frozen=True, slots=True)
class NononsiteResidualDecomposition:
    residual_power: float
    signed_reference_residual_cross_term: float
    signed_comparison_minus_reference_power: float
    decomposition_closure_defect: float


@dataclass(frozen=True, slots=True)
class AlignmentDiagnostics:
    # A-DIAG-A01--A09
    restricted_correlation_harmonic: RestrictedCorrelationHarmonic
    canonical_global_so2_alignment: CanonicalGlobalSO2Alignment
    maximum_normalized_restricted_alignment_correlation: ScalarDiagnostic
    minimum_restricted_alignment_frobenius_residual: WeightedFrobeniusResidual
    aligned_onsite_block_frobenius_residual: AlignedOnsiteBlockResidual
    comparison_minus_reference_nononsite_power: float
    maximum_frame_change_covariance_residual_over_energy_reference: ScalarDiagnostic
    nononsite_residual_decomposition: NononsiteResidualDecomposition
```

A05 should normally be derived from the primary power/correlation fields rather than
serialized as independent evidence:

```python
def restricted_alignment_squared_residual_floor(
    *, splitting_power: float, maximum_normalized_correlation: float
) -> float: ...
```

This exact formula requires the reviewed hypotheses, including positive splitting power,
`0 <= maximum_normalized_correlation <= 1`, and the declared scale domain. If negative
correlations are admitted with a nonnegative scale, the constrained optimum must be
specified separately rather than silently applying `kappa * (1 - mu**2)`.

## Matrix, spectral, Fourier, and support objects

The current `ErrorChannels.maximum_hamiltonian` name hides both the norm and its
`1 / sqrt(2)` normalization. Replace it with explicit channels rather than silently
changing its meaning.

```python
@dataclass(frozen=True, slots=True)
class MatrixErrorSummary:
    # Valid general Frobenius/Weyl upper-bound channel.
    maximum_rank_unnormalized_frobenius_over_energy_reference: float
    rms_rank_unnormalized_frobenius_over_energy_reference: float

    # Descriptive paper-loss normalization; not a general Weyl bound.
    maximum_rank_normalized_frobenius_over_energy_reference: float
    rms_rank_normalized_frobenius_over_energy_reference: float

    # Optional tighter channel when explicitly computed.
    maximum_operator_norm_over_energy_reference: float | None


@dataclass(frozen=True, slots=True)
class SortedBandErrorSummary:
    maximum_over_energy_reference: float
    rms_over_energy_reference: float


@dataclass(frozen=True, slots=True)
class ErrorChannelsVNext:
    matrix: MatrixErrorSummary
    sorted_bands: SortedBandErrorSummary


@dataclass(frozen=True, slots=True)
class ParsevalPowerDefect:
    absolute_defect: float
    relative_defect: float | None


@dataclass(frozen=True, slots=True)
class FourierFieldDiagnostics:
    # A-DIAG-F01--F05 and F08 for one named field.
    representation: RepresentationKind
    maximum_conjugate_pairing_defect_over_energy_reference: float
    maximum_complete_transform_reconstruction_defect_over_energy_reference: float
    parseval_power_defect: ParsevalPowerDefect
    cyclic_nyquist_conversion_power: ScalarDiagnostic
    nononsite_coefficient_frobenius_power: float
    complete_interpolant_vs_direct_matrix_error: ErrorChannelsVNext


@dataclass(frozen=True, slots=True)
class SupportCost:
    support_id: str
    order_index: int
    shell_index: int | None
    retained_block_count: int
    maximum_retained_support_radius: float
    support_semantic_class: SupportSemanticClass


@dataclass(frozen=True, slots=True)
class CutoffDiagnosticsVNext:
    # A-DIAG-F06, F07, F09, F10, and S02/S03 at one support.
    support: SupportCost
    representation: RepresentationKind
    omitted_coefficient_frobenius_power: float
    truncated_vs_complete_interpolant_matrix_error: ErrorChannelsVNext
    truncated_vs_direct_matrix_error: ErrorChannelsVNext
```

The support semantic class should reuse the owner implementation of the frozen contract
values `arbitrary-finite`, `negation-closed`, `complete-metric-shell`, or
`source-hopping-range`; it should not be an unchecked free-form value in production.

For the corrected S03 channel, the schema-visible equality should be

```python
maximum_rank_unnormalized_frobenius_band_error_bound = (
    truncated_vs_direct_matrix_error
    .matrix.maximum_rank_unnormalized_frobenius_over_energy_reference
)
```

The rank-normalized field remains separately named. If a specialized traceless-residual
bound is later used, the producer must retain a pointwise tracelessness premise diagnostic
and bind the specialized theorem rather than reuse the general field name.

## Finite cutoff and joint-decision objects

```python
@dataclass(frozen=True, slots=True)
class CutoffPassEvidence:
    support_id: str
    order_index: int
    disposition: PassDisposition
    signed_margin: FloatInterval


@dataclass(frozen=True, slots=True)
class FirstPassAudit:
    # A-DIAG-S05, S06, or S08 together with R03.
    representation: RepresentationKind
    channel: DecisionChannel
    decision_disposition: FirstPassDecisionDisposition
    selected_support_id: str | None
    selected_order_index: int | None
    selected_pass_disposition: PassDisposition | None
    earlier_cutoffs: tuple[CutoffPassEvidence, ...]
    expected_earlier_cutoff_count: int
    exhaustive_first_pass_audit: EvidenceGateDisposition
    reason_code: str | None


@dataclass(frozen=True, slots=True)
class ThresholdDecisionDiagnostics:
    threshold_id: str
    matrix_tolerance: float
    spectral_tolerance: float
    first_matrix_threshold_passing_cutoff: FirstPassAudit
    first_spectral_threshold_passing_cutoff: FirstPassAudit
    first_jointly_passing_cutoff: FirstPassAudit
```

For a resolved first pass, validators must require:

- decision disposition `resolved` and selected pass disposition `pass`;
- exact equality between expected and observed earlier-cutoff counts;
- unique, complete earlier order indices;
- every earlier disposition `fail`; and
- for the joint channel, one selected support whose matrix and spectral margins both pass.

`cap-exhausted` is a resolved finite-inventory outcome with no selected support; it is not
an infinite cutoff and not permission to claim continuum infeasibility. An invalid or
interval-ambiguous selection remains `unresolved`.

S04, S07, and S10 should be derived views:

```python
def band_error_to_frobenius_bound_ratio(
    *, maximum_sorted_band_error: float, frobenius_bound: float
) -> ScalarDiagnostic: ...


def comparison_minus_reference_cutoff_difference(
    *, comparison_order_index: int, reference_order_index: int
) -> int: ...


def matrix_vs_spectral_cutoff_comparison(
    *, matrix_order_index: int, spectral_order_index: int
) -> int: ...  # zero means equality; sign is retained


@dataclass(frozen=True, slots=True)
class WeightedSampledCutoffDifferenceFraction:
    # A-DIAG-S09; conditional on one frozen finite case inventory.
    case_inventory_id: str
    weight_rule: WeightRuleIdentity
    positive_difference_weight: float
    total_weight: float
    weighted_sampled_fraction_positive_cutoff_difference: float
    disposition: DiagnosticDisposition
    reason_code: str | None
```

The phrase `cutoff inflation` may be generated only when the signed difference is proved
positive for the declared case.

## Stability and conditional-method objects

```python
@dataclass(frozen=True, slots=True)
class MomentumRefinementChange:
    coarse_mesh_id: str
    fine_mesh_id: str
    maximum_objective_change: float
    minimum_signed_margin: FloatInterval
    decision_changed: bool | None
    disposition: DiagnosticDisposition
    reason_code: str | None


@dataclass(frozen=True, slots=True)
class FiniteGridParameterSensitivity:
    parameter_inventory_id: str
    diagnostic_id: str
    minimum_value: float
    maximum_value: float
    decision_change_mask: tuple[bool, ...]


@dataclass(frozen=True, slots=True)
class EvaluationSeparationDiagnostic:
    construction_mesh_id: str
    evaluation_mesh_id: str
    minimum_torus_separation: float


@dataclass(frozen=True, slots=True)
class IndependentReconstructionDiscrepancy:
    verifier_id: str
    verified_cutoff_ids: tuple[str, ...]
    maximum_matrix_discrepancy: float
    maximum_spectral_discrepancy: float
    disposition: DiagnosticDisposition
    reason_code: str | None


@dataclass(frozen=True, slots=True)
class HeldoutAmplitudeInterpolantError:
    interpolant_id: str | None
    validation_inventory_id: str | None
    maximum_target_error: ScalarDiagnostic
    minimum_decision_margin: ScalarDiagnostic
```

R09 is `not-applicable` when no amplitude interpolant is admitted. R04 concerns only the
frozen finite parameter inventory and must not be labeled continuum robustness.

## Evidence-integrity and provenance objects

```python
class EvidenceGateKind(StrEnum):
    SCHEMA = "schema"
    COVERAGE = "coverage"
    DIGEST = "digest"
    SOURCE_IDENTITY = "source-identity"
    WITNESS_IDENTITY = "witness-identity"


@dataclass(frozen=True, slots=True)
class EvidenceGate:
    kind: EvidenceGateKind
    disposition: EvidenceGateDisposition
    reason_code: str | None
    expected_identity: str | None
    observed_identity: str | None


@dataclass(frozen=True, slots=True)
class EvidenceIntegrity:
    schema: EvidenceGate
    coverage: EvidenceGate
    digest: EvidenceGate
    source_identity: EvidenceGate
    witness_identity: EvidenceGate

    @property
    def accepts(self) -> bool: ...  # true exactly when every required gate passes


@dataclass(frozen=True, slots=True)
class ExecutionProvenance:
    source_repository: str
    source_commit: str
    source_worktree_clean: bool
    dependency_lock_digest: str
    executable_digest: str
    schema_id: str
    method_id: str
    platform_id: str
    python_implementation: str
    python_version: str
    numerical_backend_id: str
    environment_digest: str
```

An unknown or unresolved gate is non-accepting. Record-count equality is not coverage;
coverage compares the exact expected and observed identity sets.

## Recommended aggregate records

```python
@dataclass(frozen=True, slots=True)
class PointDiagnosticsVNext:
    case_id: str
    parent_scale: float
    amplitude: float
    premises: PremiseDiagnostics
    alignment: AlignmentDiagnostics
    complete_field_sorted_band_discrepancy: SortedBandErrorSummary
    fourier_fields: tuple[FourierFieldDiagnostics, ...]
    cutoff_diagnostics: tuple[CutoffDiagnosticsVNext, ...]
    threshold_decisions: tuple[ThresholdDecisionDiagnostics, ...]
    heldout_amplitude_interpolant_error: HeldoutAmplitudeInterpolantError


@dataclass(frozen=True, slots=True)
class CaseDiagnosticsVNext:
    case_id: str
    minimum_construction_evaluation_torus_separation: EvaluationSeparationDiagnostic
    points: tuple[PointDiagnosticsVNext, ...]
    momentum_refinements: tuple[MomentumRefinementChange, ...]
    finite_grid_sensitivities: tuple[FiniteGridParameterSensitivity, ...]
    sampled_cutoff_difference_fractions: tuple[
        WeightedSampledCutoffDifferenceFraction, ...
    ]


@dataclass(frozen=True, slots=True)
class BandEquivalenceLocalityDiagnosticsVNext:
    schema_id: str
    family_id: str
    construction_mesh_id: str
    evaluation_mesh_id: str
    weight_rule: WeightRuleIdentity
    energy_reference: float
    cases: tuple[CaseDiagnosticsVNext, ...]
    independent_reconstruction: IndependentReconstructionDiscrepancy
    evidence_integrity: EvidenceIntegrity
    execution_provenance: ExecutionProvenance
```

The production schema identifier must be owner-approved. It should not reuse the current
schema identity because several field meanings and object shapes change.

## Migration from the audited record classes

| Audited field or object | Recommended migration |
|---|---|
| `ErrorChannels.maximum_hamiltonian` and `rms_hamiltonian` | Preserve only as explicitly named legacy rank-normalized fields; add unnormalized Frobenius fields and optional operator-norm field. |
| `FirstPassingDecision.*_preceding_error` | Replace with `FirstPassAudit.earlier_cutoffs` covering every earlier declared support. |
| `maximum_parent_hermiticity_defect` plus later Hermiticity fields | Move to `StageHermiticityDefect` records with exact stage coverage. |
| `excess_nonzero_hopping_weight` | Rename to signed `comparison_minus_reference_nononsite_power`. |
| `normalized_excess_nonzero_hopping_weight` | Remove or give an explicit signed numerator/denominator name and zero-denominator disposition. |
| `flat_identity_departure` | Replace by `NononsiteResidualDecomposition`; retain residual power, signed cross term, and closure defect separately. |
| `retained_blocks` | Pair with `maximum_retained_support_radius`; never use one as an alias for the other. |
| `maximum_covariant_defect` | Rename and bind to the exact frame-change convention and stages. |
| `BandEquivalenceLocalityVerificationDiagnostics.passes` | Derive from separate fail-closed evidence gates; do not let one Boolean hide a missing coverage or identity check. |
| hash-free refinement records | Add `ExecutionProvenance` and immutable mesh, support, method, and artifact identities before treating output as evidence. |

## Minimum owner-side tests

The owner implementation should include at least:

1. the counterexample `A = diag(1,0)`, `B = 0`, demonstrating that the legacy
   rank-normalized Frobenius value is not a general band-error upper bound;
2. a traceless-residual case if the specialized `1 / sqrt(2)` theorem is ever claimed;
3. a nonmonotone pass sequence such as `fail, pass, fail, pass`, proving that first-pass
   selection checks all earlier cutoffs rather than assuming persistence;
4. separate matrix and spectral passes at different supports, proving they do not create a
   joint witness;
5. interval overlap with a threshold, producing `unresolved`;
6. `not-applicable` Nyquist and interpolation records that cannot serialize as zero;
7. negative signed A07/A09/S07 values that remain valid records;
8. duplicate or missing support identities rejected by coverage validation; and
9. an independent reconstruction test that does not call producer control flow.

## Authority boundary

`ksdft2effmass` should own these runtime objects, validation, serialization, tests, and
retained numerical artifacts. `projectkoios-formal` should own reusable theorem semantics
and exact certificate checking. Citing a Lean theorem does not establish that a runtime
record satisfies its premises; an explicit immutable evidence bridge is still required.
