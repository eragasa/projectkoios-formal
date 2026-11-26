/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.Fourier.IntegralInjectivity
public import ProjectKoios.QuantumMechanics.Operator.Schrodinger
public import Physlib.QuantumMechanics.HarmonicOscillator.Eigenstates
public import Physlib.QuantumMechanics.HarmonicOscillator.OneDimension.Completeness
public import Physlib.QuantumMechanics.Operators.SpectralTheory.Symmetric

/-!
# Continuum harmonic-oscillator operator bridge

This module supplies a checked equivalence between Physlib's legacy one-dimensional and
`SpaceDHilbertSpace 1` carriers, proves domain, symmetry, and closability results for the continuum
`HarmonicOscillator`, and reduces essential self-adjointness to density of its Cartesian energy
eigenstates.

## i. Overview

Physlib defines the `d`-dimensional harmonic-oscillator Hamiltonian on
`SpaceDHilbertSpace d` as the sum of:

- the momentum-square kinetic operator on the Schwartz submodule; and
- the maximal multiplication operator for the quadratic real potential.

Physlib also proves that every Schwartz vector lies in the Hamiltonian domain, that the potential
operator is self-adjoint, and that explicit Schwartz eigenstates satisfy the Hamiltonian eigenvalue
equation. Combining these APIs with the Project Koios momentum-square symmetry theorem gives:

- exact equality between the Hamiltonian domain and the Schwartz submodule;
- symmetry and dense closability of the Hamiltonian; and
- essential self-adjointness from an explicit dense-span hypothesis for the supplied eigenstates.

For `d = 1`, the carrier equivalence transports the legacy oscillator eigenfunctions to the
Cartesian `SpaceDHilbertSpace 1` eigenstates. Project Koios's pointwise Fourier-integral injectivity
lemma replaces the integral-form Plancherel premise in Physlib's legacy completeness argument. This
yields unconditional one-dimensional dense span and essential self-adjointness. The older
conditional transport declarations remain available with their original statements.

No arbitrary-dimensional completeness theorem is claimed. This module establishes the
one-dimensional essential-self-adjointness theorem; the separate `QuantumSystem` module packages
its self-adjoint closure. Spectral measures and time evolution remain unbound.

## ii. Key results

- `SpaceDHilbertSpace.oneDimensionalEquiv`
- `SpaceDHilbertSpace.oneDimensionalEquiv_apply_ae`
- `hamiltonian_domain_eq_schwartz`
- `hamiltonian_isSymmetric`
- `hamiltonian_isUnbounded`
- `hamiltonian_isEssentiallySelfAdjoint_of_eigenstate_span_dense`
- `eigenstate_span_dense_one_of_plancherel`
- `hamiltonian_isEssentiallySelfAdjoint_one_of_plancherel`
- `eigenstate_span_dense_one`
- `hamiltonian_isEssentiallySelfAdjoint_one`

## iii. Table of contents

- A. Proof schematic
- B. One-dimensional carrier equivalence
- C. Domain and symmetry
- D. Dense-eigenstate reduction

## iv. References

The continuum oscillator, Schwartz eigenstates, Hamiltonian action, and one-dimensional completeness
infrastructure are reused from Physlib revision `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`,
especially `Physlib.QuantumMechanics.HarmonicOscillator.Basic`, `NumberOperator`, `Eigenstates`, and
`OneDimension.Completeness`. The upstream informal essential-self-adjointness declaration is not
used as a proof.

## A. Proof schematic

