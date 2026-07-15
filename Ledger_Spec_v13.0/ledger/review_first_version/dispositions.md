# FORMALIS Ruled Disposition List — ledger_v13_0.tex (arbiter, iteration 2 input)

File: `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/ledger_v13_0.tex` (7,869 lines, 167 pp).
Seed verified clean by all six lenses (no R1 stamps, no `drafts/`, no banners, no TODO/FIXME, PDF metadata version-free, bibliography closed, no orphaned appendix). Constraint 8 governs every item: no theorem/invariant/proof/listing removed; every mathematical and economic claim survives with meaning intact. Duplicates across the six censuses are struck; each item below appears once and is ruled.

Arbiter verifications performed before ruling: §5 enumerates FIVE illegal states (line 1926); Principle `prin:state-sufficiency` (line 1934) lists **balances, unit state, prices** — so no recast may call basis agreement "the third dependency"; FAQ §21 exists with Q1 = move-less events and Q6 = scalar cash (so line 4968's `(FAQ Q6)` is a *wrong* tag, not a dangling one); `Timestamp`/`SourceId` are used in §2's `Move` (line 493) but never declared, and `moveDelta` is used at 1541 but defined only at 4018 — MATTHIAS's closure finding confirmed.

---

## A. DELETIONS (execute first)

| # | Location | Disposition |
|---|---|---|
| D1 | line 19 `\usepackage{mathtools}` | **Delete.** Zero mathtools-specific commands in 7,869 lines; amsmath loaded at 18. Verify clean build after removal. |
| D2 | line 286 (±1) comment `% BODY — organised into parts (see coverage_map.md)` | **Delete the parenthetical** `(see coverage_map.md)` only; banner stays. coverage_map.md does not ship. |
| D3 | line 3 comment | **Delete** `(ligature fix, proven)`; keep `% --- encoding + clean PDF text extraction ---`. |
| D4 | line 429, comment tail after `\label{sec:ledger}` | **Delete comment** (`% semantic label: … (incl. Move positivity home)`); keep the label. Merge-coordination residue. |
| D5 | line 5906, comment after `\label{sec:invariants}` | **Delete comment** (`% canonical home of the invariant prose; …`); keep the label. **RULING (Nazarov over Voice lens):** "canonical home" narrates the deduplication exercise — one-sitting authors do not annotate where prose was homed. |

---

## B. REWRITES (execute second; wording ruled where contested)

**B1 — line 2779–2782 (state-basis, before C13). The canonical R2.** Ruled wording (respects line 1934's dependency list; no ordinal):
> "State-sufficiency (\S\ref{sec:valuation}) presupposes basis agreement between prices and balances; the snapshot's type variable carries that agreement. A held unit priced in the wrong basis is representable as an error and unrepresentable as a \texttt{Cash} --- one more illegal state, beyond those of \S\ref{sec:valuation}, that the valuation types exclude."

**REJECTED:** the FORMALIS/CARTAN census draft "has three dependencies: balances, unit state, and basis agreement" — it contradicts the Principle. C13 block untouched.

**B2 — FORMALIS-clearance sites (6): remarks 1809–1811, 2091–2092, 5448–5449, 6787–6788; prose 6036, 6661.** **RULING: rewrite, not keep-as-convention, not delete.** Retitle remarks `[Discharged by construction]` (or `[Totality and determinism]`); strip *only* "FORMALIS", "cleared/clearance", "verdict CLEARED", "no CRITICAL or HIGH findings", "reviewed and cleared", "findings resolved", "new code", "already-cleared". Every discharge fact survives verbatim in meaning — NOETHER's checklist is binding: Integer minor units; three coupled maps; totality of `round` on `Rational`; rounding confined to `projectAmount`; totality/determinism of `applyMove`; `Coord` unrepresentability discharging the Single-Coordinate Move Principle; P20 with no stored value to violate; non-negativity as value-level precondition at the lending gate; `priceOf` coverage, purity, `Ex Cash` fuse; `Price` has no `Monoid`. At 6036/6661: "verbatim excerpts of the reference (`reference/Ledger.hs`)" — path pointers stay. At 6661 also apply B14.

**B3 — line 516 (§2, after Qty listing).** Drop "cleared"; fix the false canonicity claim (qneg has 30 citing sites, negQty two). Ruled wording:
> "\texttt{Qty} and its group instances are the definitions of the three-home reference (Section~\ref{sec:sec04}), whose listings abbreviate the inverse \texttt{negQty} as \texttt{qneg}."

**RULING on qneg/negQty:** no global unification (touches 30 sites for zero output gain); the sentence now states the true relation. Line 4836's `negQty` stands unless its section prelude defines only `qneg` (editor verifies at point of edit).

**B4 — Nazarov attribution (3 sites).** 4295: "the Nazarov attestation finding (\S\ref{sec:conclusion})" → "the attestation-envelope requirement (\S\ref{sec:conclusion})". 4403: same substitution. 6352 (ME2 row): delete the parenthetical "(Nazarov attestation-envelope finding)" **only**; everything after the colon survives verbatim — it is the requirement itself.

**B5 — lines 4403–4408 (managed-account audit close).** Recast declaratively: drop the defensive "They are not failures of the workflow"; drop "current" from "current treatment"; "consolidated in" → "collected in". All facts survive: atomic q>0 moves, $\sum_w w(u)=0$ verified, worked example closes to the penny, escalations mark where the performance/reporting layer outruns the framework's treatment of recorded observations and external identity.

**B6 — line 3946.** `\emph{Owner: the performance/risk agent.}` → `\emph{Owner:} performance and risk engineering.` (Matches the register of line 2744 "market-data operations" and 2982 "data governance", both KEEP.)

**B7 — Escalation retag (origin sections only; register 6311–6375 untouched).** §9 futures 3939–3950: E1→FE1, E2→FE2 (paragraph heads and any in-text cites). §10 managed accounts 4074, 4216, 4218, 4240, 4256, 4294, 4392, 4403: E1–E5→ME1–ME5 per the verified one-to-one map (E1→ME1 store-vs-derive, E2→ME2 attestation, E3→ME3 LEI, E4→ME4 C4 typing, E5→ME5 solvency liveness).

**B8 — Stale-numbering cluster (CARTAN; rebuild by section TITLE, `\ref`-based, never +1 arithmetic).**
- 141–147 Roadmap part map: actual Parts I–II §§1–4, III §§5–9, IV §§10–14, V §§15–16, VI §§17–21 (FAQ included).
- 164–182 audience table: every `\S`≥8 cell re-derived by intended title (old §8 = Futures = new §9; old §11 = Impl/Ops = new §12; etc.). Appendix letters A–I verified correct — convert to `\ref` but do not renumber.
- 199–279 Key Concepts: eight pointers (Managed account §10, TRS §10, Substantiation §11, Settlement §13, CDM §14, Obligation liveness §15, Position vector §16, SBL §16).
- 3976, 3979 futures recap: hardcoded "(\S8, …)" → `\ref` to the sections actually establishing P6/P9; neighbours (\S6.), (\S7.) correct, untouched.
- 6398 FAQ Q2: add `\label` to Definition [Transaction] (~line 520) and replace "Definition~2.4" with `\ref` — 2.4 currently names the Atomicity principle.

**B9 — line 4968 listing comment.** **RULING (resolves MATTHIAS vs CARTAN):** FAQ exists; the tag is wrong, not dangling. `-- move-less event (FAQ Q6)` → `-- move-less event (FAQ Q1)`. Do not delete.

**B10 — Dangling companion-document pointers.** 6195: "(valuation mechanics are specified in the valuation specification)" → `(\S\ref{sec:valuation})`. 6294/6295/6298 Open-Problems parentheticals: point to §5 / §8 where a home exists; delete the "data specification" pointer (no home). 6168: "specified in the standalone data spec (pointer per Section~\ref{sec:scope-limitations})" → "at the ledger boundary (outside the boundary, \S\ref{sec:scope-limitations})".

**B11 — line 6309.** Ruled wording: "The items below are open items --- the forward agenda --- kept distinct from the proven quantity algebra." (Kills both "honest" and "next-version".)

**B12 — 'honest(ly)' sweep.** 2797: drop "honestly" ("The guarantee is stated in the two-tier discipline of C11 …"). 2996: "the only honest alternative" → "the only sound alternative". (6309 handled in B11.)

**B13 — 'consolidat*' voice, split ruling.** REWRITE: 5909 "This section is the consolidation point for … restated here once … in one reconciled numbering" → "This section states the framework's correctness claims once, as precise testable invariants, under the canonical numbering P1--P23."; 6008 "The highest-value content of the consolidation is the map …" → "The core of this section is the map …" — **the canonical-name rule sentence at 6008 (P1–P23 canonical over §4's local labels) survives verbatim**; sweep 576, 1774–1775, 3939, 4404, 5948, 6661: "consolidated" → "stated with" / "collected" / "carried to the register" as fits. KEEP: 6293 ("consolidated reporting" — accounting domain).

**B14 — line 6661 (with B2).** After dropping "FORMALIS-cleared", extend the deferred-helper enumeration to include `TxError`, `Hash`, and the `Cash` group inverse (`cashNeg`), so no Appendix B oracle identifier (6548, 6559, 6642) is orphaned.

**B15 — line 2524 listing comment.** `-- was Maybe Qty: dimensionally wrong, basis-free` → `-- a settle mark is dimensionally a Price and names its basis; a bare Qty carries neither`. (Surrounding "gains one field" framing is layered exposition — keep.)

**B16 — line 838.** Mark the §3 `LedgerError` two-constructor listing as the fragment it is: append comment `-- the two registration errors; the full LedgerError is in \S\ref{sec:sec04}`. No constructor changes anywhere.

**B17 — line 6871 glossary, State-sufficiency.** Align with `prin:state-sufficiency`: "…depends only on current balances, **current unit state**, and prices…". Drift repair, not new content.

**B18 — line 7507 Appendix I.** End the sentence after "under different law." — delete "and both witnesses are retained." Both appendices stay in full.

**B19 — lines 127–129 Abstract.** "as one self-contained whole" → "in one self-contained development". Low priority; execute with B11-class one-liners.

---

## C. RESTRUCTURINGS (execute third)

**C1 — §2 Move-algebra closure repair (MATTHIAS lead finding).** **RULING under constraint 8: permitted** — this is R3 repair of cross-references assuming absent material (1774 claims §2 provides `moveDelta`, `Timestamp`, `SourceId`; 1541 uses `moveDelta`; none is defined in §2), with meanings already fixed by prose. Add to the §2 listing: `newtype Timestamp`, `newtype SourceId`, and the two-line `moveDelta` for the six-field `Move` (`moveDelta (Move s d _ q _ _) = [(s, negQty q), (d, q)]`). The 4013–4019 four-field listing then stands as the local recap it presents itself as — do not touch it. No design change.

**C2 — valuation listing 1920–1923, `cashSub` orphan.** Add a signature-only declaration `cashSub :: Cash -> Cash -> Cash` with a one-line comment (pointwise difference; inverse of the second argument), matching the listing's existing signature-only style for `markValue`. Do not import `cashNeg` (defined only later, 3277).

**C3 — UnitStatus duplication cluster (largest excision; Voice lens lead).** Canonical statement stays at its first home (~802). Compress the near-verbatim paragraph at 2118, 2381, 4496, 4567, 4980, 5546, 6031, and FAQ Q1 remark 6393 to one clause + cross-reference, **preserving each site's specific extension sentence** (4567 catamorphism/P8; 4980 EXERCISED flag; 5546 loan fields; 6393 keeps only "'Move-less' therefore names a transaction that overwrites this cache without altering any wallet balance" + pointer). Variants at 1937, 5181, 6529: compress only where verbatim; 6529's oracle form and the glossary copy (6883) stay. **RULING:** no theorem-like environment is deleted — the Principle env in §9 is protected (see C4). This is merged-draft duplication excision, explicitly sanctioned; the establishing statement is untouched.

**C4 — §9 "Primitives recalled…" (3187–3215).** Compress the re-definitions of wallet/unit/move/conservation and the re-tabled three homes to a notation-fixing sentence ($\mathrm{net}q(w,u):=h(w,u)$) with cross-references to §2/§4; retitle "Notation, and where the future's state lives". **KEEP intact:** the Principle environment [UnitStatus is a projection…] (constraint-8-protected class) and all futures-specific field-division content. If the editor finds that Principle env verbatim-duplicates an earlier env, escalate to owner — do not delete unilaterally.

**C5 — Glossary "The twelve conditions" (6891–6907).** **RULING (resolves add-C13-vs-scope):** no new condition prose. Scope the paragraph explicitly to §sec04's twelve and add a one-clause cross-reference to C13 (basis edge, \S8, line 2787). The hub index at 5979–6003 is **NOT changed** — NOETHER's fence upheld: its "the three-home model imposes twelve conditions" is correctly scoped, and adding a C13 row would be new content.

**C6 — Label rename pass (LAST, after all prose edits are final).** Mechanically rename all ordinal-encoded labels (`sec:sec01`…`sec:sec20`, `sec:appA`…, and `-suffixed` children) to semantic names, following the existing pattern (`sec:valuation`, `sec:cdm`, `sec:managed`). Pure global rename of labels + refs; zero prose deltas; zero output change. Verify with a diff of the compiled PDF text.

---

## D. PROTECTED DOMAIN VOCABULARY — KEEP (with the DO-NOT-TOUCH reason)

| # | Sites | Reason |
|---|---|---|
| K1 | `TermsVersion`, `ProductTerms (NonEmpty TermsVersion)`, `currentTerms`, `allVersions`, `appendVersion`, `txAppend`; "first version" at 824, 1203, 6020 | Append-only versioned ProductTerms is the design (C6/C7). "First version" = first element of the NonEmpty list. A naive R1 grep hits these — MATERIAL error to touch. |
| K2 | All 27–30 `supersed*` hits (1388, 1462, 1567, 1741, 1855, 5290-region, 6021, …) | Units superseding units is a lifecycle fact (C8 breaking amendments). Zero document-supersession usage verified by three lenses. |
| K3 | 331, 686 legacy-system parallel-run; register F1/F8 (6320, 6327) read-compatibility / pre-migration / parallel-run; §20 "Migration from legacy architectures" | Real BANK systems during deployment cutover — not document R4. |
| K4 | 5290 "no longer eligible", 6713 ex-coupon "no longer part of the remaining promise" | Evolution of MODELLED objects. Only two "no longer" sites in the file; both domain. |
| K5 | 4911 CDM version coexistence, 3074/6304/6914 CDM v6.0.0, F2 "version the predicate" | External-standard (ISDA CDM) versioning — modelled, pinned. |
| K6 | 2466–2468 "The three-home model … is retained; one field is added" | Conclusion of a live design argument (rejecting a fourth home), not text history. **RULING: keep unchanged** — no cosmetic churn. |
| K7 | 5909/6008 hub-vs-local dual register of P1–P23 | Declared architecture (spec + test oracle + canonical-name rule). Only the two voice phrases change (B13); structure protected from deduplication. |
| K8 | C13 absent from hub index 5979–6003 | Internally correct scoping; constraint 8 forbids the "fix". (Glossary side handled by C5 cross-ref only.) |
| K9 | All 'now/old/earlier/still/survive/retained' at 102, 1804, 2438, 3477, 3686–3800, 4038–4381, 5043, 5237, 5384–5744, 7145–7346, 7594, etc. | Modelled-object state (flat positions, ex-transitions, basis points, timers surviving restarts, replay). Blanket keep. |
| K10 | 5842 "a fourth gap" | Ordinal anchored to the same paragraph's enumeration — not brittle. |
| K11 | Same-name/different-type pairs: `applyMove` (§2 vs SBL 5357), `adjust` (509 vs 2830), `priceOf` (1900 vs 6751) | Section-scoped module preludes; SBL `applyMove` is cited in invariant prose — design vocabulary. |
| K12 | "Key Invariants and Consequences" recaps (920, 1829, 3122, 3955) | Each defers to the hub; no duplicated authority. |
| K13 | 2744 "Owner: market-data operations", 2982 "data governance"; TA-BASIS 2744 | Organizational functions — the correct register B6 conforms to. |
| K14 | Preface 111–112 reader guidance | Not R-class residue; out of this pass's mandate. No action. |
| K15 | TikZ/typographic comments (353–373, 593–611, 1044–1059, 2265–2277), ~60 unreferenced labels, all 5 bibitems, empty PDF metadata, §2/§4 layered Transaction/unitDelta exposition | Verified clean or deliberate. Keep. |

---

## E. OWNER ITEMS (outside the .tex; not editor dispositions)

1. **R1 wrapper:** filenames `ledger_v13_0.tex`/`.pdf`, directory `Ledger_Spec_v13.0/`, and `README.md` (which reconstructs the entire version history the directive erases). Rename to `ledger.tex` and rewrite README as a plain first-version build note, or exclude it.
2. Optional: `\hypersetup{pdftitle,pdfauthor}` to match the title page (cosmetic; not residue).
3. Technical (not residue, not ruled here): possible tension at 5748 vs the SBL-CDM gap table on Recall mapping — route to the responsible domain agent.

## Page budget (non-blocking, per owner's standing decision)

167 pp as compiled. Projected delta from this full disposition: ~3–5 pp (C3 is the bulk). No content cut is proposed or permitted; the sub-100 figure is not reachable by residue excision and is not pursued.

*Execution order is binding: A (D1–D5) → B (B1–B19) → C (C1–C5, then C6 last). After C6, recompile and diff extracted PDF text against the pre-C6 build: the only deltas must be those ruled above.*