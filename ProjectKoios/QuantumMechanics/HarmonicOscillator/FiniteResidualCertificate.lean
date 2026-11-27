/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteSpectralResidual

/-!
# Exact-data oscillator residual certificates

A rational checker supplies normalized continuum residual and retained-energy bounds, conditional
on a separately proved enclosure of the physical oscillator energy scale.

## i. Overview

Data contain rational real/imaginary coefficients, a rational trial energy, rational endpoints
`L,U`, and a claimed unnormalized squared-residual upper bound `B`. The checker computes, rather
than trusts, the coefficient mass `S = ∑ k, (re_k² + im_k²)` and the endpoint budget

`T = ∑ k, max ((L (k+1/2) - energy)²) ((U (k+1/2) - energy)²) * (re_k² + im_k²)`.

It accepts exactly when `L ≤ U`, `S > 0`, `B ≥ 0`, and `T ≤ B`. This is finite rational arithmetic;
normalization and square roots are not evaluated by the checker. If a Lean proof separately places
`γ = ℏω₀` in `[L,U]`, interval containment bounds every exact physical energy error by the maximum
squared endpoint error. Hence the actual finite residual has squared norm at most `B`.

The accepted mass is genuinely the squared Euclidean norm, so coefficients are nonzero. Mathlib
`NormedSpace.normalize` supplies unit coefficients without introducing a state representation or
assuming that input coefficients were normalized. The normalized residual is at most `sqrt (B/S)`.
The existing domain embedding and exact norm transport yield the same bound for the actual selected
continuum closure; some retained exact energy lies within that tolerance of the trial energy.

Acceptance alone does not prove the physical-scale enclosure, even that an accepted interval can
contain the scale of a particular model. The endpoint proof arguments are mandatory in all
model-dependent guarantees. The exact input data are not floating-point solver output, a parser,
an enclosure producer, a sampled/grid basis identification, or evidence about a runtime algorithm.
No gap checker, omitted continuum-tail estimate, phase-fixed eigenvector error, or physical-model
validation is supplied. Fixtures check synthetic rational data only and do not instantiate a
physical oscillator. Their proofs use `decide +kernel`, not native computation as logical evidence.

## ii. Key results

- `FiniteResidualCertificate.check`: executable exact rational acceptance test.
- `FiniteResidualCertificate.check_eq_true_iff`: exact acceptance conditions.
- `FiniteResidualCertificate.residual_norm_sq_le`: checked raw squared-residual bound with enclosure.
- `FiniteResidualCertificate.normalized_residual_norm_le`: finite normalized bound `sqrt (B/S)`.
- `FiniteResidualCertificate.sound`: unit continuum norm, continuum residual bound, and retained-level
  proximity, all conditional on acceptance and the proved physical-scale enclosure.
- `finiteResidualCertificateFixture_accepts`: accepted non-unit, genuinely complex coefficient data.
- Rejected fixtures cover zero mass, insufficient budget, reversed endpoints, and negative budget.

## iii. Table of contents

- A. Exact data and checker
- B. Norm and interval identities
- C. Checked residual bounds
- D. Normalized continuum guarantees
- E. Exact fixtures
- F. Proof schematic

## iv. References

Reuses the existing retained oscillator matrix and selected closure through
`QHO-FINITE-SPECTRAL-DEF-001/002` and `QHO-FINITE-RESIDUAL-LEM-004/007/012`.
The physical energies use `oneDimensionalEigenEnergy_eq`, without setting `ℏω₀ = 1`.
Mathlib supplies rational arithmetic, `Complex.sq_norm`, `EuclideanSpace.norm_sq_eq`,
`abs_le_max_abs_abs`, `NormedSpace.normalize`, and `Real.le_sqrt`. No rational-complex field or
alternate operator/state abstraction is introduced: rational components map into the existing
complex Euclidean carrier. This source-neutral checker adds no publication crosswalk and does not
implement the separate exact direct-matrix certificate schemas.

## F. Proof schematic

