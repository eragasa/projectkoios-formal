# Publication-to-formalization crosswalk

Unless a later planning inspection is explicitly identified, all source locations below are in `ksdft2effmass`, branch `work/paper-3-higher-rank-extension`, commit `99a46cb59d0c6f27ada7d709f194996ef9619d9f`. “Paper proof” means a mathematical argument in publication prose; it does **not** mean Lean-checked proof. Most rows map only to metadata placeholders; the Ragasa2026C witness/separation row has the explicitly limited foundational formalization recorded below. Standard quantum, solid-state, Bloch, trace, and unitary-invariance facts are supporting dependencies rather than paper contributions; their presence in foundational modules carries no novelty claim.

## Ragasa2026A ↔ `Ragasa2026a/v3`

Primary audit ledger: `claim-and-commitment-inventory.md`, especially analytic entries A01–A12 and numerical entries N01–N23. Aggregate formal status: `ProjectKoios.BandGauge.Papers.Ragasa2026A.summary`. Five modules under `ProjectKoios.BandGauge.Papers.Ragasa2026A` record twenty-eight proved conditional statements and six exact source-specific construction statements. The latter establish three analytic conclusions and one exact checked analytic certificate for the two-observation false positive; they do not establish a calculated four-state-parent result, runtime evidence, material validation, or publication completion. The proposed scientific plan is [`BandGauge/Papers/Ragasa2026A/paper-and-proof-plan.md`](BandGauge/Papers/Ragasa2026A/paper-and-proof-plan.md), and the prospective mathematical and computational study of every diagnostic family is [`BandGauge/Papers/Ragasa2026A/diagnostic-usefulness-study-plan.md`](BandGauge/Papers/Ragasa2026A/diagnostic-usefulness-study-plan.md). These plans do not change declaration status.

