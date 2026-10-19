module

public import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Bloch sewing contracts

This module records pointwise reciprocal-boundary sewing independently of any mesh,
integration rule, or numerical tolerance. The convention is that `transport g k` maps
fiber coordinates at `k` to fiber coordinates at `g • k`.

Continuous, measurable, and square-integrable section spaces are deliberately deferred.
Pointwise sewing cannot be recovered from an `L²` equivalence class because reciprocal
boundaries have measure zero.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Bloch

variable {Γ K E Eref Ecand : Type*}
variable [Group Γ] [MulAction Γ K]
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E]
variable [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
variable [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand]

/-- Unitary fiber transport for a reciprocal-group action, with identity and cocycle
laws. The cocycle convention follows `(g * h) • k = g • (h • k)`. -/
structure SewingData (Γ K E : Type*) [Group Γ] [MulAction Γ K]
    [NormedAddCommGroup E] [InnerProductSpace ℂ E] where
  transport : Γ → K → E ≃ₗᵢ[ℂ] E
  transport_one : ∀ k v, transport 1 k v = v
  transport_mul : ∀ g h k v,
    transport (g * h) k v = transport g (h • k) (transport h k v)

/-- A fiber-valued field satisfying the declared pointwise Bloch sewing law. -/
def IsBlochSection (sewing : SewingData Γ K E) (blochSection : K → E) : Prop :=
  ∀ g k, blochSection (g • k) = sewing.transport g k (blochSection k)

/-- An operator field satisfying sewing covariance. The intertwining form avoids an
implicit choice of inverse convention:
`A(g • k) (S(g,k)v) = S(g,k) (A(k)v)`. -/
def IsBlochOperatorField (sewing : SewingData Γ K E)
    (operatorField : K → E →L[ℂ] E) : Prop :=
  ∀ g k v,
    operatorField (g • k) (sewing.transport g k v) =
      sewing.transport g k (operatorField k v)

/-- A unitary alignment from a reference fiber to a candidate fiber that respects both
sewing systems. -/
def IsBlochAlignment
    (referenceSewing : SewingData Γ K Eref)
    (candidateSewing : SewingData Γ K Ecand)
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand) : Prop :=
  ∀ g k v,
    alignment (g • k) (referenceSewing.transport g k v) =
      candidateSewing.transport g k (alignment k v)

/-- Pull a candidate operator field back to the reference fiber using a pointwise unitary
alignment. -/
noncomputable def alignedOperatorField
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (candidateOperator : K → Ecand →L[ℂ] Ecand) :
    K → Eref →L[ℂ] Eref := fun k =>
  (alignment k).symm.toContinuousLinearEquiv.toContinuousLinearMap.comp
    ((candidateOperator k).comp
      (alignment k).toContinuousLinearEquiv.toContinuousLinearMap)

/-- Applying a sewn operator field to a sewn section preserves the sewing law. -/
theorem isBlochSection_operator_apply
    {sewing : SewingData Γ K E}
    {operatorField : K → E →L[ℂ] E} {blochSection : K → E}
    (hOperator : IsBlochOperatorField sewing operatorField)
    (hSection : IsBlochSection sewing blochSection) :
    IsBlochSection sewing (fun k => operatorField k (blochSection k)) := by
  intro g k
  change operatorField (g • k) (blochSection (g • k)) =
    sewing.transport g k (operatorField k (blochSection k))
  rw [hSection g k]
  exact hOperator g k (blochSection k)

/-- A candidate operator field pulled back by a sewing-compatible unitary alignment is a
sewn operator field on the reference fibers. -/
theorem isBlochOperatorField_alignedOperatorField
    {referenceSewing : SewingData Γ K Eref}
    {candidateSewing : SewingData Γ K Ecand}
    {alignment : K → Eref ≃ₗᵢ[ℂ] Ecand}
    {candidateOperator : K → Ecand →L[ℂ] Ecand}
    (hAlignment : IsBlochAlignment referenceSewing candidateSewing alignment)
    (hOperator : IsBlochOperatorField candidateSewing candidateOperator) :
    IsBlochOperatorField referenceSewing
      (alignedOperatorField alignment candidateOperator) := by
  intro g k v
  change (alignment (g • k)).symm
      (candidateOperator (g • k)
        (alignment (g • k) (referenceSewing.transport g k v))) =
    referenceSewing.transport g k
      ((alignment k).symm (candidateOperator k (alignment k v)))
  apply (alignment (g • k)).injective
  rw [LinearIsometryEquiv.apply_symm_apply]
  rw [hAlignment g k v, hOperator g k (alignment k v)]
  rw [hAlignment g k ((alignment k).symm (candidateOperator k (alignment k v)))]
  simp

end ProjectKoios.BandGauge.Bloch
