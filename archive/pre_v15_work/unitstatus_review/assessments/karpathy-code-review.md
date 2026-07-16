# UnitStatus: mutable store, or materialised projection?

**Reviewer lens:** simplicity — one mechanism (fold over the log) versus two (a
mutable store *plus* the log). Does the mutable store earn its place, or does it
add a second source of truth that can disagree with the log?

**Recommendation: DERIVED PROJECTION.** UnitStatus is a pure fold of the
immutable event log, materialised in a mutably-overwritten cell as the running
accumulator. Its "mutability" is a storage discipline, not an authority claim.
The word "mutable" in the two state tables is a wording hazard that invites the
wrong reading; the underlying design is correct and must not be changed.

---

## 1. The two readings, stated as code

Strip the prose and there are exactly two implementations behind the same label.

**(1) AUTHORITATIVE-MUTABLE.** `UnitStatus[u]` is a source of truth. Some writer
does `status[u].stage = EXPIRED` in place. The log, if any, is secondary. Once
the cell is overwritten the prior value is gone.

**(2) MATERIALISED PROJECTION.** `UnitStatus[u]` is the accumulator of a fold:
`replay = foldM (flip apply) emptyLedger events`. The only way the cell changes
is that an event is appended and folded. The live cell holds the *current* fold;
any past value is reconstructed by folding a prefix.

These are not two phrasings of one design. They differ on the one question the
whole project turns on: can the stored state disagree with the log?

## 2. What the code in the repo actually does — reading (2), decisively

`States.tex` is not ambiguous; it is the executable answer.

- `settle` is the *only* writer of status, and it runs **only** as `apply
  (Settled u px)` inside the fold (States.tex L295–301, L374–381).
- The `Ledger` constructor and field selectors `ledgerUnit`/`ledgerPS` are
  **not exported** (L271–277). There is no out-of-band door: you cannot mutate
  `UnitStatus` except by appending an event and folding it.
- The closing sentence is explicit: "replay from `emptyLedger` rebuilds every
  unit's terms, status, and positions, so **every view is a projection of the
  stream**" (L390–391). UnitStatus is named in that list.

`FutureLifeCycle.tex` says the same in its own deeper logic, against its own
label:

- `last_settlement_price`/`date` "are **projections** of the `Settlement`
  carried by the stage, not independent fields" (L177–179).
- The general rule, stated as the document's law: "**what the fold over the log
  determines is derived, not stored**; only what the fold cannot reconstruct from
  prior events is state" (L399–400). Everything in UnitStatus — stage, last
  mark, date — is determined by folding `Register`/`SettleVM`/`Expiry` events. By
  the document's own rule it is therefore derived.

And v10.3, the ground the project rests on, forecloses reading (1) outright:

- "All other views — balances, PnL, balance sheets, regulatory reports — are
  **derived projections**" of the immutable move stream (L84).
- `net_qty` is "read from the ledger balance, **not cached in unit state**"
  (L1339); each log entry records `accumulated_cost` "enabling **reconstruction**
  of the exact position state after any event" (L1348).
- Time travel is a "**non-negotiable**" property: "any state can be reached again
  by replaying the same transactions" (L1395, L1011, L74).

So the documents' deeper logic, the reference code, and the founding spec all
implement reading (2). The single token pulling toward reading (1) is the table
cell "mutable, shared across holders" (FutureLifeCycle L58, L76; addendum L162,
L196). That cell describes *how the accumulator stores its value* — overwrite in
place rather than append — and nothing more. Read as an authority claim it is
simply false against the rest of the corpus.

## 3. My lens: is this one mechanism or two?

It is **one** mechanism. The fold over the log is the source of truth; the three
maps are the materialised accumulator of that fold. UnitStatus does **not** earn
its place as a *second source of truth* — if it were one, it would be a pure
liability, the exact "two authorities keep one fact and their records drift
apart" failure that States.tex §2 says the system exists to prevent.

It earns its place for one humble reason only: **read efficiency**. Re-folding
the whole log on every balance/PnL read is O(events) per read; at the E1 scale
(~10^6 contracts, daily fan-out) that is absurd. The materialised cell is the
standard event-sourcing materialised view — the cached current value of the
fold. That is a real, present-tense problem (not an imaginary one), so the cache
is justified.

The thing that collapses "two stores" back into "one mechanism" is the **seal**:
unexported constructor, one writer per field, every writer driven by a logged
event. With the seal, store-and-log cannot diverge because the store is *defined*
as the fold of the log. Remove the seal and you get two things that can drift —
which is precisely designs A and F that the addendum already rejects (addendum
L638, L659–665). The seal is load-bearing; it is what makes "mutable store" a
synonym for "cache," not for "second authority."

