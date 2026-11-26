# Source audit

This inventory routes provenance questions to stable audit records. Detailed records identify
immutable revisions where available, exact source paths or publication locators, byte hashes,
dirty-state limits, and authority boundaries. They do not transfer source ownership, proof status,
scientific validity, or publication authority.

## Record contract

Every detailed record has a stable `AUD-SRC-*` identifier, status, source class, and authority
boundary. The record body supplies the applicable repository or publication identity, revision,
paths or locators, byte hashes, access mode, dirty-state limitation, Formal use, and nonclaims.
Fields that do not apply to a literature or internal record are intentionally absent rather than
invented.

Status meanings:

- `current`: active provenance evidence at the identity and limitations stated in the record;
- `candidate`: inspected for possible future use but not adopted as authority;
- `provisional`: useful crosswalk evidence whose identity or byte immutability is insufficient for a
  release or publication claim; and
- `internal`: source-neutral derivation recorded without a new external source claim.

Use the declaration manifest for theorem status and the publication crosswalk for publication-facing
claim correspondence. A source record alone establishes neither.

## Record inventory

| Record | Status | Source class | Detailed record |
|---|---|---|---|
| `AUD-SRC-001` — External literature candidate: noncollinear spin-density matrices | `candidate` | Literature and primary-source inspection | [`source-literature.md`](source-literature.md#aud-src-001) |
| `AUD-SRC-002` — Ragasa publication suite final inspected identity | `current` | Publication/manuscript inspection | [`source-publications.md`](source-publications.md#aud-src-002) |
| `AUD-SRC-003` — Ragasa publication suite later attribution reinspection | `current` | Publication/manuscript inspection | [`source-publications.md`](source-publications.md#aud-src-003) |
| `AUD-SRC-004` — Ragasa publication suite inspected files and final-byte SHA-256 | `current` | Publication/manuscript inspection | [`source-publications.md`](source-publications.md#aud-src-004) |
| `AUD-SRC-005` — Ragasa2026b projection-source reconciliation reinspection | `current` | Publication/manuscript inspection | [`source-publications.md`](source-publications.md#aud-src-005) |
| `AUD-SRC-006` — Ragasa Paper 3 protocol planning inspection | `current` | Publication/manuscript inspection | [`source-publications.md`](source-publications.md#aud-src-006) |
| `AUD-SRC-007` — Periodic1D Architecture v3 centered-even convention inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-007) |
| `AUD-SRC-008` — KSD 2-D/3-D complete metric-shell protocol inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-008) |
| `AUD-SRC-009` — Rank-two unitary-conjugation band-invariance statement selection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-009) |
| `AUD-SRC-010` — Normalized product-torus factorization statement selection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-010) |
| `AUD-SRC-011` — Zeroth-Bessel integral proof provenance and local-port selection | `current` | Library or internal proof provenance | [`source-library-provenance.md`](source-library-provenance.md#aud-src-011) |
| `AUD-SRC-012` — Harmonic-oscillator computational crosswalk inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-012) |
| `AUD-SRC-013` — PIAB1D computational crosswalk inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-013) |
| `AUD-SRC-014` — Symbolic finite-barrier scope | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-014) |
| `AUD-SRC-015` — PhysKit FCC--Bain coordinate-bridge inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-015) |
| `AUD-SRC-016` — Calculation-support and finite-folding inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-016) |
| `AUD-SRC-017` — Tetrahedral `sp³s⋆` algebra inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-017) |
| `AUD-SRC-018` — Rank-one analytical-oracle inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-018) |
| `AUD-SRC-019` — Finite periodic gauge-loop inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-019) |
| `AUD-SRC-020` — Complex-unitary right-Procrustes inspection | `current` | Literature and primary-source inspection | [`source-literature.md`](source-literature.md#aud-src-020) |
| `AUD-SRC-021` — Finite Fourier least-squares motivation | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-021) |
| `AUD-SRC-022` — Finite periodic-lattice matrix least-squares applicability | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-022) |
| `AUD-SRC-023` — Finite periodic-lattice onsite/nononsite power partition | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-023) |
| `AUD-SRC-024` — Provisional Periodic2D/3D rank-N analytic-parent crosswalk | `provisional` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-024) |
| `AUD-SRC-025` — Provisional Periodic2D/3D rank-N exact gauge-construction crosswalk | `provisional` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-025) |
| `AUD-SRC-026` — Source-neutral integer lattice radius bridge | `internal` | Library or internal proof provenance | [`source-library-provenance.md`](source-library-provenance.md#aud-src-026) |
| `AUD-SRC-027` — KSD five-stage matrix/frame binding lifecycle source | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-027) |
| `AUD-SRC-028` — KSD mathematical implementation backlog inspection | `current` | Owner-repository or computational-contract inspection | [`source-owner-repositories.md`](source-owner-repositories.md#aud-src-028) |
| `AUD-SRC-029` — Provisional Chapter 9 conjugate-linear coordinate-algebra inspection | `provisional` | Publication/manuscript inspection | [`source-publications.md`](source-publications.md#aud-src-029) |
| `AUD-SRC-030` — Scalar DFT and PAW primary-source acquisition | `provisional` | Literature and primary-source inspection | [`source-literature.md`](source-literature.md#aud-src-030) |

## Maintenance

- Add a new record ID; never recycle an existing ID.
- Preserve superseded records and mark them `historical` rather than silently rewriting their byte
  identity.
- Refresh provisional records against immutable owner commits before release or publication use.
- Keep detailed validation commands and build results in `trusted-base-audit.md` or
  `validation-history.md`, not in this provenance inventory.
