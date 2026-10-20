# Per-proof LaTeX dossiers

This tree contains one human-readable LaTeX dossier per publication-facing formal statement. It is not a monolithic claims document, a second Lean source tree, a bibliography registry, or independent proof authority.

## Maintainer perspective and purpose

I am not a research mathematician or theoretical physicist. My primary training and practice are in computational materials science, with some graduate mathematics training. I can work through a proof and reach a partial, practical understanding, but doing so may require hours of effort. I do not claim that this amounts to independent expert mathematical review. These dossiers are intended to make comprehension possible rather than conceal the work behind compressed formal code or unexplained automation.

The proofs pursued here are purpose-driven. They address exact mathematical questions that arise in the computational and scientific work I need to evaluate; they are not an attempt to develop a comprehensive theory or to claim novelty for standard mathematics. The long-term goal is durable recheckability: preserve an exact statement, its assumptions, its sources, a human-readable argument, and a kernel-checked Lean realization so that the result can be checked again rather than accepted from memory or authority. This is an aspiration to durable verification, not a literal guarantee that software, dependencies, or file formats will remain executable forever.

Substantial parts of proof discovery, draft arguments, explanatory prose, and Lean implementations are AI-generated or AI-assisted. AI output is untrusted assistance, not mathematical or scientific authority. My role is predominantly computational: I build and operate the process, select questions arising from the scientific work, preserve source and toolchain provenance, run Lean and the repository audits, read the resulting arguments as far as I am able, and add the computational and scientific context in which the statements matter. I do not claim to derive every proof independently or to provide expert mathematical validation.

In the age of AI, the problem I am trying to address is how to build machinery through which untrusted generated material becomes an exact, inspectable statement with a proof term checked against an explicit trusted base, while provenance, assumptions, and remaining uncertainty stay visible. This repository is my attempt to build that machinery and then comprehend what comes out of it. Otherwise, I would be operating software without understanding what it asserts or why; avoiding that outcome is why I went down this rabbit hole.

For each proof, the corresponding dossier must record the actual automation and toolchain provenance, the exact statement Lean checked, the axiom report, what I was able to read or contextualize, whether independent expert review occurred, and what remains uncertain. It must not relabel my operation of the process as expert human proof review. My practical understanding is valuable to me, but it does not replace kernel checking, source fidelity, attribution, or independent expert review.

Every new dossier header records Eugene Joseph M. Ragasa as author, the SPDX identifier
`Apache-2.0`, and the date on which the formal proof and dossier were first completed.
Changing exposition without changing the exact proposition does not rewrite that initial
completion date. Historical dossiers require a separate auditable metadata backfill rather
than an invented common completion date.

Attribution is a continuing best-effort obligation. I have attempted to credit the origins, precedents, and methods on which these proofs rely, while recognizing that searches can miss prior work and AI-generated attributions can be wrong. Candidate references must therefore remain visibly unresolved until checked through the repository's reference-authority process. Corrections and stronger primary sources should be recorded rather than hidden.

## Value for scientific papers

These dossiers are intended to support papers that make exact mathematical claims, especially claims that are central, reusable, or easy to misstate. A completed dossier can:

- give readers a machine-checkable result rather than asking them to trust AI-generated prose;
- expose the exact assumptions, conventions, and scope of the theorem;
- prevent a checked theorem from being confused with numerical evidence or a broader physical conclusion;
- provide a readable mathematical argument for readers who do not use Lean;
- disclose how AI and other automation contributed; and
- allow later papers to reuse an exact result rather than repeat an informal argument.

Lean proves the encoded proposition under its explicit dependencies. It does not establish that the proposition is the correct physical model, that its hypotheses hold for a material or computation, that numerical evidence is valid, that the result is novel, that the citations are complete, or that the scientific interpretation is sound. Those remain separate scientific, historical, and review obligations.

For the witness/separation work, the contribution is methodological rather than theorem novelty. The metric facts, feasible-set language, witness/infeasibility distinction, and validated lower-bound machinery are established ingredients. This project integrates them into a threshold-defined decision procedure for joint spectral and restricted aligned-operator adequacy with precise certificates and scope limitations. The classical facts carry no priority claim. A bounded terminology search establishes no priority.

For a publication-facing result, the preferred package is:

