# Round 3 — MILEWSKI verdict on `states_simple/States.tex` + `States.hs`

**Lens:** Does the Haskell read like Hutton — each step obvious from the last, nothing
assuming the answer in advance, no abstraction (or data) arriving before it is earned — and
does the code obviously support the prose the `.tex` writes about it?

**Verdict: OBVIOUS.** My Round-2 residue is closed exactly as recommended, and a fresh
end-to-end read against the Hutton bar finds no blocking residue. One sub-threshold
observation is recorded below so the committee knows I weighed it and chose not to block.

---

## Round-2 residue: closed

The lone Round-2 finding — `data Lifecycle = Listed | Active | Expired | Closed` carrying two
constructors no writer in the file ever produces, against the file's own "out of scope"
discipline — is fixed by **both** of the options I offered, applied together:

- Narrowed to `data Lifecycle = Listed | Active` (`States.hs:247`, `States.tex:186`).
- The out-of-scope note added (`States.hs:244-246`): the full system has more stages, this
  file carries only the two its writers reach. This now matches the `psHwm` treatment
  (`States.hs:333`) — the thread applies its out-of-scope convention uniformly.

Every value of `Lifecycle` shown anywhere is now writer-reachable: `defaultStatus` yields
`Listed`, `settle` yields `Active`, and there is no third. The closing claim "each fact was
visible in the shape" (`States.hs:665`) no longer has an unexercised counterexample.

## What I re-verified this round (the whole thread)

- **Every abstraction is named only after the thing it names is on the page.** `Qty` group
  with `negQty` — named in step 1 only because step 4's transfer needs cancelling legs;
  `foldMap` — after the `Qty` monoid is established (step 4); `NonEmpty` — earned by "a
  registered unit always has a current version" (step 6); `foldM` — named only once the
  failing left fold is already written (step 9). No abstraction arrives early.
- **The destination is reached, not assumed.** PositionState grows from the bare `Qty` of
  step 3 into a record (step 7) with a stated reason (a non-conserved field beside the
  conserved one); the three maps are assembled in step 8 after each home is independently
  motivated. `psHwm` earns its place: it is the witness that conservation is a *per-field
  writer property*, not a type property, and it justifies why map #3's value is richer than
  `Balances`. Without it the reader would rightly ask why map #3 is not just `Balances`.
- **Conservation framing is the honest one.** Invariant of the writer, not "the type forbids
  the bad value" (`States.hs:459-472`, `States.tex:291-302`): the store type *can* hold a
  non-conserving map; what guarantees conservation is that `applyMove` is the sole writer of
  `psBal`, writes two cancelling legs, and the sealed constructor makes "every reachable
  ledger conserves from `emptyLedger`" exhaustive. Inductive argument is sound — `register`
  and `settle` never touch `psBal`, so they leave every holding sum fixed.
- **Append-only is by construction.** `ProductTerms` exported without its constructor
  (`States.hs:42-45`, header note); `register` now refuses an already-present unit
  (`States.hs:397`), closing the third door that could shorten history. Three doors —
  write-where-nothing, grow, read — none shortens.
- **Replay is a fold and deterministic because `apply` is pure and total.** `Registered` is
  now an event (`States.hs:569`), so replay from `emptyLedger` rebuilds terms, status, and
  positions — "every view is a projection of the stream" is literally true. Checkpoint
  independence is a *genuine instance* of the `foldM` left-fold law, verified executable
  (`States.hs:631,705`), not asserted. Row retention is correctly separated from determinism.
- **Totality / determinism.** No `head`/`fromJust`; `NE.last`, `Map.lookup`,
  `Map.findWithDefault`, `foldM` all total. No clock/IO/randomness in the core; sums are over
  a commutative group, so order-independent.
- **Prose ↔ code agreement.** Every code block in `States.tex` (Qty, Balances/holding,
  Price/Lifecycle/UnitStatus, ProductTerms, PositionState, Ledger, register/settle,
  applyMove, netBal, Event/apply/replay) matches `States.hs`. Every GHCi and `main` output
  I checked by hand against the derived/custom `Show` instances (note the custom
  `Show Qty` printing `1000`, not `Qty 1000`) — all match.

## Sub-threshold observation (non-blocking)

`applyMove` gates on `Map.member u (ledgerPT l)` (`States.hs:443`) while `settle` gates on
`Map.member u (ledgerUS l)` (`States.hs:411`). The two checks are equivalent under the
terms/status coherence invariant (a unit is in the terms map exactly when it is in the
status map), which the file states explicitly and maintains by `register` being the sole
introducer that writes both. So the asymmetry is immaterial to correctness. A first-time
reader doing the line-by-line Hutton read might pause on "why `ledgerPT` here, `ledgerUS`
there?"; the coherence invariant resolves it on reflection. I considered flagging a
one-token consistency edit (gate both on the same map) but judged it below the blocking bar —
forcing it would be manufacturing a finding to avoid staking OBVIOUS. Left to the author's
discretion.

## Scope note

I review representation against the Hutton bar; I do not set the lifecycle vocabulary, the
fourth-cell domain argument, or the retention policy — those are domain facts asserted
elsewhere and read coherently here. My OBVIOUS is on the representation: the types, the laws,
and the thread that builds them.
