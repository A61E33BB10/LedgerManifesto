# Cut Manifest — v16.1 post-Round-2 category-3 sweep (STYLUS)

Target file: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex` (no git baseline; removals reconstructed
from STYLUS edit history this session). Result: 113 -> 112 pp, clean double compile.

For each cut: (1) location, (2) REMOVED text verbatim, (3) the surviving text judged to carry the
claim (named lemma/theorem/invariant/principle + its exact clause). A compression is shown as
old -> new so the deleted span is unambiguous.

---

## The six category-(b) cuts (aside restating what a lemma/theorem/invariant carries)

### (b1) "Why it holds" remark residue — duplicated by `lem:closure`
**Location:** §"The total order and the refold" (`sec:totalorder`, ch4/`ch:machines`), the
`\emph{Why it holds.}` remark immediately after Theorem `thm:refold` (~line 1264).
**Removed (compression, old -> new):**
- OLD: `\emph{Why it holds.} The firing-derivation is not a one-shot map: a synthesised emission takes a past execution position, and refolding across it can imply further emissions, so the ordered prefix's emissions are a \emph{fixpoint} of interleaved fold-and-derive. Lemma~\ref{lem:closure} establishes that this fixpoint exists, is unique, and is reached in finitely many steps, computed from the record alone; being a fixpoint of a deterministic derivation over the execution-time order, it is independent of the order emissions are discovered, so the refold and the timely fold close the \emph{same} arrivals to the \emph{same} fixpoint. Both sides are then $\mathrm{fold\ step}$ over one $\mathrm{sort}_<$ sequence, and $\mathrm{fold\ step}$ is deterministic: equal input, equal fold state. Only provenance and the timing of external effects differ.`
- NEW: `\emph{Why it holds.} The firing-derivation is a \emph{fixpoint} of interleaved fold-and-derive: a synthesised emission takes a past execution position and can imply further emissions. Lemma~\ref{lem:closure} makes this fixpoint unique and record-derived, so the refold and the timely fold close the \emph{same} arrivals to the \emph{same} fixpoint; both are then $\mathrm{fold\ step}$ over one $\mathrm{sort}_<$ sequence, and $\mathrm{fold\ step}$ is deterministic: equal input, equal fold state. Only provenance and the timing of external effects differ.`
- DELETED SPAN (what the remark had duplicated): "establishes that this fixpoint **exists, is unique, and is reached in finitely many steps, computed from the record alone**; **being a fixpoint of a deterministic derivation over the execution-time order, it is independent of the order emissions are discovered**".
**Surviving carrier — Lemma `lem:closure` [Firing closure], its three clauses (verbatim):**
- Existence, uniqueness: "…the dependency strictly decreases in the well-order $<$, and $F$ is fixed by well-founded recursion along $<$ and is unique. The operator is \emph{not} monotone…"
- Termination: "Under (H-FIN) the candidate emission occasions … are finite and each watch fires at most once … and under (H-WF) the ``arms a further watch'' relation is well-founded; then the closure adds finitely many emissions and the forward pass terminates."
- Confluence: "$\mathrm{fold\ step}$ is deterministic (replay determinism, P2), so the closure is independent of the order emissions are discovered and inserted."
The deleted "exists / unique / finitely many steps / independent of discovery order" is exactly, and only, {Existence-uniqueness, Termination, Confluence}. The remark's surviving job — uniqueness + determinism ⇒ equal fold state — is retained.

### (b2) Value-sufficiency narration — duplicated by the two-guard table + `inv:coverage`
**Location:** ch14/`ch:invariants`, §"The coverage invariant and the two-guard contrast",
`\noindent` paragraph immediately after the two-guard comparison table (~line 5290).
**Removed (compression, old -> new):**
- OLD: `\noindent Value sufficiency is the guard coverage is never to be confused with. A market move, a knock, or a call in flight leaves collateral value below exposure with no party in breach; sufficiency is therefore not an invariant but an obligation --- a deadline, a discharge predicate (the delivery amount met), and close-out as the declared compensation (Chapter~\ref{ch:collateral}, \S 14.1). A book below its sufficiency line is not a broken state; it is an open, deadline-bearing item on the record.`
- NEW: `\noindent Value sufficiency is the guard coverage is never to be confused with: an intraday shortfall with no party in breach is an open, deadline-bearing item, not a broken state (Chapter~\ref{ch:collateral}, \S 14.1).`
- DELETED: "sufficiency is therefore not an invariant but an obligation --- a **deadline, a discharge predicate (the delivery amount met), and close-out as the declared compensation**."
**Surviving carrier — the two-guard comparison table (Value-sufficiency row, verbatim):**
"Value sufficiency & collateral value $\ge$ exposure & intraday, routinely & **obligation: deadline, discharge predicate, close-out as compensation**" — this row carries "not an invariant but an obligation / deadline / discharge predicate / close-out" in full. Invariant `inv:coverage` [Possession coverage] carries the contrasted guard: "No wallet delivers what it neither owns nor holds, and no wallet re-posts received mass its source agreement does not release."

