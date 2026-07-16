# States.tex — Round 4 review (jane-street-cto lens)

**Verdict: NOT-YET**

The round-3 residue is addressed. The orphaned `appendVersion` is no longer a
silent contradiction: the amendment event that would grow the version list is now
disclosed as out of scope in three places (lines 119–121, 252, 337), and the
replay claim is qualified ("each terms value has one version, replayed from its
`Registered` event," line 338). The document chose round 3's option 2 (explicit
deferral) over option 1 (add the `Amended` event). That stops the self-contradiction.

The core is obvious and needs no commentary: the 2×2 (key × authorship), the empty
fourth cell with the managed-account counterexample dissolved into a (client,
mandate-unit) position (lines 133–138), conservation as a writer invariant on the
single door that writes `psBal` behind a sealed constructor (lines 297–308), and
replay as `foldM` with checkpoint-independence from the left-fold law (lines
315–341). That part holds.

But choosing deferral over the `Amended` event, *combined* with a wording change
in §3, has left the central thesis under-supported. Two residues block the bar.

## Residue

### 1. §3 "Why Three" disarms the necessity of the third home and supplies no replacement — leaving "why not two homes?" unanswerable in-scope (lines 110–121; contrast States.hs lines 304–310)

The section opens "Each occupied cell exists for one concrete reason" (line 94).
Two of the three reasons are hard correctness necessities, and they read as
obvious:

- Position keyed by (holder, unit) — else a buyer's +1000 and a seller's −1000
  collapse to one number (lines 97–100).
- Status keyed by the unit alone — else one settlement price is copied across
  thousands of rows free to drift, "a reconciliation break by construction"
  (lines 103–108).

The third reason — terms separate from status — is not a necessity, and the .tex
now says so explicitly: "a combined cell is spellable, so the split is by
provenance, not necessity" (line 118).

That sentence undercuts the section title against the project's own #2 principle
(minimalism: "the fewest primitives that suffice ... nothing is added that an
existing primitive already covers"). The sibling **States.hs makes the necessity
argument the .tex drops**: line 309 — "A single home that had to admit both writers
would have to be both an append-only record and an overwrite-in-place cell at once.
So terms live in a third map of their own." The .tex deleted exactly the sentence
that makes the third home forced, and replaced it with a disclaimer that it is not.

This compounds with the round-3 deferral. Because the amendment event is out of
scope, "here every terms value has exactly one version" (line 121). So *in scope*,
terms is a single-version `NonEmpty` (effectively one value) and status is one
value — two unit-keyed maps distinguished only by value type and by which writer
touches them. The one thing that would force them apart, a growing version list, is
never exercised; and the prose has just told the reader the split "is by provenance,
not necessity."

A competent reader six months on, holding the minimalism principle, asks: "In
scope, terms and status are both single-value unit-keyed maps, the versioning that
would justify a separate home is deferred, and the text says the split isn't
necessary — so why isn't this one home keyed by the unit, with a sum-typed value?"
The document gives no in-text answer; provenance/auditability (line 78) is asserted,
not shown to *require* separation. That is a margin note on the load-bearing thesis.

**Fix (either):**

1. Restore the disciplinary-incompatibility argument the .hs already has: one cell
   cannot be simultaneously append-only-with-history and overwrite-in-place, so the
   write disciplines force two homes — and drop or recast "by provenance, not
   necessity." This makes "Why Three" deliver three reasons of comparable strength.
2. Or bring the `Amended` event into scope (round 3's option 1) so the version-list
   home is actually exercised; then the third home is necessary *in the shown
   construction*, not merely in an out-of-scope future, and "every view is a
   projection of the stream" becomes literally true for terms corrections — the
   answer consistent with the thesis and with CLAUDE.md.

As written, the .tex states the third home is not a necessity and supplies neither
the disciplinary necessity nor an exercised version list — the weakest of the three
"concrete reasons," disclaimed in its own sentence.

### 2. §2/§3 name position fields that never appear in `PositionState`, and — unlike every other elision — are not marked out of scope (lines 69–70, 128 vs lines 223–225)

The Answer lists a position's contents as "held quantity, accumulated cost,
high-water mark, entry NAV" (lines 69–70) — four fields. The empty-cell argument
adds "entry NAV, benchmark NAV at inception" (line 128). The shown `PositionState`
(lines 223–225) has two: `psBal` and `psHwm`. Accumulated cost, entry NAV, and
benchmark NAV appear in prose and never in the type.

The document is otherwise scrupulous about marking elisions — psHwm's writer is
"out of scope here" (line 218), the amendment event is "out of scope in this file"
(line 120), the valuation event likewise (line 120). The silence on accumulated
cost / entry NAV / benchmark NAV is therefore conspicuous: a reader cross-checking
line 69 against line 223 finds two of four advertised fields missing with no note,
and cannot tell whether they were forgotten or deliberately elided.

**Fix:** either trim the Answer's list to what the construction exhibits ("for
example, held quantity and a high-water mark"), or mark at the construction that
the further position fields (accumulated cost, entry NAV, benchmark NAV) are elided
here, with `psHwm` standing as the representative non-conserved field — the same
out-of-scope marking the rest of the document uses.
