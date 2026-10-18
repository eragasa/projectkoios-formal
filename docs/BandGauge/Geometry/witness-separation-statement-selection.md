# BG-PLAN-001 witness/separation statement-selection packet

This began as a statement-selection packet and now records the first implemented slice of `BG-PLAN-001`. The implemented declarations in `ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean` are listed in `docs/theorem-manifest.md`. Concrete paper loss formulas and certificate data remain open.

## Immutable owner source

- Repository: `ksdft2effmass`
- Branch recorded for navigation: `work/paper-3-higher-rank-extension`
- Immutable commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Path: `docs/publications/papers/Ragasa2026c/v1/manuscript.md`
- Definition: lines 117–130
- Proposition: lines 132–138
- Paper proof: lines 140–145
- Empty-set and noncomputation boundary: lines 147–149

The source defines the distance of two nonempty admissible sets as the infimum of pairwise metric distances. It states that a common witness gives zero distance, any feasible pair gives an upper bound, a certified strictly positive lower bound proves disjointness, and compact disjoint sets attain a positive distance. It also states that failed search proves none of these and that no finite set-to-set distance is reported when either set is empty.

At the later read-only attribution inspection, the owner worktree remained at the same commit but both `manuscript.md` and `manuscript.tex` were dirty. Their uncommitted citation wording is not adopted here. The committed revision is authoritative for this packet.

## Scientific decision represented

The application is joint adequacy within one declared candidate model family, not a comparison of arbitrary models drawn from unrelated parameter spaces. Following the paper terminology, let `X` be the declared model-parameter domain and let the frozen spectral and aligned-operator losses define

\[
\mathcal A_E=\{\theta\in X:L_E(\theta)\le\tau_E\},\qquad
\mathcal A_H=\{\theta\in X:L_{H,\mathrm{orb}}(\theta)\le\tau_H\}.
\]

These are two admissible classes of concrete candidate models within the same family. A **common witness** or **joint match** is the same candidate parameter `θ` in `𝒜_E ∩ 𝒜_H`: one concrete model meets both the band/spectral and restricted aligned-operator error budgets. The operator loss minimizes only over the declared admissible alignment family; admitting a larger momentum-dependent family would answer a different question.

The set distance `δ*` lives in model-parameter space. It is not an operator residual, a Brillouin-zone distance, a hopping-range measure, or a claim that the complete Hamiltonians cease to be gauge equivalent. A certified separation result says only that no candidate in the declared family, parameter domain, alignment contract, and error budgets is jointly adequate. It does not exclude a larger candidate family, establish material invalidity, or prove physical inequivalence.

The paper's decision vocabulary has three outcomes:

1. **joint match** — an explicit common witness establishes compatibility;
2. **certified separation** — a verified lower bound exceeds the declared separation resolution; and
3. **unresolved** — neither a witness nor a qualifying global certificate has been established.

A failed search, plot, or local optimizer result remains unresolved. Paper B's sampled three-way Pareto landscape among spectral fidelity, Hamiltonian fidelity, and hopping locality is a related but distinct decision object; it must not be collapsed into this two-admissible-set proposition.

## Motivation and contribution boundary

This work is motivated by the value of an auditable decision procedure, not by a claim of new mathematical theory.

- The elementary set-distance clauses are classical metric-space consequences. Positive separation of a compact set from a disjoint closed set is recorded by Rudin, Chapter 4, Exercise 21, p. 101; compact extrema are supplied by Theorem 4.16, pp. 89–90, and attainment on two compact sets follows by applying that result to the compact product.
- The distinction between an unsuccessful local or finite search and a global certificate is established in complete-search, constraint-satisfaction, and validated-global-optimization practice.
- Feasible-parameter-set, consistency, invalidation, and infeasibility language has established precedent in bounded-error and set-membership identification.
- A validated lower bound on a set-distance optimization problem uses established interval and global-optimization machinery rather than a new proof principle.

The contribution is methodological and applied: these standard ingredients form one threshold-defined rule for joint spectral and restricted aligned-operator adequacy, with explicit witness and separation certificates and a concrete scientific instantiation. The metric facts and witness/infeasibility distinction are classical, not novel.

