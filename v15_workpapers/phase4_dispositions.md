# Phase 4 — Consolidated Review Dispositions (PARETO arbiter record)

Five Phase 4 reviews are complete and persisted:
`phase4_formalis_conformance.md`, `phase4_cartan_continuity.md`,
`phase4_taleb_review.md`, `phase4_ashworth_review.md`, `phase4_lexmandatum_review.md`.

**Structural verdicts.** FORMALIS: conformance matrix TOTAL both directions; all three
v1.1 amendments realised; coverage invariant in DEFECT-9-corrected form throughout; no
constitutional conflict. CARTAN: six threads unbroken, zero number forks, stale 2026-05-29
absent everywhere. TALEB: READY-WITH-FIXES. Compiles clean at 69pp (ToC), no undefined refs.

**Arbitration rule.** No finding requires amending the constitution or the ratified
collateral ruling. Every accepted fix *completes* machinery the spec already contains
(cum/ex operator in Ch.8/14; obligation + supervised write-off in Ch.9; observation
ordering in the log). Constitutional-parking index (Ch.17) receives only genuinely open
design residuals. FORMALIS re-verifies the collateral/settlement seam after fixes.

**File→editor map (each file edited by exactly one agent this round):**
- Agent 1 (MINSKY): Ch.9, Ch.11, Ch.14 — the correctness cluster.
- Agent 2 (KARPATHY): Ch.2, Ch.3, Ch.5 — one-touch barrier faithfulness + accumulator (Ch.5).
- Agent 3 (WILSON): Ch.6, Ch.15 — accumulator ordering + generator-universe enumerations.
- Agent 4 (MATTHIAS): Ch.13 — CDM precision.
- Agent 5 (general): Ch.7, Ch.8, Ch.12 — light clarifications.
- Agent 6 (general): Ch.1, Ch.16, Ch.17 — light clarifications + open-problems index.

Preserve each chapter's voice and every FROZEN number. Do not renumber existing labels
(P1–P6, sec:*, inv:*, prin:*) — other chapters cite them.

---

## SUBSTANTIVE FIXES (must land before freeze)

### FIX-1 — Ch.11: entitlement routing must be ex-date-aware (LEX L-1 SIGNIFICANT; ASHWORTH A-1)
The D2 *Entitlement routing* proposition currently keys the market claim on "owned +
settlement state **at the record date**." Economic entitlement is fixed by the **ex-date**
(cum/ex), not the record date. Fix:
- A market claim for a distribution arises **iff the trade is cum-entitled (executed before
  the ex-date) and remains unsettled at the record date**; entitlement then routes from the
  registered holder to the **cum-buyer** via the market-claim unit. An **ex trade** (executed
  on/after the ex-date) that is unsettled at the record date raises **no** buyer claim — the
  registered holder keeps the distribution, matching the ex-buyer's economic expectation.
- Wire in the existing cum/ex machinery: the ex-date operator of Ch.8 (§9, G5) and the
  cum/ex invariance witness catalogued in Ch.14. The routing predicate reads the trade's
  execution date against the ex-date; the record date only fixes the registration snapshot.
- In the worked micro-example, note that the 2026-05-14 sale is **cum** (executed before the
  ex-date of the 2026-05-15 record date); that is *why* the claim routes to the buyer. Do not
  invent a new frozen ex-date number — state the ex-date qualitatively relative to the frozen
  record date. Keep all amounts (15,000.00 / 1,500,000 minor units) unchanged.
- Keep "settlement failure is a recorded event, never a reversal" (LEX confirms CSDR-correct).

### FIX-2 — Ch.14 (+ Ch.9/Ch.11 seam): soften the coverage over-claim under instructed ownership (TALEB T-1 HIGH; ASHWORTH A-1 HIGH)
Ch.14 currently claims collateral "delivered that was never possessed … unreachable."
Because `owned` is booked at **instruction** (trade-date ownership), a wallet CAN post or
deliver a security it has bought but not yet settled — so that state is reachable, and the
settlement-fail chain lives inside the model. Fix (Ch.14, coverage invariant discussion):
- Replace the impossibility claim with the accurate statement: the coverage invariant
  `Σ_G posted_G(w,u) ≤ max(owned(w,u),0)` is enforced **at the door on every transaction**;
  it forbids *recording* a state with posted in excess of instructed ownership, but instructed
  ownership includes a bought-not-yet-settled position. A subsequent involuntary reduction of
  `owned` (a failed or cancelled purchase) that would drop it below `posted` is **refused at
  the door**; the unmet return is carried as a **recorded obligation** and, on default,
  escalates to the **supervised write-off** path (Ch.9). The invariant is never false in a
  committed state; the residual economic exposure is an obligation, never a silent breach.
- Ch.9/Ch.11: add one sentence making the same point where owned re-books at instruction —
  the fails cascade resolves by order-forcing at the door + obligation + supervised write-off,
  not by impossibility.
