# jane-street-cto — Round 14 — States.tex

**Verdict: NOT-YET** (one located, actionable residue)

## What I checked and found sound

The core is correct and self-contained in the .tex:

- **Conservation.** `applyMove` is the sole writer of `psBal`; it lays down two
  inverse legs (`negQty q`, `q`) summed per wallet, so each move changes the
  per-unit holding sum by `mempty`. `register`/`settle` touch only `ledgerUnit`.
  From `emptyLedger` (sum zero), every reachable ledger conserves. The sealed
  constructor + withheld field selectors close the other doors. `netBal` is the
  witness. The self-move and zero-move cases (legs land on one wallet, cancel to
  `mempty`, write no row) are handled and explained. Solid.
- **Determinism.** `apply` is pure and total over the three events; `replay` is a
  `foldM` that halts at the first refusal. Checkpointing rests on the monadic
  left-fold split law. Correct.
- **The 2×2 → three homes.** The two placement questions (holder-dependence;
  authorship) are crisp, the table is consistent with the listings, and the
  fourth (empty) cell is argued from "no authority issues a fact about one
  holder's position," with the custodian-statement and managed-account
  counterexamples addressed.
- **Type discipline carried correctly elsewhere.** `Price` as a distinct newtype
  with neither identity nor inverse; `Lifecycle = Listed | Active Price` making
  "active with no price" unspellable; `ProductTerms` as a non-empty list with an
  unexported constructor; co-presence of terms+status carried by the pair shape,
  not policed. The `position` `Maybe` distinction (never-held vs held-and-flat)
  is well drawn and motivated (settlement entitlement, wash-sale lookback).

The multi-instrument **reification** is explicitly flagged as "assumed here, not
proved" (§Answer; §Why It Is Right, managed-account paragraph). That is honest
scoping, not an overclaim, and the reader is told exactly what rests on it. Not a
blocker.

## The residue

**`psHwm :: Qty` is left unreconciled with the .tex's own type rule for `Price`.**

The .tex establishes a rule and applies it visibly (lines 201–203):

> "A price is a number but not a quantity — never added, never moved between
> wallets — so `Price` is a separate newtype with neither identity nor inverse,
> never summed into a balance."

The stated principle the reader extracts: *a figure that is never summed gets a
type that cannot sum it.* The .tex then says of the high-water mark (lines
240, 244–249):

> "`psHwm` is also a `Qty`, but no move writes it as two cancelling legs, so it
> carries no zero-sum invariant … and no aggregate over holders is claimed for
> it."

So `psHwm` is, by the .tex's own words, a never-aggregated figure — yet it is
given `Qty`, which *does* have identity and inverse and *can* be summed into a
balance. Applying the rule the document just taught with `Price`, a competent
reader expects `psHwm` to be a non-summable type and instead finds the summable
one, with no sentence explaining the asymmetry. The reader stops and writes the
margin note: *"why is the high-water mark a `Qty` when `Price` got its own type
for the same reason — never summed?"* That is precisely the commentary the bar
forbids.

This is not an invented concern: `States.hs` (lines 579–591) contains the exact
reconciliation — "a high-water mark *is* a quantity, and it combines with the
same monoid … adding high-water marks is legal … a separate newtype would only
decorate, and we do not add it." That paragraph answers the reader's question.
The .tex dropped it. The fix is to port one compressed sentence of that rationale
into the §Construction "A position carries more than a balance" paragraph (state
that an HWM is genuinely a quantity and summing them is legal-but-unclaimed, so
no distinct type is warranted) — or, if the design instead intends HWM to be
non-summable, give it a `Price`-style newtype. Either way the .tex must close the
gap it currently leaves to `States.hs`.

- **Location:** lines 201–203 (Price rationale) vs. lines 240, 244–249 (`psHwm`).
- **Blocker:** the never-summed → distinct-type rule the .tex teaches with
  `Price` is silently violated for `psHwm`, and the .tex offers no reconciliation;
  the reader must consult `States.hs` or annotate to resolve it.
