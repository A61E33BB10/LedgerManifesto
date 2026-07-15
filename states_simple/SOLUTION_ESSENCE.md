# Solution Essence — what `States.tex` must keep, and what it must drop (FORMALIS-owned)

`States.tex` states the **solution only**, simply enough that its correctness is self-evident.
FORMALIS guards a narrow line here: the **path** is dropped on purpose, but every **load-bearing
fact of the solution** stays. Dropping the path is not dropping correctness; weakening or hiding a
load-bearing fact to read cleaner triggers the FORMALIS **NOT-YET** veto.

## KEEP — load-bearing facts of the solution (each stated once, plainly)

1. **State lives in three places, and no fourth.**
   - **Immutable, versioned terms** for a unit, shared by all holders (what never changes:
     multiplier, currency, expiry, strike/ISIN, fee schedule, mandate text, benchmark identity).
   - **Shared, mutable status** for a unit: one value seen identically by every holder (what
     changes for the contract as a whole: lifecycle stage, last settlement price, current
     weights, benchmark level).
   - **Per-position state**: one value per `(holder, unit)`, whose accessor distinguishes a
     position **never held** from one **held and now flat**.

2. **No separate wallet-keyed state sector.** Every per-wallet *economic* fact is keyed by a
   mandate or strategy unit and lives in the per-position state (e.g. high-water mark, entry NAV,
   accrued fee for a managed account are `(holder, u_mandate)` facts). There is no fourth
   `WalletState` map. (A wallet-level registry of KYC/permissions is not economic state and is not
   one of the three.)

3. **The never-held vs held-and-flat distinction is essential** and cannot be collapsed: the
   accessor returns "absent" for a position never taken and "present, zero" for one taken and
   closed. Both readings are used (e.g. settlement entitlement vs. lookback); merging them loses
   information.

4. **The three forcing reasons** — each the *single concrete reason that home must exist*, shown
   by a small example, not by elimination:
   - *Per-position exists because* two holders of the **same** contract can hold **different**
     state (different cost / high-water mark); a unit-keyed value would collapse them.
   - *Shared status exists because* one settlement value (the day's settle price, the index level)
     is **one number read identically by every holder**; copying it per holder invites divergence.
   - *Terms are separate from status because* terms **never change in place** (append a version)
     while status **changes on every settlement** — two different change disciplines cannot share
     one home without conflating them.

5. **Why it is right (the consequences must be visibly forced by the structure, in a few lines):**
   - **Conservation** `Σ_holders position(·, u) = 0` for the conserved quantity: each event moves
     quantity between named holders, so every event's net change is zero, and the sum stays zero.
   - **Deterministic replay**: per-position rows are retained (a closed position stays as a zero
     row, not deleted), so replaying the events is a plain left fold — the same events give the
     same state regardless of where you start. This is what makes the omitted proofs unnecessary:
     the reader *sees* conservation and replay follow from the shape.

6. **The mandate/strategy as a unit** may be used as the small example that grounds reason 2's
   "no fourth sector": the manager issues a mandate unit to the client (`−1` to manager, `+1` to
   client, summing to zero), and the client's economic state for that mandate is a per-position
   fact — so it needs no wallet-keyed sector. Keep this only as far as it makes the third home and
   the absence of a fourth obvious; do not import the full managed-account treatment.

## DROP — the path (must NOT appear)

- The Pareto frontier; the rejected designs (the sentinel-unit design, the four-map design, the
  sheaf design, the universe-wallet design) and every elimination argument.
- The condition catalogue `C1`–`C12` presented as a list; the iteration log; the count of review
  rounds; the 27-round provenance; private labels for discarded ideas.
- The risk register `F1`–`F8`; mutation-score numbers; the TLC state-count.
- The four test cases as an enumerated case study (a *small example* may be used to ground a
  forcing reason, but not the catalogue).
- Any "we considered X and rejected it" reasoning. The document shows why the answer is right, not
  why other answers are wrong.

## The standard
The document is **done** when a competent engineer who has never seen this problem, reading only
these three pages, calls the solution obvious and reaches for no further justification — when the
structure so plainly forces conservation and deterministic replay that the dropped proofs are not
missed. Simplicity that costs a KEEP item is not the goal; **obvious *and* right** is.
