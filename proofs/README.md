# Proof dossiers

This directory contains one human-readable LaTeX dossier per publication-facing Lean statement. Dossiers explain proofs; they do not replace Lean, the theorem manifest, source authority, or expert review.

## Purpose

A dossier makes one proof reviewable without changing its authority.

- Preserve the exact statement, assumptions, sources, readable argument, Lean realization, and audit result.
- Expose AI and automation use.
- Separate kernel checking from source fidelity, scientific interpretation, novelty, and publication status.
- Support later rechecking without claiming permanent software executability.

The maintainer operates and reviews this process as a computational materials scientist, not as an independent expert mathematician or theoretical physicist. AI-generated material remains untrusted until checked by Lean and reviewed against the stated sources and assumptions.

## File rule

Each dossier mirrors its Lean module path and uses one statement ID.

```text
ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean
proofs/BandGauge/Geometry/BG-THM-002-common-witness.tex
```

- Use one dossier for one publication-facing declaration.
- Do not create dossiers for planning IDs, searches, or unsourced generalizations.
- Keep helper-lemma documentation in Lean unless a separate source claim warrants a dossier.
- Update the existing dossier when only the proof changes.
- Create a new declaration and ID when the proposition changes.
- Treat `template.tex` as a template, not a claim.

The directory tree is the dossier index. `docs/theorem-manifest.md` is the status index.

## Selected finite gauge and operator tranche

The publication-facing tranche below records selected structural results rather than every helper
in the owning modules.

| Family | Dossier IDs | Exact scope |
|---|---|---|
| Aligned operator differences | `BG-BLOCH-THM-021--023` | subtraction, unitary pullback, and reference-minus-pulled-back-candidate self-adjointness |
| Fixed-unitary Fourier algebra | `BG-FOURIER-THM-035`, `043`, `046`, `047` | Frobenius inner-product invariance and equivariance of coefficient extraction, truncated reconstruction, and the truncation residual |
| Finite rank-one resolvent algebra | `QM-RESOLVENT-THM-005`, `008`, `010`, `013` | determinant factorization, Sherman--Morrison inversion, the scalar singularity criterion, and the conditional defect equation |
| Finite gauge and projector loops | `SS-GAUGE-THM-008`, `011`, `020`, `023` | Bargmann-product and Wilson-determinant invariance, projector--Bargmann equality, and projector-loop phase invariance |

These dossiers add no theorem and bind no runtime field, matrix, mesh, frame, support, root,
certificate, or scientific model. In particular, fixed-unitary Fourier equivariance does not cover
momentum-dependent gauges, the resolvent equation does not itself prove a nonzero eigenvector, and
finite loop-phase invariance does not establish continuum topology.

## Selected integer lattice radius bridge

The exact squared-index/radius bridge has a selected dossier for
[`BG-FOURIER-SUPPORT-THM-016-fcc-shell-radius-inclusion.tex`](BandGauge/Fourier/BG-FOURIER-SUPPORT-THM-016-fcc-shell-radius-inclusion.tex).
It records the normalized FCC Euclidean realization, exact radius-squared identity, inversion and
triangle laws, the elementwise `R_A + 2 R_U` gauge--field--gauge bound, and the resulting complete-shell inclusion. The parallel square,
triangular, and simple-cubic results and the carrier-independent helpers remain fully recorded in
Lean and the theorem manifest without separate dossiers.

These are infinite integer-lattice statements. They do not identify finite Fourier characters with
centered representatives across modular seams, authenticate a runtime mesh or FFT convention, or
assign physical hopping-range or scientific meaning.

## Selected aligned-operator norm and stability tranche

The source-neutral aligned-difference extension has selected dossiers for
`BG-BLOCH-THM-024`, `027`, `029`, `031`, and `032`. They cover unitary-pullback action-norm
and exact operator-norm preservation, the aligned-difference operator-norm budget, the exact
same-alignment subtraction identity, and the resulting operator-norm stability bound. The intermediate pointwise inequalities
and pullback-linearity theorem remain fully recorded in Lean and the theorem manifest without
separate dossiers.

Each selected statement uses a supplied exact alignment; the stability result uses one common
alignment for both pairs of fields. They do not authenticate an alignment, compare different
gauges, bind runtime operators or binary64 values, estimate spectra, prove continuum adequacy,
or create a certificate.

## Selected finite aligned-operator budget tranche

