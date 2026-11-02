/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-03
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.LeastSquares
public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.MatrixFrobenius
public import Mathlib.Data.ZMod.Basic
public import Mathlib.LinearAlgebra.Basis.Basic

/-!
# Periodic-lattice matrix least squares

This module makes the dimension- and rank-generality of finite-abelian Fourier least squares
explicit for periodic lattice calculations.  A mesh is the finite quotient of an integer coordinate
lattice, one cyclic quotient per primitive reciprocal-lattice direction.  The reciprocal basis is
recorded separately from the quotient group: it controls physical geometry and shell interpretation,
but not finite-character orthogonality.

The matrix theorems use the explicit entrywise Frobenius power.  They cover one, two, three, or any
finite number of lattice directions and rank one, rank two, or arbitrary finite rank through the
index types.  They do not bind a runtime array, authenticate a reciprocal basis or mesh inventory,
certify a gauge, validate floating-point least squares, or establish scientific adequacy.
-/

@[expose] public section

open scoped BigOperators
open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier.FiniteAbelian

/-- `BG-FOURIER-LATTICE-DEF-001`: exact finite periodic reciprocal-lattice data.  `period` gives the
number of quotient coordinates in each primitive direction.  `reciprocalBasis` records a genuine
real basis for physical-coordinate interpretation, but the Fourier theorem depends only on the
finite quotient. -/
structure FinitePeriodicReciprocalLattice (Dimension : Type*) [Fintype Dimension] where
  period : Dimension → ℕ
  period_ne_zero : ∀ dimension, period dimension ≠ 0
  reciprocalBasis : Module.Basis Dimension ℝ (Dimension → ℝ)

instance {Dimension : Type*} [Fintype Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension) (dimension : Dimension) :
    NeZero (lattice.period dimension) :=
  ⟨lattice.period_ne_zero dimension⟩

/-- `BG-FOURIER-LATTICE-DEF-002`: finite quotient of the integer coordinate lattice by the declared
period in each primitive direction. -/
abbrev FinitePeriodicLatticeMesh
    {Dimension : Type*} [Fintype Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension) :=
  (dimension : Dimension) → ZMod (lattice.period dimension)

/-- `BG-FOURIER-LATTICE-DEF-003`: one-dimensional periodic reciprocal-lattice data. -/
abbrev FinitePeriodicReciprocalLattice1D := FinitePeriodicReciprocalLattice (Fin 1)

/-- `BG-FOURIER-LATTICE-DEF-004`: two-dimensional periodic reciprocal-lattice data. -/
abbrev FinitePeriodicReciprocalLattice2D := FinitePeriodicReciprocalLattice (Fin 2)

/-- `BG-FOURIER-LATTICE-DEF-005`: three-dimensional periodic reciprocal-lattice data. -/
abbrev FinitePeriodicReciprocalLattice3D := FinitePeriodicReciprocalLattice (Fin 3)

