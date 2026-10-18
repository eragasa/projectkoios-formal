module

public import Mathlib.Data.Nat.Basic

/-! Minimal harness declaration. It carries no scientific content. -/

@[expose] public section

namespace ProjectKoios.Formal

/-- Kernel-checked smoke theorem for the repository harness only. -/
theorem harnessCompiles : True := by
  trivial

end ProjectKoios.Formal
