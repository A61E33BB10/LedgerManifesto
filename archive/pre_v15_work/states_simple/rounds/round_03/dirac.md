# DIRAC — Round 3 — States.tex

**Verdict: NOT-YET**

## Lens

Is the three-home structure inevitable — no unexplained special case? The bar is
that a competent engineer who has never seen this problem reads the third home as
forced, not chosen.

## What is already beautiful

The frame is a clean 2×2: key ∈ {unit, (holder,unit)} × retention ∈ {history kept,
overwritten}, three cells filled, one empty. The empty cell predicted-then-checked
is genuinely Dirac-shaped (an absence the formalism forces). Three of the four
boundary arguments are inevitable:

- **Position keyed by (holder, unit)** — buyer +1000 / seller −1000 collapse under a
  unit key. Forced.
- **Status keyed by unit** — per-holder copies of one number drift apart, a
  reconciliation break by construction. Forced.
- **Empty cell** — every position is sourced from the ledger's own move events, so no
  external per-(holder,unit) authority exists to version; the managed-account
  apparent counterexample dissolves into a (client, mandate-unit) position. Forced.

## The residue (located, actionable)

**The split of Terms from Status — the only thing that makes the structure *three*
homes rather than *two* — hangs on an asserted usage claim, not a derived
necessity.**

Location: §The Answer, lines 72–78 ("Retention follows provenance … recovered by
replay when a prior is needed"); §Why Three ¶3, lines 108–117.

The decisive sentence (lines 113–116):

> "Both are rebuilt by replay, yet terms additionally retain their version list in
> the store, **because prior versions are queried directly for audit while a prior
> settlement value is only ever needed as the current projection.**"

This is the load-bearing claim, and it is asserted, not proved. Trace it:

1. The text concedes both histories are rebuilt by replay (line 114).
2. Both histories also arrive as events in the *same* stream: `Registered`/
   `appendVersion` for terms, `Settled` for status (lines 313–314). So terms'
   in-store version list is recoverable exactly as status's prior values are —
   neither is uniquely stream-resident.
3. Therefore the only difference between the two homes at the projection level is
   that one carries a stored version list and the other does not. The minimalism
   argument at lines 116–117 ("each home keeps history one way") is sound *given*
   that the disciplines differ — but it presupposes the very thing in question.
4. Hence the three-ness reduces entirely to: *terms' history must be projected,
   status's need not.* And that reduces entirely to the universal usage claim
   "a prior settlement value is only ever needed as the current projection."

A competent reader will dispute "only ever." Prior settlement prices are routinely
queried directly — yesterday's mark for yesterday's P&L, valuation history,
dispute. If a prior settlement value is ever wanted by direct query, status would
need the same in-store retention as terms by the document's own logic, the two
homes would collapse, and the structure would be two homes, not three. The third
home is thus presented as contingent on an access-pattern assertion, not as
inevitable. That is precisely the unexplained special case the bar forbids.

The project's own first principle ("a claim is proved, not asserted") is what this
sentence violates: the entire cardinality of the answer rests on it.

## Fix (either suffices)

- **Ground the split in provenance as system-of-record, not access pattern.** State
  that terms are corrections received from an *external* authority for which the
  ledger is the system of record, so they must be held as an authoritative
  versioned artifact in their own right — independent of whether anyone queries them
  — whereas settlement prices are the ledger's *own* internal observations, fully
  carried by the stream and projected to current. Make external-vs-internal
  provenance, not "queried directly for audit," the thing that forces retention.
  (The page already gestures at this on line 76; it must do the work, and the
  weaker usage sentence on 113–116 must go.) Note this fix must also answer why the
  external corrections being themselves stream events does not already suffice —
  i.e. why the projection must hold them again.
- **Or prove the usage claim** — show that a prior settlement value is genuinely
  never needed except as the current projection, so that status provably requires no
  versioned home while terms does.

Until the third home is forced by something other than "only ever needed as the
current projection," the structure reads as three-chosen, not three-inevitable.
