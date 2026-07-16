# henri-cartan — States.tex, Round 1

**Verdict: NOT-YET**

My bar: the answer follows from the document's own definitions so directly that
the omitted proof is not missed. It does not. The two formal results
(conservation, replay) are close to self-evident, but the *central thesis* — three
homes, no fourth, organised by key — is contradicted by its own construction and
rests on undefined terms. Located residue follows.

---

## R1. "Each with its own key" is contradicted by the construction.

Line 43 states the organising principle: "State lives in three homes, each a
finite map, **each with its own key**." But in the assembled `Ledger`
(lines 191–194):

```
ledgerPT :: Map UnitId ProductTerms     -- keyed by UnitId
ledgerUS :: Map UnitId UnitStatus       -- keyed by UnitId
ledgerPS :: Map (WalletId, UnitId) PositionState
```

Two of the three homes share the **same** key, `UnitId`. So the key does not
distinguish the three homes — there are only two distinct keys. The claim that
"three homes" follows from "three keys" is false on its face, and the reader who
takes line 43 at its word will mis-count. The real distinguishing principle is
update discipline (R2), not the key. The document's own scaffolding ("keyed by
unit / keyed by unit / keyed by (holder,unit)", lines 46–53) repeats this: two
entries begin "keyed by unit." This must be reconciled before "three homes" is
self-evident.

## R2. Terms/Status separation is asserted, not forced.

Lines 83–89: "Append-only and overwrite-in-place are two disciplines; one home
cannot enforce both without violating one of them. So terms and status are two
maps, not one." This does not follow. A single map `Map UnitId (ProductTerms,
UnitStatus)` holds both: the `ProductTerms` field is the append-only `NonEmpty`
already defined (line 168), the `UnitStatus` field is overwritten in place. One
unit-keyed record can carry one append-only field and one overwrite field
simultaneously — the disciplines attach to fields, not to maps. The split into
two maps is therefore a presentation choice, not a forced consequence. The
argument states an impossibility ("cannot enforce both") that is not true, so the
necessity of the second map is not established.

## R3. "There is no fourth home" — the main result — is not derived.

Lines 56–61 and 91–98 carry the thesis. It is a universal completeness claim:
"**Every** per-wallet economic fact is a fact about the holder's position in some
unit." It is supported by exactly one worked case (the mandate, lines 91–98) and
then generalised to "every." One example does not discharge a universal. Worse,
the carve-out depends on an undefined dichotomy: KYC and permissions are excluded
because they carry "identity, not economic state" (line 60). Nowhere is
"economic state" defined, nor the boundary that sorts a fact into economic
(→ position) versus identity (→ excluded registry). Without that definition the
claim is unfalsifiable: any candidate fourth home can be deflected either as "a
position in some unit" or as "identity, not economic." A completeness theorem
whose scope term is undefined cannot be obvious. This is the claim the document
exists to make, and it is the least proven.

## R4. Conservation is proved for code that is not the ledger; `apply` is absent.

Lines 201–206 prove conservation from `transfer` on `Balances :: Map (WalletId,
UnitId) Qty` (lines 144–149), where the two legs are visibly `negQty q` and `q`.
But the ledger of record stores `PositionState` (lines 178–182, 194), and events
are applied by `apply` (referenced lines 213–215) which is **never shown**. The
proof's load-bearing premise, "Every event is a transfer" (line 202), is asserted
of `apply`, not exhibited. Whether `apply` moves `psAc` as two cancelling legs —
and how it touches the non-conserved `psHwm` it sits beside in the same record —
is unverifiable from the text. The conservation argument is sound for the toy
`transfer` and undischarged for the actual structure.

## R5. The `Maybe` in replay is unexplained, and the fold law is stated for the
wrong fold.

`replay` and `apply` return `Maybe Ledger` (lines 213–215), yet the document
elsewhere insists illegal states are unrepresentable and an unbalanced move
"cannot be written" (lines 142, and the project's "illegal states not
representable"). What, then, makes `apply` fail and produce `Nothing`? It is
never said. The checkpoint-independence argument (lines 216–221) invokes the pure
fold/append law ("a fold over a concatenation is the fold of the first part, then
the fold of the second"), but `replay` uses `foldM` in `Maybe`. The corresponding
law holds, but only with failure semantics the prose omits: if the prefix yields
`Nothing` there is no checkpoint to resume from. The conclusion is defensible, but
the stated justification is the law for `foldl`, not the monadic fold actually
written, and the failure mode is left dark. The proof as written does not match
the code as written.

---

## Summary

The replay and conservation results are nearly obvious *for the code shown*, but
the code shown (`transfer` on `Balances`) is not the structure the claims are
about (`apply` on `Ledger`), so R4/R5 leave a real gap. The organising thesis —
three homes distinguished by key, with no fourth — is contradicted by its own
construction (R1), not forced (R2), and not derived (R3). The omitted proofs are
missed. NOT-YET.
