/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-26
-/
module

public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.LinearAlgebra.Matrix.Trace
public import ProjectKoios.QuantumMechanics.FiniteDimensional.RankOneResolvent
public import ProjectKoios.SolidState.FiniteLattice.GaugeLoops

/-!
# Rank-one projector and Bargmann-loop crosswalk

This module connects two exact finite descriptions of the same ordered state loop. A state vector
`ψ` determines the rank-one outer-product matrix `|ψ⟩⟨ψ|`; this matrix is Hermitian for every
vector and is an idempotent projector when the vector has norm one. Products of these matrices
collapse to endpoint outer products multiplied by consecutive overlaps. Taking the trace supplies
the closing overlap and therefore equals the finite Bargmann loop product.

The crosswalk follows Mathlib's conjugate-linear-first inner-product convention. It also proves
that each rank-one state matrix, every ordered product of them, the loop trace, and the principal
argument of that trace are invariant under independent pointwise unit-modulus phase changes.

These are finite exact identities. The module does not identify a runtime array with a state,
certify normalization data from floating-point values, construct a numerical overlap mesh, select
loop orientation or sewing, unwrap argument branches, establish Chern integrality or continuum
topology, or establish physical applicability.
-/

@[expose] public section

open InnerProductSpace
open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.SolidState.FiniteLattice

universe u v

variable {V : Type u} {ι : Type v} [Fintype ι]

/-- `SS-GAUGE-DEF-013`: rank-one outer-product matrix `|ψ⟩⟨ψ|` associated with a finite complex
state vector. It is an idempotent projector only under a normalization premise. -/
noncomputable def pureStateProjectorMatrix
    (state : EuclideanSpace ℂ ι) : Matrix ι ι ℂ :=
  ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix state state

/-- `SS-GAUGE-DEF-014`: ordered product of rank-one state matrices at a start vertex and each
subsequently listed vertex. The empty tail contains the start matrix rather than the identity. -/
noncomputable def orderedStateProjectorProduct
    (state : V → EuclideanSpace ℂ ι) (start : V) : List V → Matrix ι ι ℂ
  | [] => pureStateProjectorMatrix (state start)
  | next :: rest =>
      pureStateProjectorMatrix (state start) *
        orderedStateProjectorProduct state next rest

/-- `SS-GAUGE-DEF-015`: trace of an ordered finite product of rank-one state matrices. -/
noncomputable def projectorLoopTrace (state : V → EuclideanSpace ℂ ι)
    (base : V) (tail : List V) : ℂ :=
  Matrix.trace (orderedStateProjectorProduct state base tail)

/-- `SS-GAUGE-DEF-016`: principal complex argument of the projector-loop trace. At a zero trace
this is Mathlib's totalized `Complex.arg`; no nonvanishing claim is inferred. -/
noncomputable def projectorLoopPhase (state : V → EuclideanSpace ℂ ι)
    (base : V) (tail : List V) : ℝ :=
  Complex.arg (projectorLoopTrace state base tail)

omit [Fintype ι] in
/-- `SS-GAUGE-THM-012`: entrywise form of the rank-one state matrix. -/
theorem pureStateProjectorMatrix_apply (state : EuclideanSpace ℂ ι) (i j : ι) :
    pureStateProjectorMatrix state i j = state i * conj (state j) := by
  rfl

omit [Fintype ι] in
/-- `SS-GAUGE-THM-013`: every rank-one state outer-product matrix is Hermitian, without a
normalization premise. -/
theorem pureStateProjectorMatrix_isHermitian (state : EuclideanSpace ℂ ι) :
    (pureStateProjectorMatrix state).IsHermitian := by
  exact ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix_self_isHermitian state

