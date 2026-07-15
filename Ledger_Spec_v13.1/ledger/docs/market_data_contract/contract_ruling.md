FORMALIS RULING — THE MARKET-DATA CONTRACT (consolidated from NAZAROV, THORP, MATTHIAS, WILSON)

All anchors verified by inspection: `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/ledger_v13_0.tex` (ingest door 2606–2642, TA-BASIS 2633–2642, OpSpec 2484–2497, re-derivation canon 2589–2604, pinned-chain-version precedent 2824–2826, W-table 2836–2885, divisor example 2950–2964, App D Scope ~6653–6666, FAQ 6103, glossary 6686 ff., roadmap ~89) and `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/reference/Ledger.hs` (BasisId 190–198, ledgerBounds 508–512, unitStatus 701, Market/statePrice/fibre commentary 850–882, Property 1421, effTip 1531–1544, p24 1546–1566, fibreOK 1568–1582). GHC unavailable; everything below is inspection-grounded; execution disposition stated once in Part D.

---

## PART A — ARCHITECTURAL RULINGS

Each ruling names the two alternatives compared, the winner, the origin design, and the property that checks it. No accepted design leaves a boundary uninjectable.

**R1. Stamping authority: the door stamps (Design A) over gateway-stamps-against-cited-view (Design B).** Origin: NAZAROV, whose A/B comparison is adopted verbatim as the ruling's grounds: under zero-trust the door must re-verify a gateway stamp anyway, so B either widens TA-BASIS or duplicates the computation, and B carries a standing served-view/commit race that A closes by construction. WILSON's MATERIAL finding (the consulted log prefix is currently ambient in `ingest`) is upheld and repaired inside A: the stamp is the pure total function stamp = f(projection version, convention version, source, t_obs, raw), and the StampedObs envelope records the (projection version, convention version) consulted. NAZAROV's advisory pre-stamp (SHOULD) is **cut** under minimalism: the projection is exported, so pre-staging is unspecified implementation freedom; the contract names exactly one stamp. Property: P-DET.

**R2. Projection interface: pinned immutable chain-plus-fold value, over tip-only and over live callback.** Origin: WILSON (chain, not tip — re-stamp repair and backward transport need the chain; a tip read is unpinnable), MATTHIAS (value semantics and the concrete surface), THORP (one pin per ingestion run, normative — see R6). Surface, exactly and only:

- `basisView :: Ledger -> BasisView` (BasisView abstract; a projection of the log, same rank as `unitStatus`, under the existing cache discipline — derivable, discardable, never authoritative)
- `viewAsOf :: [Transaction] -> Timestamp -> BasisView` (P8 machinery)
- `betaAt :: BasisView -> UnitId -> Maybe BasisId` — **Maybe ruled over total-with-Origin** (MATTHIAS): Origin-for-unregistered is a guessed basis wearing a type; the Maybe makes the door's UnregisteredUnit refusal a pattern match that cannot be forgotten. Invariant inv:basis's totality over registered units is untouched.
- `chainAt :: BasisView -> UnitId -> [(Timestamp, Integer, BoundaryId)]` (ascending lex (t_eff, prec, bid))
- `onChain :: BasisView -> UnitId -> BasisId -> Bool` (the admission predicate)
- Each view carries its version: the as-of log position. Nothing else is exposed.

The projection is **arithmetic-free**: no OpSpec, no operator kinds, no parameters, no arrows (NAZAROV over THORP's kind-exposure — THORP's reconciliation use case needs parameters, which are forbidden; TA-BASIS daily reconciliation is therefore an internal ledger workflow, not a projection consumer). NAZAROV's `correlate()` and the notice content-address export are **cut**: no obligation needs them. Consequence, stated in the document: "no CA logic outside the Ledger" holds by information hiding — an external component does not possess the information needed to adjust. Consistency: BasisView is an immutable value (determinism of the stamp follows); monotone under append (p24 corollary: the tip never regresses; an on-chain stamp stays on-chain under any later view); cache-vs-replay consistency is inherited from p24 — zero new proof obligations. Properties: p24 (exists), P25.

