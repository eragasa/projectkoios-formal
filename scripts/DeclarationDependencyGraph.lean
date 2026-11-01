/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/

import ProjectKoios.Audit

open Lean Elab Command

namespace ProjectKoios.DependencyGraph

structure ManifestEntry where
  statementId : Option String
  declarationName : String
  kind : String
  deriving Repr

structure GraphNode where
  key : String
  statementId : Option String
  declarationName : String
  kind : String
  moduleName : String
  registered : Bool
  axioms : Array String
  externalModules : Array String
  deriving Repr

structure GraphEdge where
  source : String
  target : String
  relation : String
  deriving Repr

structure ModuleCounts where
  definitions : Nat := 0
  lemmas : Nat := 0
  theorems : Nat := 0
  other : Nat := 0
  deriving Repr

-- Manifest cells use Markdown code spans. Normalize those spans before interpreting IDs/names.
private def stripCodeCell (s : String) : String :=
  let trimmed := s.trimAscii.toString
  if trimmed.startsWith "`" && trimmed.endsWith "`" && trimmed.length >= 2 then
    (trimmed.drop 1 |>.dropEnd 1).toString
  else
    trimmed

-- Only the authoritative table rows whose declaration names begin with `ProjectKoios.` are
-- admitted. Planning-table rows therefore cannot accidentally become proof-graph nodes.
private def parseManifestLine (line : String) : Option ManifestEntry := do
  let cells := line.splitOn "|" |>.map (·.trimAscii.toString)
  let idCell ← cells[1]?
  let declarationCell ← cells[2]?
  let kindCell ← cells[3]?
  let declarationName := stripCodeCell declarationCell |>.splitOn " " |>.headD ""
  if !declarationName.startsWith "ProjectKoios." then
    none
  else
    let rawId := stripCodeCell idCell
    let statementId := if rawId == "—" || rawId.isEmpty then none else some rawId
    some {
      statementId
      declarationName
      kind := kindCell
    }

private def parseManifest (text : String) : Array ManifestEntry :=
  text.splitOn "\n" |>.filterMap parseManifestLine |>.toArray

private def nameFromDottedString (s : String) : Name :=
  s.splitOn "." |>.foldl (fun name component => Name.str name component) Name.anonymous

private def sortedStrings (values : Array String) : Array String :=
  values.qsort (fun left right => left < right)

private def jsonStringArray (values : Array String) : Json :=
  Json.arr (values.map Json.str)

private def nodeToJson (node : GraphNode) : Json :=
  Json.mkObj [
    ("key", Json.str node.key),
    ("statementId", node.statementId.map Json.str |>.getD Json.null),
    ("declaration", Json.str node.declarationName),
    ("kind", Json.str node.kind),
    ("module", Json.str node.moduleName),
    ("registered", Json.bool node.registered),
    ("axioms", jsonStringArray node.axioms),
    ("externalModules", jsonStringArray node.externalModules)
  ]

private def edgeToJson (edge : GraphEdge) : Json :=
  Json.mkObj [
    ("source", Json.str edge.source),
    ("target", Json.str edge.target),
    ("relation", Json.str edge.relation)
  ]

private def dotQuoted (s : String) : String :=
  (Json.str s).compress

private def dotShapeAndColor (node : GraphNode) : String × String :=
  if node.kind == "generated-project-dependency" then
    ("diamond", "#eeeeee")
  else if !node.registered then
    ("diamond", "#f4cccc")
  else if node.kind == "lemma" then
    ("ellipse", "#fff2cc")
  else if node.kind == "theorem" then
    ("box", "#d9ead3")
  else
    ("box", "#cfe2f3")