```mermaid
flowchart TD
    data["QHO-RESIDUAL-CERT-DEF-001 to 004<br/>rational components, computed mass S<br/>and endpoint budget T"] --> check["QHO-RESIDUAL-CERT-DEF-005/006<br/>ordered interval, S positive<br/>B nonnegative, T at most B"]
    data --> interval["QHO-RESIDUAL-CERT-LEM-005<br/>squared energy-error bound<br/>requires separately proved L at most hbar omega at most U"]
    check --> normSq["QHO-RESIDUAL-CERT-LEM-001 to 004<br/>exact acceptance conditions<br/>actual norm squared S and nonzero input"]
    interval --> raw["QHO-RESIDUAL-CERT-LEM-006<br/>actual raw squared residual at most B"]
    check --> raw
    raw --> normalized["QHO-RESIDUAL-CERT-LEM-007<br/>normalized residual at most sqrt(B/S)<br/>via exact Mathlib normalization and residual scaling"]
    normSq --> normalized
    normalized --> sound["QHO-RESIDUAL-CERT-LEM-008 to 010<br/>unit continuum image, residual, retained-level proximity<br/>via existing isometry/intertwining and proximity lemma"]
    normSq --> sound
    check --> fixtures["QHO-RESIDUAL-CERT-LEM-011 to 017<br/>kernel-checked synthetic accepted/rejected cases<br/>not a physical-scale enclosure proof"]
```
-/

@[expose] public section

open scoped BigOperators InnerProductSpace Matrix

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/-! ## A. Exact data and checker -/

/--
Exact rational data for a retained oscillator residual bound with an independently justified scale
interval.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-001`.

`K` is the highest retained index. There is no input normalization assumption, claimed mass field,
or stored proof of physical-scale containment.
-/
structure FiniteResidualCertificate (K : ℕ) where
  /-- Exact real components of the unnormalized complex coefficients. -/
  coefficientReal : Fin (K+1) → ℚ
  /-- Exact imaginary components of the unnormalized complex coefficients. -/
  coefficientImag : Fin (K+1) → ℚ
  /-- Rational real trial energy. -/
  trialEnergy : ℚ
  /-- Proposed rational lower endpoint for the physical scale `ℏω₀`. -/
  scaleLower : ℚ
  /-- Proposed rational upper endpoint for the physical scale `ℏω₀`. -/
  scaleUpper : ℚ
  /-- Claimed upper bound on the unnormalized squared residual, checked against the endpoint sum. -/
  residualSqUpper : ℚ

/--
Computed rational squared modulus of one exact coefficient.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-002`.
-/
def FiniteResidualCertificate.coefficientMass {K : ℕ}
    (C : FiniteResidualCertificate K) (k : Fin (K+1)) : ℚ :=
  C.coefficientReal k ^ 2 + C.coefficientImag k ^ 2

/--
Computed total coefficient mass, not an independently supplied normalization claim.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-003`.
-/
def FiniteResidualCertificate.mass {K : ℕ} (C : FiniteResidualCertificate K) : ℚ :=
  ∑ k, C.coefficientMass k

/--
Computed rational upper budget for the squared residual over the entire proposed scale interval.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-004`.

Each coefficient weight multiplies the maximum squared trial-energy error at the two endpoints.
Containment of the actual physical scale is not established by this computation.
-/
def FiniteResidualCertificate.endpointResidualBudget {K : ℕ}
    (C : FiniteResidualCertificate K) : ℚ :=
  ∑ k : Fin (K+1),
    max ((C.scaleLower * ((k.val : ℚ) + 1/2) - C.trialEnergy)^2)
      ((C.scaleUpper * ((k.val : ℚ) + 1/2) - C.trialEnergy)^2) * C.coefficientMass k

