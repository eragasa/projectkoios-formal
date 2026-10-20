import ProjectKoios.Formal.Authority

/-! Aggregate metadata for the partial Ragasa2026A formalization.

The conditional rank-two field, correlation-harmonic, optimized-loss geometry, exact
certificate-binding bridges, and exact constructed false-positive instance are owned by
the corresponding modules under `ProjectKoios.BandGauge.Papers.Ragasa2026A`. Runtime
publication data, numerical evidence, and physical validation remain external.
-/

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.Formal

/-- Aggregate status for the paper-specific exact statements and constructed analytic
instance. This is not a numerical, physical-validation, or publication-completion claim. -/
def summary : PublicationFormalizationSummary where
  sourceKey := "Ragasa2026a/v3"
  sourcePath := "docs/publications/papers/Ragasa2026a/v3"
  inspectedRevision := "99a46cb59d0c6f27ada7d709f194996ef9619d9f"
  status := .proved
  formalStatementCount := 34
  provedScientificTheoremCount := 3
  checkedCertificateCount := 1
  warning := "PARTIAL FORMALIZATION ONLY: twenty-eight conditional statements and six exact source-specific construction statements are proved, including the exact separation distance and resolution corollary; one analytic equal-weight certificate is checked. This is not runtime evidence, four-state-parent validation, material validation, or publication completion."

end ProjectKoios.BandGauge.Papers.Ragasa2026A