**R3. Flow direction: strict two-arrow pull, over bidirectional enrichment and over per-datum interactive query.** Rejections adopted: NAZAROV obj. 6 (position data outward is a different boundary), WILSON obj. 7 (live external read inside valuation is an ambient oracle), THORP obj. 6 / MATTHIAS obj. 7 (per-datum query is an unpinnable read; ingest must be deterministic in visible arguments). The G3 sentence is in Part B. Property: type fact — BasisView has no mutators, StampedObs no exported constructor, `ingestAt` pure and total over a value argument.

**R4. Published signature: keep `ingest :: Ledger -> ...` verbatim (tex 2613), with the normative factoring `ingest l = ingestAt (basisView l)`; the market-data layer links against `ingestAt` only; the Ledger value never crosses the boundary.** Origin: MATTHIAS (over revising the tex signature to `BasisView ->`). The existing verbatim block is untouched.

**R5. Quarantine representation: the Left branch of ingest IS the quarantine, payload retained in IngestError; consumable = Right image of ingest, a type fact.** Origin: MATTHIAS (over a Pending-stamp variant inside StampedObs, which would tax every consumption site forever). The G2 prose phrase "Pending-equivalent" is realised as the refusal channel, not as a stamp value. The quarantine store (the fold of Lefts) is part of the reference surface, inspectable by the W3 workflow. `IngestError = UnregisteredUnit | UndeterminedBasis | OffChainClaim`, payloads retained.

**R6. The pin is normative.** One ingestion run pins one projection version; the StampedObs attestation envelope records (projection version, convention version). Origin: THORP (torn-run unrepresentability) + WILSON (obj. 4: without the pin, P-DET, P-MODE, P-CRASH and as-known-at-t replay are unprovable). Ruled as an **extension of the existing abstract envelope comment** (tex 2615–2617), not a new primitive; precedent already in the document's own words, "a pinned snapshot plus a pinned chain version is reproducible and right" (tex 2824–2826). Boundary-side discipline only; internal semantics untouched; no escalation required.

**R7. Source basis convention: logged observation events under the existing canonical-handler idiom, versioned, as-of-queryable; owner named in the obligation set.** Origin: NAZAROV (O3) + WILSON (G2 addendum: an unlogged convention edit would silently rewrite historical stamps under replay); home in the numbered obligations per THORP open 5 — single lookup. No new state home.

**R8. Primitive vs derived: THORP's criterion (a) is adopted.** A datum is **derived** iff computed inside a snapshot scope from ledger-stamped inputs; such data carry the joint stamp of their inputs and are never transported (canon unchanged). A value computed **outside** the ledger from data the ledger never stamped — a provider-published index level, a vendor curve — is a **primitive observation of the publisher's unit**, singleton stamp, the publisher's rebalance/divisor events entering as W4 basis notices on that unit. Grounds: authority tracks computation (the log's authority over the provider's arithmetic is nil); the purist alternative (joint stamps on all composites) puts a 500-wide stamp on every index tick and a 500-way pointwise check at every consumption — unimplementable, and it proves nothing about arithmetic we did not perform. Fail-closed is preserved: composition change without a maintenance boundary is W3 quarantine on the level series. The divisor worked example (tex 2950–2964) survives **verbatim** — that divisor was snapped in-scope from stamped inputs and keeps its joint stamp. One-clause edit required at tex 2597: the canon-elaboration example "a vendor divisor, an index level" becomes the in-scope case (e.g. "a divisor snapped in-scope from stamped constituents"); the criterion is stated once in the contract subsection. **Escalation guard:** if editors find any theorem, condition, or property (beyond that example clause) whose statement depends on provider-computed levels carrying joint stamps, stop and escalate; this ruling changes a boundary classification, never C13, the canon principle, or any internal semantics.

