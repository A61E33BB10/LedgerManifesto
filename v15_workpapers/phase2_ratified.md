# Phase 2 — RATIFIED (owner note of 2026-07-11)

Phase 2 is ratified with the dispositions below. **Standing delegation:** no further owner
gate; Phases 3 and 4 run to completion. Sole exception: genuine conflicts with
Constitution v1.1 are parked in Ch. 17's open-problems index with exact proposed
amendment text — never amended, never fudged. FORMALIS arbitrates internal disputes.
Definition of done (amended): finished v15 ≤ 100 pp compiled, conformance matrix total,
Exclusions Register complete, six threads unbroken, STYLUS + PROCRUSTES sign-offs,
Team B converged under PARETO, committed and pushed with the full committee record.

## Ratified budget ledger (PROCRUSTES)

| Ch. | Title | Author | Was | Now | Change |
|----:|-------|--------|----:|----:|--------|
| 1 | The Objective and the Commitments | KLEPPMANN | 4 | 4 | — |
| 2 | The Picture: Map, Then Fold | KLEPPMANN | 6 | 5 | recut −1 |
| 3 | The Objects (incl. **Term Sheets as Graphs**, Track A) | KLEPPMANN | 7 | 8.5 | +1.5 from reserve |
| 4 | The Machines | KLEPPMANN | 5 | 5 | — |
| 5 | Smart Contracts | KARPATHY | 6 | 5.5 | recut −0.5 |
| 6 | State: The Three Homes | KLEPPMANN | 5 | 5 | — |
| 7 | Valuation and PnL (incl. **dual valuation MtMk/MtMd**) | GATHERAL | 6 | 7 | +1 (G2) |
| 8 | Ingestion, Corporate Actions, Market Data Operator | NAZAROV | 6 | 8.5 | +2.5 (G1 +1.5, G3 +0.5, G5 +0.5) |
| 9 | Collateral, Margin, and Lending (incl. **lent-plane episode**) | MINSKY | 10 | 11 | +1 (G6) |
| 10 | Virtual Ledgers, Strategies, and the TRS | KARPATHY | 5 | 5 | — |
| 11 | The Settlement Interface | KLEPPMANN | 5 | 5 | — |
| 12 | Presentation and Reporting Projections | MINSKY | 4 | 4 | — |
| 13 | Alignment with the Common Domain Model | MATTHIAS | 3 | 3 | — |
| 14 | The Invariant Catalogue | NOETHER | 6 | 6 | — |
| 15 | Testability and the Executable-Check Regime | WILSON | 6 | 5.5 | recut −0.5 |
| 16 | Minimum Requirements | NAZAROV | 4 | 4 | — |
| 17 | Scope (incl. **open-problems index** + constitutional parking) | KLEPPMANN | 2 | 3 | +1 (G4) |
| | **Working budget** | | 90 | **95** | reserve **5**, hard cap **100** |

Release valve for Ch. 3 (standing instruction): if it breaches 8.5 pp, move one of its
four thread episodes to Ch. 6 — never draw the reserve; the graph section is not movable.

## Gap dispositions (G1–G6)

- **G1:** the four v14 mechanisms — adjustment-schedule totality, datum-kind registry +
  invariance witness, Recompose, aggregate weld — are **normative in Ch. 8**; spin-off
  and elective merger carried as compressed half-page worked examples; dividend-forecast
  and special-dividend worked examples deferred to the Worked-Examples Volume (register
  lines E71, E72).
- **G2:** dual valuation (MtMk/MtMd) carried, Ch. 7.
- **G3:** failure regimes W1–W4 carried normatively, Ch. 8.
- **G4:** open-problems index carried, Ch. 17 (with the constitutional parking rule).
- **G5:** cum/ex state-aware pricing carried, Ch. 8.
- **G6:** Ch. 9 grows only +1 pp: a half-page lent-plane episode (loan open → recall →
  return; manufactured payment via the determination/payment split). The full SBL
  operational lifecycle (locates, buy-ins, SFTR, CSDR) is a **named companion
  document** — the *SBL Operations Companion* (register line E73).

## Ch. 11 authorship

KLEPPMANN authors. MINSKY contributes the D2 settlement-state and market-claim passage
as a drafted insert; KLEPPMANN integrates for voice; FORMALIS verifies the seam against
the ratified ruling.