private def renderDot (nodes : Array GraphNode) (edges : Array GraphEdge) : String := Id.run do
  let mut lines := #[
    "digraph ProjectKoiosDeclarationDependencies {",
    "  rankdir=LR;",
    "  graph [fontname=\"Helvetica\"];",
    "  node [style=filled, fontname=\"Helvetica\", fontsize=9];",
    "  edge [fontname=\"Helvetica\", fontsize=8];"
  ]
  for node in nodes do
    let (shape, color) := dotShapeAndColor node
    let idLabel := node.statementId.getD "NO-STABLE-ID"
    let label := s!"{idLabel}\\n{node.declarationName}\\n[{node.kind}]"
    lines := lines.push s!"  {dotQuoted node.key} [label={dotQuoted label}, shape={shape}, fillcolor={dotQuoted color}];"
  for edge in edges do
    lines := lines.push s!"  {dotQuoted edge.source} -> {dotQuoted edge.target} [label={dotQuoted edge.relation}];"
  lines := lines.push "}"
  return String.intercalate "\n" lines.toList ++ "\n"

-- The default visualization is intentionally narrower than the JSON graph. Generated structure
-- machinery remains available in the full graph without overwhelming the author-facing view.
private def renderRegisteredDot (nodes : Array GraphNode) (edges : Array GraphEdge) : String :=
  let registeredKeys : Std.HashSet String := nodes.foldl (init := {}) fun keys node =>
    if node.registered then keys.insert node.key else keys
  let registeredNodes := nodes.filter (·.registered)
  let registeredEdges := edges.filter fun edge =>
    registeredKeys.contains edge.source && registeredKeys.contains edge.target
  renderDot registeredNodes registeredEdges

-- Prefix-focused views retain the exact compiled edges but suppress unrelated declaration families.
-- They are a navigation aid, not a different dependency relation.
private def renderPrefixDot
    (nodes : Array GraphNode) (edges : Array GraphEdge) (namePrefix : String) : String :=
  let focusedNodes := nodes.filter fun node =>
    node.registered && node.declarationName.startsWith namePrefix
  let focusedKeys : Std.HashSet String := focusedNodes.foldl (init := {}) fun keys node =>
    keys.insert node.key
  let focusedEdges := edges.filter fun edge =>
    focusedKeys.contains edge.source && focusedKeys.contains edge.target
  renderDot focusedNodes focusedEdges

private def incrementModuleCount (counts : ModuleCounts) (kind : String) : ModuleCounts :=
  if kind == "lemma" then
    { counts with lemmas := counts.lemmas + 1 }
  else if kind == "theorem" then
    { counts with theorems := counts.theorems + 1 }
  else if kind == "definition" || kind == "abbreviation" || kind == "structure" ||
      kind == "inductive definition" then
    { counts with definitions := counts.definitions + 1 }
  else
    { counts with other := counts.other + 1 }

-- The module graph is the readable overview: parallel declaration edges are collapsed and labelled
-- by multiplicity. Self-edges are omitted because they do not explain cross-module architecture.
private def renderModuleDot (nodes : Array GraphNode) (edges : Array GraphEdge) : String := Id.run do
  let registeredNodes := nodes.filter (·.registered)
  let mut nodeByKey : Std.HashMap String GraphNode := {}
  let mut countsByModule : Std.HashMap String ModuleCounts := {}
  for node in registeredNodes do
    nodeByKey := nodeByKey.insert node.key node
    let counts := countsByModule.getD node.moduleName {}
    countsByModule := countsByModule.insert node.moduleName
      (incrementModuleCount counts node.kind)

  let mut edgeCounts : Std.HashMap (String × String) Nat := {}
  for edge in edges do
    if let (some source, some target) :=
        (nodeByKey.get? edge.source, nodeByKey.get? edge.target) then
      if source.moduleName != target.moduleName then
        let key := (source.moduleName, target.moduleName)
        edgeCounts := edgeCounts.insert key (edgeCounts.getD key 0 + 1)

  let modules := countsByModule.toList.toArray.qsort fun left right => left.1 < right.1
  let moduleEdges := edgeCounts.toList.toArray.qsort fun left right =>
    if left.1.1 == right.1.1 then left.1.2 < right.1.2 else left.1.1 < right.1.1
  let mut lines := #[
    "digraph ProjectKoiosModuleDependencies {",
    "  rankdir=LR;",
    "  graph [fontname=\"Helvetica\", label=\"Project Koios compiled module dependencies\", labelloc=t, fontsize=18];",
    "  node [shape=box, style=\"rounded,filled\", fillcolor=\"#d9eaf7\", fontname=\"Helvetica\", fontsize=10];",
    "  edge [fontname=\"Helvetica\", fontsize=8];"
  ]
  for (moduleName, counts) in modules do
    let label := s!"{moduleName}\\n{counts.definitions} definitions | {counts.lemmas} lemmas | {counts.theorems} theorems"
    lines := lines.push s!"  {dotQuoted moduleName} [label={dotQuoted label}];"
  for ((source, target), count) in moduleEdges do
    lines := lines.push s!"  {dotQuoted source} -> {dotQuoted target} [label={dotQuoted (toString count)}];"
  lines := lines.push "}"
  return String.intercalate "\n" lines.toList ++ "\n"