/-- `SS-GAUGE-THM-014`: the rank-one state matrix is an idempotent projector when its state vector
has norm one. -/
theorem pureStateProjectorMatrix_mul_self_of_norm_eq_one
    (state : EuclideanSpace ℂ ι) (hnorm : ‖state‖ = 1) :
    pureStateProjectorMatrix state * pureStateProjectorMatrix state =
      pureStateProjectorMatrix state := by
  simp only [pureStateProjectorMatrix]
  rw [ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix,
    Matrix.vecMulVec_mul_vecMulVec]
  have hinner : (fun i => conj (state i)) ⬝ᵥ (fun i => state i) = (1 : ℂ) := by
    calc
      (fun i => conj (state i)) ⬝ᵥ (fun i => state i) = ⟪state, state⟫_ℂ := by
        rw [dotProduct, PiLp.inner_apply]
        apply Finset.sum_congr rfl
        intro i hi
        simp only [RCLike.inner_apply']
      _ = 1 := inner_self_eq_one_of_norm_eq_one hnorm
  ext i j
  simp [Matrix.vecMulVec_apply, hinner]

/-- `SS-GAUGE-THM-015`: a pointwise unit-modulus phase change leaves the rank-one state matrix
unchanged. -/
theorem pureStateProjectorMatrix_phaseGaugeState
    (phase : V → unitary ℂ) (state : V → EuclideanSpace ℂ ι) (x : V) :
    pureStateProjectorMatrix (phaseGaugeState phase state x) =
      pureStateProjectorMatrix (state x) := by
  ext i j
  simp only [pureStateProjectorMatrix_apply, phaseGaugeState, PiLp.smul_apply, smul_eq_mul]
  rw [map_mul, starRingEnd_apply]
  have hu : star (phase x : ℂ) * (phase x : ℂ) = 1 := by
    change (↑(star (phase x) * phase x) : ℂ) = (↑(1 : unitary ℂ) : ℂ)
    rw [Unitary.star_mul_self]
  calc
    (phase x : ℂ) * state x i * (star (phase x : ℂ) * conj (state x j)) =
        (star (phase x : ℂ) * (phase x : ℂ)) *
          (state x i * conj (state x j)) := by ring
    _ = state x i * conj (state x j) := by rw [hu, one_mul]

/-- `SS-GAUGE-THM-016`: multiplying two finite rank-one matrices contracts the middle bra and ket
using Mathlib's complex inner product. -/
theorem rankOneMatrix_mul_rankOneMatrix
    (a b c d : EuclideanSpace ℂ ι) :
    ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix a b *
        ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix c d =
      ⟪b, c⟫_ℂ •
        ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix a d := by
  have hinner : (fun i => conj (b i)) ⬝ᵥ (fun i => c i) = ⟪b, c⟫_ℂ := by
    rw [dotProduct, PiLp.inner_apply]
    apply Finset.sum_congr rfl
    intro i hi
    simp only [RCLike.inner_apply']
  rw [ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix,
    ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix,
    Matrix.vecMulVec_mul_vecMulVec]
  ext i j
  simp [ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix,
    Matrix.vecMulVec_apply]
  rw [hinner]
  ring

/-- `SS-GAUGE-THM-017`: the trace of `|a⟩⟨b|` is `⟨b,a⟩`. -/
theorem trace_rankOneMatrix (a b : EuclideanSpace ℂ ι) :
    Matrix.trace (ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix a b) =
      ⟪b, a⟫_ℂ := by
  rw [ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix,
    Matrix.trace_vecMulVec]
  simp [dotProduct, PiLp.inner_apply]

/-- `SS-GAUGE-THM-018`: an ordered state-matrix product factors as the consecutive open-path
Bargmann product times one outer product joining the first and last states. -/
theorem orderedStateProjectorProduct_eq (state : V → EuclideanSpace ℂ ι)
    (start : V) (tail : List V) :
    orderedStateProjectorProduct state start tail =
      orderedLinkProduct (bargmannLink state) start tail •
        ProjectKoios.QuantumMechanics.FiniteDimensional.rankOneMatrix
          (state start) (state (pathEndpoint start tail)) := by
  induction tail generalizing start with
  | nil =>
      simp [orderedStateProjectorProduct, orderedLinkProduct, pathEndpoint,
        pureStateProjectorMatrix]
  | cons next rest ih =>
      simp only [orderedStateProjectorProduct, orderedLinkProduct, pathEndpoint]
      rw [ih]
      rw [Matrix.mul_smul]
      rw [pureStateProjectorMatrix, rankOneMatrix_mul_rankOneMatrix]
      simp only [bargmannLink]
      rw [smul_smul, mul_comm]

/-- `SS-GAUGE-THM-019`: the full ordered product of rank-one state matrices is unchanged by
independent pointwise unit-modulus phase changes. -/
theorem orderedStateProjectorProduct_phaseGaugeState
    (phase : V → unitary ℂ) (state : V → EuclideanSpace ℂ ι)
    (start : V) (tail : List V) :
    orderedStateProjectorProduct (phaseGaugeState phase state) start tail =
      orderedStateProjectorProduct state start tail := by
  induction tail generalizing start with
  | nil =>
      simp only [orderedStateProjectorProduct]
      exact pureStateProjectorMatrix_phaseGaugeState phase state start
  | cons next rest ih =>
      simp only [orderedStateProjectorProduct]
      rw [pureStateProjectorMatrix_phaseGaugeState, ih]

/-- `SS-GAUGE-THM-020`: the trace of an ordered rank-one projector product is exactly the
corresponding closed Bargmann overlap product, including the final overlap back to the base. -/
theorem projectorLoopTrace_eq_bargmannLoopProduct
    (state : V → EuclideanSpace ℂ ι) (base : V) (tail : List V) :
    projectorLoopTrace state base tail = bargmannLoopProduct state base tail := by
  rw [projectorLoopTrace, orderedStateProjectorProduct_eq, Matrix.trace_smul,
    trace_rankOneMatrix]
  rfl

/-- `SS-GAUGE-THM-021`: the projector-loop trace is invariant under independent pointwise
unit-modulus phase changes. -/
theorem projectorLoopTrace_phaseGaugeState
    (phase : V → unitary ℂ) (state : V → EuclideanSpace ℂ ι)
    (base : V) (tail : List V) :
    projectorLoopTrace (phaseGaugeState phase state) base tail =
      projectorLoopTrace state base tail := by
  rw [projectorLoopTrace_eq_bargmannLoopProduct,
    projectorLoopTrace_eq_bargmannLoopProduct,
    bargmannLoopProduct_phaseGaugeState]

/-- `SS-GAUGE-THM-022`: the principal argument of the projector-loop trace is exactly the
principal Bargmann-loop phase. -/
theorem projectorLoopPhase_eq_bargmannLoopPhase
    (state : V → EuclideanSpace ℂ ι) (base : V) (tail : List V) :
    projectorLoopPhase state base tail = bargmannLoopPhase state base tail := by
  rw [projectorLoopPhase, bargmannLoopPhase, projectorLoopTrace_eq_bargmannLoopProduct]

/-- `SS-GAUGE-THM-023`: the principal projector-loop phase is invariant under independent
pointwise unit-modulus phase changes. -/
theorem projectorLoopPhase_phaseGaugeState
    (phase : V → unitary ℂ) (state : V → EuclideanSpace ℂ ι)
    (base : V) (tail : List V) :
    projectorLoopPhase (phaseGaugeState phase state) base tail =
      projectorLoopPhase state base tail := by
  rw [projectorLoopPhase_eq_bargmannLoopPhase,
    projectorLoopPhase_eq_bargmannLoopPhase,
    bargmannLoopPhase_phaseGaugeState]

end ProjectKoios.SolidState.FiniteLattice
