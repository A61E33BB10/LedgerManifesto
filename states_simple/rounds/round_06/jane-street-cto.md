# jane-street-cto — Round 6 — States.tex

**Verdict: NOT-YET.**

The Haskell is correct: `applyMove` is the sole `psBal` writer and writes two
cancelling legs; `register`/`settle` never touch `psBal`; the sealed constructor
makes the conservation reach exhaustive; `replay = foldM (flip apply)` is pure and
total; the `Maybe` distinction on `position` (never-held vs held-and-flat) is well
motivated. No bug. If the bar were "is the construction sound," this passes.

The bar is higher: a competent engineer, new to the problem, reads `States.tex`
**and writes no commentary to understand it.** Two passages fail that test.

---

## R1 — The empty-cell proof shifts its classifying axis mid-argument (§Why Three, lines 132–146)

§The Answer fixes the two axes precisely (line 55): state is distinguished "first by
what it depends on [key], then by how a correction to it is recorded [append vs
overwrite]." The whole 2×2 is built on those two axes. Three cells are then filled
by exactly that criterion.

The fourth cell's emptiness, however, is proved by a *different* criterion. Lines
133–134 introduce: "A correctable definition is a versioned artifact the ledger
receives at its boundary... the ledger versions what it receives, derives what it
owns." That is an **origin** axis (received-from-boundary vs ledger-authored), not
the **correction-discipline** axis (append vs overwrite) that defined the matrix.
The proof that cell four is empty rests entirely on the asserted biconditional
*versions ⟺ receives, derives ⟺ owns* — which is stated once and never grounded.

This bridge collides head-on with the document's own thesis. §Deterministic replay
establishes that *everything* is a projection of an owned, append-only event stream.
So the ledger plainly **does** keep an append-only history of things it owns (the log
itself; and the terms version-list is a projection of owned `Registered` events). A
reader will ask the obvious question: if owned state can be append-only (the log is),
why can a (holder,unit) fact never be a "definition"? The real answer — terms carry
boundary-originated *payload* while positions are *folded* from authored moves — is a
payload-origin distinction the text never cleanly separates from the correction
axis. The tell is line 139–141, where the prose must actively defend against the
collision: "This does not reopen authorship..." When a spec has to fend off a
confusion in-line, the confusion is real and the reader is already writing the note.

Actionable: either (a) prove the bridge — show that on the (holder,unit) key every
fact is folded-from-authored-events and therefore has no received version to keep,
making "definition" *impossible* under the **same** correction-discipline axis the
matrix is built on; or (b) state explicitly that the fourth cell is excluded by a
third consideration (payload origin), not by the two matrix axes, and that the 2×2 is
therefore not a clean product of its stated axes. As written, the matrix claims to be
a product of two axes but its empty cell is justified by a third.

## R2 — `psHwm` is called a "running peak" but typed and justified as an additive quantity (lines 146, 170, 228–231)

`Qty`'s monoid is addition (line 170: `Qty a <> Qty b = Qty (a + b)`). The high-water
mark is typed `Qty`, started at `zeroP` (the additive identity `mempty`), and its
membership in `Qty` is justified at line 228 as "a high-water mark is a quantity, and
quantities add." Yet line 146 states the field "keeps only its running peak."

A high-water mark combines over time by **max**, not by sum; its identity is −∞, not
0; and 0 is a floor, not a monoid identity for max. Any finance-literate engineer
knows this on sight, so the words "running peak" sitting beside an additive monoid
and the reason "quantities add" read as a contradiction. The text conflates two
different combinings: across-holders aggregation (a sum — the `.hs` calls it "total
peak exposure") and across-time ratcheting (a max — the "running peak"). The stated
justification ("quantities add") is the wrong operation for the property named
("running peak"), and the reader must disentangle this unaided.

Because the field stays zero and its writer is out of scope, nothing *manifests* —
this is a clarity defect, not a bug. But it is exactly the kind of seam that gets a
margin note. The honest framing is: `psHwm` shares `Qty`'s representation (same minor
units) to exhibit a non-conserved field beside the conserved balance; its combining
operation (max) is deferred with its out-of-scope writer. Say that. Do not justify
the field by "quantities add" when the property you have named combines by max.

---

Fix R1 (the load-bearing one) and R2, and this is OBVIOUS. The skeleton is right;
two passages overstate what they have proved and make the reader do the
reconciling.