| Publication declaration/location | Source status | Lean status |
|---|---|---|
| Weighted Frobenius operator loss, `manuscript.tex:575` and `manuscript.tex:599` | finite weighted sum of retained-matrix Frobenius residuals | generic residual-ball geometry is `BG-HILBERT-DEF-001/002` and `BG-HILBERT-THM-001` through `BG-HILBERT-THM-004`; the rank-two coefficient, entrywise residual, real correlation, Cauchy–Schwarz, unitary invariance, polarization, traceless-identity orthogonality, operator residual expansion, and scalar aligned-loss bridge are `BG-HILBERT-DEF-003` through `BG-HILBERT-DEF-008` and `BG-HILBERT-THM-005` through `BG-HILBERT-THM-013`; `BG-BLOCH-DEF-006` through `BG-BLOCH-DEF-011` and `BG-BLOCH-THM-003` through `BG-BLOCH-THM-011` supply abstract supporting infrastructure; `BG-RAGASA2026A-DEF-001` through `BG-RAGASA2026A-DEF-004` and `BG-RAGASA2026A-THM-001` through `BG-RAGASA2026A-THM-004` instantiate the source's strict-positive weights, global real rotation, momentum-dependent comparison field, correlation, and operator-loss bridge conditionally; construction from a periodic potential and concrete publication data remain open |
| Weighted spectral loss, `manuscript.tex:568` | finite weighted sum of two retained-state residuals | the generic finite spectral layer is `BG-HILBERT-DEF-009` through `BG-HILBERT-DEF-012` and `BG-HILBERT-THM-014/015`; `BG-RAGASA2026A-DEF-005/006` define the exact witness interface and splitting field, while `BG-RAGASA2026A-THM-005` through `BG-RAGASA2026A-THM-007` prove its bridges; `BG-RAGASA2026A-DEF-015` and `BG-RAGASA2026A-THM-018` through `BG-RAGASA2026A-THM-020` construct and instantiate the witness canonically using the finite-dimensional Hermitian spectral theorem; no floating-point eigensolver, numerical eigenvalue certificate, ordering claim, continuity, periodic-potential construction, or concrete data are supplied |
| Correlation harmonic and continuous maximum, `manuscript.tex:626–659` | exact Pauli-coordinate formula, value `bmax = b₀ + √(c²+d²)`, and canonical angle reduced to `[-π/2,π/2)` | standard supporting algebra/analysis is `BG-FOUNDATION-DEF-002` through `BG-FOUNDATION-DEF-009` and `BG-FOUNDATION-THM-001` through `BG-FOUNDATION-THM-007`; exact paper coefficients and conditional results are `BG-RAGASA2026A-DEF-007` through `BG-RAGASA2026A-DEF-014` and `BG-RAGASA2026A-THM-008` through `BG-RAGASA2026A-THM-017`, including canonical Pauli extraction and the matrix-loss bridge centered at `μmax`; no concrete matrix data or uniqueness in the degenerate case is claimed |
| “Exact loss geometry,” `manuscript.tex:663` | theorem with paper proof; rank-two/strict-positive-weight/global-real-rotation assumptions | operator and spectral field bridges are `BG-RAGASA2026A-DEF-001` through `BG-RAGASA2026A-DEF-015` and `BG-RAGASA2026A-THM-001` through `BG-RAGASA2026A-THM-020`; canonical real losses and their optimized full-plane and candidate-rectangle admissible-set geometry are `BG-RAGASA2026A-DEF-016` through `BG-RAGASA2026A-DEF-021` and `BG-RAGASA2026A-THM-021` through `BG-RAGASA2026A-THM-026`; rectangle conclusions retain explicit full-ellipse containment; “optimized” denotes evaluation at the correlation-maximizing angle and does not assert all-real-`λ` angle minimization outside the source's positive candidate domain; periodic-potential construction, concrete data, and scientific hypotheses remain open |
| Reduced scalar loss formulas and irreducible operator floor, `manuscript.tex:663` | consequences of the exact-loss quadratic; operator-set negative-radicand condition follows in the next subsection | `BG-DEF-005` through `BG-DEF-014` and `BG-THM-009` through `BG-THM-030` cover scalar geometry; `BG-HILBERT-THM-011` through `BG-HILBERT-THM-015` derive both scalar losses from abstract finite residuals; `BG-RAGASA2026A-THM-004/007` supply conditional exact operator and spectral field bridges, and `BG-RAGASA2026A-THM-008` through `BG-RAGASA2026A-THM-017` supply canonical Pauli extraction, conditional continuous correlation optimization, and the matrix-loss bridge centered at `μmax`; concrete matrix/eigenvalue data, numerical certificates, and periodic-potential construction remain open |
| “Compatibility and exact full-ellipse distance,” `manuscript.tex:737` | corollary with containment and real-radius premises | reusable full-plane geometry is `BG-THM-025` and `BG-THM-029`; `BG-DEF-015` through `BG-DEF-017` and `BG-THM-031` through `BG-THM-034` provide containment-based rectangle transfer; `BG-RAGASA2026A-DEF-016` through `BG-RAGASA2026A-DEF-021` and `BG-RAGASA2026A-THM-021` through `BG-RAGASA2026A-THM-026` instantiate the actual canonical Paper A loss sets, intersection criteria, and distances; concrete thresholds and numerical containment verification remain external |
| “Exact spectral pass with certified operator incompatibility,” `manuscript.tex:851–889` | constructed proposition for two equally weighted observations, fixed matrices/rotations, box, and thresholds | `BG-CERT-DEF-001` through `BG-CERT-DEF-013` and `BG-CERT-THM-001` through `BG-CERT-THM-008` provide exact rational-center and rational-enclosure checkers; `BG-CERT-THM-009` proves `7/10 < 1 / √2 < 71/100`; `BG-RAGASA2026A-THM-027/028` provide conditional bridges; `BG-RAGASA2026A-DEF-022` through `BG-RAGASA2026A-DEF-024` and `BG-RAGASA2026A-THM-029` through `BG-RAGASA2026A-THM-034` encode the equal weights, centered `σ_z` parent, `R(0)` and `R(π/4)` comparison alignments, exact power and `μmax`, accepted rational enclosure certificate, zero-loss witness `(0,1)`, disjoint pass sets, the exact positive closed-form distance, and the separation-resolution corollary. It is not runtime output, a parser result, a calculated four-state-parent claim, material validation, or a continuum claim. |
| “Smooth monotone threshold continuum,” `manuscript.tex:925` | corollary for the stated flat rank-two Bessel family and amplitude interval | placeholder; no statement |
| “Operator residual equals induced nonlocal hopping weight,” `manuscript.tex:1024` | theorem under flat traceless parent and matched real-rotation-family assumptions | placeholder; no statement |
| “Attainment, transported-frame covariance, and excess,” `supplementary.tex:202` | limited paper proposition; explicitly not the MLWF spread decomposition | placeholder; no statement |

