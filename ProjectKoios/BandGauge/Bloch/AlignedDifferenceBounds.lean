/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Bloch.AlignedDifference

@[expose] public section

namespace ProjectKoios.BandGauge.Bloch

variable {K Eref Ecand : Type*}
variable [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
variable [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand]

/-- `BG-BLOCH-THM-024`: unitary pullback preserves the norm of the candidate action on the
aligned vector. -/
theorem alignedOperatorField_apply_norm
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (candidate : K → Ecand →L[ℂ] Ecand) (k : K) (v : Eref) :
    ‖alignedOperatorField alignment candidate k v‖ =
      ‖candidate k (alignment k v)‖ := by
  change ‖(alignment k).symm (candidate k (alignment k v))‖ = _
  exact (alignment k).symm.norm_map _

/-- `BG-BLOCH-THM-025`: the pointwise aligned-difference action is bounded by the sum of the
reference and aligned-candidate action norms. -/
theorem alignedOperatorDifferenceField_apply_norm_le
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) (k : K) (v : Eref) :
    ‖alignedOperatorDifferenceField alignment reference candidate k v‖ ≤
      ‖reference k v‖ + ‖candidate k (alignment k v)‖ := by
  rw [alignedOperatorDifferenceField_apply]
  calc
    ‖reference k v - (alignment k).symm (candidate k (alignment k v))‖ ≤
        ‖reference k v‖ + ‖(alignment k).symm (candidate k (alignment k v))‖ :=
      norm_sub_le _ _
    _ = ‖reference k v‖ + ‖candidate k (alignment k v)‖ := by
      rw [(alignment k).symm.norm_map]

/-- `BG-BLOCH-THM-026`: the pointwise aligned-difference action is bounded by the sum of the two
operator norms times the input norm. -/
theorem alignedOperatorDifferenceField_apply_norm_le_opNorm
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) (k : K) (v : Eref) :
    ‖alignedOperatorDifferenceField alignment reference candidate k v‖ ≤
      (‖reference k‖ + ‖candidate k‖) * ‖v‖ := by
  calc
    ‖alignedOperatorDifferenceField alignment reference candidate k v‖ ≤
        ‖reference k v‖ + ‖candidate k (alignment k v)‖ :=
      alignedOperatorDifferenceField_apply_norm_le alignment reference candidate k v
    _ ≤ ‖reference k‖ * ‖v‖ + ‖candidate k‖ * ‖alignment k v‖ :=
      add_le_add ((reference k).le_opNorm v)
        ((candidate k).le_opNorm (alignment k v))
    _ = (‖reference k‖ + ‖candidate k‖) * ‖v‖ := by
      rw [(alignment k).norm_map]
      ring

/-- `BG-BLOCH-THM-027`: the operator norm of an aligned difference is at most the sum of the
reference and candidate operator norms. -/
theorem norm_alignedOperatorDifferenceField_le
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) (k : K) :
    ‖alignedOperatorDifferenceField alignment reference candidate k‖ ≤
      ‖reference k‖ + ‖candidate k‖ := by
  refine ContinuousLinearMap.opNorm_le_bound
    (alignedOperatorDifferenceField alignment reference candidate k)
    (add_nonneg (norm_nonneg _) (norm_nonneg _)) ?_
  intro v
  exact alignedOperatorDifferenceField_apply_norm_le_opNorm
    alignment reference candidate k v

/-- `BG-BLOCH-THM-028`: unitary pullback is additive under candidate-field subtraction. -/
theorem alignedOperatorField_sub
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand) :
    alignedOperatorField alignment (candidateLeft - candidateRight) =
      alignedOperatorField alignment candidateLeft -
        alignedOperatorField alignment candidateRight := by
  funext k
  ext v
  change (alignment k).symm
      ((candidateLeft k - candidateRight k) (alignment k v)) =
    (alignment k).symm (candidateLeft k (alignment k v)) -
      (alignment k).symm (candidateRight k (alignment k v))
  rw [sub_apply, map_sub]

