<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial recommendation completed: 2026-11-04
-->

# Authenticated external matrix and frame binding contract recommendation

## Status and authority boundary

Candidate contract identifier: `PKF-EXTERNAL-MATRIX-FRAME-BINDING/CANDIDATE-1`.

This document is a Formal-owned design recommendation. It is not a frozen wire schema, parser,
checker implementation, checked certificate, runtime result, scientific validation, evidence
promotion, or authorization to modify an owner repository. The candidate identifier must not be
used as though it were an accepted production version.

The recommendation defines what a future fail-closed binding must establish before selected
external matrices or frames may instantiate exact `projectkoios-formal` theorems. It deliberately
keeps three things separate:

1. a generic authenticated binding from immutable bytes to explicitly represented finite objects;
2. a proposition-specific Formal theorem-application profile; and
3. an owner-specific request/result schema, producer, serializer, verifier, and retained artifact.

Formal owns the first two meanings and any Lean checker and soundness theorem. The computational
owner owns the third. `ksdft2effmass`, Quantum ESPRESSO, Wannier90, NumPy, SciPy, and their file
formats do not become Lean runtime dependencies.

No current KSD, DFT, or Wannier90 output satisfies this candidate contract. The checked
runtime-certificate count remains zero.

## Recommendation

Adopt a two-layer, content-addressed boundary:

- **binding envelope:** authenticates immutable source bytes and constructs exact finite index,
  scalar, matrix, frame, basis, mesh, and convention objects without hidden defaults; and
- **theorem-application profile:** selects one exact Formal theorem family, checks every premise,
  derives rather than trusts theorem inputs, and emits a bounded checked conclusion.

Do not begin with a general DFT or Wannier90 importer. The first implementation, if separately
authorized, should be a compact exact synthetic fixture using the direct Hermitian-pair profile.
A frame-compression fixture may follow with exact coordinate frames and an exact permutation or
signed-permutation unitary. Real floating DFT or Wannier90 data must wait for a separately proved
outward-enclosure bridge; an interval around an array is not by itself a proof that the exact
orthonormal-frame hypotheses hold.

## Governing boundaries

This recommendation refines, but does not replace:

- [`../../formal-vs-numerical-evidence.md`](../../formal-vs-numerical-evidence.md);
- [`../../authority-boundaries.md`](../../authority-boundaries.md);
- [`../../certificates.md`](../../certificates.md);
- [`../publication-evidence-contract.md`](../publication-evidence-contract.md);
- [`../../ecosystem-architecture.md`](../../ecosystem-architecture.md); and
- [`mathematical-representation-class-architecture-plan.md`](mathematical-representation-class-architecture-plan.md).

A numerical-to-formal bridge still requires an exact proposition, certificate model,
unambiguous parser, checker, checker-soundness theorem, bound input identity, and explicit
rounding, interval, discretization, and model assumptions. This document supplies a recommended
logical contract only.

## Inspected design sources

The exact ordered-spectrum theorem interface is owned by this repository at commit
`212441600f27d5b31ead4ca5ccac0d3817d4a40b`, tree
`056eb529380e7d4457fa3e9c5ab0b7c6c8e897ab`.

The five-stage computational lifecycle was inspected read-only from:

- repository: `ksdft2effmass`;
- branch: `work/si-right-handed-kpoint`;
- commit: `b0af45f4eea97ee41eb0e2ae23a35a986a6c6e78`;
- tree: `3b5e66c797d0ffa1fa1ad9d9a6d3f603f243f4c3`;
- path: `calculations/periodic1d/rank2/band-equivalence-versus-hopping-locality/protocol.md`;
- Git blob: `cfebcdfdb0d3d8316f38b0383d42642e2fbf3cd7`;
- SHA-256 of commit bytes: `aabe8c6e005e6605ca4e2fec7103985f1ad303d2f41ff76fce1bbd4867aa74e4`;
- worktree state during inspection: clean.

