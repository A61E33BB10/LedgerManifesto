# v15.1 Discharge Matrix — Constitution v1.1 clauses × discharging chapters

This is the rating instrument that makes "the specification is rated against the Constitution"
falsifiable and mechanical (Finding F11 / PARK-1). Clause identifiers `C-<sec>.<n>` are defined
in `Ledger_Spec_v15.1/ledger/constitution_v1_2_proposed.tex` — a clause-level address on every
normative clause of Constitution v1.1, not one word of prose changed. The proposal is
authoritative for nothing; it is the addressing scheme only.

Rules, applied mechanically:
- A clause that no chapter substantively specifies is a **NAMED GAP** (reported, not invented away).
- A chapter is listed only where it *actually discharges* the clause. "Builds on / relies on" a
  clause discharged elsewhere is **not** a discharge and is not listed here (creating one would be
  a defect).
- A clause discharged by more than one chapter is fine and is noted (§C below).

Chapter file key: ch01 objective · ch02 picture · ch03 objects · ch04 machines · ch05 contracts ·
ch06 homes · ch07 valuation · ch08 marketdata · ch09 collateral · ch10 virtual · ch11 settlement ·
ch12 reporting · ch13 cdm · ch14 invariants · ch15 testability · ch16 requirements · ch17 scope.

---

## The matrix