```mermaid
flowchart TD
    kinetic["Project Koios momentum-square symmetry"]
    potential["Physlib quadratic potential<br/>self-adjoint"]
    domainIncl["Physlib Schwartz inclusion<br/>in Hamiltonian domain"]
    exactDomain["QHO-CONTINUUM-LEM-001<br/>domain = Schwartz"]
    symmetric["QHO-CONTINUUM-LEM-002<br/>Hamiltonian symmetric"]
    closable["QHO-CONTINUUM-LEM-003<br/>densely defined and closable"]
    carrier["QM-HILBERT-DEF-001<br/>legacy L²(ℝ) ≃ SpaceDHilbertSpace 1"]
    legacyComplete["Physlib 1D completeness<br/>with Plancherel premise"]
    fourierInjective["QM-FOURIER-LEM-001<br/>pointwise Fourier injectivity"]
    denseOne["QHO-CONTINUUM-LEM-006<br/>d = 1 conditional dense span"]
    denseOneUnconditional["QHO-CONTINUUM-LEM-008<br/>d = 1 dense span"]
    eigenEq["Physlib Cartesian eigenstate equations"]
    dense["explicit dense-span hypothesis"]
    esa["QHO-CONTINUUM-LEM-004<br/>essential self-adjointness"]
    esaOne["QHO-CONTINUUM-LEM-007<br/>d = 1 conditional ESA"]
    esaOneUnconditional["QHO-CONTINUUM-LEM-009<br/>d = 1 ESA"]

    carrier --> denseOne
    legacyComplete --> denseOne
    denseOne --> esaOne
    fourierInjective --> denseOneUnconditional
    carrier --> denseOneUnconditional
    denseOneUnconditional --> esaOneUnconditional
    domainIncl --> exactDomain
    kinetic --> symmetric
    potential --> symmetric
    exactDomain --> closable
    symmetric --> closable
    symmetric --> esa
    eigenEq --> esa
    dense --> esa
```
-/

@[expose] public section

open scoped LinearPMap

namespace ProjectKoios.QuantumMechanics.SpaceDHilbertSpace

open MeasureTheory
open _root_.QuantumMechanics

/-! ## B. One-dimensional carrier equivalence -/

/-- The linear isometric equivalence between Physlib's legacy one-dimensional quantum Hilbert
space `L²(ℝ, ℂ)` and its Cartesian carrier `SpaceDHilbertSpace 1`.

The map sends a representative `ψ` to `ψ ∘ Space.oneEquiv`, where `Space.oneEquiv` is Physlib's
measure-preserving linear isometry from `Space 1` to `ℝ`.

Project Koios ID: `QM-HILBERT-DEF-001`. -/
noncomputable def oneDimensionalEquiv :
    _root_.QuantumMechanics.OneDimension.HilbertSpace ≃ₗᵢ[ℂ]
      _root_.QuantumMechanics.SpaceDHilbertSpace 1 := by
  let forward :
      _root_.QuantumMechanics.OneDimension.HilbertSpace →ₗᵢ[ℂ]
        _root_.QuantumMechanics.SpaceDHilbertSpace 1 :=
    Lp.compMeasurePreservingₗᵢ ℂ Space.oneEquiv Space.oneEquiv_measurePreserving
  let inverse :
      _root_.QuantumMechanics.SpaceDHilbertSpace 1 →ₗᵢ[ℂ]
        _root_.QuantumMechanics.OneDimension.HilbertSpace :=
    Lp.compMeasurePreservingₗᵢ ℂ Space.oneEquiv.symm Space.oneEquiv_symm_measurePreserving
  apply LinearIsometryEquiv.ofLinearIsometry forward inverse.toLinearMap
  · apply LinearMap.ext
    intro ψ
    apply Lp.ext
    have hInverse :
        (inverse ψ : ℝ → ℂ) =ᵐ[volume]
          (ψ : Space 1 → ℂ) ∘ Space.oneEquiv.symm :=
      Lp.coeFn_compMeasurePreserving ψ Space.oneEquiv_symm_measurePreserving
    have hPullback :=
      Space.oneEquiv_measurePreserving.quasiMeasurePreserving.ae_eq_comp hInverse
    filter_upwards
        [Lp.coeFn_compMeasurePreserving (inverse ψ) Space.oneEquiv_measurePreserving,
          hPullback] with x hx₁ hx₂
    change ((Lp.compMeasurePreserving Space.oneEquiv Space.oneEquiv_measurePreserving
      (inverse ψ) : _root_.QuantumMechanics.SpaceDHilbertSpace 1) : Space 1 → ℂ) x = _
    rw [hx₁, hx₂, Function.comp_apply, Function.comp_apply, Space.oneEquiv.symm_apply_apply]
    rfl
  · apply LinearMap.ext
    intro ψ
    apply Lp.ext
    have hForward :
        (forward ψ : Space 1 → ℂ) =ᵐ[volume] (ψ : ℝ → ℂ) ∘ Space.oneEquiv :=
      Lp.coeFn_compMeasurePreserving ψ Space.oneEquiv_measurePreserving
    have hPullback :=
      Space.oneEquiv_symm_measurePreserving.quasiMeasurePreserving.ae_eq_comp hForward
    filter_upwards
        [Lp.coeFn_compMeasurePreserving (forward ψ) Space.oneEquiv_symm_measurePreserving,
          hPullback] with x hx₁ hx₂
    change ((Lp.compMeasurePreserving Space.oneEquiv.symm
      Space.oneEquiv_symm_measurePreserving (forward ψ) :
        _root_.QuantumMechanics.OneDimension.HilbertSpace) : ℝ → ℂ) x = _
    rw [hx₁, hx₂, Function.comp_apply, Function.comp_apply, Space.oneEquiv.apply_symm_apply]
    rfl

