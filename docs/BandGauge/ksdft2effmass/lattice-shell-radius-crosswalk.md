# Integer lattice shell-radius crosswalk

## Status

This document is a source-neutral mathematical crosswalk. It does not bind a KSD runtime mesh,
coefficient array, centered-index convention, gauge, or physical hopping range to Lean objects.

## Exact bridge

`ProjectKoios.BandGauge.Fourier.Support.LatticeRadius` assigns an `NNReal` radius to each existing
integer shell index by taking the norm of an explicit additive Euclidean realization.

| Integer-coordinate family | Existing squared index | Exact radius result | Complete-shell inclusion |
|---|---|---|---|
| square 2-D | `x² + y²` | `BG-FOURIER-SUPPORT-THM-001/005` | `BG-FOURIER-SUPPORT-THM-013` |
| triangular 2-D | `x² + xy + y²` | `BG-FOURIER-SUPPORT-THM-002/006` | `BG-FOURIER-SUPPORT-THM-014` |
| simple cubic 3-D | `x² + y² + z²` | `BG-FOURIER-SUPPORT-THM-003/007` | `BG-FOURIER-SUPPORT-THM-015` |
| normalized FCC 3-D | `x² + y² + z² + xy + xz + yz` | `BG-FOURIER-SUPPORT-THM-004/008` | `BG-FOURIER-SUPPORT-THM-016` |

For each family, the radius:

1. has real square exactly equal to the cast integer shell index;
2. is invariant under coordinate inversion;
3. is subadditive under integer-coordinate addition; and
4. bounds every gauge--field--gauge mode relation `-u₁ + a + u₂` by `R_A + 2 R_U`
   whenever both gauge modes have radius at most `R_U` and the field mode has radius at most
   `R_A`; and
5. instantiates that elementwise fact as the complete-shell inclusion
   `(-shell R_U + shell R_A) + shell R_U ⊆ shell (R_A + 2 R_U)`.

The last statement is an inclusion only. Cancellation may make actual coefficient
support strictly smaller.

## Finite Fourier boundary

The finite Fourier theorem `BG-FOURIER-GAUGE-THM-003` is stated on the finite character group
`AddChar G ℂ`. The new radii are stated on infinite integer-coordinate groups. A concrete finite
periodic application therefore still needs a reviewed quotient binding that:

- identifies each finite character mode with an admitted quotient class;
- specifies centered representatives and boundary/Nyquist conventions;
- handles modular wraparound;
- proves that the selected quotient radius is inversion invariant and subadditive; and
- authenticates the runtime periods, axes, basis, support, and gauge.

A raw centered-representative map is not silently treated as an additive homomorphism across the
periodic seam. The present results do not certify NumPy `fft`/`fftshift`, binary64 values, runtime
support classifications, mesh convergence, material applicability, or scientific adequacy.