The broader KSD mathematical backlog inspection remains the immutable but dirty-checkout-limited
source record already listed in `docs/source-audit.md`: commit
`4835e7bf9161729cc8f0537bcc13db083896a6ae`, tree
`fd641fb8a4efe7a5ef4d5da9c49f126e1e03e355`, with 112 short-status entries. Its specifically
hashed commit blobs motivated the required KSD, Fourier, and Wannier90 adapter fields; dirty bytes
were not treated as evidence.

An owner-side implementation must re-audit a selected clean immutable source revision. This
document does not adopt any uncommitted owner bytes.

## What “authenticated” means here

Authentication in this contract means that the checker binds a declared identity and semantics to
specific immutable bytes and rejects substitution, drift, or ambiguity. SHA-256 authenticates byte
identity only. It does not establish:

- who produced the bytes;
- whether the producer was correct;
- whether a DFT or Wannier90 run was physically appropriate;
- whether a selected basis or model is scientifically applicable; or
- whether the result is acceptable for publication.

If producer-origin assurance is required, a signed attestation or separately governed artifact
registry may be referenced. That assurance remains distinct from the exact mathematical checker.

## Threat and error model

The binding must fail closed against at least:

- commit, path, payload, or dependency substitution;
- dirty or unretained source presented as immutable evidence;
- duplicate identifiers or replay under a different package identity;
- permissive parsing, duplicate keys, unknown fields, or implicit defaults;
- missing, duplicated, reordered, transposed, or conjugated matrix entries;
- row/column, source/target, ambient/retained, or basis-axis confusion;
- subtraction of matrices before a common-space and common-basis identification;
- left-unitary data silently interpreted as the frozen right-unitary action;
- mesh-axis permutation, endpoint drift, reciprocal-coordinate drift, or Fourier-sign drift;
- unit or energy-reference mismatch;
- decimal or binary floating values silently promoted to exact physical quantities;
- tolerance-qualified Hermiticity, orthonormality, or unitarity treated as exact equality;
- stale producer-supplied compressed matrices, norms, eigenvalues, or aggregate errors;
- ascending eigensolver output interpreted as Formal's decreasing ordered spectrum;
- arbitrary eigenvector labels inside a degenerate eigenspace;
- interval overlap converted into acceptance or rejection; and
- finite-mesh evidence labeled as continuum evidence.

A future parser must also enforce bounded dimensions and payload size, reject path traversal and
noncanonical references, and avoid copying private, scratch, wavefunction, density, or other large
source artifacts into Formal.

## Contract architecture

```text
immutable owner bytes
        |
        v
source and payload identity checks
        |
        v
strict owner adapter + canonical compact export
        |
        v
independent owner-side reconstruction and verification
        |
        v
Formal binding envelope checker
        |
        v
exact semantic objects + checked premises
        |
        v
one named Formal theorem-application profile
        |
        v
bounded checked conclusion and audit record
```

The generic envelope must not decide which scientific claim an artifact supports. The theorem
profile must not infer source fidelity merely because its algebraic premises check. An owner schema
must not claim Formal acceptance merely because it contains Formal theorem IDs.

## Required binding envelope

Field names below specify meaning, not a frozen JSON schema. The eventual owner wire format must be
strict, versioned, canonical, and independently reviewed.

### 1. Contract and package identity

Require:

- candidate or frozen contract identity and major/minor version;
- owner schema identity and version;
- globally unique package identity;
- package role: development fixture, candidate export, retained export, or superseded export;
- canonical serialization algorithm and version;
- digest algorithm and digest of the canonical package body;
- digest and media type of every referenced payload;
- creation timestamp as metadata, not identity;
- producer and independent-verifier identities; and
- explicit predecessor identity for a superseding package.

