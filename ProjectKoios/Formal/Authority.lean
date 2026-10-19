import ProjectKoios.Formal

/-! Explicit authority and placeholder metadata for publication crosswalks. -/

namespace ProjectKoios.Formal

/-- The distinct kinds of evidence that repository records may discuss. -/
inductive AuthorityKind where
  | exactFormalProof
  | exactCheckedCertificate
  | numericalEvidence
  | calculatorRuntime
  deriving DecidableEq, Repr

/-- Startup placeholders contain no imported scientific proposition. -/
inductive FormalizationStatus where
  | placeholderNoStatement
  | statementOnly
  | proved
  | externallyAssumed
  deriving DecidableEq, Repr

/-- Auditable metadata for a publication whose paper-specific declarations have not been encoded. -/
structure PublicationPlaceholder where
  sourceKey : String
  sourcePath : String
  inspectedRevision : String
  status : FormalizationStatus
  formalStatementCount : Nat
  provedScientificTheoremCount : Nat
  checkedCertificateCount : Nat
  warning : String
  deriving Repr

/-- Auditable aggregate status for a partially or fully formalized publication crosswalk.
A positive formal statement count does not imply a proved scientific or numerical claim. -/
structure PublicationFormalizationSummary where
  sourceKey : String
  sourcePath : String
  inspectedRevision : String
  status : FormalizationStatus
  formalStatementCount : Nat
  provedScientificTheoremCount : Nat
  checkedCertificateCount : Nat
  warning : String
  deriving Repr

end ProjectKoios.Formal
