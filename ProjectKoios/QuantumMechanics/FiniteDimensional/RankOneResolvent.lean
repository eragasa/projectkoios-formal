/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-26
-/
module

public import Mathlib.Basic.Complex.Basic
public import Mathlib.LinearAlgebra.Matrix.Hermitian
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
public import Mathlib.LinearAlgebra.Matrix.SchurComplement

/-!
# Finite rank-one determinant and resolvent algebra

This module proves source-neutral finite-matrix identities for a rank-one update
`A + coupling • |ket⟩⟨bra|`.  It includes the matrix determinant lemma, the exact scalar
singularity condition, a Sherman--Morrison inverse formula, Hermitian self-update specializations,
and the resolvent-constructed eigenvector equation for an attractive self-update.

The motivating calculation protocol was inspected read-only in the `ksdft2effmass` owner
repository.  The declarations remain more general than that calculation and bind no authored
vector, hopping matrix, energy, coupling, root bracket, tolerance, eigensolver result, or retained
artifact.  They prove conditional finite-dimensional algebra only.  In particular, they do not
prove existence or uniqueness of a secular root, positivity or monotonicity of a local resolvent,
a bound-state count, numerical bisection correctness, an infinite-volume limit, or physical
applicability.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-RESOLVENT-DEF-001`: the finite matrix `|ket⟩⟨bra|`, with conjugation in the bra. -/
noncomputable def rankOneMatrix (ket bra : ι → ℂ) : Matrix ι ι ℂ :=
  Matrix.vecMulVec ket (fun i => conj (bra i))

/-- `QM-RESOLVENT-DEF-002`: a general complex rank-one update of a finite square matrix. -/
noncomputable def rankOnePerturbation (A : Matrix ι ι ℂ) (coupling : ℂ)
    (ket bra : ι → ℂ) : Matrix ι ι ℂ :=
  A + coupling • rankOneMatrix ket bra

/-- `QM-RESOLVENT-DEF-003`: the scalar contraction `⟨bra|A⁻¹|ket⟩`. -/
noncomputable def rankOneResolventScalar (A : Matrix ι ι ℂ)
    (ket bra : ι → ℂ) : ℂ :=
  (fun i => conj (bra i)) ⬝ᵥ (A⁻¹ *ᵥ ket)

/-- `QM-RESOLVENT-DEF-004`: the scalar denominator in the rank-one inverse formula. -/
noncomputable def rankOneResolventDenominator (A : Matrix ι ι ℂ) (coupling : ℂ)
    (ket bra : ι → ℂ) : ℂ :=
  1 + coupling * rankOneResolventScalar A ket bra

/-- `QM-RESOLVENT-DEF-005`: the vector obtained by applying the finite matrix resolvent. -/
noncomputable def rankOneResolventVector (A : Matrix ι ι ℂ) (ket : ι → ℂ) : ι → ℂ :=
  A⁻¹ *ᵥ ket

/-- `QM-RESOLVENT-DEF-006`: the Sherman--Morrison inverse candidate. -/
noncomputable def rankOneInverseCandidate (A : Matrix ι ι ℂ) (coupling : ℂ)
    (ket bra : ι → ℂ) : Matrix ι ι ℂ :=
  A⁻¹ - (coupling / rankOneResolventDenominator A coupling ket bra) •
    Matrix.vecMulVec (rankOneResolventVector A ket)
      ((fun i => conj (bra i)) ᵥ* A⁻¹)

/-- `QM-RESOLVENT-DEF-007`: an attractive-sign rank-one self-update `A - g|v⟩⟨v|`. -/
noncomputable def rankOneDefectMatrix (A : Matrix ι ι ℂ) (magnitude : ℂ)
    (vector : ι → ℂ) : Matrix ι ι ℂ :=
  A - magnitude • rankOneMatrix vector vector

/-- `QM-RESOLVENT-DEF-008`: the attractive-sign scalar secular expression
`1 - g⟨v|A⁻¹|v⟩`. -/
noncomputable def rankOneDefectSecularValue (A : Matrix ι ι ℂ) (magnitude : ℂ)
    (vector : ι → ℂ) : ℂ :=
  1 - magnitude * rankOneResolventScalar A vector vector

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-RESOLVENT-THM-001`: entrywise form of the rank-one matrix. -/
theorem rankOneMatrix_apply (ket bra : ι → ℂ) (i j : ι) :
    rankOneMatrix ket bra i j = ket i * conj (bra j) := by
  rfl