The canonical `package_body` itself must contain the contract identity/version, owner-schema
identity/version, package identity/role, canonical serialization algorithm/version, and all
referenced-payload digests. The digest preimage must not be self-referential. For the first frozen
version, define `body_bytes = canonicalSerialize(package_body)`, where `package_body` excludes only
the detached authentication envelope containing its digest and any signatures. Compute
`SHA-256(UTF8("PKF-EXTERNAL-MATRIX-FRAME-BINDING/body/v1") || BYTE(0x00) || body_bytes)`.
The detached envelope carries that digest and repeats the contract and canonicalization identities
needed to select a supported verifier. Those repeated values must equal the authenticated values in
`package_body` byte for byte; mismatch rejects the package. Referenced-payload digests remain inside
`package_body` and are therefore transitively bound. Any different digest domain or preimage rule
requires a reviewed contract version.

Unknown major versions, unknown enumerations, unknown fields, duplicate keys, noncanonical bytes,
and digest mismatch reject the package. A filename, timestamp, branch name, or mutable URL is not
identity.

### 2. Source provenance

For each source, require the applicable fields:

- canonical repository or artifact-store identity;
- descriptive branch, if useful, but never as the immutable identity;
- full commit and tree for Git-controlled sources;
- relative path, Git blob identity, and independent byte digest;
- retained execution or run identity for generated sources;
- source and destination artifact manifests when bytes were staged or copied;
- producing and verifying executable or source revisions;
- dependency-lock digest;
- dirty-state disposition;
- source role; and
- derivation edge from source bytes to each compact exported object.

A retained binding rejects an uncommitted source, a dirty source that could affect the exported
object, or a source path that cannot be reconstructed at the declared immutable revision.
Development fixtures may record dirty context but cannot become retained evidence.

For large or restricted artifacts, the computational owner retains any permitted compact external
export. Formal retains only permitted synthetic conformance fixtures, checker and audit metadata,
identities, and digests. Formal may retain an exact external certificate artifact only after a
separately reviewed evidence authorization explicitly permits it. A digest reference does not prove
that selected exported entries were correctly extracted; that relation requires an independently
checked adapter or a separate exact certificate.

### 3. Finite index carriers and dimensions

Every array axis must bind to an explicit finite carrier. Require:

- stable carrier identity;
- positive cardinality where the selected theorem requires `Nonempty`;
- complete ordered labels and a bijection to `Fin N`;
- source indexing origin and ordering convention;
- semantic axis role; and
- exact agreement between carrier cardinality and payload shape.

For compression profiles, require distinct ambient and retained carrier identities and dimensions.
A frame has shape `Ambient × Retained`: rows are ambient coordinates and columns are retained-frame
vectors. The retained dimension must be nonzero for maximum and RMS ordered-spectrum profiles.

No dimension may be inferred only from byte count. No truncation, padding, broadcasting, or missing
entry may be repaired by the checker.

### 4. Scalar encoding

The first frozen version should accept only narrow exact encodings:

- reduced rational `p/q` with `q > 0`;
- exact complex rational as an ordered `(real, imaginary)` rational pair;
- closed rational real interval `[lower, upper]`; and
- closed rectangular complex interval from separate real and imaginary intervals.

Canonical reduction, sign, and zero rules are mandatory. NaN, infinity, locale-dependent numbers,
JSON binary floating numbers, decimal exponents with unspecified exact meaning, and tolerance-only
records are rejected as theorem inputs.

An IEEE-754 payload may be authenticated as source bytes and decoded exactly to its represented
dyadic rational. That proves only the value of the stored bit pattern. It does not prove that the
bit pattern encloses or equals an intended real-valued mathematical, DFT, or physical quantity.
Such a relation requires a separate outward-rounding or derivation certificate.

Future algebraic-number support requires a new reviewed encoding and checker; it must not be added
through a permissive string field.

### 5. Matrix and frame objects

Each object requires:

- stable object identity and semantic role;
- source and target carrier identities;
- row and column basis identities;
- scalar encoding and exact shape;
- dense complete entry inventory in canonical row-major semantic order for the first version;
- source byte references and extraction locators;
- units and energy reference when applicable;
- representation, state-space, geometry, and spin identities; and
- derivation identity if the object is transformed from another object.

Recommended initial roles are:

- `ambient-hermitian-operator`;
- `direct-hermitian-operator-a` and `direct-hermitian-operator-b`;
- `candidate-frame`;
- `reference-frame`;
- `right-unitary-gauge`; and
- `independently-supplied-retained-operator` only when a profile explicitly needs one.