- CL-5 (TALEB T-10): note that coverage on fungible cash is a **per-move** check (owned USD is
  claimed by every obligation); aggregate cash adequacy is the **sufficiency obligation**, not
  the coverage invariant. One sentence in Ch.14 (and/or Ch.9).

### FIX-3 — Ch.2/Ch.3/Ch.5: the one-touch barrier is observed at the official close (TALEB T-3 MED-HIGH)
OT-1's terms read "touch-at-or-below" (continuous) but its watch and knock are the **official
close** (79.00). A continuous barrier is not faithfully transcribed by a close watch — an
intraday touch would be silently missed, violating §6 faithfulness and the Ch.3 graph-
consistency invariant (watch ≡ the edge's declared guard). Fix, **consistently in Ch.2, Ch.3,
and Ch.5** (canonical wording):
- State OT-1's barrier as **breached when the official close is at or below 80.00** — a
  discretely-monitored (closing-price) one-touch. The watch that observes the official close
  then faithfully transcribes the term; the knock at official close 79.00 is exact.
- Keep every number (barrier 80.00, knock close 79.00, payout 1,000,000). This is a wording
  alignment, not a number change. Ch.5 must show the watch = the declared close-observation
  guard (graph-consistency holds).

### FIX-4 — Ch.9: declared agreement terms are a catalogued boundary input (ASHWORTH A-2 HIGH; TALEB T-5)
Ch.8 holds market data to provenance + failure regimes (W1–W4, TA-KIND); Ch.9 rests on the
agreement's declared terms (eligibility, valuation %, thresholds, trapping predicate)
transcribed once, held to none of that, with only the regime bit given a detector/repair.
Fix (short paragraph in Ch.9, generalising the regime-bit treatment):
- Declared agreement terms are **boundary data with the executed agreement as provenance**.
  A transcription error is a **perimeter-reconciliation matter** — the same class as the
  §13-invisible regime bit and Ch.8's TA-KIND — detected by boundary reconciliation against
  the counterparty's own record and repaired by **terms amendment plus compensating
  rebooking**, never a silent edit. The regime bit is the worked instance; the treatment is
  general over all declared terms.
- CL-1 (TALEB T-5): the agreement-terms / regime-bit **reconciliation duty** must also appear
  as a data-boundary minimum in Ch.16 (Agent 6 adds it to the B-group).
- CL-7 (LEX L-5 / ASHWORTH A-6): note the eligibility predicate **may read ledger state**
  (concentration limits make eligibility portfolio-state-dependent), exactly as the coverage
  check reads state — "checked at the door, never typed" stands; add "the declared predicate
  may read recorded state."

### FIX-5 — Ch.13 (+ Ch.15 sync): correct the CDM Payout characterization (LEX L-2 MED; L-3, L-4)
"The eight-way `Payout` choice" mischaracterises CDM 6.0.0: `Payout` is **not** a closed
one-of/enum — its payout components are **cardinality-many and co-populated** (a swap
populates both an interest-rate and a performance leg); the stated arity is wrong. Fix:
- Correct the description: payout components compose (co-populated), they are not a closed
  choice. Rest the **generator-universe** claim on the genuinely **closed enumerations**:
  day-count fraction, option type, and the primitive-instruction set. (Canonical closed-
  enumeration list for Ch.13 ↔ Ch.15 consistency — Agent 3 uses the identical list in Ch.15:
  **day-count fraction; option type (call/put); the primitive-instruction set; the ledger's
  own closed sets — regimes {title-transfer, pledge, STM/CTM}, coordinate planes
  {owned, lent, posted}, trigger/event kinds, product-graph node/edge sets.**)
- L-3: `Trade.collateral` is CDM type **`Collateral`**, which *carries* `CollateralProvisions`
  — fix the type name; the identity argument rests on the type.
- L-4: reframe "collateral terms are part of identity" as **economic individuation**, not CDM
  identity (CDM identity is carried by `TradeIdentifier`).
- Keep "alignment shown, never adopted as authority" and "gaps stated as gaps" (LEX ACCEPT).

### FIX-6 — Ch.5/Ch.6/Ch.15: accumulator firings are ordered by recorded observation index (TALEB T-4 MED-HIGH)
Order-dependent accumulators (future margin reads "last applied level"; variance reads
`A_{k−1}`) are not reorder-safe; the claim "late firing costs nothing but timeliness" over-
claims. Fix (canonical framing, used identically in Ch.5, Ch.6, Ch.15):
- The immutable log's total order for a unit's fixings is the **recorded observation index**
  (the fixing sequence k), not arrival order. Replay folds in that order and is deterministic.
  A **late or out-of-order** print is inserted at its observation position k, and the
  accumulator tail `A_{k}, A_{k+1}, …` is **recomputed** from k forward — the result is
  identical to timely arrival *because the fold is over the ordered sequence*, but downstream
  daily CCP cash figures at positions > k are corrected by compensating transactions, not left
  as posted. Qualify the idempotence statement accordingly: duplicate = inert; **out-of-order =
  re-sequenced and tail-recomputed**, not a no-op on the tail.
- Ch.15 states this as an executable property (replay by observation index is deterministic;
  a late insertion recomputes the tail and the recomputation is bit-exact).

---

## CLARIFICATIONS (one to three sentences each; fold into the chapter being edited)

- **CL-2 (Ch.7, TALEB T-7):** deposit-neutrality is a theorem **only if the declared financing
  rate equals the fair rate**; the case-2 return obligation is priced at the inflow amount
  (par-plus-accrued). Name this assumption at the deposit-neutrality proposition.
- **CL-3 (Ch.1, TALEB T-8):** state plainly, once, that **internal unbreakability is not
  external correctness** — the ledger guarantees one consistent internal record; correspondence
  with the outside world is reconciled at the boundary (Ch.8), never assumed. One sentence.
- **CL-4 (Ch.8, TALEB T-9):** note the W3 divergence threshold is a **governance parameter**;
  under correlated stress (all venues diverge) it defers valuation book-wide — an intended
  fail-closed, flagged as a calibration/governance matter, not a silent behaviour.
- **CL-6 (Ch.12, ASHWORTH A-3/A-4):** state the attribution pool predicate is **total over
  recorded log state** (declared data in Ch.8's slot); an input not on the log is not
  admissible, so there is no hidden manual tagging step. Frame the one two-sided figure
  (net-exposure collateralisation) as the genuinely reconciled surface named beside the
  projections — not a late concession.
- **A-6 (Ch.12):** distinguish **gates admission** (eligibility refuses a bad transaction at
  the door) from **alters a quantity** (the reference-data join never does) — no contradiction.
- **A-7 (Ch.9):** note manufactured payment is modelled as a trapping **condition**; where a
  withholding/manufactured-rate **amount** transformation applies, it is a declared term of the
  agreement, read like any other declared datum (one clause; do not expand into a companion).
- **A-8 (Ch.8):** one clause placing **amended/withdrawn corporate-action notices** as the
  bitemporal W2 case (a late/superseding datum), consistent with originals-never-overwritten.
- **CL-9 / TALEB T-6 (Ch.9, OPTIONAL, compressed):** the future thread is STM; add a **short
  CTM contrast paragraph** (not a full episode) — CTM differs by one declared term and one
  returnable-liability obligation unit, per the ruling's D5. Keep it to a paragraph; respect
  minimalism and the page budget.
- **F11 (Ch.1, optional):** one clause acknowledging the reader is not assumed to know category
  theory (the second-tellings are deletable) — reinforces the CT protocol already followed.

---

## PARKED / ACCEPT-WITH-NOTE (Ch.17 open-problems index — Agent 6)

- **P-1 (FORMALIS F-1, MEDIUM):** §6 managed-account **fee accrual / NAV attribution** is a
  partial discharge — the constitution defers it "to the detailed specification," but v15
  neither works nor names it. Park it in Ch.17's open-problems index as a residual for the
  detailed specification (no amendment; the constitution's own deferral licenses this).
- **P-2 (TALEB T-2 HIGH; FORMALIS/ASHWORTH note):** the per-netting-set **claim/obligation
  apparatus exists for close-out, and the close-out/netting algebra is undesigned**. It is
  already named in Ch.17 — **elevate it to the explicit TOP open risk** in the open-problems
  index, with one line on what it entails (default → close-out valuation → net → recovery
  decoupling), consistent with the ruling's claims-priced-by-taker / decouple-on-default.
- **ACCEPT (no edit):** L-6/A-5 — "settlement failure is a recorded event, never a reversal"
  is CSDR-correct; partial/tranched settlement is the settlement layer's "how" (out of scope).
  Add **one clause** in Ch.11 noting the ledger records the settled quantity on confirmation
  and that partial-settlement mechanics belong to the settlement layer (Agent 1).
- **ACCEPT (no edit):** FORMALIS F-2/F-3 (Ch.13 CDM as §6/§2 demonstration; three additive-but-
  anchored mechanisms) — grounded, Method-permitted; no action.
- **Workpaper-only note:** LEX flags the *ruling memo's* citations (SFTR 4.4–4.7 → ITS 4.11–4.14;
  CSA Para 5(c)) as imprecise, but these **do not appear in any chapter** (chapters cite only
  the correct Para 13 / 6(d)(i) or stay generic). No chapter edit; left as the historical record.

---

## POST-FIX GATES
1. Recompile (multi-pass); confirm no new errors / undefined refs; page count still ≤ 100.
2. FORMALIS re-verifies the Ch.9/11/14 collateral-settlement seam + a conformance delta.
3. CARTAN spot-checks that no frozen number moved.
4. STYLUS form pass over edited chapters (voice, economy, deductive order).
5. PROCRUSTES final page ledger; STYLUS + PROCRUSTES sign-off.
6. Commit + push final with the full committee record (all phase4_*.md + this disposition).