### (b3) "Totality is what turns…" — duplicated by Principle `prin:sched-total`
**Location:** ch8/`ch:marketdata`, paragraph opening the adjustment-schedule-totality discussion
(~line 2660).
**Removed (deletion of leading sentence):**
- `Totality is what turns ``never improvised at read'' into a checkable property.`
(new paragraph now opens "An improvised adjustment is precisely a pairing with no declared operator; forbidding the improvisation means requiring the declaration in advance…")
**Surviving carrier — Principle `prin:sched-total` [Adjustment-schedule totality] (verbatim):**
"For every registered data kind and every event kind the boundary admits, an operator is declared --- the identity operator where a kind is genuinely unaffected, but declared, not assumed. **There is no (data kind, event kind) pair for which a read finds the adjustment undefined.** A corporate action whose pairing has no declared operator is not processed…" The deleted sentence asserted the same totality-as-checkable-property the principle states normatively (and requirement B3 tests).

### (b4) "No gap adds a mechanism…" row recap — duplicated by the CDM Gaps table
**Location:** ch13/`ch:cdm`, paragraph immediately after the Gaps table (~line 4855).
**Removed (compression, old -> new):**
- OLD: `No gap adds a mechanism: the recall rides the lent plane, the locate rides the obligation-liveness discipline, re-use rides the source-agreement reference, and the cascade rides the cause-derived identifier. The mapping is total on the ledger's side precisely because the residue is absorbed by primitives the design already carries.`
- NEW: `No gap adds a mechanism: the mapping is total on the ledger's side because the residue is absorbed by primitives the design already carries.`
- DELETED (row-by-row recap): "the recall rides the lent plane, the locate rides the obligation-liveness discipline, re-use rides the source-agreement reference, and the cascade rides the cause-derived identifier."
**Surviving carrier — CDM Gaps table, "Lineage convention carried" column (verbatim rows):**
- recall -> "**Lent-plane transaction keyed to the loan agreement unit** (Chapter~9): open $\to$ recall $\to$ return"
- locate -> "The locate is a **declared obligation on the agreement unit, with deadline and discharge predicate**…"
- re-use -> "**Posting of mass on the received ray with a mandatory source-agreement reference**, from which per-agreement re-use projects"
- cascade -> "The legs share one $\mathit{causeEventId}$ … yet differ in $(\mathit{contractId},\mathit{unitId},\mathit{seq})$, so **each carries a distinct cause-derived identifier**"
Each deleted "rides the X" clause is the one-liner of the corresponding table cell.

### (b5) "One writer per fact…" recap — duplicated by Invariant `inv:writer`
**Location:** ch14/`ch:invariants`, paragraph immediately after Invariant `inv:writer`
[One legal writer] (~line 5124).
**Removed (compression, old -> new):**
- OLD: `One writer per fact, one home per fact (Chapter~\ref{ch:homes}): a fact cannot be written into disagreement with itself, because no second writer and no second home exist to hold a rival copy. This is what keeps the three homes --- ProductTerms, UnitStatus, PositionState --- free of the divergence a second store would breed. Each is a \emph{materialised projection}:`
- NEW: `Each of the three homes --- ProductTerms, UnitStatus, PositionState --- is a \emph{materialised projection}:`
- DELETED: "One writer per fact, one home per fact (Chapter~homes): a fact cannot be written into disagreement with itself, because no second writer and no second home exist to hold a rival copy. This is what keeps the three homes … free of the divergence a second store would breed."
**Surviving carrier — Invariant `inv:writer` [One legal writer] (verbatim, sits directly above the cut):**
"Every non-balance fact has exactly one legal writer --- the smart contract of the instrument the fact belongs to --- and the Transaction Executor refuses a transaction that writes a fact outside its writer's authority (Chapter~homes, constitution \S 11)." The "materialised projection … not a second store" content the paragraph continues with is retained (surviving sentence, "…a cached, one-writer, rebuildable read of the log, provably equal to the fold it caches, and \emph{not} a second store…").

