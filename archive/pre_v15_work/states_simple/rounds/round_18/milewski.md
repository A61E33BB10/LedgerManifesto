# Round 18 — milewski review of `states_simple/States.{tex,hs}`

## Verdict: OBVIOUS

Held from R17. The Haskell reads like Hutton end to end; every abstraction is
named after the thing it is the name of and earned at the point of introduction;
no step assumes the answer; `.tex` and `.hs` agree. Empty residue.

## What I checked this round (files read in full; no GHC in env, verified by reading)

R18 delta vs my R17 OBVIOUS:
- `States.hs` mtime 13:37, `States.tex` mtime 13:56, `iteration_log.md` 13:57.
- `.hs` psHwm content is **unchanged** from the R17 deferral.
- `.tex` psHwm paragraph (:222–234) **restored** the clause "leans on none of
  `Qty`'s group structure for it" and now states the Price-vs-psHwm contrast
  cleanly ("Price strips the group because a price is settled never to sum;
  psHwm keeps its source type because its operation is not settled here").
  This narrows the R17 `.tex`/`.hs` divergence to nil — an improvement, not a
  regression.

Fresh Hutton-bar pass on the rest, re-derived by reading (not deferring to
memory):
- **Qty** group (step 1) — earned solely to make a transfer's two legs cancel.
- **Price** non-group newtype (step 5) — earns its place: removes the bug class
  "a price summed into a balance." This is the restraint rule satisfied.
- **Lifecycle = Listed | Active Price** (step 5) — priced-iff-active by shape;
  both illegal states unspellable.
- **ProductTerms = NonEmpty**, constructor unexported; `currentTerms` total via
  `NE.last`; `appendVersion` the only growth door (step 6).
- **Sealed Ledger**, two maps, three homes; `register`/`settle`/`applyMove`/
  accessors all type-correct; co-presence structural via the pair (step 8).
- **applyMove** net-first (`netDeltas` then `writeNet | d == mempty = ps`):
  self-move and zero-move conjure no row; conservation = writer invariant,
  honestly disclosed; seal makes the reach exhaustive (step 8, §right).
- **position** Maybe = never-held vs held-and-flat; **netBal** = `foldMap psBal`.
- **replay = foldM (flip apply)** in Maybe; determinism = purity of `apply` +
  the monadic left-fold law (checkpoint independence). All sound.

## The one standing item — non-blocking, unchanged disposition

**psHwm type-strengthening (standing FLAG 2, carried R2–R18).** The type still
admits `foldMap psHwm` — a meaningless cross-holder sum, the shape of `netBal`
one screen away. The Price-style remedy (a value-level newtype with **no**
Semigroup/Monoid) would make that unspellable and, by my own restraint rule,
*earns* its place.

It is **not residue**, for the reasons settled in R17 and re-confirmed here:
1. **No false claim in either artifact.** Both `.hs` (579–593) and `.tex`
   (222–234) make *no* aggregate claim over holders for psHwm and *no*
   type-impossibility claim either — pure deferral ("its algebra belongs to its
   out-of-scope writer"). The dangerous fold is never written and is explicitly
   disclaimed. FORMALIS confirmed no overclaim.
2. **Adjudicated owner-returned (minsky).** It must be applied to the `.hs`
   declaration **and** the `.tex` listing (`tex:239` still shows `psHwm :: Qty`;
   `tex:157` "listings reproduce declarations") **together** — an
   owner/STYLUS-coordinated change, never a `.hs`-only milewski edit. A `.hs`-only
   application would diverge the decl from the listing: a worse, declaration-level
   residue than the one removed.
3. **Identical-or-better content vs my R17 OBVIOUS.** The `.hs` is unchanged and
   the `.tex` improved. Re-flipping on improved content would be inventing residue
   to withhold.

I endorse the strengthening in principle and leave it returned to source.

## The iteration log's alleged `.hs` internal contradiction is STALE — already discharged

`iteration_log.md` (13:57) carries: "the additivity rationale at 579-583/588-593
vs the no-aggregate-claim stance at 584-591, and the ratchet=max at 374 vs add=+
at 581 — still milewski's to reconcile in the .hs."

This references an **older `States.hs`**. The current file (13:37) has **no
additivity rationale anywhere**:
- `grep -i 'hwm|adding|combines|peak'` over `States.hs`: the only psHwm algebra
  text is the pure deferral at 579–593 ("leans on *none* of `Qty`'s group
  structure", "makes no aggregate claim at all", "its algebra belongs to its
  out-of-scope writer"). No "adding HWMs is legal", no "newtype would only
  decorate", no `+`/negate applied to psHwm.
- Line 374 ("it ratchets up") describes the **writer's** discipline, not a
  combine operator; it is consistent with — not contradicted by — the 579–593
  deferral, which assigns that algebra to the out-of-scope writer. There is no
  "add=+ at 581" (line 381 is the field declaration comment "not conserved").

So the `.hs` is internally consistent; the only live psHwm item is the
non-group-newtype strengthening above (FLAG 2), already owner-returned. No `.hs`
edit is owed by me this round (restraint rule).

## Carried non-blocking nit (since R5, 14 rounds; FORMALIS R13 = licensed simplification)

`.tex` renders `TermsVersion` (:214) and `Move` (:297) as positional
constructors where `.hs` uses records — mildly strains "the listings reproduce
its declarations." The `.tex` is internally consistent (never uses the dropped
accessors), so a reader of the `.tex` alone is not misled. STYLUS/owner-owned;
not a `.hs` defect.

## FORMALIS handshake

R18 carries no new `.hs` change from me, so no new handshake is owed; the R17
`.hs` content is FORMALIS-cleared (no overclaim on psHwm). I make no submission
over any FORMALIS objection.

Empty residue.
