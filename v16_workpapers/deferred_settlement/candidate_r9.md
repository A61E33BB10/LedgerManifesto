# Deferred Settlement, v16-Native — Round 9 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r8.md`. **Round-9 tally:** 4 APPROVE (jane-street, rosetta,
minsky — their first of the process, after red-teaming the minting rule across all four
per-coordinate direction combinations including the unworked fourth — and sbl), 3 BREAK,
**every one a statement-level fix**: one paragraph (R9-B1), one line (R9-B2), one
sentence (R9-B3). No mechanism is contested by any reviewer. All three are adopted
verbatim, the three .tex carries are folded in, **nothing else is changed, and every
worked number of Round 8 is kept intact.** Round 10 is the cap. Every item answered in
§9. **Status:** Round 9 candidate. Not the final .tex. Not committed.

---

## 1. The problem (settled since Round 2; held)

Buy 100 XYZ at $50.00 Monday, T+2; Tuesday's $52.00 close makes +$200.00 real before
any custody movement. The bound between the internal record and the external
assertions — the binary reconciliation invariant, everything crossing the one door —
is this candidate. v16.0 carries everything else.

## 2. Classification (delta from Round 8 only — three statements typed correctly)

- **Trust-typing closes its last gap.** The cut-off declared term compared an attested
  operand against an untyped trust: the Spine gives replay determinism, not
  correctness — it faithfully replays a *wrong* cut-off. The term's faithfulness is
  now cited to TA-TERMS with an owner and a distinct detection signal (R9-B1).
- **An endpoint set is an enumeration; enumerations must be complete.** SEFP's right
  endpoint gains cancellation — which the design's own cancel-and-re-instruct
  produces routinely (R9-B2).
- **A rule stated stronger than meant is a rule that refuses certified machinery.**
  The minting rule was written as a bijection and would have refused E4's partial
  split, whose root-reference inheritance is load-bearing for the penalty fold. It is
  a function (R9-B3).

## 3. The design

**Thesis (held).** Three cross-cutting rules: the Spine pins the read; the Binding
pins the write; Terminality pins the race.

### 3.0a The Spine (held)

All identity inputs fold in force at the statement's valid-time; declared data
forward-only; revocations carry t_c.

### 3.0b The Binding (held; minting rule restated as a function — R9-B3; netting mode
a declared term — carry 2)

Held in full: one restated parameter set; per-coordinate case-split; settled mass
netted per coordinate at amounts actually moved; forward-forward → one DvP unit;
return-return → one reverse-DvP unit; mixed → two units. Two statements corrected or
added:

- **The minting rule is a function, not a bijection (R9-B3, one sentence).** Each
  unit's legs belong to exactly **one** CSD instruction — unit → one root
  reference — and a reference carries multiple units **only via the certified
  partial split** (E4), whose legs inherit the parent's reference, the inheritance
  the penalty fold's fragment-tree grouping depends on (DS14). R8-B1's mixed-case
  argument survives verbatim — legs spanning two instructions still mint two
  units — only the injective half ("one reference = one unit") was wrong: enforced
  literally, the door would have refused the certified split held this same round.
- **The netting mode of the mixed case is a declared term (carry 2).** The FoP +
  cash-return decomposition presumes **settlement netting** (the ISLA Clause Library
  outcome); a counterparty settling **gross** re-forms the same correction as a
  DvP-70 plus a cash compensation obligation — both shapes conserve identically
  (same legs' totals, same Δpredicted = 0), and which one is minted rides the
  agreement's declared netting term, not a universal assumption. A gross-settling
  counterparty against a netted assumption mis-matches at the CSD; the term is read
  where every other agreement term is read.

### 3.0c Terminality (held; race-freedom affirmed in Round 8, four-quadrant totality
red-teamed by minsky in Round 9 — holds)

Settled mass is terminal, coordinate by coordinate.

### 3.1 Existing v16 mechanisms (held; E1–E9)

