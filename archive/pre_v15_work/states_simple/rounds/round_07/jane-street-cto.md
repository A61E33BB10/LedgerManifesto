# jane-street-cto — Round 7 — States.tex

## Verdict: NOT-YET

The code in the listings is clean, pure, total, and correct: `applyMove` is the
sole `psBal` writer and writes two cancelling legs, the sealed constructor closes
the conservation argument, `replay` is a pure `foldM`, and the `Maybe` on
`position` carries a real three-way distinction. The core is genuinely obvious.

But two located items force a new reader to stop and write commentary. The bar is
"obvious, no commentary needed." It is not yet met.

---

## Residue 1 (primary, code/types) — `psHwm` is typed `Qty`, whose monoid contradicts the field's stated semantics

**Location:** States.tex lines 182-187 (`Qty` monoid = addition), lines 244-246
("its combine over time is the running maximum, not addition"), lines 248-253
(`psHwm :: Qty`, `zeroP = PositionState mempty mempty`).

**The problem.** `Qty`'s only `Semigroup`/`Monoid` is addition (`Qty a <> Qty b =
Qty (a+b)`, `mempty = Qty 0`). The prose then states the real combine of `psHwm`
is the running maximum, "not addition." So the type advertises exactly the wrong
operation for the field. A reader sees two fields, `psBal :: Qty` and `psHwm ::
Qty`, both seeded `mempty`, and **cannot tell from the types** that one conserves
(additive legs) and one does not (max). They must read the prose disclaimer
"shares only `Qty`'s representation" to learn that the type's own `<>` must not be
used here. That disclaimer lives in prose, not in the type — a direct inversion of
this design's first principle (illegal states unrepresentable; types as the first
line of defense). A maintainer who later `foldMap`s `psHwm`, or reuses `Qty`'s
`<>`, gets silent addition where max was meant.

**Corroboration that this is unsettled, not merely terse.** The canonical
`States.hs` (which the .tex names as the source, line 174) argues the *opposite*:
its lines 542-543 say "a high-water mark is a quantity, and high-water marks add
... a newtype to mark psHwm non-conserved would only decorate." The .tex says the
combine is max; the source says it adds. The two artifacts disagree on the one
fact that determines whether `Qty` is the right type. A high-water mark is the
running *maximum* of a value (peak NAV) — it does not add — so the .tex's
semantics are right and the type is wrong. Either way, the question is open, and an
open question at the type level is not obvious.

**Actionable fix (pick one):**
- Give the mark its own type, e.g. `newtype Hwm = Hwm Integer` with a `Max`
  `Semigroup` and the correct identity, so the type states the combine and `zeroP`
  cannot seed it with the additive zero. This is the principled fix.
- If the field must stay inert for this file's scope, drop `psHwm` entirely and
  make the "conservation is a writer property, not a store-type property" point in
  prose alone. A type-lying placeholder is worse than no placeholder.

A seed of `Qty 0` for a max-field is independently suspect: the identity of max is
not the additive zero, and a non-negative floor on the mark is a real future bug if
the mark can go negative.

---

## Residue 2 (secondary, prose) — the empty cell is promised "one reason" and given two

**Location:** States.tex lines 110-111 ("Each occupied cell exists for one
concrete reason; the empty cell is empty for one") versus lines 141-159.

**The problem.** The fourth-cell paragraph is titled "empty by the seal, not by
survey" and argues from the seal (admitting a definition on the (holder, unit) key
"would open a writer beside `applyMove`, breaking the seal"). It then gives a
*second, independent* reason: "None is wanted in any case ... by minimalism the
recoverable and unaudited is never versioned." Two distinct justifications (seal;
minimalism) are offered for a cell the document just promised is "empty for one."
A careful reader notices the count mismatch and must decide for themselves which
reason is load-bearing — that is commentary the text should have removed.

**Actionable fix.** Commit to the seal as *the* reason and present minimalism as a
corollary ("and were the seal not decisive, minimalism would still bar it"), or
amend line 110-111 to stop promising a single reason for the empty cell.

---

## What is done well

The conservation argument is airtight and reader-checkable: single writer, two
cancelling legs from one quantity, sealed constructor, `emptyLedger` base case.
`register`/`settle`/`applyMove` each return `Nothing` for exactly one named
failure, and lines 318-321 pre-empt the obvious reader question ("the `Maybe`
guards input, not the balance"). The `position` three-way distinction
(never-held / held / held-and-flat) and its justification via row retention is
exemplary — that is the part a 3am debugger most needs, and it is spelled out.
Fix the `psHwm` type and the empty-cell reason count, and this reaches OBVIOUS.