/-- The one-dimensional carrier equivalence acts almost everywhere by composition with
`Space.oneEquiv`.

Project Koios ID: `QM-HILBERT-LEM-001`. -/
lemma oneDimensionalEquiv_apply_ae
    (ψ : _root_.QuantumMechanics.OneDimension.HilbertSpace) :
    (oneDimensionalEquiv ψ : Space 1 → ℂ) =ᵐ[volume]
      (ψ : ℝ → ℂ) ∘ Space.oneEquiv := by
  change ((Lp.compMeasurePreserving Space.oneEquiv Space.oneEquiv_measurePreserving ψ :
    _root_.QuantumMechanics.SpaceDHilbertSpace 1) : Space 1 → ℂ) =ᵐ[volume] _
  exact Lp.coeFn_compMeasurePreserving ψ Space.oneEquiv_measurePreserving

end ProjectKoios.QuantumMechanics.SpaceDHilbertSpace

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

open FourierTransform InnerProductSpace MeasureTheory
open _root_.QuantumMechanics
open _root_.QuantumMechanics.SpaceDHilbertSpace
open ProjectKoios.QuantumMechanics.SpaceDHilbertSpace
open SchwartzMap SchwartzSubmodule

variable {d : ℕ}

/-! ## C. Domain and symmetry -/

/-- The domain of Physlib's continuum harmonic-oscillator Hamiltonian is exactly the Schwartz
submodule.

Project Koios ID: `QHO-CONTINUUM-LEM-001`. -/
lemma hamiltonian_domain_eq_schwartz
    (Q : _root_.QuantumMechanics.HarmonicOscillator d) :
    Q.hamiltonian.domain = SchwartzSubmodule d := by
  rw [_root_.QuantumMechanics.HarmonicOscillator.hamiltonain_eq,
    LinearPMap.add_domain,
    _root_.QuantumMechanics.HarmonicOscillator.kineticOperator,
    LinearPMap.smul_domain, momentumSqOperator_domain_eq]
  exact inf_eq_left.mpr fun ψ hψ => (Q.schwartzSubmodule_le_hamiltonian_domain hψ).2

/-- Physlib's continuum harmonic-oscillator Hamiltonian is symmetric on its exact Schwartz domain.

Project Koios ID: `QHO-CONTINUUM-LEM-002`. -/
lemma hamiltonian_isSymmetric
    (Q : _root_.QuantumMechanics.HarmonicOscillator d) :
    Q.hamiltonian.IsSymmetric := by
  intro ψ φ
  let ψS : SchwartzSubmodule d :=
    ⟨(ψ : Q.HS), by rw [← hamiltonian_domain_eq_schwartz Q]; exact ψ.2⟩
  let φS : SchwartzSubmodule d :=
    ⟨(φ : Q.HS), by rw [← hamiltonian_domain_eq_schwartz Q]; exact φ.2⟩
  obtain ⟨f, hf⟩ := (schwartzEquiv volume).surjective ψS
  obtain ⟨g, hg⟩ := (schwartzEquiv volume).surjective φS
  have hfH : (schwartzEquiv volume f : Q.HS) = (ψ : Q.HS) :=
    congrArg Subtype.val hf
  have hgH : (schwartzEquiv volume g : Q.HS) = (φ : Q.HS) :=
    congrArg Subtype.val hg
  have hfDom : (schwartzEquiv volume f : Q.HS) ∈ Q.hamiltonian.domain := by
    rw [hfH]
    exact ψ.2
  have hgDom : (schwartzEquiv volume g : Q.HS) ∈ Q.hamiltonian.domain := by
    rw [hgH]
    exact φ.2
  have hinner := Q.hamiltonian_inner_schwartz f g hfDom hgDom
  simpa [hfH, hgH] using hinner

