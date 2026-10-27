/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-27
-/
module

public import ProjectKoios.BandGauge.Fourier.UnitaryEquivariance

/-!
# Pointwise gauges and finite Fourier modes

This module separates three operations that must not be conflated. Multiplying a vector-valued
field by a character phase shifts its finite Fourier mode labels. Conjugating a scalar operator
by an arbitrary pointwise unit-modulus phase is instead exactly trivial. Conjugating a higher-rank
matrix field by a pointwise unitary can change the field and therefore at least one Fourier
coefficient, while preserving pointwise Frobenius power.

The character-phase theorem is one exact mode-shift case, not a general convolution theorem for
arbitrary pointwise gauges. The results do not identify a publication mesh, prove support decay,
bind runtime arrays, or assign physical locality to a Fourier coefficient.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Fourier

variable {G V ι : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- `BG-FOURIER-DEF-020`: pointwise multiplication of a vector-valued field by one finite
additive character. This is a state/vector action, not operator conjugation. -/
def characterPhaseMultiply [AddCommMonoid V] [Module ℂ V]
    (phase : AddChar G ℂ) (field : G → V) (momentum : G) : V :=
  phase momentum • field momentum

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-048`: multiplication by one character shifts finite Fourier mode labels
exactly. With the normalized conjugated-character forward convention, the coefficient at `mode`
after multiplication equals the original coefficient at `mode - phase`. -/
theorem finiteFourierCoefficient_characterPhaseMultiply
    [AddCommMonoid V] [Module ℂ V]
    (phase mode : AddChar G ℂ) (field : G → V) :
    finiteFourierCoefficient (characterPhaseMultiply phase field) mode =
      finiteFourierCoefficient field (mode - phase) := by
  simp only [finiteFourierCoefficient, characterPhaseMultiply, smul_smul]
  congr 1
  apply Finset.sum_congr rfl
  intro momentum _
  congr 1
  rw [AddChar.sub_apply', map_div₀, div_eq_mul_inv]
  congr 1
  rw [← AddChar.inv_apply_eq_conj]
  simp

/-- `BG-FOURIER-DEF-021`: pointwise conjugation of a scalar operator by a unit-modulus phase. -/
def scalarPhaseConjugation
    (phase : G → unitary ℂ) (field : G → ℂ) (momentum : G) : ℂ :=
  star (phase momentum : ℂ) * field momentum * (phase momentum : ℂ)

omit [AddCommGroup G] [Fintype G] [DecidableEq G] in
/-- `BG-FOURIER-THM-049`: scalar operator conjugation is pointwise trivial, even when the phase
depends on momentum. This is why rank-one scalar conjugation is not a gauge-locality effect. -/
theorem scalarPhaseConjugation_eq
    (phase : G → unitary ℂ) (field : G → ℂ) :
    scalarPhaseConjugation phase field = field := by
  funext momentum
  rw [scalarPhaseConjugation, ← Unitary.coe_star, Unitary.star_eq_inv]
  calc
    ((star (phase momentum) : unitary ℂ) : ℂ) * field momentum *
          (phase momentum : ℂ) =
        field momentum *
          (((star (phase momentum) : unitary ℂ) : ℂ) *
            (phase momentum : ℂ)) := by ring
    _ = field momentum := by
      have hunit : ((star (phase momentum) : unitary ℂ) : ℂ) *
          (phase momentum : ℂ) = 1 := by
        simpa only [Unitary.coe_star] using
          Unitary.coe_star_mul_self (phase momentum)
      rw [hunit, mul_one]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-050`: arbitrary pointwise scalar conjugation leaves every finite Fourier
coefficient of a scalar operator field unchanged. -/
theorem finiteFourierCoefficient_scalarPhaseConjugation
    (phase : G → unitary ℂ) (field : G → ℂ) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (scalarPhaseConjugation phase field) mode =
      finiteFourierCoefficient field mode := by
  rw [scalarPhaseConjugation_eq]

/-- `BG-FOURIER-THM-051`: the complete finite Fourier coefficient family separates fields.
Consequently, any actual pointwise change must alter at least one coefficient. -/
theorem exists_finiteFourierCoefficient_ne_of_ne
    [AddCommMonoid V] [Module ℂ V]
    {left right : G → V} (hneq : left ≠ right) :
    ∃ mode : AddChar G ℂ,
      finiteFourierCoefficient left mode ≠ finiteFourierCoefficient right mode := by
  by_contra hnot
  push Not at hnot
  apply hneq
  funext momentum
  rw [← finiteFourierReconstruction_coefficients left momentum,
    ← finiteFourierReconstruction_coefficients right momentum]
  congr 1
  funext mode
  exact hnot mode

section Matrix

variable [Fintype ι] [DecidableEq ι]

/-- `BG-FOURIER-DEF-022`: momentum-by-momentum conjugation of a matrix field by a unitary
matrix field. Unlike `fixedUnitaryConjugation`, the unitary may vary with momentum. -/
def pointwiseUnitaryConjugation
    (gauge : G → Matrix.unitaryGroup ι ℂ)
    (field : G → Matrix ι ι ℂ) (momentum : G) : Matrix ι ι ℂ :=
  (gauge momentum : Matrix ι ι ℂ)ᴴ * field momentum *
    (gauge momentum : Matrix ι ι ℂ)

omit [AddCommGroup G] [Fintype G] [DecidableEq G] in
/-- `BG-FOURIER-THM-052`: a constant pointwise unitary field reduces definitionally to the
existing fixed-unitary conjugation. -/
theorem pointwiseUnitaryConjugation_const
    (U : Matrix.unitaryGroup ι ℂ) (field : G → Matrix ι ι ℂ) :
    pointwiseUnitaryConjugation (fun _ => U) field =
      fun momentum => fixedUnitaryConjugation U (field momentum) := by
  rfl

/-- `BG-FOURIER-THM-053`: if pointwise unitary conjugation changes the matrix field at one
momentum, then it changes at least one finite Fourier coefficient. The theorem does not claim that
every pointwise gauge changes the field or identify which coefficient changes. -/
theorem exists_finiteFourierCoefficient_pointwiseUnitaryConjugation_ne
    (gauge : G → Matrix.unitaryGroup ι ℂ)
    (field : G → Matrix ι ι ℂ) (momentum : G)
    (hchanged : pointwiseUnitaryConjugation gauge field momentum ≠ field momentum) :
    ∃ mode : AddChar G ℂ,
      finiteFourierCoefficient (pointwiseUnitaryConjugation gauge field) mode ≠
        finiteFourierCoefficient field mode := by
  apply exists_finiteFourierCoefficient_ne_of_ne
  intro hfield
  exact hchanged (congrFun hfield momentum)

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-054`: arbitrary pointwise unitary conjugation preserves every caller-weighted
sum of pointwise Frobenius powers. This pointwise invariant does not imply Fourier-mode or support
invariance. -/
theorem weightedFiniteMatrixFrobeniusPower_pointwiseUnitaryConjugation
    (weight : G → ℝ) (gauge : G → Matrix.unitaryGroup ι ℂ)
    (field : G → Matrix ι ι ℂ) :
    weightedFiniteMatrixFrobeniusPower weight
        (pointwiseUnitaryConjugation gauge field) =
      weightedFiniteMatrixFrobeniusPower weight field := by
  rw [weightedFiniteMatrixFrobeniusPower, weightedFiniteMatrixFrobeniusPower]
  apply Finset.sum_congr rfl
  intro momentum _
  rw [pointwiseUnitaryConjugation]
  exact congrArg (weight momentum * ·)
    (matrixFrobeniusPower_fixedUnitaryConjugation (gauge momentum) (field momentum))

end Matrix

end ProjectKoios.BandGauge.Fourier
