# Henri Cartan — States, Round 12

**Target:** `/home/renaud/Ledger/states_simple/States.tex`
**Authoritative source cross-checked:** `/home/renaud/Ledger/states_simple/States.hs`
**Bar:** the answer follows from its definitions so directly that the omitted proof is not missed.
**Reader:** a competent engineer who has never seen this problem.

## Verdict: NOT-YET

## What is obvious (clears the bar)

The two named correctness properties follow directly from the definitions and are
argued, not merely asserted:

- **Conservation.** `applyMove` is the sole writer of `psBal`; it lays down
  `negQty q` and `q`, whose sum is `mempty`; `register`/`settle` never touch
  `psBal`; `emptyLedger` sums to zero; the constructor and field selectors are
  unexported, so the reachable set is exactly the events. Induction closes it.
  The self-move and zero-move edge cases are handled correctly (`netDeltas` nets
  per wallet, `writeNet` skips `mempty`), so no phantom row is conjured. Sound.
- **Deterministic replay.** `apply` is pure and total (all three `Event`
  constructors matched; `NE.last` on a `NonEmpty` is total; no partial calls).
  `replay = foldM (flip apply)`; checkpoint-independence is the monadic
  left-fold law, which holds for `Maybe`. Sound.
- The shape-level guarantees (price rides on `Active`, `NonEmpty` terms,
  terms/status co-present as a pair, balance keyed by `(wallet,unit)`) are
  genuinely unrepresentable-by-type and need no proof. Sound.

The `.tex` listings match the `States.hs` declarations; the code is correct.

## The residue (located, actionable)

The `.tex` overstates a central, load-bearing claim that its own authoritative
source explicitly marks as **unproved in the general case**. This is precisely
the "present unsettled content as settled" failure the project method forbids.

**The claim.** Part of *the answer* is "three homes, no fourth" — equivalently,
the fourth 2×2 cell (externally-authored `(holder,unit)`) is empty and there is
no wallet-keyed economic home. This rests on a *reification*: every per-wallet
economic fact is a fact about the wallet's position in some unit.

**How `States.tex` presents it — as established:**
- Lines 63–67: "Every economic fact about a wallet ... *is* a (holder, unit)
  fact, because the framework models every economic relationship a wallet has as
  itself a unit the wallet holds ... The managed-account mandate of §why is *the
  demonstrated instance*." (A single instance is offered as demonstrating the
  universal — the opposite of flagging a gap.)
- Lines 98–99: "The fourth cell ... is empty."
- Lines 152–158: "A managed account looks like the counterexample ... *They do
  not.* ... Two mandates are two rows." This disposes of *multiple mandates*
  but says nothing about a *multi-instrument relationship inside one mandate*,
  and attaches no conditionality.

**How `States.hs` (the source) presents the same claim — as conditional:**
- Lines 429–431: "This file establishes the reification only for the
  single-mandate case (n = 1: one holder, one mandate unit); that a
  *multi-instrument* relationship is likewise a single unit is **assumed here,
  not proved**."
- Lines 784–787: "The 'no fourth home' half of the headline is conditional, and
  said so: it holds *given* that every per-wallet economic fact reifies as a
  position in some unit — a reification shown here for one mandate (n = 1) and
  **assumed for the general multi-instrument case, not proved**."

**Why this fails the bar.** "No fourth home" is part of the stated answer, yet it
does not follow from the definitions: the source itself concedes the general
reification is an assumption, not a theorem. The `.tex` conceals that the proof
is missing — it claims there is nothing to prove. A competent engineer reading
only the `.tex` would take "every economic fact is a (holder,unit) fact" and "no
fourth home" as established and would never learn that the general
(multi-instrument) case is an unproven assumption. The omitted proof is therefore
*missed precisely because its absence is hidden*.

(The narrower argument at lines 143–151 — that `(holder,unit)` facts are all
ledger-authored because external position reports are reconciliation inputs, not
adopted records — is itself fine; it follows from the system's defining purpose.
The weak link is only the universal reification of lines 63–67.)

**Actionable fix (either):**
1. Import the source's qualification into the `.tex`: state that "three homes,
   no fourth" holds *conditionally* on a reification established only for the
   single-mandate (n = 1) case and *assumed* for the general multi-instrument
   relationship; or
2. Supply the general proof that any multi-instrument economic relationship is a
   single held unit, discharging the assumption.

Until one of these is done, the answer as `States.tex` presents it is not
obviously right: it asserts as settled a claim its own authority leaves open.
