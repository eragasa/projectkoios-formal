# Documentation

These files record policy, provenance, status, and plans. They do not establish theorem or evidence status by themselves.

## Authoritative ledgers

Five ledgers control status and provenance.

- `theorem-manifest.md`: declarations and proof status.
- `audit/source-audit.md`: stable source-record inventory; detailed identities and byte hashes are
  split across the linked `audit/source-*.md` records.
- `publication-crosswalk.md`: source claims and formalization mapping.
- `audit/trusted-base-audit.md`: audit requirements and current recorded checks;
  `audit/validation-history.md` preserves older tranche evidence.
- `audit/dependency-audit.md`: Lean, Mathlib, and Physlib evaluation.

The audit directory is indexed at [`audit/index.md`](audit/index.md).

## Policy

Policy files define evidence and workflow boundaries.

- `authority-boundaries.md`: proof, certificate, numerical, and runtime authority.
- `formal-vs-numerical-evidence.md`: permitted bridges and prohibited status transfers.
- `certificates.md`: certificate classes and lifecycle.
- `BandGauge/publication-evidence-contract.md`: publication-package acceptance requirements.
- `reference-crosswalk-policy.md`: literature identity and relation policy.
- `conventions.md`: required theorem-family conventions.
- `lean-code-standards.md`: Lean module and declaration documentation standards.
- `agent-workflow.md`: bounded development and promotion procedure.

## Derived audit views

Derived audit views inspect existing formal state without changing theorem or evidence status.

- `audit/declaration-dependency-graph.md`: optional non-building graph generation from an already validated compiled audit environment.
- `api-maps/quantum-mechanics-operators.md`: declaration-level overlap and gap map for Project Koios test-space operators and the adopted Physlib operator stack.
- `api-maps/continuum-schrodinger.md`: adopted `SpaceDQuantumSystem` carrier, Sobolev and multiplication APIs, Schwartz-core and singular hydrogenic Hamiltonian bridges, and self-adjointness gates.

## Architecture and planning

Planning files organize work without changing formal status.

- `effort-portfolio.md`: active, ready, blocked, deferred, and completed work.
- `module-layout.md`: semantic ownership and import direction.
- `definition-and-lemma-inventory.md`: implemented and candidate mathematics.
- `roadmap.md`: dependency-ordered future work.
- `architecture/index.md`: co-located Lean, Rust, Mojo, and Python verification-sidecar architecture, language authority, and current implementation status.
- `architecture/repo-layout.md`: target source, fixture, manifest, dependency-direction, and cross-language completion layout.
- `ecosystem-architecture.md`: repository boundaries.
- `BandGauge/ksdft2effmass/mathematical-representation-class-architecture-plan.md`: verification-side recommendation for owner-controlled computational representation classes and certificate boundaries.
- `BandGauge/ksdft2effmass/authenticated-external-matrix-frame-binding-contract.md`: candidate fail-closed contract for binding immutable external matrices, frames, bases, meshes, and conventions to exact theorem-application profiles without treating runtime arrays as formal evidence.
- [`../specification/certificates/exact-direct-matrix/`](../specification/certificates/exact-direct-matrix/index.md): source-neutral Formal-owned v1 and v2 exact direct-matrix certificate schemas.
- `BandGauge/ksdft2effmass/exact-synthetic-direct-matrix-pilot-plan.md`: KSD-facing motivation, ownership crosswalk, implementation gates, and nonclaims; it does not own schema bytes.
- `BandGauge/ksdft2effmass/finite-fourier-least-squares-crosswalk.md`: immutable-source motivation and applicability boundary for exact finite-abelian truncation optimality.
- `BandGauge/ksdft2effmass/finite-periodic-lattice-matrix-least-squares-crosswalk.md`: explicit periodic 1-D/2-D/3-D and arbitrary-rank lattice least-squares and onsite/nononsite power-partition layers, immutable source locators, and remaining owner-specific bindings.
- `BandGauge/ksdft2effmass/finite-rank-analytic-parent-crosswalk.md`: provisional exact-mathematics crosswalk for the Periodic2D/3D rank-N parent formulas, with dirty-source limitations and runtime nonclaims.
- `BandGauge/ksdft2effmass/exact-gauge-construction-crosswalk.md`: provisional exact-mathematics crosswalk for the Periodic2D/3D rank-N construction `F'=F₀G`, `H'=GᴴDG`, and known inverse `Gᴴ`.
- `BandGauge/ksdft2effmass/conjugate-linear-coordinate-algebra-crosswalk.md`: provisional Chapter 9 crosswalk for conjugate-linear basis change, algebraic metric compatibility, and composition, with the untracked dirty-source limitation explicit.
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

## Structural migrations and tasks

- `migrations/fourier-domain-hierarchy.md`: complete stable-ID crosswalk from the former flat Fourier namespace to the `FiniteAbelian`, `Gauge`, `Support`, `Torus`, and `Residual` families.
- `tasks/lean-docstrings-update/`: module-by-module checklist for migration to the Lean documentation standard.

## User guide

- `user-guide/index.md`: local environment guidance.
- `user-guide/installation/index.md`: audit-first Lean, Rust, Mojo, Python, platform, and Gate 0 installation qualification.

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