The concrete compatibility adapter has selected dossiers for `BG-DECISION-THM-039`, `044`,
`047`, and `050`. They cover the finite maximum operator-norm interpretation, same-alignment
loss stability, construction of a conformant operator witness from an exact concrete budget, and
the resulting witness-compatibility bridge. Intermediate maximum-field and headroom results remain
fully recorded in Lean and the theorem manifest without separate dossiers.

These statements use exact supplied fields, inventories, budgets, channel predicates, and an
alignment carrier with an explicit pointwise-unitary projection. They do not parse or authenticate
runtime data, prove an optimizer exists, compare different gauges, create a certificate, establish
external inventory coverage, or confer scientific or publication status.

## Selected precise-channel and finite alignment-attainment tranche

The precise-channel and finite-family layer has selected dossiers for `BG-DECISION-THM-051`,
`056`, and `060`. They cover exact minimizer existence on a nonempty finite alignment family,
the resulting conditional equivalence between central and witness compatibility, and the tagged
adapter that identifies generic mandatory-channel acceptance with all exact upper-bounded error
channels and all nonnumeric structural requirements. The intermediate branch equations, infimum,
concrete-budget, operator-witness, and one-way compatibility bridges remain fully recorded in Lean
and the theorem manifest without separate dossiers.

Finiteness supplies mathematical attainment only. Error budgets and structural requirements are
separate exact inputs, mandatory-channel conformance is an explicit independent premise, and no
theorem authenticates runtime enumeration, optimizer behavior, external inventory coverage,
binary64 values, or a certificate.

## Selected four-stage residual-channel tranche

The source-neutral four-stage extension has selected dossiers for `BG-HILBERT-THM-022`,
`BG-HILBERT-THM-025`, and `BG-DECISION-THM-063`. They cover the exact interpolation--conversion--
deliberate-truncation field decomposition, the corresponding finite root-mean-square triangle
bound, and exact four-channel finite-maximum budget acceptance. Pointwise and finite-maximum intermediate bounds, complete four-channel
inventory, and budget-relaxation monotonicity remain fully recorded in Lean and the theorem
manifest.

The component fields add exactly, but their scalar norm summaries generally satisfy inequalities
only. The narrow adapter's empty structural inventory proves no structural coverage, and the four
named residual channels need not exhaust any consuming study's broader error ledger. The dossiers
authenticate no runtime stage, value, inventory, enclosure, or certificate.

## Selected four-stage budget-synthesis tranche

The budget-synthesis extension has selected dossiers for `BG-DECISION-THM-067` and
`BG-DECISION-THM-072`. They cover the conditional redundancy of the total channel when the total
upper budget dominates the sum of the three component upper budgets, and the resulting exact
component-level expansion of witness compatibility for one common candidate and alignment.
Intermediate component-to-total, four-channel acceptance, alignment-channel, conformant-witness,
and operator-witness results remain fully recorded in Lean and the theorem manifest.

Total headroom is an explicit exact premise, not runtime evidence. The result does not assert
scalar-error additivity, supply structural requirements, establish external inventory coverage,
authenticate a runtime optimizer or numerical value, create a certificate, or confer scientific or
publication status.

## Selected mandatory-channel composition tranche

The channel-composition extension has selected dossiers for `BG-DECISION-THM-077` and
`BG-DECISION-THM-086`. They cover exact same-witness acceptance of two disjointly tagged precise
error/structural datasets and the resulting four-stage witness-compatibility expansion with every
consumer-supplied extra channel retained. Inventory equations, separate error and structural
acceptance, intermediate alignment-channel and conformant-witness bridges, and extended
component acceptance remain fully recorded in Lean and the theorem manifest.

Disjoint composition prevents identifier collision but proves no external taxonomy completeness.
The narrow four-stage structural inventory remains empty; only supplied extra data can add
structural obligations. No theorem authenticates runtime inventory construction, candidate or
alignment selection, numerical values, enclosures, certificates, scientific adequacy, or
publication status.

## Selected complex-unitary Procrustes tranche

The exact right-action Procrustes extension has selected dossiers for `BG-ALIGNMENT-THM-044`
and `BG-ALIGNMENT-THM-045`. They cover global minimality from a supplied exact polar witness and
uniqueness when its positive factor is positive definite. Frobenius/trace identities, unitary entry
and column bounds, diagonal and positive-semidefinite trace inequalities, objective expansion, and
score lemmas remain fully recorded in Lean and the theorem manifest without separate dossiers.