Compressed matrices, frame projectors, conjugated retained operators, matrix differences,
Frobenius norms, operator norms, and eigenvalue errors should normally be reconstructed by the
checker. A producer-supplied copy may be retained as a cross-check, but it is never theorem
authority.

### 6. Space, basis, and unit identity

Entrywise comparison is permitted only after common semantics are established. Require:

- state-space identity;
- basis identity and ordering;
- scalar field and conjugation convention;
- source and target coordinate roles;
- geometry and cell identity where relevant;
- spin, spinor, orbital, band-window, and channel labels where relevant;
- energy and length units;
- energy-zero or energy-reference identity; and
- an exact common-basis map if the sources were not originally represented in the same basis.

Equal dimensions do not establish equal spaces or bases. Matching eigenvalues do not establish a
basis map. A common-basis transformation must itself be bound and checked with its declared
orientation.

### 7. Mesh and field identity

When objects vary over a finite mesh, require:

- mesh identity, dimension, cardinality, and complete ordered sample inventory;
- axis order and tensor flattening rule;
- lattice and reciprocal-lattice basis identities;
- fractional versus Cartesian coordinates and the placement of `2π`;
- endpoint, centered-representative, seam, and Nyquist conventions;
- exact coordinates or rational outward enclosures;
- per-sample object identities; and
- coverage and role: construction, verification, refinement, or plotting.

A theorem application is keyed to explicit sample identities. Applying a matrix theorem at every
listed point proves only a finite family of conclusions. It does not prove continuum coverage,
interpolation accuracy, mesh convergence, or behavior between points.

### 8. Transformation and gauge identity

Every transformation edge requires source and target object identities, operation, orientation,
and parameters. The frame-compression profiles freeze:

```text
frame change:       F -> F U
compression:        H_F = Fᴴ H F
represented change: H_F -> Uᴴ H_F U
frame discrepancy:  C - F U
```

Require the gauge dimension, right-action code, adjoint convention, and whether the gauge is global
or sample dependent. A source using `U F`, `F Uᴴ`, `U H Uᴴ`, transposed storage, or inverse-gauge
coordinates needs an explicit exact adapter relation. Silent conversion rejects the binding.

### 9. Fourier and normalization conventions

A binding that references Fourier-derived objects also requires:

- finite domain or group identity;
- forward and inverse signs;
- normalization on each direction;
- coefficient and reconstruction formulas;
- mode representatives and ordering;
- centered-origin phase convention;
- tensor-axis order;
- Nyquist and seam handling;
- support membership and negation/conjugate closure where claimed; and
- exact relation between any source hopping block and the matrix used by the theorem profile.

`fft`, `ifft`, `fftshift`, a filename ending in `_hr.dat`, or a class name does not determine these
semantics.

### 10. Ordered spectrum and degeneracy policy

Formal's ordered carrier is fixed:

- eigenvalues are real because the matrix is exactly Hermitian;
- order is decreasing;
- algebraic multiplicity is retained;
- the canonical index is `Fin N`; and
- maximum and RMS errors are separate quantities.

The binding must not use runtime eigensolver order as the Formal carrier. Runtime eigenvalue arrays
are optional diagnostics unless a separate exact characteristic-polynomial or eigenpair certificate
checks them. Ascending arrays require an explicit diagnostic conversion and still are not theorem
inputs.

Inside a repeated-eigenvalue cluster, individual eigenvectors are not canonically identified. A
source-specific degeneracy policy must use multiplicity-retaining spectra, projectors, clusters, or
subspaces unless an additional labeling theorem justifies vectors. Characteristic-polynomial
equality preserves multiplicity and must not be described as equality of sets of eigenvalues.

## Exact premise classes

A profile may accept a premise only through one of these modes.

### Checked exact value

The checker constructs an exact object and proves the required equality or proposition, such as:

