# Publication and manuscript source records

Read-only inspections of publication manuscripts and publication-facing planning sources. These records identify inspected sources and limitations; they do not transfer ownership, theorem status, scientific validity, or publication authority.

<a id="aud-src-002"></a>

## `AUD-SRC-002` — Ragasa publication suite final inspected identity

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-002` |
| Status | `current` |
| Source class | Publication/manuscript inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The final inspection resolved one clean immutable source revision.

- Owner repository: `ksdft2effmass`
- Branch: `work/paper-3-higher-rank-extension`
- Commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Final worktree status: clean.
- Identity basis: local branch, immutable commit, and cited-byte hashes; upstream tracking is irrelevant.
- Access: read-only; no owner file, index, branch, worktree, or configuration was changed.

Source directories use lowercase paper suffixes; Lean placeholders use uppercase A/B/C. Inspection began at `593cfca64b19b34fc37f450a38419d1cf6e67a15` with relevant uncommitted changes. Another process integrated those bytes, so identity and status were re-resolved. A later unrelated protocol path briefly appeared and disappeared; cited publication paths remained clean. The final cited files are clean bytes at `99a46c…`, and no concurrent change is attributed to this audit.

<a id="aud-src-003"></a>

## `AUD-SRC-003` — Ragasa publication suite later attribution reinspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-003` |
| Status | `current` |
| Source class | Publication/manuscript inspection |
| Identity record | [`AUD-SRC-002`](#aud-src-002) |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A later read-only inspection for `BG-PLAN-001` found the same branch and HEAD, but both `Ragasa2026c/v1/manuscript.md` and `manuscript.tex` had new unstaged changes. Only the committed revision is used by the statement-selection packet. The later dirty attribution wording is neither copied nor treated as owner-approved evidence here.

This later observation does not retroactively change the worktree state recorded during the original audit. It records a new dirty-state limitation for subsequent source use.

<a id="aud-src-004"></a>

## `AUD-SRC-004` — Ragasa publication suite inspected files and final-byte SHA-256

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-004` |
| Status | `current` |
| Source class | Publication/manuscript inspection |
| Identity record | [`AUD-SRC-002`](#aud-src-002) |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

These hashes bind the exact publication bytes.

| SHA-256 | Owner-repository path |
|---|---|
| `c8e71adaf9aa9194b65ebb2b610479265befb9356e07a5587bf886a2ba1652f8` | `docs/publications/papers/Ragasa2026a/v3/README.md` |
| `65d838e09fcaf9bb97a16d43fd3a751cf875c974e57c61e9144ed1d1825d0f24` | `docs/publications/papers/Ragasa2026a/v3/claim-and-commitment-inventory.md` |
| `2565cf464adb9da72061cad9a3e42d94834e22455bdce7fbba2cf6452572e340` | `docs/publications/papers/Ragasa2026a/v3/manuscript.tex` |
| `b993c8f35249a3decedd0039f956c15a24ca7ffe11ada0dbb821ece435bb6b42` | `docs/publications/papers/Ragasa2026a/v3/supplementary.tex` |
| `b12ac427ac2e0322e4d5362ee5bd70bec3ea427802f5e3d0dd2156bc0852665b` | `docs/publications/papers/Ragasa2026b/v2/README.md` |
| `d8d5951d8d7ed75355b5d94f37fcbddc70c1466897a5770dbe9f877e60016daf` | `docs/publications/papers/Ragasa2026b/v2/manuscript.tex` |
| `eb83d5f1da16eec66ccc6b18fae96a9d155c563263e163e1d0c5b0fc659eeb9b` | `docs/publications/papers/Ragasa2026b/v2/appendices.tex` |
| `614fad3426a941a9a1c5ad4c73ca917b55007b525a1a3a76970d5d7df5af7d19` | `docs/publications/papers/Ragasa2026b/v2/appendix_proofs.tex` |
| `f2fa27a11936a470130022ba8bdf76fdd6b2e22d9323d13a005c31f9888ddd93` | `docs/publications/papers/Ragasa2026c/v1/README.md` |
| `153992c3567c40c18d48e52897280be49cf4e0b8c2efac562dc0e96a092cabad` | `docs/publications/papers/Ragasa2026c/v1/manuscript.md` |
| `b76cd37c244a0d2ec023fa37449b3e65bd9ae16255917858811be784603e9e0d` | `docs/publications/papers/Ragasa2026c/v1/appendices/A-1-extracted-evidence-boundary.md` |
| `40b4658e2a074fcb75431d10642f689caf54b5671f4d03d793aaadc7c4ded8f2` | `docs/publications/papers/Ragasa2026c/v1/appendices/A-2-d1-p0-g0-isolation-gap-certificate.tex` |

Hashes identify inspected bytes; they do not transfer ownership or evidence into this repository.

<a id="aud-src-005"></a>

## `AUD-SRC-005` — Ragasa2026b projection-source reconciliation reinspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-005` |
| Status | `current` |
| Source class | Publication/manuscript inspection |
| Identity record | [`AUD-SRC-002`](#aud-src-002) |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

On 2026-11-01, the four Ragasa2026b hashes above were reverified read-only with
`git show` at immutable commit `99a46cb59d0c6f27ada7d709f194996ef9619d9f`. The active
owner checkout was then on branch `work/monograph-current-library-capabilities`, ahead of
its upstream and dirty in many unrelated paths. No active-worktree publication bytes were
used, and no owner file, index, branch, worktree, or configuration was changed. This dirty
checkout limits claims about the active owner tree but does not alter the cited immutable
commit bytes.

<a id="aud-src-006"></a>

## `AUD-SRC-006` — Ragasa Paper 3 protocol planning inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-006` |
| Status | `current` |
| Source class | Publication/manuscript inspection |
| Identity record | [`AUD-SRC-002`](#aud-src-002) |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A later read-only planning inspection used a different immutable owner revision:

- owner repository: `ksdft2effmass`;
- branch: `work/paper-3-d1-calculator`;
- commit: `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`;
- protocol path: `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex`;
- protocol SHA-256 at that commit: `160b61b2c2dc87e7628524c710c779f8e3b2c547f0a2d228615300aa06bdce0b`;
- sibling README SHA-256 at that commit: `bf6693582c805aab485b5d3f17b55a6142f8e7adb4a4f7fb8eadb5ff365756dd`.

The worktree was dirty during this inspection: the protocol and sibling README had
uncommitted science-only edits, while the inspected Python implementation matched the
immutable commit. The immutable committed protocol was therefore used for planning. This
later inspection does not replace the publication-source identity or cited-byte hashes
recorded above, and it does not transfer development calculator output into retained
publication evidence.

<a id="aud-src-029"></a>

## `AUD-SRC-029` — Provisional Chapter 9 conjugate-linear coordinate-algebra inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-029` |
| Status | `provisional` |
| Source class | Publication/manuscript inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A later read-only inspection used an active KSD monograph worktree:

- owner repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-silicon-main-package-0matampv`;
- branch: `work/silicon-gram-rank-enclosure`;
- checked-out commit: `dac209a60aec502ae05fe84abd0c5eca23d3b4df`;
- checked-out tree: `99e9a090dcb4a762e7250c9bc616485f674f950b`;
- cited path: `docs/publications/research-monograph/chapters/symmetry-actions-and-represented-subspaces.tex`;
- SHA-256 of inspected bytes: `6618147457500455e6b1c50e788436440622733769b3827b935cb3bb35386b34`;
- dirty-state limitation: 73 short-status entries were present, and the cited Chapter 9 file was
  untracked. The commit and tree therefore identify only the surrounding checkout, not the cited
  file bytes. No Git blob or immutable commit locator is claimed for this file.

The authenticated bytes at lines 208–267 define the conjugate-linear coordinate action
`x ↦ M conjugate(x)`, distinguish antiunitarity from conjugate-linear isometry through bijectivity,
state the algebraic metric equation `M† G_t M = conjugate(G_s)`, retain conjugation in composition
`(M K)(N K) = M conjugate(N)`, and give the independent source/target basis-change formula
`M' = A_t⁻¹ M conjugate(A_s)` with `G'_a = A_a† G_a A_a`. Lines 270–279 provide a `2 × 2`
diagnostic showing that a norm check alone does not detect omission of source-coordinate
conjugation.

`ProjectKoios/BandGauge/Alignment/ConjugateLinearCoordinates.lean` formalizes the source-neutral
finite algebra for arbitrary finite source and target coordinate types, using independently
invertible `Matrix.GeneralLinearGroup` basis matrices. It proves the transformed coordinate action,
preservation of the algebraic metric equation, and the distinct-middle-type composition identity.
The optional `2 × 2` diagnostic is not promoted to a separate named declaration because the generic
basis-change lemma already covers it and the source bytes are not immutable.

This formalization does not infer Hermiticity, positive definiteness, bijectivity, norm
preservation, isometry, or antiunitarity from the algebraic metric equation. It does not formalize
operator covariance, symmetry-sector closure, Wigner theory, runtime residual tolerances, external
matrix authentication, scientific applicability, or publication status. The detailed formula and
nonclaim crosswalk is
[`docs/BandGauge/ksdft2effmass/conjugate-linear-coordinate-algebra-crosswalk.md`](../BandGauge/ksdft2effmass/conjugate-linear-coordinate-algebra-crosswalk.md).
No KSD file, index, branch, worktree, or configuration was modified.
