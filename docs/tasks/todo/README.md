# Todo tasks

This directory records bounded follow-up work. Entries do not establish theorem, evidence, or
publication status.

## Continuum Fourier compatibility

- [x] Prove pointwise Fourier-integral injectivity for integrable complex functions and use it to
  remove the integral-form Plancherel premise from the one-dimensional oscillator completeness
  argument.

Completed by `ProjectKoios.QuantumMechanics.Fourier.ae_eq_zero_of_fourier_eq_zero`,
`ProjectKoios.QuantumMechanics.HarmonicOscillator.eigenstate_span_dense_one`, and
`ProjectKoios.QuantumMechanics.HarmonicOscillator.hamiltonian_isEssentiallySelfAdjoint_one`.
Identification with Mathlib's abstract `L²` Fourier isometry remains a separate optional
compatibility result rather than a prerequisite for this proof.
