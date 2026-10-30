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
