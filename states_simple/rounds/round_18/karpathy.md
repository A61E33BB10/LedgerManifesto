# karpathy review — States.tex, Round 18

Verdict: **NOT-YET**

Reader assumed: a competent engineer who has never seen this problem, reading once,
top to bottom, allowed no backtracking and no granted leaps.

## What is genuinely obvious (verified, not taken on trust)

I traced the load-bearing code rather than trust the prose, and it holds in one pass:

- **Conservation.** `netDeltas f t q` builds `{f: -q, t: +q}` for distinct wallets, and
  `{w: mempty}` when `from == to` (the inner `insertWith` lays `-q`, the outer combines
  `q <> (-q) = mempty`). `writeNet` adds each wallet's delta to `psBal` and skips `mempty`,
  so the per-unit holding sum changes by `negQty q <> q = mempty`. `register`/`settle`
  touch only `ledgerUnit`. The sealed constructor + withheld selectors leave no other
  writer. From `emptyLedger` (sum zero), every reachable ledger conserves. Clean.
- **Determinism.** `apply` is pure and total (every branch is `Map`/`NonEmpty` total ops
  returning `Maybe`); `replay` is `foldM (flip apply)`, halting at the first refusal;
  checkpoint-splitting is the monadic left-fold law. Clean.
- **The retained-row distinction** (`Nothing` = never held, `Just` zero = held and flat)
  is correctly motivated and correctly implemented (first touch writes, close-out leaves
  at zero, never deletes).

The architecture (two questions → 2×2 → three occupied cells → three homes / two maps)
is well motivated and the per-cell reasons in §why are concrete. The core answer is right.

## Residue (located, actionable) — why it is not yet *obvious*

### R1 — "Exactly three homes" rests on a granted, unproven premise (primary)

The whole count is conditional on the reification premise: "every economic relationship a
wallet has is itself a unit the wallet holds" (lines 55–59). The answer's completeness —
that there is no *fourth* home keyed by `(holder, several-units)`, hence no third map —
depends on this premise holding for relationships that span several instruments. The
document states plainly (lines 148–150):

> "that a relationship spanning several instruments is likewise a single unit ... is
> assumed here, not proved."

So when the single-pass reader asks the natural question — *why exactly three homes and
not four?* — the answer is "grant the premise." That is precisely a leap of faith on a
load-bearing step. Honest flagging does not convert the leap into a thing the reader can
*see*; it converts it into a thing the reader is asked to accept. Under this bar, that
is the disqualifying residue.

Actionable, two options:
- prove the multi-instrument reification (a relationship over several instruments collapses
  to one `(holder, unit)` row), closing the partition; or
- bound the stated answer so it claims only what is proved — e.g. "three homes for any
  relationship reifiable as a single unit" — so the reader is not asked to grant an
  unproven *completeness* claim while reading the answer as unconditional.

### R2 — The `psHwm` paragraph breaks single-pass flow (secondary)

Lines 222–234 defend, at ~13 dense lines, a field that is `mempty` at creation, never
written by any in-scope writer, never read meaningfully, and never folded (`netBal` folds
only `psBal`). The reader hits an always-zero field and must re-read the paragraph to learn
*why it exists at all* — the Price-vs-Qty group-structure contrast, the "operation not
settled here" justification, and the "no aggregate claim over holders" caveat are all
piled into one breath. The point being made is legitimate (the Position home must
accommodate a non-conserved fact), but the delivery forces backtracking.

Actionable: compress to the single claim it needs — "psHwm demonstrates that the Position
home can carry a non-conserved fact; its writer and summing semantics are a valuation event
out of scope, so it is typed `Qty` and held at `mempty` throughout this file" — and drop
the extended Price/Qty meta-argument or move it to a footnote.

## Noted, not residue

- The empty fourth cell could have invited the objection "a prime-broker position report is
  an externally-authored `(holder, unit)` fact, so the cell is occupied." The document
  pre-empts this in the same paragraph (lines 137–140): such reports are reconciliation
  inputs the ledger checks at its boundary, not records it adopts. Adequately handled.
- Heavy forward-referencing (§answer points to §why and §construction) is the intended
  result-first deductive order, not a defect.

## Bottom line

The mechanism is provably right and reads cleanly in one pass. The *answer* — "state lives
in exactly three homes" — is not obvious in one pass, because its completeness is granted
(R1) rather than shown, and one paragraph (R2) forces a re-read. Fix R1's scoping and
compress R2.
