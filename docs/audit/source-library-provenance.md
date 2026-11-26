# Library and proof-provenance source records

External proof provenance and source-neutral internal derivation records. These records identify inspected sources and limitations; they do not transfer ownership, theorem status, scientific validity, or publication authority.

<a id="aud-src-011"></a>

## `AUD-SRC-011` — Zeroth-Bessel integral proof provenance and local-port selection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-011` |
| Status | `current` |
| Source class | Library or internal proof provenance |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

Pinned Mathlib defines `Complex.besselJ` through `regularizedHGFun`, but its Bessel module does not
expose the required finite trigonometric integral representation or a Jacobi--Anger theorem. A
separate public Lean proof was inspected read-only and selected as the source for a minimal
attributed local port:

- repository: `https://github.com/naoki-cpp/LeanCondensedMatter`;
- merged pull request: `https://github.com/naoki-cpp/LeanCondensedMatter/pull/3802`;
- merge commit: `47d64b9d2e85522dbbef295bf0ce3d2a1d0afe87`;
- parent: `638810c74afd8154bcc96b7dcc9d97466ff395db`;
- tree: `20efdb151b64d0b18826de9beb4010d965f10b1a`;
- source path: `LeanCondensedMatter/Transport/Analysis/PolarFourier.lean`;
- source theorem: `QuantumTheory.Transport.polarFourierZerothAngularKernel_eq_besselJ`;
- source blob: `adb66f516780cbe8f63d82054ca7a3b7dbb096cc`;
- source-file SHA-256: `608fdf0281c7a25c3d132e669ac25ce18ce25f2b8300458e29a4d9e7146facac`;
- source size: 54,549 bytes;
- license: Apache License 2.0; and
- merge-commit author: `naok1`.

The exact external checkout at `/tmp/LeanCondensedMatter-bessel-audit` was clean and detached at the
merge commit. Its module built successfully with 3,603 jobs under the same Lean `4.35.0` and
Mathlib commit `56a005855ea17e0b0958f73ec801ae140b0a1679`. The external theorem's axiom report was
`[propext, Classical.choice, Quot.sound]`; no `sorry`, `admit`, repository-owned axiom, or `sorryAx`
was found in the theorem file.

`ProjectKoios/BandGauge/SpecialFunctions/BesselJZeroIntegral.lean` adapts only the source-neutral
proof chain: full-angle cosine moments, dominated termwise integration of the exponential series,
identification of the even coefficients with Mathlib's regularized-hypergeometric definition, and
`∫₀²π exp(i z cos θ) dθ = 2π J₀(z)` for real `z`. The Project Koios module retains explicit
Apache-2.0 provenance in its source header. `LeanCondensedMatter` is not added as a dependency, and
no unrelated transport, condensed-matter, or project-specific API is copied.

`ProjectKoios/BandGauge/Fourier/Torus/NormalizedCircleBessel.lean` is a separately owned thin bridge. It
fixes the carrier to `UnitAddCircle`, its standard Haar probability measure, the period-one
coordinate `sin(2πx)`, positive phase `i b sin(2πx)`, and no extra `2π` in `b`. It proves the
normalized one-circle identity and exact finite-product powers, including source-neutral 2-D
`J₀(a)²` and 3-D `J₀(2a/3)³` scaling corollaries. These results do not identify KSD's notation or
runtime values with the exact carrier, coordinate, phase, amplitude, or measure; authenticate
quadrature or a finite mesh; establish finite-to-continuum convergence; or certify either analytic
comparator. The current checked runtime-certificate count remains zero.

<a id="aud-src-026"></a>

## `AUD-SRC-026` — Source-neutral integer lattice radius bridge

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-026` |
| Status | `internal` |
| Source class | Library or internal proof provenance |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

`ProjectKoios/BandGauge/Fourier/Support/LatticeRadius.lean` is derived from the repository's
existing exact integer shell-index definitions rather than from new owner-repository bytes. The
square and simple-cubic realizations use ordinary Euclidean coordinates. The triangular realization
uses `(x + y/2, √3 y/2)`. The normalized FCC realization uses the four coordinates
`((x+y+z)/√2, x/√2, y/√2, z/√2)`. Expanding the Euclidean norm squares gives exactly the existing
square, triangular, simple-cubic, and normalized FCC indices.

The triangle inequalities are inherited from the Euclidean norm, and inversion invariance follows
from negating the additive realizations. These facts yield the elementwise `R_A + 2 R_U` bound for
`-u₁ + a + u₂` and the corresponding inclusion between complete set-valued radius shells. They do
not identify an infinite integer coordinate with a finite Fourier
character. Any concrete periodic application must separately specify the quotient map, centered
representatives, seam/Nyquist convention, and a wraparound-compatible quotient radius. No runtime
mesh, coefficient array, physical length, source-defined hopping range, applicability, or scientific
claim is introduced.