## Track A — Term Sheets as Graphs (ratified scope addition, Ch. 3, KLEPPMANN)

Normative content per the owner's note (source prompt retained in the committee record):

1. **The product graph.** Every unit's terms define a product graph: nodes = the unit's
   lifecycle states, closed and known at registration; each node carries a payload — the
   §7 sufficiency facts (the varswap's accrued fixings, the future's last settlement
   applied); each edge carries a guard (an event kind the Monitor can watch plus a
   predicate) and an action (the transaction template the traversal emits). Structure is
   declared data; the arithmetic inside an action is a small named, versioned pure
   function referenced from the edge.
2. **Identity with watches.** The watch list of a unit is exactly the out-edge set of
   its current node: declaring the graph declares the watches; arming is edge
   registration; firing is traversal; traversing an edge expires its siblings. The
   declared → armed → fired/expired lifecycle is a graph fact.
3. **Strongly typed states.** The node set being closed at registration, each state is
   a distinct type and each edge a function between those types (`touch : Fixing -> Live
   -> Triggered` the only constructor of a knocked note; `Triggered -> Live` a
   non-program; a case analysis that forgets a node does not compile). Illegal
   transitions unrepresentable; totality compiler-checked.
4. **The consistency invariant (normative).** For every unit there exists a product
   graph from which its watches, its state schema, and its contract's actions are all
   derivable, and their mutual consistency is property-tested: (i) watches ≡ out-edges
   of the current node at every commit; (ii) every fired event matches exactly one
   out-edge and lands on its target; (iii) every emitted transaction equals the edge's
   declared action applied to the recorded inputs; (iv) traversal expires exactly the
   declared siblings. Definition and invariant in Ch. 3; the four property statements
   join the test surface where NOETHER and WILSON judge best (Ch. 14/15).
5. GROTHENDIECK's single categorical second-telling for the graph (one object,
   interpreters as structure-preserving maps out of it) is admissible in Ch. 3 under the
   standing CT protocol.

**Track B** (generic interpreter prototype, CDM round-trip, term-sheet rendering) is NOT
in v15's scope or budget: after v15 delivery it becomes a standalone companion memo per
the retained prompt; any constitutional amendment it proposes routes through the Ch. 17
parking rule. No gate.

## Frozen thread timelines (CARTAN enforces; coupled threads may not fork numbers)

**The ACME calendar** (threads T3 dividend, T4 split — one issuer, one calendar):
- 2026-05-04: dividend announcement (1.50 per share, cash, ordinary).
- 2026-05-15: record date (W-ALPHA holds 10,000 ACME → entitlement 15,000.00 USD).
- 2026-05-22: payment date (15,000.00 USD paid).
- 2026-06-01: 2-for-1 split effective (10,000 → 20,000 shares; price frame 100.00 →
  50.00; declared per-share dividend figure 1.50 → 0.75 at the read seam).
- Constraint: announcement < record < payment < split, all dates fixed above.

**The IDX close series** (threads T1 future, T5 variance swap — one observation source):
- The recorded IDX official closes on the future's three settlement days are fixed:
  day 1 = 1,000.00; day 2 = 990.00; day 3 (final settlement) = 1,005.00.
- The variance swap's 252 scheduled fixings read the same recorded IDX official-close
  series; the three futures days above are fixings k, k+1, k+2 of that series (GATHERAL
  places k in Phase 3 and fixes the mid-life accrued statistic at fixing 126
  consistently with the frozen endpoint).
- Endpoint fixed: final realised variance 441 points; settlement 1,000 × (441 − 400) =
  41,000 USD to the realised-variance receiver.
- The future: FUT-IDX, multiplier 10, USD, STM; W-ALPHA buys 1 at 995 on day 0; VM
  +50, −100, +150; cumulative VM = 100 = PnL.

**All other thread parameters** as fixed in `phase2_toc_proposal.md` §3 (T2 one-touch
carries the ruling's micro-case (c) numbers verbatim; T6 TRS 10,000,000 notional, 4%
financing, first reset NAV 10,300,000 → net 200,000).

## Standing instructions

1. Commit the updated ToC and Exclusions Register first, then begin drafting.
2. Commit and push at every phase boundary and at final delivery.
3. Budget trades, episode placement, review dispositions, and reserve release are the
   committee's (PROCRUSTES ledgers, FORMALIS arbitrates).
