/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDifference.TwistedCyclic1D

/-!
# Dirichlet data as the odd sector of a doubled periodic lattice

An `N`-coordinate Dirichlet vector is extended to a cycle of length `2 * (N + 1)`: the values at
coordinates `0` and `N + 1` vanish, the first interior half carries the supplied vector, and the
second half is its reflected negative.  Restricting the periodic negative centered difference back
to the first interior half recovers the finite Dirichlet difference exactly.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-ODD-EXTENSION-DEF-001`: first-half interior coordinate in the doubled cycle. -/
def doubledCycleInteriorCoordinate {N : ℕ} (i : Fin N) : Fin (2 * N + 2) :=
  ⟨i.val + 1, by omega⟩

/-- `QM-ODD-EXTENSION-DEF-002`: coordinate preceding a first-half interior coordinate. -/
def doubledCycleLeftCoordinate {N : ℕ} (i : Fin N) : Fin (2 * N + 2) :=
  ⟨i.val, by omega⟩

/-- `QM-ODD-EXTENSION-DEF-003`: coordinate following a first-half interior coordinate. -/
def doubledCycleRightCoordinate {N : ℕ} (i : Fin N) : Fin (2 * N + 2) :=
  ⟨i.val + 2, by omega⟩

/--
`QM-ODD-EXTENSION-DEF-004`: odd extension to the doubled cycle, with zeros at the two fixed
boundary coordinates.
-/
def oddDoubledCycleExtension {N : ℕ} (v : Fin N → ℂ) : Fin (2 * N + 2) → ℂ :=
  fun j =>
    if hleft : 1 ≤ j.val ∧ j.val ≤ N then
      v ⟨j.val - 1, by omega⟩
    else if hright : N + 2 ≤ j.val then
      -v ⟨2 * N + 1 - j.val, by omega⟩
    else 0

/-- `QM-ODD-EXTENSION-THM-001`: the odd extension vanishes at the left boundary coordinate. -/
theorem oddDoubledCycleExtension_zero
    (N : ℕ) (v : Fin N → ℂ) :
    oddDoubledCycleExtension v (0 : Fin (2 * N + 2)) = 0 := by
  simp [oddDoubledCycleExtension]

/-- `QM-ODD-EXTENSION-THM-002`: the odd extension vanishes at the opposite boundary coordinate. -/
theorem oddDoubledCycleExtension_opposite_zero
    (N : ℕ) (v : Fin N → ℂ) :
    oddDoubledCycleExtension v ⟨N + 1, by omega⟩ = 0 := by
  simp [oddDoubledCycleExtension]

/-- `QM-ODD-EXTENSION-THM-003`: restriction to the first interior half recovers the input. -/
theorem oddDoubledCycleExtension_interior
    {N : ℕ} (v : Fin N → ℂ) (i : Fin N) :
    oddDoubledCycleExtension v (doubledCycleInteriorCoordinate i) = v i := by
  simp [oddDoubledCycleExtension, doubledCycleInteriorCoordinate]

/--
`QM-ODD-EXTENSION-LEM-001`: the coordinate preceding an embedded interior site agrees with the
Dirichlet left-neighbor convention.
-/
lemma oddDoubledCycleExtension_left
    {N : ℕ} (v : Fin N → ℂ) (i : Fin N) :
    oddDoubledCycleExtension v (doubledCycleLeftCoordinate i) = leftDirichletValue v i := by
  by_cases hpos : 0 < i.val
  · have hone : 1 ≤ i.val := by omega
    have hle : i.val ≤ N := by omega
    simp [oddDoubledCycleExtension, doubledCycleLeftCoordinate, leftDirichletValue, hpos,
      hone, hle]
  · have hi0 : i.val = 0 := by omega
    simp [oddDoubledCycleExtension, doubledCycleLeftCoordinate, leftDirichletValue, hi0]

/--
`QM-ODD-EXTENSION-LEM-002`: the coordinate following an embedded interior site agrees with the
Dirichlet right-neighbor convention.
-/
lemma oddDoubledCycleExtension_right
    {N : ℕ} (v : Fin N → ℂ) (i : Fin N) :
    oddDoubledCycleExtension v (doubledCycleRightCoordinate i) = rightDirichletValue v i := by
  by_cases hnext : i.val + 1 < N
  · have hle : i.val + 2 ≤ N := by omega
    simp [oddDoubledCycleExtension, doubledCycleRightCoordinate, rightDirichletValue, hnext, hle]
  · have heq : i.val + 2 = N + 1 := by omega
    simp [oddDoubledCycleExtension, doubledCycleRightCoordinate, rightDirichletValue, hnext, heq]

/-- `QM-ODD-EXTENSION-DEF-005`: reflection of the doubled cycle across its boundary coordinates. -/
def doubledCycleReflection {N : ℕ} (j : Fin (2 * N + 2)) : Fin (2 * N + 2) :=
  if h : j.val = 0 then 0 else ⟨2 * N + 2 - j.val, by omega⟩

/-- `QM-ODD-EXTENSION-THM-004`: the doubled extension is odd under cycle reflection. -/
theorem oddDoubledCycleExtension_reflection
    {N : ℕ} (v : Fin N → ℂ) (j : Fin (2 * N + 2)) :
    oddDoubledCycleExtension v (doubledCycleReflection j) =
      -oddDoubledCycleExtension v j := by
  by_cases h0 : j.val = 0
  · have hj : j = 0 := Fin.ext h0
    subst j
    simp [doubledCycleReflection, oddDoubledCycleExtension]
  · by_cases hleft : j.val ≤ N
    · have hone : 1 ≤ j.val := by omega
      have hrefval : (doubledCycleReflection j).val = 2 * N + 2 - j.val := by
        simp [doubledCycleReflection, h0]
      have hrefRight : N + 2 ≤ (doubledCycleReflection j).val := by
        rw [hrefval]
        omega
      have hrefNotLeft : ¬(1 ≤ (doubledCycleReflection j).val ∧
          (doubledCycleReflection j).val ≤ N) := by omega
      rw [show oddDoubledCycleExtension v (doubledCycleReflection j) =
          -v ⟨2 * N + 1 - (doubledCycleReflection j).val, by omega⟩ by
            simp [oddDoubledCycleExtension, hrefRight, hrefNotLeft]]
      rw [show oddDoubledCycleExtension v j = v ⟨j.val - 1, by omega⟩ by
        simp [oddDoubledCycleExtension, hone, hleft]]
      congr 2
      apply Fin.ext
      change 2 * N + 1 - (doubledCycleReflection j).val = j.val - 1
      omega
    · by_cases hright : N + 2 ≤ j.val
      · have hrefval : (doubledCycleReflection j).val = 2 * N + 2 - j.val := by
          simp [doubledCycleReflection, h0]
        have hrefOne : 1 ≤ (doubledCycleReflection j).val := by
          rw [hrefval]
          omega
        have hrefLeft : (doubledCycleReflection j).val ≤ N := by
          rw [hrefval]
          omega
        have hrefInLeft : 1 ≤ (doubledCycleReflection j).val ∧
            (doubledCycleReflection j).val ≤ N := ⟨hrefOne, hrefLeft⟩
        rw [show oddDoubledCycleExtension v (doubledCycleReflection j) =
            v ⟨(doubledCycleReflection j).val - 1, by omega⟩ by
              simp [oddDoubledCycleExtension, hrefInLeft]]
        rw [show oddDoubledCycleExtension v j = -v ⟨2 * N + 1 - j.val, by omega⟩ by
          simp [oddDoubledCycleExtension, hleft, hright]]
        simp only [neg_neg]
        congr 1
        apply Fin.ext
        change (doubledCycleReflection j).val - 1 = 2 * N + 1 - j.val
        omega
      · have hj : j.val = N + 1 := by omega
        have href : doubledCycleReflection j = j := by
          unfold doubledCycleReflection
          rw [dite_eq_right h0]
          apply Fin.ext
          change 2 * N + 2 - j.val = j.val
          omega
        rw [href]
        have hzero : oddDoubledCycleExtension v j = 0 := by
          rw [show j = ⟨N + 1, by omega⟩ from Fin.ext hj]
          exact oddDoubledCycleExtension_opposite_zero N v
        rw [hzero, neg_zero]

/-- `QM-ODD-EXTENSION-DEF-006`: restriction from the doubled cycle to its first interior half. -/
def restrictDoubledCycleInterior {N : ℕ} (w : Fin (2 * N + 2) → ℂ) : Fin N → ℂ :=
  fun i => w (doubledCycleInteriorCoordinate i)

/--
`QM-ODD-EXTENSION-THM-005`: restricting the doubled periodic difference of the odd extension gives
exactly the finite Dirichlet difference.
-/
theorem restrictDoubledCycleInterior_negativePeriodicDifference_oddExtension
    (N : ℕ) (v : Fin N → ℂ) :
    restrictDoubledCycleInterior
        (negativePeriodicDifference (N := 2 * N) (oddDoubledCycleExtension v)) =
      negativeDirichletDifference v := by
  funext i
  change negativePeriodicDifference (oddDoubledCycleExtension v)
      (doubledCycleInteriorCoordinate i) = negativeDirichletDifference v i
  have hleft :
      leftTwistedValue 1 (oddDoubledCycleExtension v) (doubledCycleInteriorCoordinate i) =
        oddDoubledCycleExtension v (doubledCycleLeftCoordinate i) := by
    unfold leftTwistedValue
    split_ifs with h
    · apply congrArg (oddDoubledCycleExtension v)
      exact Fin.ext (by simp [doubledCycleInteriorCoordinate, doubledCycleLeftCoordinate])
    · simp [doubledCycleInteriorCoordinate] at h
  have hright :
      rightTwistedValue 1 (oddDoubledCycleExtension v) (doubledCycleInteriorCoordinate i) =
        oddDoubledCycleExtension v (doubledCycleRightCoordinate i) := by
    unfold rightTwistedValue
    split_ifs with h
    · apply congrArg (oddDoubledCycleExtension v)
      exact Fin.ext (by simp [doubledCycleInteriorCoordinate, doubledCycleRightCoordinate])
    · simp [doubledCycleInteriorCoordinate] at h
      omega
  unfold negativePeriodicDifference negativeTwistedDifference
  rw [hleft, hright, oddDoubledCycleExtension_interior,
    oddDoubledCycleExtension_left, oddDoubledCycleExtension_right]
  rfl

end ProjectKoios.QuantumMechanics.FiniteDifference