- `Hᴴ = H` for Hermiticity;
- `Fᴴ F = I` for an orthonormal frame;
- the unitary-group equations for `U`;
- exact common dimensions and basis identities; or
- an exact transformation identity.

A numerical residual below a tolerance does not satisfy this mode.

### Checked outward enclosure

The checker verifies rational containment and invokes a separately proved soundness theorem whose
conclusion is stated for the enclosed exact object. The certificate must identify:

- the unknown or separately defined exact target;
- exact center and outward radii or endpoint intervals;
- the derivation of every outward endpoint;
- the relation between source bytes and target;
- the propagated premise or error bound; and
- the precise theorem that turns containment into the final conclusion.

An interval matrix alone does not prove exact Hermiticity, orthonormality, unitarity, or source
fidelity. Current exact frame-compression theorems require exact orthonormal frames. Therefore the
frame-compression profiles are exact-only until an approximate-frame/enclosure bridge is separately
implemented and proved.

### External obligation

A record may identify a numerical or scientific obligation that remains outside Lean. Such a
record is not a premise and cannot produce `formally-checked` status.

## Initial theorem-application profiles

The profile identifier, Formal commit, module, declaration ID, and fully qualified declaration name
must all be bound. A theorem ID by itself is insufficient because source and theorem meaning may
change across revisions.

### Profile A: direct Hermitian pair

Inputs:

- one nonempty finite carrier `n`;
- exact `A B : Matrix n n ℂ` in one basis;
- checked exact Hermiticity of both matrices.

Available exact targets include:

| Declaration | Conclusion class |
|---|---|
| `BG-FOUNDATION-THM-043` | pointwise decreasing ordered-eigenvalue difference bounded by matrix `L2Operator` norm |
| `BG-FOUNDATION-THM-044` | maximum ordered-eigenvalue error bounded by matrix `L2Operator` norm |
| `BG-FOUNDATION-THM-046` | unnormalized ordered-eigenvalue square-sum bounded by entrywise Frobenius power |
| `BG-FOUNDATION-THM-047` | squared RMS error bounded by average entrywise Frobenius power |
| `BG-PROJECTION-THM-023` | RMS error bounded by Frobenius norm divided by `sqrt N` |

The unnormalized square-sum conclusion must remain visible before the normalized RMS consequence.
Maximum and RMS profiles must never share one ambiguous `spectral_error` field.

### Profile B: two exact frames compressing one operator

Inputs:

- nonempty ambient and retained carriers;
- one exact ambient operator `H`;
- exact candidate frame `C` and reference frame `F` with shape `Ambient × Retained`;
- checked `Hᴴ = H`;
- checked `Cᴴ C = I` and `Fᴴ F = I`; and
- one common basis, units, and operator identity.

Derived objects:

```text
candidate retained operator = Cᴴ H C
reference retained operator = Fᴴ H F
frame difference             = C - F
```

Available exact targets include:

| Declaration | Conclusion class |
|---|---|
| `BG-PROJECTION-THM-021` | maximum ordered retained-spectrum error bounded by `2 ||H||op ||C-F||F` |
| `BG-PROJECTION-THM-024` | RMS ordered retained-spectrum error bounded by `2 ||H||op ||C-F||F / sqrt N` |

The profile rejects different ambient operators. A direct comparison of already compressed
matrices may instead use Profile A, but that does not establish the frame-transfer conclusion.

### Profile C: frozen right-unitary reference representation

Inputs are Profile B plus an exact retained-space unitary `U`. The checker derives:

```text
right-unitary reference frame = F U
represented reference operator = Uᴴ (Fᴴ H F) U
frame difference = C - F U
```

Available exact targets include:

| Declaration | Conclusion class |
|---|---|
| `BG-PROJECTION-THM-022` | maximum ordered retained-spectrum right-unitary compression bound |
| `BG-PROJECTION-THM-025` | RMS ordered retained-spectrum right-unitary compression bound |

This profile does not select `U`, prove that a runtime SVD produced it, authenticate numerical rank,
or choose a completion inside a rank-deficient subspace. Those are separate witness-production and
binding obligations.