| Clause | What it fixes (short) | Discharged by |
|---|---|---|
| C-1.1 | The objective: one system of record | ch01 |
| C-1.2 | Root cause: the same fact stored more than once | ch01 |
| C-1.3 | Two independent stores eventually disagree | ch01 |
| C-1.4 | Exactly one canonical record; all else a projection | ch01 |
| C-1.5 | Two projections of one record cannot disagree | ch01 |
| C-2.1 | Full auditability | ch01, ch12 |
| C-2.2 | Full reproducibility | ch01, ch12 |
| C-2.3 | Time travel embedded in the design | ch01 |
| C-2.4 | Correctness (illegal states unrepresentable; fail closed) | ch01 |
| C-2.5 | Testability (executable checks; construction principle) | ch01, ch15 |
| C-2.6 | Clarity (one name per component; behaviour as declared data) | ch01, ch13 |
| C-3.1 | Map, then fold | ch02 |
| C-3.2 | Gloss definitions: unit, wallet, transaction, projection | ch02 |
| C-3.3 | Units declare watches; Event Monitor emits | ch02 |
| C-3.4 | The map = smart contracts + Events Executor | ch02 |
| C-3.5 | The fold = Transaction Executor; every view a further fold | ch02 |
| C-3.6 | Data / functions / machines; one machine per arrow | ch02 |
| C-3.7 | The clock is the one off-record input; emission verifiable | ch02 |
| C-3.8 | Either arrow may refuse; a refusal is a returned value | ch02 |
| C-3.9 | Map and fold advance together in a single total order | ch02 |
| C-3.10 | Map proposed, fold authoritative; economic verification | ch02 |
| C-3.11 | Not event sourcing; replay never re-executes contracts | ch02 |
| C-4.1 | A ledger is units, wallets, balances, and the log | ch03 |
| C-4.2 | Unit definition; first-class, extensible, uniform | ch03 |
| C-4.3 | Valued vs non-valued units | ch03 |
| C-4.4 | Unit carries terms, state, contracts; watches; exhaustive | ch03 |
| C-4.5 | Wallet definition; manager and beneficial owner | ch03 |
| C-4.6 | The atomic move; exact minor units; remainder booked | ch03 |
| C-4.7 | The transaction: four kinds of change, all-or-nothing | ch03 |
| C-4.8 | The immutable log; log / ledger / record defined | ch03 |
| C-4.9 | Closure by virtual wallets; conservation by construction | ch03 |
| C-4.10 | The signed coordinate vector (owned, lent, posted) **[PARK-3/F10]** | ch03, ch09 |
| C-4.11 | Coordinate earns a coordinate; mass never value | ch03, ch09 |
| C-5.1 | Three machines; three roles, one writer | ch04 |
| C-5.2 | The Event Monitor; the recorded handshake | ch04 |
| C-5.3 | Unarmed watch is a visible gap; walkable chain | ch04 |
| C-5.4 | The Events Executor; output is only proposals | ch04 |
| C-5.5 | The Transaction Executor; the single door | ch04 |
| C-5.6 | Cause-derived identifier; commit once | ch04 |
| C-5.7 | Single-writer, monotonic; refuse non-commuting | ch04 |
| C-5.8 | Trust levels; integrity vs liveness | ch04 |
| C-6.1 | Instruments are active contracts; contract is the converter | ch05 |
| C-6.2 | Everything a contract consumes is on the record | ch05 |
| C-6.3 | A contract never waits and never remembers | ch05 |
| C-6.4 | Purity and statelessness | ch05 |
| C-6.5 | Every right and obligation is a unit | ch05, ch09, ch13 |
| C-6.6 | Managed-account fee accrual and NAV attribution consequences | ch17 Exclusions Register E75 (named out-of-scope companion) |
| C-7.1 | Lifecycle states; unit-alone vs joint facts | ch06 |
| C-7.2 | The three-home model | ch06 |
| C-7.3 | Homes derived from log, rebuildable; one legal writer | ch06 |
| C-7.4 | Sufficiency: homes carry all a contract needs | ch06 |
| C-7.5 | One event lands in exactly one home | ch06 |
| C-8.1 | NAV operational meaning | ch07 |
| C-8.2 | NAV formula; sum over valued units | ch07 |
| C-8.3 | Pricing parameterised by lifecycle state from the ledger | ch07 |
| C-8.4 | PnL is the variation in NAV; path-independent; no second copy | ch07 |
| C-8.5 | Deposits must not create profit; inflow is one of three | ch07 |
| C-8.6 | Inflow case 1: exchange / settled-to-market margin | ch07, ch09 |
| C-8.7 | Inflow case 2: title-transfer financing **[PARK-4/F12]** | ch07, ch09 |
| C-8.8 | Inflow case 3: custody / security interest without use | ch07, ch09 |
| C-8.9 | Case declared once on the agreement; deposit cannot move PnL | ch07, ch09 |
| C-9.1 | A corporate action is a transaction like any other | ch08 |
| C-9.2 | The market data operator; declared once, never improvised | ch08 |
| C-9.3 | Three operator principles (intrinsic, ledger-authority, originals) | ch08 |
| C-10.1 | Virtual ledger definition; far side of the settlement boundary | ch10 |
| C-10.2 | The strategy as a smart contract; level is a NAV projection | ch10 |
| C-10.3 | Two disciplines: bridge is an observation; wall level by level | ch10 |
| C-10.4 | Real execution: orders, benchmark, exact slippage | ch10 |
| C-10.5 | The total return swap definition | ch10 |
| C-11.1 | Classes of illegal state cannot be represented at all | ch14 |
| C-11.2 | Atomicity | ch14 |
| C-11.3 | Consistency of reference | ch14 |
| C-11.4 | Writer discipline | ch14 |
| C-11.5 | The catalogue; what cannot be represented cannot break | ch14 |
| C-12.1 | Historical state reconstructible by replay **[PARK-2/F2]** | ch14 |
| C-12.2 | Reads only committed transactions; independent of machinery | ch14 |
| C-12.3 | Smart contracts must be idempotent | ch14 |
| C-13.1 | Structural correctness (guaranteed by the door) | ch15 |
| C-13.2 | Economic correctness (checkable by recomputation) | ch15 |
| C-13.3 | The separation; prefer detectable, repairable error | ch15 |
| C-14.1 | Monitor/Executor outside trust boundary; minima follow | ch16 |
| C-14.2 | M1 Durable watches and timers | ch16 |
| C-14.3 | M2 At-least-once emission | ch16 |
| C-14.4 | M3 Acknowledged watches | ch16 |
| C-14.5 | M4 Triggers carry timing, not data | ch16 |
| C-14.6 | M5 Deterministic, replayable orchestration | ch16 |
| C-14.7 | M6 No write privilege | ch16 |
| C-14.8 | M7 Obligation liveness | ch16 |
| C-14.9 | V1 Ledger records pricing outputs, never runs a model | ch16 |
| C-14.10 | V2 Valuation state-dependent, state from the ledger | ch16 |
| C-14.11 | V3 Valuations reproducible from recorded inputs | ch16 |
| C-14.12 | V4 Prices and quantities never mixed across an event | ch16 |
| C-14.13 | B4 Originals preserved; adjusted/derived recomputed | ch16 |
| C-14.14 | V6 Estimates and entitlements kept apart | ch16 |
| C-14.15 | V1/provenance Model outputs re-enter only as observations | ch16 |
| C-Scope.1 | Scope framing: what the project encompasses | ch17 |
| C-Scope.2 | Closed move model, conservation, single-door admission | ch17 |
| C-Scope.3 | Immutable log and projection machinery | ch17 |
| C-Scope.4 | Three-home architecture; illegal states unrepresentable | ch17 |
| C-Scope.5 | Smart-contract framework; purity and idempotence | ch17 |
| C-Scope.6 | Market data operators and integration layer | ch17 |
| C-Scope.7 | Time-travel and historical-replay machinery | ch17 |
| C-Scope.8 | Formal invariant catalogue and property-based testing | ch17 |
| C-Scope.9 | The settlement-projection layer | ch11, ch17 |
| C-Scope.10 | The virtual-ledger mechanism | ch17 |
| C-Scope.11 | Explicit out-of-scope authorities | ch17 |
| C-Auth.1 | One-way authority | ch01, ch17 |
| C-Auth.2 | All specs assessed for conformance | ch17 |
| C-Auth.3 | Amend the manifesto first; reject untraceable choices | ch17 |
| C-Auth.4 | Fixed vocabulary; no synonyms | ch01, ch17 |

