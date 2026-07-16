# chris-lattner — FutureLifeCycle, Round 2

Lens: the lifecycle reads as one clean progression; nothing present that does not
serve it; artifacts agree.

## Verdict: NOT-YET

One located, one-line gap stands between this and CORRECT-AND-COMPLETE. The
substance is sound; the defect is an internal self-contradiction the document's own
rigor standard forbids.

## What I verified (all pass)

I recomputed the entire worked example independently (net_qty, accumulated_cost,
per-step VM, cumulative VM, economic P&L) and matched every cell of the §2 table:

- T1 `net=(10,-10,0) ac=(-50000,+50000,0)`; d1 `VM=(+1000,-1000) ac=(-51000,+51000)`;
  T2 `ac=(-30400,+51000,-20600)`; d2 `VM=(-100,+500,-400) ac=(-30300,+50500,-20200)`;
  T3 `ac=(-30300,+30300,0)`; expiry `VM=(+1200,-1200) ac=(-31500,+31500,0)`;
  close `net=ac=(0,0,0)`.
- Conservation: at every event Σ net_qty = 0 and Σ ac = 0; Σ VM = 0 at all three
  settlements and at close.
- The anchor is correct and load-bearing: A's day-2 VM is −100, not the naive
  `6·(101−102)·50 = −300`; the +200 from selling 4 @103 one point above the prior
  mark is exactly what stored per-wallet `ac` absorbs. This is the right reason `ac`
  is `PositionState`, not a price-derived consequence.
- Closing identity ties: cumulative VM = economic P&L per wallet
  (A +2100, B −1700, C −400, CH 0, Σ 0).

**Three anchor sub-questions — answered without evasion.** §"anchor" (3 enumerated
answers) and `settlement_answer.md` (sub-questions 1–3) agree and are crisp:
(1) state update split by layer — shared price write on `UnitStatus`, per-holder
fan-out on `PositionState`, one atomic `StateDelta`; (2) one atomic event that fans
out, forced by the per-holder cash leg, not a derived consequence; (3) price only
shared, consequence only per-wallet. No hedging.

**Architecture I want to acknowledge.** The identity `VM(w) = −Δac(w)` collapsing
VM zero-sum and `ac` conservation into the *same* fact is the right kind of design —
one invariant doing two jobs, not two reconciliations. The fused
`Stage = Registered | Active (Maybe Settlement) | Expired Settlement` making the two
unreachable status states unspellable is exactly "illegal states not representable."
The Close-as-flattening-trade-at-the-final-mark (Δac = −(−6)·105·50 = +31500, zero
cash because a trade pays no notional, zero VM because it settles at its own mark)
is consistent and admissible-post-EXPIRED precisely because it carries no stage
write. Clean. The artifacts agree on all overlapping content (settlement mechanism,
conservation derivation, E1/E2, stage naming).

## The gap

**Location:** §2 promise vs §"A subsequent, intraday trade (day 2)" (T2) and
§"Closing a position to flat" (T3).

§2 states, as a universal claim over the whole walk:

> "Each event is one `StateDelta`; each shows the three conservation sums
> Σ Δnet_qty, Σ Δac, Σ VM."

T1 honors this for a no-cash trade — it writes `Σ VM = 0`. T2 and T3 are the same
kind of event (a trade, cash leg "None") but show only two of the three:

- T2: "Conservation: Σ Δnet_qty = +4−4 = 0, Σ Δac = −20600+20600 = 0." — Σ VM absent.
- T3: "Conservation: Σ Δnet_qty = 0, Σ Δac = 0." — Σ VM absent.

So the document presents the identical event class two ways and breaks a universal
claim it made one screen earlier. In a spec whose first principle is "a claim is
proved, not asserted" and whose clarity rule is "each statement stated once," an
unhonored universal claim is a real defect, not a cosmetic one — it is the
"artifacts agree with themselves" property failing inside a single artifact.

**Actionable fix (one line each, choose one direction):**
- Add `Σ VM = 0 (no cash leg)` to the conservation line of T2 and T3, matching T1; or
- Soften the §2 sentence to "each settlement shows three sums; each trade shows
  Σ Δnet_qty and Σ Δac, its cash-leg map being empty," so the claim matches what
  the walk delivers.

Either restores the one-clean-progression property: every event presented
uniformly, no broken promise.

## Non-blocking observation (not a gap)

The CH wallet is named as CCP but trades are modeled holder-to-holder with the CH
leg as a residual that is zero. This preserves conservation and is stated explicitly
("the clearinghouse leg is the residual ... no CH row materialises"), so it is a
consistent simplification, not an inconsistency. No action required; recording it so
a later reviewer does not re-litigate it as novation-vs-bilateral.
