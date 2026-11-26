/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Physlib.QuantumMechanics.PlanckConstant
public import PhyslibAlpha.ProbabilisticTheory.HilbertSpace.Unbounded.Flow.StoneInvariance

/-!
# Schrödinger time-evolution convention

This module fixes the physical time convention used when Project Koios binds a self-adjoint
Hamiltonian to PhyslibAlpha's domain-aware spectral and Stone APIs.

## i. Convention

PhyslibAlpha constructs the strongly continuous group `s ↦ exp(i s T)`. Project Koios uses the
Schrödinger convention

`U(t) = exp(-i t T / ℏ)`.

Therefore physical time `t` is passed to the Alpha group through `s = -t / ℏ`. The reduced Planck
constant is Physlib's positive real constant `Constants.ℏ`, documented upstream in joule-seconds.
Lean does not enforce the dimensional units of the real time parameter.

This agrees with stable Physlib's bounded `FiniteTarget.timeEvolution` convention. It deliberately
does not replace PhyslibAlpha's spectral measure, domain-aware theorem, or strong unitary-group
structures.

## ii. Key declarations

- `schrodingerEvolutionParameter`
- `DomainAwareSelfAdjointSpectralTheorem.schrodingerEvolution`
- `DomainAwareSelfAdjointSpectralTheorem.schrodingerEvolution_hasDerivAt_zero`
- `DomainAwareSelfAdjointSpectralTheorem.schrodingerEvolution_hasDerivAt`
- `DomainAwareSelfAdjointSpectralTheorem.schrodingerEvolution_commutes`

## iii. Proof schematic

```mermaid
flowchart LR
    physical["physical time t"]
    parameter["s = -t / ℏ"]
    alpha["PhyslibAlpha exp(i s T)"]
    evolution["Project Koios exp(-i t T / ℏ)"]
    derivative["dU/dt at 0 = (-i/ℏ) T"]

    physical --> parameter
    parameter --> alpha
    alpha --> evolution
    evolution --> derivative
```

## iv. Source identity and assumption delta

The adopted dependency revision is Physlib commit
`101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`.

- Stable source: `Physlib/QuantumMechanics/FiniteTarget.lean`, where bounded physical evolution is
  `exp((-t i / ℏ) H)`.
- Alpha source:
  `PhyslibAlpha/ProbabilisticTheory/HilbertSpace/Unbounded/StoneUnitaryGroup.lean`,
  `Flow/Stone.lean`, and `Flow/StoneInvariance.lean`, where the spectral group is `exp(i s T)`, its
  derivative is `i T`, and it preserves and commutes with the self-adjoint operator domain.
- Assumption delta: Project Koios adds only the explicit reparameterization `s = -t / ℏ`; it does
  not add an operator-domain, self-adjointness, spectral-resolution, or unit convention beyond the
  adopted upstream declarations.
-/

@[expose] public section

noncomputable section

namespace ProjectKoios.QuantumMechanics

open Constants
open PhyslibAlpha.ProbabilisticTheory

/-! ## A. Physical-to-spectral time parameter -/

/-- Convert physical time to the parameter used by PhyslibAlpha's `exp(i s T)` spectral group.

Project Koios ID: `QM-EVOLUTION-DEF-001`. -/
def schrodingerEvolutionParameter (t : ℝ) : ℝ :=
  -t / (ℏ : ℝ)

/-- Zero physical time maps to zero spectral-group parameter.

Project Koios ID: `QM-EVOLUTION-LEM-001`. -/
@[simp]
lemma schrodingerEvolutionParameter_zero : schrodingerEvolutionParameter 0 = 0 := by
  simp [schrodingerEvolutionParameter]

/-- The physical-to-spectral time conversion is additive.

Project Koios ID: `QM-EVOLUTION-LEM-002`. -/
lemma schrodingerEvolutionParameter_add (t s : ℝ) :
    schrodingerEvolutionParameter (t + s) =
      schrodingerEvolutionParameter t + schrodingerEvolutionParameter s := by
  unfold schrodingerEvolutionParameter
  ring

