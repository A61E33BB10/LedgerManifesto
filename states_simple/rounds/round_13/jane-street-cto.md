# jane-street-cto — States.tex, Round 13

Verdict: **NOT-YET**

Bar applied: a competent engineer who has never seen this problem reads it
cold six months on, calls it obvious, writes no commentary; no overclaim.

The document is, on the whole, excellent: the 2x2 placement is genuinely
clarifying, the conservation argument is tight and verifiable from the code,
the replay/checkpoint argument is correct (the `foldM`-over-concatenation
split law does hold for `Maybe`), and the scope boundaries (psHwm writer,
`appendVersion`, multi-instrument reification) are disclosed rather than
hidden. The self-move / zero-move "writes no row" reasoning checks out
against `netDeltas`/`writeNet`. There is no conservation or replay bug.

It fails the bar on one substantive point, with two minor ones.

## Blocking residue

**1. `psHwm :: Qty` contradicts the document's own central principle and
leaves a latent foot-gun. (lines 246-248, against 203-205 and 121-127)**

The spec argues, explicitly and well, that `Price` must be its own newtype
"with neither identity nor inverse, never summed into a balance" precisely
*because* it is a number that is never added (lines 203-205). It then makes
the opposite choice for the high-water mark — `psHwm :: Qty` — and `Qty` is a
`Monoid`/group with `<>` and `mempty`. So the HWM field carries full additive
group structure that, by the document's own taxonomy, it must not have.

This is not cosmetic. A high-water mark, written by a valuation event and
sitting beside entry NAV in the managed-account discussion (lines 156-161),
is a value level, not a share count. Because it is typed `Qty`, nothing
prevents it from being folded exactly as `netBal` folds `psBal`
(`foldMap psBal ...`, line 364). The type permits the very "copied across
rows free to drift / summed wrongly" hazard the Status paragraph (lines
121-127) and the `Price` paragraph were written to make unrepresentable. The
prose patches this by *convention* ("carries no zero-sum invariant", "no
aggregate over holders is claimed"), which is precisely the writer-trusted
discipline the rest of the document rejects in favour of types.

A fresh reader stops here and writes the note: *"Why is the high-water mark a
`Qty`? It is a value, never summed across holders — by this document's own
`Price` argument it should be a separate newtype with no monoid. As typed,
nothing stops someone summing HWMs."* That note is the failure of the bar.

Actionable: either give the HWM (and entry NAV) a value-level newtype with no
`Semigroup`/`Monoid` instance, mirroring `Price`, and state why; or, if there
is a real reason it must be `Qty`, give that reason in the paragraph instead
of merely asserting the invariant is "not claimed."

## Minor residues (not individually blocking, worth fixing)

**2. "The seal no longer carries coherence --- the pair does" (line 263).**
"No longer" presupposes a prior design the new reader never saw. Stated
positively ("co-presence is structural, so the seal only carries
conservation") it reads without back-reference.

**3. `replay` partiality is unstated (lines 376-386).** `replay` can return
`Nothing` (duplicate `Registered`, `Moved`/`Settled` on an unknown unit), yet
the closing paragraph speaks only of it rebuilding state. One clause —
`Nothing` signals an ill-formed stream; a valid stream always yields `Just` —
would close the gap and pre-empt the reader's question.

## Noted, not charged as overclaim

The multi-instrument reification is load-bearing for the headline "exactly
three homes" claim and is assumed, not proved (lines 64-67, 100-101, 156-161).
This is flagged honestly three times and scoped out, so it is not overclaim;
it is a known open lemma, correctly labelled.