private def moduleNameOf (env : Environment) (name : Name) : String :=
  env.getModuleFor? name |>.map toString |>.getD "unknown"

private def entryKey (entry : ManifestEntry) : String :=
  entry.statementId.getD s!"NO-ID:{entry.declarationName}"

private def checkManifestEntries (entries : Array ManifestEntry) : Except String Unit := do
  let mut ids : Std.HashSet String := {}
  let mut names : Std.HashSet String := {}
  for entry in entries do
    if names.contains entry.declarationName then
      throw s!"duplicate manifest declaration: {entry.declarationName}"
    names := names.insert entry.declarationName
    if let some statementId := entry.statementId then
      if ids.contains statementId then
        throw s!"duplicate statement ID: {statementId}"
      ids := ids.insert statementId

-- Lean generates constructors, recursors, and projections below a declaration's name. Treat these
-- children differently from genuinely unregistered repository dependencies.
private def hasRegisteredParent
    (entriesByName : Std.HashMap String ManifestEntry) (declarationName : String) : Bool :=
  entriesByName.toList.any fun (candidate, _) =>
    declarationName.startsWith (candidate ++ ".")

private def buildGraph (env : Environment) (entries : Array ManifestEntry) : CommandElabM (Array GraphNode × Array GraphEdge) := do
  match checkManifestEntries entries with
  | .error message => throwError message
  | .ok () => pure ()

  let mut entriesByName : Std.HashMap String ManifestEntry := {}
  for entry in entries do
    entriesByName := entriesByName.insert entry.declarationName entry

  let mut unregisteredNames : Std.HashSet String := {}
  let mut dependenciesByName : Std.HashMap String (Array String) := {}
  let mut externalModulesByName : Std.HashMap String (Array String) := {}

  -- First collect direct constants from each compiled declaration. This inspects kernel terms,
  -- not source-level tactic scripts or textual name occurrences.
  for entry in entries do
    let declarationName := nameFromDottedString entry.declarationName
    let some constantInfo := env.find? declarationName
      | throwError "manifest declaration is absent from the compiled environment: {entry.declarationName}"
    let mut projectDependencies : Array String := #[]
    let mut externalModules : Std.HashSet String := {}
    for usedName in constantInfo.getUsedConstantsAsSet do
      let usedString := toString usedName
      if usedString.startsWith "ProjectKoios." then
        projectDependencies := projectDependencies.push usedString
        if !entriesByName.contains usedString then
          unregisteredNames := unregisteredNames.insert usedString
      else
        if let some moduleName := env.getModuleFor? usedName then
          externalModules := externalModules.insert (toString moduleName)
    dependenciesByName := dependenciesByName.insert entry.declarationName (sortedStrings projectDependencies)
    externalModulesByName := externalModulesByName.insert entry.declarationName
      (sortedStrings externalModules.toArray)

  -- Axiom lists are transitive, while dependency edges below remain direct. Keeping that
  -- distinction explicit prevents a visual edge from being mistaken for a transitive closure.
  let mut nodes : Array GraphNode := #[]
  let sortedEntries := entries.qsort (fun left right => entryKey left < entryKey right)
  for entry in sortedEntries do
    let declarationName := nameFromDottedString entry.declarationName
    let axioms ← collectAxioms declarationName
    nodes := nodes.push {
      key := entryKey entry
      statementId := entry.statementId
      declarationName := entry.declarationName
      kind := entry.kind
      moduleName := moduleNameOf env declarationName
      registered := true
      axioms := sortedStrings (axioms.map toString)
      externalModules := externalModulesByName.getD entry.declarationName #[]
    }

  let sortedUnregistered := sortedStrings unregisteredNames.toArray
  for declarationNameString in sortedUnregistered do
    let declarationName := nameFromDottedString declarationNameString
    let axioms ← collectAxioms declarationName
    nodes := nodes.push {
      key := s!"UNREGISTERED:{declarationNameString}"
      statementId := none
      declarationName := declarationNameString
      kind := if hasRegisteredParent entriesByName declarationNameString then
        "generated-project-dependency"
      else
        "unregistered-project-dependency"
      moduleName := moduleNameOf env declarationName
      registered := false
      axioms := sortedStrings (axioms.map toString)
      externalModules := #[]
    }

  let mut edges : Array GraphEdge := #[]
  for entry in sortedEntries do
    for dependencyName in dependenciesByName.getD entry.declarationName #[] do
      let target := match entriesByName.get? dependencyName with
        | some dependencyEntry => entryKey dependencyEntry
        | none => s!"UNREGISTERED:{dependencyName}"
      edges := edges.push {
        source := entryKey entry
        target
        relation := "direct-kernel-dependency"
      }
  edges := edges.qsort fun left right =>
    if left.source == right.source then left.target < right.target else left.source < right.source
  return (nodes, edges)

