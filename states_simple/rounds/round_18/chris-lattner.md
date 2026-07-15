# chris-lattner — States.tex, Round 18

**Verdict: NOT-YET**

The architecture is sound and the throughline holds: two questions → a 2×2 →
three homes → two maps, then the writers and the by-construction proofs. A reader
new to the problem can follow the spine. The placement answer is right. But the
bar here is "nothing present that does not serve the answer; nothing said twice,"
and the `psHwm` passage fails both.

## Residue

### 1. The `psHwm` typing meditation does not serve "where state lives," and repeats the `Price` rationale (lines 222–242, esp. 230–234)

`psHwm` earns its place as the one concrete witness that the Position home can
carry a per-(holder, unit) fact that does not conserve. That single claim is what
the answer needs. Everything after it in the paragraph is residue:

> "It is typed `Qty` to match its source, yet the file leans on none of `Qty`'s
> group structure for it... `Price` (above) strips the group because a price is
> settled never to sum; `psHwm` keeps its source type because its operation is
> not settled here."

Two distinct problems in this stretch:

- **Does not serve the answer.** This is a defense of an *implementation typing
  choice* — why `Qty` rather than a group-stripped newtype like `Price` — for a
  field that is, by the paragraph's own admission, "never folded over holders, and
  so zero throughout this file." A field that is never written and never read in
  any path is a weak witness defended at length. The placement question ("where
  does this state live") needs the field to *exist* in the Position value; it does
  not need the meditation on why its type retains an algebra the file never uses.

- **Said twice.** The `Price` rationale is already given at lines 192–194: "a
  price is a number but not a quantity --- prices are never added --- so `Price`
  is a separate newtype with neither identity nor inverse, never summed into a
  balance." Line 232 restates it ("`Price` (above) strips the group because a
  price is settled never to sum") to set up a contrast with `psHwm`. The contrast
  itself is the off-topic part; the fact it leans on is already on the page.

**Actionable.** Cut the paragraph to the claim that earns the field: the Position
home carries a non-conserved per-(holder, unit) fact — a high-water mark, written
by a valuation event out of scope here, bearing no zero-sum invariant. Keep the
field in the `lstlisting`; drop the group-structure / `Price`-contrast sentences
(roughly lines 230–234). If the writer wants the field to genuinely witness rather
than assert, the alternative is to exercise it — but for this file's scope,
trimming the prose is the lighter fix and removes both the off-topic weight and
the repeated `Price` rationale.

## Checked and cleared (not residue)

- The empty fourth cell: stated in The Answer (96–97), proved in Why Three
  (133–140). Forward-reference then proof — not duplication.
- Conservation's legs-cancel step (340–349) recapitulates the `applyMove`
  mechanism (289–294). This is a proof appealing to a mechanism established
  earlier; the recap is the inductive step, not a second telling. Defensible.
- The reification premise ("every relationship is a unit") is asserted in The
  Answer, discharged for one mandate and explicitly *assumed* for the
  multi-instrument case (149–150). The gap is disclosed, in scope, and honest —
  not a hidden hole.
- The Construction and Why-It-Is-Right sections serve the thesis: the Question
  (44–48) frames the answer as placement *plus* the discipline that makes
  conservation and replay hold by construction. The writers and proofs are in
  scope of that stated answer.