**R9. Batch/real-time stamping semantics unified.** One pinned view per run (R6); within the run, each datum's stamp is computed by the source basis convention **as a function**, with the datum's t_obs as one argument, against the pinned chain. Where the convention itself names the basis — a pre-adjusting source, or a historical file declared adjusted-through (THORP O6, the highest-volume real-world basis error, named as its own obligation) — the convention takes precedence over any t_obs-position reading. Never β at arrival time (tex 2625 kept verbatim); never a bare timestamp join (tex 2360–2364 already refutes it; NAZAROV obj. 7 and THORP obj. 3 both upheld). This reconciles NAZAROV's asOf(t_obs) with THORP's file-convention stamping: t_obs is an input the convention may use, never the coordinate. Property: P-MODE.

**R10. Fixings/benchmarks: no carve-out.** A fixing crosses a boundary only along a declared arrow; basis-insensitivity is a declared AId, never assumed (WILSON — "obviously invariant" is exactly what AId-must-be-declared exists to block); the default declaration is empty, so transport is refused (MATTHIAS's fail-closed default is the same rule seen from absence). Benchmark cessation/succession is a named instance of existing operators, Subst composed with Shift (the published fallback spread), no new OpSpec case (THORP). No new W-regime: W1/W2 cover (NAZAROV open 7 confirmed). Republication within a correction window: **one clause in the row** — a new observation on the value axis, basis untouched (THORP open 6: kept, at clause length, because the row's fail-closed column needs the content and it pre-empts a real ops question). NAZAROV's "invertible generators only" special rule is subsumed by the general rule and not separately stated.

**R11. Coordinate sensitivity is declared data in the OpSpec partial-map idiom — not a fixed two-valued enum, never a function.** A datum kind's declaration states, per coordinate and per operator class acting on the kind, which coordinate carries the boundary's declared action (e.g. absolute-strike coordinates carry the price action under Scale; a moneyness coordinate declares AId); an undeclared (coordinate, operator-class) pair has no arrow — the existing absence-is-load-bearing semantics reused verbatim (WILSON), zero new machinery. MATTHIAS obj. 6 upheld: a rescaling *function* is model content, a MATERIAL finding. MATTHIAS open 7 answered: cardinality is not fixed at two; it follows the declared operator classes, via the partial map.

**R12. Duplicate raw data: the door is idempotent by content address, returning the existing StampedObs — the P6 idiom at the observation plane** (WILSON open 3). Crash-recovery (F9) is written under this ruling: a StampedObs exists only as a log event; crash-before-append is nothing-happened; resubmission dedups.

