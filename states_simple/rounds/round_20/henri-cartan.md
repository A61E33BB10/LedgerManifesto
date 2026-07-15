# henri-cartan — States committee, Round 20

**Verdict: OBVIOUS**

Bar applied: the answer follows from its definitions so directly that the omitted
proof is not missed. Reader: a competent engineer new to the problem.

## What the document claims and how it discharges each claim

Two theses, both grounded:

1. **Placement (three homes, two maps).** A unit's economic state sits in a 2×2
   classified by two questions — holder-dependence (sets the key) and authorship
   (sets the writer) — three cells occupied, one empty.
2. **Construction.** The Haskell achieves conservation and deterministic replay *by
   construction*, not by convention.

### The 2×2 is exhaustive, and its axes are derived, not assumed
The governing rule is a conjunction: each fact has *exactly one home* **and** *exactly
one writer*. Failing a conjunction means failing one conjunct: "keyed wrong" (home) or
"authored wrong" (writer). The two questions are exactly these two conjuncts, so the
"there is no third question" claim follows from the shape of the rule rather than being
asserted. Both axes are binary within the stated scope (one unit, one holder), so the
2×2 is genuinely exhaustive. This is a tight derivation, not a leap.

### The empty cell is argued on its merits, not merely scoped away
The externally-authored (holder, unit) cell is shown empty by a structural point that is
explicitly stated and load-bearing: *who owns the record's history, not who sources the
number*. Every per-(holder, unit) fact named (held quantity folded from moves, HWM from
the valuation event, entry NAV from the opening event) is produced by a ledger event,
hence ledger-authored; an external position statement is a reconciliation input, not an
adopted authority. I stress-tested this with cases a competent engineer would raise —
repo/loan obligations, corporate-action splits, prime-broker reports — and each is
foreclosed by the stated principle (the issuer sources the ratio/number; the ledger
authors the holder-level record). The managed-account "counterexample" is dissolved by
the mandate-unit reification (−1/+1), and the genuinely-different case (a relationship
not reducing to a single (holder, unit) row) is explicitly placed outside §2's scope
rather than silently absorbed. Both "fourths" — the empty 2×2 cell and the out-of-scope
several-units home — are handled distinctly.

### Conservation holds by construction, and the code bears it out
I verified `netDeltas`/`writeNet`/`applyMove`:
- `negQty q <> q = Qty(-n + n) = mempty`; `Qty` is the group claimed (identity `Qty 0`,
  inverse `negQty`, associativity from `Integer`).
- Two distinct wallets net `{-q, +q}`; a self-move collapses via `insertWith (<>)` to
  `{f: mempty}` and writes no row. Either way per-unit deltas sum to `mempty`.
- `applyMove` is the only writer of `psBal`; `register`/`settle` touch only
  `ledgerUnit`. From `emptyLedger` (net zero), every event preserves the per-unit sum,
  so every reachable ledger has `netBal l u = Qty 0`. The sealed constructor and
  withheld field selectors leave no other write door, and the document names the precise
  bypass it forecloses (record update through an exported selector).

The conservation invariant's *value* (per-unit holder-sum is zero) is left implicit, but
it is immediate from `netBal`'s definition plus "sum unchanged from zero." A reader does
not miss a proof here.

### Determinism holds, and the Event set matches the writers
`apply` is pure and total (each writer returns `Maybe`, no partial patterns, no
divergence); `replay = foldM (flip apply)` halts at the first refusal. The `Event` type
carries exactly the three writers exercised; `appendVersion` is out of scope, so every
terms value has one version, consistent with "rebuilds every unit's terms (one version
each)." Ill-formed streams (repeat registration, move/settle on an unregistered unit)
return `Nothing`. Checkpointing rests on the `foldM`-over-concatenation law, a standard
and true monad law, invoked by name — acceptable for the reader.

### Other code points checked, all consistent
- `register` refuses a present unit; `settle` adjusts only `snd` of the pair; both gate
  on membership.
- "Held and flat" vs "never held": first touch writes a row, close-out leaves `psBal`
  zero, never deletes — `position`'s `Maybe`/zero distinction is real and used.
- `ProductTerms` constructor unexported protects the append-only discipline; `Ledger`
  seal protects conservation; `psHwm` is an explicitly-flagged out-of-scope placeholder
  (`mempty` throughout), present to witness that the Position home can carry a
  non-conserved fact.

## Non-blocking observations (recorded, not residue)
- The universal "every economic fact is a (holder, unit) or unit fact" is scoped by the
  reification, which is mildly self-selecting; the document is upfront about this and
  bounds it in §3.
- The conservation invariant's zero value is implicit rather than stated.

Neither is a missed proof. Each contestable step is either derived, demonstrated against
the code, or explicitly scoped — there is no omitted proof a competent reader would
reach for and find absent.

**OBVIOUS.**