/-- Reversing physical time reverses the spectral-group parameter.

Project Koios ID: `QM-EVOLUTION-LEM-003`. -/
@[simp]
lemma schrodingerEvolutionParameter_neg (t : ℝ) :
    schrodingerEvolutionParameter (-t) = -schrodingerEvolutionParameter t := by
  unfold schrodingerEvolutionParameter
  ring

/-- The physical-to-spectral parameter has constant derivative `-ℏ⁻¹`.

Project Koios ID: `QM-EVOLUTION-LEM-004`. -/
lemma schrodingerEvolutionParameter_hasDerivAt (t : ℝ) :
    HasDerivAt schrodingerEvolutionParameter (-(ℏ : ℝ)⁻¹) t := by
  unfold schrodingerEvolutionParameter
  convert ((hasDerivAt_id' (𝕜 := ℝ) t).neg.mul_const ((ℏ : ℝ)⁻¹)) using 1 <;>
    simp [div_eq_mul_inv]

/-! ## B. Domain-aware physical Schrödinger evolution -/

namespace DomainAwareSelfAdjointSpectralTheorem

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
variable {T : H →ₗ.[ℂ] H}
variable {μS : QuantumMechanics.WOTSpectralMeasure ℝ H}

/-- Physical Schrödinger evolution `exp(-i t T / ℏ)`, obtained by reparameterizing
PhyslibAlpha's domain-aware spectral group `exp(i s T)`.

Project Koios ID: `QM-EVOLUTION-DEF-002`. -/
noncomputable def schrodingerEvolution
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) (t : ℝ) :
    H →WOT[ℂ] H :=
  D.expUnitaryGroup (schrodingerEvolutionParameter t)

/-- Schrödinger evolution is the identity at zero physical time.

Project Koios ID: `QM-EVOLUTION-LEM-005`. -/
@[simp]
lemma schrodingerEvolution_zero
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) :
    schrodingerEvolution D 0 = 1 := by
  simp [schrodingerEvolution]

/-- Schrödinger evolution satisfies the additive group law in physical time.

Project Koios ID: `QM-EVOLUTION-LEM-006`. -/
lemma schrodingerEvolution_add
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) (t s : ℝ) :
    schrodingerEvolution D (t + s) =
      schrodingerEvolution D t * schrodingerEvolution D s := by
  rw [schrodingerEvolution, schrodingerEvolutionParameter_add, D.expUnitaryGroup_add]
  rfl

/-- Schrödinger evolution is unitary at every physical time.

Project Koios ID: `QM-EVOLUTION-LEM-007`. -/
lemma schrodingerEvolution_mem_unitary
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) (t : ℝ) :
    schrodingerEvolution D t ∈ unitary (H →WOT[ℂ] H) := by
  exact D.expUnitaryGroup.mem_unitary (schrodingerEvolutionParameter t)

/-- Schrödinger evolution is strongly continuous on every Hilbert-space vector.

Project Koios ID: `QM-EVOLUTION-LEM-008`. -/
lemma schrodingerEvolution_continuous_apply
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) (x : H) :
    Continuous (fun t => schrodingerEvolution D t x) := by
  exact (D.expUnitaryGroup_continuous_apply x).comp (by
    unfold schrodingerEvolutionParameter
    fun_prop)

/-- The adjoint of physical evolution at time `t` is physical evolution at time `-t`.

Project Koios ID: `QM-EVOLUTION-LEM-009`. -/
lemma schrodingerEvolution_star
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) (t : ℝ) :
    star (schrodingerEvolution D t) = schrodingerEvolution D (-t) := by
  rw [schrodingerEvolution, D.expUnitaryGroup_star]
  change D.expUnitaryGroup (-schrodingerEvolutionParameter t) =
    D.expUnitaryGroup (schrodingerEvolutionParameter (-t))
  rw [schrodingerEvolutionParameter_neg]

/-- On the operator domain, the physical orbit derivative at zero is `(-i/ℏ) T x`.

