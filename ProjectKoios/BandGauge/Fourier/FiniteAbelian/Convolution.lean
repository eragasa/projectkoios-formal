/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-31
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.Parseval
public import Mathlib.Algebra.Group.Pointwise.Finset.Basic
public import Mathlib.Data.Matrix.Mul

/-!
# Finite Fourier convolution

This module proves the exact convolution law for pointwise products of finite matrix fields.  It
uses the repository's normalized conjugated-character forward transform and unconjugated
reconstruction convention.  The convolution carries no additional cardinality factor.

Coefficient support is a statement about an exact declared finite character inventory.  It does not
identify runtime coefficient arrays, authenticate an external mesh, establish continuum decay, or
assign physical hopping-range semantics to the support.
-/

@[expose] public section

open scoped BigOperators Pointwise

namespace ProjectKoios.BandGauge.Fourier.FiniteAbelian

variable {G Mode V m n p : Type*}

/-- `BG-FOURIER-FINITE-DEF-001`: an exact coefficient field vanishes outside the declared finite
support. -/
def CoefficientSupportedOn [Zero V]
    (support : Finset Mode) (coefficients : CoefficientField Mode V) : Prop :=
  ∀ mode, mode ∉ support → coefficients mode = 0

/-- `BG-FOURIER-FINITE-LEM-002`: enlarging a declared support preserves exact coefficient
support. -/
lemma coefficientSupportedOn_mono [Zero V]
    {smaller larger : Finset Mode} {coefficients : CoefficientField Mode V}
    (hsubset : smaller ⊆ larger)
    (hsupported : CoefficientSupportedOn smaller coefficients) :
    CoefficientSupportedOn larger coefficients := by
  intro mode hmode
  exact hsupported mode fun hsmall => hmode (hsubset hsmall)

/-- `BG-FOURIER-FINITE-DEF-002`: matrix-valued convolution over the finite character group. -/
noncomputable def finiteMatrixConvolution
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype n]
    (left : AddChar G ℂ → Matrix m n ℂ)
    (right : AddChar G ℂ → Matrix n p ℂ)
    (mode : AddChar G ℂ) : Matrix m p ℂ :=
  ∑ leftMode, ∑ rightMode,
    if leftMode + rightMode = mode then left leftMode * right rightMode else 0

/-- `BG-FOURIER-FINITE-LEM-001`: reconstruction turns finite matrix convolution into pointwise
matrix multiplication. -/
lemma finiteFourierReconstruction_finiteMatrixConvolution
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype n]
    (left : AddChar G ℂ → Matrix m n ℂ)
    (right : AddChar G ℂ → Matrix n p ℂ) (momentum : G) :
    finiteFourierReconstruction (finiteMatrixConvolution left right) momentum =
      finiteFourierReconstruction left momentum *
        finiteFourierReconstruction right momentum := by
  classical
  simp only [finiteFourierReconstruction, finiteReconstruction, finiteCharacterPhase,
    finiteMatrixConvolution]
  simp_rw [Finset.smul_sum]
  rw [Matrix.sum_mul]
  simp_rw [Matrix.mul_sum]
  rw [Finset.sum_comm]
  congr 1
  funext leftMode
  rw [Finset.sum_comm]
  congr 1
  funext rightMode
  simp [AddChar.add_apply, smul_smul, mul_comm]

/-- `BG-FOURIER-FINITE-THM-001`: the finite Fourier coefficient of a pointwise matrix product is
its coefficient convolution.  Rectangular factors are allowed when their middle dimensions agree. -/
theorem finiteFourierCoefficient_mul
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype n]
    (left : G → Matrix m n ℂ) (right : G → Matrix n p ℂ)
    (mode : AddChar G ℂ) :
    finiteFourierCoefficient (fun momentum => left momentum * right momentum) mode =
      finiteMatrixConvolution (finiteFourierCoefficient left)
        (finiteFourierCoefficient right) mode := by
  rw [← finiteFourierCoefficient_reconstruction
    (finiteMatrixConvolution (finiteFourierCoefficient left)
      (finiteFourierCoefficient right)) mode]
  congr 2
  funext momentum
  rw [finiteFourierReconstruction_finiteMatrixConvolution,
    finiteFourierReconstruction_coefficients,
    finiteFourierReconstruction_coefficients]

/-- `BG-FOURIER-FINITE-THM-002`: convolution of fields supported on `S` and `T` is supported on the
finite pointwise sum `S + T`.  This is an inclusion; cancellations may make the actual support
smaller. -/
theorem finiteMatrixConvolution_supportedOn_add
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype n]
    (left : AddChar G ℂ → Matrix m n ℂ)
    (right : AddChar G ℂ → Matrix n p ℂ)
    (leftSupport rightSupport : Finset (AddChar G ℂ))
    (hleft : CoefficientSupportedOn leftSupport left)
    (hright : CoefficientSupportedOn rightSupport right) :
    CoefficientSupportedOn (leftSupport + rightSupport)
      (finiteMatrixConvolution left right) := by
  classical
  intro mode hmode
  apply Finset.sum_eq_zero
  intro leftMode _
  apply Finset.sum_eq_zero
  intro rightMode _
  by_cases hleftMode : leftMode ∈ leftSupport
  · by_cases hrightMode : rightMode ∈ rightSupport
    · have hne : leftMode + rightMode ≠ mode := by
        intro heq
        apply hmode
        rw [← heq]
        exact Finset.add_mem_add hleftMode hrightMode
      simp [hne]
    · rw [hright rightMode hrightMode]
      simp
  · rw [hleft leftMode hleftMode]
    simp

end ProjectKoios.BandGauge.Fourier.FiniteAbelian
