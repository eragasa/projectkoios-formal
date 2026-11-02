# Finite periodic-lattice matrix least-squares crosswalk

## Scope

This crosswalk records why `BG-FOURIER-LATTICE-DEF-001–006`,
`BG-FOURIER-LATTICE-LEM-001`, and `BG-FOURIER-LATTICE-THM-001–005` are relevant to periodic 1-D,
2-D, and 3-D rank-one, rank-two, and finite-rank KSD calculations.

The Formal carrier is lattice based. For a finite dimension type `D`, exact positive periods `Nᵢ`,
and a reciprocal basis, the finite mesh is the quotient

```text
(d : D) → ZMod (N d).
```

The reciprocal basis owns geometry; the quotient owns finite-character orthogonality. Consequently,
orthogonal and nonorthogonal lattices use the same least-squares theorem once their exact quotient
coordinates have been identified. Matrix rank is an arbitrary finite index type `m`; `Fin 1`,
`Fin 2`, and `Fin r` provide rank-one, rank-two, and rank-`r` cases.

This is a source comparison, not a runtime binding or numerical validation.

## Periodic 1-D rank-one source

The existing exact crosswalk
[`finite-fourier-least-squares-crosswalk.md`](finite-fourier-least-squares-crosswalk.md) records the
Periodic1D rank-one source at immutable KSD commit
`ca052e6571ea10dfbfc3f51be47ffdb08e5313d0`, tree
`447d0634ab6fa09782d50afa899f45e38c156809`. The lattice specialization takes
`Dimension = Fin 1` and matrix index `m = Fin 1`. The scalar squared norm and the entrywise
`1 × 1` Frobenius power coincide after the explicit scalar-to-single-entry identification.

No runtime array is identified with that Lean value by the present theorem.

## Periodic 2-D/3-D rank-two and rank-N sources

Read-only inspection used KSD repository `ksdft2effmass`, branch
`work/periodic23-rank2-ragasa-metric-extension`, at commit
`0bef3dc574648ac60e4014962da75077ded3b4b2`, tree
`d957c541e73f78a312107ddb62cf3eb9fff8514f`. The worktree had 81 dirty-status entries during this
inspection. Every Python path listed below was tracked and clean at the recorded commit, so its
commit and byte hash are immutable source locators. The working copy of
`calculations/periodic3d/rankN/recommended-baseline.md` was modified and is therefore not used as an
immutable working-tree source; its committed version remains locatable at the recorded commit.

| SHA-256 | Owner-repository path | Relevance |
|---|---|---|
| `a13aa64f1b4a88a1f939199db6c08a10bf2b059b1083d258a07831e21ea8377d` | `python/src/ksdft2effmass/periodic2d/rank2/band_equivalence_hopping_locality/analysis.py` | periodic 2-D rank-two matrix locality analysis |
| `6a17d0992d92bd167264916dfc9d890b6ca5ebe1659e8274706f00fe74517126` | `python/src/ksdft2effmass/periodic2d/rank2/band_equivalence_hopping_locality/reference.py` | independent/reference route for the 2-D rank-two calculation |
| `148b9272ec7a967ee6e9385c96453185141c08b6049af685eed0511ecac0047b` | `python/src/ksdft2effmass/periodic2d/rankN/band_equivalence_hopping_locality/analysis.py` | periodic 2-D arbitrary-retained-rank matrix analysis |
| `16f88ea8bcba5f2c1a12bda5abcc8aa4284f6e19fae4f71971bd62656661b718` | `python/src/ksdft2effmass/periodic2d/rankN/band_equivalence_hopping_locality/model.py` | 2-D reduced coordinates, rank inventory, matrix parent, and gauge construction |
| `b29b5ebfcf047e47d7308f3c2a4553780124f043dd1e8f8cae51d7e15ece7d69` | `python/src/ksdft2effmass/periodic3d/rank2/band_equivalence_hopping_locality/analysis.py` | periodic 3-D rank-two matrix locality analysis |
| `33aa04be6b6a28b1ada4fe0dcd2d2d59e4a36ddb08e0a9f7d7a990b08bbb9eb4` | `python/src/ksdft2effmass/periodic3d/rank2/band_equivalence_hopping_locality/reference.py` | independent/reference route for the 3-D rank-two calculation |
| `8d67cc5623a5314c5086262288d460827a13f501b06582a91ac03e9a694d1791` | `python/src/ksdft2effmass/periodic3d/rankN/band_equivalence_hopping_locality/analysis.py` | periodic 3-D arbitrary-retained-rank matrix analysis |
| `b886fae702c9f44449255fa52b837df6837ce531f6fe521b49aa729ebfaa27ea` | `python/src/ksdft2effmass/periodic3d/rankN/band_equivalence_hopping_locality/model.py` | 3-D reduced coordinates, rank inventory, matrix parent, and gauge construction |

The committed rank-N baseline locators are:

| SHA-256 at commit `0bef3dc…` | Path | Status during inspection |
|---|---|---|
| `8cb6faf776281589c6c49b6d5cde9c9532ac0d746ff5aa0ba0d3600c6ba3ef50` | `calculations/periodic2d/rankN/recommended-baseline.md` | tracked and clean |
| `c0da1a4bc65187d4af0ea5d5114b0c2a3fca45d0dd71dd3f5135cc54f27c5bd2` | `calculations/periodic3d/rankN/recommended-baseline.md` | committed bytes; working copy modified |

The source models use reduced coordinates with final coordinate lengths two or three and return
complex matrix fields whose retained rank is explicit. Their baseline documents distinguish square,
triangular, simple-cubic, and FCC-like physical metrics. Those facts motivate the separation between
the quotient lattice coordinates and the reciprocal basis in Formal.

## Exact Formal coverage

`BG-FOURIER-LATTICE-THM-001` proves, for arbitrary finite lattice dimension and arbitrary finite
matrix index type,

```text
FrobeniusError(candidate)
  = FrobeniusError(exact truncation)
  + |finite lattice quotient| * FrobeniusCoefficientMismatch(candidate).
```

`BG-FOURIER-LATTICE-THM-002` proves minimality and equality exactly at the truncated exact
coefficient field. `BG-FOURIER-LATTICE-THM-003–005` expose periodic 1-D, 2-D, and 3-D
specializations without duplicating the proof. Rank is still arbitrary in every specialization.

The exact statement applies after a gauge has been selected: a pointwise gauge changes the matrix
field and therefore generally changes its Fourier coefficients and locality. These declarations do
not select or validate identity, global-unitary, pointwise-unitary, or known-inverse gauges.

## Remaining owner-specific bridge obligations

Application to a retained KSD execution still requires exact evidence for all of the following:

1. the runtime mesh axes and periods equal the declared finite lattice quotient;
2. the reduced-coordinate convention and reciprocal basis equal the declared lattice data;
3. the runtime character inventory is complete and uses the same sign and normalization;
4. every mesh point has equal weight, or a separately proved weighted theorem is used;
5. the runtime matrix axes equal the declared finite rank index type;
6. the runtime Frobenius convention equals the exact entrywise power;
7. the support and selected gauge equal the values used in the theorem; and
8. runtime floating-point values are connected to exact or outward-enclosed values by an accepted
   evidence boundary.

Neither SHA-256 hashes nor source correspondence discharge these obligations. The theorem does not
certify NumPy execution, FFT conventions, least-squares conditioning, binary64 route agreement,
mesh convergence, support adequacy, ordered eigensolver output, or a materials-science conclusion.