The ledger labels dispersive homotopy, finite-mesh hopping, truncation, and range-inflation outputs as development calculations, not continuum certificates or retained evidence. The separate scalar retained precursor does not transfer status to the active rank-two experiment. Open gates, tolerances, provenance freeze, retained execution, and verification remain external obligations.

## Ragasa2026B ↔ `Ragasa2026b/v2`

Primary source: `manuscript.tex`; v2 says it preserves v1 mathematics and scope. Formal target: `ProjectKoios.BandGauge.Papers.Ragasa2026B.placeholder`. The proposed scientific, evidence, and semantic proof-dependency plan is [`BandGauge/Papers/Ragasa2026B/paper-and-proof-plan.md`](BandGauge/Papers/Ragasa2026B/paper-and-proof-plan.md); it does not instantiate the placeholder.

| Publication declaration/location | Source status | Lean status |
|---|---|---|
| “Spectral projection can destroy finite hopping support,” `manuscript.tex:316` | proposition with paper proof in Appendix A | placeholder; no statement |
| “Multidimensional flat-parent residual--locality identity,” `manuscript.tex:410` | theorem for stated `d ∈ {2,3}`, flat-parent, rotation, and amplitude assumptions | placeholder; no statement |
| “Shell-resolved coefficients and factorial Fourier-tail bound,” `manuscript.tex:450` | theorem with explicit shell-cap premise and paper proof | placeholder; no statement |
| “Monotonicity and the small-amplitude dimension law,” `manuscript.tex:507` | corollary under the orthogonal flat-parent assumptions | placeholder; no statement |
| “Bond-orbit flat-parent comparator,” `manuscript.tex:625` | theorem for a declared finite bond inventory and fixed symmetry weights | placeholder; no statement |
| “Constrained-series complete-shell tail certificate,” `manuscript.tex:677` | analytic conditional theorem; later binary64 evaluations are numerical applications, not exact formal certificates | placeholder; no statement |

Finite meshes and strain samples do not establish continuum extrema. Graphene-/silicon-inspired controls are not material parametrizations. The source explicitly separates its exact analytic comparators from replaceable development calculations and unexecuted hierarchy designs.

## Ragasa2026C ↔ `Ragasa2026c/v1`

Primary source: `manuscript.md`; boundary detail in `appendices/`. Formal target: `ProjectKoios.BandGauge.Papers.Ragasa2026C.placeholder`.

A later read-only planning inspection used branch `work/paper-3-d1-calculator`, immutable
commit `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`, and the committed higher-rank D1 protocol.
That protocol supports the source-audited planning documents
[`BandGauge/higher-rank-composite-band-formalization-plan.md`](BandGauge/higher-rank-composite-band-formalization-plan.md)
and
[`BandGauge/Papers/Ragasa2026C/paper-and-proof-plan.md`](BandGauge/Papers/Ragasa2026C/paper-and-proof-plan.md).
It does not replace the publication-source revision, instantiate the Paper C Lean
namespace, or promote schema-free development output to retained evidence.

