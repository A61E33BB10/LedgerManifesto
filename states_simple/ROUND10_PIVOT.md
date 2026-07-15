# Round-11 pivot — fix the third home's justification (the persistent residue)

After ten rounds the correctness lenses (formalis, minsky, milewski) call the document OBVIOUS,
but five clarity lenses (karpathy, chris-lattner, henri-cartan, dirac, jane-street) hold NOT-YET on
**one concentrated issue**: *why Terms is a separate home from Status is not obvious in one pass.*
The current draft justifies it with a "past-dated boundary read" test, which is the root defect.
Pivot the exposition as follows. This changes only how the solution is presented; the solution —
three homes, two maps, no fourth — is unchanged, and every KEEP item in `SOLUTION_ESSENCE.md`
stays. Full round-10 residue: `rounds/round_10/_pooled_residue.md` (address every item).

## Pivot 1 — Discriminate Terms from Status by AUTHORITY, not by a boundary read (delete the boundary test)
Remove every appearance of the "past-dated value read at the boundary" test, the word
"synchronously", and the "cannot be served by replay" claim. They are out of scope (they lean on an
entitlement mechanism the document excludes), never exercised in-file (every terms value has one
version), and self-contradictory (replay *can* reconstruct a past value). Replace the discriminator
with **provenance / authority**, which is in scope and visible in the types:

- **Terms are externally authored.** The exchange, the contract, the reference-data provider owns
  the truth — multiplier, expiry, ISIN, fee schedule, mandate text. The ledger *consumes* terms; it
  never *creates* them. So when the outside world corrects a term, the ledger **appends a new
  version** and keeps the old one — it does not overwrite, because it is not the author and must
  preserve the authority's history for audit and reconstruction.
- **Status and positions are ledger-authored.** They are produced by the ledger's own events
  (settlements, trades). The ledger owns them, so it **overwrites** status (last settlement wins)
  and **accumulates** positions. Append-only-versioning is unnecessary because the event log already
  is the history.

This is why Terms cannot share a home with Status: they have different **sources of truth**.
Co-mingling an external authority's record with the ledger's own derived record is exactly the
single-source-of-truth violation the whole framework exists to prevent. (Append-only vs overwrite is
then a *consequence* of authority, not the criterion — which answers "disciplines attach to fields,
not maps": the maps are separated by authorship, the discipline follows.)

## Pivot 2 — One organizing principle: a 2×2 the reader can predict (gives inevitability)
State the placement rule once, result-first, as **two questions** that locate any fact:
1. **Does it depend on the holder, or only on the unit?**  (per-`(holder,unit)` vs per-`unit`)
2. **Is it externally authored, or ledger-authored?**  (given from outside vs produced by events)

| | ledger-authored | externally authored |
|---|---|---|
| **per unit** | **Status** (settle price, lifecycle) | **Terms** (multiplier, expiry, ISIN) |
| **per (holder,unit)** | **Position** (balance, cost, HWM) | **— empty —** |

Three cells are populated; the fourth is **structurally empty for one reason**: no external authority
issues a fact about a *specific holder's specific position* — a position exists only because the
ledger's own events created it. Give this single reason; delete the competing "boundary test",
"seal", and "which key may host a definition" arguments. Per-position facts that are set once and
never changed (entry NAV, benchmark NAV at inception) are **ledger-authored write-once fields of the
Position row** — ledger-authored, so they belong to Position, not to a fourth home.

## Pivot 3 — Fix the high-water-mark correctness overclaim (genuine error)
"High-water marks add, summing over holders to total peak exposure" is **false** and must be
corrected: the sum of per-holder high-water marks is an **upper bound** on aggregate peak exposure,
not equal to it (each holder peaks on a different date; the peak of a sum ≤ the sum of peaks). State
only what is true and load-bearing: per-position state **composes** (the Qty monoid: balances add,
and the per-position facts compose holder-by-holder), so conservation is a single fold over the
position map. Drop the "total peak exposure" gloss entirely — it is not needed for the argument and
it is wrong.

## Pivot 4 — Make "no fourth ECONOMIC home" a stated reduction, not an asserted universal
The claim that there is no wallet-keyed economic home depends on: *every economic relationship a
wallet has is to some unit* (a holding, a mandate, a strategy is itself a unit the wallet holds), so
every per-wallet economic fact is a `(holder,unit)` fact and lives in Position. State this as the
framework's modeling stance, with the mandate as the canonical instance (manager issues a mandate
unit to the client, `−1`/`+1`, summing to zero; the client's HWM and entry NAV are facts about its
position in the mandate unit). Do not leave the universal dangling as "admitted unestablished" — own
it as the definitional choice that makes the fourth home unnecessary, and note that what stays
wallet-keyed (KYC, permissions) is identity, not economic state.

## Pivot 5 — Say each conclusion once, result-first
"Three homes, two maps" and the Terms/Status pairing are currently stated three+ times (§2, §3, §4).
State the placement rule and the count **once**, lead with the result, and let §"Why Three" ground
each home by its one small example without restating the conclusion. Expand the compressed slogans
("the multi-unit case is the reification…") into plain declarative clauses.

## Unchanged
Three pages, solution only, no path. Hutton-style Haskell, FORMALIS-cleared (the Haskell is already
cleared and the correctness lenses are satisfied — keep them satisfied; the authority framing does
not change the code, and Pivot 3 is a correctness improvement). The goal remains: a competent
engineer who has never seen this problem reads three pages and calls it obvious.
