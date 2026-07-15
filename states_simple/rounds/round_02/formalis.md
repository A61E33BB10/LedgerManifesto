# FORMALIS — Round 2 verdict on `States.tex`

**Verdict: NOT-YET**

## What Round 1 fixed (acknowledged)

The two Round-1 vetoes are resolved, cleanly.

- **Conservation is now visible on the assembled object.** `PositionState` carries
  `psBal :: Qty` as its primary field (lines 198–201); `applyMove` writes the two
  inverse legs (`negQty q`, `q`) directly into `psBal` of `ledgerPS` (lines 235–244);
  the conservation paragraph (257–268) reasons about `psBal` and `netBal` folds it
  (271–273). The conserved object no longer vanishes between the toy `Balances` and
  the real `Ledger`. The argument — sole writer + cancelling legs + sealed
  constructor + zero-sum start — is evident and correct.
- **The "every event is a transfer" overclaim is gone.** `Event`/`apply` are shown
  (279–285); the text now correctly says a settle "moves no quantity and leaves the
  sum untouched" (264, 267–268).

The KEEP items are otherwise present and intact: three homes and no fourth (§The
Answer; 74–79), the empty fourth cell argued (111–121), the three forcing reasons
by example (89–121), never-held vs held-and-flat (153–159, 295–296), mandate-as-unit
(116–121). No path leaked in.

## Residue 1 — replay cannot reach a non-trivial ledger; "projection of the stream" is not visibly true (BLOCKING)

The replay section closes the event vocabulary to two constructors:

```
data Event = Moved Move | Settled UnitId Price        -- line 279
```

But both state-changing writers gate on prior **registration**, which no `Event`
performs:

- `settle` requires `Map.member u (ledgerUS l)` (line 224);
- `applyMove` requires `Map.member u (ledgerPT l)` (line 237);
- the only writer that creates `ledgerPT`/`ledgerUS` entries is registration
  (line 217), and registration is **not** a constructor of `Event`.

Consequence, traced on the structure as shown: from `emptyLedger`, replaying any
`[Event]` yields either `emptyLedger` unchanged or `Nothing` — every `Moved` fails
the `ledgerPT` membership test and every `Settled` fails the `ledgerUS` membership
test, because nothing in the stream ever registers a unit. So the claim at lines
295–296 —

> "replay rebuilds status with positions: every view is a projection of the stream"

— is not visibly true. Status is *not* rebuilt by replay from the empty ledger; it
must be pre-seeded into `l0`, and terms are never in the stream at all. Under the
structure shown, terms and the initial status are **boundary inputs, not
projections of the event stream**. The blanket "every view is a projection of the
stream" hides that boundary.

This is load-bearing: "every view is a projection of the single stream" is the
foundational promise the ledger rests on (it is what makes internal reconciliation
failure impossible). Stated without the registration caveat, the promise reads
cleaner than the structure earns.

## Residue 2 — "event" is used in two incompatible senses (BLOCKING, same root)

The defect surfaces a terminological slip between two sections that assume opposite
answers to "is registration an event?"

- §Conservation (line 264): *"From `emptyLedger` … every event preserves it, so
  every reachable ledger conserves."* For any reachable ledger to contain a
  registered unit, registration must count as one of the "events" being folded —
  i.e. registration is in the stream.
- §Deterministic replay (line 279): `Event` is a closed ADT of `{Moved, Settled}`
  — registration is **not** in the stream.

A careful reader cannot hold both. Either registration is a replayable event (then
it belongs in the `Event` type, and §Replay dropped a load-bearing constructor), or
it is a boundary input (then §Conservation's "every event / every reachable ledger"
phrasing, anchored at `emptyLedger`, is loose, and §Replay's "projection of the
stream" overclaims). The reader is left to reconcile it — exactly the "reaching for
further justification" the essence standard forbids.

## Actionable remediation (either branch closes both residues)

- **(a) Registration is an event.** Add a registration constructor to `Event`
  (e.g. `Registered UnitId ProductTerms`) and have `apply` dispatch it. Then replay
  from `emptyLedger` genuinely reconstructs terms, status, and positions, and
  "every view is a projection of the stream" becomes literally true and visibly
  forced; align §Conservation's "every event" with the now-complete `Event` type.
- **(b) Registration is a boundary input.** State once, plainly, that registration
  seeds terms/status from the external reference-data authority (out of scope), and
  scope the projection claim to: *given the registered units, status (via settle)
  and positions (via moves) are projections of the move/settle stream.* Then make
  §Conservation say "from a registered base ledger" rather than anchoring "every
  reachable ledger" at `emptyLedger` via "every event."

Either is a few lines and costs none of the path.

## Standard not yet met

Conservation is now evident. Replay's determinism and checkpoint-independence
(`foldM` over concatenation, purity) are evident and correct. But the replay
section's headline — that every view is a projection of the stream — is contradicted
by the closed `Event` type, and "event" carries two meanings across the two proof
sections. A competent reader hits this gap and reaches for justification the
document does not supply.
