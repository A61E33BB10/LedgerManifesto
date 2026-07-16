# Round 2 — MILEWSKI verdict on `states_simple/States.tex` + `States.hs`

**Lens:** Does the Haskell read like Hutton — each step obvious from the last, nothing
assuming the answer in advance, no abstraction (or data) arriving before it is earned, and
does the code obviously support the prose written about it?

**Verdict: NOT-YET** — one minor, located residue. Everything Round 1 blocked on is fixed;
the rest of the thread is OBVIOUS-grade.

---

## What is now obvious (and was the open question last round)

- **The append-only claim is now true by construction.** `ProductTerms` is exported
  without `(..)` (export list line 41; module header lines 36–39 explain why). The only
  doors are `currentTerms` (read) and `appendVersion` (grow); no importer can lay down a
  fresh one-version value. The Round-1 CRITICAL — the export list defeating the central
  property of the third home — is closed. The .tex carries the same `-- constructor not
  exported` note (line 184), so prose and code agree.

- **The overwrite discipline that forces map #3 now has a witness.** `settle` (lines
  390–395) overwrites `usLastSettle` and discards the prior price, set directly against
  `appendVersion`, which keeps every prior term. The "append vs overwrite" contrast — the
  load-bearing *why three, not two* — is now shown in code, not merely told. Round-1 MEDIUM
  closed.

- **`Price` earns its newtype as a deliberate *absence*.** Step 5 (lines 233–239) makes
  `Price` a non-monoid, non-group on purpose: a price is never summed into a balance, a
  balance never mistaken for a price. This is restraint, not decoration — the only type
  carrying the group structure is the one that conserves.

- **The thread shape holds throughout.** `Qty` as a group with `negQty` named only because
  step 4's transfer needs cancelling legs; `foldMap` introduced after the monoid is on the
  page; `NonEmpty` earned by "always has a current version"; `foldM` named only once the
  failing left fold is already written; `Ledger` sealed with the terms/status coherence
  argued from the sealing. The conservation framing is the honest one — *invariant of the
  writer*, not "the type forbids the bad value" (lines 440–451), with the two qualifications
  stated. The checkpoint law `replay (xs<>ys) = replay xs >=> replay ys` is a true instance
  (line 581), not an assertion. Totality holds (no `head`/`fromJust`; `NE.last`,
  `Map.lookup`, `Map.findWithDefault`, `foldM` all total). Determinism holds (no IO/clock/
  randomness in the core; sums over a commutative group). I checked every GHCi and `main`
  output by hand against the derived `Show` instances — all match.

---

## MINOR — `Lifecycle` carries two constructors the thread never produces

`States.hs` line 241:

```haskell
data Lifecycle = Listed | Active | Expired | Closed deriving (Eq, Show)
```

`defaultStatus` yields `Listed` (line 251); `settle` yields `Active` and only `Active`
(line 395). No function in the file ever produces `Expired` or `Closed`. The close-out
walkthrough (lines 514–528) drives a position flat (`psBal = 0`) but leaves its lifecycle
at `Active` — so a reader meets a constructor literally named `Closed`, watches a close-out,
and never sees `Closed` set. Under the Hutton bar this is the one place data arrives without
being earned: a sum case present in the type but never inhabited by the code, and never
transitioned to.

What makes this a residue rather than a nit is that the file has *already established the
device that would resolve it*. For `psHwm` it writes, plainly, that the field is set by a
valuation event "out of scope for this file" (line 333), and for the managed-account
high-water mark it explains the same. The unused lifecycle stages get no such note. The
thread applies its "out of scope" discipline to one unearned field and not to the other,
which is an internal inconsistency in the thread's own method — and it slightly undercuts
the closing sentence "Nothing here had to be asserted; each fact was visible in the shape"
(step 10, line 612), since `Expired`/`Closed` are asserted in the type without being visible
anywhere in the shape.

**Actionable fix, either:**
1. Narrow the illustrative enum to what the thread exercises — `data Lifecycle = Listed |
   Active` — restoring Minimalism (fewest constructors that the thread earns); or
2. Add the one-line note already used for `psHwm`: that expiry and close-out are the
   remaining lifecycle transitions, out of scope for this file, so `Expired`/`Closed` stand
   for stages the full lifecycle machine produces.

Either makes the unearned data either gone or accounted for, and the thread is then clean
end to end.

---

## Scope note

I review representation against the Hutton bar; I do not set the lifecycle stages — the set
of legal stages is a domain fact. My finding is not "the stages are wrong" but "two of them
arrive in the code unearned and unexplained, against the file's own out-of-scope
convention." If the domain owner confirms the four-stage enum is the fixed vocabulary, fix
(2) is the right resolution and is a one-line change.
