# Round 16 — milewski review

**Verdict: NOT-YET.**

This reverses my Rounds 11–15 OBVIOUS verdicts on the psHwm question, and I owe the
reason. R16 did not close the long-standing jane-street-cto flag; it *broke the prior
coherence* that had let me wave it through. I was also, on re-examination, answering the
wrong proposal in those earlier rounds. Both are corrected below.

## What R16 changed (and what it did not)

`.hs` mtime 12:33 predates the 13:28 `.tex`; the R16 delta is `.tex` prose only
(`iteration_log.md` Round 16). STYLUS **removed** the contested sentence in §Construction
"A position carries more than a balance" — *"a high-water mark is a quantity, so adding two
is legal, unlike a price (above), whose sum is meaningless"* — and replaced it with a
**deferral**: psHwm is typed `Qty` "matching the source," but "the file leans on none of
`Qty`'s group structure for it," its algebra fixed by an out-of-scope valuation writer
(States.tex ~227–231).

This makes the `.tex` assert nothing *false*. But "honest deferral" is not the bar. The
bar is *obviously right* and *no abstraction before it is earned*. R16 fails it two ways.

## Residue 1 — the `Qty` reuse on psHwm now contradicts the document's own step-5 principle, and the R16 deferral sharpens the contradiction rather than closing it

Located: States.tex ~227–231 (§Construction, "A position carries more than a balance")
against States.tex ~192–193 (step 5, the `Price` rationale). Mirror in States.hs:
`psHwm :: Qty` (line 380), `zeroP` (line 391), and the §8 comment (lines 579–591).

Step 5 states the document's governing rule for value-carrying fields, in its own words:
*"A price is a number but not a quantity — prices are never added — so `Price` is a separate
newtype with neither identity nor inverse, never summed into a balance"* and *"the only type
that carries the group structure is the one that conserves."*

A high-water mark conserves nothing and is **never meaningfully summed** (Round 11 settled
this: peak-of-sum ≤ sum-of-peaks; the cross-holder sum is meaningless). Within one position
it is updated by a **max/ratchet**, never by `+` or negation. So `Qty`'s algebra — additive
group, `(+, 0, negate)`, existing *only* for conservation's cancelling legs (step 1) — is
the **wrong algebra** for psHwm, by exactly the standard step 5 applies to `Price`.

The dimension matches (both are cents/minor units), which is why `psHwm :: Qty` *looks*
fine. But step 5's distinction is about *algebra*, not dimension: `Price` is also cents and
is still denied the group, precisely because it is never added. psHwm is in the identical
position and is given the full group. That is the document violating its own step-5 rule at
step 7 — a step that is not obvious from the last; it contradicts the last.

R16 made this **worse, not better.** Before R16 the document at least *claimed* HWM was
quantity-like ("unlike a price"), so claim and type cohered (coherent-but-dubious). R16
retracted the claim ("leans on none of `Qty`'s group structure") but kept the type, leaving
**openly incoherent**: a field the document says uses *none* of a structure, carrying that
structure, justified only by "matching the source" — an appeal outside a self-contained
Hutton thread. The cost is concrete and unchanged: `foldMap psHwm` (the shape of `netBal`,
States.hs 597–598) typechecks and yields a meaningless cross-holder sum — the exact class of
illegal computation step 5 exists to forbid.

Minor supporting point: the deferral's "leans on **none** of `Qty`'s group structure" is not
even strictly true — `zeroP = PositionState mempty mempty` (States.hs 391) uses `Qty`'s
*identity* for psHwm. The file leans on the identity; only the operation and inverse are
unused. So even the new sentence slightly overstates.

### Why this is not the abstraction I rejected in Rounds 11–15

My standing rejection (memory) was of *"a newtype to mark psHwm non-conserved"* — a `Qty`-
like group **plus a label**. That buys nothing and I correctly rejected it. But that is the
**wrong proposal**. The correct fix is a **value-level newtype with no `Semigroup`/`Monoid`**,
mirroring `Price` exactly. That is **not** decoration: it removes the `foldMap psHwm` bug
class (the meaningless fold stops typechecking) and makes the type honest about the absent
algebra. It is the *same purchase the document already banked for `Price`*. My earlier
rejections answered the decorative proposal and missed this one — by my own restraint rule
(item 1: an abstraction must buy a bug class made unrepresentable), the Price-style newtype
earns its place; the unused group structure on `psHwm` does not.

### Actionable

Two routes, either closes it (these are the routes jane-street-cto/STYLUS returned to me):

- **(a) — the live one, and my recommendation.** Give the high-water mark (and entry NAV,
  when it lands) a value-level newtype with **no `Semigroup`/`Monoid`** instance, mirroring
  `Price` (States.hs 249). Then `foldMap psHwm` does not typecheck, and the field serves its
  stated in-file role — "a non-conserved field beside the conserved balance" — *better* than
  `Qty` does, because the type now says so. Cost is one constructor change at `zeroP`
  (`PositionState mempty (Hwm 0)`); nothing folds psHwm, so nothing else breaks. State, in a
  line, what the mark measures (the position's NAV peak), so its dimension is named even
  though its cross-holder combination is undefined.
- **(b)** If `Qty` is genuinely intended, state in source what the HWM is a quantity OF and
  show that addition over holders is meaningful. Round 11 already found it is not, so (b) is
  not available without overturning Round 11.

For an out-of-scope field, note that `Qty` is the *wrong* placeholder regardless: a safe
placeholder for an undecided algebra carries *no* operations, not the additive conservation
group. So "out of scope" supports (a), it does not defend the status quo.

## Residue 2 — R16 introduced a substantive `.hs`/`.tex` contradiction on the contested point

Located: States.hs 579–591 vs States.tex ~227–231.

The `.hs` still asserts the very rationale R16 deleted from the `.tex`: *"psHwm is the same
type `Qty`, and that is right: a high-water mark is a quantity, and it combines with the same
monoid … adding high-water marks is legal — so a separate newtype … would only decorate, and
we do not add it."* The `.tex` now says the file "leans on none of `Qty`'s group structure"
and defers. These are contradictory claims about whether psHwm's monoid is meaningfully used.

This is not the long-standing cosmetic positional-vs-record listing nit; it is a substantive
prose disagreement between the two artifacts the committee reviews as one solution. Bring
them into agreement — and the clean way to do that is to apply Residue 1 route (a) to both:
re-type psHwm, then both files say the same true thing.

## What is unchanged and still OBVIOUS

Everything else holds, as in R5–R15: `Qty` as the conservation group; `Price` correctly
non-group (this is exactly the precedent Residue 1 invokes); `Lifecycle = Listed | Active
Price` (priced-iff-active by shape); `NonEmpty` terms; the `ledgerUnit` pair (co-presence by
shape); net-first `applyMove` (zero/self-move conjure no row); conservation as an honest
writer-invariant; replay = `foldM` with the monadic left-fold law; the never-held /
held-and-flat `Maybe`. None of these is in question. The single blocking item is the psHwm
type/algebra, which R16 moved from coherent-but-dubious to openly-incoherent-and-divergent.

Standing flag, outside my lens, untouched this round: the multi-instrument reification proof
(three-homes count conditional on it; shown for n=1).

No GHC in env; `.hs` verified by reading (unchanged), `.tex` change confirmed against
`iteration_log.md` Round 16.
