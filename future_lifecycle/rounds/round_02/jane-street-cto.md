# jane-street-cto — FutureLifeCycle, Round 2

Lens: clear in six months to someone new; the settlement answer unambiguous, not evasive;
artifacts consistent.

Verdict: **CORRECT-AND-COMPLETE**

## What I checked

I re-derived the entire worked example from scratch (independent script, not reading the
table) and confirmed every cell of the life table and both closing identities:

- T1 net (10,-10,0), ac (-50000,+50000,0)
- Settle d1 @102: VM (+1000,-1000,0), ac (-51000,+51000,0)
- T2 net (6,-10,4), ac (-30400,+51000,-20600)
- Settle d2 @101: VM (-100,+500,-400), ac (-30300,+50500,-20200)
- T3 net (6,-6,0), ac (-30300,+30300,0)
- Expiry @105: VM (+1200,-1200,0), ac (-31500,+31500,0)
- Close net (0,0,0), ac (0,0,0)
- Cumulative VM: A +2100, B -1700, C -400, sum 0 — equal to economic P&L computed
  independently (A +2100, B -1700, C -400).

Every figure matches the `.tex` table and the prose to the cent.

## Conservation shown at every event

Confirmed the three sums are present and zero at each event:

- Listing: vacuous, empty sum = 0 (C9) — stated.
- T1: ΣΔnet=0, ΣΔac=0, ΣVM=0 — stated.
- Settle d1: all three — stated.
- T2: ΣΔnet=0, ΣΔac=0 — stated (a trade emits no cash leg, so there is no VM sum to show).
- Settle d2 (anchor): ΣΔnet=0, ΣΔac=0, ΣVM=0 — stated.
- T3: ΣΔnet=0, ΣΔac=0 — stated.
- Expiry: ΣΔnet=0, ΣΔac=0, ΣVM=0 — stated.
- Close: ΣΔnet=0, ΣΔac=0, ΣVM=0 (no cash) — stated.

The algebraic backing in `settlement_answer.md` (ΣΔac = −S·m·Σnet − Σac = 0+0 = 0, hence
ΣVM = −ΣΔac = 0) is correct and ties VM zero-sum to ac conservation as one fact, not a
separate reconciliation. This is the right structural claim.

## The three anchor sub-questions — answered without evasion

1. *Is settlement a state update; which parts shared, which per-wallet?* — Yes; shared price
   write on `UnitStatus`, per-holder fan-out (ac reset + cash leg) on `PositionState`. The
   coarse-rank-vs-embedded-mark distinction is made explicitly, which is exactly the place a
   reader would otherwise trip. Unambiguous.
2. *One atomic fan-out event, or a derived consequence of the price?* — One atomic event that
   fans out. The answer is committed and defended: the cash leg is per-wallet real money and
   cannot be lazy, so the per-holder pass is forced; the ac reset rides the same delta under
   the single-writer discipline. The "derived consequence" alternative is named and declined
   (E2), not dodged.
3. *Price only in shared state, consequence only in per-wallet state?* — Yes, and stated
   crisply.

The load-bearing subtlety — A's day-2 VM is −100, not the naive price-derived −300 — is the
strongest part of both documents. It is the concrete proof that per-wallet stored `ac` is
necessary, and it is identical in the `.tex` (§anchor) and `settlement_answer.md`. A new reader
at 3am gets the "why" immediately.

## Artifact consistency

`FutureLifeCycle.tex` and `settlement_answer.md` agree on the model, the formulas, the worked
figures, the stage algebra, and both escalations (E1 fan-out cost, E2 declined alternative).
The three "answers stated plainly" in the `.tex` are the same three sub-question answers in the
`.md`. No contradiction found.

## Non-blocking observations (do not affirm as gaps; recorded for the owner)

- `settlement_answer.md` cites `C12` ("per-wallet economic state lives in PositionState"); the
  `.tex` invariants section cites C1, C2, C9, C10, C11 but never C12. If C12 exists in the
  addendum this is harmless; if not, one of the two artifacts has a stray reference. Worth a
  one-line cross-check against the addendum. Not load-bearing for any claim above.
- Close row prose says "units returned to CH" while listing Δnet(CH)=0. This is internally
  consistent — A's +6 and B's −6 cancel and CH is a balanced pass-through, so its net never
  moves — but the phrase "returned to CH" alongside Δnet(CH)=0 could momentarily read as a
  contradiction to someone new. The trades are modelled bilaterally (A buys from B), so CH is a
  VM hub with a permanently flat book rather than a true novating central counterparty; the
  documents are honest that CH's leg is the residual zero. Optional: one clause clarifying CH is
  a balanced pass-through at Close would remove the only line a fresh reader might re-read.

Neither observation blocks. The settlement answer is unambiguous, conservation is shown at
every event, and the two artifacts are consistent.
