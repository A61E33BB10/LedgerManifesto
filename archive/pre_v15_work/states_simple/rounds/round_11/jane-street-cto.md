# Round 11 — jane-street-cto review of States.tex

Verdict: **NOT-YET**

## What is right (and should not be relitigated)

The core is sound and the code is correct as written:

- `Qty` is a group; `applyMove` writes two cancelling legs from one quantity, so
  conservation is a one-line induction from `emptyLedger`. The self-move / zero-net
  collapse via `insertWith (<>)` to `mempty` and the `writeNet` skip are correct, and
  the prose states them.
- The placement argument (per-unit vs per-(holder,unit); ledger- vs externally-authored)
  is a clean 2x2, and the empty fourth cell is argued, not asserted, with the managed-
  account mandate as the worked instance.
- Terms-as-NonEmpty (append-only) vs status-as-single-value (overwrite) is forced by the
  authorship distinction, and the `Active Price` constructor makes "active without price"
  unrepresentable — the right use of the type system.
- `apply` is total; `replay = foldM (flip apply)`; the checkpoint-splitting claim is the
  genuine `foldM`-over-concatenation law. Determinism is honestly stated.
- Honesty about scope is good: `psHwm` stays zero, the amendment writer is out of scope,
  and these are flagged rather than papered over. No determinism overclaim.

## Residue (located, actionable)

### 1. The "sealed constructor" seal is under-specified; record update is an open door. (PRIMARY)

§"The three homes, two maps": *"The constructor is not exported, so a `Ledger` is built
only by the writers below."* And §"Why It Is Right / Conservation": *"the sealed
constructor leaves no other door."*

In Haskell this is not sufficient. Record-update syntax `l { ledgerPS = bogusMap }`
requires only the **field label** to be in scope, not the data constructor. `Ledger` is
declared with named fields `ledgerUnit` and `ledgerPS`, shown and used throughout the
listings. If those selectors are exported, any importer can rewrite `ledgerPS` on a
`Ledger` obtained from the read API and install a non-conserving map — without ever
touching the constructor. The conservation-by-construction claim then does not hold from
what the tex states.

The property *does* hold, because `States.hs` withholds the selectors too (its export
comment: *"The `Ledger` constructor and its field selectors are deliberately NOT
exported"*, with `productTerms`/`unitStatus`/`position`/`netBal` as the only read API).
But the tex never says the selectors are withheld. The mechanism the tex names
("constructor not exported") is necessary, not sufficient, and a competent Haskeller
reading only the tex will stop and write exactly this margin note before believing
"leaves no other door." That is the commentary the bar forbids.

Fix: in both passages, state that the field selectors `ledgerUnit` and `ledgerPS` are
also not exported (reads go through `position`/`netBal`/`productTerms`/`unitStatus`),
because record update through an exported selector would otherwise bypass the
single-writer discipline. One clause closes it.

### 2. §Answer table lists Status facts the modeled type does not carry, with no elision note. (SECONDARY)

The 2x2 table puts *"current weights, benchmark level"* (and last settlement price)
under **Status**. The construction then defines `UnitStatus { usLifecycle }` carrying
only `Lifecycle`, with price riding on `Active`. The tex explicitly flags elision for
`PositionState` ("any further field is elided") and constrains status to "the two stages
its writers reach" — but never reconciles the table's `weights`/`benchmark level` with a
status type that has no such fields. A reader cross-referencing the table against the
type sees price modeled but weights/benchmark vanished, unexplained.

Fix: one phrase noting the table enumerates the Status *category* and the listing models
a representative slice (lifecycle + settlement price), the rest elided — matching the
treatment already given to `PositionState`.

## Bottom line

The design is right and the code is correct. The block is that the tex's own
justification for its headline guarantee (conservation by construction) rests on a seal
it describes incompletely: "constructor not exported" does not stop record update, and
the tex omits the selector withholding that actually makes the property hold. Close that
clause (and the minor table/type note) and this is OBVIOUS.