omit [DecidableEq ι] in
/-- `QM-RESOLVENT-THM-002`: a rank-one matrix acts by contraction with its bra. -/
theorem rankOneMatrix_mulVec (ket bra vector : ι → ℂ) :
    rankOneMatrix ket bra *ᵥ vector =
      ((fun i => conj (bra i)) ⬝ᵥ vector) • ket := by
  rw [rankOneMatrix, Matrix.vecMulVec_mulVec]
  ext i
  simp
  ring

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-RESOLVENT-THM-003`: a rank-one self outer product is Hermitian. -/
theorem rankOneMatrix_self_isHermitian (vector : ι → ℂ) :
    (rankOneMatrix vector vector).IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j
  simp [rankOneMatrix, Matrix.vecMulVec_apply]
  ring

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-RESOLVENT-THM-004`: a real-coupling rank-one self-update preserves Hermiticity. -/
theorem rankOnePerturbation_isHermitian_of_real
    (A : Matrix ι ι ℂ) (coupling : ℝ) (vector : ι → ℂ)
    (hA : A.IsHermitian) :
    (rankOnePerturbation A coupling vector vector).IsHermitian := by
  rw [rankOnePerturbation]
  exact hA.add ((rankOneMatrix_self_isHermitian vector).smul (by
    rw [isSelfAdjoint_iff]
    exact Complex.conj_ofReal coupling))

/-- `QM-RESOLVENT-THM-005`: determinant factorization for a general complex rank-one update. -/
theorem det_rankOnePerturbation
    (A : Matrix ι ι ℂ) (coupling : ℂ) (ket bra : ι → ℂ)
    (hA : IsUnit A.det) :
    (rankOnePerturbation A coupling ket bra).det =
      A.det * rankOneResolventDenominator A coupling ket bra := by
  rw [rankOnePerturbation, rankOneMatrix, rankOneResolventDenominator,
    rankOneResolventScalar]
  rw [show coupling • Matrix.vecMulVec ket (fun i => conj (bra i)) =
      Matrix.replicateCol Unit (coupling • ket) *
        Matrix.replicateRow Unit (fun i => conj (bra i)) by
    rw [← Matrix.vecMulVec_eq]
    simp]
  rw [Matrix.dotProduct_mulVec]
  rw [Matrix.det_add_replicateCol_mul_replicateRow hA]
  rw [← Matrix.replicateRow_vecMul (ι := Unit)]
  rw [Matrix.replicateRow_mul_replicateCol]
  simp [Matrix.det_unique, dotProduct_smul]

/-- `QM-RESOLVENT-THM-006`: for an invertible base matrix, the rank-one update is singular exactly
when its scalar resolvent denominator vanishes. -/
theorem det_rankOnePerturbation_eq_zero_iff
    (A : Matrix ι ι ℂ) (coupling : ℂ) (ket bra : ι → ℂ)
    (hA : IsUnit A.det) :
    (rankOnePerturbation A coupling ket bra).det = 0 ↔
      rankOneResolventDenominator A coupling ket bra = 0 := by
  rw [det_rankOnePerturbation A coupling ket bra hA, mul_eq_zero]
  exact or_iff_right hA.ne_zero