| Publication declaration/location | Source status | Lean status |
|---|---|---|
| “Witnesses and certified separation,” `manuscript.md:132` | proposition with elementary paper proof; failed search proves nothing; compactness is required for the stated attainment conclusion | generic mathematical clauses and representation bridge formalized: `BG-DEF-001/002` and `BG-THM-001` through `BG-THM-006`; no paper-namespace instantiation |
| Spectral and aligned-operator admissible-set definitions, `manuscript.md:117` | two loss sublevel sets in one candidate parameter domain | threshold form implemented as `BG-DEF-003/004`; `BG-THM-007/008` prove the joint-witness and certified-separation consequences; concrete loss formulas and certificates remain external |
| Periodic frames, aligned operator fields, and reciprocal-boundary sewing, `manuscript.md:27` and `manuscript.md:87` | equal-rank periodic-frame and alignment contract; sewing diagnostics are not topology claims | abstract pointwise group-action adaptation implemented as `BG-BLOCH-DEF-001` through `BG-BLOCH-DEF-005`; `BG-BLOCH-THM-001/002` prove preservation of section and operator sewing; the finite rank-two sample structure in `BG-BLOCH-DEF-008` composes with this contract but does not construct a Bloch family from a potential; quotient-torus, regularity, and integration layers remain open |
| “Exact D1 representation certificates,” `manuscript.md:547` | proposition with paper proof for the selected continuum Fourier/P0 construction | placeholder; no statement |
| D1 exterior-isolation and attack-angle derivations, `appendices/A-2-d1-p0-g0-isolation-gap-certificate.tex` | analytic formulas; accompanying finite grid is explicitly only a sanity check | placeholder; no checked certificate |
| M2/M3, rank-three, and Wannier90 records, `appendices/A-1-extracted-evidence-boundary.md` | bounded historical/extracted numerical evidence with listed nonclaims | outside Lean; external numerical obligations |

Paper 3 remains pre-results for the new higher-rank campaign: the selected D1 P0/G0 protocol has no implementation, run, result, retained evidence package, submission, or publication asserted by the source. Its exact prose certificates do not establish numerical convergence, locality, or scientific acceptance.

## Controlled model systems — not publication claims

The QHO1D and PIAB1D modules are exact, source-neutral controlled-model mathematics motivated by
the owner repository's calculation packages. They are not mapped to a Ragasa2026 publication
claim. For PIAB1D, the formalized tranche covers compression algebra, additive decomposition
nonuniqueness, finite Frobenius model-class fits, the centered Dirichlet stencil, cyclic corner
support, complex translation characters, antisymmetric/sine-normalized Dirichlet modes, canonical
phases `exp(i kπ/(N+1))`, real representability, and the exact finite-matrix eigenvalue
`2-2 cos(kπ/(N+1))`. See `docs/source-audit.md` for the dirty-worktree crosswalk limitation.
No retained numerical result, observed convergence order, runtime eigensolver claim, continuum
spectral completeness claim, or publication status follows.

## Series planning beyond the current crosswalk

The proposed division of Ragasa2026A–D is recorded in
[`BandGauge/Papers/ragasa-series-research-plan.md`](BandGauge/Papers/ragasa-series-research-plan.md).
The possible first-principles continuation is described separately in
[`BandGauge/Papers/Ragasa2026D/paper-and-proof-plan.md`](BandGauge/Papers/Ragasa2026D/paper-and-proof-plan.md).
These documents are planning only. In particular, Ragasa2026D has no audited publication
source, canonical source key, Lean namespace, or paper-specific claim in this repository.

## Residual assumptions and unresolved work

The proved declarations include abstract finite operator and spectral residual-loss derivations, but do not identify their fields with scientific source data or encode concrete thresholds, admissible alignment construction, or numerical claims. Any later statement must preserve the source's rank, dimension, positivity, compactness, support, gauge/alignment family, Fourier convention, parameter-domain, and numerical-boundary premises exactly. Later clauses remain separate statement and source-fidelity tasks.
