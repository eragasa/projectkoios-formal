# Formalization conventions

Every theorem family must state the conventions relevant to its claim. Module and declaration
presentation follows the [Lean code standards](lean-code-standards.md).

## Required record

Record every convention that affects a proposition.

| Topic | Record explicitly | Never infer |
|---|---|---|
| Scalars | field and order assumptions | real-to-complex generalization |
| Dimension | spatial dimension, rank, finiteness | arbitrary rank or dimension |
| Momentum | mesh, interval, torus, endpoints, measure | endpoint identification |
| Weights | normalized counting, geometric, moment, or certified optimized rule | post-hoc evaluation weights |
| Fourier | sign, normalization, group, inversion, finite/continuum domain | interchange of conventions |
| Special functions | exact library function, order, phase sign, coordinate scaling, and measure normalization | equality of differently normalized integral formulas |
| Operators | spaces, basis/frame, adjoint, norm | matrix/operator identity without a map |
| Evolution | Hamiltonian units, `ℏ` normalization, exponential sign, and time parameter | `exp(±itH)` convention from an unqualified one-parameter group |
| Support | indices, metric, shells, closure, finite/decaying semantics | physical range from coordinate cutoff |
| Gauge | group family, represented finite dimension, action side, inner-product or metric convention, and global/pointwise dependence | group family from metric, represented dimension from spatial dimension, or a larger alignment family |
| Spectrum | multiplicity, ordering, gaps, retained subspace | canonical eigenvectors at degeneracy |
| Parameters | domains, positivity, compactness, units | bounded conclusions from unbounded formulas |
| Evidence | equality, bound, tolerance, or external obligation | approximate-to-exact promotion |

## Declaration IDs

IDs classify declarations without changing status.

- `DEF`: definition, abbreviation, structure, or construction.
- `LEM`: supporting identity or intermediate result.
- `THM`: principal theorem.
- Existing IDs are append-only; a changed proposition receives a new ID.
- The hierarchical Fourier migration retains historical `BG-FOURIER-DEF-*` and
  `BG-FOURIER-THM-*` IDs. New declarations use family-scoped streams:
  `BG-FOURIER-FINITE-*`, `BG-FOURIER-GAUGE-*`, `BG-FOURIER-SUPPORT-*`,
  `BG-FOURIER-TORUS-*`, or `BG-FOURIER-RESIDUAL-*`.

## Adopted-library namespace mirroring

Project Koios extensions of adopted Physlib, PhyslibAlpha, and QuantumInfo concepts mirror the
upstream semantic declaration namespace beneath the `ProjectKoios` root.

- `_root_.QuantumMechanics.SpaceDQuantumSystem` extensions use
  `ProjectKoios.QuantumMechanics.SpaceDQuantumSystem`.
- `_root_.QuantumMechanics.HydrogenAtom` extensions use
  `ProjectKoios.QuantumMechanics.HydrogenAtom`.
- A genuinely generic extension of `_root_.LinearPMap` uses the corresponding
  `ProjectKoios.LinearPMap` namespace.
- Package and maturity labels such as `Physlib` and `PhyslibAlpha` are not inserted into declaration
  namespaces when the adopted declaration itself uses a semantic namespace such as
  `QuantumMechanics`.

Mirroring records conceptual ownership and makes library relationships legible. It does not claim
upstream acceptance, API stability, source authority, or intent to contribute upstream. Dependency
and Alpha-stability status remain explicit in imports and audit documentation. Established Project
Koios declaration names remain stable unless a separately reviewed migration authorizes a change;
new uncommitted integration declarations should be aligned before their names are frozen.

## Schrödinger time evolution

Project Koios uses physical Schrödinger evolution

`U(t) = exp(-i t H / ℏ)`.

PhyslibAlpha's domain-aware spectral group is parameterized as `s ↦ exp(i s H)`, so the explicit
bridge is `s = -t / ℏ`. The `ℏ` value is Physlib's positive `Constants.ℏ`, not a natural-units
normalization. Its upstream documentation assigns joule-seconds, but Lean's real scalar does not
enforce dimensional units. This convention agrees with stable Physlib's bounded
`FiniteTarget.timeEvolution` and is implemented in
`ProjectKoios/QuantumMechanics/Evolution/Schrodinger.lean`. Do not identify the Alpha group
parameter directly with physical time.

## Comparison discipline

Before comparing operators, identify:

1. state spaces;
2. basis or frame maps;
3. gauge or alignment action;
4. energy reference and units; and
5. lattice and reciprocal coordinates.

Projection, disentanglement, basis change, Fourier conversion, and truncation are different operations.
For a column frame `F : Ambient × Retained`, the retained-coordinate action `F ↦ F U` is a right action and compression transforms as `H ↦ Uᴴ H U`. A left-action label does not determine a conformable formula without a separately typed row-frame or ambient-action convention. For a nonorthonormal coordinate basis, distinguish a compressed sesquilinear-form matrix from a coordinate endomorphism before selecting `Uᴴ H U` versus `U⁻¹ H U`.
For a conjugate-linear coordinate action, write the conjugation explicitly: `x ↦ M conjugate(x)`, `M' = A_t⁻¹ M conjugate(A_s)`, and `(M K)(N K) = M conjugate(N)`. Do not model componentwise complex conjugation as a complex-linear map, and do not infer Hermiticity, positive definiteness, bijectivity, isometry, or antiunitarity from the algebraic metric equation alone.

## Normalized-circle Bessel convention

The implemented one-circle `J₀` bridge uses Mathlib's `Complex.besselJ 0`, `UnitAddCircle`, its
standard Haar probability measure, the representative coordinate `sin (2πx)`, positive phase
`i b sin (2πx)`, and no extra `2π` in the real amplitude `b`. Any external consumer must prove its
own coordinate, phase, scaling, and measure identification before reusing the result.

## Certificates

Certificate inputs remain exact and explicit.

- Exact scalar certificates use rational data and comparisons before real coercion.
- Algebraic values require proved rational enclosures.
- Square-root bounds require squared inequalities and nonnegativity.
- Certificate acceptance does not bind fields, thresholds, or runtime data automatically.
- Concrete weights and supports must satisfy `BandGauge/publication-evidence-contract.md`.

## Freeze rule

A convention is frozen only after:

1. immutable source identity and locator;
2. source-to-Lean review;
3. recorded assumption delta;
4. manifest entry; and
5. dependent crosswalk updates.
