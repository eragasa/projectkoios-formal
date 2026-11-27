/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.HilbertBasis
public import ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteLadder
public import Mathlib.Analysis.CStarAlgebra.Matrix

/-!
# Exact finite spectral compression of the continuum oscillator

The existing retained diagonal oscillator matrix is the exact finite spectral compression of the
selected one-dimensional continuum Hamiltonian closure.

## i. Overview

For cutoff `K`, coefficients belong to Mathlib's `EuclideanSpace ℂ (Fin (K+1))`, with its `ℓ²` norm,
not the default sup norm of a function type. The embedding

`J_K c = ∑ k : Fin (K+1), c k • e_(k.val)`

is a linear isometry and has an explicit lift into `Q.hamiltonian.closure.domain`. With physical
energy scale `ℏ ω₀`, the already-defined real matrix `retainedHarmonicOscillatorHamiltonian` is
mapped entrywise into `ℂ` and acted on using Mathlib's `Matrix.toEuclideanCLM`. No second retained
Hamiltonian is defined. The exact intertwining identity is `H̄ J_K c = J_K (H_K c)`, with the left
side evaluated through the domain lift. Taking the isometry adjoint yields the compression
identity, and preservation of inner products yields equality of quadratic energies.

Here `K` is the highest retained index and the dimension is `K+1`. For Hilbert-coordinate input,
the domain embedding equals `oneDimensionalEigenstateDomainPartialSum Q (K+1) ψ`, so the existing
orbital, density, graph-norm, and energy approximation results concern the same partial sums.

The binding is to the direct diagonal Hamiltonian, not to an expression reconstructed from finite
creation/annihilation products; their highest-state defect remains separate. The finite embedding
is not asserted to be onto the whole continuum Hilbert space. No sampled-grid, quadrature,
floating-point, numerical eigensolver, Kohn--Sham eigenbasis, or physical-validation claim follows.

## ii. Key results

- `retainedEigenstateDomainEmbedding`: coefficient reconstruction in the actual closure domain.
- `retainedEigenstateEmbedding`: the corresponding ambient linear isometry.
- `retainedHamiltonian_complex_eq_eigenEnergy_diagonal`: exact existing-matrix identification.
- `retainedEigenstateHamiltonian_action`: domain-safe continuum/finite intertwining.
- `retainedEigenstateHamiltonian_compression`: adjoint compression equals the finite action.
- `retainedEigenstateHamiltonian_quadraticEnergy`: identical finite and continuum quadratic energy.
- `retainedEigenstateDomainEmbedding_coefficients_eq_partialSum`: exact partial-sum crosswalk.

## iii. Table of contents

- A. Domain embedding and isometry
- B. Existing matrix and continuum action
- C. Partial-sum crosswalk
- D. Proof schematic

## iv. References

Reuses `QHO-LADDER-DEF-006` for the exact retained diagonal matrix, the proved oscillator eigenstate
Hilbert basis and selected-closure eigenvalue equation, and Mathlib `Orthonormal.inner_sum`,
`LinearMap.isometryOfInner`, `Matrix.toEuclideanCLM`, and `LinearIsometry.adjoint_comp_self`.
The selected continuum operator remains exactly `Q.hamiltonian.closure`, as packaged by
`oneDimensionalQuantumSystem`. This source-neutral binding adds no publication crosswalk.

## D. Proof schematic

```mermaid
flowchart TD
    basis["QHO-HILBERT-LEM-001<br/>oscillator eigenstate orthonormality"] --> domain["QHO-FINITE-SPECTRAL-DEF-001<br/>domain-valued coefficient embedding"]
    eigen["QHO-HILBERT-LEM-005<br/>selected closure eigenstate equation"] --> domain
    domain --> isometry["QHO-FINITE-SPECTRAL-DEF-002<br/>ambient Euclidean linear isometry"]
    matrix["QHO-LADDER-DEF-006<br/>existing real diagonal Hamiltonian"] --> identify["QHO-FINITE-SPECTRAL-LEM-004<br/>complex diagonal identification"]
    identify --> action["QHO-FINITE-SPECTRAL-LEM-005<br/>exact intertwining"]
    domain --> action
    eigen --> action
    action --> compression["QHO-FINITE-SPECTRAL-LEM-006<br/>adjoint compression"]
    isometry --> compression
    action --> energyEq["QHO-FINITE-SPECTRAL-LEM-007<br/>equal quadratic energies"]
    isometry --> energyEq
    domain --> partial["QHO-FINITE-SPECTRAL-LEM-008<br/>same K+1-term partial sums"]
```
-/

@[expose] public section

open scoped BigOperators InnerProductSpace Matrix

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/-! ## A. Domain embedding and isometry -/