-- Generation is an explicit audit command. Outputs live under ignored Lake build state and are
-- reproducible from the manifest, compiled environment, repository revision, and dependency pins.
elab "#emit_projectkoios_declaration_dependency_graph" : command => do
  let manifestPath : System.FilePath := "docs/theorem-manifest.md"
  let outputDirectory : System.FilePath := ".lake/build/audit"
  let jsonPath := outputDirectory / "declaration-dependencies.json"
  let dotPath := outputDirectory / "declaration-dependencies.dot"
  let fullDotPath := outputDirectory / "declaration-dependencies-full.dot"
  let moduleDotPath := outputDirectory / "module-dependencies.dot"
  let quantumDotPath := outputDirectory / "quantum-mechanics-dependencies.dot"
  let manifestText ← liftIO <| IO.FS.readFile manifestPath
  let entries := parseManifest manifestText
  if entries.isEmpty then
    throwError "no ProjectKoios declaration rows were parsed from {manifestPath}"
  let env ← getEnv
  let (nodes, edges) ← buildGraph env entries
  let document := Json.mkObj [
    ("schema", Json.str "PKF-DECLARATION-DEPENDENCY-GRAPH/1"),
    ("edgeDirection", Json.str "source declaration directly uses target declaration"),
    ("nodes", Json.arr (nodes.map nodeToJson)),
    ("edges", Json.arr (edges.map edgeToJson))
  ]
  liftIO <| IO.FS.createDirAll outputDirectory
  liftIO <| IO.FS.writeFile jsonPath (document.pretty ++ "\n")
  liftIO <| IO.FS.writeFile dotPath (renderRegisteredDot nodes edges)
  liftIO <| IO.FS.writeFile fullDotPath (renderDot nodes edges)
  liftIO <| IO.FS.writeFile moduleDotPath (renderModuleDot nodes edges)
  liftIO <| IO.FS.writeFile quantumDotPath
    (renderPrefixDot nodes edges "ProjectKoios.QuantumMechanics.")
  logInfo m!"wrote {nodes.size} nodes and {edges.size} edges plus focused DOT views under {outputDirectory}"

end ProjectKoios.DependencyGraph

#emit_projectkoios_declaration_dependency_graph