/--
Exact decidable rational acceptance conditions for the residual certificate.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-005`.

The physical-scale enclosure is deliberately absent: it remains a separate Lean proof input to
model-dependent soundness. Positive computed mass rules out a zero-vector certificate.
-/
abbrev FiniteResidualCertificate.Conditions {K : ℕ} (C : FiniteResidualCertificate K) : Prop :=
  C.scaleLower ≤ C.scaleUpper ∧ 0 < C.mass ∧ 0 ≤ C.residualSqUpper ∧
    C.endpointResidualBudget ≤ C.residualSqUpper

/--
Executable exact rational residual checker, without real square roots or floating-point arithmetic.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-006`.
-/
def FiniteResidualCertificate.check {K : ℕ} (C : FiniteResidualCertificate K) : Bool :=
  decide C.Conditions

/--
Semantic complex Euclidean coefficient vector represented by the rational component data.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-007`.

This maps exact components into the existing carrier; it does not introduce a rational-complex
algebra or a state abstraction. The checker does not evaluate this noncomputable semantic map.
-/
noncomputable def FiniteResidualCertificate.coefficients {K : ℕ}
    (C : FiniteResidualCertificate K) : EuclideanSpace ℂ (Fin (K+1)) :=
  WithLp.toLp 2 (fun k => ⟨(C.coefficientReal k : ℝ), (C.coefficientImag k : ℝ)⟩)

/--
The Boolean checker accepts exactly the stated rational conditions.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-001`.
-/
lemma FiniteResidualCertificate.check_eq_true_iff {K : ℕ} (C : FiniteResidualCertificate K) :
    C.check = true ↔ C.Conditions := by
  simp [check]

/-! ## B. Norm and interval identities -/

/--
A semantic coefficient's squared complex norm equals its computed rational mass.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-002`.
-/
lemma FiniteResidualCertificate.norm_coefficient_sq {K : ℕ}
    (C : FiniteResidualCertificate K) (k : Fin (K+1)) :
    ‖C.coefficients k‖ ^ 2 = (C.coefficientMass k : ℝ) := by
  change ‖(⟨(C.coefficientReal k : ℝ), (C.coefficientImag k : ℝ)⟩ : ℂ)‖ ^ 2 = _
  rw [Complex.sq_norm]
  simp [Complex.normSq_apply, coefficientMass, pow_two]

/--
The actual squared Euclidean coefficient norm is the computed rational total mass.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-003`.
-/
lemma FiniteResidualCertificate.norm_coefficients_sq {K : ℕ} (C : FiniteResidualCertificate K) :
    ‖C.coefficients‖ ^ 2 = (C.mass : ℝ) := by
  rw [EuclideanSpace.norm_sq_eq]
  simp [mass, norm_coefficient_sq]

/--
Accepted certificates have genuinely nonzero semantic coefficients.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-004`.
-/
lemma FiniteResidualCertificate.coefficients_ne_zero {K : ℕ} (C : FiniteResidualCertificate K)
    (hcheck : C.check = true) : C.coefficients ≠ 0 := by
  have hm : (0 : ℝ) < C.mass := by exact_mod_cast ((C.check_eq_true_iff).1 hcheck).2.1
  intro hz
  rw [← C.norm_coefficients_sq, hz, norm_zero, zero_pow (by decide : 2 ≠ 0)] at hm
  exact (lt_irrefl 0) hm

