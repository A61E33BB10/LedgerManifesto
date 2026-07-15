# Round-1 fixes — convergence guidance for STYLUS and milewski

The committee returned all NOT-YET with FORMALIS veto. The residue is genuine and consistent. The
fixes below are grounded in the settled source (`_source_v2.tex`, and the "three independent
forcing constraints" argument); adopt them so the next draft converges. The full pooled residue is
in `rounds/round_01/_pooled_residue.md` — address every item; the items below are the load-bearing
ones the whole verdict turns on.

## Fix 1 — The balance IS the primary per-position fact (resolves the "balance vanished" defect)
The held quantity `w(u)` is, by definition, a fact per `(holder, unit)`. So the **per-position home
is the balance map itself, enriched** with the other per-position facts (accumulated cost,
high-water mark). Do not build a separate `Balances` map that then disappears from the assembled
`Ledger`. In the Haskell, `PositionState` carries the balance as its primary field
(e.g. `psBal :: Qty`) alongside `psAc`, `psHwm`; the assembled `Ledger`'s third map is this
`PositionState` map. Conservation is then stated and proved about the actual stored structure:
`Σ_holders position(·, u) = 0`. (Fixes karpathy/chris-lattner/henri-cartan/jane-street on the
missing quantity, and makes the never-held vs held-and-flat accessor land on the home that holds
the balance.)

## Fix 2 — Show `Event` and `apply`; reconcile the `Maybe`
`Event` and `apply` are load-bearing and must appear. `apply` moves quantity as **two cancelling
legs** (debit one holder, credit another), so each event's net change is zero by construction.
Reconcile the failure type honestly: `apply` returns `Maybe`/`Either` because an event can be
**rejected as malformed input** (a reference to a unit that was never registered, a re-registration
of an existing unit id). That is distinct from the conservation claim: a *well-formed transfer*
**cannot be written so as to break conservation**, because the two legs cancel by construction.
State both: ill-formed input is rejected; well-formed input conserves. Do not let the unexplained
`Maybe` sit against the "cannot be written" thesis.

## Fix 3 — Replay determinism comes from purity, not from row retention
Attribute correctly: replay is a deterministic left fold because `apply` is a **pure, total
function of the event and the prior state**; the same events yield the same state from any starting
checkpoint. Row retention (a closed position stays as a zero row, never deleted) is a *separate*
property that keeps the key set stable and serves audit/history — state it on its own grounds, not
as the cause of the fold property. Remove the non-sequitur "so".

## Fix 4 — "Three homes," not "three keys"; the distinction is discipline/authority
Terms and status are **both keyed by the unit** — so "three keys" is false and must not be the
organizing claim. The organizing principle is: state is distinguished first by **what it depends
on** (the unit, or the holder-and-unit), and unit-keyed state is split further by **authority and
change discipline**. State this once, plainly, and let the three homes follow.

## Fix 5 — "Why three" is three INDEPENDENT necessities (own it; do not fake one cleavage)
The source's answer is three *independent* forcing constraints, each shown by a small example — not
one rule that generates three. Present them as such, honestly:
1. **Per-position is forced** because two holders of the *same* unit can hold *different* state
   (A's cost basis 100, B's 120). A unit-keyed value cannot hold both. → a `(holder,unit)`-keyed
   home. (The balance itself is the first such fact — Fix 1.)
2. **Shared status is forced** because some facts are *one value for the whole contract*, read
   identically by every holder (the day's settlement price; the index level). Copying it per
   holder admits divergence — a reconciliation break by construction. → a unit-keyed home holding
   one shared value.
3. **Terms separate from status is forced** because terms are an **external reference authority
   that is never rewritten in place** (multiplier, expiry, ISIN — corrected only by appending a
   new version, for audit and reconstruction) while status is **overwritten on every settlement**.
   One home cannot be both an append-only external authority and an in-place mutable cell without
   conflating the two provenances. → a third home.

Address the implied 2×2 fourth cell head-on (the dirac/henri-cartan point): per-position facts that
are set once and not rewritten (entry NAV, benchmark NAV at inception) are **write-once fields of
the position row**, folded from the event that opens the position. They need no separate append-only
*authority*, because that authority exists only for externally-sourced unit terms. So there is no
fourth map — not by omission, but because the only thing that forces the terms/status split
(external versioned authority) has no per-position counterpart. Say this explicitly so the reader
does not have to wonder.

## Fix 6 — "No fourth" means no fourth ECONOMIC-state home; argue the universal
Qualify the claim precisely and prove the universal rather than asserting it from the mandate
example alone: **every economic fact about a wallet is a fact about that wallet's relationship to
some unit** — a holding, a mandate, or a strategy is itself a unit the wallet holds — hence a
`(holder, unit)` fact, hence a position. There is no economic fact that is about a wallet and no
unit. What remains wallet-keyed (KYC, permissions, audit cursor) is **identity, not economic
state**, and is explicitly out of the three. Use the mandate as the *illustration* of the universal
(manager issues mandate unit to client, `−1`/`+1`, sums to zero; the client's high-water mark and
entry NAV are facts about its position in the mandate unit), not as the whole argument.

## Standing constraints (unchanged)
Three pages, solution only, no path. Every KEEP item in `SOLUTION_ESSENCE.md` stays, exactly as
strong. Hutton-style Haskell: one idea at a time, GHCi evaluations shown, abstractions named only
once earned. milewski clears every listing with FORMALIS before it enters the document.