The current audit found no reviewed source using the exact terminology for this workflow. That search result establishes no priority.

## Attribution boundary

The conservative attribution is:

- the set-distance implications are standard metric-space facts;
- feasible-set terminology has precedent in bounded-error and set-membership identification;
- validated global lower bounds belong to complete-search and interval-analysis methodology; and
- the spectral/operator admissible-set decision workflow is a project-specific synthesis and application in the unpublished Ragasa manuscripts.

Do not call the candidate a “Ragasa witness theorem,” an established theory named “common witness or certified positive separation,” or a novel principle. The exact Ragasa proposition remains the formalization source without implying that its elementary ingredients originated there.

No theorem-to-literature crosswalk is complete. The References-owned canonical and authority identifiers listed in `docs/reference-crosswalk-policy.md` are not yet available for the candidate works below.

## Mathematical decomposition

The paper proposition should not become one bundled theorem. The proposed components are:

1. **Distance representation and domain.** Define an infimum of pairwise distances while preserving the source rule that empty sets do not produce a finite reported value.
2. **Feasible-pair upper bound.** For `x ∈ s` and `y ∈ t`, the set distance is at most the distance from `x` to `y`.
3. **Common witness.** For `x ∈ s ∩ t`, the set distance is zero.
4. **Certified separation.** If a strictly positive value is certified below the set distance, then `s` and `t` are disjoint.
5. **Compact attainment and positivity.** If `s` and `t` are nonempty compact disjoint subsets of a metric space, their set distance is attained by a pair and is strictly positive.

“Failure of a search proves none of these” is an evidence-policy statement, not a standalone mathematical proposition suitable for Lean without first formalizing a search procedure and its specification.

## Representation decision

The implemented first-slice representation is an extended nonnegative distance. The pinned Mathlib revision has point-to-set `Metric.infDist` and `Metric.infEDist`, but no inspected real-valued set-to-set distance matching the paper's infimum over `s × t`. A total real-valued definition would also assign an implementation value to empty input, conflicting with the paper's instruction not to report a finite distance there.

`BG-DEF-001` is:

```lean
noncomputable def admissibleSetEDist [MetricSpace X] (A B : Set X) : ENNReal :=
  ⨅ (a : X) (_ : a ∈ A) (b : X) (_ : b ∈ B), edist a b
```

This extends the paper's real-valued nonempty distance so that either empty input gives `⊤`, not a finite reported value. `BG-DEF-002` exposes the real value only with nonemptiness proofs, and `BG-THM-006` proves the real/extended bridge. No total real API assigns a reportable value to empty inputs.

## Implemented and remaining signatures

Four publication-facing clauses have status `proved` under `[MetricSpace X]`:

```lean
-- BG-THM-001
candidateA ∈ A → candidateB ∈ B →
  admissibleSetEDist A B ≤ edist candidateA candidateB

-- BG-THM-002
candidate ∈ A ∩ B → admissibleSetEDist A B = 0

-- BG-THM-003
0 < lower → lower ≤ admissibleSetEDist A B → Disjoint A B

-- BG-THM-004
IsCompact A → IsCompact B → A.Nonempty → B.Nonempty → Disjoint A B →
  ∃ a ∈ A, ∃ b ∈ B,
    admissibleSetEDist A B = edist a b ∧ 0 < admissibleSetEDist A B

-- BG-THM-005
A.Nonempty → B.Nonempty → admissibleSetEDist A B ≠ ⊤

-- BG-DEF-002
admissibleSetDist (A B : Set X) (hA : A.Nonempty) (hB : B.Nonempty) : ℝ

-- BG-THM-006
ENNReal.ofReal (admissibleSetDist A B hA hB) = admissibleSetEDist A B

-- BG-DEF-003 / BG-DEF-004
spectralAdmissibleSet spectralLoss spectralBudget : Set X
alignedOperatorAdmissibleSet alignedOperatorLoss operatorBudget : Set X

-- BG-THM-007
spectralLoss candidate ≤ spectralBudget →
alignedOperatorLoss candidate ≤ operatorBudget →
  admissibleSetEDist
    (spectralAdmissibleSet spectralLoss spectralBudget)
    (alignedOperatorAdmissibleSet alignedOperatorLoss operatorBudget) = 0

-- BG-THM-008
0 < lower →
lower ≤ admissibleSetEDist
  (spectralAdmissibleSet spectralLoss spectralBudget)
  (alignedOperatorAdmissibleSet alignedOperatorLoss operatorBudget) →
¬ ∃ candidate,
  spectralLoss candidate ≤ spectralBudget ∧
  alignedOperatorLoss candidate ≤ operatorBudget
```