/-- `BG-BLOCH-THM-029`: subtracting two aligned differences that use the same alignment equals the
aligned difference of the corresponding field differences. -/
theorem alignedOperatorDifferenceField_sub
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand) :
    alignedOperatorDifferenceField alignment referenceLeft candidateLeft -
        alignedOperatorDifferenceField alignment referenceRight candidateRight =
      alignedOperatorDifferenceField alignment
        (referenceLeft - referenceRight) (candidateLeft - candidateRight) := by
  funext k
  ext v
  simp only [Pi.sub_apply, sub_apply, alignedOperatorDifferenceField_apply, map_sub]
  abel

/-- `BG-BLOCH-THM-030`: under one common alignment, the pointwise change between two aligned
operator differences is Lipschitz in the reference and candidate field changes. -/
theorem alignedOperatorDifferenceField_apply_sub_apply_norm_le
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand)
    (k : K) (v : Eref) :
    ‖alignedOperatorDifferenceField alignment referenceLeft candidateLeft k v -
        alignedOperatorDifferenceField alignment referenceRight candidateRight k v‖ ≤
      (‖referenceLeft k - referenceRight k‖ +
        ‖candidateLeft k - candidateRight k‖) * ‖v‖ := by
  have hfield := alignedOperatorDifferenceField_sub alignment
    referenceLeft referenceRight candidateLeft candidateRight
  have hpoint := congrArg (fun field => field k v) hfield
  simp only [Pi.sub_apply, sub_apply] at hpoint
  rw [hpoint]
  exact alignedOperatorDifferenceField_apply_norm_le_opNorm alignment
    (referenceLeft - referenceRight) (candidateLeft - candidateRight) k v

/-- `BG-BLOCH-THM-031`: under one common alignment, the operator-norm change between two aligned
differences is bounded by the sum of the reference and candidate operator-norm changes. -/
theorem alignedOperatorDifferenceField_sub_norm_le
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand)
    (k : K) :
    ‖alignedOperatorDifferenceField alignment referenceLeft candidateLeft k -
        alignedOperatorDifferenceField alignment referenceRight candidateRight k‖ ≤
      ‖referenceLeft k - referenceRight k‖ +
        ‖candidateLeft k - candidateRight k‖ := by
  have hfield := alignedOperatorDifferenceField_sub alignment
    referenceLeft referenceRight candidateLeft candidateRight
  have hk := congrFun hfield k
  simp only [Pi.sub_apply] at hk
  rw [hk]
  exact norm_alignedOperatorDifferenceField_le alignment
    (referenceLeft - referenceRight) (candidateLeft - candidateRight) k

/-- `BG-BLOCH-THM-032`: unitary pullback preserves the exact continuous-linear-map operator norm
of the candidate operator. -/
theorem norm_alignedOperatorField_eq
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (candidate : K → Ecand →L[ℂ] Ecand) (k : K) :
    ‖alignedOperatorField alignment candidate k‖ = ‖candidate k‖ := by
  apply le_antisymm
  · refine ContinuousLinearMap.opNorm_le_bound
      (alignedOperatorField alignment candidate k) (norm_nonneg _) ?_
    intro v
    rw [alignedOperatorField_apply_norm]
    calc
      ‖candidate k (alignment k v)‖ ≤ ‖candidate k‖ * ‖alignment k v‖ :=
        (candidate k).le_opNorm (alignment k v)
      _ = ‖candidate k‖ * ‖v‖ := by rw [(alignment k).norm_map]
  · refine ContinuousLinearMap.opNorm_le_bound (candidate k) (norm_nonneg _) ?_
    intro w
    calc
      ‖candidate k w‖ =
          ‖alignedOperatorField alignment candidate k ((alignment k).symm w)‖ := by
        symm
        simpa using
          alignedOperatorField_apply_norm alignment candidate k ((alignment k).symm w)
      _ ≤ ‖alignedOperatorField alignment candidate k‖ * ‖(alignment k).symm w‖ :=
        (alignedOperatorField alignment candidate k).le_opNorm ((alignment k).symm w)
      _ = ‖alignedOperatorField alignment candidate k‖ * ‖w‖ := by
        rw [(alignment k).symm.norm_map]

end ProjectKoios.BandGauge.Bloch