---

## Summary

### (a) Count of clauses

**110** normative clauses total, numbered in reading order within each section:

| Section | Clauses | Section | Clauses |
|---|---|---|---|
| §1 | C-1.1 … C-1.5 (5) | §9 | C-9.1 … C-9.3 (3) |
| §2 | C-2.1 … C-2.6 (6) | §10 | C-10.1 … C-10.5 (5) |
| §3 | C-3.1 … C-3.11 (11) | §11 | C-11.1 … C-11.5 (5) |
| §4 | C-4.1 … C-4.11 (11) | §12 | C-12.1 … C-12.3 (3) |
| §5 | C-5.1 … C-5.8 (8) | §13 | C-13.1 … C-13.3 (3) |
| §6 | C-6.1 … C-6.6 (6) | §14 | C-14.1 … C-14.15 (15) |
| §7 | C-7.1 … C-7.5 (5) | Scope | C-Scope.1 … C-Scope.11 (11) |
| §8 | C-8.1 … C-8.9 (9) | Authority | C-Auth.1 … C-Auth.4 (4) |

Of the 110, **109 are discharged** by at least one chapter; **C-6.6 is resolved as a named out-of-scope
companion** (Exclusions Register E75) rather than an undischarged gap. **No NAMED GAP remains.**

### (b) Former named gap — C-6.6, now resolved (OBL-B, Phase 4)

- **C-6.6 — managed-account fee accrual and NAV attribution.** Constitution §6 states that treating
  the client's redemption claim as a valued unit "has direct consequences for fee accrual and NAV
  attribution in managed accounts; these consequences are resolved in the detailed specification
  consistently with the principles stated here." No v15.1 chapter works these consequences in-body.
  **Resolution (CONCORDIA ruling, OBL-B):** relocated from the §17.3 open-problems index to a NAMED
  Exclusions-Register companion — **E75, the Managed-Account Companion** (ch17 §17.2) — alongside
  E71–E74. Its absence from this specification is therefore a deliberate, auditable scoping decision
  that points to where the consequences are worked, not a silent undischarged clause. CONCORDIA
  permitted "work it OR relocate to a named companion"; the relocate option is taken. To be
  re-confirmed at the Phase-4 CONCORDIA gate.

No other clause is undischarged. In particular, the close-out/netting algebra and the
correction-algebra items named in ch17 §17.3 are open *design questions within* discharged clauses
(they refine C-6.5 and C-2.1/C-8.4), not undischarged Constitution clauses, so they are not matrix
gaps.

### (c) Clauses discharged by more than one chapter (all legitimate; noted)