/-- Physlib's continuum harmonic-oscillator Hamiltonian is densely defined and closable. Physlib
calls this conjunction `IsUnbounded`; it does not assert failure of boundedness.

Project Koios ID: `QHO-CONTINUUM-LEM-003`. -/
lemma hamiltonian_isUnbounded
    (Q : _root_.QuantumMechanics.HarmonicOscillator d) :
    Q.hamiltonian.IsUnbounded := by
  apply (hamiltonian_isSymmetric Q).isUnbounded_iff_hasDenseDomain.mpr
  rw [LinearPMap.hasDenseDomain_def, hamiltonian_domain_eq_schwartz]
  exact SchwartzSubmodule.dense d volume

/-! ## D. Dense-eigenstate reduction -/

/-- Physlib's continuum harmonic-oscillator Hamiltonian is essentially self-adjoint if its supplied
Cartesian energy eigenstates have dense complex span in `SpaceDHilbertSpace d`.

The eigenvalue equations are already proved upstream. The dense-span premise remains explicit and
is the unresolved completeness obligation at the adopted revision.

Project Koios ID: `QHO-CONTINUUM-LEM-004`. -/
lemma hamiltonian_isEssentiallySelfAdjoint_of_eigenstate_span_dense
    (Q : _root_.QuantumMechanics.HarmonicOscillator d)
    (hspan : Dense
      (Submodule.span ℂ (Set.range fun n : Fin d → ℕ => (Q.eigenstate n : Q.HS)) : Set Q.HS)) :
    Q.hamiltonian.IsEssentiallySelfAdjoint := by
  let v : (Fin d → ℕ) → Q.hamiltonian.domain := fun n =>
    ⟨Q.eigenstate n, Q.eigenstate_mem_hamiltonian_domain n⟩
  apply (hamiltonian_isSymmetric Q).isEssentiallySelfAdjoint_of_dense_span_eigenvectors
    (v := v) (c := fun n => (Q.eigenEnergy n : ℂ))
  · intro n
    exact Q.hamiltonian_eigenstate n _
  · simpa [v] using hspan

/-- The one-dimensional carrier equivalence sends Physlib's legacy oscillator eigenstate to the
corresponding Cartesian eigenstate with constant one-component quantum number.

Project Koios ID: `QHO-CONTINUUM-LEM-005`. -/
lemma oneDimensionalEquiv_eigenstate
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ) :
    oneDimensionalEquiv
      (_root_.QuantumMechanics.OneDimension.HilbertSpace.mk
        ((Q.oneDim 0).eigenfunction_memHS n)) =
      (Q.eigenstate (fun _ => n) : Q.HS) := by
  apply Lp.ext
  let ψ := _root_.QuantumMechanics.OneDimension.HilbertSpace.mk
    ((Q.oneDim 0).eigenfunction_memHS n)
  have hψ : (ψ : ℝ → ℂ) =ᵐ[volume] (Q.oneDim 0).eigenfunction n :=
    _root_.QuantumMechanics.OneDimension.HilbertSpace.coe_mk_ae _
  have hψPullback :=
    Space.oneEquiv_measurePreserving.quasiMeasurePreserving.ae_eq_comp hψ
  filter_upwards [oneDimensionalEquiv_apply_ae ψ, hψPullback,
      SchwartzSubmodule.schwartzEquiv_coe_ae (Q.eigenfunction (fun _ => n))] with x hx₁ hx₂ hx₃
  change (oneDimensionalEquiv ψ : Space 1 → ℂ) x =
    (((schwartzEquiv volume (Q.eigenfunction (fun _ => n)) : SchwartzSubmodule 1) : Q.HS) :
      Space 1 → ℂ) x
  rw [hx₁, hx₂, hx₃]
  simp only [Function.comp_apply]
  rw [Q.eigenfunction_eq_prod_oneDim]
  simp [Space.oneEquiv_coe]

