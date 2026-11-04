# Documentation

These files record policy, provenance, status, and plans. They do not establish theorem or evidence status by themselves.

## Authoritative ledgers

Five ledgers control status and provenance.

- `theorem-manifest.md`: declarations and proof status.
- `source-audit.md`: inspected source identities and byte hashes.
- `publication-crosswalk.md`: source claims and formalization mapping.
- `trusted-base-audit.md`: audit requirements and recorded checks.
- `dependency-audit.md`: Lean, Mathlib, and Physlib evaluation.

## Policy

Policy files define evidence and workflow boundaries.

- `authority-boundaries.md`: proof, certificate, numerical, and runtime authority.
- `formal-vs-numerical-evidence.md`: permitted bridges and prohibited status transfers.
- `certificates.md`: certificate classes and lifecycle.
- `BandGauge/publication-evidence-contract.md`: publication-package acceptance requirements.
- `reference-crosswalk-policy.md`: literature identity and relation policy.
- `conventions.md`: required theorem-family conventions.
- `agent-workflow.md`: bounded development and promotion procedure.

## Derived audit views

Derived audit views inspect existing formal state without changing theorem or evidence status.

- `declaration-dependency-graph.md`: optional non-building graph generation from an already validated compiled audit environment.

## Architecture and planning

Planning files organize work without changing formal status.

- `effort-portfolio.md`: active, ready, blocked, deferred, and completed work.
- `module-layout.md`: semantic ownership and import direction.
- `definition-and-lemma-inventory.md`: implemented and candidate mathematics.
- `roadmap.md`: dependency-ordered future work.
- `ecosystem-architecture.md`: repository boundaries.
- `BandGauge/ksdft2effmass/mathematical-representation-class-architecture-plan.md`: verification-side recommendation for owner-controlled computational representation classes and certificate boundaries.
- `BandGauge/ksdft2effmass/authenticated-external-matrix-frame-binding-contract.md`: candidate fail-closed contract for binding immutable external matrices, frames, bases, meshes, and conventions to exact theorem-application profiles without treating runtime arrays as formal evidence.
- `BandGauge/ksdft2effmass/finite-fourier-least-squares-crosswalk.md`: immutable-source motivation and applicability boundary for exact finite-abelian truncation optimality.
- `BandGauge/ksdft2effmass/finite-periodic-lattice-matrix-least-squares-crosswalk.md`: explicit periodic 1-D/2-D/3-D and arbitrary-rank lattice least-squares and onsite/nononsite power-partition layers, immutable source locators, and remaining owner-specific bindings.
- `BandGauge/ksdft2effmass/finite-rank-analytic-parent-crosswalk.md`: provisional exact-mathematics crosswalk for the Periodic2D/3D rank-N parent formulas, with dirty-source limitations and runtime nonclaims.
- `BandGauge/ksdft2effmass/exact-gauge-construction-crosswalk.md`: provisional exact-mathematics crosswalk for the Periodic2D/3D rank-N construction `F'=F₀G`, `H'=GᴴDG`, and known inverse `Gᴴ`.
- `BandGauge/ksdft2effmass/lattice-shell-radius-crosswalk.md`: source-neutral bridge from exact square, triangular, simple-cubic, and normalized FCC squared indices to subadditive integer-lattice radii, with the finite-character quotient seam left explicit.
- `ksdft2effmass-calculations-formal-support-inventory.md`: calculation-to-formal-support assessment.
- `witness-catalog.md`: candidate exact examples.
- `BandGauge/Geometry/witness-separation-statement-selection.md`: `BG-PLAN-001` decision record.
- `BandGauge/higher-rank-composite-band-formalization-plan.md`: higher-rank D1 plan.
- `BandGauge/Papers/`: series and per-paper plans.
- `BandGauge/Papers/Ragasa2026A/diagnostic-mathematical-specification.md`: proposed mathematical semantics for the Paper A diagnostic registry.
- `BandGauge/Papers/Ragasa2026A/diagnostic-python-interface-recommendation.md`: owner-side diagnostic naming and immutable-record recommendation.
- `papers/`: Formal-owned, publication-quality proof companions and their publication boundaries.
- `SolidState/TightBinding/vogl-sp3s-star-formalization.md`: Vogl exact-algebra scope.

## Structural migrations

- `migrations/fourier-domain-hierarchy.md`: complete stable-ID crosswalk from the former flat Fourier namespace to the `FiniteAbelian`, `Gauge`, `Support`, `Torus`, and `Residual` families.

## Related indexes

These indexes point to explanatory material.

- `../proofs/README.md`: proof-dossier policy.
- `papers/README.md`: Formal-owned proof-companion policy and index.
- `../papers/README.md`: legacy synthesis-manuscript policy.
- Module README files: local scope and exclusions.

## Status terms

Status terms have fixed meanings.

- **metadata:** traceability only.
- **planned:** no declaration exists.
- **implemented:** a declaration exists.
- **proved:** Lean accepts the declaration without admissions and the audit record exists.
- **blocked:** a required source, convention, dependency, or authority decision is unresolved.

Only `theorem-manifest.md` assigns formal status.