Project Koios ID: `QM-EVOLUTION-LEM-010`. -/
lemma schrodingerEvolution_hasDerivAt_zero
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS) (x : T.domain) :
    HasDerivAt (fun t : ℝ => schrodingerEvolution D t (x : H))
      ((-Complex.I / (ℏ : ℂ)) • T x) 0 := by
  have hout : HasDerivAt (fun s : ℝ => D.expUnitaryGroup s (x : H))
      (Complex.I • T x) (schrodingerEvolutionParameter 0) := by
    simpa using D.expUnitaryGroup_hasDerivAt_zero x
  have h := HasDerivAt.scomp (𝕜 := ℝ) (𝕜' := ℝ) 0 hout
    (schrodingerEvolutionParameter_hasDerivAt 0)
  change HasDerivAt
      ((fun s : ℝ => D.expUnitaryGroup s (x : H)) ∘ schrodingerEvolutionParameter)
      ((-(ℏ : ℝ)⁻¹) • (Complex.I • T x)) 0 at h
  convert h using 1
  · rfl
  · rw [RCLike.real_smul_eq_coe_smul (K := ℂ), smul_smul]
    congr 1
    push_cast
    field_simp [Constants.ℏ_ofReal_ne_zero]
    rfl

/-- On the operator domain, the physical orbit derivative at every time is the evolved vector
`(-i/ℏ) T x`.

Project Koios ID: `QM-EVOLUTION-LEM-011`. -/
lemma schrodingerEvolution_hasDerivAt
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS)
    (x : T.domain) (t : ℝ) :
    HasDerivAt (fun s : ℝ => schrodingerEvolution D s (x : H))
      (schrodingerEvolution D t ((-Complex.I / (ℏ : ℂ)) • T x)) t := by
  have hout : HasDerivAt (fun s : ℝ => D.expUnitaryGroup s (x : H))
      (D.expUnitaryGroup (schrodingerEvolutionParameter t) (Complex.I • T x))
      (schrodingerEvolutionParameter t) :=
    D.expUnitaryGroup_hasDerivAt x (schrodingerEvolutionParameter t)
  have h := HasDerivAt.scomp (𝕜 := ℝ) (𝕜' := ℝ) t hout
    (schrodingerEvolutionParameter_hasDerivAt t)
  change HasDerivAt
      ((fun s : ℝ => D.expUnitaryGroup s (x : H)) ∘ schrodingerEvolutionParameter)
      ((-(ℏ : ℝ)⁻¹) •
        D.expUnitaryGroup (schrodingerEvolutionParameter t) (Complex.I • T x)) t at h
  convert h using 1
  · rfl
  · rw [RCLike.real_smul_eq_coe_smul (K := ℂ)]
    rw [← map_smul]
    congr 1
    rw [smul_smul]
    congr 1
    push_cast
    field_simp [Constants.ℏ_ofReal_ne_zero]
    rfl

/-- Physical Schrödinger evolution preserves the self-adjoint operator domain.

Project Koios ID: `QM-EVOLUTION-LEM-012`. -/
lemma schrodingerEvolution_mem_domain
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS)
    (x : T.domain) (t : ℝ) :
    schrodingerEvolution D t (x : H) ∈ T.domain := by
  exact D.expUnitaryGroup_translate_mem x (schrodingerEvolutionParameter t)

/-- The self-adjoint operator commutes with physical Schrödinger evolution on its domain.

Project Koios ID: `QM-EVOLUTION-LEM-013`. -/
lemma schrodingerEvolution_commutes
    (D : QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem T μS)
    (x : T.domain) (t : ℝ) :
    T ⟨schrodingerEvolution D t (x : H), schrodingerEvolution_mem_domain D x t⟩ =
      schrodingerEvolution D t (T x) := by
  exact D.expUnitaryGroup_translate x (schrodingerEvolutionParameter t)

end DomainAwareSelfAdjointSpectralTheorem

end ProjectKoios.QuantumMechanics