E1 trade-date booking · E2 the settlement-obligation unit · E3 moveless discharge ·
E4 the partial edge (root-reference inheritance now explicitly load-bearing, §3.0b) ·
E5 market claims · E6 registry/quarantine/capture · E7 the due-date watch · E8
bitemporal doctrine · E9 witness-before-signal.

### 3.2 The mechanisms (deltas; N5 touched by all three fixes; N1–N4, N6, N7 held)

**N5 — The penalty regime (three statement fixes; all Round-8 numbers intact).**

- *The cut-off's faithfulness is TA-TERMS's (R9-B1, the candidate's own precedent).*
  The LMFP/SEFP boundary — and **which party bears the flipped day** — compares the
  CSD's attested matching timestamp against **our declared** cut-off. The
  declaration's faithfulness to the venue's actual convention is a trust assumption,
  and it is now typed: **TA-TERMS** — a declared term faithfully renders the venue's
  convention — **owner: calendar/venue governance**; **detection: a boundary-day
  advice whose implied cut-off contradicts our declared value is a distinct named
  signal** — "declared-cut-off contradiction", pointing at the term — never buried
  as a generic mischarge BREAK; **replay rides the Spine as-is** (the Spine
  guarantees the same wrong answer everywhere until the term is repaired
  forward — determinism, not correctness, which is exactly why the faithfulness
  needs its own named type). The reviewer's numbers, carried: real cut-off 16:00,
  stale declared 15:00, matched Friday 15:30 ⇒ we expect LMFP $15,600.00 against a
  correct $10,400.00 advice — a BREAK on a correct advice, plus the flipped
  $5,200.00 silently mis-attributed between us and the counterparty. The named
  signal turns that day into a term-repair, not a dispute with a correct CSD.
- *SEFP's right-endpoint set gains cancellation (R9-B2, one line; data already
  recorded).* SEFP accrues over **[max(ISD, matching), min(settlement, buy-in,
  cancellation))**, all exclusive; the old root reference's window **closes at its
  recorded cancellation**, and the successor accrues from **its own ISD**. The
  reviewer's numbers, carried: REF-001 fails Wednesday and Thursday, cancelled
  Friday under our own cancel-and-re-instruct ⇒ correct advice caps REF-001's SEFP
  at 2 × $5,200.00 = **$10,400.00**; the Round-8 fold would have accrued
  $5,200.00/day past Friday and BREAK-ed a correct advice on every
  amended-while-failing trade. The cancellation is already on the log (fold row
  14); the fix is the enumeration, not a new fact.
- *The reference price is the per-business-day close; the period net keys per
  currency (carry 1).* Check 2 compares each accrual day's advice line against
  **that business day's** recorded SECR-designated-source close — prices move
  across a multi-day fail, and a single-day close would false-BREAK a correct
  multi-day advice. Row 16's net keys per **(participant, currency, period)**: a
  multi-currency month mints one penalty settlement-obligation unit per currency,
  each discharged by its own collection.

**N1 (held; carry 3 reaffirmed).** The matching timestamp remains CSD-asserted,
single-source, honestly inside the named TA-CUSTODY residual — as stated in Round 8,
kept through the .tex.

### 3.3 DvP atomicity (held, affirmed eight rounds running)

Ledger-level paired-leg atomicity at the door; external-CSD atomicity reconciled,
never enforced.