/-- `BG-FOURIER-LATTICE-DEF-006`: the unique least-squares conclusion for one supported matrix
coefficient candidate on a finite periodic reciprocal-lattice quotient. -/
def FinitePeriodicLatticeMatrixLeastSquaresConclusion
    {Dimension m : Type*} [Fintype Dimension] [DecidableEq Dimension] [Fintype m]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (field : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (candidate : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → Matrix m m ℂ) : Prop :=
  finiteMatrixFrobeniusPower
      (fun momentum => field momentum - finiteFourierReconstruction
        (truncateCoefficients support (finiteFourierCoefficient field)) momentum) ≤
    finiteMatrixFrobeniusPower
      (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) ∧
  (finiteMatrixFrobeniusPower
      (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) =
    finiteMatrixFrobeniusPower
      (fun momentum => field momentum - finiteFourierReconstruction
        (truncateCoefficients support (finiteFourierCoefficient field)) momentum) ↔
    candidate = truncateCoefficients support (finiteFourierCoefficient field))

variable {G m : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G] [Fintype m]

omit [DecidableEq G] in
/-- `BG-FOURIER-LATTICE-LEM-001`: entrywise matrix coefficient error against a supported candidate
splits into omitted truncation error and retained coefficient mismatch. -/
lemma finiteMatrixFrobeniusPower_sub_supported_eq
    (support : Finset (AddChar G ℂ))
    (coefficients candidate : AddChar G ℂ → Matrix m m ℂ)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteMatrixFrobeniusPower (fun mode => coefficients mode - candidate mode) =
      finiteMatrixFrobeniusPower
          (fun mode => coefficients mode - truncateCoefficients support coefficients mode) +
        finiteMatrixFrobeniusPower
          (fun mode => truncateCoefficients support coefficients mode - candidate mode) := by
  simp only [finiteMatrixFrobeniusPower, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro mode _
  by_cases hmode : mode ∈ support
  · simp [truncateCoefficients, hmode]
  · rw [hcandidate mode hmode]
    simp [truncateCoefficients, hmode]

/-- `BG-FOURIER-LATTICE-THM-001`: on a finite periodic lattice quotient, matrix reconstruction
error has the exact Frobenius decomposition into truncation error plus `|G|` times retained
coefficient mismatch.  The lattice dimension and matrix rank are arbitrary finite index types. -/
theorem finitePeriodicLatticeMatrixReconstruction_error_decomposition
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (field : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (candidate : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → Matrix m m ℂ)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteMatrixFrobeniusPower
        (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) =
      finiteMatrixFrobeniusPower
          (fun momentum => field momentum - finiteFourierReconstruction
            (truncateCoefficients support (finiteFourierCoefficient field)) momentum) +
        (card (FinitePeriodicLatticeMesh lattice) : ℝ) * finiteMatrixFrobeniusPower
          (fun mode =>
            truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode) := by
  rw [finiteMatrixFrobeniusPower_parseval]
  have hcoeff :
      finiteFourierCoefficient
          (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) =
        fun mode => finiteFourierCoefficient field mode - candidate mode := by
    funext mode
    rw [finiteFourierCoefficient_sub, finiteFourierCoefficient_reconstruction]
  rw [hcoeff, finiteMatrixFrobeniusPower_sub_supported_eq support
    (finiteFourierCoefficient field) candidate hcandidate, mul_add]
  have htruncation :
      finiteMatrixFrobeniusPower
          (fun momentum => field momentum - finiteFourierReconstruction
            (truncateCoefficients support (finiteFourierCoefficient field)) momentum) =
        (card (FinitePeriodicLatticeMesh lattice) : ℝ) * finiteMatrixFrobeniusPower
          (fun mode => finiteFourierCoefficient field mode -
            truncateCoefficients support (finiteFourierCoefficient field) mode) := by
    rw [finiteMatrixFrobeniusPower_parseval]
    have htruncatedCoeff :
        finiteFourierCoefficient
            (fun momentum => field momentum - finiteFourierReconstruction
              (truncateCoefficients support (finiteFourierCoefficient field)) momentum) =
          fun mode => finiteFourierCoefficient field mode -
            truncateCoefficients support (finiteFourierCoefficient field) mode := by
      funext mode
      rw [finiteFourierCoefficient_sub, finiteFourierCoefficient_reconstruction]
    rw [htruncatedCoeff]
  rw [htruncation]

/-- `BG-FOURIER-LATTICE-THM-002`: Fourier truncation is the unique equal-weight Frobenius
least-squares minimizer for a matrix field on any finite periodic reciprocal-lattice quotient.
Taking `Dimension = Fin 1`, `Fin 2`, or `Fin 3` gives periodic 1-D, 2-D, or 3-D; taking
`m = Fin 1`, `Fin 2`, or any finite type gives rank one, rank two, or arbitrary finite rank. -/
theorem finitePeriodicLatticeMatrixTruncation_leastSquares
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (field : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (candidate : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → Matrix m m ℂ)
    (hcandidate : CoefficientSupportedOn support candidate) :
    FinitePeriodicLatticeMatrixLeastSquaresConclusion lattice field support candidate := by
  unfold FinitePeriodicLatticeMatrixLeastSquaresConclusion
  have hdecomposition :=
    finitePeriodicLatticeMatrixReconstruction_error_decomposition
      lattice field support candidate hcandidate
  have hpowerNonneg :
      0 ≤ finiteMatrixFrobeniusPower
        (fun mode => truncateCoefficients support (finiteFourierCoefficient field) mode -
          candidate mode) := by
    rw [finiteMatrixFrobeniusPower]
    exact Finset.sum_nonneg fun mode _ =>
      Finset.sum_nonneg fun i _ => Finset.sum_nonneg fun j _ => sq_nonneg ‖
        (truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode) i j‖
  have hcardNonneg : (0 : ℝ) ≤ card (FinitePeriodicLatticeMesh lattice) := by
    exact_mod_cast Nat.zero_le (card (FinitePeriodicLatticeMesh lattice))
  constructor
  · rw [hdecomposition]
    exact le_add_of_nonneg_right (mul_nonneg hcardNonneg hpowerNonneg)
  · constructor
    · intro hequal
      have hmul :
          (card (FinitePeriodicLatticeMesh lattice) : ℝ) * finiteMatrixFrobeniusPower
            (fun mode => truncateCoefficients support (finiteFourierCoefficient field) mode -
              candidate mode) = 0 := by
        linarith
      have hcardNe : (card (FinitePeriodicLatticeMesh lattice) : ℝ) ≠ 0 := by
        exact_mod_cast Fintype.card_ne_zero
      have hpower :
          finiteMatrixFrobeniusPower
            (fun mode => truncateCoefficients support (finiteFourierCoefficient field) mode -
              candidate mode) = 0 :=
        (mul_eq_zero.mp hmul).resolve_left hcardNe
      rw [finiteMatrixFrobeniusPower] at hpower
      funext mode i j
      have hmode :
          (∑ i, ∑ j,
            ‖(truncateCoefficients support (finiteFourierCoefficient field) mode -
              candidate mode) i j‖ ^ 2) = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun _ _ => Finset.sum_nonneg fun i _ =>
            Finset.sum_nonneg fun j _ => sq_nonneg _)).mp hpower mode (Finset.mem_univ mode)
      have hi :
          (∑ j,
            ‖(truncateCoefficients support (finiteFourierCoefficient field) mode -
              candidate mode) i j‖ ^ 2) = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun _ _ => Finset.sum_nonneg fun j _ => sq_nonneg _)).mp hmode i (Finset.mem_univ i)
      have hterm :
          ‖(truncateCoefficients support (finiteFourierCoefficient field) mode -
            candidate mode) i j‖ ^ 2 = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun _ _ => sq_nonneg _)).mp hi j (Finset.mem_univ j)
      have hnorm :
          ‖(truncateCoefficients support (finiteFourierCoefficient field) mode -
            candidate mode) i j‖ = 0 := by
        nlinarith [norm_nonneg
          ((truncateCoefficients support (finiteFourierCoefficient field) mode -
            candidate mode) i j)]
      exact sub_eq_zero.mp (norm_eq_zero.mp hnorm) |>.symm
    · intro hequal
      subst candidate
      have hsupported := truncateCoefficients_supportedOn support (finiteFourierCoefficient field)
      rw [finitePeriodicLatticeMatrixReconstruction_error_decomposition lattice field support
        (truncateCoefficients support (finiteFourierCoefficient field)) hsupported]