/--
A proved enclosure of the physical energy scale bounds each squared exact energy error by the
maximum squared endpoint error.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-005`.

The two enclosure hypotheses are indispensable proof inputs. No acceptance hypothesis is needed
for this interval identity, and the interval endpoints need not themselves be positive.
-/
lemma FiniteResidualCertificate.eigenEnergy_error_sq_le {K : ℕ}
    (C : FiniteResidualCertificate K) (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (hlower : (C.scaleLower : ℝ) ≤ (Constants.ℏ : ℝ) * Q.ω 0)
    (hupper : (Constants.ℏ : ℝ) * Q.ω 0 ≤ (C.scaleUpper : ℝ)) (k : Fin (K+1)) :
    (Q.eigenEnergy (fun _ => k.val) - (C.trialEnergy : ℝ)) ^ 2 ≤
      ((max ((C.scaleLower * ((k.val : ℚ) + 1/2) - C.trialEnergy)^2)
        ((C.scaleUpper * ((k.val : ℚ) + 1/2) - C.trialEnergy)^2) : ℚ) : ℝ) := by
  have ht : 0 ≤ ((k.val : ℝ) + 1/2) := by positivity
  have hlo := mul_le_mul_of_nonneg_right hlower ht
  have hup := mul_le_mul_of_nonneg_right hupper ht
  rw [oneDimensionalEigenEnergy_eq]
  push_cast
  have habs := abs_le_max_abs_abs (sub_le_sub_right hlo (C.trialEnergy : ℝ))
    (sub_le_sub_right hup (C.trialEnergy : ℝ))
  rcases le_total |(C.scaleLower : ℝ) * ((k.val : ℝ)+1/2) - C.trialEnergy|
    |(C.scaleUpper : ℝ) * ((k.val : ℝ)+1/2) - C.trialEnergy| with h | h
  · rw [max_eq_right h] at habs
    have hs := (sq_le_sq₀ (abs_nonneg _) (abs_nonneg _)).2 habs
    simp only [sq_abs] at hs
    exact hs.trans (le_max_right _ _)
  · rw [max_eq_left h] at habs
    have hs := (sq_le_sq₀ (abs_nonneg _) (abs_nonneg _)).2 habs
    simp only [sq_abs] at hs
    exact hs.trans (le_max_left _ _)

/-! ## C. Checked residual bounds -/

/--
Acceptance and a proved physical-scale enclosure bound the actual unnormalized squared residual.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-006`.