/-- Physlib's Cartesian oscillator eigenstates have dense complex span in
`SpaceDHilbertSpace 1`, provided the integral-form Plancherel premise used by its legacy
one-dimensional completeness theorem.

This theorem transports completeness across `oneDimensionalEquiv`; it does not discharge or weaken
the upstream Plancherel premise.

Project Koios ID: `QHO-CONTINUUM-LEM-006`. -/
lemma eigenstate_span_dense_one_of_plancherel
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (plancherelTheorem : ∀ {f : ℝ → ℂ} (hf : Integrable f volume) (_ : MemLp f 2),
      eLpNorm (𝓕 f) 2 volume = eLpNorm f 2 volume) :
    Dense (Submodule.span ℂ
      (Set.range fun n : Fin 1 → ℕ => (Q.eigenstate n : Q.HS)) : Set Q.HS) := by
  let legacyEigenstate : ℕ → _root_.QuantumMechanics.OneDimension.HilbertSpace := fun n =>
    _root_.QuantumMechanics.OneDimension.HilbertSpace.mk
      ((Q.oneDim 0).eigenfunction_memHS n)
  have hLegacy :
      (Submodule.span ℂ (Set.range legacyEigenstate)).topologicalClosure = ⊤ :=
    (Q.oneDim 0).eigenfunction_completeness plancherelTheorem
  let carrierMap :
      _root_.QuantumMechanics.OneDimension.HilbertSpace →L[ℂ] Q.HS :=
    oneDimensionalEquiv.toContinuousLinearEquiv.toContinuousLinearMap
  have hMapped :
      ((Submodule.span ℂ (Set.range legacyEigenstate)).map
        carrierMap.toLinearMap).topologicalClosure = ⊤ :=
    oneDimensionalEquiv.surjective.denseRange.topologicalClosure_map_submodule hLegacy
  rw [Submodule.map_span] at hMapped
  have hImage :
      (carrierMap.toLinearMap :
        _root_.QuantumMechanics.OneDimension.HilbertSpace → Q.HS) ''
          Set.range legacyEigenstate =
        Set.range (fun n : ℕ => (Q.eigenstate (fun _ => n) : Q.HS)) := by
    ext ψ
    constructor
    · rintro ⟨_, ⟨n, rfl⟩, rfl⟩
      exact ⟨n, by
        simpa [carrierMap, legacyEigenstate] using (oneDimensionalEquiv_eigenstate Q n).symm⟩
    · rintro ⟨n, rfl⟩
      refine ⟨legacyEigenstate n, ⟨n, rfl⟩, ?_⟩
      simpa [carrierMap, legacyEigenstate] using oneDimensionalEquiv_eigenstate Q n
  rw [hImage] at hMapped
  apply Submodule.dense_iff_topologicalClosure_eq_top.mpr
  rw [show Set.range (fun n : Fin 1 → ℕ => (Q.eigenstate n : Q.HS)) =
      Set.range (fun n : ℕ => (Q.eigenstate (fun _ => n) : Q.HS)) by
    ext ψ
    constructor
    · rintro ⟨n, rfl⟩
      refine ⟨n 0, ?_⟩
      have hn : n = fun _ => n 0 := funext fun i => congrArg n (Subsingleton.elim i 0)
      rw [hn]
    · rintro ⟨n, rfl⟩
      exact ⟨fun _ => n, rfl⟩]
  exact hMapped

/-- The one-dimensional continuum harmonic-oscillator Hamiltonian is essentially self-adjoint,
provided the integral-form Plancherel premise used by Physlib's legacy completeness theorem.

Project Koios ID: `QHO-CONTINUUM-LEM-007`. -/
lemma hamiltonian_isEssentiallySelfAdjoint_one_of_plancherel
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (plancherelTheorem : ∀ {f : ℝ → ℂ} (hf : Integrable f volume) (_ : MemLp f 2),
      eLpNorm (𝓕 f) 2 volume = eLpNorm f 2 volume) :
    Q.hamiltonian.IsEssentiallySelfAdjoint :=
  hamiltonian_isEssentiallySelfAdjoint_of_eigenstate_span_dense Q
    (eigenstate_span_dense_one_of_plancherel Q plancherelTheorem)

