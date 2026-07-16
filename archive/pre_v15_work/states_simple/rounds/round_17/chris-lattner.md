# chris-lattner — States.tex, Round 17

Verdict: **NOT-YET**

## What is right

The architecture is sound and the arc is clean: Question → Answer (2×2, three
homes / two maps, derived from two orthogonal questions) → Why Three (one reason
per occupied cell, one for the empty cell) → Construction → Why It Is Right
(conservation, replay). The two axes — "depends on holder?" and "who authors?" —
are genuinely orthogonal and the cell occupancy falls out of them rather than
being asserted. Illegal states are designed out, not policed: `Active Price`
makes "active with no price" unspellable; the non-empty list makes "registered
but versionless" unrepresentable; the sealed constructor leaves "no other door"
for a non-conserving write. The forward-reference / fulfill discipline is mostly
disciplined and signposted. This is close.

Two items keep it from obvious. Both are "said twice," located and actionable.

## Residue

### 1. The holder-in-key justification is derived twice

§why ¶1 (lines 110–114) proves it in full with the concrete case: buyer +1000,
seller −1000, "A unit-keyed value would store one number and collapse the two.
The holder must be in the key."

§Construction "A balance is held by a wallet" (lines 173–175) re-derives the same
conclusion: "Two holders of one unit are two keys, so two balances: the holder is
in the key." This is not a use of the established fact — it re-runs the
two-holders → two-balances → holder-in-key argument that §why already owns. The
construction step only needs to *name* the two-part key (to motivate `WalletId`
and `UnitId`) and cite §why for *why* the holder belongs in it. As written, the
"why" is paid for twice.

Fix: in the construction paragraph, declare the keys and point to §why
("two keys name it — the holder in the key, §why"); drop the re-derivation.

### 2. The conservation base case is stated twice

§Construction (lines 250–251) ends the "three homes, two maps" paragraph with
"`emptyLedger` has both maps empty, so its holding sum is zero --- the base case
for conservation."

§right (lines 343–344) states the same fact as the base case it is: "From
`emptyLedger`, whose sum is zero, every event preserves it, so every reachable
ledger conserves."

The conservation proof's home is §right, and that proof must state its own base
case. The construction's trailing "so its holding sum is zero --- the base case
for conservation" therefore anticipates and duplicates it. The construction
paragraph's job there is to justify the seal; the conservation framing is §right's.

Fix: in §Construction, stop at "`emptyLedger` has both maps empty" (or describe
its role only as "the empty store"); let §right introduce it as the base case.

## Notes (not blocking)

- The benchmark-identity-vs-level aside (lines 88–94) is a deep disambiguation
  for the Answer section, but it does real work defending the authorship
  criterion against the same-provider case, so it serves.
- The "assumed, not proved" caveat for the multi-instrument relationship appears
  at both §Answer (56–58) and §why (148–149). This reads as the announce-then-
  discharge pattern with an honest scope statement at the proof site, not a
  defect; I would not change it.
