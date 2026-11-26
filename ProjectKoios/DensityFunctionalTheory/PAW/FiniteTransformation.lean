/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-26
-/
module

public import Mathlib.Basic.Complex.Basic
public import Mathlib.Analysis.Matrix.PosDef
public import Mathlib.LinearAlgebra.Matrix.Invertible

/-!
# Exact finite-dimensional PAW transformation algebra

This module introduces the first projector-augmented-wave semantic layer. A supplied square complex
matrix `T` represents the finite-dimensional PAW transformation from a smooth pseudo-state to its
reconstructed all-electron state. The induced operator and metric are fixed by

`ψ = T ψ̃`,

`Ã = Tᴴ A T`,

`S = Tᴴ T`.

The module proves that `S` is Hermitian and positive semidefinite, is positive definite when the
state transformation is injective, and that Hermiticity, sesquilinear pairings, expectation values,
and eigenvalue equations transport through these definitions. The principal result identifies the
standard reconstructed-state eigenproblem with the generalized pseudo-state eigenproblem when `T`
is invertible.

## Source locators

* Blöchl, “Projector Augmented-Wave Method,” Physical Review B 50 (1994), DOI
  `10.1103/PhysRevB.50.17953`:
  * Section II.A, equations (8)--(9), for the PAW transformation and state reconstruction;
  * Section II.B, equation (11), for `Ã = T† A T`;
  * Section IV.A, equation (30), for `S = T† T`.
* Kresse and Joubert, “From Ultrasoft Pseudopotentials to the Projector Augmented-Wave Method,”
  Physical Review B 59 (1999), DOI `10.1103/PhysRevB.59.1758`:
  * Section III.A, equations (38)--(40), for pseudo-state orthonormality and overlap;
  * Section III.D, the generalized Kohn--Sham equation displayed immediately after equation (51).

Proposed citekeys: `Blochl1994` and `Kresse1999`. The inspected source identities remain candidates
pending the References workflow. The Blöchl scan equations were checked against rendered page
images; OCR was used only for discovery.

## Conventions and statement delta

The same finite index type is used for pseudo and reconstructed coordinates, so `T` is square.
Conjugate transpose is Mathlib's `Matrix.conjTranspose`; matrix action is `Matrix.mulVec`; and the
sesquilinear pairing is `star x ⬝ᵥ y`, conjugate-linear in the first argument.

The converse generalized-eigenproblem theorem first exposes the exact necessary hypothesis that
left multiplication by `Tᴴ` on vectors is injective. The principal corollary derives that hypothesis
from `IsUnit T`. No claim is made that a concrete PAW construction satisfies invertibility.

## Explicit limitations

This layer does not define the finite-rank partial-wave/projector formula for `T`, augmentation
regions, dual projectors, compensation charges, density or total-energy decompositions, frozen-core
approximations, plane-wave cutoffs, datasets, numerical algorithms, or material accuracy. It is
exact finite matrix algebra for supplied data, not a validation theorem for PAW calculations.
-/

open scoped ComplexConjugate ComplexOrder Matrix

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.PAW

/--
`DFT-PAW-TRANSFORM-DEF-001`: a finite PAW transformation represented by a square complex matrix.

The abbreviation adds PAW semantics to a supplied matrix but does not assert invertibility,
locality, or a partial-wave/projector construction.
-/
abbrev FinitePawTransformation (Index : Type*) := Matrix Index Index ℂ

variable {Index : Type*} [Fintype Index]

/--
`DFT-PAW-TRANSFORM-DEF-002`: reconstruct an all-electron coordinate vector as `ψ = T ψ̃`.

Source binding: Blöchl (1994), Section II.A, equations (8)--(9), abstracted from the explicit
finite-rank projector formula to a supplied finite transformation matrix.
-/
def FinitePawTransformation.reconstructState
    (transformation : FinitePawTransformation Index)
    (pseudoState : Index → ℂ) : Index → ℂ :=
  transformation *ᵥ pseudoState

/--
`DFT-PAW-TRANSFORM-DEF-003`: transport an operator by PAW congruence, `Ã = Tᴴ A T`.

Source binding: Blöchl (1994), Section II.B, equation (11). The explicit one-center expansion in that
equation is deliberately deferred.
-/
def FinitePawTransformation.transformedOperator
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) : Matrix Index Index ℂ :=
  transformationᴴ * operator * transformation

/--
`DFT-PAW-TRANSFORM-DEF-004`: induced pseudo-space overlap matrix `S = Tᴴ T`.

Source binding: Blöchl (1994), Section IV.A, equation (30), and Kresse--Joubert (1999), Section III.A,
equations (38)--(40).
-/
def FinitePawTransformation.overlapMatrix
    (transformation : FinitePawTransformation Index) : Matrix Index Index ℂ :=
  transformationᴴ * transformation