| Clause | Chapters | Why more than one genuinely discharges it |
|---|---|---|
| C-2.1 | ch01, ch12 | Auditability stated (ch01) and made an executable reporting gate (ch12) |
| C-2.2 | ch01, ch12 | Reproducibility stated (ch01) and an executable reporting gate (ch12) |
| C-2.5 | ch01, ch15 | Testability commitment (ch01); the executable-check regime (ch15) |
| C-2.6 | ch01, ch13 | Clarity/declared-data (ch01); CDM restated as declared data (ch13) |
| C-4.10 | ch03, ch09 | Coordinate vector defined (ch03); operationalised as the regime key (ch09) |
| C-4.11 | ch03, ch09 | Mass-never-value defined (ch03); enforced across regimes (ch09) |
| C-6.5 | ch05, ch09, ch13 | Every-right-a-unit stated (ch05); agreement units (ch09); CDM demo (ch13) |
| C-8.6 | ch07, ch09 | Valuation consequence (ch07); the settled-to-market regime (ch09) |
| C-8.7 | ch07, ch09 | Prop. 7.3 (ch07); title-transfer financing machinery (ch09) |
| C-8.8 | ch07, ch09 | Valuation consequence (ch07); the custody regime (ch09) |
| C-8.9 | ch07, ch09 | Deposit-neutrality (ch07); regime declared on the agreement (ch09) |
| C-Scope.9 | ch11, ch17 | Settlement layer specified (ch11); declared in-scope (ch17) |
| C-Auth.1 | ch01, ch17 | One-way authority opened (ch01) and stated as Authority (ch17) |
| C-Auth.4 | ch01, ch17 | Vocabulary fixed by Clarity (ch01) and by Authority (ch17) |

No chapter cites a clause it does not discharge (no DEFECT introduced). Every chapter opener's
clause-ID list is exactly this matrix, read by chapter.

---

## Note (F7) — Constitution §5's one-sentence treatment of identifiers

Finding F7 (MAJOR; certifiers CONCORDIA, MATTHIAS-β/G9, TALEB/G4) exposed a latent
inconsistency between event-level idempotence (§4.3 as originally drafted: "a retried,
duplicated, or late proposal for an already-processed EVENT is committed exactly once") and
the coordinated cascade of §13.5 (one cause, MANY units, MANY transactions). Keyed on the
cause/event, idempotence would suppress the legitimate second-through-nth legs of one cascade;
keyed on the transaction identifier, it collapses retries while admitting every distinct leg.

**Root cause, for the record:** Constitution §5 treats the cause-derived identifier in a single
sentence and does not fix its derivation. That one-sentence treatment is what let the ambiguity
through review — the spec inherited "derived from its cause" without a stated tuple, so nothing
forced the drafters to notice that "cause" and "transaction" are different grains. The repair
states the derivation rule **once, normatively, in Chapter 4**:
`txid = H(causeEventId, contractId, unitId, seq)`, with H assumed collision-resistant (injective
on the well-formed-tuple domain), and proves both required properties — *constant under retry*
(identical tuple ⇒ identical txid) and *injective over a cascade* (fixed cause, distinct
(contractId, unitId, seq) ⇒ distinct txids ⇒ all n commit). Ch. 13 §13.5, Ch. 14 (idempotence
bullet), and Ch. 15 (`prop_cascadeIdempotence`) now reference this single rule; Ch. 6's PosFacts
key (`Map Txid PosFact`, F6) is the same identifier and stays consistent.

**This is a NOTE, not a park and not a constitutional edit.** §5's one-sentence treatment is not a
genuine conflict requiring amendment: the constitution says the identifier is cause-derived, and
the Chapter 4 rule *is* cause-derived (causeEventId is the first component). The spec sharpens an
under-specified guarantee within the constitution's own words; it neither narrows nor amends §5.
Recorded here so the discharge of C-5.x carries the reason the ambiguity was possible and the
evidence it is closed.

---

## Note (F13) — the "admission door" overreach in the not-event-sourcing argument

Finding F13 (MAJOR; certifier CONCORDIA) identified a false clause in §2.8's
not-event-sourcing argument. The draft claimed the Transaction Executor is "an admission door
event sourcing has no equivalent of." It is not without equivalent: event sourcing has the
command handler / aggregate invariant check, which admits or rejects a command before it
becomes an event. An experienced reader stops at that sentence and discounts the whole
section. The genuinely distinguishing claims are the two now leading §2.8: (1) a single total
order, not per-aggregate streams stitched back together; (2) replay re-reads transactions and
never re-executes contracts. The false clause was dropped and the section re-led with the two
strong claims — losing a false argument makes the section more persuasive, not less.

**The same overreach sits in Constitution §3's prose.** This is recorded here as a NOTE only.
The Constitution is authoritative and is rated against nothing; no agent may edit it, and this
is neither a park nor a proposed amendment. The overreach in §3 is a rhetorical flourish, not a
normative guarantee — C-3.11 ("not event sourcing; replay never re-executes contracts") stands
on the two genuine claims, both of which the spec discharges. The point of the note is simply
that the spec (§2.8) no longer echoes the overreach; the Constitution's own wording is left
exactly as the owner wrote it.
