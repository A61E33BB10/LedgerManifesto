# karpathy — States.tex, Round 17

**Verdict: NOT-YET.**

## What is obviously right

I read `States.tex` line by line and checked it against `States.hs`. The listings
faithfully reproduce the declarations, and the engineering core is genuinely
single-pass-convincing — it is built one forced piece at a time, exactly as a teaching
file should be:

- **`Qty` as a group → conservation.** `applyMove` is the only writer of `psBal`, and it
  lays down `negQty q` and `q` from one quantity, so each move changes the holding sum by
  `negQty q <> q = mempty`. `register`/`settle` never touch `psBal`. Base case
  `emptyLedger` sums to zero; the sealed constructor leaves no other door. The induction
  closes. (§Why It Is Right, lines 336–350.) I verified `netDeltas`/`writeNet` by hand for
  the distinct-wallet, zero-quantity, and self-move cases — all net to `mempty` correctly,
  and the "zero net writes no row" rule keeps *never held* (`Nothing`) apart from *held and
  flat* (`Just … psBal 0`). Correct.
- **"Priced iff active" by shape.** The price riding on `Active` makes both illegal states
  unspellable; this is a real by-construction property, not a writer discipline. Correct.
- **Append-only terms by seal.** Non-exported constructor + `register` refusing a present
  unit means no door shortens history. Correct.
- **Deterministic replay.** `apply` is pure and total (every branch returns `Maybe`, no
  partial patterns, `NE.last` total); `replay = foldM (flip apply)`; checkpointing rides
  the monadic left-fold law over concatenation. Correct.

The "three homes, two maps" *structure* is forced cleanly: Position keyed by
(holder, unit) because two holders differ; Status keyed by the unit because one number is
read identically; Terms apart from Status because their change disciplines (append vs.
overwrite) and authorities differ and cannot share one value. All three are obvious.

## The residue (one, load-bearing, located)

The headline answer is not "at least three homes" — it is "**three homes and no fourth.**"
The completeness half — that the fourth cell is empty and that *every* economic fact is a
(holder, unit) fact or a unit fact, "never about a wider key" (§The Answer, lines 62–67) —
does not stand on its own. It rests on a single premise: that **every economic relationship
a wallet has is itself a unit the wallet holds** (lines 55–59).

That premise is proved for exactly one case (the single mandate reified as a
(client, mandate-unit) position, §Why Three, lines 142–148) and then, in the document's own
words, **"a relationship spanning several instruments is likewise a single unit, and so a
single row, is assumed here, not proved"** (lines 148–149; echoed at 56–58).

This is honestly flagged — but flagging makes it *honest*, not *obvious*. A reader meeting
this for the first time cannot, in one pass, see why a portfolio mandate spanning many
instruments collapses to one (holder, unit) row rather than forcing a wider key. They are
told to grant it. That is a marked leap of faith sitting directly under the word that makes
the answer an answer ("no fourth"). By the project's own first commitment — *"a claim is
proved, not asserted… properties hold by construction"* — a load-bearing completeness claim
that is assumed for its general case is a correctness gap, not a stylistic one.

To be precise about scope: everything that *is* a unit is fully handled. The gap is exactly
the inductive step that brings multi-instrument relationships inside the "is a unit"
premise, and with it the universal "never a wider key."

**Actionable fix — any one of:**
1. Discharge the multi-instrument reification: show a relationship spanning several
   instruments is a single unit (single row), as the single-mandate case is shown at
   lines 142–148. This closes "no fourth" outright.
2. Replace the assumed reification with a closure argument that no *economic* fact can
   escape the unit / (holder, unit) dichotomy — generalizing the existing "KYC/permissions
   are identity, not economic state" move (lines 66–67, 132) into a complete partition of
   economic facts. (Currently that move disposes of identity facts but does not show every
   remaining economic fact reifies.)
3. If neither is in scope for this file, weaken the stated answer to what is proved —
   "at least three homes within the proven (single-unit) scope" — so the headline no longer
   asserts completeness it has not earned.

Until one of these lands, the answer the reader is asked to accept ("exactly three, no
fourth") contains one explicit, located leap.
