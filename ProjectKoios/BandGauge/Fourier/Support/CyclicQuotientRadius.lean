/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-03
-/
module

public import Mathlib.Analysis.Fourier.FiniteAbelian.PontryaginDuality
public import Mathlib.Analysis.Normed.Group.Quotient

/-!
# Cyclic quotient radius for finite Fourier characters

This module equips the complex-character group of `ZMod n` with the exact quotient radius induced
by the ordinary absolute-value norm on `ℤ`.  The radius is defined through two additive
equivalences: the first-isomorphism identification of `ℤ / ker(ℤ → ZMod n)` with `ZMod n`, and the
standard finite Pontryagin-duality identification of `ZMod n` with its complex characters.

Because the radius is a genuine quotient seminorm, inversion invariance and the triangle inequality
hold across the periodic seam.  Thus it is not obtained by pretending that a raw centered
representative map is additive.  An integer representative supplies an upper bound on the quotient
radius; equality with a particular centered representative is deliberately not claimed here.

These declarations do not identify a runtime FFT ordering, centered array index, Nyquist
convention, reciprocal basis, physical distance, or serialized coefficient array.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Fourier.Support

/-- `BG-FOURIER-SUPPORT-DEF-010`: additive first-isomorphism identification of the integer quotient
with `ZMod n`. -/
noncomputable def zmodIntegerQuotientEquiv (n : ℕ) :
    (ℤ ⧸ (Int.castAddHom (ZMod n)).ker) ≃+ ZMod n :=
  QuotientAddGroup.quotientKerEquivOfSurjective
    (Int.castAddHom (ZMod n)) ZMod.intCast_surjective

/-- `BG-FOURIER-SUPPORT-DEF-011`: periodic quotient radius on complex Fourier characters of
`ZMod n`, induced by the ordinary norm on integer representatives. -/
noncomputable def cyclicCharacterQuotientRadius (n : ℕ) [NeZero n]
    (mode : AddChar (ZMod n) ℂ) : NNReal :=
  ‖(zmodIntegerQuotientEquiv n).symm ((AddChar.zmodAddEquiv).symm mode)‖₊

/-- `BG-FOURIER-SUPPORT-LEM-009`: the cyclic character quotient radius is invariant under mode
inversion, including at the periodic seam. -/
@[simp] lemma cyclicCharacterQuotientRadius_neg (n : ℕ) [NeZero n]
    (mode : AddChar (ZMod n) ℂ) :
    cyclicCharacterQuotientRadius n (-mode) = cyclicCharacterQuotientRadius n mode := by
  simp [cyclicCharacterQuotientRadius]

/-- `BG-FOURIER-SUPPORT-THM-017`: the cyclic character quotient radius satisfies the triangle
inequality under finite-character addition. -/
theorem cyclicCharacterQuotientRadius_add_le (n : ℕ) [NeZero n]
    (left right : AddChar (ZMod n) ℂ) :
    cyclicCharacterQuotientRadius n (left + right) ≤
      cyclicCharacterQuotientRadius n left + cyclicCharacterQuotientRadius n right := by
  change ‖(zmodIntegerQuotientEquiv n).symm
      ((AddChar.zmodAddEquiv).symm (left + right))‖₊ ≤ _
  rw [map_add, map_add]
  exact nnnorm_add_le _ _

/-- `BG-FOURIER-SUPPORT-THM-018`: every integer representative bounds from above the periodic
quotient radius of its corresponding complex Fourier character.  No preferred centered
representative or equality claim is introduced. -/
theorem cyclicCharacterQuotientRadius_zmod_le (n : ℕ) [NeZero n] (representative : ℤ) :
    cyclicCharacterQuotientRadius n
        (AddChar.zmodAddEquiv (representative : ZMod n)) ≤ ‖representative‖₊ := by
  simp only [cyclicCharacterQuotientRadius, AddEquiv.symm_apply_apply]
  have hrepresentative :
      (zmodIntegerQuotientEquiv n).symm (representative : ZMod n) =
        ((representative : ℤ) : ℤ ⧸ (Int.castAddHom (ZMod n)).ker) := by
    apply (zmodIntegerQuotientEquiv n).injective
    rw [AddEquiv.apply_symm_apply]
    rfl
  rw [hrepresentative]
  exact_mod_cast (QuotientAddGroup.norm_mk_le_norm (m := representative)
    (S := (Int.castAddHom (ZMod n)).ker))

end ProjectKoios.BandGauge.Fourier.Support