## 4. The fold (rows 4, 12, 15, 16 carry the three statement fixes; all else held)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | Binding-derived paired re-book + unit at `instructed`; atomic-finality venue: born `settled`, no timer. |
| 2 | Price close | Recorded observation (per business day — the penalty check's daily comparand); valuation/PnL are further folds. |
| 3 | Settlement confirmation | Moveless walk to `settled`; racing a pending cancel: settlement wins. |
| 4 | Repair event (intent on the kind) | live(ref) picks the mechanism; per-coordinate case-split; legs partition into units by external instruction — **unit → one root reference (a function; a reference carries multiple units only via the certified partial split)**; mixed-case decomposition per the declared netting term (netted: FoP + cash return; gross: DvP + compensation — both conserve). |
| 5 | Partial confirmation, clip q | Recorded always; ≥ floor: split (root reference **inherited** — load-bearing for the penalty fold); below: aggregates on the one live residual. |
| 6 | Fail notice / due-date watch | Walk to `failed` on the remainder; fails cascade. |
| 7 | Custody statement | Identity under the Spine; classification at read; LEAD-LAG lines carry M7 status. |
| 8 | Recall / return; terminal return failure | Paired lent-coordinate move + possession leg; terminal: §9 close-out, owned paired w_L → w_B, CLM-CO (income leg routed), collateral applied. |
| 9 | Scheduled-statement watch (calendar-aware) | Overdue open item. |
| 10 | Buy-in delivery confirmation | Discharges the failed residual; buy-in date an exclusive SEFP endpoint. |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror; claim units outside the identity's range. |
| 12 | Registry / tolerance / key amendment | Forward-only, valid-timed; revocations carry t_c; the venue calendar + settlement cut-off ride the declared terms, **faithfulness typed TA-TERMS with the declared-cut-off contradiction as its named detection signal**. |
| 13 | Restated statement / finality | Tip-only supersession; identity nets the tip. |
| 14 | Emission receipts (intent → send → receipt/ack; match confirmation + timestamp; cancellation confirmation) | Intent keys live(ref); receipt/ack is check (b)'s witness by matched reference; **the recorded cancellation is now also an SEFP right endpoint**. |
| 15 | CSD penalty advice (semt.044) | Decidable checks over the partitioned windows; two-case cut-off boundary; **SEFP over [max(ISD, matching), min(settlement, buy-in, cancellation)), ISD inclusive, all right endpoints exclusive**; reference price = that business day's SECR-designated-source close; CLEAN / BREAK only. |
| 16 | Penalty reconciliation complete for a period | Binding-derived booking of the net **per (participant, currency, period)** — one penalty unit per currency — discharged by each collection's camt.054. |

## 5. Temporal mapping (delta from Round 8: none)

Held in full. All three fixes are statements over recorded facts — a trust-type
citation, an enumeration member, a rule's quantifier — none touches orchestration.

## 6. The running example (all Round-8 numbers intact; one block added)

Core, fail/buy-in/cash-in-lieu, partial with sub-floor aggregation, amendment
REF-001→REF-002, quantity-and-price composition, the bust, the two-unit mixed case
with its delivery-first sequence, the two-case penalty boundary (before cut-off
$10,400.00 + $5,200.00; after cut-off $15,600.00 + $0.00; same total, the flipped
Friday moving between parties), the penalty cash cycle at $26,000.00, A′, A″
both-sided, CA-on-in-flight: **all held, unchanged.**

**Added block — cancellation caps the window (R9-B2).** The amendment example's own
timeline: REF-001 instructed with ISD Wednesday, matched timely, fails Wednesday and
Thursday at end-of-day, and is **cancelled Friday** by our cancel-and-re-instruct
(successor REF-002, its own ISD). REF-001's SEFP window: [ISD Wednesday,
min(settlement = none, buy-in = none, cancellation = Friday)) = Wednesday + Thursday
= 2 × $5,200.00 = **$10,400.00**, capped by the recorded cancellation; REF-002
accrues, if it fails, from its own ISD onward. The correct advice says exactly this;
the Round-8 fold would have kept accruing past Friday and BREAK-ed it. One
enumeration member; the data was on the log all along.

## 7. DS1–DS19 disposition (Round-9 deltas; counts unchanged: 18 satisfied-or-closed · 1 routed · 0 rejected)

Held: all rows as in Round 8, with two annotations.

| DS | Round-9 delta |
|----|---------------|
| DS14 | **Endpoint set complete and trust-typed.** The SEFP right-endpoint enumeration gains cancellation (its absence BREAK-ed correct advices on every amended-while-failing trade); the boundary's declared cut-off is TA-TERMS-typed with its own named detection signal; the daily reference price is the per-business-day designated-source close; the period net keys per currency. |
| DS3/DS11a | **Consistency note:** the minting rule as a function keeps the certified partial split admissible (root-reference inheritance intact), so DS11a's per-step conservation and DS14's fragment-tree grouping coexist — the bijection reading would have set them against each other. |