This is the exact-data boundary from rational endpoint arithmetic to the existing complex finite
Hamiltonian residual; no independent residual norm claim is accepted from a solver.
-/
lemma FiniteResidualCertificate.residual_norm_sq_le {K : ℕ}
    (C : FiniteResidualCertificate K) (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (hcheck : C.check = true)
    (hlower : (C.scaleLower : ℝ) ≤ (Constants.ℏ : ℝ) * Q.ω 0)
    (hupper : (Constants.ℏ : ℝ) * Q.ω 0 ≤ (C.scaleUpper : ℝ)) :
    ‖retainedSpectralResidual Q K (C.trialEnergy : ℝ) C.coefficients‖ ^ 2 ≤
      (C.residualSqUpper : ℝ) := by
  have hb : (C.endpointResidualBudget : ℝ) ≤ C.residualSqUpper := by
    exact_mod_cast ((C.check_eq_true_iff).1 hcheck).2.2.2
  apply le_trans _ hb
  rw [EuclideanSpace.norm_sq_eq]
  simp only [endpointResidualBudget, Rat.cast_sum, Rat.cast_mul]
  apply Finset.sum_le_sum
  intro k _
  rw [norm_retainedSpectralResidual_apply, mul_pow, sq_abs, C.norm_coefficient_sq]
  exact mul_le_mul_of_nonneg_right (C.eigenEnergy_error_sq_le Q hlower hupper k) (by
    dsimp [coefficientMass]
    push_cast
    positivity)

/--
Accepted exact data and a proved scale enclosure give normalized finite residual at most `sqrt (B/S)`.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-007`.

The denominator is the computed, proved positive mass. Normalization is Mathlib's exact semantic
normalization, not a floating-point division or a unit-norm assertion about the raw input.
-/
lemma FiniteResidualCertificate.normalized_residual_norm_le {K : ℕ}
    (C : FiniteResidualCertificate K) (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (hcheck : C.check = true)
    (hlower : (C.scaleLower : ℝ) ≤ (Constants.ℏ : ℝ) * Q.ω 0)
    (hupper : (Constants.ℏ : ℝ) * Q.ω 0 ≤ (C.scaleUpper : ℝ)) :
    ‖retainedSpectralResidual Q K (C.trialEnergy : ℝ)
      (NormedSpace.normalize C.coefficients)‖ ≤
      Real.sqrt ((C.residualSqUpper : ℝ) / (C.mass : ℝ)) := by
  have hm : (0 : ℝ) < C.mass := by exact_mod_cast ((C.check_eq_true_iff).1 hcheck).2.1
  have hb : (0 : ℝ) ≤ C.residualSqUpper := by
    exact_mod_cast ((C.check_eq_true_iff).1 hcheck).2.2.1
  apply (Real.le_sqrt (norm_nonneg _) (div_nonneg hb hm.le)).2
  rw [norm_retainedSpectralResidual_normalize, div_pow, C.norm_coefficients_sq]
  exact div_le_div_of_nonneg_right (C.residual_norm_sq_le Q hcheck hlower hupper) hm.le

/-! ## D. Normalized continuum guarantees -/

/--
The normalized continuum image has residual at most `sqrt (B/S)` under acceptance and the proved
physical-scale enclosure.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-008`.

The continuum operator is evaluated only on the actual closure-domain embedding of the normalized
coefficients. This does not bound an omitted tail of a different continuum state.
-/
lemma FiniteResidualCertificate.continuum_residual_norm_le {K : ℕ}
    (C : FiniteResidualCertificate K) (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (hcheck : C.check = true)
    (hlower : (C.scaleLower : ℝ) ≤ (Constants.ℏ : ℝ) * Q.ω 0)
    (hupper : (Constants.ℏ : ℝ) * Q.ω 0 ≤ (C.scaleUpper : ℝ)) :
    ‖Q.hamiltonian.closure
        (retainedEigenstateDomainEmbedding Q K (NormedSpace.normalize C.coefficients)) -
      ((C.trialEnergy : ℝ) : ℂ) •
        retainedEigenstateEmbedding Q K (NormedSpace.normalize C.coefficients)‖ ≤
      Real.sqrt ((C.residualSqUpper : ℝ) / (C.mass : ℝ)) := by
  rw [norm_retainedEigenstateHamiltonian_residual]
  exact C.normalized_residual_norm_le Q hcheck hlower hupper

/--
Some retained exact physical energy lies within the checked normalized residual tolerance of the
trial energy, conditional on the proved scale enclosure.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-009`.

The level is existential, not a specified or unique eigenstate label. Input coefficients need not
be normalized; acceptance supplies nonzero mass and Mathlib supplies exact normalization.
-/
lemma FiniteResidualCertificate.exists_energy_near {K : ℕ}
    (C : FiniteResidualCertificate K) (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (hcheck : C.check = true)
    (hlower : (C.scaleLower : ℝ) ≤ (Constants.ℏ : ℝ) * Q.ω 0)
    (hupper : (Constants.ℏ : ℝ) * Q.ω 0 ≤ (C.scaleUpper : ℝ)) :
    ∃ k : Fin (K+1), |Q.eigenEnergy (fun _ => k.val) - C.trialEnergy| ≤
      Real.sqrt ((C.residualSqUpper : ℝ) / (C.mass : ℝ)) := by
  exact retainedSpectralResidual_exists_energy_near_of_norm_le Q K C.trialEnergy
    (NormedSpace.normalize C.coefficients)
    (NormedSpace.norm_normalize (C.coefficients_ne_zero hcheck)) _
    (C.normalized_residual_norm_le Q hcheck hlower hupper)

/--
Acceptance plus a proved physical-scale enclosure guarantees unit continuum norm, the checked
normalized continuum residual bound, and proximity to a retained exact energy.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-010`.

This is conditional checker soundness, not a physical-scale enclosure producer, runtime parser,
solver-correctness result, gap certificate, or physical-validation conclusion.
-/
lemma FiniteResidualCertificate.sound {K : ℕ}
    (C : FiniteResidualCertificate K) (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (hcheck : C.check = true)
    (hlower : (C.scaleLower : ℝ) ≤ (Constants.ℏ : ℝ) * Q.ω 0)
    (hupper : (Constants.ℏ : ℝ) * Q.ω 0 ≤ (C.scaleUpper : ℝ)) :
    ‖retainedEigenstateEmbedding Q K (NormedSpace.normalize C.coefficients)‖ = 1 ∧
    ‖Q.hamiltonian.closure
        (retainedEigenstateDomainEmbedding Q K (NormedSpace.normalize C.coefficients)) -
      ((C.trialEnergy : ℝ) : ℂ) •
        retainedEigenstateEmbedding Q K (NormedSpace.normalize C.coefficients)‖ ≤
      Real.sqrt ((C.residualSqUpper : ℝ) / (C.mass : ℝ)) ∧
    ∃ k : Fin (K+1), |Q.eigenEnergy (fun _ => k.val) - C.trialEnergy| ≤
      Real.sqrt ((C.residualSqUpper : ℝ) / (C.mass : ℝ)) := by
  refine ⟨?_, C.continuum_residual_norm_le Q hcheck hlower hupper,
    C.exists_energy_near Q hcheck hlower hupper⟩
  rw [(retainedEigenstateEmbedding Q K).norm_map]
  exact NormedSpace.norm_normalize (C.coefficients_ne_zero hcheck)

/-! ## E. Exact fixtures -/

/--
Synthetic two-coefficient fixture with non-unit mass, nonzero imaginary parts, and an exact boundary
budget over a nondegenerate scale interval.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-DEF-008`.

It represents `c = (1+i, 2i)`, trial energy `1`, and proposed scale interval `[1,3]`. This is not an
assertion that any particular physical oscillator has that scale or those coefficients.
-/
def finiteResidualCertificateFixture : FiniteResidualCertificate 1 where
  coefficientReal := ![1, 0]
  coefficientImag := ![1, 2]
  trialEnergy := 1
  scaleLower := 1
  scaleUpper := 3
  residualSqUpper := 99/2

/--
The synthetic complex fixture has computed mass `6` and exact endpoint budget `99/2`.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-011`.
-/
lemma finiteResidualCertificateFixture_values :
    finiteResidualCertificateFixture.mass = 6 ∧
      finiteResidualCertificateFixture.endpointResidualBudget = 99/2 := by decide +kernel

/--
The exact checker accepts the synthetic fixture, including equality at the squared-budget threshold.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-012`.
-/
lemma finiteResidualCertificateFixture_accepts :
    finiteResidualCertificateFixture.check = true := by decide +kernel

/--
The exact checker rejects the otherwise unchanged fixture with zero coefficients.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-013`.
-/
lemma finiteResidualCertificateFixture_rejects_zero :
    ({finiteResidualCertificateFixture with coefficientReal := 0, coefficientImag := 0} :
      FiniteResidualCertificate 1).check = false := by decide +kernel

/--
The exact checker rejects a claimed squared-residual bound below its computed endpoint budget.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-014`.
-/
lemma finiteResidualCertificateFixture_rejects_underbudget :
    ({finiteResidualCertificateFixture with residualSqUpper := 49} :
      FiniteResidualCertificate 1).check = false := by decide +kernel

/--
The exact checker rejects reversed interval endpoints, even though their maximum endpoint budget
is unchanged.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-015`.
-/
lemma finiteResidualCertificateFixture_rejects_reversed :
    ({finiteResidualCertificateFixture with scaleLower := 3, scaleUpper := 1} :
      FiniteResidualCertificate 1).check = false := by decide +kernel

/--
The exact checker rejects a negative claimed squared-residual upper bound.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-016`.
-/
lemma finiteResidualCertificateFixture_rejects_negative :
    ({finiteResidualCertificateFixture with residualSqUpper := -1} :
      FiniteResidualCertificate 1).check = false := by decide +kernel

/--
The checker also accepts a synthetic lowest-cutoff, zero-budget fixture with non-unit complex
coefficient mass and a degenerate scale interval.

Project Koios declaration ID: `QHO-RESIDUAL-CERT-LEM-017`.

This checks exact arithmetic at `K=0`, scale endpoints `2`, and trial energy `1`; it does not prove
the physical-scale enclosure for a particular model.
-/
lemma finiteResidualCertificate_groundFixture_accepts :
    (FiniteResidualCertificate.check
      { coefficientReal := fun _ : Fin 1 => 1
        coefficientImag := fun _ => 1
        trialEnergy := 1
        scaleLower := 2
        scaleUpper := 2
        residualSqUpper := 0 }) = true := by decide +kernel

end ProjectKoios.QuantumMechanics.HarmonicOscillator