## Numerical upper-bound certificates

A theorem can be instantiated while its right-hand side remains an exact symbolic real expression.
A package claiming a concrete rational threshold must additionally check every numerical upper
bound. Do not trust producer-reported NumPy or SciPy norms.

A later proposition-specific certificate may use:

- exact entrywise Frobenius-square sums for rational matrices;
- exact rational comparison after squaring nonnegative square-root expressions;
- a checked Frobenius upper bound on the matrix operator norm;
- an exact positive-semidefinite, Gram, Gershgorin, or other reviewed operator-norm certificate; or
- a separately proved outward interval norm bound.

The certificate must state which bound was used and its loss of sharpness. A binding envelope alone
is not a threshold decision.

## Owner-specific adapter requirements

### KSD compact exports

A KSD adapter should additionally bind:

- native request, result, verification, analysis, and artifact identities;
- schema and canonical-serializer revisions;
- representation, domain, state-space, basis, geometry, and energy-reference identities;
- transformation graph from parent operator through frame, compression, gauge, alignment, Fourier,
  truncation, and reconstruction stages;
- exact candidate/reference roles and one common alignment witness where required;
- finite mesh and weight identities; and
- direct independent reconstruction rather than reuse of producer aggregate values.

Python abstract-base-class membership, a frozen dataclass, a validation tolerance, or a successful
unit test does not establish a Lean premise.

### DFT-derived exports

There must be no single convention-free `dft-matrix` adapter. Each code and format profile must bind:

- code family, version, executable digest, build configuration, and input/output manifests;
- lattice and reciprocal-lattice orientation, coordinate units, and `2π` convention;
- k-point inventory, weights, spin treatment, band inventory, and occupation/window semantics;
- basis construction and ordering, including plane-wave or localized-orbital labels;
- cell, atom, orbital, spinor, and channel ordering;
- energy units and reference;
- matrix construction or extraction formula; and
- an independent check that selected compact entries correspond to the authenticated source bytes.

A Kohn--Sham eigenvalue list is not an operator matrix or frame. A successful DFT calculation does
not prove convergence, physical adequacy, or suitability of its pseudopotentials and settings.

### Wannier90-derived exports

A Wannier90 adapter must keep file roles distinct and bind the applicable format version and
orientation. At minimum distinguish:

- square retained-space unitary data such as an applicable `_u.mat` object;
- rectangular disentanglement/isometry data such as an applicable `_u_dis.mat` object;
- overlap or projection records, which are not automatically frames;
- eigenvalue records, which are not operator matrices;
- real-space Hamiltonian blocks such as `_hr.dat` data; and
- localization summaries, which are not formal frame or locality proofs.

For every applicable file bind `num_bands`, `num_wann`, k-point and neighbor ordering, one-based or
zero-based indices, complex-entry orientation, spin handling, energy units/reference, lattice
conventions, and exact source bytes. `_hr.dat` use also requires the translation inventory,
degeneracy-weight placement, coefficient normalization, and reconstruction sign. No parser may
infer these rules from a filename.

A rectangular isometry must not be admitted as a square unitary. A disentanglement matrix, gauge
matrix, represented Hamiltonian, and real-space hopping field remain separate semantic objects.

## Preservation of the five-stage calculation contract

The binding must preserve the owner lifecycle rather than becoming a shortcut around it.

1. `simulations/run_01_experiment.py` produces a versioned simulation result and candidate compact
   export. This stage cannot declare Formal acceptance.
2. `simulations/run_02_experiment_verification.py` independently reconstructs and verifies the
   simulation result and the source-to-export relation.
3. `analysis/run_03_analysis.py` consumes only verified simulation output and may construct a
   proposition-specific theorem-application request without rewriting simulation bytes.
4. `analysis/run_04_analysis_verification.py` independently verifies the analysis, derived-object
   identities, and exact or outward certificate inputs. Formal checking belongs after this gate or
   is invoked by this verification lane as an offline sidecar.
5. `analysis/run_05_plots.py` consumes only verified analysis output. Rendering cannot create,
   repair, reorder, round, or promote theorem inputs.