## 8. Boundary notes (deltas)

**TA-TERMS (R9-B1).** The venue calendar and settlement cut-off are declared terms
whose faithfulness to the venue's actual convention is typed to TA-TERMS — the
candidate's own precedent (the atomic-finality declaration, Round 4). Owner:
calendar/venue governance. Detection: the **declared-cut-off contradiction signal** —
a boundary-day advice whose implied cut-off contradicts our declared value routes to
term-repair, never to a generic mischarge BREAK against a correct CSD. Replay rides
the Spine as-is: determinism was never the gap; unverified faithfulness was.

**TA-CUSTODY (held; carry 3).** The matching timestamp stays CSD-asserted,
single-source, inside the named residual — Round 8's statement, reaffirmed for the
.tex.

**Declared terms (extended).** The venue/calendar surface now carries: business-day
calendar, holidays, settlement cut-off (TA-TERMS-typed), and the agreement surface
carries the **netting mode** of correction decompositions (carry 2). Both are read,
never assumed.

**CDM (held).** Six nothing-rows, two corrections, two-axis repair vocabulary;
nothing this round adds a row (the function-form minting rule and the gross-form
correction are settlement-layer statements).

## 9. Responses on the record (every Round-9 item)

- **R9-B1 — ADOPTED verbatim (§3.2 N5; §8; fold row 12):** cut-off faithfulness
  cited to TA-TERMS; owner = calendar/venue governance; detection = the
  declared-cut-off contradiction as a distinct named signal; replay rides the Spine;
  the 16:00/15:00/15:30 mis-attribution scenario carried as the motivating numbers.
- **R9-B2 — ADOPTED verbatim (§3.2 N5; fold rows 14–15; §6 added block):** SEFP over
  [max(ISD, matching), min(settlement, buy-in, cancellation)), exclusive; the old
  reference closes at its recorded cancellation; the successor accrues from its own
  ISD; REF-001's cap at $10,400.00 worked in print.
- **R9-B3 — ADOPTED verbatim (§3.0b; fold rows 4–5):** the minting rule is a
  function — unit → one root reference — never a bijection; a reference carries
  multiple units only via the certified partial split, whose inheritance is
  load-bearing for DS14; R8-B1's two-unit argument survives verbatim; the door
  refuses nothing certified.
- **Carry 1 — ADOPTED (§3.2 N5; fold rows 2, 15, 16):** per-business-day
  designated-source close as check 2's daily comparand; row-16 net per
  (participant, currency, period), one penalty unit per currency.
- **Carry 2 — ADOPTED (§3.0b; fold row 4):** the netting mode is a declared term;
  netted and gross forms of the mixed-case correction both conserve identically;
  neither is assumed.
- **Carry 3 — REAFFIRMED (§3.2 N1; §8):** the matching timestamp stays honestly in
  the named TA-CUSTODY residual through the .tex.
- **Affirmations carried:** minsky's first APPROVE (four-quadrant totality of the
  per-coordinate split, including the unworked fourth combination, red-teamed and
  holding); jane-street's "cleanest the candidate has been."
- **CONTESTED: none.** Nothing else was changed; every Round-8 worked number stands
  untouched, per the cap-round instruction.

## 10. Residuals for Round 10 (the cap) / the .tex

1. DS10 / Herstatt with the NS-02 currency workstream; the CLM-CO income leg to the
   billing/income workstream (both routing patterns held).
2. Executable-property additions this round: the declared-cut-off contradiction
   signal fires on generated boundary-day advices against a mutated declared
   cut-off; the cancellation-capped SEFP window (the uncapped mutant BREAKs a
   correct advice and must fire); the function-form minting rule (the certified
   split remains constructible; a spanning-legs unit does not; the bijection mutant
   refuses the split and must fire); gross-mode corrections conserve identically to
   netted-mode over generated agreements. Zero firings is a defect.
3. The parked ch16 four→five spec-pass edit rides with the .tex (TA-CUSTODY text
   final; TA-TERMS citation for the cut-off included).
4. Temporal conformance: held set, unchanged.

