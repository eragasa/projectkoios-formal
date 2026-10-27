# Witness and separation statement selection

This record freezes the source statement behind `BG-PLAN-001`. It is a planning crosswalk, not a theorem-status override.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-18

## Source identity

The selected source is Paper C in `ksdft2effmass`.

- Repository: `ksdft2effmass`
- Branch at inspection: `work/paper-3-higher-rank-extension`
- Commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Path: `docs/publications/papers/Ragasa2026c/v1/manuscript.md`
- Definition: lines 117–130
- Proposition: lines 132–138
- Proof: lines 140–145
- Empty-set and noncomputation boundary: lines 147–149

At the later read-only attribution inspection, the owner worktree remained at the same commit, but both `manuscript.md` and `manuscript.tex` had unstaged changes. This record uses only the immutable committed bytes; the later uncommitted attribution wording is not adopted.

## Scientific decision

For one declared candidate domain `X`, define

\[
\mathcal A_E=\{\theta\in X:L_E(\theta)\le\tau_E\},\qquad
\mathcal A_H=\{\theta\in X:L_{H,\mathrm{orb}}(\theta)\le\tau_H\}.
\]

A common witness is the same candidate `θ` in both sets. The aligned-operator loss minimizes only over the declared alignment family; enlarging that family changes the question.

The set distance lies in model-parameter space. It is not an operator residual, momentum-space distance, hopping-range measure, proof of physical inequivalence, or statement about a larger model family.

The decision has three outcomes:

1. **joint match:** an explicit common witness;
2. **certified separation:** a verified lower bound above the declared resolution; or
3. **unresolved:** neither object is established.

A failed search, plot, or local optimizer remains unresolved. Paper B's sampled three-objective Pareto problem is a separate decision object.

## Selected statement

For nonempty admissible sets, any feasible pair bounds the distance from above, a common witness forces distance zero, and a certified positive lower bound excludes a common witness. Nonempty compact disjoint sets attain a strictly positive distance.

The source states that it does not report a finite distance for an empty input. Lean therefore uses an extended nonnegative infimum, where an empty input gives `⊤`, and exposes a real-valued distance only with nonemptiness proofs. A metric, rather than only a pseudometric, is retained because strict positivity can fail for distinct points at zero pseudodistance.

## Formal crosswalk

The selected source decomposes into reusable declarations.

- `BG-THM-001`: any feasible pair bounds the admissible-set distance from above.
- `BG-THM-002`: a common witness gives distance zero.
- `BG-THM-003`: a certified positive lower bound excludes a common witness.
- `BG-THM-004`: nonempty compact disjoint sets attain a strictly positive distance.
- `BG-THM-005` and `BG-THM-006`: nonemptiness makes the extended distance finite and connects it to the real-valued representation.
- `BG-THM-007` and `BG-THM-008`: loss-defined common witnesses give zero distance, while positive separation excludes joint adequacy.

The formal results are intentionally more reusable than the publication notation. `docs/theorem-manifest.md` remains authoritative for declaration status.

## Attribution boundary

The metric facts and compactness argument are classical. Feasible-set language and validated global lower bounds also have established precedent. The project-specific contribution is the source-traceable decision procedure, not a new named theorem or priority claim.

A read-only References-owner check returned `REVIEW_INCONCLUSIVE`: none of the candidate works had an accepted canonical reference, authority/projection, or governed source-document evidence ID.

| Candidate | Reviewed locator and role | Limitation |
|---|---|---|
| Walter Rudin, *Principles of Mathematical Analysis*, 3rd ed. | Ch. 4, Exercise 21, p. 101; Theorem 4.16, pp. 89–90; candidate `depends-on` relation | edition-faithful mirror only; no governed identity |
| Arnold Neumaier, “Complete Search in Continuous Global Optimization and Constraint Satisfaction,” *Acta Numerica* 13 (2004), 271–369, DOI `10.1017/S0962492904000194` | §1 and §20, especially Theorem 20.1 and equations (96)–(100); `background-only` | version-of-record leaf pages and accepted identities unresolved |
| Moore, Kearfott, and Cloud, *Introduction to Interval Analysis* (2009), DOI `10.1137/1.9780898717716` | §5.4, Theorem 5.1 and Corollary 5.1, p. 47; §3.2, Definition 3.1, p. 22; `background-only` | no accepted canonical, authority, or source-document ID |
| Milanese, Norton, Piet-Lahanier, and Walter, eds., *Bounding Approaches to System Identification* (1996), DOI `10.1007/978-1-4757-9545-5` | Ch. 20, pp. 317–331, for feasible-parameter-set language; Ch. 2, pp. 5–27, as background | preview does not support attributing the exact phrase to Ch. 2; accepted IDs unavailable |

Farkas, Nocedal--Wright, and Ljung remain deferred analogical candidates. They are not required to state or prove this theorem family.

## Historical replay

An earlier probe used Lean `v4.35.0` at commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc` and Mathlib commit `56a005855ea17e0b0958f73ec801ae140b0a1679`. The exploratory files were not retained; the repository declarations are the replayable source. Their named audit reports use only `propext`, `Classical.choice`, and `Quot.sound`.

The replay supported statement selection; it did not replace the repository declarations, full audit, or source review.

## Boundaries

This crosswalk does not establish numerical separation, physical applicability, novelty, or publication readiness. It does not transfer Paper A evidence or source identity to the Paper C statement.