Every stage must have immutable input/output identities and no-overwrite behavior. A successful
Formal checker does not replace either independent verification stage. A plot is never a source for
a matrix binding.

## Fail-closed dispositions

Use explicit outcomes rather than one Boolean:

| Outcome | Meaning |
|---|---|
| `ACCEPTED_EXACT_BINDING` | exact bytes, semantics, premises, and selected theorem profile checked |
| `ACCEPTED_ENCLOSURE_BINDING` | a separately implemented enclosure soundness profile checked |
| `UNRESOLVED` | authenticated intervals or obligations are insufficient for the requested conclusion |
| `REJECTED` | identity, schema, semantics, premise, coverage, or checker requirement failed |

`ACCEPTED_ENCLOSURE_BINDING` must not exist in an implementation until its soundness theorem does.
The initial checker should expose only exact acceptance, unresolved external obligations, and
rejection.

Required rejection reason families include:

- `CONTRACT_VERSION_UNSUPPORTED`;
- `CANONICAL_BYTES_INVALID`;
- `SOURCE_IDENTITY_MISMATCH`;
- `PAYLOAD_DIGEST_MISMATCH`;
- `SOURCE_NOT_IMMUTABLE`;
- `DUPLICATE_OR_UNKNOWN_FIELD`;
- `CARRIER_OR_SHAPE_MISMATCH`;
- `ENTRY_INVENTORY_INCOMPLETE`;
- `SCALAR_ENCODING_UNSUPPORTED`;
- `SPACE_OR_BASIS_MISMATCH`;
- `UNIT_OR_ENERGY_REFERENCE_MISMATCH`;
- `MESH_OR_AXIS_CONVENTION_MISMATCH`;
- `GAUGE_ACTION_MISMATCH`;
- `HERMITICITY_CHECK_FAILED`;
- `ORTHONORMALITY_CHECK_FAILED`;
- `UNITARITY_CHECK_FAILED`;
- `THEOREM_PROFILE_MISMATCH`;
- `ENCLOSURE_BRIDGE_UNAVAILABLE`;
- `INDEPENDENT_VERIFICATION_FAILED`; and
- `RESOURCE_BOUND_EXCEEDED`.

Missing mandatory data is rejection, not an invitation to guess. Interval overlap or an insufficient
conservative bound is unresolved, not acceptance and not proof of failure of the underlying claim.

## Checked output record

A successful checker result must retain:

- canonical input package identity and digest;
- every source and payload identity used;
- parser, checker, Formal, Lean, Mathlib, and dependency revisions;
- theorem profile, module, declaration ID, and fully qualified declaration name;
- exact dimensions, carrier identities, roles, bases, units, mesh sample, and gauge orientation;
- premise-check results;
- derived-object digests;
- exact checked conclusion;
- any rational upper-bound derivation and comparison;
- checker axiom/admission audit for the named public declarations;
- independent-verifier identity and result;
- acceptance level; and
- explicit nonclaims.

The output must not embed private source bytes or large generated arrays. It must be reproducible
from the retained compact export and pinned checker environment.

## Acceptance levels remain independent

Use the existing six levels without status transfer:

1. `identity-bound`;
2. `schema-validated`;
3. `numerically-verified`;
4. `formally-checked`;
5. `crosswalked`; and
6. `scientifically-assessed`.

A package can be formally checked without being scientifically assessed. A scientifically reviewed
calculation is not formally checked unless the exact checker accepts its bound export. Neither
status authorizes publication.

## Minimum conformance and adversarial fixtures

A future implementation should include at least:

