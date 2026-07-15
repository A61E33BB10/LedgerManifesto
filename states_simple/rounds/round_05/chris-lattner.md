# chris-lattner — Round 5 — States.tex

## Verdict: NOT-YET

## Lens

Is the solution obviously right? The simple path must be the whole document:
nothing present that does not serve the answer. Reader is a competent engineer
who has never seen this problem.

## What is right

The spine is excellent and I want to be explicit about it, because the residue
is narrow and the rest earns its place.

- The shape of the answer — two distinctions (key: unit vs (holder,unit);
  correction: correctable definition vs superseding observation), a 2x2, three
  occupied cells, fourth empty — is the kind of derivation that makes a design
  obvious in hindsight. It is closed on both excluded keyings (multi-unit folds
  into a unit; holder-alone is identity, not economic state). That is real
  first-principles work, not accretion.
- "Three homes, two maps" is the right architectural move: terms and status
  share a key, so co-presence is the *shape* of the map, not an invariant a
  writer must police. Making an illegal state unrepresentable instead of
  guarded is exactly the discipline I'd insist on.
- The two proofs land. Conservation = single writer (`applyMove`) writing
  paired inverse legs from one quantity, plus a sealed constructor that leaves
  "no other door," inducting from `emptyLedger`. Replay determinism = purity +
  totality + the `foldM` left-fold law for checkpointing. Both are stated as
  properties of *how a field is written*, not of the store type — that is the
  correct mental model and it is held consistently (psHwm adds but carries no
  zero-sum invariant; the point is made cleanly).
- Progressive disclosure is honored: Qty (monoid→group) → pair key → status →
  terms → position → ledger, each piece motivating the next.

## Residue (located, actionable)

**One orphaned step: `Balances` / `holding` is introduced, given the document's
most carefully developed semantic distinction, then discarded by the final
design — and the distinction is never re-homed where state actually lives.**

- Location: "The Construction," paragraph *A balance is held by a wallet*
  (lines 169–187), which declares `type Balances = Map (WalletId, UnitId) Qty`
  and `holding :: Balances -> WalletId -> UnitId -> Maybe Qty`, versus the final
  `Ledger` (lines 254–260) and `applyMove` (lines 292–303).

- The defect: the final `Ledger` has no `Balances` field and no `holding`. The
  position home is `ledgerPS :: Map (WalletId, UnitId) PositionState`. So both
  `type Balances` and `holding` are declared, reproduced from `States.hs` per
  the document's own framing ("the listings reproduce its declarations"), and
  then touched by nothing in the system. Under this document's stated standard —
  "the fewest primitives that suffice; nothing is added that an existing
  primitive already covers" — a lookup over a type the answer abandons is
  exactly the thing the standard forbids.

- Why it bites the reader, not just the linter: the Maybe distinction is the
  document's sharpest single idea — `Nothing` = *never held* (no key), `Just 0`
  = *held, now flat* (key present, zero) — and the text stakes a real claim on
  it: "Settlement entitlement and wash-sale lookback answer the two
  differently; they are never collapsed." That claim is demonstrated on
  `holding`, i.e. on the discarded `Balances`. The final home carries the
  distinction operationally (`Map.findWithDefault zeroP` in `applyMove`
  preserves key-absent vs key-present-zero), but there is no
  `position :: Ledger -> WalletId -> UnitId -> Maybe PositionState` that
  *surfaces* it the way `holding` did. The capability the document promises
  lands on the type it throws away and is absent from the type it keeps. A
  competent engineer finishes the Construction holding two orphaned declarations
  and an open question: "where did never-held vs held-flat go, and how do I
  query a position?"

- Note this is not the same as the deliberately-elided writers (amendment
  events, valuation/HWM). Those are scoped out explicitly and the elision is
  argued. `holding` is not elided — it is fully present, and then unused.

### Fix (either direction closes it)

1. Re-home the distinction: drop `holding`/`Balances`, and provide
   `position :: Ledger -> WalletId -> UnitId -> Maybe PositionState` on the
   actual home, attaching the *never-held vs held-flat* paragraph there. The
   pair key and the Maybe distinction then debut on the map the answer keeps;
   `applyMove` already shows the same key and the same default-zero behavior, so
   nothing is lost from the on-ramp. This is my preferred direction — it makes
   the most-developed idea land on `ledgerPS`.

2. Or make `Balances` load-bearing: define `ledgerPS` in terms of a balance
   layer such that `holding` is the real query path. This is heavier and I'd
   resist it; the enrichment story (`PositionState` = balance + non-conserved
   fields) reads more cleanly than a layered type.

Until the distinction the document spends a paragraph establishing is reachable
on the home the document actually ships, there is machinery present that does
not serve the answer. That is the bar, and it is the only place it fails.

## Bottom line

NOT-YET. Architecturally this is close to obvious — the placement, the
two-maps collapse, and both proofs are right. The single blocker is the
`Balances`/`holding` step (lines 169–187): it is the answer's best idea homed on
the answer's discarded type. Re-home it on `ledgerPS` (or cut it) and I expect
OBVIOUS.