/-- `QM-RESOLVENT-THM-007`: the Sherman--Morrison candidate is a right inverse whenever the base
determinant and scalar denominator are nonzero. -/
theorem rankOnePerturbation_mul_rankOneInverseCandidate
    (A : Matrix ι ι ℂ) (coupling : ℂ) (ket bra : ι → ℂ)
    (hA : IsUnit A.det)
    (hden : rankOneResolventDenominator A coupling ket bra ≠ 0) :
    rankOnePerturbation A coupling ket bra *
      rankOneInverseCandidate A coupling ket bra = 1 := by
  let R : Matrix ι ι ℂ := A⁻¹
  let p : ι → ℂ := rankOneResolventVector A ket
  let q : ι → ℂ := (fun i => conj (bra i)) ᵥ* R
  let s : ℂ := rankOneResolventScalar A ket bra
  let d : ℂ := rankOneResolventDenominator A coupling ket bra
  let O : Matrix ι ι ℂ := rankOneMatrix ket bra
  let K : Matrix ι ι ℂ := Matrix.vecMulVec p q
  have hAR : A * R = 1 := Matrix.mul_nonsing_inv A hA
  have hAp : A *ᵥ p = ket := by
    rw [show p = R *ᵥ ket by rfl, Matrix.mulVec_mulVec, hAR, Matrix.one_mulVec]
  have hOR : O * R = Matrix.vecMulVec ket q := by
    rw [show O = Matrix.vecMulVec ket (fun i => conj (bra i)) by rfl,
      Matrix.vecMulVec_mul]
  have hAK : A * K = Matrix.vecMulVec ket q := by
    rw [show K = Matrix.vecMulVec p q by rfl, Matrix.mul_vecMulVec, hAp]
  have hs : s = (fun i => conj (bra i)) ⬝ᵥ p := by
    rfl
  have hOK : O * K = s • Matrix.vecMulVec ket q := by
    rw [show O = Matrix.vecMulVec ket (fun i => conj (bra i)) by rfl,
      show K = Matrix.vecMulVec p q by rfl,
      Matrix.vecMulVec_mul_vecMulVec]
    ext i j
    simp [Matrix.vecMulVec_apply, hs]
    ring
  rw [rankOnePerturbation, rankOneInverseCandidate]
  change (A + coupling • O) * (R - (coupling / d) • K) = 1
  calc
    (A + coupling • O) * (R - (coupling / d) • K) =
        A * R - (coupling / d) • (A * K) + coupling • (O * R) -
          ((coupling / d) * coupling) • (O * K) := by
      simp [Matrix.add_mul, Matrix.mul_sub, smul_smul]
      abel
    _ = 1 - (coupling / d) • Matrix.vecMulVec ket q +
          coupling • Matrix.vecMulVec ket q -
          ((coupling / d) * coupling * s) • Matrix.vecMulVec ket q := by
      rw [hAR, hAK, hOR, hOK, smul_smul]
    _ = 1 := by
      have hd : d = 1 + coupling * s := by rfl
      have hden' : 1 + coupling * s ≠ 0 := by rwa [← hd]
      ext i j
      simp only [Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply,
        Matrix.vecMulVec_apply]
      by_cases hij : i = j
      · simp [hij]
        rw [hd]
        field_simp [hden']
        ring
      · simp [hij]
        rw [hd]
        field_simp [hden']
        ring

/-- `QM-RESOLVENT-THM-008`: the finite Sherman--Morrison resolvent identity. -/
theorem inv_rankOnePerturbation
    (A : Matrix ι ι ℂ) (coupling : ℂ) (ket bra : ι → ℂ)
    (hA : IsUnit A.det)
    (hden : rankOneResolventDenominator A coupling ket bra ≠ 0) :
    (rankOnePerturbation A coupling ket bra)⁻¹ =
      rankOneInverseCandidate A coupling ket bra := by
  have hright := rankOnePerturbation_mul_rankOneInverseCandidate
    A coupling ket bra hA hden
  have hupdate : IsUnit (rankOnePerturbation A coupling ket bra).det :=
    Matrix.isUnit_det_of_right_inverse hright
  exact left_inv_eq_right_inv
    (Matrix.nonsing_inv_mul (rankOnePerturbation A coupling ket bra) hupdate) hright

/-- `QM-RESOLVENT-THM-009`: determinant factorization for the attractive-sign self-update. -/
theorem det_rankOneDefectMatrix
    (A : Matrix ι ι ℂ) (magnitude : ℂ) (vector : ι → ℂ)
    (hA : IsUnit A.det) :
    (rankOneDefectMatrix A magnitude vector).det =
      A.det * rankOneDefectSecularValue A magnitude vector := by
  have hgeneral := det_rankOnePerturbation A (-magnitude) vector vector hA
  rw [rankOnePerturbation, rankOneResolventDenominator] at hgeneral
  rw [rankOneDefectMatrix, rankOneDefectSecularValue, sub_eq_add_neg]
  rw [← neg_smul]
  simpa only [sub_eq_add_neg, neg_mul] using hgeneral

/-- `QM-RESOLVENT-THM-010`: the attractive rank-one self-update is singular exactly at a zero of
the scalar secular expression, conditional on base invertibility. -/
theorem det_rankOneDefectMatrix_eq_zero_iff
    (A : Matrix ι ι ℂ) (magnitude : ℂ) (vector : ι → ℂ)
    (hA : IsUnit A.det) :
    (rankOneDefectMatrix A magnitude vector).det = 0 ↔
      rankOneDefectSecularValue A magnitude vector = 0 := by
  rw [det_rankOneDefectMatrix A magnitude vector hA, mul_eq_zero]
  exact or_iff_right hA.ne_zero

/-- `QM-RESOLVENT-THM-011`: a secular zero makes the resolvent-constructed vector a kernel vector
of the attractive rank-one update. -/
theorem rankOneDefectMatrix_mulVec_rankOneResolventVector_eq_zero
    (A : Matrix ι ι ℂ) (magnitude : ℂ) (vector : ι → ℂ)
    (hA : IsUnit A.det)
    (hsecular : rankOneDefectSecularValue A magnitude vector = 0) :
    rankOneDefectMatrix A magnitude vector *ᵥ rankOneResolventVector A vector = 0 := by
  have hAinv : A *ᵥ rankOneResolventVector A vector = vector := by
    rw [rankOneResolventVector, Matrix.mulVec_mulVec,
      Matrix.mul_nonsing_inv A hA, Matrix.one_mulVec]
  have houter : rankOneMatrix vector vector *ᵥ rankOneResolventVector A vector =
      rankOneResolventScalar A vector vector • vector := by
    rw [rankOneMatrix_mulVec, rankOneResolventScalar, rankOneResolventVector]
  rw [rankOneDefectMatrix, Matrix.sub_mulVec, hAinv, Matrix.smul_mulVec, houter,
    smul_smul]
  rw [rankOneDefectSecularValue] at hsecular
  ext i
  simp only [Pi.sub_apply, Pi.smul_apply, Pi.zero_apply, smul_eq_mul]
  calc
    vector i - magnitude * rankOneResolventScalar A vector vector * vector i =
        (1 - magnitude * rankOneResolventScalar A vector vector) * vector i := by ring
    _ = 0 := by rw [hsecular, zero_mul]

/-- `QM-RESOLVENT-THM-012`: an invertible base sends a nonzero source vector to a nonzero
resolvent-constructed vector. -/
theorem rankOneResolventVector_ne_zero
    (A : Matrix ι ι ℂ) (vector : ι → ℂ) (hA : IsUnit A.det)
    (hvector : vector ≠ 0) :
    rankOneResolventVector A vector ≠ 0 := by
  intro hzero
  apply hvector
  calc
    vector = A *ᵥ rankOneResolventVector A vector := by
      rw [rankOneResolventVector, Matrix.mulVec_mulVec,
        Matrix.mul_nonsing_inv A hA, Matrix.one_mulVec]
    _ = 0 := by rw [hzero, Matrix.mulVec_zero]

/-- `QM-RESOLVENT-THM-013`: at a supplied secular zero for `H - E I`, the non-normalized
resolvent vector satisfies the exact rank-one-defect eigenvalue equation. -/
theorem rankOneDefectMatrix_mulVec_rankOneResolventVector_eq_smul
    (H : Matrix ι ι ℂ) (energy magnitude : ℂ) (vector : ι → ℂ)
    (hshift : IsUnit (H - energy • (1 : Matrix ι ι ℂ)).det)
    (hsecular : rankOneDefectSecularValue
      (H - energy • (1 : Matrix ι ι ℂ)) magnitude vector = 0) :
    rankOneDefectMatrix H magnitude vector *ᵥ
        rankOneResolventVector (H - energy • (1 : Matrix ι ι ℂ)) vector =
      energy • rankOneResolventVector
        (H - energy • (1 : Matrix ι ι ℂ)) vector := by
  let A : Matrix ι ι ℂ := H - energy • 1
  let psi : ι → ℂ := rankOneResolventVector A vector
  have hkernel : rankOneDefectMatrix A magnitude vector *ᵥ psi = 0 :=
    rankOneDefectMatrix_mulVec_rankOneResolventVector_eq_zero
      A magnitude vector hshift hsecular
  change rankOneDefectMatrix H magnitude vector *ᵥ psi = energy • psi
  rw [rankOneDefectMatrix, Matrix.sub_mulVec, Matrix.smul_mulVec]
  have hkernel' :
      (H *ᵥ psi - energy • psi) -
        magnitude • (rankOneMatrix vector vector *ᵥ psi) = 0 := by
    simpa [A, rankOneDefectMatrix, Matrix.sub_mulVec, Matrix.smul_mulVec,
      Matrix.one_mulVec] using hkernel
  ext i
  have hi : (H *ᵥ psi) i - energy * psi i -
      magnitude * (rankOneMatrix vector vector *ᵥ psi) i = 0 := by
    simpa only [Pi.sub_apply, Pi.smul_apply, Pi.zero_apply, smul_eq_mul] using
      congrFun hkernel' i
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  calc
    (H *ᵥ psi) i - magnitude * (rankOneMatrix vector vector *ᵥ psi) i =
        ((H *ᵥ psi) i - energy * psi i -
          magnitude * (rankOneMatrix vector vector *ᵥ psi) i) + energy * psi i := by ring
    _ = energy * psi i := by rw [hi, zero_add]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-RESOLVENT-THM-014`: a real attractive magnitude preserves Hermiticity of a Hermitian
finite matrix. -/
theorem rankOneDefectMatrix_isHermitian_of_real
    (A : Matrix ι ι ℂ) (magnitude : ℝ) (vector : ι → ℂ)
    (hA : A.IsHermitian) :
    (rankOneDefectMatrix A magnitude vector).IsHermitian := by
  rw [rankOneDefectMatrix]
  exact hA.sub ((rankOneMatrix_self_isHermitian vector).smul (by
    rw [isSelfAdjoint_iff]
    exact Complex.conj_ofReal magnitude))

end ProjectKoios.QuantumMechanics.FiniteDimensional
