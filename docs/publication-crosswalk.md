# Publication-to-formalization crosswalk

All source locations below are in `ksdft2effmass`, branch `work/paper-3-higher-rank-extension`, commit `99a46cb59d0c6f27ada7d709f194996ef9619d9f`. “Paper proof” means a mathematical argument in publication prose; it does **not** mean Lean-checked proof. Most rows map only to metadata placeholders; the Ragasa2026C witness/separation row has the explicitly limited foundational formalization recorded below.

## Ragasa2026A ↔ `Ragasa2026a/v3`

Primary audit ledger: `claim-and-commitment-inventory.md`, especially analytic entries A01–A12 and numerical entries N01–N23. Formal target: `ProjectKoios.BandGauge.Papers.Ragasa2026A.placeholder`.

| Publication declaration/location | Source status | Lean status |
|---|---|---|
| “Exact loss geometry,” `manuscript.tex:663` | theorem with paper proof; rank-two/positive-weight/global-real-rotation assumptions | placeholder; no statement |
| Reduced scalar loss formulas and irreducible operator floor, `manuscript.tex:663` | consequences of the exact-loss quadratic; operator-set negative-radicand condition follows in the next subsection | `BG-DEF-005` through `BG-DEF-008` implemented and `BG-THM-009` through `BG-THM-013` proved; matrix-residual derivation and the matrix-level `|b| ≤ κ` bound remain open |
| “Compatibility and exact full-ellipse distance,” `manuscript.tex:737` | corollary with containment and real-radius premises | placeholder; no statement |
| “Exact spectral pass with certified operator incompatibility,” `manuscript.tex:857` | constructed proposition for fixed observations, box, and thresholds | placeholder; no statement |
| “Smooth monotone threshold continuum,” `manuscript.tex:925` | corollary for the stated flat rank-two Bessel family and amplitude interval | placeholder; no statement |
| “Operator residual equals induced nonlocal hopping weight,” `manuscript.tex:1024` | theorem under flat traceless parent and matched real-rotation-family assumptions | placeholder; no statement |
| “Attainment, transported-frame covariance, and excess,” `supplementary.tex:202` | limited paper proposition; explicitly not the MLWF spread decomposition | placeholder; no statement |

The ledger labels dispersive homotopy, finite-mesh hopping, truncation, and range-inflation outputs as development calculations, not continuum certificates or retained evidence. The separate scalar retained precursor does not transfer status to the active rank-two experiment. Open gates, tolerances, provenance freeze, retained execution, and verification remain external obligations.

## Ragasa2026B ↔ `Ragasa2026b/v2`

Primary source: `manuscript.tex`; v2 says it preserves v1 mathematics and scope. Formal target: `ProjectKoios.BandGauge.Papers.Ragasa2026B.placeholder`.

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

| Publication declaration/location | Source status | Lean status |
|---|---|---|
| “Witnesses and certified separation,” `manuscript.md:132` | proposition with elementary paper proof; failed search proves nothing; compactness is required for the stated attainment conclusion | generic mathematical clauses and representation bridge formalized: `BG-DEF-001/002` and `BG-THM-001` through `BG-THM-006`; no paper-namespace instantiation |
| Spectral and aligned-operator admissible-set definitions, `manuscript.md:117` | two loss sublevel sets in one candidate parameter domain | threshold form implemented as `BG-DEF-003/004`; `BG-THM-007/008` prove the joint-witness and certified-separation consequences; concrete loss formulas and certificates remain external |
| “Exact D1 representation certificates,” `manuscript.md:547` | proposition with paper proof for the selected continuum Fourier/P0 construction | placeholder; no statement |
| D1 exterior-isolation and attack-angle derivations, `appendices/A-2-d1-p0-g0-isolation-gap-certificate.tex` | analytic formulas; accompanying finite grid is explicitly only a sanity check | placeholder; no checked certificate |
| M2/M3, rank-three, and Wannier90 records, `appendices/A-1-extracted-evidence-boundary.md` | bounded historical/extracted numerical evidence with listed nonclaims | outside Lean; external numerical obligations |

Paper 3 remains pre-results for the new higher-rank campaign: the selected D1 P0/G0 protocol has no implementation, run, result, retained evidence package, submission, or publication asserted by the source. Its exact prose certificates do not establish numerical convergence, locality, or scientific acceptance.

## Residual assumptions and unresolved work

The proved generic and reduced-scalar declarations do not encode the full matrix-residual loss derivation, concrete thresholds, admissible alignment construction, or numerical claims. Any later statement must preserve the source's rank, dimension, positivity, compactness, support, gauge/alignment family, Fourier convention, parameter-domain, and numerical-boundary premises exactly. Later clauses remain separate statement and source-fidelity tasks.