Distinct mutation disciplines (ProductTerms append-only vs UnitStatus overwrite)
do **not** mean two source-of-truth philosophies. Both are folds of the log. The
difference is only what the accumulator must retain: ProductTerms carries
externally-authored versions, each of which is itself a distinct fact the log
must surface as a *value*, so the accumulator keeps the list; UnitStatus carries
a ledger-authored current value whose history is fully recoverable by replaying
to an earlier cut, so the accumulator keeps only the latest. Overwrite is safe
**because** it is a fold — the discarded value is reconstructible from the log.

## 4. Time travel — the consequences are opposite under the two readings

- **Reading (2), correct:** time travel works and is trivial. Past UnitStatus at
  time *t* = fold the event prefix `events ≤ t` (v10.3 `clone_at(t)`, L74). The
  in-place overwrite of the *live* accumulator destroys no history, because
  history lives in the log, not in the cell. This is exactly the futures-margin
  case v10.3 L1374 demands: the sequence of marks and the prices used is
  recoverable, because each is a `SettleVM` event in the log, not a stale cell.

- **Reading (1), if it were true:** time travel **breaks**. A genuinely
  authoritative cell mutated in place has no backing log for its past values;
  once `stage` is overwritten to `EXPIRED`, the `ACTIVE`-with-mark-102 state as
  of day 1 is gone. v10.3 Property 6 (non-negotiable) fails. This alone refutes
  reading (1): the project cannot adopt it without abandoning a founding
  guarantee.

The contrast is the whole argument. Reading (2) makes time travel free; reading
(1) makes it impossible. The design that ships is the one whose past states are
recoverable, so the design is reading (2), whatever the label says.

## 5. Reproducibility — same split

- **Reading (2), correct:** `replay` is a pure, total `foldM`; same events give
  the same UnitStatus, bit-for-bit (States.tex L383–391; v10.3 L619 fixed-point
  decimals). The one caveat is honestly stated and contained: the stream must be
  de-duplicated at ingestion, because `SettleVM` at a fixed mark is idempotent
  but `Trade` is not (FutureLifeCycle L414–420). That is a boundary obligation on
  the *input* to the fold, not a defect of the fold. Reproducibility holds by
  construction.

- **Reading (1), if it were true:** any mutation of UnitStatus *not* expressed as
  a logged event would make a fresh replay disagree with the live store — the
  live ledger and the replayed ledger return different stages for the same *t*.
  That is the internal-reconciliation break the ledger exists to make
  unrepresentable. So reproducibility *requires* reading (2); it is not merely
  compatible with it.

## 6. Honesty check — is the current treatment a flaw or sound?

Sound in substance, hazardous in wording. The mechanism is right: one fold, a
sealed materialised accumulator, overwrite justified by recoverability. The flaw
is a single mislabel. "Mutable, shared across holders" names a true storage
property (the cell is overwritten) but, standing alone next to "immutable
ProductTerms," it reads as an *authority* contrast — as if UnitStatus were a
source of truth you edit. It is not; it is a projection you recompute and happen
to cache. Two readers can take the table two ways, and only one way is the design.
A spec whose stated principle is "each statement stated once, result first" should
not leave its own central object describable as either a cache or an authority.

## 7. What must change — and what must not

**Change (wording only):**

- In both state tables (FutureLifeCycle L58/L76; addendum L162/L196/L196 row),
  replace the bare "mutable, shared across holders" with: *"materialised
  projection of the log — shared across holders; the cell is overwritten in place
  (not append-only) because every prior value is reconstructible by replay."*
- State once, beside the three-map model, the load-bearing sentence already
  implied by States.tex L390 and FutureLifeCycle L399: **all three maps are the
  materialised accumulator of one fold over the immutable event log; the log is
  the sole source of truth, the maps are its cached current value.** Make
  "mutable" mean "overwrite-discipline of a cache," never "authority."

**Must NOT change (these are correct and load-bearing):**

- The overwrite-in-place discipline for UnitStatus. Do **not** "fix" the apparent
  contradiction by making UnitStatus append-only/versioned like ProductTerms:
  that duplicates the log, adds cost, and buys nothing, since the history is
  already in the log. (The addendum's design comparison already implies this; an
  append-only UnitStatus would be ceremony with no correctness gain.)
- The seal: unexported constructor, one writer per field, every writer driven by
  a logged event. This is the single thing that keeps store and log from being
  two sources of truth.
- The claim that replay reconstructs UnitStatus, and that time travel goes
  through replay-to-prefix rather than through reading the live cell.

## 8. One-line verdict

UnitStatus is a derived projection of the event log, cached in a mutably
overwritten cell for read speed; call it a *materialised projection*, not
"mutable," and the contradiction disappears, time travel stays free, and replay
stays reproducible.
