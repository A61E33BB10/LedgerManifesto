# Round 11 — milewski review of states_simple/States.tex

**Verdict: OBVIOUS.**

## Scope this round
Round 11 is a presentation pivot (`ROUND10_PIVOT.md`): discriminate Terms from Status by
**authority** not a boundary read (Pivot 1), one predictable 2×2 (Pivot 2), fix the HWM
overclaim (Pivot 3), own "no fourth economic home" as a stated reduction (Pivot 4), say
each conclusion once (Pivot 5). The pivot explicitly leaves the Haskell semantics unchanged
and FORMALIS-cleared; the only correctness-touching change is Pivot 3, which is a
correction. My bar is the Haskell-as-presented (Hutton: each step obvious from the last, no
abstraction before earned) plus the laws.

## What I checked and found right

1. **Pivot 3 is in the `.tex`.** §"A position carries more than a balance" (lines 233–239):
   `psHwm` "carries no zero-sum invariant — a non-conserved field beside the conserved
   balance, and no aggregate over holders is claimed for it." The false "total peak
   exposure" gloss (round-10 residue items 8, 11) is gone. Matches `States.hs` 587–599 and
   the settled Round-11 memory note. The kept reason is the only true, load-bearing one:
   per-position state composes under the `Qty` monoid; `psBal` cancels because its writer
   lays two inverse legs, `psHwm` simply does not.

2. **Listings are code-correct and match `States.hs`.** `Qty`/`negQty` (group, identity +
   inverse), `Price` (deliberately no monoid/group), `Lifecycle = Listed | Active Price`
   (price fused onto the settled stage), `ProductTerms (NonEmpty TermsVersion)` with hidden
   constructor, `PositionState {psBal, psHwm}`, the collapsed `ledgerUnit :: Map UnitId
   (ProductTerms, UnitStatus)` pair, `register`/`settle`, the net-first `applyMove`
   (`netDeltas` per-wallet net + `writeNet | d == mempty = ps`), `position`, `netBal`,
   `Event`/`apply`/`replay = foldM (flip apply)`. All type-correct, all consistent with the
   `.hs`.

3. **Laws stated honestly.** Conservation as a *writer* invariant (line 345: "not the store
   type, which can hold a non-conserving assignment"; the sealed constructor makes the reach
   from `emptyLedger` exhaustive). Replay determinism from `apply` being pure+total, with
   checkpoint-independence as the monadic left-fold law splitting `foldM` over a
   concatenation at any cut (374–381). Both are real laws, neither overstated.

4. **Hutton bar: every abstraction named after its referent and earned at introduction.**
   `Qty` group — "the negation later forces the two legs of a transfer to cancel"; `Price`
   denied a monoid — "never summed into a balance"; price-on-`Active` — the "active with no
   price / listed yet priced" states are "unspellable … by the type, not by a writer";
   `NonEmpty` — "registered but versionless is not representable"; `foldM`/`Maybe` — "a fold
   whose step may fail." No abstraction precedes its use.

5. **The net-first move presentation (R10) reads obviously in the `.tex`.** Lines 294–323:
   two cancelling legs summed per wallet; both a zero-quantity move and a self-move net to
   `mempty` and write no row; `Maybe` guards "is this unit known?", never "did the balance
   hold?". Consistent with the .hs and with my R9/R10 reviews.

6. **`.tex` is solution-only, no path** (per pivot "Unchanged"). It correctly omits the
   teaching scaffolding (`Balances`/`transfer`) the `.hs` thread carries; the placement
   logic is instead derived in §The Answer's 2×2, and §The Construction realizes each cell
   as a type. The forcing chain ("each forced by the one before") is mild rhetoric but every
   type is motivated where introduced — same as prior passed rounds.

## Carried non-blocking note (sub-threshold, not residue)
The `.tex` claims (line 166) "the listings reproduce its declarations, deriving clauses
elided," but renders `TermsVersion` (line 221) and `Move` (line 302) as **positional**
constructors where `States.hs` declares them as **records** (`tvLabel`; `mvUnit/mvFrom/
mvTo/mvQty`). Other listings (`UnitStatus`, `PositionState`, `Ledger`) keep record syntax,
so the rendering is internally inconsistent and the "reproduce its declarations" claim is
slightly overstated. This does **not** affect any argument: the `.tex` never uses the
dropped accessors and its `applyMove`/patterns match positionally, so a reader of the `.tex`
alone is not misled. Carried as non-blocking since Round 5; left to the author. Not residue.

## Conclusion
At the milewski bar the Haskell as `States.tex` presents it reads like Hutton: each type
forced and motivated, each abstraction named after the thing it names and earned at use, the
two laws classified honestly (shape-enforced vs writer/seal soundness), totality and
determinism verifiable by reading (no GHC in env; verified by inspection). The Round-11
pivot's only correctness item (Pivot 3) is correctly reflected. **OBVIOUS**, empty residue.
