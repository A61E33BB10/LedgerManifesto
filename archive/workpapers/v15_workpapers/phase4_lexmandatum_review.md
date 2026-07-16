# Phase 4 Review — LEX MANDATUM (legal / regulatory / standards bindingness)

**Reviewer:** LEX MANDATUM (Team B, adversarial panel). **Date:** 2026-07-12.
**Scope of review:** ch05, ch08, ch09, ch11, ch12, ch13 (legal/regulatory substance), with
ch14 checked for the catalogued propositions. Rated one-way against the constitution.
**Mandate:** judge only whether the spec's legal/standards CLAIMS are accurate and
appropriately hedged. Regulatory submission and legal-agreement enforceability are OUT OF
SCOPE per `EXCLUSIONS.md` (E31, E37, E53–E55, E73) and are not reported as gaps.

## Verdict in one line

The regime model (title-transfer vs pledge vs STM/CTM) is **legally coherent and unusually
sophisticated**; the "shown, not adopted" CDM posture **satisfies the constitution**; and the
hedging on IFRS/FINREP is **appropriately scoped**. One **significant** correctness gap: the
entitlement-routing rule is ex-date-blind. Two **CDM-precision** findings and three minor
notes. Nothing critical.

---

## F1 — SIGNIFICANT — Ch.11 (systemically Ch.5, Ch.9): entitlement determination omits the ex-date

**The claim.** Ch.11, Proposition (Entitlement routing): *"The recipient of a distribution is a
total function of the recorded owned plane and the recorded settlement state at the record
date."* Restated across the spec as *"who owns a unit at the record date is who is owed its
distribution"* (Ch.11 §11.3; Ch.9 "Entitlements: determination reads the owned plane"; Ch.5
firing 2 records the record-date entitlement).

**Why it is under-stated / incorrect as a general rule.** Dividend entitlement is not fixed by
ownership at the record date. It is fixed by the **ex-date** (the cum/ex status of the trade):

- Who the issuer/CSD **pays** = the holder of record on the record date (the record holder). The
  chapter models this axis correctly (settlement state → record holder).
- Who is **economically entitled** = fixed by the ex-date. A trade executed *before* the ex-date
  is **cum** (buyer entitled); a trade executed *on/after* the ex-date is **ex** (seller
  retains). The chapter models this axis by "owned at the record date" — i.e. trade-date
  ownership — which is **not** the same thing.

The two coincide for most date configurations but **diverge precisely in the window the chapter
exists to handle**: a trade executed between the ex-date and the record date. There, a market
claim should be assessed on cum/ex, not on trade-date ownership. An **ex** trade (executed on/
after the ex-date, unsettled at record date) generates **no** buyer market claim — the seller
keeps the dividend — yet the chapter, seeing owned re-booked to the buyer at instruction, would
issue a market claim to the buyer. The real matrix is 2×2 — (cum/ex) × (settled/unsettled at
RD) — and yields a buyer claim, a *reverse* (seller) claim, or *no* claim; the chapter's
symmetry is buy-side/sell-side, not cum/ex, so it does not capture the reverse claim that an
ex-trade settling before the record date produces.

**Evidence the fix is cheap and the omission is an internal inconsistency.** The ledger already
models the ex-date: Ch.8 §sec:witness and Ch.14 (lines 172–178) run a cum/ex invariance witness
that "subtracts the distribution's value" and refuses "a cum price consumed as ex." The ex-date
state is on the record and load-bearing for *pricing* — but is never wired into the *entitlement*
path. So the spec's own machinery contradicts the ex-date-blind determination rule.

**Evidence in the worked example.** Ch.11 micro-example: trade instructed 2026-05-14, settlement
2026-05-16 (T+2), record date 2026-05-15 — with no ex-date stated. Under standard T+2 the ex-date
is record-date − 1 = 2026-05-14, so the 05-14 trade is an **ex** trade → the seller (W-ALPHA)
retains the dividend and there is **no** buyer market claim. The chapter routes it to the buyer
(W-BETA). The routing is correct only under a T+1 ex-date convention (ex-date = record date =
05-15, making the 05-14 trade cum). The example thus mixes a T+2 settlement cycle with a T+1
ex-date assumption, and its entitlement direction is convention-dependent and unstated.

**Suggested wording.** Proposition: *"The recipient of a distribution is a total function of the
recorded owned plane as adjusted for the recorded ex-date state, and the recorded settlement
state at the record date. Economic entitlement is fixed by the ex-date (cum/ex, Chapter 8); the
paying agent credits the record holder; and a market-claim unit carries the reconciling leg from
the record holder to the entitled party wherever the two differ."* In the worked example, state
the ex-date explicitly and choose dates so the trade is unambiguously cum and unsettled at the
record date. Add an ex-date input to the Ch.5/Ch.9 determination sentences.