/--
`DFT-PAW-TRANSFORM-DEF-005`: the reconstructed state `T ψ̃` is an eigenvector of the supplied
all-electron operator with the supplied complex eigenvalue.

The eigenvalue is allowed to be complex because this predicate does not build Hermiticity into its
data. A later use may supply Hermiticity and derive additional spectral information separately.
-/
def FinitePawTransformation.IsReconstructedEigenpair
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ)
    (pseudoState : Index → ℂ) (energy : ℂ) : Prop :=
  operator *ᵥ transformation.reconstructState pseudoState =
    energy • transformation.reconstructState pseudoState

/--
`DFT-PAW-TRANSFORM-DEF-006`: generalized pseudo-state eigenproblem `Ã ψ̃ = ε S ψ̃`.

This is the exact finite algebraic form of the PAW generalized Kohn--Sham equation. It does not
assert that the state is normalized in the overlap metric or that it is a self-consistent solution.
-/
def FinitePawTransformation.IsGeneralizedEigenpair
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ)
    (pseudoState : Index → ℂ) (energy : ℂ) : Prop :=
  transformation.transformedOperator operator *ᵥ pseudoState =
    energy • (transformation.overlapMatrix *ᵥ pseudoState)

/-- `DFT-PAW-TRANSFORM-LEM-001`: every induced overlap matrix is Hermitian. -/
lemma FinitePawTransformation.overlapMatrix_isHermitian
    (transformation : FinitePawTransformation Index) :
    transformation.overlapMatrix.IsHermitian := by
  exact Matrix.isHermitian_conjTranspose_mul_self transformation

/--
`DFT-PAW-TRANSFORM-LEM-002`: every induced overlap matrix is positive semidefinite.

The complex order used by Mathlib reduces the quadratic-form statement to nonnegativity of its real
part. No injectivity hypothesis is needed.
-/
lemma FinitePawTransformation.overlapMatrix_posSemidef
    (transformation : FinitePawTransformation Index) :
    transformation.overlapMatrix.PosSemidef := by
  exact Matrix.posSemidef_conjTranspose_mul_self transformation

/--
`DFT-PAW-TRANSFORM-LEM-003`: an injective state transformation induces a positive-definite overlap.

The hypothesis is stated directly on `Matrix.mulVec`; it is not inferred from a PAW dataset or from
partial-wave completeness.
-/
lemma FinitePawTransformation.overlapMatrix_posDef
    (transformation : FinitePawTransformation Index)
    (hinjective : Function.Injective transformation.mulVec) :
    transformation.overlapMatrix.PosDef := by
  exact Matrix.PosDef.conjTranspose_mul_self transformation hinjective

/--
`DFT-PAW-TRANSFORM-LEM-004`: PAW congruence preserves Hermiticity of the supplied operator.
-/
lemma FinitePawTransformation.transformedOperator_isHermitian
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) (hoperator : operator.IsHermitian) :
    (transformation.transformedOperator operator).IsHermitian := by
  exact Matrix.isHermitian_conjTranspose_mul_mul transformation hoperator

/--
`DFT-PAW-TRANSFORM-LEM-005`: physical inner products of reconstructed states equal overlap-metric
pairings of pseudo states.

This identity is the finite algebra behind Kresse--Joubert (1999), equation (38). It does not impose
the Kronecker-delta orthonormality condition appearing there.
-/
lemma FinitePawTransformation.overlap_pairing_transport
    (transformation : FinitePawTransformation Index)
    (left right : Index → ℂ) :
    star (transformation.reconstructState left) ⬝ᵥ
        transformation.reconstructState right =
      star left ⬝ᵥ (transformation.overlapMatrix *ᵥ right) := by
  -- Move the left transformation through the conjugate-linear slot as `Tᴴ`, then reassociate the
  -- two matrix-vector products. This is exact finite sesquilinear algebra.
  simp only [FinitePawTransformation.reconstructState,
    FinitePawTransformation.overlapMatrix, ← Matrix.mulVec_mulVec,
    Matrix.dotProduct_mulVec, Matrix.vecMul_conjTranspose, star_star]

/--
`DFT-PAW-TRANSFORM-LEM-006`: all-electron operator pairings equal pairings with the transported
pseudo-space operator.

Taking equal left and right states gives expectation-value transport. No Hermiticity premise is
needed for the algebraic identity itself.
-/
lemma FinitePawTransformation.operator_pairing_transport
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) (left right : Index → ℂ) :
    star (transformation.reconstructState left) ⬝ᵥ
        (operator *ᵥ transformation.reconstructState right) =
      star left ⬝ᵥ (transformation.transformedOperator operator *ᵥ right) := by
  -- The proof is the same adjoint transport as for the overlap, with `operator` retained between
  -- the two transformation factors.
  simp only [FinitePawTransformation.reconstructState,
    FinitePawTransformation.transformedOperator, ← Matrix.mulVec_mulVec,
    Matrix.dotProduct_mulVec, Matrix.vecMul_conjTranspose, star_star]

