# karpathy — States.tex, Round 15

**Verdict: OBVIOUS**

Bar applied: a competent engineer new to the problem sees *what* the answer is and
*why it must hold* in a single careful pass — no leap of faith, no backtracking.

## What I checked

I read `States.tex` end to end, then verified the listings against the authoritative
`States.hs` (which is runnable, carries GHCi traces and a `main`) and re-derived the
code's correctness myself rather than trusting the prose.

### The answer is stated result-first and is genuinely forced

- The classification is a clean 2×2 on two orthogonal questions — *depends on holder?*
  and *who authors the record?* — yielding Status (unit / ledger), Terms (unit /
  external), Position (holder+unit / ledger), and an empty fourth cell. The reader can
  hold both axes at once; the table is not a leap.
- Each occupied cell's necessity is given concretely, not asserted:
  Position keyed by (holder,unit) because buyer +1000 / seller −1000 collapse under a
  unit key; Status keyed by unit alone because per-holder copies of one settlement
  number drift into a reconciliation break; Terms split from Status because append-only
  (external authority, history preserved) and overwrite-in-place (ledger) cannot be one
  value. These land instantly.
- "Three homes, two maps" resolves: Terms+Status share the unit key and ride as a pair
  `(ProductTerms, UnitStatus)`, so co-presence is the *shape* of the map, not a policed
  invariant. Two maps for three homes is then self-evident from the differing key types.

### The code is correct (verified, not trusted)

- `netDeltas`/`writeNet`: ordinary move (f≠t) writes {−q, +q}; self-move (f==t) collapses
  to `mempty` via `insertWith (<>)` and is skipped; `Qty 0` move skipped on both legs.
  Every case sums to `mempty` per unit. Confirmed by hand against the `insertWith`
  combination order.
- Conservation: `applyMove` is the only writer of `psBal` and writes two cancelling legs;
  `register`/`settle` touch only `ledgerUnit`. From `emptyLedger` (sum zero), induction
  over the sealed reach gives `netBal l u = mempty` for every reachable ledger. The seal
  argument preempts the obvious bypass (record update through an exported selector) — no
  open door remains.
- Totality: no partial functions; `NE.last` is total on `NonEmpty`, all `Map` ops total,
  `apply` returns `Maybe` rather than throwing. Determinism + checkpointing follow from
  purity and the `foldM` left-fold law, both correctly invoked.
- Append-only Terms holds by construction: constructor unexported, `register` refuses a
  present unit, `appendVersion` only grows — and since `ledgerUnit` is unexported, no
  external `Map.insert` can overwrite an entry. Closed loop.

### Shape-guarantees vs writer-invariants are kept distinct

The document explicitly separates facts the *type* makes unrepresentable (price rides on
`Active`; `NonEmpty` terms; pair co-presence; two-legs-from-one-quantity) from facts that
hold only by a writer/seal soundness argument (conservation, append-only, the
unregistered-unit gate). The reader is never asked to take a writer discipline on faith as
though it were a shape. This is exactly the right disclosure and it is the main reason the
piece clears the bar.

## On the one acknowledged gap (not a defect in obviousness)

The "no fourth home" claim is proved only for the single-mandate case (n=1) and is
*explicitly* marked conditional on the reification for the multi-instrument case
("assumed here, not proved", §why and §answer). This does not violate the bar: the leap is
named and quarantined, not silently required. The reader sees precisely what is proved and
what is assumed, so nothing must be taken on faith without notice. Honest scoping, not a
hidden hole.

## Minor friction (does not break the single pass)

- §Answer's "assumed for one spanning several instruments" is opaque until the end of
  §why, but it is flagged "assumed," so the reader need not resolve it to proceed.
- `psHwm` is always zero within scope (its valuation-event writer is out of scope); a
  reader may find the field idle, but its purpose — exhibiting a non-conserved field
  beside the conserved balance — is stated, so it is justified, not mysterious.

Neither forces backtracking to make an earlier claim true; the forward references expand,
they do not retroactively repair. The prose is dense (deliberately compressed), but it is
deductive and result-first throughout, and a careful single pass extracts the answer and
its necessity.

**OBVIOUS.**