**Disposition: FIX.** (Correctness gap in a rule the chapter itself calls "load-bearing for
correctness"; not critical because it is a spec-level determination rule, not a submission
breach, and the reconciling mechanism — the market claim as a first-class unit — is sound.)

---

## F2 — MEDIUM — Ch.13: "the eight-way `Payout` choice" mischaracterizes CDM 6.0.0

**The claim.** §"Closed enumerations and the product graph": *"the CDM is built on closed
enumerations --- the eight-way `Payout` choice, the option-type and day-count enumerations, the
finite instruction set --- and closed choice types are exactly a generator universe … the CDM
enumerations seed the generator universe."*

**Why it is over-stated.** In CDM 6.0.0 `Payout` is **not** a closed one-of "choice" and is not
an enumeration. It is a structured type whose several payout components — `interestRatePayout`,
`performancePayout`, `optionPayout`, `assetPayout`, `cashflow`, `commodityPayout`,
`creditDefaultPayout`, `fixedPricePayout`, `settlementPayout`, … — are **cardinality-many and
co-populated**: a swap populates both `interestRatePayout` and `performancePayout` on one
`Payout`; a variance swap (as this very chapter states) populates `performancePayout`. So (a) it
is not an exclusive choice, and (b) the arity "eight-way" is inaccurate (there are more than
eight, and the set has grown across versions). Lumping `Payout` with genuine closed enumerations
(day-count, option-type — which *are* closed enums) to found the "closed choice types are exactly
a generator universe" claim overstates the CDM metamodel. The broader point (CDM has closed
enumerations that seed a generator universe) is TRUE and worth keeping; the `Payout`
characterization is the defect.

**Suggested wording.** *"the CDM is built on closed enumerations --- the option-type and
day-count enumerations, the finite `PrimitiveInstruction` set --- together with a finite, closed
set of payout components; closed choice and enumeration types are exactly a generator universe …"*
Drop "eight-way … choice."

**Disposition: FIX.** (A specific, checkable, inaccurate claim about a named standard the
constitution requires to be "shown, not asserted.")

---

## F3 — MINOR — Ch.13: `Trade.collateral` typed as "a `CollateralProvisions`"

**The claim.** §"Unit maps to product": *"the collateral terms live on `Trade.collateral` (a
`CollateralProvisions`), so two executions sharing one `NonTransferableProduct` but differing in
their collateral terms are distinct `Trade`s."*

**Why it is imprecise.** In CDM 6.0.0 `Trade.collateral` is of type **`Collateral`**, which
*contains* `collateralProvisions :: CollateralProvisions` (alongside `collateralPortfolio`). The
structural-identity argument rests on this type, so the precision matters where the chapter is
making a legal-identity point.

**Suggested wording.** *"the collateral terms live on `Trade.collateral` (a `Collateral`,
carrying its `CollateralProvisions`) …"*

**Disposition: CLARIFY.**

---

## F4 — MINOR — Ch.13: the trade-identity inference slightly overstates CDM's identity model

**The claim.** *"Unit identity therefore corresponds to `Trade` identity, not to
`NonTransferableProduct` identity --- collateral terms are part of identity in both models."*

**Why it is over-stated.** In CDM, trade identity is carried by `TradeIdentifier`, not derived
structurally from the collateral terms; two `Trade`s are individuated by their identifiers, and
`NonTransferableProduct` is deliberately counterparty-agnostic (hence not identity-bearing). The
chapter's economic point — that a unit whose economics are inseparable from its collateral terms
is a distinct unit, which images to `Trade` rather than to the product template — is defensible
as **economic individuation**. Framing it as CDM "identity" claims more than the CDM metamodel
states.

**Suggested wording.** Replace "collateral terms are part of identity in both models" with
"collateral terms individuate the economic object in both models — the ledger unit and the CDM
`Trade` — even though CDM's formal identity is carried by `TradeIdentifier`."

**Disposition: CLARIFY.**

---

## F5 — MINOR — Ch.9: "eligibility = declared data checked at the door" understates state-dependent eligibility

**The claim.** *"Eligibility and haircuts are declared data, checked at the door … and never
typed … a schedule in the agreement's terms."*

**Assessment.** The core claim is **defensible and legally coherent**: contractual eligibility is
exactly the CSA Paragraph 13 / GMRA-GMSLA eligible-collateral schedule (asset class, currency,
per-line valuation percentage), and "role a balance plays under an agreement, not a kind of
thing" is legally astute — the same ISIN is eligible under one CSA and not another; eligibility
is relational, not a property of the asset. It does **not** elide the in-scope legal test; it
faithfully renders it. Legal-agreement enforceability (title-transfer recharacterization,
perfection) and regulatory eligibility (UMR/LCR/CCP) are out of scope (E31, E53).

