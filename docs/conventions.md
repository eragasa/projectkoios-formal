# Formalization conventions

Every theorem family must state the conventions relevant to its claim.

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

## Comparison discipline

Before comparing operators, identify:

1. state spaces;
2. basis or frame maps;
3. gauge or alignment action;
4. energy reference and units; and
5. lattice and reciprocal coordinates.

Projection, disentanglement, basis change, Fourier conversion, and truncation are different operations.
For a column frame `F : Ambient × Retained`, the retained-coordinate action `F ↦ F U` is a right action and compression transforms as `H ↦ Uᴴ H U`. A left-action label does not determine a conformable formula without a separately typed row-frame or ambient-action convention. For a nonorthonormal coordinate basis, distinguish a compressed sesquilinear-form matrix from a coordinate endomorphism before selecting `Uᴴ H U` versus `U⁻¹ H U`.

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