1. a concise statement in the paper that does not exceed the Lean theorem;
2. the exact Lean declaration and an immutable repository revision;
3. a corresponding per-proof LaTeX dossier as supplementary material;
4. the Lean version, Mathlib revision, build result, and axiom report;
5. an explicit boundary between formal proof, checked certificates, numerical evidence, and physical interpretation;
6. an AI-assistance disclosure consistent with the venue's policy; and
7. when separately authorized, an archived reviewed release with a persistent identifier.

Use this machinery for substantive publication claims, not every internal helper lemma. The current foundational theorems formalize generic decision logic. They do not instantiate the paper's loss functions or establish a scientific result.

Current draft dossiers:

- [`BG-THM-001-feasible-pair-upper-bound.tex`](BandGauge/Geometry/BG-THM-001-feasible-pair-upper-bound.tex);
- [`BG-THM-002-common-witness.tex`](BandGauge/Geometry/BG-THM-002-common-witness.tex);
- [`BG-THM-003-certified-separation.tex`](BandGauge/Geometry/BG-THM-003-certified-separation.tex); and
- [`BG-THM-004-compact-attainment-positive-distance.tex`](BandGauge/Geometry/BG-THM-004-compact-attainment-positive-distance.tex);
- [`BG-THM-005-nonempty-finiteness.tex`](BandGauge/Geometry/BG-THM-005-nonempty-finiteness.tex); and
- [`BG-THM-006-real-extended-bridge.tex`](BandGauge/Geometry/BG-THM-006-real-extended-bridge.tex);
- [`BG-THM-007-joint-loss-bounds-zero-distance.tex`](BandGauge/Geometry/BG-THM-007-joint-loss-bounds-zero-distance.tex); and
- [`BG-THM-008-certified-separation-excludes-joint-adequacy.tex`](BandGauge/Geometry/BG-THM-008-certified-separation-excludes-joint-adequacy.tex);
- [`BG-THM-009-irreducible-operator-floor.tex`](BandGauge/Geometry/BG-THM-009-irreducible-operator-floor.tex); and
- [`BG-THM-010-below-floor-operator-set-empty.tex`](BandGauge/Geometry/BG-THM-010-below-floor-operator-set-empty.tex);
- [`BG-THM-011-normalized-correlation-bound.tex`](BandGauge/Geometry/BG-THM-011-normalized-correlation-bound.tex);
- [`BG-THM-012-irreducible-floor-nonnegative.tex`](BandGauge/Geometry/BG-THM-012-irreducible-floor-nonnegative.tex); and
- [`BG-THM-013-operator-squared-loss-nonnegative.tex`](BandGauge/Geometry/BG-THM-013-operator-squared-loss-nonnegative.tex);
- [`BG-THM-014-spectral-squared-loss-nonnegative.tex`](BandGauge/Geometry/BG-THM-014-spectral-squared-loss-nonnegative.tex);
- [`BG-THM-015-spectral-square-root-recovery.tex`](BandGauge/Geometry/BG-THM-015-spectral-square-root-recovery.tex);
- [`BG-THM-016-operator-square-root-recovery.tex`](BandGauge/Geometry/BG-THM-016-operator-square-root-recovery.tex);
- [`BG-THM-017-spectral-threshold-equivalence.tex`](BandGauge/Geometry/BG-THM-017-spectral-threshold-equivalence.tex); and
- [`BG-THM-018-operator-threshold-equivalence.tex`](BandGauge/Geometry/BG-THM-018-operator-threshold-equivalence.tex);
- [`BG-THM-019-spectral-sublevel-ellipse.tex`](BandGauge/Geometry/BG-THM-019-spectral-sublevel-ellipse.tex);
- [`BG-THM-020-operator-radius-recovery.tex`](BandGauge/Geometry/BG-THM-020-operator-radius-recovery.tex); and
- [`BG-THM-021-operator-sublevel-ellipse.tex`](BandGauge/Geometry/BG-THM-021-operator-sublevel-ellipse.tex);
- [`BG-THM-022-common-point-compatibility-bound.tex`](BandGauge/Geometry/BG-THM-022-common-point-compatibility-bound.tex);
- [`BG-THM-023-strict-center-separation.tex`](BandGauge/Geometry/BG-THM-023-strict-center-separation.tex);
- [`BG-THM-024-compatibility-constructs-common-point.tex`](BandGauge/Geometry/BG-THM-024-compatibility-constructs-common-point.tex);
- [`BG-THM-025-full-ellipse-intersection-criterion.tex`](BandGauge/Geometry/BG-THM-025-full-ellipse-intersection-criterion.tex); and
- [`BG-THM-026-real-loss-intersection-criterion.tex`](BandGauge/Geometry/BG-THM-026-real-loss-intersection-criterion.tex);
- [`BG-THM-027-pairwise-distance-lower-bound.tex`](BandGauge/Geometry/BG-THM-027-pairwise-distance-lower-bound.tex);
- [`BG-THM-028-distance-attainment.tex`](BandGauge/Geometry/BG-THM-028-distance-attainment.tex);
- [`BG-THM-029-exact-full-ellipse-distance.tex`](BandGauge/Geometry/BG-THM-029-exact-full-ellipse-distance.tex); and
- [`BG-THM-030-exact-real-loss-distance.tex`](BandGauge/Geometry/BG-THM-030-exact-real-loss-distance.tex);
- [`BG-THM-031-spectral-rectangle-containment-transfer.tex`](BandGauge/Geometry/BG-THM-031-spectral-rectangle-containment-transfer.tex);
- [`BG-THM-032-operator-rectangle-containment-transfer.tex`](BandGauge/Geometry/BG-THM-032-operator-rectangle-containment-transfer.tex);
- [`BG-THM-033-rectangle-intersection-criterion.tex`](BandGauge/Geometry/BG-THM-033-rectangle-intersection-criterion.tex); and
- [`BG-THM-034-exact-rectangle-ellipse-distance.tex`](BandGauge/Geometry/BG-THM-034-exact-rectangle-ellipse-distance.tex);
- [`BG-FOUNDATION-THM-001-second-harmonic-upper-bound.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-001-second-harmonic-upper-bound.tex);
- [`BG-FOUNDATION-THM-002-second-harmonic-arg-attainment.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-002-second-harmonic-arg-attainment.tex);
- [`BG-FOUNDATION-THM-003-real-rotation-pauli-action.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-003-real-rotation-pauli-action.tex);
- [`BG-FOUNDATION-THM-004-pauli-frobenius-correlation.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-004-pauli-frobenius-correlation.tex);
- [`BG-FOUNDATION-THM-005-canonical-angle-range.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-005-canonical-angle-range.tex); and
- [`BG-FOUNDATION-THM-006-canonical-angle-attainment.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-006-canonical-angle-attainment.tex); and
- [`BG-FOUNDATION-THM-007-canonical-pauli-decomposition.tex`](BandGauge/Foundations/BG-FOUNDATION-THM-007-canonical-pauli-decomposition.tex);
- [`BG-BLOCH-THM-001-operator-preserves-sewing.tex`](BandGauge/Bloch/BG-BLOCH-THM-001-operator-preserves-sewing.tex); and
- [`BG-BLOCH-THM-002-alignment-preserves-covariance.tex`](BandGauge/Bloch/BG-BLOCH-THM-002-alignment-preserves-covariance.tex);
- [`BG-BLOCH-THM-003-trace-centering.tex`](BandGauge/Bloch/BG-BLOCH-THM-003-trace-centering.tex);
- [`BG-BLOCH-THM-004-sampled-field-traceless.tex`](BandGauge/Bloch/BG-BLOCH-THM-004-sampled-field-traceless.tex);
- [`BG-BLOCH-THM-005-unitary-conjugation-preserves-trace.tex`](BandGauge/Bloch/BG-BLOCH-THM-005-unitary-conjugation-preserves-trace.tex);
- [`BG-BLOCH-THM-006-sampled-unitary-power.tex`](BandGauge/Bloch/BG-BLOCH-THM-006-sampled-unitary-power.tex);
- [`BG-BLOCH-THM-007-two-alignments-common-power.tex`](BandGauge/Bloch/BG-BLOCH-THM-007-two-alignments-common-power.tex); and
- [`BG-BLOCH-THM-008-sampled-correlation-bound.tex`](BandGauge/Bloch/BG-BLOCH-THM-008-sampled-correlation-bound.tex);
- [`BG-BLOCH-THM-009-trace-centering-preserves-hermiticity.tex`](BandGauge/Bloch/BG-BLOCH-THM-009-trace-centering-preserves-hermiticity.tex);
- [`BG-BLOCH-THM-010-sampled-field-hermitian.tex`](BandGauge/Bloch/BG-BLOCH-THM-010-sampled-field-hermitian.tex); and
- [`BG-BLOCH-THM-011-unitary-conjugation-preserves-hermiticity.tex`](BandGauge/Bloch/BG-BLOCH-THM-011-unitary-conjugation-preserves-hermiticity.tex);
- [`BG-HILBERT-THM-001-ball-intersection-criterion.tex`](BandGauge/Hilbert/BG-HILBERT-THM-001-ball-intersection-criterion.tex);
- [`BG-HILBERT-THM-002-ball-distance-lower-bound.tex`](BandGauge/Hilbert/BG-HILBERT-THM-002-ball-distance-lower-bound.tex);
- [`BG-HILBERT-THM-003-ball-distance-attainment.tex`](BandGauge/Hilbert/BG-HILBERT-THM-003-ball-distance-attainment.tex); and
- [`BG-HILBERT-THM-004-exact-ball-set-distance.tex`](BandGauge/Hilbert/BG-HILBERT-THM-004-exact-ball-set-distance.tex);
- [`BG-HILBERT-THM-005-weighted-frobenius-nonnegative.tex`](BandGauge/Hilbert/BG-HILBERT-THM-005-weighted-frobenius-nonnegative.tex);
- [`BG-HILBERT-THM-006-weighted-frobenius-cauchy-schwarz.tex`](BandGauge/Hilbert/BG-HILBERT-THM-006-weighted-frobenius-cauchy-schwarz.tex);
- [`BG-HILBERT-THM-007-unitary-conjugation-preserves-power.tex`](BandGauge/Hilbert/BG-HILBERT-THM-007-unitary-conjugation-preserves-power.tex); and
- [`BG-HILBERT-THM-008-common-power-correlation-bound.tex`](BandGauge/Hilbert/BG-HILBERT-THM-008-common-power-correlation-bound.tex);
- [`BG-HILBERT-THM-009-weighted-frobenius-polarization.tex`](BandGauge/Hilbert/BG-HILBERT-THM-009-weighted-frobenius-polarization.tex);
- [`BG-HILBERT-THM-010-traceless-identity-orthogonality.tex`](BandGauge/Hilbert/BG-HILBERT-THM-010-traceless-identity-orthogonality.tex);
- [`BG-HILBERT-THM-011-operator-matrix-loss-expansion.tex`](BandGauge/Hilbert/BG-HILBERT-THM-011-operator-matrix-loss-expansion.tex);
- [`BG-HILBERT-THM-012-common-power-operator-quadratic.tex`](BandGauge/Hilbert/BG-HILBERT-THM-012-common-power-operator-quadratic.tex); and
- [`BG-HILBERT-THM-013-matrix-to-scalar-operator-loss.tex`](BandGauge/Hilbert/BG-HILBERT-THM-013-matrix-to-scalar-operator-loss.tex);
- [`BG-HILBERT-THM-014-spectral-residual-expansion.tex`](BandGauge/Hilbert/BG-HILBERT-THM-014-spectral-residual-expansion.tex); and
- [`BG-HILBERT-THM-015-spectral-field-to-scalar-loss.tex`](BandGauge/Hilbert/BG-HILBERT-THM-015-spectral-field-to-scalar-loss.tex);
- [`BG-CERT-THM-001-check-implies-valid.tex`](BandGauge/Certificates/BG-CERT-THM-001-check-implies-valid.tex);
- [`BG-CERT-THM-002-spectral-witness.tex`](BandGauge/Certificates/BG-CERT-THM-002-spectral-witness.tex);
- [`BG-CERT-THM-003-ellipse-containment.tex`](BandGauge/Certificates/BG-CERT-THM-003-ellipse-containment.tex); and
- [`BG-CERT-THM-004-strict-separation.tex`](BandGauge/Certificates/BG-CERT-THM-004-strict-separation.tex);
- [`BG-CERT-THM-005-enclosure-check-implies-valid.tex`](BandGauge/Certificates/BG-CERT-THM-005-enclosure-check-implies-valid.tex);
- [`BG-CERT-THM-006-enclosure-spectral-witness.tex`](BandGauge/Certificates/BG-CERT-THM-006-enclosure-spectral-witness.tex);
- [`BG-CERT-THM-007-enclosure-containment.tex`](BandGauge/Certificates/BG-CERT-THM-007-enclosure-containment.tex);
- [`BG-CERT-THM-008-enclosure-separation.tex`](BandGauge/Certificates/BG-CERT-THM-008-enclosure-separation.tex); and
- [`BG-CERT-THM-009-inverse-sqrt-two-enclosure.tex`](BandGauge/Certificates/BG-CERT-THM-009-inverse-sqrt-two-enclosure.tex);
- [`BG-CERT-THM-010-exact-dominance-check.tex`](BandGauge/Certificates/BG-CERT-THM-010-exact-dominance-check.tex);
- [`BG-CERT-THM-011-exact-threshold-check.tex`](BandGauge/Certificates/BG-CERT-THM-011-exact-threshold-check.tex); and
- [`BG-CERT-THM-012-exact-pareto-mask.tex`](BandGauge/Certificates/BG-CERT-THM-012-exact-pareto-mask.tex);
- [`BG-RAGASA2026A-THM-001-aligned-fields-traceless.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-001-aligned-fields-traceless.tex);
- [`BG-RAGASA2026A-THM-002-aligned-fields-common-power.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-002-aligned-fields-common-power.tex);
- [`BG-RAGASA2026A-THM-003-operator-correlation-bound.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-003-operator-correlation-bound.tex); and
- [`BG-RAGASA2026A-THM-004-operator-matrix-to-scalar-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-004-operator-matrix-to-scalar-loss.tex);
- [`BG-RAGASA2026A-THM-005-spectral-field-centered.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-005-spectral-field-centered.tex);
- [`BG-RAGASA2026A-THM-006-spectral-power-equals-parent.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-006-spectral-power-equals-parent.tex); and
- [`BG-RAGASA2026A-THM-007-spectral-field-to-scalar-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-007-spectral-field-to-scalar-loss.tex);
- [`BG-RAGASA2026A-THM-008-correlation-harmonic.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-008-correlation-harmonic.tex);
- [`BG-RAGASA2026A-THM-009-correlation-upper-bound.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-009-correlation-upper-bound.tex);
- [`BG-RAGASA2026A-THM-010-maximizing-angle-range.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-010-maximizing-angle-range.tex);
- [`BG-RAGASA2026A-THM-011-maximizing-angle-attainment.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-011-maximizing-angle-attainment.tex);
- [`BG-RAGASA2026A-THM-012-correlation-maximum-is-greatest.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-012-correlation-maximum-is-greatest.tex); and
- [`BG-RAGASA2026A-THM-013-maximized-normalized-correlation-bound.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-013-maximized-normalized-correlation-bound.tex);
- [`BG-RAGASA2026A-THM-014-normalized-correlation-at-maximizer.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-014-normalized-correlation-at-maximizer.tex); and
- [`BG-RAGASA2026A-THM-015-maximized-matrix-to-scalar-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-015-maximized-matrix-to-scalar-loss.tex);
- [`BG-RAGASA2026A-THM-016-canonical-correlation-harmonic.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-016-canonical-correlation-harmonic.tex); and
- [`BG-RAGASA2026A-THM-017-canonical-maximized-matrix-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-017-canonical-maximized-matrix-loss.tex);
- [`BG-RAGASA2026A-THM-018-canonical-spectral-field-centered.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-018-canonical-spectral-field-centered.tex);
- [`BG-RAGASA2026A-THM-019-canonical-spectral-power.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-019-canonical-spectral-power.tex); and
- [`BG-RAGASA2026A-THM-020-canonical-spectral-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-020-canonical-spectral-loss.tex);
- [`BG-RAGASA2026A-THM-021-canonical-spectral-real-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-021-canonical-spectral-real-loss.tex);
- [`BG-RAGASA2026A-THM-022-canonical-optimized-real-loss.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-022-canonical-optimized-real-loss.tex);
- [`BG-RAGASA2026A-THM-023-canonical-loss-intersection.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-023-canonical-loss-intersection.tex);
- [`BG-RAGASA2026A-THM-024-canonical-loss-distance.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-024-canonical-loss-distance.tex);
- [`BG-RAGASA2026A-THM-025-rectangle-intersection.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-025-rectangle-intersection.tex); and
- [`BG-RAGASA2026A-THM-026-rectangle-distance.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-026-rectangle-distance.tex); and
- [`BG-RAGASA2026A-THM-027-checked-certificate-bridge.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-027-checked-certificate-bridge.tex); and
- [`BG-RAGASA2026A-THM-028-checked-enclosure-bridge.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-028-checked-enclosure-bridge.tex);
- [`BG-RAGASA2026A-THM-029-uniform-weight-and-power.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-029-uniform-weight-and-power.tex);
- [`BG-RAGASA2026A-THM-030-constructed-maximum-correlation.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-030-constructed-maximum-correlation.tex);
- [`BG-RAGASA2026A-THM-031-constructed-certificate-accepts.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-031-constructed-certificate-accepts.tex); and
- [`BG-RAGASA2026A-THM-032-constructed-false-positive.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-032-constructed-false-positive.tex);
- [`BG-RAGASA2026A-THM-033-exact-separation-distance.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-033-exact-separation-distance.tex); and
- [`BG-RAGASA2026A-THM-034-separation-resolution.tex`](BandGauge/Papers/Ragasa2026A/BG-RAGASA2026A-THM-034-separation-resolution.tex);
- [`BG-DECISION-THM-001-weak-improvement-reflexive.tex`](BandGauge/Decision/BG-DECISION-THM-001-weak-improvement-reflexive.tex);
- [`BG-DECISION-THM-002-weak-improvement-transitive.tex`](BandGauge/Decision/BG-DECISION-THM-002-weak-improvement-transitive.tex);
- [`BG-DECISION-THM-003-dominance-irreflexive.tex`](BandGauge/Decision/BG-DECISION-THM-003-dominance-irreflexive.tex);
- [`BG-DECISION-THM-004-dominance-transitive.tex`](BandGauge/Decision/BG-DECISION-THM-004-dominance-transitive.tex);
- [`BG-DECISION-THM-005-duplicate-objectives-do-not-dominate.tex`](BandGauge/Decision/BG-DECISION-THM-005-duplicate-objectives-do-not-dominate.tex);
- [`BG-DECISION-THM-006-efficient-weak-improver-exists.tex`](BandGauge/Decision/BG-DECISION-THM-006-efficient-weak-improver-exists.tex);
- [`BG-DECISION-THM-007-weak-improvement-preserves-feasibility.tex`](BandGauge/Decision/BG-DECISION-THM-007-weak-improvement-preserves-feasibility.tex);
- [`BG-DECISION-THM-008-efficient-feasible-decision-exists.tex`](BandGauge/Decision/BG-DECISION-THM-008-efficient-feasible-decision-exists.tex);
- [`BG-DECISION-THM-009-pareto-sufficiency-for-feasibility.tex`](BandGauge/Decision/BG-DECISION-THM-009-pareto-sufficiency-for-feasibility.tex);
- [`BG-DECISION-THM-010-relaxed-thresholds-preserve-feasibility.tex`](BandGauge/Decision/BG-DECISION-THM-010-relaxed-thresholds-preserve-feasibility.tex);
- [`BG-DECISION-THM-011-minimum-feasible-cost-attained.tex`](BandGauge/Decision/BG-DECISION-THM-011-minimum-feasible-cost-attained.tex); and
- [`BG-DECISION-THM-012-minimum-cost-antitone-under-relaxation.tex`](BandGauge/Decision/BG-DECISION-THM-012-minimum-cost-antitone-under-relaxation.tex); and
- [`BG-DECISION-THM-013-two-channel-outcome-classification.tex`](BandGauge/Decision/BG-DECISION-THM-013-two-channel-outcome-classification.tex);
- [`BG-FOURIER-THM-001-truncation-preserves-supported-coefficient.tex`](BandGauge/Fourier/BG-FOURIER-THM-001-truncation-preserves-supported-coefficient.tex);
- [`BG-FOURIER-THM-002-truncation-zero-outside-support.tex`](BandGauge/Fourier/BG-FOURIER-THM-002-truncation-zero-outside-support.tex);
- [`BG-FOURIER-THM-003-truncated-reconstruction-support-sum.tex`](BandGauge/Fourier/BG-FOURIER-THM-003-truncated-reconstruction-support-sum.tex);
- [`BG-FOURIER-THM-004-retained-omitted-decomposition.tex`](BandGauge/Fourier/BG-FOURIER-THM-004-retained-omitted-decomposition.tex);
- [`BG-FOURIER-THM-005-full-minus-truncated-tail.tex`](BandGauge/Fourier/BG-FOURIER-THM-005-full-minus-truncated-tail.tex);
- [`BG-FOURIER-THM-006-linear-map-reconstruction.tex`](BandGauge/Fourier/BG-FOURIER-THM-006-linear-map-reconstruction.tex);
- [`BG-FOURIER-THM-007-linear-map-truncation.tex`](BandGauge/Fourier/BG-FOURIER-THM-007-linear-map-truncation.tex);
- [`BG-FOURIER-THM-008-omitted-weight-antitone.tex`](BandGauge/Fourier/BG-FOURIER-THM-008-omitted-weight-antitone.tex);
- [`BG-FOURIER-THM-009-finite-character-kernel.tex`](BandGauge/Fourier/BG-FOURIER-THM-009-finite-character-kernel.tex);
- [`BG-FOURIER-THM-010-finite-fourier-inversion.tex`](BandGauge/Fourier/BG-FOURIER-THM-010-finite-fourier-inversion.tex);
- [`BG-FOURIER-THM-011-cardinality-removes-forward-normalization.tex`](BandGauge/Fourier/BG-FOURIER-THM-011-cardinality-removes-forward-normalization.tex);
- [`BG-FOURIER-THM-012-inner-sum-parseval.tex`](BandGauge/Fourier/BG-FOURIER-THM-012-inner-sum-parseval.tex);
- [`BG-FOURIER-THM-013-character-orthogonality.tex`](BandGauge/Fourier/BG-FOURIER-THM-013-character-orthogonality.tex);
- [`BG-FOURIER-THM-014-coefficient-reconstruction.tex`](BandGauge/Fourier/BG-FOURIER-THM-014-coefficient-reconstruction.tex);
- [`BG-FOURIER-THM-015-power-is-norm-square-sum.tex`](BandGauge/Fourier/BG-FOURIER-THM-015-power-is-norm-square-sum.tex);
- [`BG-FOURIER-THM-016-finite-parseval.tex`](BandGauge/Fourier/BG-FOURIER-THM-016-finite-parseval.tex);
- [`BG-FOURIER-THM-017-retained-omitted-power.tex`](BandGauge/Fourier/BG-FOURIER-THM-017-retained-omitted-power.tex);
- [`BG-FOURIER-THM-018-coefficient-subtraction.tex`](BandGauge/Fourier/BG-FOURIER-THM-018-coefficient-subtraction.tex);
- [`BG-FOURIER-THM-019-truncation-residual-coefficient.tex`](BandGauge/Fourier/BG-FOURIER-THM-019-truncation-residual-coefficient.tex);
- [`BG-FOURIER-THM-020-coefficient-residual-omitted-power.tex`](BandGauge/Fourier/BG-FOURIER-THM-020-coefficient-residual-omitted-power.tex);
- [`BG-FOURIER-THM-021-reconstructed-residual-parseval.tex`](BandGauge/Fourier/BG-FOURIER-THM-021-reconstructed-residual-parseval.tex);
- [`BG-FOURIER-THM-022-hermitian-field-coefficient-pairing.tex`](BandGauge/Fourier/BG-FOURIER-THM-022-hermitian-field-coefficient-pairing.tex);
- [`BG-FOURIER-THM-023-negation-closed-truncation-pairing.tex`](BandGauge/Fourier/BG-FOURIER-THM-023-negation-closed-truncation-pairing.tex);
- [`BG-FOURIER-THM-024-paired-coefficients-hermitian-reconstruction.tex`](BandGauge/Fourier/BG-FOURIER-THM-024-paired-coefficients-hermitian-reconstruction.tex);
- [`BG-FOURIER-THM-025-truncated-reconstruction-hermitian.tex`](BandGauge/Fourier/BG-FOURIER-THM-025-truncated-reconstruction-hermitian.tex);
- [`BG-FOURIER-THM-026-matrix-coefficients-entrywise.tex`](BandGauge/Fourier/BG-FOURIER-THM-026-matrix-coefficients-entrywise.tex);
- [`BG-FOURIER-THM-027-matrix-frobenius-parseval.tex`](BandGauge/Fourier/BG-FOURIER-THM-027-matrix-frobenius-parseval.tex);
- [`BG-FOURIER-THM-028-matrix-frobenius-residual-tail.tex`](BandGauge/Fourier/BG-FOURIER-THM-028-matrix-frobenius-residual-tail.tex);
- [`BG-FOURIER-THM-029-constant-weight-frobenius-bridge.tex`](BandGauge/Fourier/BG-FOURIER-THM-029-constant-weight-frobenius-bridge.tex);
- [`BG-FOURIER-THM-030-weighted-residual-tail.tex`](BandGauge/Fourier/BG-FOURIER-THM-030-weighted-residual-tail.tex);
- [`BG-FOURIER-THM-031-uniform-weight-positive.tex`](BandGauge/Fourier/BG-FOURIER-THM-031-uniform-weight-positive.tex); and
- [`BG-FOURIER-THM-032-uniform-paper-normalization.tex`](BandGauge/Fourier/BG-FOURIER-THM-032-uniform-paper-normalization.tex).

Each dossier records its statement ID and the status listed in `docs/theorem-manifest.md`. The `BG-BLOCH-THM-003` through `BG-BLOCH-THM-006` dossiers document standard supporting trace and unitary-invariance infrastructure; they are not paper-contribution or novelty claims. `BG-BLOCH-THM-007/008` are source-normalized bridge specializations; `BG-BLOCH-THM-009--011` are standard Hermiticity infrastructure. None carries a claim that the underlying standard algebra is novel. The files remain draft and unreleased; accepted literature identities and scientific instantiation remain unresolved. `template.tex` remains a template, not a claim.

## Organizing principle

A dossier is keyed by one Project Koios Formal statement ID and mirrors the owning Lean module path. For example:

```text
ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean
proofs/BandGauge/Geometry/BG-THM-002-common-witness.tex
```

Use one dossier for one publication-facing Lean declaration. Do not create dossiers for broad planning families such as `BG-PLAN-001`, search attempts, or unsourced generalizations. Internal helper lemmas normally remain documented by Lean source unless they carry an independently sourced claim that warrants a dossier.

A changed proof of the same exact statement updates the existing dossier. Once a proved statement has an ID, do not change that proposition under the same ID. If a different result is needed, create a new Lean declaration with a new ID and build on the earlier theorem.

## Lifecycle

Every dossier begins with exactly one statement ID and one formal status matching `docs/theorem-manifest.md`.

A dossier may be drafted once there is an exact declaration, an owning module and namespace, an immutable owner-source locator, an assumption-delta review, and a decision about applicable prior-art relationships. Draft formatting does not alter theorem status. A proved theorem is not thereby released, paper-specific, scientifically validated, novel, or publication-ready.
## Required dossier sections

Each dossier must contain:

1. statement ID, status, module, and declaration;
2. exact mathematical statement;
3. immutable source provenance and source locator;
4. assumptions, conventions, and source-to-Lean delta;
5. statement-specific prior art and a novelty/contribution boundary;
6. a proof schematic showing the argument's dependency and implication structure;
7. a human-readable mathematical proof or an explicit proof gap;
8. the Lean realization and library dependencies without duplicating the full Lean file;
9. trusted-base and `#print axioms` results;
10. AI/automation and toolchain provenance, maintainer comprehension/context notes, and independent-review status;
11. numerical, certificate, and external-evidence boundaries;
12. unresolved questions; and
13. review and revision history.

The proof schematic should expose the inputs, definitions, principal reductions, imported lemmas, critical implications, conclusion, and any branch that remains an external or numerical obligation. It should let a reader see the proof's shape before reading either prose or Lean.

The dossier must distinguish the mathematical proof from Lean implementation notes. It may quote the final Lean declaration signature, but it must not duplicate long tactic scripts or exploratory proof bodies.

## Prior-art rules

Prior art belongs to the particular statement, not to an undifferentiated project bibliography. Use only the closed relation vocabulary from `docs/reference-crosswalk-policy.md`:

- `formalizes`;
- `adapts`;
- `depends-on`;
- `compares-with`; and
- `background-only`.

`projectkoios-references` owns canonical literature identity, citekeys, bibliography metadata, and bibliography rendering. A dossier records References-owned canonical and authority IDs plus exact locators. Titles, authors, DOI values, and rendered citations are non-authoritative display fields.

If identity is unresolved, label the entry unresolved and retain only approved candidate or observation IDs. Do not mint a Formal-owned literature identity or commit an independent `.bib` file here.

A citation attachment does not establish originality, correctness, scientific support, or proof completion. State whether a source directly supplies the claim, supplies a method, is only comparison/background, or requires a derived step.

## Relationship to other repository surfaces

- `docs/` owns policy, planning, source audits, manifests, and crosswalks.
- `ProjectKoios/` owns accepted Lean definitions and proofs.
- `proofs/` explains one accepted statement and proof at a time.
- `papers/` supplies cross-statement working narratives and status matrices without replacing individual dossiers or Lean authority.
- Future replayable experiments, if approved, belong in a separately audited probe/test surface rather than in dossiers.

The Lean declaration and kernel check are authoritative for formal proof status. The dossier is an auditable human explanation and attribution record; compiling its LaTeX does not prove its claim.

## Building a dossier

Compile outside the repository tree so generated artifacts are not retained:

```console
out="$(mktemp -d /tmp/projectkoios-proof.XXXXXX)"
latexmk -pdf -interaction=nonstopmode -halt-on-error \
  -outdir="$out" proofs/path/to/dossier.tex
rm -rf "$out"
```

Do not commit PDFs, auxiliary files, logs, or generated bibliography output. A LaTeX build check is separate from the Lean build and axiom audit.