/--
Embed finite Euclidean coefficients in the selected oscillator Hamiltonian closure domain.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-DEF-001`.

The image is in the domain because it is a finite linear combination of domain eigenvectors.
No domain membership is assumed of an unrelated target continuum state.
-/
noncomputable def retainedEigenstateDomainEmbedding
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) :
    EuclideanSpace ℂ (Fin (K+1)) →ₗ[ℂ] Q.hamiltonian.closure.domain where
  toFun c := ∑ k : Fin (K+1), c k •
    ⟨oneDimensionalEigenstateHilbertBasis Q k.val,
      oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k.val⟩
  map_add' c d := by
    apply Subtype.ext
    simp [add_smul, Finset.sum_add_distrib]
  map_smul' a c := by
    apply Subtype.ext
    simp [smul_smul, Finset.smul_sum]

/--
The domain embedding has the declared finite coefficient expansion in the ambient Hilbert space.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-001`.
-/
lemma retainedEigenstateDomainEmbedding_coe
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    (retainedEigenstateDomainEmbedding Q K c : Q.HS) =
      ∑ k : Fin (K+1), c k • oneDimensionalEigenstateHilbertBasis Q k.val := by
  simp [retainedEigenstateDomainEmbedding]

/--
The first `K+1` oscillator Hilbert-basis vectors form an orthonormal finite family.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-002`.
-/
lemma retainedEigenstateFamily_orthonormal
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) :
    Orthonormal ℂ (fun k : Fin (K+1) => oneDimensionalEigenstateHilbertBasis Q k.val) :=
  (oneDimensionalEigenstateHilbertBasis Q).orthonormal.comp Fin.val Fin.val_injective

/--
The finite oscillator coefficient embedding as a Mathlib linear isometry.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-DEF-002`.

Both coefficients and continuum states use their `ℓ²`/`L²` inner-product norms. Unit coefficient
norm is therefore equivalent to unit norm of the embedded vector, but normalization is not assumed
of arbitrary supplied coefficients. This is not a surjectivity or full resolution-of-identity claim.
-/
noncomputable def retainedEigenstateEmbedding
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) :
    EuclideanSpace ℂ (Fin (K+1)) →ₗᵢ[ℂ] Q.HS :=
  (Q.hamiltonian.closure.domain.subtype.comp (retainedEigenstateDomainEmbedding Q K)).isometryOfInner
    (by
      intro c d
      change ⟪(retainedEigenstateDomainEmbedding Q K c : Q.HS),
        (retainedEigenstateDomainEmbedding Q K d : Q.HS)⟫_ℂ = _
      rw [retainedEigenstateDomainEmbedding_coe, retainedEigenstateDomainEmbedding_coe,
        (retainedEigenstateFamily_orthonormal Q K).inner_sum]
      simp [PiLp.inner_apply, RCLike.inner_apply, mul_comm])

/--
The ambient linear isometry is exactly the coercion of the domain-valued embedding.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-003`.
-/
lemma retainedEigenstateEmbedding_apply
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    retainedEigenstateEmbedding Q K c = (retainedEigenstateDomainEmbedding Q K c : Q.HS) := rfl

/-! ## B. Existing matrix and continuum action -/

/--
The existing real retained Hamiltonian, complexified entrywise at scale `ℏ ω₀`, is the diagonal
matrix of the corresponding continuum oscillator eigenvalues.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-004`.
-/
lemma retainedHamiltonian_complex_eq_eigenEnergy_diagonal
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) :
    (retainedHarmonicOscillatorHamiltonian K ((Constants.ℏ : ℝ) * Q.ω 0)).map Complex.ofReal =
      Matrix.diagonal (fun k : Fin (K+1) => (Q.eigenEnergy (fun _ => k.val) : ℂ)) := by
  ext i j
  by_cases h : i=j
  · subst j
    simp [retainedHarmonicOscillatorHamiltonian, retainedNumberStateEnergy,
      oneDimensionalEigenEnergy_eq]
  · simp [retainedHarmonicOscillatorHamiltonian, h]

/--
The continuum closure and the existing finite retained matrix intertwine exactly through the
coefficient embedding.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-005`.

The partial operator is applied only to the explicit domain lift. The finite matrix action uses
Mathlib's existing Euclidean continuous-linear-map representation; the continuum Hamiltonian is
not relabeled as a bounded operator on the whole Hilbert space.
-/
lemma retainedEigenstateHamiltonian_action
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    Q.hamiltonian.closure (retainedEigenstateDomainEmbedding Q K c) =
      retainedEigenstateEmbedding Q K
        (Matrix.toEuclideanCLM (n := Fin (K+1)) (𝕜 := ℂ)
          ((retainedHarmonicOscillatorHamiltonian K ((Constants.ℏ : ℝ) * Q.ω 0)).map Complex.ofReal) c) := by
  change Q.hamiltonian.closure.toFun (∑ k : Fin (K+1), c k •
    ⟨oneDimensionalEigenstateHilbertBasis Q k.val,
      oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k.val⟩) = _
  rw [map_sum]
  simp only [map_smul]
  change (∑ k : Fin (K+1), c k • Q.hamiltonian.closure
    ⟨oneDimensionalEigenstateHilbertBasis Q k.val,
      oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k.val⟩) = _
  rw [retainedEigenstateEmbedding_apply, retainedEigenstateDomainEmbedding_coe,
    retainedHamiltonian_complex_eq_eigenEnergy_diagonal]
  simp only [oneDimensionalHamiltonianClosure_eigenstate, smul_smul]
  apply Finset.sum_congr rfl
  intro k _
  congr 1
  rw [Matrix.ofLp_toEuclideanCLM, Matrix.mulVec_diagonal]
  simp [mul_comm]

/--
Adjoint compression of the selected continuum Hamiltonian action equals the existing finite matrix
action on all coefficient vectors.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-006`.