/-- `BG-FOURIER-LATTICE-THM-003`: the arbitrary-rank matrix least-squares result specialized to a
one-dimensional periodic reciprocal lattice. -/
theorem finitePeriodicLatticeMatrixTruncation_leastSquares_oneDimensional
    (lattice : FinitePeriodicReciprocalLattice1D)
    (field : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (candidate : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → Matrix m m ℂ)
    (hcandidate : CoefficientSupportedOn support candidate) :
    FinitePeriodicLatticeMatrixLeastSquaresConclusion lattice field support candidate :=
  finitePeriodicLatticeMatrixTruncation_leastSquares lattice field support candidate hcandidate

/-- `BG-FOURIER-LATTICE-THM-004`: the arbitrary-rank matrix least-squares result specialized to a
two-dimensional periodic reciprocal lattice, including nonorthogonal reciprocal bases. -/
theorem finitePeriodicLatticeMatrixTruncation_leastSquares_twoDimensional
    (lattice : FinitePeriodicReciprocalLattice2D)
    (field : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (candidate : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → Matrix m m ℂ)
    (hcandidate : CoefficientSupportedOn support candidate) :
    FinitePeriodicLatticeMatrixLeastSquaresConclusion lattice field support candidate :=
  finitePeriodicLatticeMatrixTruncation_leastSquares lattice field support candidate hcandidate

/-- `BG-FOURIER-LATTICE-THM-005`: the arbitrary-rank matrix least-squares result specialized to a
three-dimensional periodic reciprocal lattice, including nonorthogonal reciprocal bases. -/
theorem finitePeriodicLatticeMatrixTruncation_leastSquares_threeDimensional
    (lattice : FinitePeriodicReciprocalLattice3D)
    (field : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (candidate : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → Matrix m m ℂ)
    (hcandidate : CoefficientSupportedOn support candidate) :
    FinitePeriodicLatticeMatrixLeastSquaresConclusion lattice field support candidate :=
  finitePeriodicLatticeMatrixTruncation_leastSquares lattice field support candidate hcandidate

end ProjectKoios.BandGauge.Fourier.FiniteAbelian