### (b6) "A second copy is dangerous…" re-explanation — duplicated by Principle `prin:rebuildable`
**Location:** ch6/`ch:homes`, §"Rebuildable by replay", paragraph on materialised projections
vs second copies (~line 2064), just after Principle `prin:rebuildable` [Homes are projections].
**Removed (deletion of interior sentence, old -> new):**
- OLD: `…and not second copies. A second copy is dangerous because two stores of one fact, maintained by independent logic, eventually disagree --- the failure the framework exists to remove (Chapter~1). A home cannot play that role: it has exactly one legal writer…`
- NEW: `…and not second copies. A home cannot play that role: it has exactly one legal writer…`
- DELETED: "A second copy is dangerous because two stores of one fact, maintained by independent logic, eventually disagree --- the failure the framework exists to remove (Chapter~1)."
**Surviving carrier — Principle `prin:rebuildable` [Homes are projections] (verbatim, same subsection):**
"Each home is a deterministic projection of the log --- ProductTerms of the terms changes, UnitStatus of the unit-state changes, PositionState of the position-state changes. Any home may be discarded and rebuilt by replaying the log, without loss of information, **so no home is a store that can drift from the record**." (The ch1 reconciliation-failure motivation is also its home — C-1.2–1.3.)

---

## Appendix — the other cuts (site · category · description)

Categories: (a) motivational padding before a definition/environment; (c) rhetorical/narrative
flourish; (d) v1.x/PARK historical narration in a chapter body (home = ch17 registers);
(e) ToC / ch1–3-doctrine recapitulation; plus companion-roadmap and register-recap trims.

1. ch2/`ch:picture` ~497 · (c) · event-sourcing throat-clearing opener struck
2. ch3/`ch:objects` ~887 · (a) · lead-in before `inv:graph-consistency` struck
3. ch3/`ch:objects` ~785 · (d) · PARK-3 v1.2 body narration struck
4. ch7/`ch:valuation` ~2310 · (d) · PARK-4 v1.2 body narration struck
5. ch7/`ch:valuation` ~2395 · (e) · ch1 reconciliation-failure recap compressed
6. ch8/`ch:marketdata` ~2610 · (d) · "adopted in v1.3" tag struck
7. ch9/`ch:collateral` ~3033 · (c) · "boundary is then closed" closer struck
8. ch9/`ch:collateral` ~3112 · (c) · agreement-index restatement struck
9. ch10/`ch:virtual` ~3713 · (a) · "already has the parts" throat-clearing struck
10. ch10/`ch:virtual` ~3735 · (e) · "no privileged copy" no-second-store recap struck
11. ch11/`ch:settlement` ~3968 · (e) · ch5 single-writer discipline recap struck
12. ch11/`ch:settlement` ~3971 · (a) · "four properties follow" lead-in struck
13. ch12/`ch:reporting` ~4414 · (e) · reporting reconciliation re-explanation compressed to one pointer
14. ch13/`ch:cdm` ~4829 · (c) · "none is a defect…" gaps-table editorializing trimmed
15. ch13/`ch:cdm` (companion) · roadmap · companion descriptions cut to names+register lines
16. ch14/`ch:invariants` ~5146 · (d) · "C-12.1 (v1.3)…discharge stated below" compressed
17. ch14/`ch:invariants` ~5234 · (d) · PARK-2 v1.2 body narration struck
18. ch14/`ch:invariants` ~5264 · (a) · "this is their canonical home" meta struck
19. ch14/`ch:invariants` ~5403 · (c) · "stated once and executable" method recap trimmed
20. ch14/`ch:invariants` ~5410 · (c) · "what cannot be represented cannot break" aphorism struck
21. ch15/`ch:testability` ~6246 · (d) · BITEMP "(v1.3) … PARK-2 closed" narration struck
22. ch16/`ch:requirements` (Verification) · (e) · M/V/B requirement recap compressed
23. ch16/`ch:requirements` (traceability table) · merge · two identical `ch:invariants` rows merged
24. ch17/`ch:scope` (In scope) · (e) · chapter-by-chapter ToC-duplicate enumeration cut (CLAUDE.md §6)
25. ch17/`ch:scope` (Out of scope) · (c) · "each is a function of some other system" flourish struck
26. ch17/`ch:scope` (open-problems index) · register-recap · discharged-item mechanism recaps cut to name+status+pointer
27. ch17/`ch:scope` (open-problems index) · (c) · "none is a gap hidden…" closing flourish struck

Also (Job 1, factual — NOT a category-3 cut): the ch17 change-log "Under decision" paragraph
was rewritten to "Ruled (DL-01)" to record the pass Decision Panel's settled 3–0 R-conform
ruling and drop the "If the Panel rules otherwise…" conditional.
