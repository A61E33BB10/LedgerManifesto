# karpathy — Round 10 — States.tex

**Verdict: NOT-YET**

The design is right and the code is right. I traced the listings by hand: the
move legs cancel by construction, conservation holds from a zero base under a
sealed constructor with a single `psBal` writer, self/zero moves net to `mempty`
and write no row, and replay is a pure total fold. As an *engineering artifact*
it is sound.

But my bar is not "is it right" — it is "does a first-time reader see *why* it
must hold in a single pass, with no leap of faith and no backtrack." At the
load-bearing step of the argument, the reader stalls. Three located residues,
ordered by weight.

---

## Residue 1 (primary) — the placement test reads as a self-contradiction

**Location: §The Answer, line 84** — "A past-dated boundary read therefore
**cannot be served by replay**."

This single sentence carries the entire 2×2. Terms-vs-Status is decided by it.
And it collides head-on with what the document itself says elsewhere:

- Line 86: status priors are "recoverable offline **by replay alone**."
- §Why It Is Right, lines 388–391: "replay from `emptyLedger` rebuilds every
  unit's terms, status, and positions," and checkpointing "splits at any cut."

So replay demonstrably *can* reconstruct any past value — the document proves it
two sections later. A reader who has absorbed that proof hits line 84, reads
"cannot be served by replay," and must stop, back up, and reconstruct the real
distinction for themselves: replay can produce the value but **not as a
synchronous boundary read** — it is the offline path. The whole force of the
test lives in the word "synchronously" (line 80), which is doing more work than
its placement signals. The reader has to supply "and replay is too slow / not a
boundary mechanism, so a synchronous past-dated demand must be materialized
live" — it is implied, not stated as the pivot.

This is a backtrack, by definition. The test is about **synchronous past-dated
demand**, not about recoverability; written as "cannot be served by replay" it
asserts the opposite of the document's own replay theorem.

**Actionable fix:** state the axis as demand, not capability. e.g. "Replay can
rebuild any past value, but only offline; it is not a read the boundary can
issue synchronously. So a fact with a *synchronous* past-dated boundary read
must have that past value materialized in the live projection (a version list);
a fact whose past values are wanted only offline keeps a single overwritten
scalar and leans on replay." Then line 84's apparent contradiction dissolves.

---

## Residue 2 — the reason for the third home is never visible, only asserted

**Location: §The Answer lines 98–102 (benchmark identity "drives a boundary
entitlement"); §Why Three lines 142–147.**

Terms is a separate home *only* because some consumer issues a synchronous
past-dated read of terms. That is the entire justification for the third home.
But:

- The one concrete instance given — benchmark identity "in force on a past date
  drives a boundary entitlement" — rests on an entitlement mechanism that is
  explicitly **out of scope** (line 144).
- In-file, "every terms value has exactly one version" (line 146), so the
  distinguishing test is **never exercised**. What the file actually shows is two
  *writers* with different disciplines (`appendVersion` keeps, `settle`
  discards) — not the *need* that forces the discipline.

So the reader sees *that* Terms is versioned and *that* the writers differ, but
cannot see *why* Terms must be versioned without taking an out-of-scope domain
claim on faith. The document is honest about this scoping — but honesty about a
gap does not close the gap for the "no leap of faith" bar. The "why" of the
central answer (three homes, not two) is the one thing not demonstrable in the
artifact.

**Actionable fix:** give one *in-scope* past-dated terms read the reader can
verify against the listings (even a worked sentence: "settling a move recorded
under terms version N must value it at version N, read synchronously, after
version N+1 exists"), or state plainly at the point of claim that the third
home's necessity is *assumed* here and only its discipline is exercised — so the
reader knows where trust is being asked, rather than discovering it two
paragraphs later.

---

## Residue 3 (minor) — the empty cell is argued three ways that don't reconcile

**Location: §Why Three, lines 156–162.**

The fourth cell is closed by (a) the boundary test ("none read past-dated"),
then (b) "the seal corroborates" (a second writer would be barred), then (c) a
new framing: "at the fourth cell the question is **instead** which key may host a
definition, and no (holder, unit) fact the ledger holds is one."

Framing (c) introduces a criterion — definition-hood, external-authored vs
ledger-owned — that is used nowhere else as the placement rule. It also reads as
displacing (a) ("the question is *instead*..."). The reader is left unsure
whether the cell is empty *contingently* (no current consumer reads a
(holder,unit) fact past-dated — could change) or *structurally* (a (holder,unit)
fact is never the kind of thing that can be a definition — cannot change). Those
are different claims with different durability, and the paragraph asserts both.
"So three homes are forced, not counted" (line 162) wants the structural reading,
but the boundary-test argument is contingent.

**Actionable fix:** pick the structural argument as primary (a ledger-owned fact
is not an external definition, so the (holder,unit) key cannot host the append
discipline regardless of read pattern) and demote the boundary test and the seal
to one-line corroborations — or drop "instead" and show the two arguments agree
rather than compete.

---

## What is already obvious (credit where due)

- Conservation (§Why It Is Right): single writer, two cancelling legs from one
  quantity, zero base case, sealed constructor — I followed it in one pass, no gap.
- The Position (holder,unit) key argument (lines 120–124): buyer +1000 / seller
  −1000 collapsing to one number — immediate.
- The Status unit-key argument (lines 126–131): per-holder copies free to drift
  = reconciliation break by construction — immediate.
- The non-representability arguments (price riding on `Active`; `NonEmpty` for
  terms; unexported constructors) — each lands without backtrack.

The skeleton is obvious. The *hinge* — the past-dated-boundary-read test that
distinguishes Terms from Status and forces the third home — is where the reader
must take a leap and, worse, reconcile an apparent contradiction with the
document's own replay theorem. Fix Residue 1's wording and surface Residue 2's
trust point, and this reaches OBVIOUS.