The source assumes a metric, not merely a pseudometric. `[MetricSpace X]` is retained because strict positivity for disjoint sets fails when distinct points can have zero pseudodistance.

Remaining convenience lemmas:

- left-empty distance is `⊤`;
- right-empty distance is `⊤`.

## Mathlib API probe

Probe identity:

- Lean: `v4.35.0`, commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`
- Mathlib: `56a005855ea17e0b0958f73ec801ae140b0a1679`
- Module imports: `Mathlib.Topology.Instances.ENNReal.Lemmas`, `Mathlib.Topology.MetricSpace.Basic`, and `Mathlib.Topology.Order.Compact`
- Secondary API inspection: `Mathlib.Topology.MetricSpace.HausdorffDistance` and `Mathlib.Topology.MetricSpace.MetricSeparated`
- Probe status: the original exploratory files were not retained; all four clauses are replayable repository source
- Repository Lean source: `ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean`

Inspected declarations:

| Declaration | Use or limitation |
|---|---|
| `Metric.infEDist` | Point-to-set extended distance; useful model for empty-set semantics, but not set-to-set distance. |
| `Metric.infDist` | Point-to-set real distance; `Metric.infDist_empty = 0`, so it cannot by itself enforce the paper's no-finite-empty-report boundary. |
| `Metric.infDist_le_dist_of_mem` | Existing point-to-set feasible-point upper bound. |
| `Metric.le_infDist` | Characterizes lower bounds on point-to-set distance for nonempty sets. |
| `IsCompact.exists_infDist_eq_dist` | Point-to-set attainment for a compact nonempty set. |
| `Metric.AreSeparated` | Existing positive uniform separation predicate in extended distance. |
| `Metric.AreSeparated.disjoint` | Directly converts that predicate to disjointness, but does not expose the paper's numeric infimum or attainment pair. |
| `Metric.exists_pos_forall_lt_edist` | Gives a positive uniform gap for a compact set and a disjoint closed set. |
| `IsCompact.prod` | Supplies compactness of the product for pairwise-distance minimization. |
| `IsCompact.exists_isMinOn` | Supplies an attaining pair for continuous distance on the compact product. |
| `continuous_dist`, `continuous_edist` | Continuity needed for product minimization. |
| `csInf_le`, `le_csInf` | Support the alternative real `sInf (Set.image2 dist s t)` representation. |

Local exploratory files considered both a real-valued `sInf (Set.image2 dist s t)` formulation and the implemented extended-valued formulation. Their exact source was not retained and supplies no proof evidence. The repository module independently proves and implements every declaration listed for this module in `docs/theorem-manifest.md`.

The module and `ProjectKoios/Audit.lean` build at the pin. The audit reports only `propext`, `Classical.choice`, and `Quot.sound` for every listed theorem, with no admission or repository-owned scientific axiom. The full repository build, pin check, admission scan, and named axiom audit pass in the current worktree.

## Artifact placement principle

Keep each kind of material in one place:

- `docs/` records policy, source identity, planning, representation decisions, and review status. It should not contain full exploratory proofs or long theorem-by-theorem prior-art essays.
- `ProjectKoios/` contains library definitions and theorem declarations that are built and audited as repository results.
- The top-level `proofs/` tree mirrors the Lean module hierarchy and contains one standalone LaTeX proof dossier per publication-facing statement, named by its formal statement ID and a short slug. Each dossier records that statement's source, assumptions, prior art, contribution boundary, mathematical proof, Lean realization, axiom report, and evidence boundary; it does not duplicate the full Lean source or own bibliography identity.
- The top-level `papers/` tree may synthesize across claim families. Its working paper is a narrative/status surface, not proof authority, a duplicate owner manuscript, or a replacement for per-statement dossiers.
- A future `Tests/Probes/` area may contain replayable, non-library Lean experiments organized one file per planning ID. Creating that area, its audit coverage, and its explicit check command requires separate review because it would add repository-owned Lean source outside the current library glob.
- Implement the smallest declaration and matching dossier needed for the sourced claim. Do not preserve duplicate proof bodies across documentation, probes, dossiers, and library source.

This packet therefore remains a compact decision record. The Lean proof bodies live in the library module and each theorem has an individual dossier draft under `proofs/BandGauge/Geometry/`; this file embeds neither a proof appendix nor a hidden test surface or monolithic claims document.

Physlib was not needed or inspected for these generic metric-space facts.

## Ownership and names

The module is:

```text
ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean
```

It imports the three Mathlib modules listed above, uses namespace `ProjectKoios.BandGauge.Geometry`, and is intentionally not re-exported from `ProjectKoios/BandGauge.lean` or another root. Declaration names and IDs are recorded in `docs/theorem-manifest.md`.

The generic definition may later merit a narrower foundational home or upstream proposal, but moving or generalizing it before downstream instantiations are reviewed would be premature.

## Reference-resolution result

A read-only References-owner check returned `REVIEW_INCONCLUSIVE` because none of the four candidate works currently has an accepted `canonical_reference_id`, authority/projection ID, or governed source-document evidence ID.

| Candidate | Verified locator and limited role | Remaining limitation |
|---|---|---|
| Walter Rudin, *Principles of Mathematical Analysis*, 3rd ed. | Ch. 4, Exercise 21, p. 101 states positive separation for disjoint compact `K` and closed `F`. Theorem 4.16, pp. 89–90 gives extrema of a continuous real function on a compact metric space; pairwise attainment follows by a compact-product derivation. Relation candidate: `depends-on`, with derived-step caveat. | Checked against an edition-faithful institutional mirror only; temporary hash is not a governed evidence ID. No canonical or authority ID. |
| Arnold Neumaier, “Complete Search in Continuous Global Optimization and Constraint Satisfaction,” *Acta Numerica* 13 (2004), 271–369, DOI `10.1017/S0962492904000194` | Author manuscript §1 defines complete search; §20, “Rigorous verification and certificates,” especially “Certificates of infeasibility,” Theorem 20.1 and equations (96)–(100), gives checkable infeasibility/box-exclusion certificates. Relation candidate: `background-only`. | Exact version-of-record leaf pages remain unresolved; legacy metadata is imported-unverified and has no accepted IDs or asset. |
| Ramon E. Moore, R. Baker Kearfott, and Michael J. Cloud, *Introduction to Interval Analysis* (2009), DOI `10.1137/1.9780898717716` | §5.4, Theorem 5.1 and Corollary 5.1, p. 47: interval extensions enclose the real range and provide finite bounds. §3.2, Definition 3.1, p. 22 addresses outward-rounded machine rigor. Relation candidate: `background-only`. | No accepted canonical, authority, or source-document ID. |
| Milanese, Norton, Piet-Lahanier, and Walter, eds., *Bounding Approaches to System Identification* (1996), DOI `10.1007/978-1-4757-9545-5` | Chapter 20, Norton and Veres, “Identification of Nonlinear State-Space Models by Deterministic Search,” pp. 317–331, has publisher-primary abstract support for “feasible parameter set.” Chapter 2, Milanese and Vicino, pp. 5–27, is broader conceptual background. Relation candidate: `background-only`. | No accepted IDs. The available preview does not expose the exact phrase for Chapter 2, so do not attribute that wording to Chapter 2 without stronger evidence. |

Farkas, Nocedal–Wright, and Ljung remain deferred analogical/background candidates. They are not needed to state or prove the elementary theorem family.

## Remaining work

- Add explicit empty-input simplification lemmas when downstream proofs need them.
- Instantiate the generic geometry in a paper namespace when the scientific loss definitions are encoded.
- Attach References-owned canonical and authority IDs when available.
- Exclude the owner's dirty attribution wording unless it is committed and separately audited.

`BG-PLAN-001` contains the generic decision theorems and real/extended bridge. Concrete scientific loss formulas, certificate data, and the numerical decision procedure remain incomplete.
