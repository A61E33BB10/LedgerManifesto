# Round 14 — henri-cartan review of States.tex

Verdict: **NOT-YET**

## What is obviously right

The code-level content and its two stated theorems are complete and follow
directly from the definitions; their omitted detail is not missed:

- **Conservation.** `applyMove` is the only writer of `psBal`; it derives both
  legs from one `q` as `negQty q` and `q`, exact inverses in the `Qty` group;
  every per-unit sum therefore changes by `mempty`. `register`/`settle` touch
  only `ledgerUnit`. From `emptyLedger` (sum zero) induction gives `netBal u`
  invariant for every unit. The self-move and zero-quantity cases are handled
  explicitly (both net `mempty`, write no row). The export list of States.hs
  (verified: `Ledger` and its selectors not exported, the step-3/4 scaffolding
  `Balances`/`transfer` not exported) closes the "no other door" clause. Airtight.

- **Deterministic replay.** `apply` is pure and total (no partial pattern, `NE.last`
  is total on `NonEmpty`, all `Map`/`foldM` operations total), so equal streams
  give equal ledgers; `foldM` halts at the first `Nothing`. Checkpointing rests on
  the standard `foldM`-over-concatenation law. Sound.

- **Construction invariants.** Lifecycle/price correlation by the `Active`
  constructor (illegal states unspellable), `NonEmpty` + unexported constructor
  for append-only terms, the terms/status pair making co-presence structural, and
  the `Maybe`/zero-row distinction in `position` (never-held vs held-and-flat) all
  follow from the declarations shown. The listings match States.hs.

For a single unit holding a single reified relationship, the three-home placement
follows from the two sorting questions and the demonstrated mandate reification.

## The residue (located, load-bearing, blocking)

The document's **headline answer is stated universally but proven only partially.**

§The Answer asserts: "Two questions place any fact," and derives the binary
holder-axis (every economic fact is a (holder,unit) fact or a unit fact) from
"the reification that every economic relationship a wallet has is itself a unit
the wallet holds." It then states plainly: "The reification is demonstrated for a
single relationship and assumed for one spanning several instruments (§why); the
binary holder-axis, **and so the count below, rests on it.**"

§Why Three repeats the concession: the managed-account case "discharges the
reification for one mandate; that a relationship spanning several instruments is
likewise a single unit, and so a single row, **is assumed here, not proved.**"

So the decisive step for the central conclusion — that three homes suffice and the
fourth cell (externally-authored (holder,unit) fact) is empty *for every* economic
fact — is the general reification, and it is openly unproven. The two correctness
theorems do not depend on it, but the *placement answer itself* does: if a
relationship spanning several instruments produced a fact that is neither a pure
unit fact nor a single (holder, single-unit) fact, the binary axis and the
"three cells occupied" count would not hold, and a fourth home could be forced.

A competent engineer asking the natural question — "is this design *complete*; will
I ever need a home the 2×2 does not provide?" — cannot derive the answer from the
definitions. The decisive lemma is absent, and it is the exact place the design is
most likely to fail (multi-leg / multi-instrument mandates).

This is flagged honestly rather than hidden, which is correct documentation
practice — but flagging an assumption makes the document candid, not the answer
obvious. A conclusion that rests on an admittedly unproven, load-bearing premise
is "right modulo a conjecture," not obviously right.

### Actionable resolution (either suffices)

1. Prove the general reification: show that a relationship spanning several
   instruments reifies to a single held unit, so a fact about it is a single
   (holder, that-unit) fact — discharging the binary holder-axis in general; or
2. Downscope the headline to what is proven: state the placement answer for a
   single reified relationship and mark the multi-instrument generalization as an
   external premise this file consumes (named, owned elsewhere), so the universal
   phrasing "place any fact" / "no fourth" is not claimed here.

## Non-residue (checked, holds)

- Sealing claims are accurate against States.hs's export list.
- `psHwm` stays `mempty` (no writer in scope); `appendVersion` driven by no event,
  so every terms value has one version, as stated.
- `foldM` checkpoint law is a genuine monad law; acceptable as a remark.
- Listings reproduce the `.hs` declarations as claimed.
