# chris-lattner — States.tex, Round 16

Verdict: **NOT-YET**

The architecture is right and the arc is clean: Question → Answer (the 2×2,
three cells) → Why Three → Construction → Why It Is Right. A competent engineer
new to the problem can walk it. The forward-reference structure (announce in
§2, justify in §3, construct in §4) is deliberate and mostly earns itself —
each section does a distinct job rather than echoing the last.

But the bar is "nothing said twice," and one field violates it plainly.

## Primary residue: `psHwm` is defended six times for a field that does nothing in scope

Location: §The Construction, paragraph "A position carries more than a
balance," lines 221–234; with a seventh callback at line 351.

The single fact the reader needs is: *a Position carries the conserved `psBal`
plus room for a non-conserved per-(holder,unit) field; the high-water mark is
such a field, written by a valuation event out of scope, so it stays zero
here.* One sentence. The paragraph instead circles it:

1. "a high-water mark rides alongside and does not [conserve]"
2. "the file leans on none of `Qty`'s group structure for it"
3. "what a high-water mark measures … is fixed by its writer, a valuation event
   out of scope here, not by this file"
4. "One role is kept for `psHwm` here, a non-conserved field beside the
   conserved balance"
5. "It has no paired writer … so it carries no zero-sum invariant, and no fold
   aggregates it over holders"
6. "Its writer out of scope, `psHwm` stays zero in this file"

"Not conserved" appears ~3 times; "writer out of scope" ~3 times. Then §Why It
Is Right adds a seventh: "`psHwm` carries no such invariant (§construction)."

This is backwards by progressive-disclosure. The load-bearing machinery (the
seal, the cancelling legs, conservation) deserves the words; an inert field
that stays zero deserves a sentence. When a decision needs this much defense,
the defending itself becomes a smell — it tells the reader the field is barely
pulling its weight while spending the most prose on it, which obscures the
simple path rather than clearing it.

Actionable: collapse to one sentence. Keep `psHwm` in the listing (it shows a
Position can hold non-conserved state under the (holder,unit) key — that does
serve the answer), but state its role once: typed `Qty` to match its source,
written by an out-of-scope valuation event, non-conserved and never folded,
zero throughout this file. Delete the rest, including the §5 callback (§5's own
sentence "Conservation is an invariant of the writer, not the store type"
already covers why a non-conserved field is unremarkable).

## Secondary residue: conservation pre-stated in §4, then proved in §5

Location: §The Construction, same `psBal` sentence, lines 226–229
("conservation is a single fold over the position map") vs. §Why It Is Right,
lines 341–356.

§4 motivates `psBal` as "primary, conserved" — fine, it must. But it leaks the
proof: "a move writes two cancelling legs (below), so it conserves … the rows
combine holder by holder, so conservation is a single fold over the position
map." That last clause is precisely `netBal` and the §5 argument, asserted
before the move writer or the seal has been shown. §5 then delivers it
properly. Lower confidence than the primary — §4 does need to say `psBal`
conserves — but trim §4 to the claim ("primary, conserved") and leave the
*mechanism* (cancelling legs, single fold, seal) to §5 where it is proved.

## What is not residue

- The empty fourth cell (named §2, reasoned §3) — announce vs. justify, not a
  repeat.
- Terms/status co-presence (§2 "ride together as a pair," §4 "co-presence is
  the shape of the map") — §4 adds the construction fact, distinct.
- The sealed-constructor rationale (§4 full, §5 one-clause callback) — the §5
  mention is a proof citation, acceptable.
- The benchmark-level vs. benchmark-identity example — earns its place
  clarifying the subtle authorship criterion; appears once.
- The self-move / zero-move "nets to mempty" point (§4 twice) — first for the
  sum-to-mempty conservation fact, then for "writes no row" / held semantics;
  different purposes, and the second cites "(above)." Borderline but defensible.

Fix the `psHwm` over-statement and this is obvious.