The objective is explicitly `‖candidate * gauge - reference‖_F²`, with a right-acting complex
unitary and cross matrix `candidateᴴ * reference`. The witness proves mathematical optimality but
authenticates no runtime frame, orthonormality check, NumPy SVD, floating rank, tolerance, optimizer
branch, null-space completion, serialization, enclosure, or certificate. Positive-semidefinite
rank-deficient factors still prove minimality but do not imply uniqueness.

## Selected finite-mesh Procrustes tranche

The finite-mesh extension has selected dossiers for `BG-ALIGNMENT-THM-052` and
`BG-ALIGNMENT-THM-058`. They cover global minimization of the summed objective from one supplied
exact local polar witness per mesh point and equality of an explicit exact known-inverse control
with the unique pointwise polar field under positive definiteness at every point. The pointwise
minimum, summed uniqueness, constant/identity comparisons, zero-objective control, and exact
matrix-unitary embedding into identity/global/complete alignment families remain fully recorded in
Lean and the theorem manifest without separate dossiers.

The summed objective uses equal finite weights and imposes no cross-point regularity. The known
inverse is a conditional control, not universal ground truth. No theorem constructs a polar
witness, authenticates a runtime mesh, verifies SVD/rank/tolerance behavior, selects a
rank-deficient completion, binds external arrays, or checks a certificate.

## Finite gauge-identity tranche

The typed gauge-identity extension has dossiers for `BG-ALIGNMENT-THM-059` through
`BG-ALIGNMENT-THM-061`. They record type-derived represented dimension, identity-metric preservation
by an ordinary unitary, and the exact right-frame-action compression law. Group family, dimension,
action side, inner-product convention, sample domain, and global-versus-pointwise family remain
separate. The metric-isometry predicate does not claim a metric-aware adjoint, objective, optimizer,
or runtime binding. A left-action label does not silently define a conformable operation on the
current column-frame carrier. `BG-ALIGNMENT-THM-062` through `BG-ALIGNMENT-THM-067` add the
identity and multiplication laws for a fixed metric plus identity, composition,
conjugate-transpose, and Hermiticity laws for right conjugation; they are recorded in Lean and the
theorem manifest without separate dossiers.

## Selected exact finite-rank gauge-construction tranche

The source-neutral exact construction has selected dossiers for:

- [`BG-ALIGNMENT-THM-069-unitary-spectrum.tex`](BandGauge/Alignment/BG-ALIGNMENT-THM-069-unitary-spectrum.tex); and
- [`BG-ALIGNMENT-THM-071-exact-gauge-construction.tex`](BandGauge/Alignment/BG-ALIGNMENT-THM-071-exact-gauge-construction.tex).

They cover complex-spectrum preservation under `H'=GᴴDG` and the combined preservation/recovery
contract for `F'=F₀G`, `H'=GᴴDG`. The direct frame and represented-operator recovery identities are
fully recorded as `BG-ALIGNMENT-LEM-001/002` without separate dossiers.

The owner crosswalk is provisional because the inspected Periodic2D/3D rank-N model files were
untracked in a dirty KSD worktree. These theorems do not authenticate NumPy arrays, floating-point
unitarity or orthonormality, eigenvalue order, eigensolvers, Procrustes recovery, meshes, Fourier
transforms, artifacts, material applicability, or scientific adequacy.

## Selected complete metric-shell tranche

The source-neutral metric-shell extension has selected dossiers for `BG-FOURIER-THM-100` and
`BG-FOURIER-THM-105`. They cover the exact characterization of every finite shell change by an
attained radius and the capped no-skipped-shell consequence. Shell membership, nesting, equal-
radius ties, conditional inversion and symmetry closure, strict support/cardinality growth, and
the square, triangular, simple-cubic, and normalized FCC integer-index algebra remain fully
recorded in Lean and the theorem manifest without separate dossiers.

The results are conditional on one declared finite inventory, exact radius, and cutoff cap. They
do not authenticate an external or serialized inventory, admit a runtime symmetry group, identify
metric radius with physical hopping range, verify calculated block counts, or establish Fourier
or continuum convergence, material adequacy, scientific acceptance, or a certificate.

## Selected rank-two unitary-conjugation tranche

The exact rank-two conjugation extension has selected dossiers for `BG-FOUNDATION-THM-024` and
`BG-FOUNDATION-THM-025`. They cover equality of both canonical bands under one exact supplied
complex-unitary conjugation witness and the pointwise field-level corollary on a supplied finite
index type. Spectrum, trace, determinant, scalar-coordinate, Pauli-radius, and separate lower/upper-band
lemmas remain fully recorded in Lean and the theorem manifest without separate dossiers.

