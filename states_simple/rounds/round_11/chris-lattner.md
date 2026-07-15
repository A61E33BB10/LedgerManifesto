# chris-lattner — Round 11 — States.tex

**Verdict: NOT-YET**

The architecture is sound and the construction is clean. The logical spine —
question, 2×2 placement, per-cell justification, construction, proof — is complete and
a competent newcomer can walk it end to end without a gap. The defect is not in *what*
is said but in *where*: **The Answer** and **Why Three** carry the same arguments at the
same altitude. The document has not decided whether The Answer *states and defers* or
*states and argues*, and it does both inconsistently — producing duplication that the
bar "nothing said twice" forbids.

The tell is an asymmetry. In The Answer, **Position** and **Status** are merely *placed*
(table cells); their reasons appear only in Why Three (buyer/seller ±1000; the
settlement price read identically). That is the clean pattern: place here, argue there.
But **Terms** and the **empty fourth cell** are *fully argued* in The Answer **and**
argued again in Why Three. Same proposition, twice, sometimes near-verbatim.

## Residue (located, actionable)

### 1. Terms authorship argument made in full in two places
- §The Answer, lines 92–98 — "How a correction is recorded follows from authorship …
  the ledger appends a new version and keeps the prior, **preserving the authority's
  record for audit and reconstruction** … A single value cannot be at once an
  append-only record and an overwrite-in-place cell, so terms and status are distinct
  values with distinct types — a non-empty version list and a single value."
- §Why Three, lines 124–135 — "a correction from the authority is appended as a new
  version, the prior kept, **preserving the authority's history for audit and
  reconstruction** … so the two are distinct values: a non-empty version list grown by
  `appendVersion`, a single value replaced by `settle`."

This is the same argument (overwrite-vs-append → distinct types) with a near-verbatim
shared clause. **Action:** reduce The Answer to the placement plus the *structural*
consequence that the headline "three homes, two maps" actually needs — terms+status
share the unit key, so they ride as a pair: a third kind of state, not a third map
(lines 98–101). Defer the authorship → correction-recording → distinct-types argument
wholly to Why Three, matching how Position and Status are already handled.
(Minor, same family: "share the key → one map entry, co-present" then appears a third
time in §The Construction, lines 250–258. That instance is closer to
statement-then-implementation, but folding item 1 should keep it from reading as a
restatement.)

### 2. Empty-fourth-cell reason stated in full in two places
- §The Answer, lines 87–91 — "no external authority issues a fact about one holder's
  position. A position exists only because the ledger's own events created it, so every
  per-(holder, unit) fact is ledger-authored …"
- §Why Three, lines 140–148 — "The fourth cell is empty because no authority issues a
  fact about one holder's position … the (holder, unit) key carries only
  ledger-authored facts, the externally authored cell is empty by construction."

Same proposition, near-identical heading sentence. Why Three earns its keep by adding
the concrete custodian/prime-broker concretion; The Answer's full version does not.
**Action:** keep the argument in Why Three; cut The Answer to the one-line placement
claim (the fourth cell is empty), no derivation.

### 3. General framework stance stated twice
- §The Answer, lines 60–65 — "the framework models every economic relationship a wallet
  has as itself a unit the wallet holds: a holding, a mandate, a strategy is a unit, so
  a fact about the relationship is a fact about the wallet's position in that unit."
- §Why Three, lines 155–158 — "This is the framework's stance in general: every
  economic relationship a wallet has is to some unit it holds, so every per-wallet
  economic fact is a position, and no fourth, wallet-keyed economic home is needed."

The Answer already states the general principle and forwards to §why for "the
demonstrated instance." §why should then *deliver the instance* (the managed-account
mandate) and stop — not re-state the general principle it was sent to demonstrate.
**Action:** end the managed-account paragraph at the two-mandates-two-rows point; drop
the "framework's stance in general" restatement.

## Root cause and the single fix
All three are one defect: The Answer over-argues exactly the two decisions (Terms, empty
cell) that Why Three exists to argue, while under-arguing the two (Position, Status) it
correctly defers. Pick one altitude for The Answer — *place the facts, name the
structural consequence the headline needs, defer every "why this cell" to Why Three* —
and hold it for all four cells. That single discipline removes items 1–3 at once and
leaves Why Three as the sole home of justification, with The Answer a clean map of the
2×2.

Once that cut lands, the document is obvious. The bones are right.