private lemma legacy_zero_of_orthogonal_mk
    (Q : _root_.QuantumMechanics.OneDimension.HarmonicOscillator)
    (f : ℝ → ℂ) (hf : _root_.QuantumMechanics.OneDimension.HilbertSpace.MemHS f)
    (hOrth : ∀ n : ℕ,
      ⟪_root_.QuantumMechanics.OneDimension.HilbertSpace.mk (Q.eigenfunction_memHS n),
        _root_.QuantumMechanics.OneDimension.HilbertSpace.mk hf⟫_ℂ = 0) :
    _root_.QuantumMechanics.OneDimension.HilbertSpace.mk hf = 0 := by
  have hf' : (fun x => f x * ↑(Real.exp (- x ^ 2 / (2 * Q.ξ^2)))) =
      (fun x => f x * ↑(Real.exp (- (1 / (2 * Q.ξ^2)) * (x - 0) ^ 2))) := by
    funext x
    simp only [neg_mul, Complex.ofReal_exp, Complex.ofReal_div, Complex.ofReal_neg,
      Complex.ofReal_mul, Complex.ofReal_pow, Complex.ofReal_ofNat, sub_zero,
      mul_eq_mul_left_iff]
    left
    congr
    field_simp
    simp
  have hIntLp : MemLp (fun x => f x * Real.exp (- x^2 / (2 * Q.ξ^2))) 1 volume := by
    rw [hf']
    exact _root_.QuantumMechanics.OneDimension.HilbertSpace.mul_gaussian_mem_Lp_one
      f hf (1 / (2 * Q.ξ^2)) 0 (by simp)
  have hInt : Integrable (fun x => f x * Real.exp (- x^2 / (2 * Q.ξ^2))) volume :=
    memLp_one_iff_integrable.mp hIntLp
  have hWeightedZero :
      (fun x => f x * Real.exp (- x^2 / (2 * Q.ξ^2))) =ᵐ[volume] 0 :=
    ProjectKoios.QuantumMechanics.Fourier.ae_eq_zero_of_fourier_eq_zero _ hInt
      (Q.fourierIntegral_zero_of_mem_orthogonal f hf hOrth)
  have hfZero : f =ᵐ[volume] 0 := by
    filter_upwards [hWeightedZero] with x hx
    simp only [Pi.zero_apply, Complex.ofReal_exp, Complex.ofReal_div, Complex.ofReal_neg,
      Complex.ofReal_mul, Complex.ofReal_pow, Complex.ofReal_ofNat, mul_eq_zero,
      Complex.exp_ne_zero, or_false] at hx
    exact hx
  apply Lp.ext
  filter_upwards [_root_.QuantumMechanics.OneDimension.HilbertSpace.coe_mk_ae hf, hfZero]
    with x hx h0
  simpa using hx.trans h0

private lemma legacy_eigenfunction_completeness
    (Q : _root_.QuantumMechanics.OneDimension.HarmonicOscillator) :
    (Submodule.span ℂ (Set.range (fun n =>
      _root_.QuantumMechanics.OneDimension.HilbertSpace.mk
        (Q.eigenfunction_memHS n)))).topologicalClosure = ⊤ := by
  rw [Submodule.topologicalClosure_eq_top_iff]
  refine (Submodule.eq_bot_iff (Submodule.span ℂ
    (Set.range (fun n => _root_.QuantumMechanics.OneDimension.HilbertSpace.mk
      (Q.eigenfunction_memHS n))))ᗮ).mpr ?_
  intro f hf
  obtain ⟨f, hfMem, rfl⟩ :=
    _root_.QuantumMechanics.OneDimension.HilbertSpace.mk_surjective f
  apply legacy_zero_of_orthogonal_mk Q f hfMem
  intro n
  rw [@Submodule.mem_orthogonal'] at hf
  rw [← inner_conj_symm]
  have hl :
      ⟪_root_.QuantumMechanics.OneDimension.HilbertSpace.mk hfMem,
        _root_.QuantumMechanics.OneDimension.HilbertSpace.mk
          (Q.eigenfunction_memHS n)⟫_ℂ = 0 := by
    apply hf
    refine Finsupp.mem_span_range_iff_exists_finsupp.mpr ?_
    use Finsupp.single n 1
    simp
  rw [hl]
  simp

/-- Physlib's Cartesian oscillator eigenstates have dense complex span in
`SpaceDHilbertSpace 1`.

The proof replaces the integral-form Plancherel premise in Physlib's legacy completeness argument
with `ProjectKoios.QuantumMechanics.Fourier.ae_eq_zero_of_fourier_eq_zero`, then transports the
result across `oneDimensionalEquiv`.

Project Koios ID: `QHO-CONTINUUM-LEM-008`. -/
lemma eigenstate_span_dense_one
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    Dense (Submodule.span ℂ
      (Set.range fun n : Fin 1 → ℕ => (Q.eigenstate n : Q.HS)) : Set Q.HS) := by
  let legacyEigenstate : ℕ → _root_.QuantumMechanics.OneDimension.HilbertSpace := fun n =>
    _root_.QuantumMechanics.OneDimension.HilbertSpace.mk
      ((Q.oneDim 0).eigenfunction_memHS n)
  have hLegacy :
      (Submodule.span ℂ (Set.range legacyEigenstate)).topologicalClosure = ⊤ := by
    simpa [legacyEigenstate] using legacy_eigenfunction_completeness (Q.oneDim 0)
  let carrierMap :
      _root_.QuantumMechanics.OneDimension.HilbertSpace →L[ℂ] Q.HS :=
    oneDimensionalEquiv.toContinuousLinearEquiv.toContinuousLinearMap
  have hMapped :
      ((Submodule.span ℂ (Set.range legacyEigenstate)).map
        carrierMap.toLinearMap).topologicalClosure = ⊤ :=
    oneDimensionalEquiv.surjective.denseRange.topologicalClosure_map_submodule hLegacy
  rw [Submodule.map_span] at hMapped
  have hImage :
      (carrierMap.toLinearMap :
        _root_.QuantumMechanics.OneDimension.HilbertSpace → Q.HS) ''
          Set.range legacyEigenstate =
        Set.range (fun n : ℕ => (Q.eigenstate (fun _ => n) : Q.HS)) := by
    ext ψ
    constructor
    · rintro ⟨_, ⟨n, rfl⟩, rfl⟩
      exact ⟨n, by
        simpa [carrierMap, legacyEigenstate] using
          (oneDimensionalEquiv_eigenstate Q n).symm⟩
    · rintro ⟨n, rfl⟩
      refine ⟨legacyEigenstate n, ⟨n, rfl⟩, ?_⟩
      simpa [carrierMap, legacyEigenstate] using oneDimensionalEquiv_eigenstate Q n
  rw [hImage] at hMapped
  apply Submodule.dense_iff_topologicalClosure_eq_top.mpr
  rw [show Set.range (fun n : Fin 1 → ℕ => (Q.eigenstate n : Q.HS)) =
      Set.range (fun n : ℕ => (Q.eigenstate (fun _ => n) : Q.HS)) by
    ext ψ
    constructor
    · rintro ⟨n, rfl⟩
      refine ⟨n 0, ?_⟩
      have hn : n = fun _ => n 0 := funext fun i => congrArg n (Subsingleton.elim i 0)
      rw [hn]
    · rintro ⟨n, rfl⟩
      exact ⟨fun _ => n, rfl⟩]
  exact hMapped

/-- The one-dimensional continuum harmonic-oscillator Hamiltonian is essentially self-adjoint.

Project Koios ID: `QHO-CONTINUUM-LEM-009`. -/
lemma hamiltonian_isEssentiallySelfAdjoint_one
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    Q.hamiltonian.IsEssentiallySelfAdjoint :=
  hamiltonian_isEssentiallySelfAdjoint_of_eigenstate_span_dense Q
    (eigenstate_span_dense_one Q)

end ProjectKoios.QuantumMechanics.HarmonicOscillator