The generic spectrum step specializes pinned Mathlib unitary spectrum invariance. The supplied
unitary and post-conjugation coordinate equality are exact hypotheses. No theorem constructs or
authenticates a runtime gauge, floating orthonormality, eigensolver, band tracker, momentum mesh,
external artifact, certificate, Fourier support, truncation error, or scientific adequacy.

## Selected finite-rank analytic-parent tranche

The exact finite-rank analytic-parent extension has selected dossiers for:

- [`BG-FOUNDATION-THM-035-finite-rank-external-gap.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-035-finite-rank-external-gap.tex); and
- [`BG-FOUNDATION-THM-036-finite-rank-adjacent-gap.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-036-finite-rank-adjacent-gap.tex).

They cover the explicit nonempty finite-bond analytic parent's `19/10` external-gap lower bound and
its `7/(10(r-1))` adjacent retained-energy lower bound. Bond-harmonic, structure-factor,
orbital-coordinate, component-energy, and factorization results remain fully recorded in Lean and
the theorem manifest without separate dossiers.

The KSD source locator is provisional: the inspected Periodic2D/3D rank-N model and baseline files
were untracked in a dirty owner worktree. The results validate exact formulas only and do not bind
Python/NumPy execution, binary64 trigonometry, sampled minima, eigensolvers, meshes, alignment,
artifacts, material models, or scientific adequacy.

## Selected projection-support counterexample tranche

The source-specific two-band projection tranche has dossiers for
`BG-PROJECTION-THM-001` through `BG-PROJECTION-THM-008`:

- [`BG-PROJECTION-THM-001-parent-square.tex`](BandGauge/Projection/BG-PROJECTION-THM-001-parent-square.tex);
- [`BG-PROJECTION-THM-002-laurent-square-root-obstruction.tex`](BandGauge/Projection/BG-PROJECTION-THM-002-laurent-square-root-obstruction.tex);
- [`BG-PROJECTION-THM-003-unit-circle-injectivity.tex`](BandGauge/Projection/BG-PROJECTION-THM-003-unit-circle-injectivity.tex);
- [`BG-PROJECTION-THM-004-dispersion-not-finite-fourier.tex`](BandGauge/Projection/BG-PROJECTION-THM-004-dispersion-not-finite-fourier.tex);
- [`BG-PROJECTION-THM-005-projector-specification.tex`](BandGauge/Projection/BG-PROJECTION-THM-005-projector-specification.tex);
- [`BG-PROJECTION-THM-006-projector-sandwich.tex`](BandGauge/Projection/BG-PROJECTION-THM-006-projector-sandwich.tex);
- [`BG-PROJECTION-THM-007-projected-operator-not-finite-fourier.tex`](BandGauge/Projection/BG-PROJECTION-THM-007-projected-operator-not-finite-fourier.tex); and
- [`BG-PROJECTION-THM-008-spectral-projection-destroys-finite-support.tex`](BandGauge/Projection/BG-PROJECTION-THM-008-spectral-projection-destroys-finite-support.tex).

They cover the exact Laurent parent/radicand algebra, odd extreme-support obstruction,
injective unit-circle evaluation, positive-dispersion non-finiteness, algebraic lower-band
projector and sandwich identities, and the final matrix-valued finite-support contradiction.
The result is one exact counterexample under `Δt ≠ 0`; it is not a universal projection,
decay-rate, runtime-evidence, material, novelty, release, or publication claim.

## Selected normalized product-torus tranche

The source-neutral normalized product-torus extension has selected dossiers for
`BG-FOURIER-THM-124` and `BG-FOURIER-THM-125`. They cover factorization of the normalized average
of an exponential of coordinatewise additive phases and the equal-phase cardinality-power law.
The explicit total-mass-one normalization, pointwise exponential identity, arbitrary separable-
field factorization, and `Fin 2` square and `Fin 3` cube corollaries remain fully recorded in Lean
and the theorem manifest without separate dossiers.

The carrier is explicitly a finite product of Mathlib unit additive circles and the measure is the
product of their standard Haar probability measures. These factorization theorems alone do not
evaluate a one-circle integral as a Bessel function or bind an external convention.

## Selected zeroth-Bessel tranche

The attributed source-neutral Bessel extension has selected dossiers for `BG-SPECIAL-THM-014` and
`BG-FOURIER-THM-129`. They cover the full-angle exponential-cosine integral in terms of Mathlib's
`Complex.besselJ` and its normalized period-one positive sine-phase consequence. Intermediate
cosine-moment, summability, coefficient, arbitrary-product, 2-D square, and 3-D cube/scaling results
remain fully recorded in Lean and the theorem manifest without separate dossiers.

