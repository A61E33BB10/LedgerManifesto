# chris-lattner — Round 13 — States.tex

Verdict: **NOT-YET**

## What is right

The architecture is sound and the document is, for the most part, a single
descending path: Question -> Answer (the 2x2, three occupied cells) -> Why each
cell -> Construction (types forced one by one) -> Why It Is Right (conservation,
replay). The two placing questions (holder-dependence, authorship) are the right
two axes, and the document earns its central moves:

- The "prefer the shape, disclose an invariant only when the shape cannot carry
  it" contrast (price-on-`Active` vs conservation-as-writer-invariant) is the
  best thing here — it tells a new reader exactly when a property is by type and
  when it is by argument, and the closing roadmap honors it.
- The sealed constructor / withheld field selectors story is precisely
  motivated: the record-update bypass (`l { ledgerPS = ... }`) is named, so the
  seal is justified rather than asserted.
- The held / never-held / held-and-flat distinction is load-bearing and carried
  by `Maybe` rather than a flag. Good.

This clears the "simple path is the whole document" and "everything serves the
answer" prongs. It fails on "nothing said twice."

## Residue (located, actionable)

### 1. PRIMARY — the reification caveat is stated in full twice.

The admission that the reification is *demonstrated for one relationship and
only assumed for the multi-instrument case* appears, in full, in two places:

- The Answer, lines 64–67: "The managed-account mandate of §why demonstrates the
  reification for a single relationship; that a relationship spanning several
  instruments likewise reifies as one unit is assumed, not proved here (§why)."
- Why Three, lines 160–161: "This discharges the reification for one mandate;
  that a relationship spanning several instruments is likewise a single unit, and
  so a single row, is assumed here, not proved."

This is not the legitimate assert-in-Answer / prove-in-Why layering used
elsewhere in the document. A caveat that something is *not proved* is not a claim
awaiting proof — there is no proof to defer to — so stating it fully in both
places is duplication, not disclosure. The Answer here reaches forward into
§why's managed-account paragraph and pre-narrates both its result ("demonstrates
the reification for a single relationship") and its caveat; §why then says both
again.

Fix: in the Answer, make the reification *claim* (every economic fact is a
(holder,unit) fact on a reification — this is load-bearing for the empty fourth
cell and must stay) and reduce the demonstration-and-caveat to a bare pointer,
e.g. "(demonstrated for one relationship, assumed in general, §why)." Let §why
carry the demonstration and the caveat exactly once.

### 2. SECONDARY — psHwm "carries no conservation invariant, for lack of a
cancelling-leg writer" is stated twice.

- Construction, lines 241–243: "psHwm is also a `Qty`, but no move writes it as
  two cancelling legs, so it carries no zero-sum invariant — a non-conserved
  field beside the conserved balance ..."
- Why It Is Right, line 360: "psHwm, written by no cancelling-leg writer, carries
  no such invariant."

Same proposition, same reason. The conservation proof legitimately needs to
*scope* its invariant to `psBal`, but the reason was already given in full at
241–243; line 360 re-derives it rather than relying on it. Fix: at 360, either
drop the clause (the proof is about `psBal`; psHwm needs no mention) or reduce it
to a scope note that cites the established fact rather than restating its reason.

## Note (not residue)

The "fourth cell is empty" fact appears at line 80 (implicitly, "three cells are
occupied"), in the table, at line 100–101, and at 112/144. I checked this and
judged it acceptable: line 100–101 names the cell's coordinates (which the table
shows only positionally) and installs the forward pointer, and 112/144 are the
§why roadmap-plus-proof. Each adds something. I am not flagging it, but if a
later round tightens further, line 100–101 is the weakest of these and is the
first place to look.
