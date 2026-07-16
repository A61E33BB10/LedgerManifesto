# milewski — Round 8 — States.tex / States.hs

## Verdict: OBVIOUS

My lens: does the Haskell, as States.tex presents it, read like Hutton — each
step obvious from the last, nothing assuming the answer in advance, no
abstraction arriving before it is earned.

## What changed since Round 7

The `.hs` is unchanged (mtime 10:21 predates the R7 review at 11:05; every
declaration matches the file I cleared OBVIOUS at R5/R6/R7). The R8 delta is
confined to `States.tex` prose (mtime 11:12), in two places, both in the
*derivation* (§The Answer, §Why Three), not in §The Construction or §Why It Is
Right that map onto the code:

1. **§The Answer, new closure paragraph (States.tex:100–108).** Closes the
   *wallet-alone* key: no fourth home holds economic state, because conservation,
   valuation and P&L are reckoned per holding, so every economic fact about a
   wallet is a fact about its relationship to some unit (a (holder, unit)
   position); what stays wallet-keyed (KYC, permissions, audit cursor) is
   identity, not economic state, and is none of the homes.
2. **§Why Three, reworked fourth-cell chain (States.tex:146–164).** The seal is
   now stated as **single-writer-per-fact, not per-key** (:147), with the
   valuation event writing `psHwm` beside `applyMove` writing `psBal`, "the two
   coexist because they own distinct fields" (:150); a (holder, unit) correctable
   definition would be a second writer of a fact `applyMove` already owns,
   breaking the seal — "empty by this one chain," and "this does not reopen
   authorship" (:156–160).

This is an improvement to the derivation, not a weakening. Item 1 completes the
case analysis of the keying axis: §The Answer's "first by what it depends on"
splits on a *binary* key (unit vs (holder, unit)); the multi-unit key was closed
by the §Answer assumption (lines 60–64), and the wallet-alone key is now closed
explicitly. The two-value axis is therefore derived, not assumed. Item 2 ties
the empty fourth cell to the *same seal the Haskell already enforces* (sole
`psBal` writer = `applyMove`, hidden constructor), now sharpened to per-field so
that `psHwm`'s out-of-scope valuation writer coexists without contradiction. The
home count is unchanged — still `ledgerUnit` (the `(ProductTerms, UnitStatus)`
pair) plus `ledgerPS`.

## Hutton-bar pass (fresh)

The construction and its laws are the file I have cleared three times; I re-ran
the pass against the current text:

- `Qty` monoid then group (`negQty`): group structure exists solely so a
  transfer's two legs cancel; forward-pointer honest (States.tex:184–193).
- `Price` newtype, deliberately *not* a monoid/group: keeps a price from being
  summed into a balance — earned by contrast with `Qty` (States.tex:214–223).
- `Active Price`: price rides on the constructor, so "active with no price" and
  "listed yet priced" are unspellable; correctly contrasted with conservation as
  a *disclosed* writer-invariant where the shape cannot afford the guarantee.
- `NonEmpty ProductTerms`, constructor unexported: "registered but versionless"
  not representable; no door shortens history (States.tex:225–241).
- pair `(ProductTerms, UnitStatus)` under one key: co-presence is the shape, not
  a policed invariant — the file's own step-5 rule applied (States.tex:261–278).
- `foldMap` / `foldM`: each named where its referent is on the page.

No step assumes the answer. Result-first throughout: §The Answer states it,
§Why Three derives it, §The Construction builds from the smallest pieces each
forced by the one before. Conservation is still disclosed honestly as a
writer-invariant (States.tex:349–360), not falsely as a type guarantee. Replay
determinism is attributed to purity/totality of `apply`, the checkpoint property
to the monadic left-fold law, row retention disentangled as a separate audit
property. `apply` matches all three `Event` constructors — a new class forces a
new arm; no wildcard. All accessors total; every refusing writer makes failure
explicit in `Maybe`, and the document keeps the `Maybe` answering "is this unit
known?", never "did the balance hold?".

## Sub-threshold notes (non-blocking, do not move the verdict)

- **Carried from R5–R7:** the `.tex` listings render `TermsVersion`
  (States.tex:235) and `Move` (States.tex:312) as *positional* constructors where
  States.hs declares both as records (`TermsVersion { tvLabel }`,
  `Move { mvUnit, mvFrom, mvTo, mvQty }`). The `.tex` says "the listings
  reproduce its declarations, deriving clauses elided" (line 180); record→
  positional is more than deriving elision. Each file is internally
  self-consistent and arities/types agree; cross-artifact fidelity nit
  (STYLUS/formalis territory).
- **New, minor:** the fourth-cell chain says "Every (holder, unit) fact is the
  ledger's own, folded from *its own move stream*" (States.tex:153). `psHwm` is
  folded from a *valuation* event, not the move stream; the load-bearing point
  ("the ledger's own," vs received at the boundary) holds, but "move stream" is
  loose. Likewise the cross-ref at :150 sends "two coexist because they own
  distinct fields" to §right, which establishes `psHwm` carries no zero-sum
  invariant but does not itself describe the valuation writer's coexistence.
  Both are prose imprecisions in the domain derivation about the full system, not
  defects in how the in-file Haskell reads (the code keeps `psHwm` at zero and
  makes no replay claim about it), so they do not contradict the code. Left to
  the author.

No GHC in this environment; totality, exhaustiveness, and the derived-`Show`
GHCi/`main` echoes verified by reading, which is what this lens turns on.

A competent engineer new to the problem can still read the Haskell and watch
conservation fall out of "a move is two cancelling legs, written by the one
sealed door, from an empty base," and replay fall out of "apply is pure and
total, replay is its fold." The new prose makes the *why-three* derivation more
complete (the keying axis is now closed on both sides), not less obvious. Each
abstraction arrives only when earned.

**OBVIOUS.**