The dossiers preserve immutable provenance to the Apache-2.0 `LeanCondensedMatter` proof while
making clear that the external package is not a dependency. Neither theorem binds an external
half-open coordinate or runtime phase convention, authenticates quadrature or a runtime mesh,
proves finite-to-continuum convergence, or certifies a KSD analytic comparator, material model,
certificate, or scientific conclusion.

## Selected multidimensional gauge--locality separation tranche

The source-neutral binary product-mesh extension has selected dossiers for
`BG-FOURIER-THM-156` and `BG-FOURIER-THM-159`. They cover strictly positive omitted
matrix-Frobenius power after zero-mode truncation for the explicit `Fin 2 → ZMod 2` and
`Fin 3 → ZMod 2` witnesses. Exact Hermiticity, pointwise spectrum and ordered-band equality,
full Fourier reconstruction, truncation noncommutation, and the dimension-parametric versions
remain fully recorded in Lean and the theorem manifest without separate dossiers.

These theorems establish an exact finite representation-locality separation only. They do not
bind a runtime mesh, gauge, frame, eigensolver, coefficient array, physical hopping range,
finite-to-continuum limit, material model, certificate, or scientific conclusion.

## Selected finite Fourier least-squares tranche

The source-neutral finite-abelian extension has selected dossiers for
`BG-FOURIER-FINITE-THM-004` and `BG-FOURIER-FINITE-THM-005`. They cover the exact reconstruction-
error decomposition and the resulting least-squares minimality and equality characterization of
support truncation. The supporting coefficient-space Pythagorean identity remains fully recorded
in Lean and the theorem manifest without a separate dossier.

These theorems concern exact equal-weight finite sums on a complete character inventory. The
`BG-FOURIER-LATTICE-THM-001–005` application layer derives arbitrary-rank periodic 1-D/2-D/3-D
matrix least-squares statements from the same proof. The separate direct onsite/nononsite power
partition is recorded by `BG-FOURIER-FINITE-THM-006` and its lattice specializations
`BG-FOURIER-LATTICE-THM-006–009`. These declarations are recorded in Lean, the theorem manifest,
and the source crosswalk without separate theorem dossiers. They do not authenticate a runtime
design, quotient periods, reciprocal basis, gauge, NumPy solve, numerical rank, conditioning,
binary64 coefficient summation or route, threshold, artifact, or scientific conclusion.

## Required contents

A dossier records:

1. statement ID, status, module, and declaration;
2. exact mathematical statement;
3. immutable source identity and locator;
4. assumptions, conventions, and source-to-Lean delta;
5. statement-specific prior art and contribution boundary;
6. proof structure and readable proof or explicit gap;
7. Lean dependencies and realization summary;
8. trusted-base and `#print axioms` results;
9. AI, automation, toolchain, maintainer-context, and independent-review status;
10. numerical, certificate, and external-evidence boundaries;
11. unresolved questions; and
12. review history.

Headers record Eugene Joseph M. Ragasa as author, `Apache-2.0`, and the initial completion date. Exposition changes do not rewrite that date. Historical metadata requires an auditable backfill.

## Prior art

Use the relations defined in `docs/reference-crosswalk-policy.md`:

- `formalizes`
- `adapts`
- `depends-on`
- `compares-with`
- `background-only`

`projectkoios-references` owns canonical literature identity and bibliography metadata. Mark unresolved identity as unresolved; do not mint a local canonical identity or bibliography.

For witness/separation work, the metric facts, feasible-set language, witness/infeasibility distinction, and validated lower-bound methods carry no local priority claim. The stated contribution is their source-traceable integration into a threshold-defined joint spectral and restricted aligned-operator decision procedure. A bounded terminology search does not establish novelty or priority.

## Authority

Dossiers remain explanatory documents.

- Lean and `docs/theorem-manifest.md` determine formal proof status.
- Dossier compilation proves nothing.
- A proved proposition does not establish physical applicability, valid numerical evidence, novelty, complete citation coverage, or publication readiness.
- Current dossiers are drafts unless a separate release record states otherwise.

## Build

Compile outside the repository.

```console
out="$(mktemp -d /tmp/projectkoios-proof.XXXXXX)"
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir="$out" proofs/path/to/dossier.tex
rm -rf "$out"
```

Do not commit generated PDFs, logs, auxiliary files, or bibliography output.
