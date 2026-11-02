# Finite-rank analytic-parent crosswalk

## Status

This is a **provisional mathematical crosswalk**, not a runtime or evidence binding. The inspected
Periodic2D/3D rank-N KSD files were untracked in a dirty owner worktree. Exact byte hashes, branch,
checked-out commit, line locators, and dirty-state limitations are recorded in
[`docs/source-audit.md`](../../source-audit.md).

## Formula correspondence

| KSD mathematical object | Formal declaration | Exact result |
|---|---|---|
| `0.75 cos θ + 0.25 cos 2θ` | `finiteRankBondHarmonic` | `BG-FOUNDATION-THM-026`: value in `[-1,1]` |
| nonempty equal-weight bond average `c_B` | `finiteRankStructureFactor` | `BG-FOUNDATION-THM-027`: `c_B ∈ [-1,1]` |
| `ξ_j = (2j-r+1)/(r-1)` | `finiteRankOrbitalCoordinate` | `BG-FOUNDATION-THM-028`: selected coordinates lie in `[-1,1]` |
| retained energy `0.4 ξ_j + 0.25 λ (1+0.2 ξ_j)c_B` | `finiteRankRetainedEnergy` | `BG-FOUNDATION-THM-029`: at most `0.7` |
| exterior energy `3.0 + 0.3 ξ_j + 0.1 λ c_B` | `finiteRankExteriorEnergy` | `BG-FOUNDATION-THM-030`: at least `2.6` |
| retained/exterior separation | preceding exact definitions | `BG-FOUNDATION-THM-035`: gap at least `1.9` |
| adjacent retained gap and ordering | preceding exact definitions | `BG-FOUNDATION-THM-036/037`: gap at least `7/(10(r-1))` and strict selected-index ordering |

The Formal theorem is dimension-neutral. Periodic2D and Periodic3D differ in their bond vectors and
phase construction, while the exact bound uses only a nonempty finite phase inventory. The selected
runtime ranks `{3,4,8}` satisfy the theorem's assumption `r ≥ 2`; Formal does not encode that runtime
inventory as evidence.

## Explicit nonclaims

These declarations do not establish:

- identity between the abstract finite bond type and a Python tuple;
- exactness of NumPy, binary64 cosine evaluation, averaging, or array broadcasting;
- correctness of sampled minimum-gap calculations or equality with a continuum minimum;
- eigensolver ordering, Procrustes rank detection, gauge recovery, frame transport, or Fourier
  transforms;
- mesh adequacy, threshold adequacy, retained artifacts, material applicability, or scientific
  validation; or
- immutable source fidelity while the owner files remain untracked.

A future owner-commit binding must refresh the hashes and locators and receive separate review. It
must not promote runtime values into exact evidence without an explicit checked certificate
boundary.
