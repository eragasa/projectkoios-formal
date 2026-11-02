# Exact finite-rank gauge-construction crosswalk

## Status

This is a **provisional exact-mathematics crosswalk**, not a runtime or evidence binding. The
inspected Periodic2D/3D rank-N KSD model files were untracked in a highly dirty owner worktree.
Exact byte hashes, branch, checked-out commit, line locators, and dirty-state limitations are
recorded in [`docs/source-audit.md`](../../source-audit.md).

## Formula correspondence

| KSD construction | Formal representation | Exact result |
|---|---|---|
| attacked frame `F' = F₀ G` | `rightUnitaryFrame referenceFrame gauge` | `BG-ALIGNMENT-THM-003`: exact orthonormality preservation |
| attacked represented operator `H' = Gᴴ D G` | `rightGaugeConjugate G D` | `BG-ALIGNMENT-THM-069`: complex-spectrum preservation |
| known inverse right action `Gᴴ` | right multiplication by the conjugate transpose | `BG-ALIGNMENT-LEM-001`: `(F₀G)Gᴴ = F₀` |
| inverse represented-operator action | `rightGaugeConjugate Gᴴ (rightGaugeConjugate G D)` | `BG-ALIGNMENT-LEM-002`: exact recovery of `D` |
| combined construction contract | preceding exact definitions | `BG-ALIGNMENT-THM-071`: orthonormality, spectrum, and both recovery identities |

The theorem is independent of spatial dimension and retained rank. It applies to the KSD diagonal
reference operator as a specialization of an arbitrary exact finite represented operator. The
spectral conclusion is equality of the complex spectrum as a set; it is not an ordered-eigenvalue
or runtime eigensolver claim.

## Explicit nonclaims

These declarations do not establish:

- unitarity of a floating-point Givens circuit or orthonormality of a NumPy frame;
- exactness of binary64 conjugation, matrix multiplication, broadcasting, or serialization;
- identity between runtime arrays and the exact supplied matrices;
- correctness of eigensolver ordering, Procrustes rank detection, optimizer recovery, transport,
  Fourier transforms, or support truncation;
- mesh adequacy, retained-artifact validity, material applicability, or scientific validation; or
- immutable source fidelity while the owner files remain untracked.

A future owner-commit binding must refresh the hashes and locators and receive separate review.
Runtime claims require their own exact or outward-enclosed checked-certificate boundary.
