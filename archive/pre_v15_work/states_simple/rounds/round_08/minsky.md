# minsky — Round 8 — States.tex / States.hs

**Verdict: NOT-YET**

My lens: the types must make the illegal states *visibly* impossible — the reader sees
it, not takes it on faith.

## What is genuinely clean (and I credit it)

The marquee type-wins are real and visible to a first-time reader:

- **priced iff active** — `Active Price` puts the price on the only stage that has one;
  "active with no price" and "listed but priced" are unspellable. (States.hs 257, 293-295)
- **registered ⇒ at least one terms version** — `ProductTerms (NonEmpty TermsVersion)`
  with the constructor unexported; "registered but versionless" cannot be written.
- **terms/status co-presence** — one map of pairs; "in terms, not status" has no value.
- **two holders, two balances** — the `(WalletId, UnitId)` key; no collapse.
- **unbalanced move** — `Move … Qty` carries one quantity; `applyMove` derives both legs
  from it (`leg to q (leg from (negQty q) …)`), both written unconditionally inside the
  one `Just` branch. I checked the `from == to` and existing-balance cases: still cancels.

I also verified the seal the soundness arguments lean on: `Ledger` is exported as a type
only (States.hs:60), and `ledgerUnit`/`ledgerPS` are absent from the export list, so no
outside code can lay down a `ledgerPS`. Conservation's "the only door that writes the
balance writes it balanced, and the constructor leaves no other door" is therefore a
finite, checkable argument, not faith. Good. (That `PositionState (..)` *is* fully
exported is harmless: you still cannot inject one into a sealed `Ledger`.)

For these, the document meets my bar.

## Residue (located, actionable)

### R1 — The closing summary tells the reader the opposite of the document's own honest disclosure. (States.hs:737)

Line 737: *"Nothing here had to be asserted; each fact was visible in the shape."*

This directly contradicts States.hs:519-540, where the document itself states — correctly
and admirably — that conservation is **not** carried by the store type: *"the store type …
can perfectly well hold a non-conserving map … Conservation is an invariant of the
writer."* The same is true of append-only history (it rests on the unexported constructor
plus `register` refusing a present unit — an API/seal discipline, not a shape) and of the
registration-gating cross-map invariant ("a position may exist only for a registered
unit", States.hs:499-500, held by `applyMove`'s guard plus the absence of any deleter).

These three are *soundness-argued writer/seal invariants*, not shape-enforced facts. A
reader who reads the summary (and summaries are read — principle: favor readers) is told to
take them as "visible in the shape," i.e. as type-guaranteed, which is exactly the faith my
bar forbids. The body is candid; the conclusion withdraws the candor.

Actionable: reword 737 to separate the two registers — facts made unrepresentable by shape
(the five above) versus invariants held sound by the seal and a single writer
(conservation, append-only terms, the registration gate). The .tex does not commit this
overclaim (it repeats "an invariant of the writer, not the store type" at 349-350,
358-359); only the .hs conclusion does.

### R2 — A zero-quantity move silently pollutes the never-held / held-and-flat distinction the design leans on. (States.hs:515-517; States.tex:318-321)

`leg w d ps = let cur = Map.findWithDefault zeroP (w,u) ps in Map.insert (w,u) (cur {
psBal = psBal cur <> d }) ps` inserts a key for **any** `d`, including `Qty 0`. So
`applyMove (Move u w1 w2 (Qty 0))` conjures flat rows for `w1` and `w2`. Thereafter
`position` returns `Just (… psBal = 0)` — "held and flat" — for a wallet that never held a
nonzero position.

The text makes this distinction load-bearing: *"settlement entitlement and wash-sale
lookback answer never held and held-and-flat differently; the retained row keeps them
apart"* (States.tex:336-337). A `Qty 0` move is well-formed input (the type admits it,
`applyMove` accepts it), so it produces a false "held and flat" — a wash-sale-lookback
false positive — and nothing in the type or the writer guards against it, nor is it
disclosed. This is a representable input corrupting a distinction the design relies on,
which is squarely against the stated ethos.

Actionable, any one of: skip the write when `d == mempty`; reject `Qty 0` at the move
boundary; or state explicitly that "held" means "named in a move" (not "held a nonzero
quantity") and accept the lookback consequence in writing.

## Why NOT-YET rather than OBVIOUS

The shape-enforced facts pass. But the document's own conclusion (R1) instructs the reader
to take the writer/seal invariants on faith as if shape-enforced, and a well-formed input
(R2) can establish a load-bearing distinction that no type or writer defends, undisclosed.
Both are exactly the kind of "seen, not taken on faith" failure my lens exists to catch.
Close R1 and R2 and I expect this reaches OBVIOUS.
