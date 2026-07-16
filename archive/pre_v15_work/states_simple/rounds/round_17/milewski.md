# MILEWSKI — States, Round 17

**Verdict: OBVIOUS** (empty residue)

My lens: the Haskell reads like Hutton — each step obvious from the last, no abstraction
before it is earned; conservation and deterministic replay are consequences of the structure,
not asserted; totality and determinism hold by construction. Reader = a competent engineer who
has never seen this problem. I read `States.hs` end to end and `States.tex` end to end, and
cross-checked the two for agreement on the one point that was open last round (psHwm).

## This round closes my Round-16 NOT-YET

Round 16 I flipped a 14-round standing OBVIOUS to NOT-YET on psHwm. That NOT-YET had two
drivers; both are now resolved.

1. **The false claim is gone.** R16's `.hs` (579–591) still asserted the committal rationale
   "a high-water mark is a quantity, and it combines with the same monoid… adding HWMs is
   legal… a separate newtype would only decorate." That is false — a HWM's algebra is
   max/ratchet, never `+`; its cross-holder sum is meaningless (Round 11). The R17 edit
   (comment-only) replaced it with a **pure deferral** (`States.hs` 579–593): "typed `Qty`
   here, matching the source, but this file leans on **none** of `Qty`'s group structure for
   it. What a high-water mark measures — and so whether two of them compose, and how — is fixed
   by its writer, a valuation event out of scope for this file, not decided here." No committal
   claim survives; no false statement remains. The only kept facts are exact: no paired writer
   ⇒ no zero-sum invariant; nothing folds it over holders (`netBal` sums `psBal` alone); the
   load-bearing "per-position state composes" fact is about `psBal`.

2. **The `.hs`/`.tex` contradiction is gone.** R16 the `.tex` deferred while the `.hs` made
   the committal claim — two source artifacts disagreeing on a load-bearing rationale. Now they
   agree. `.tex` (221–237): "typed `Qty` to match its source, written by a valuation event out
   of scope here, never folded over holders, and so zero throughout this file." `.hs` (579–593):
   the matching deferral above. Same stance, same type (`psHwm :: Qty`), no contradiction.

## The remaining psHwm strengthening is non-blocking, not residue

I still endorse, in principle, giving `psHwm` (and entry NAV) a `Price`-style **non-group**
newtype (no `Semigroup`/`Monoid`) so that `foldMap psHwm` — the shape of `netBal` — would fail
to typecheck, removing a latent meaningless cross-holder sum. That is a genuine purchase by my
restraint rule. But it does **not** block "obviously right" this round, for three reasons:

- **No false claim is left to fix.** Neither `.hs` nor `.tex` claims the cross-holder sum is
  type-impossible, and neither claims `+` is the right combine for psHwm; both explicitly
  *defer* on its algebra. The latent operation is never written in the file and is disclaimed.
  FORMALIS confirms "no overclaim" (round_17 formalis.md 53–54). An honest deferral that leaves
  an un-exercised, disclaimed latent operation is a missing *strengthening*, not a derivation
  gap or a misstatement — the Hutton bar is about whether each step follows, and every written
  step does.
- **It must be applied to both artifacts together.** `States.tex` 157–158 says "the listings
  reproduce its declarations"; the `.tex` listing (238–239) keeps `psHwm :: Qty`. A `.hs`-only
  newtype change would diverge the `.hs` declaration from the `.tex` listing — re-opening
  exactly the kind of cross-artifact divergence R17 just closed. So this is an owner/STYLUS-
  coordinated change across both files, adjudicated (minsky) as a should-strengthen returned to
  source, not a this-round defect.
- **Do not relitigate the decorative-newtype confusion.** A `Qty`-like group *plus a label* to
  "mark psHwm non-conserved" is decoration and stays rejected. The endorsed strengthening is the
  *non-group* newtype, distinct from that — recorded so it is not conflated again.

## Fresh Hutton-bar pass on the rest — clean (unchanged since R5)

Code is unchanged this round (`.hs` edit was comment-only). Re-verified the structure stands:

- **Every abstraction is named after its referent and earned at introduction.** `Qty` a group
  *because* a transfer's two legs must cancel (step 1, used in step 4); `Price` deliberately
  not a monoid because prices are never added (step 5); `NonEmpty` for terms because "registered
  but versionless" must be unrepresentable (step 6); `foldMap`/`foldM` named only once the thing
  they name is already on the page.
- **Illegal states unrepresentable where the shape affords it, disclosed honestly where it
  cannot.** Price-iff-active rides on `Active Price` (no listed-but-priced, no active-but-
  unpriced); terms/status co-presence is the pair-valued map (no "in terms but not status").
  Conservation stays an honest *writer invariant* — the store type can hold a non-conserving
  map; what makes it hold is that `applyMove` is the sole `psBal` writer and writes two
  cancelling legs, and the sealed constructor + withheld selectors make the reach from
  `emptyLedger` exhaustive. The file states which facts are shape-enforced and which are
  writer/seal-argued (step 10), so the reader is never asked to take a discipline on faith as
  though it were a shape.
- **Conservation re-derived by hand.** `netDeltas` builds the per-wallet net first: distinct
  wallets `{f ↦ −q, t ↦ +q}` (sum `mempty`); self-move `{f ↦ q <> negQty q} = {f ↦ mempty}`,
  which `writeNet` drops (no phantom row). Zero-quantity and self-move unified under one
  net-zero ⇒ no-row rule. "Held = named in a move that nets nonzero on it."
- **Determinism by construction.** `apply` pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)` in `Maybe`; checkpoint-independence is the monadic left-fold
  split law, attributed to purity, not to row retention (which is disclosed as a separate audit
  property).
- **Totality.** `currentTerms` total via `NonEmpty`; `settlementPrice` total over the two
  reachable lifecycle cases; all three writers total, returning `Nothing` only for an
  out-of-bounds unit (input guard), never for a balance that failed to hold.
- **Type-correctness** of the load-bearing signatures confirmed by reading (no GHC in env):
  `Map.foldrWithKey writeNet (ledgerPS l) (netDeltas …)` with `netDeltas :: … -> Map WalletId
  Qty` and `writeNet :: WalletId -> Qty -> …`; `foldM (flip apply) :: Ledger -> [Event] ->
  Maybe Ledger`.

## Carried non-blocking nit (now 13 rounds)

`.tex` renders `TermsVersion` (213) and `Move` (293) as positional constructors where `.hs`
uses record syntax. Internally consistent (the `.tex` never uses the dropped accessors), a
reader of the `.tex` alone is not misled, FORMALIS calls it a licensed structural
simplification. STYLUS-owned, not residue.

## Handshake

FORMALIS round 17: **OBVIOUS, no residue**; independently confirms the psHwm deferral carries
no overclaim, every listing faithful to `States.hs`, every `\S\ref` lands, conservation and
deterministic replay visible from the structure. No disagreement; I submit with it.

**OBVIOUS.**

— MILEWSKI Committee