**The understatement.** CSA Paragraph 13 eligibility routinely includes **concentration limits**
(max % per issuer/sector/maturity bucket, wrong-way exclusions). Those are not a static per-line
property — eligibility of a posting can depend on the *already-posted portfolio*. The chapter
presents eligibility as a static per-line schedule; the "at the door, per posting" framing should
acknowledge the declared eligibility predicate may **read ledger state** (as the coverage check
already does), so concentration-type eligibility is representable without a code change.

**Suggested wording.** Add one clause: *"An eligibility term may be a predicate on ledger state
--- a concentration limit reads the already-posted portfolio --- checked at the same door and by
the same reading of the record as the coverage invariant; it remains declared data, not a type."*

**Disposition: CLARIFY (completeness note; not a defect).**

---

## F6 — ACCEPT-WITH-NOTE — Ch.11: "settlement failure is a recorded event, never a reversal" is accurate

**Assessment.** The claim is **accurate** and consistent with the CSDR settlement-discipline
regime: a fail does not rewind the booking; it is managed by recycling and daily cash penalties
(live since Feb 2022), with mandatory buy-in deferred/last-resort under the CSDR Refit and not in
force as of 2026. The chapter correctly keeps a *cancelled* trade as a compensating transaction
"through the same door, never by deleting the booking," so history is never rewritten (§2), and a
permanently-failed market claim defaults/compensates via its §14.1 deadline. The chapter also
correctly keeps the **market claim** (a CAJWG/T2S corporate-actions construct) separate from
**settlement discipline** (CSDR fails/penalties) — it does not conflate the two, and it does not
claim CSDR compliance.

**Note (no change required).** A fail also triggers CSDR cash penalties as further recorded
events; these are correctly out of scope (E73, SBL Operations Companion) and their omission is
not an over- or under-statement.

**Disposition: ACCEPT.**

---

## F7 — ACCEPT — regime coherence, IFRS hedging, and the verified CDM mappings

**Regime coherence (Ch.9).** Legally coherent and correct:
- **Title transfer** (GMRA repo, English-law CSA, GMSLA): full ownership passes to the taker; the
  poster holds a contractual claim-for-equivalent; on taker default it "decouples … to a recovery
  claim on the taker's estate" — precisely the unsecured close-out claim, correctly priced by
  counterparty state. Per-agreement (per-netting-set) claim units are the correct granularity —
  "close-out nets within a master agreement and never across masters" is accurate.
- **Pledge / security interest** (NY-law CSA no-right-of-use, segregated UMR IM): owned untouched
  — "the pledgor still owns" is the correct legal fact; determination reads owned, payment routes
  through the conditional obligation (Paragraph 6(d)(i): no default, no delivery amount) — a
  correct rendering of NY-CSA distribution trapping.
- **STM vs CTM** (cash margin table): STM → settlement, no return obligation; CTM/TT → financing,
  return obligation accruing the declared rate. This is the correct, capital/accounting-material
  distinction that drove the 2017 CCP CTM→STM flips. Excellent. Right-of-use cash → financing on
  exercise (= receipt into own accounts for commingled cash) is the correct NY-CSA rehypothecation
  treatment.