1. one exact rational Hermitian-pair acceptance fixture;
2. one exact coordinate-frame and permutation-unitary right-action fixture;
3. source commit, path, tree, blob, and payload substitution rejection;
4. duplicate-key, unknown-field, noncanonical-number, and missing-entry rejection;
5. row/column transpose and conjugation rejection;
6. ambient/retained axis swap rejection;
7. basis, units, energy-reference, and mesh-axis mismatch rejection;
8. left-action versus right-action rejection;
9. non-Hermitian matrix rejection;
10. nearly orthonormal but not exactly orthonormal frame rejection;
11. nearly unitary but not exactly unitary gauge rejection;
12. binary64-bit authentication without physical-exactness promotion;
13. ascending runtime eigenvalue diagnostic kept separate from decreasing Formal order;
14. repeated-eigenvalue fixture that forbids eigenvector-label inference;
15. direct-pair acceptance but compression-profile rejection when ambient operators differ;
16. stale producer-supplied compression, norm, or eigenvalue aggregate detection;
17. interval overlap returning `UNRESOLVED`;
18. unknown enclosure profile returning `ENCLOSURE_BRIDGE_UNAVAILABLE`;
19. incomplete finite mesh coverage rejection; and
20. deterministic reproduction of the checked output from canonical bytes.

The independent verifier must reconstruct entries and derived matrices from source-bound compact
objects. It should not call the producer's aggregate-result implementation as its sole route.

## Implementation sequence and gates

### Phase 0: review and freeze the semantic contract

- independently review this recommendation;
- resolve only genuine human-owned choices;
- select a clean immutable owner revision for any pilot;
- freeze one narrow major-version meaning; and
- obtain separate authorization before implementation.

### Phase 1: exact direct-matrix pilot

- define strict canonical compact bytes;
- implement exact rational scalar, carrier, and dense-matrix decoding;
- check source identity and exact Hermiticity;
- instantiate only Profile A;
- emit a complete audit result; and
- retain negative fixtures.

This phase remains synthetic or controlled exact evidence. It does not admit DFT or Wannier90 data.

### Phase 2: exact frame and right-unitary pilot

- add ambient/retained carriers and basis identities;
- check exact orthonormality and unitarity;
- derive compression and right-unitary representation inside the checker;
- instantiate Profiles B and C; and
- certify concrete norm bounds only through separately reviewed exact checkers.

### Phase 3: owner adapter and five-stage integration

- let KSD own its proposition-specific request/result schema and canonical serializer;
- require independent source-to-export reconstruction;
- place Formal checking after verified analysis;
- preserve no-overwrite stage identities; and
- let the computational owner retain one compact conforming package only after separate evidence
  authorization; Formal retains only the permitted checker/audit record unless that authorization
  explicitly includes an exact certificate artifact.

### Phase 4: outward-enclosure bridge

- specify the exact target related to runtime data;
- prove enclosure propagation and checker soundness;
- verify outward rounding independently;
- add `ACCEPTED_ENCLOSURE_BINDING` only after the proof exists; and
- keep discretization, convergence, and physical assumptions external unless separately formalized.

### Phase 5: code-specific DFT or Wannier90 profile

- freeze one code, one format family, one exact orientation, and one bounded proposition;
- authenticate complete source and execution provenance;
- independently verify extraction and semantic mapping;
- perform applicability and scientific review separately; and
- seek separate authorization for evidence promotion, crosswalk, publication, or release.

## Stop conditions

Stop and request review when:

- source bytes are dirty, mutable, restricted, or unavailable;
- an owner format or convention is ambiguous;
- basis, frame, units, energy reference, mesh axes, or gauge action cannot be identified exactly;
- a theorem would require a different operator, rank, dimension, norm, or ordering than supplied;
- tolerance-qualified data would be used as an exact premise;
- an enclosure lacks a proved target relation or soundness theorem;
- an eigensolver array would be used as the canonical ordered spectrum;
- a degenerate cluster would require unjustified eigenvector labels;
- independent verification reuses the producer route tautologically; or
- work would mutate an owner repository, execute protected software, promote evidence, commit,
  push, publish, release, or make a scientific-validation claim without separate authorization.

## Current disposition

The recommended architecture is ready for bounded independent review. No parser, checker, owner
adapter, request/result schema, retained package, or runtime certificate is implemented by this
document. KSD, DFT, and Wannier90 remain external evidence owners, and the checked
runtime-certificate count remains zero.