**R13. W1 staleness clock: the threshold value lives in ProductTerms; the clock reading is an explicit invocation argument, never ambient** (WILSON open 5; the arbiter's no-uninjectable-boundary rule).

**R14. P-MODE status: theorem in prose (a one-sentence consequence of stamp purity under the pin) with the authored property as its executable shadow** (WILSON open 6).

**R15. Fault catalogue home: a compact table inside the contract subsection whose discharge column cites the existing W-regimes and properties; the W1–W4 table gains no rows.** Compared against WILSON's preference to extend W1–W4: the W-table's organising principle is consequence-class regimes; F1–F10 are boundary fault *scenarios*, several of which (crash, dedup, reordering) are not world-splits. One register per purpose; the discharge column prevents a second failure register by pointing into the first.

**R16. "No unstamped observation is consumable" is discharged in three parts:** P25 (door soundness, Property-shaped) + C13 at withSnapshot (exists) + the stated type fact that StampedObs is abstract (no side door), unnumbered per the fibreOK/`total` precedent (MATTHIAS open 6/8; the omnibus alternative rejected as re-proving p24's territory).

**R17. Future-effective (pro-forma) stamping: refused at the door until the boundary commits — no new admission path.** THORP open 3 is answered against THORP's reading, on inspection: `effTip` (Ledger.hs 1538–1544) is the lexicographic maximum over *committed* boundary events with no now-filter, so a committed future-t_eff boundary would advance the tip immediately — which is exactly why the document commits boundary transactions at effectiveness ("Pending ... advances the basis id at effectiveness — the moves and SetBasis commit atomically", tex 2579–2581) and holds the announcement window in pending-transition (W4). Therefore a pro-forma datum claiming a not-yet-committed basis id is an `OffChainClaim` refusal with retained payload, re-presented after effectiveness; the announcement window is already governed (W1 blocks, W2 quarantines, W3 partitions). Zero new machinery; no tip-weld interaction.

**R18. Vol row: declarations only.** Any statement of how a vol *value* transforms — sticky-strike, sticky-delta, any mandated parametrization — is a MATERIAL finding (unanimous: NAZAROV obj. 5, THORP obj. 5, WILSON obj. 8). One factual clause is admitted as grounding: listed markets adjust option strikes and multipliers for splits and qualifying distributions, so the Scale relabelling of an absolute-strike coordinate is transcription of an exchange fact, not a model (THORP).

**R19. Worked example home: inside the contract subsection** (NAZAROV open 6, THORP open 7 — both designers' preference; it is the contract's own seam being exercised). One cross-reference from the §8 end-to-end walk.

WILSON's determinism audit is accepted in full; his single MATERIAL finding (ambient prefix) is repaired by R1+R6 and closed.

---

## PART B — COINAGE REGISTER (default: plain phrase)

APPROVED:
- **"basis projection"** — glossary term; used throughout the contract; near-plain (NAZAROV/THORP/WILSON all converged on it independently).
- **"Stamping authority"** as the named G1 principle (the prompt mandates a name; three designs proposed this one).
- **`BasisView`, `ingestAt`** as reference-code identifiers (MATTHIAS; each used in door, oracle, and generators — clears the ≥2-use bar).
- **"source basis convention"** for the per-(unit, source) convention (plainer than the alternative; self-describing).

REJECTED (use the plain phrase shown):
- "stamping context" → "the basis projection, pinned per ingestion run" (THORP).
- "dissemination convention" → "source basis convention" (NAZAROV; tex 2637's existing "the source's dissemination" is plain prose, untouched).
- "stamp pin" / "chain version" as terms → "the projection version (the as-of log position)" (WILSON; tex 2825's existing "pinned chain version" prose stands).
- KVolAbsStrike-style datum-kind names → plain prose in the table (NAZAROV open 3d).
- "primitive/derived observation" needs no coinage; the criterion gets a glossary row in plain words.

---

## PART C — THE SETTLED CONTRACT (what the editors write)

### G1 — Principle and interface

**Stamping authority** (named principle, stated once): *the Ledger's committed boundary chain is the single source of basis truth; the ingestion layer stamps by consulting a derived, read-only projection of that chain — never by re-implementing corporate-action logic — and no component outside the Ledger authors, defaults, or adjusts a basis coordinate.*

The basis projection, as an interface: the R2 surface exactly (basisView / viewAsOf / betaAt / chainAt / onChain, plus the view's version = as-of log position). Semantics: a projection of the log like every other projection, under the existing cache discipline (derivable, discardable, never authoritative — tex 2366–2367 reused, not restated); an immutable value once constructed; monotone under append (p24 corollary); arithmetic-free — it exposes no operator kinds, parameters, or arrows, so "no CA logic outside the Ledger" is a consequence of information hiding, not a policy. Consumers: any ingestion layer (in-process, gateway, batch loader) and diagnostics. Consistency proof inherited from p24; no new obligations.

### G2 — Provider and ingestion obligations (numbered, one home)

- **O1** A raw observation carries: exact value, observation time (attested data, never compared raw against any wall clock for semantics), signed source id, and a unit reference resolvable to a registered UnitId. Nothing more is demanded of providers. (NAZAROV O1, WILSON O1–O4.)
- **O2** The Ledger attaches the stamp, at ingestion, from the pinned basis projection and the source basis convention; the attestation envelope records the projection version and convention version consulted, so every stamp replays as a pure function of recorded data. (WILSON pin; R1, R6.)
- **O3** Providers are not required to be corporate-action-aware: a pre-adjusting source and a lagging source are both representable, because the stamp says which basis the value is in — the quote-ex flag of App D generalised from one bit to the coordinate. (All four designs.)
- **O4** Each (unit, source) pair has a source basis convention on file, entered as logged observation events under the existing canonical handler — versioned, as-of-queryable, no new state home. Owner: market-data operations, under TA-BASIS, reconciled daily against vendor-published adjustment factors. (NAZAROV O3, WILSON addendum, R7.)
- **O5** A datum whose basis cannot be determined is refused with payload retained — the quarantine — and is never given a guessed basis and never defaulted from the ledger's prevailing state; an unresolvable or unregistered unit reference is refused outright (existing rule, kept verbatim). (R5; tex 2625–2627.)
- **O6** A historical series pulled as a back-adjusted file is stamped from the file's declared adjusted-through convention, never from the basis prevailing at each row's observation time. (THORP O6, named as its own obligation.)
- **O7** Feeds are signed; an unsigned feed enters only through a gateway that counter-signs under a named key with its own scoped trust assumption. (NAZAROV O6.)
- **O8** A vendor value correction is a new observation superseding by (source, unit, t_obs); a duplicate content address is idempotent at the door; basis re-coordination is exclusively the Ledger's re-stamp event with lineage. (NAZAROV O7, R12, §time-travel reused.)

### G3 — Direction of flow (the one sentence)

*Exactly two arrows cross the market-data boundary: the basis projection flows out — read-only, versioned, a view of the log — and raw observations flow in through ingest, the sole door, where the Ledger itself attaches the stamp; the market-data layer never writes ledger state, and the Ledger never accepts a basis it did not stamp or verify against its own committed chain.*

Pull-based and versioned; no per-datum query, no callback (R3).

### G4 — Generalisation table

Four columns: **Raw datum | What the stamp covers | Declared operator classes acting | Fail-closed meaning**. Six rows:

1. **Spot and quotes.** Disseminated trade/quote, exact value, t_obs, source. Singleton stamp {u ↦ b} per (unit, source). Scale, Shift, Subst; the lagging source is the per-source convention case (already in tex 2621–2625). Unknown convention quarantines the series; W3 partitions by stamped basis around ex-dates.
2. **Implied-vol observations** (strictly observations). Vol value plus labelled coordinates (absolute strike, expiry, moneyness/delta), coordinate metadata transcribed from the source, never inferred. Singleton stamp on the underlying (option-series units where registered). Per R11: coordinate sensitivity is declared data — absolute-strike coordinates carry the boundary's price action under Scale (transcription of the exchange's own contract adjustment); moneyness declares AId if the source says so; the vol value is never transformed, no parametrization mandated. Undeclared coordinate at a boundary = no arrow = quarantine; an unpriced vol point is an enumerated Unpriced, never a transported value.
3. **Index levels.** Provider-published level = primitive observation of the index unit (R8); singleton stamp {I ↦ b_I}; the provider's rebalances/divisor changes enter as W4 basis notices on I, declaring Recompose. Composition change with no committed maintenance boundary → W3 quarantine of the level series. The in-scope snapped divisor (the existing worked example) is the derived case and keeps its joint stamp; the criterion — derived iff computed in-scope from stamped inputs — is stated once here.
4. **Compositions, weights, divisors.** Provider files; boundary logged as a W4 notice with its t_eff; pro-forma data claiming a not-yet-committed basis id are refused into quarantine until the boundary commits at effectiveness (R17); Recompose, invertible iff sigma declared bijective. Fail-closed is the 70.8 phantom, refused.
5. **Fixings and benchmarks.** Raw datum carries fixing time and publication time; singleton stamp on the benchmark unit at the basis prevailing per the administrator's convention. Crossing any boundary requires a declared arrow — AId is declared, never assumed; the default declaration is empty, so transport is refused; cessation/succession is the declared Subst-then-Shift instance (published fallback spread). A republication within a correction window is a new observation on the value axis; the basis axis is untouched (one clause). A fixing meeting Terminal or a Pending gap: W1 blocks — real money never moves on an unwitnessed basis.
6. **Curves and derived data.** Derived in-scope from transported primitives; joint stamp inherited compositionally — the re-derivation canon and its functorial story stated once in §8 and cross-referenced here, never restated; never transported; one refusing input refuses the derived point, enumerated per unit. A vendor-supplied curve is the primitive case of row 3 (publisher's unit, singleton stamp).

### G5 — Operational modes, worked example, fault catalogue

**Modes — one contract three times.** Real-time: stamp each datum at ingestion from the pinned projection with the source convention at t_obs. End-of-day batch: one pinned projection version per run (normative); the file's declared convention supplies the stamp evidence; a boundary committing mid-run cannot tear the run. Historical pulls: O6. Multi-vendor: same door per SourceId; disagreement on **value** within one basis partition is data quality, out of scope; disagreement on **basis** is different stamps — W3 partitions, in scope, resolved by the stamp; no aggregate is ever computed across partitions (the median-75 sentence, tex 2864–2866, promoted to a property). Stamping semantics per R9: the convention is the function, t_obs an argument, never the coordinate.

**Worked example (in this subsection, R19).** A 2-for-1 split effective at the open; the stored pre-split print 100 is stamped b3. Consumer A opens withSnapshot at 09:29: β(u)=b3, consumes 100 as-is, marks 1,000 × 100. Consumer B opens at 09:31: β(u)=b4; the same stored observation transports along the unique declared arrow to 50; marks 2,000 × 50. Same series, opposite sides of the boundary, both correct; totals related by the value-invariance theorem; the 2,000 × 100 phantom is a type error on A's side and a typed refusal at B's seam. (THORP's numbers, WILSON's framing.)

**Stated consequence (verbatim-grade, THORP):** *No corporate-action logic exists outside the Ledger, because adjustment arrows are declared once, in the log, and applied by the one evaluator; the ingestion layer's whole competence is transcription — of values, times, and conventions — never adjustment.*

**Fault catalogue** (table in this subsection; discharge column cites existing regimes/properties; W1–W4 table unchanged, R15):
F1 late notice → tip weld + re-stamp lineage + W3/W1 (exists; extend the effTip/agrees oracle to stamps). F2 duplicated notice → content address + idempotent SetBasis (P6). F3 reordered notices → P-PERM-N (strong form claimed: the tip weld makes every admissible booking permutation yield the identical chain projection — WILSON obj. 9 upheld). F4 omitted notice → W3 innovation-without-boundary detection (detection, not guarantee) + fail-closed Pending. F5 duplicated observation → idempotent door (R12). F6 reordered/late observations → P-PERM-O. F7 omitted observation → snapPrice Left, Unpriced enumerated (exists). F8 clock skew → t_obs is data; only the W1 staleness check reads a clock, and that clock is injected (R13). F9 crash mid-ingestion → P-CRASH; crash-before-append is nothing-happened; resubmission dedups via F5. F10 multi-vendor basis disagreement → W3 partitions; property: no cross-partition aggregate representable.

---

## PART D — PROPERTIES (WILSON's requirement, consolidated)

New, authored: **P25** door soundness (on Right, every stamped unit is registered and every stamped id on-chain; on Left, nothing admitted, payload retained; Property-shaped per MATTHIAS's listing); **P-DET** same (projection version, convention version, source, t_obs, raw) ⇒ bit-identical StampedObs; **P-MODE** batch/real-time equivalence (theorem in prose + property shadow, R14); **P-PERM-N** (strong); **P-PERM-O** valuation invariant under ingestion-order permutation at fixed pins; **P-CRASH** every crash point recovers to a committed prefix; **P-REPRO** same log + stamped observations + pinned chain version ⇒ bit-identical valuations; **P-CLONE-STAMP** as-known replay reproduces the honest mistake, corrected replay applies re-stamps, both deterministic; the F10 no-cross-partition-aggregate property. Stated unnumbered as a type fact (fibreOK precedent): no side door — StampedObs abstract, constructors unexported. Existing and reused, not re-proved: p24, C13, the Cum/Ex fibre law, divisor refusal, W1 no-money-on-BasisError.

Generators (merged MATTHIAS + WILSON): genStampedObs **only by calling ingestAt** — never forge a stamp, shrink the RawDatum and re-ingest; genChain/genBoundaryEvent (monotone (t_eff, prec, bid), retro-effective t_eff, same-t_eff prec collisions, all seven OpSpec constructors, side conditions respected; prefix-closed shrinking); genNoticeTiming (t_eff, t_notify) including the re-stamp window; genVendorBehaviour (TracksChain | LagsBy k | PreAdjusts | DeclaredAt b | NoClaim, shrink toward TracksChain); genBoundaryStraddle (the worked example as a scenario); booking-order interleavings; crash schedules; multi-vendor partitions.

**Disposition, stated once for the whole catalogue: all properties are authored in catalogue shape with generators and shrinkers and verified by inspection; execution is PENDING-TOOLCHAIN (GHC unavailable) and is never reported as passed.**

---

## PART E — G6: PLACEMENT, EDITS, VOICE

1. **New subsection** `\subsection{The market-data contract}` in §8, inserted immediately after "The stamp and the ingest door" (between tex 2642 and `\subsection{The invariant}` at 2644). Title per NAZAROV/THORP; MATTHIAS's "The Ingestion Boundary" rejected as less findable from the reader's question. Contents: G1 principle + interface, O1–O8, the G3 sentence, the G4 table, G5 modes + worked example + fault catalogue, the R8 criterion, the stated consequence. Budget ≤3 pp (168 → ~171, inside the 200 cap).
2. **Reference code**: new Part in `Ledger.hs` after Part L — BasisView surface, IngestError, ingestAt factoring (`ingest l = ingestAt (basisView l)`; published signature at tex 2613 untouched), P25, generators. All new listings ILLUSTRATIVE, pending-toolchain; sweep every fresh listing for agent-name provenance residue.
3. **One-clause edit** at tex 2597 per R8 (canon-elaboration example becomes the in-scope snapped divisor); escalation guard applies. No other touch to existing §8 prose; protected elements (atomic move, conservation, log immutability, internal State-Basis semantics) untouched.
4. **App D**: one cross-reference sentence in the Scope subsection (~tex 6653–6666), which already states the fibre reading: add that `mQuoteEx` is the one-bit pedagogical fibre *of the market-data contract* (§8), pointer only.
5. **Front matter**: roadmap §8 row gains the boundary-contract pointer; FAQ (tex 6103) gains one entry — "Must a provider track corporate actions? No (O3): the stamp says which basis the value is in."; glossary gains rows for *basis projection*, *stamp*, *source basis convention*, and the *primitive/derived observation* criterion. One lookup from question to answer.
6. **Voice**: first-version throughout; standalone; no trace of this exercise, any reviewer, or any prior version; no diff-voice; every G4 row written as a fact about market structure. Model-agnostic absolutely: pricing functions uninterpreted; any statement of how a vol or derived value transforms is a MATERIAL finding (R18).

Files: `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/ledger_v13_0.tex`, `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/reference/Ledger.hs`.

— FORMALIS. The contract completes the discipline at the boundary; it alters nothing inside it. Every ruling above names its alternatives, its origin, and its property; execution of the property catalogue awaits the toolchain and is reported as nothing more.