/--
`DFT-PAW-TRANSFORM-LEM-007`: expectation values transport exactly to the transformed operator.

This is the equal-state specialization of `operator_pairing_transport`. It remains an unnormalized
quadratic-form identity; division by a norm or overlap expectation is not performed here.
-/
lemma FinitePawTransformation.operator_expectation_transport
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) (pseudoState : Index → ℂ) :
    star (transformation.reconstructState pseudoState) ⬝ᵥ
        (operator *ᵥ transformation.reconstructState pseudoState) =
      star pseudoState ⬝ᵥ
        (transformation.transformedOperator operator *ᵥ pseudoState) := by
  exact transformation.operator_pairing_transport operator pseudoState pseudoState

/--
`DFT-PAW-TRANSFORM-LEM-008`: a standard eigenproblem for the reconstructed state implies the PAW
generalized eigenproblem for the pseudo state.

Only left multiplication by `Tᴴ` is used, so this direction requires no injectivity or invertibility.
-/
lemma FinitePawTransformation.isGeneralizedEigenpair_of_isReconstructedEigenpair
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) (pseudoState : Index → ℂ) (energy : ℂ)
    (hreconstructed : transformation.IsReconstructedEigenpair
      operator pseudoState energy) :
    transformation.IsGeneralizedEigenpair operator pseudoState energy := by
  rw [FinitePawTransformation.IsReconstructedEigenpair,
    FinitePawTransformation.reconstructState] at hreconstructed
  rw [FinitePawTransformation.IsGeneralizedEigenpair,
    FinitePawTransformation.transformedOperator,
    FinitePawTransformation.overlapMatrix,
    ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    ← Matrix.mulVec_mulVec, hreconstructed, Matrix.mulVec_smul]

/--
`DFT-PAW-TRANSFORM-LEM-009`: generalized and reconstructed eigenproblems are equivalent when the
adjoint transformation acts injectively on vectors.

The reverse implication cancels the `Tᴴ` introduced by the generalized equation. The hypothesis is
exposed rather than hidden behind an unsupported PAW completeness claim.
-/
lemma FinitePawTransformation.isGeneralizedEigenpair_iff_isReconstructedEigenpair
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) (pseudoState : Index → ℂ) (energy : ℂ)
    (hadjoint : Function.Injective transformationᴴ.mulVec) :
    transformation.IsGeneralizedEigenpair operator pseudoState energy ↔
      transformation.IsReconstructedEigenpair operator pseudoState energy := by
  constructor
  · intro hgeneralized
    rw [FinitePawTransformation.IsGeneralizedEigenpair,
      FinitePawTransformation.transformedOperator,
      FinitePawTransformation.overlapMatrix,
      ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
      ← Matrix.mulVec_mulVec] at hgeneralized
    rw [FinitePawTransformation.IsReconstructedEigenpair,
      FinitePawTransformation.reconstructState]
    apply hadjoint
    simpa only [Matrix.mulVec_smul] using hgeneralized
  · exact transformation.isGeneralizedEigenpair_of_isReconstructedEigenpair
      operator pseudoState energy

/--
`DFT-PAW-TRANSFORM-THM-001`: for an invertible finite PAW transformation, the generalized
pseudo-state eigenproblem is equivalent to the standard eigenproblem for the reconstructed state.

Source binding: Blöchl (1994), equations (9), (11), and (30), together with the generalized
Kohn--Sham equation displayed in Kresse--Joubert (1999), Section III.D, immediately after equation
(51). Lean states invertibility explicitly as `IsUnit T`; neither source identity nor a concrete PAW
dataset is used to manufacture this premise.
-/
theorem FinitePawTransformation.isGeneralizedEigenpair_iff_isReconstructedEigenpair_of_isUnit
    [DecidableEq Index]
    (transformation : FinitePawTransformation Index)
    (operator : Matrix Index Index ℂ) (pseudoState : Index → ℂ) (energy : ℂ)
    (hinvertible : IsUnit transformation) :
    transformation.IsGeneralizedEigenpair operator pseudoState energy ↔
      transformation.IsReconstructedEigenpair operator pseudoState energy := by
  apply transformation.isGeneralizedEigenpair_iff_isReconstructedEigenpair
  exact Matrix.mulVec_injective_of_isUnit
    ((Matrix.isUnit_conjTranspose transformation).mpr hinvertible)

end ProjectKoios.DensityFunctionalTheory.PAW