**IFRS/FINREP hedging (Ch.9, Ch.12).** The ledger deliberately decouples the internal `owned`
coordinate (re-booked to the taker — who can lawfully deal the asset) from the accounting balance
sheet (which under IFRS 9 §3.2.6 keeps the repo'd asset with the poster). It recovers the balance
sheet as a **projection** mapping "claim-for-equivalent-under-financing → transferred asset at
fair value." Critically, the chapters hedge this with **"complete within the ledger's fair-value
scope"** and defer to an **auditor sign-off as a Phase-4 gate**, and — unlike the ruling
workpaper — the *chapters* do not name FINREP F32.01 / IFRS 7 §42D outright or cite CSA paragraph
numbers in prose (only Ch.13's "CSA Paragraph 13", which is correct). This is appropriately
scoped and **not overstated**: FINREP encumbrance is a mixed-measurement supervisory return, so
"within fair-value scope" is the correct caveat for a fair-value-only book.

**CDM mappings verified (Ch.13).**
- `NonTransferableProduct` / `EconomicTerms` / `Payout` legs — correct types.
- Variance swap → `PerformancePayout` with `returnTerms`/`VarianceReturnTerms`; **each fixing →
  `Observation`; each accrual → `BusinessEvent` with `Reset` in `resetHistory`** — the
  fixing=Observation / reset=Reset mapping the challenge asked to verify is **correct** and
  carefully distinguished. (Minor: a daily variance accrual → `Reset` is a modeling assertion —
  CDM does not necessarily emit a Reset per variance observation — acceptable, could read "is
  modeled as".)
- TRS → `PerformancePayout` + `InterestRatePayout`; first reset → `BusinessEvent`/`Reset`;
  gross-legs-from-retained-business-event vs net-move-substance — correct and a genuine CDM point.
- **Gaps table** states gaps as gaps (SL recall, locate, re-use event, coordinated cascade) with
  the honest framing "None is a defect in the ledger; each is a place the industry model has not
  yet reached." No papering-over. No invented CDM types.
- **"Shown, not adopted"**: Ch.13 opening ("the CDM is exhibited *against* [the ledger's objects],
  never consulted as their source. The direction of authority … does not turn") and Ch.9
  eligibility ("derived independently … shown, not borrowed") **satisfy the constitution's
  one-way authority requirement**. No bare appeal to a standard as authority found in any of the
  six chapters.

**Disposition: ACCEPT.**

---

## Resolution confirmation (post-fix re-read, 2026-07-12)

All five findings dispositioned and applied; re-read of the revised drafts confirms:

- **L-1 (SIGNIFICANT) — RESOLVED.** Ch.11 §11.3 now keys the market claim on cum/ex. The
  Proposition takes "the trade's cum/ex status against the recorded ex-date" as an explicit
  input; a claim arises **iff** the trade is cum (executed before the ex-date) and unsettled at
  the record date; the **ex** case is worked explicitly ("owned read alone would misroute;
  entitlement keys on the ex-date, and the record-date contract stays silent — the registered
  holder keeps it"). Ch.8's ex-date operator and Ch.14's cum/ex witness are wired in. The worked
  example states the ex-date qualitatively relative to the frozen 2026-05-15 record date; frozen
  amounts (15,000 / 1,500,000 minor units) unchanged. CSDR clause preserved. Complete — this now
  discharges D2's old external "per the corporate-action standards" appeal with the ledger's own
  machinery.
- **L-2 (MEDIUM) — RESOLVED.** Ch.13 §"Closed enumerations" now states `Payout` components
  *compose* (`EconomicTerms.payout` cardinality `(1..*)`), not a closed choice; the generator
  universe rests on the genuinely closed enumerations (day-count, option type, primitive-
  instruction set) plus the ledger's own closed sets. Accurate for CDM 6.0.0; synced into Ch.15.
- **L-3 — RESOLVED.** `Trade.collateral` now typed `Collateral` carrying `CollateralProvisions`.
- **L-4 — RESOLVED.** Reframed as economic individuation; "identity is carried by
  `TradeIdentifier`, and collateral terms individuate the economics that identifier then names."
- **L-5 — RESOLVED.** Ch.9 adds that the declared eligibility predicate "may itself read recorded
  ledger state: a concentration limit makes eligibility portfolio-dependent … read at the door
  exactly as the coverage check reads state, and never typed."

**No new legal/regulatory must-fix introduced.** Two optional (non-blocking) hardening notes, both
consequences of a single non-standard edge — an *ex* trade that *settles before* the record date
(which a well-formed ex-date convention prevents, since the ex-date is set precisely so ex trades
settle after the record date; it arises only in fails / manual OTC bookings):
1. The Proposition lists cum/ex as an input to the whole determination, but the prose applies it
   only to the *market claim* and says "Determination reads owned" flatly for the base
   entitlement. For all cases that arise under a standard ex-date this is correct; the sole
   uncovered case (ex-settled-before-RD → a seller "reverse claim") cannot arise under a
   well-formed ex-date. Optional: make cum/ex an input to base determination too, so the edge is
   covered uniformly.
2. The retained "symmetric … reverse claim with signs reversed" sentence uses "reverse claim" for
   the buy-side perspective of the *cum* case; this lightly collides with the CAJWG/T2S technical
   term "reverse claim" (the ex-settled-before-RD case). Cosmetic; the chapter claims no CAJWG
   terminology and the ex case is now explicitly handled.

**Verdict: CONVERGED.**

## Cross-check against reviewer memory

The prior determination that booking received cash collateral on a generic `owned` balance
breaks SFTR reuse reporting (Table 4) is **addressed** by the ruling/chapters: the return
obligation is its own valued unit, and re-use figures are (a) per-(unit, agreement) *actuals* for
pledge form via source-agreement references, and (b) *attributions* for title-transfer
commingled fungibles via the declared totality convention — with the correct rationale
(single-sidedness of Table 4; SFTR 2.73 named as the genuinely reconciled two-sided surface).
Ch.12 gets this right and does **not** cite SFTR field numbers in prose (the ruling workpaper
cites "4.4–4.7"; the correct ITS numbering is 4.11–4.14 — a workpaper matter, not a chapter
defect, since the chapters stay generic). No new finding.