The identity `J_K* H̄ J_K c = H_K c` is stated with domain-safe evaluation of `H̄`, not an invalid
composition treating an unbounded partial operator as an everywhere-defined continuous map.
-/
lemma retainedEigenstateHamiltonian_compression
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    (retainedEigenstateEmbedding Q K).toContinuousLinearMap.adjoint
      (Q.hamiltonian.closure (retainedEigenstateDomainEmbedding Q K c)) =
      Matrix.toEuclideanCLM (n := Fin (K+1)) (𝕜 := ℂ)
        ((retainedHarmonicOscillatorHamiltonian K ((Constants.ℏ : ℝ) * Q.ω 0)).map Complex.ofReal) c := by
  rw [retainedEigenstateHamiltonian_action]
  have h := congrArg (fun f : EuclideanSpace ℂ (Fin (K+1)) →L[ℂ] EuclideanSpace ℂ (Fin (K+1)) =>
    f (Matrix.toEuclideanCLM (n := Fin (K+1)) (𝕜 := ℂ)
      ((retainedHarmonicOscillatorHamiltonian K ((Constants.ℏ : ℝ) * Q.ω 0)).map Complex.ofReal) c))
    (retainedEigenstateEmbedding Q K).adjoint_comp_self
  simpa only [ContinuousLinearMap.comp_apply, one_apply_eq_self,
    LinearIsometry.coe_toContinuousLinearMap] using h

/--
The finite matrix quadratic energy equals Physlib's continuum quadratic energy of the embedded
coefficient vector.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-007`.

This is valid for arbitrary coefficients. For unit coefficients the isometry supplies unit
continuum norm; otherwise the equation concerns unnormalized quadratic energies.
-/
lemma retainedEigenstateHamiltonian_quadraticEnergy
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    Q.hamiltonian.closure.expectedValue (retainedEigenstateDomainEmbedding Q K c) =
      (⟪c, Matrix.toEuclideanCLM (n := Fin (K+1)) (𝕜 := ℂ)
        ((retainedHarmonicOscillatorHamiltonian K ((Constants.ℏ : ℝ) * Q.ω 0)).map Complex.ofReal)
          c⟫_ℂ).re := by
  unfold LinearPMap.expectedValue
  rw [retainedEigenstateHamiltonian_action, ← retainedEigenstateEmbedding_apply,
    (retainedEigenstateEmbedding Q K).inner_map_map]

/-! ## C. Partial-sum crosswalk -/

/--
Embedding the first `K+1` Hilbert coefficients yields exactly the previously defined domain-valued
oscillator partial sum at cutoff `K+1`.

Project Koios declaration ID: `QHO-FINITE-SPECTRAL-LEM-008`.

This is the explicit highest-index-versus-term-count crosswalk needed to reuse the existing
orbital, density, graph-norm, and energy approximation theorems without identifying different
finite and continuum carriers by definition.
-/
lemma retainedEigenstateDomainEmbedding_coefficients_eq_partialSum
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (ψ : Q.HS) :
    retainedEigenstateDomainEmbedding Q K (WithLp.toLp 2 (fun k : Fin (K+1) =>
      ⟪oneDimensionalEigenstateHilbertBasis Q k.val, ψ⟫_ℂ)) =
      oneDimensionalEigenstateDomainPartialSum Q (K+1) ψ := by
  apply Subtype.ext
  rw [retainedEigenstateDomainEmbedding_coe, oneDimensionalEigenstateDomainPartialSum_coe]
  change (∑ k : Fin (K+1),
    ⟪oneDimensionalEigenstateHilbertBasis Q k.val, ψ⟫_ℂ •
      oneDimensionalEigenstateHilbertBasis Q k.val) = _
  exact Fin.sum_univ_eq_sum_range (fun k : ℕ =>
    ⟪oneDimensionalEigenstateHilbertBasis Q k, ψ⟫_ℂ • oneDimensionalEigenstateHilbertBasis Q k) (K+1)

end ProjectKoios.QuantumMechanics.HarmonicOscillator
