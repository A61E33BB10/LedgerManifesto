# UnitStatus mutability — assessment from the data boundary

**Reviewer:** NAZAROV (data-layer architect)
**Lens:** provenance and replay at the point where market-derived data crosses into the closed system
**Recommendation:** **DERIVED PROJECTION** — UnitStatus is a materialised fold of the immutable
event log; its "mutability" is caching/materialisation only, not authority. The label as written is
ambiguous and must be sharpened. A separate, deeper boundary defect (missing attestation in the event
payload) is exposed by this question and must be fixed independently of the label.

---

## 1. The boundary I am holding

The settlement price `S` is the canonical market-derived datum in this artefact. It enters the closed
system at settlement. The question put to the committee — "overwritten in place, does it lose lineage;
can it be re-attested and re-derived from the boundary?" — is a boundary question, so I answer it from
the boundary.

The decisive structural fact is **where the price physically lives**:

- States.tex L374: `data Event = Registered UnitId TermsVersion | Moved Move | Settled UnitId Price`.
  The price rides **inside the immutable `Settled` event**.
- States.tex L378: `apply (Settled u px) = settle u px`. `UnitStatus[u]` is **the output of applying
  that event** — a fold result.
- States.tex L360–363: the sealed constructor leaves "no other door": `UnitStatus` is never written
  except through an event. There is no `set_status` back channel.
- FutureLifeCycle.tex L177–179: `last_settlement_price`/`last_settlement_date` are "**projections of
  the Settlement carried by the stage, not independent fields**."
- FutureLifeCycle.tex L399 (the general rule): "**what the fold over the log determines is derived, not
  stored**; only what the fold cannot reconstruct from prior events is state."
- v10.3 L1501: "The current balance is a **projection of the log**, not an independent record."
- v10.3 L2265: "Corrections in both systems follow the same principle: **compensating events, not
  mutations**."

Every deep passage agrees: the system of record is the append-only event stream. `UnitStatus[u]` is the
*latest materialised value* of `fold(apply, {Settled/SettleVM events for u})`. The state-table label
"mutable, shared across holders" (FutureLifeCycle L58; addendum L162) describes the **storage discipline
of the cache** — overwritten in place rather than versioned — and the addendum is explicit that the
three-map split exists to separate *mutation disciplines* (addendum L585: append-only terms vs.
overwrite-on-settle status), not to confer source-of-truth status on the map.

**Conclusion of step 1:** the AUTHORITATIVE-MUTABLE reading is contradicted by the documents' own
construction. UnitStatus is a derived projection. The two documents do not, on inspection, actually
disagree — one of them carries a loose *label* over a body of *prose* that says the opposite.

## 2. Time travel — explicit effect under each reading

Time travel (v10.3 Property 6, L74; `clone_at(t)`, L1392) is reconstruction of any past state by
replaying the immutable stream up to `t`. v10.3 L74 demands **two** views without conflation:
"as known at `t`" (snapshot from `t`) and "to `t` with today's corrected data" (restated snapshot).

- **AUTHORITATIVE-MUTABLE reading → time travel is broken.** If `UnitStatus` were the source of truth
  changed by in-place mutation, the value of `S` at `t` is destroyed the moment the next settle
  overwrites it. `clone_at(t)` has nothing to reconstruct from; only the latest mark survives. "As known
  at `t`" is unanswerable, and a vendor correction silently erases the prior belief, so the two
  mandated views collapse into one. This directly violates L74, L1392, L399, L1501.

- **MATERIALISED-PROJECTION reading → time travel works, and works for both mandated views.**
  `clone_at(t) = fold(apply, events with time ≤ t)`. The mutable map is merely the `t = now`
  materialisation; it is irrelevant to time travel because time travel reads the **log**, not the map.
  "As known at `t`" = fold over events timestamped ≤ `t`. "With corrections through `t'`" = fold that
  includes correction events appended after `t` but bearing on `t` (v10.3 L2265: corrections are new
  compensating events). Time travel is a property of the log's append-only-ness, not of the map's
  mutability — which is exactly why the map *may* be overwritten freely.

**The contrast is the whole point:** mutability of the map costs time travel nothing **iff** the datum
also lives in an immutable event. The documents establish that it does (`Settled u S`). So the in-place
overwrite is harmless to time travel. Were the price to live *only* in the map, time travel would be
destroyed. The committee must not approve "mutable" without also affirming "and the value is carried in
the event," because the second clause is what makes the first safe.

## 3. Reproducibility — explicit effect under each reading

- **AUTHORITATIVE-MUTABLE reading → only the latest state is reproducible.** Re-reading the map
  reproduces "now." Historical replay is not reproducible: there is no prior basis to replay to. A
  vendor correction overwrites the basis with no record, so a replay after correction yields a different
  answer than the same replay before it, with nothing to explain the change. This fails the v10.3 L1418
  contract that "as known at `t`" and "with corrected data" be *each* deterministic given *their
  respective* inputs — because the pre-correction input no longer exists.

- **MATERIALISED-PROJECTION reading → fully reproducible.** `replay` is a pure, total fold (States.tex
  L383; FutureLifeCycle C1(b)/L413), bit-identical under the fixed-precision arithmetic requirement
  (v10.3 L619). Same events → same `UnitStatus`. The map is throwaway: discard it, re-fold, get the
  identical value. Corrections are new events → a new deterministic fold. Both L1418 views hold.

## 4. What in-place mutation actually costs the attestation/replay story — the honest answer

The prompt's premise ("overwritten in place, it loses lineage") is **only half right, and the wrong
half is the one that matters.**

1. In-place mutation of the materialised map costs the **replay of the number** nothing, because the
   number lives in the immutable `Settled u S` event. Lineage-of-number is preserved by the log, not by
   the map. Approve the projection reading and this concern dissolves.

2. The genuine lineage loss is **orthogonal to UnitStatus mutability** and would survive making
   `UnitStatus` perfectly immutable. The `Settled` event carries `Price` as a **bare scalar**. It
   records no provenance and no attestation: no signing provider key, no source identity, no observation
   timestamp, no fallback-chain-as-traversed, no signature. So while "what number settled `u` at `t`"
   replays exactly, "**was that number the faithfully-attested market settlement price at `t`**" is not
   answerable from the log at all. A reproducible unsigned price is a *reproducible-but-unverifiable*
   datum — a reproducible rumour. (This is the recurring determinism-≠-attestation pattern: recording a
   datum makes a wrong number reproducible, it does not make it right.)

3. **Re-attestation / re-derivation from the boundary** — the literal question — is therefore **not
   satisfiable as specified**, for a reason that has nothing to do with the mutable map. To re-derive
   `S` at `t` from the boundary you need the boundary snapshot itself to be a first-class, append-only,
   content-addressed, as-of-queryable artefact, bound into the `Settled` event by hash. v10.3 L1418
   already *requires* exactly this ("versioned snapshot with source, timestamp, and fallback chain …
   replays use the stored snapshot, not a live feed"), and v10.3 L2644 wires a data-quality/staleness
   gate into lifecycle. But neither States.tex's `Settled UnitId Price` nor FutureLifeCycle's shared
   StateDelta write carries that binding. **The right requirement exists in the spec; it is simply not
   wired into the event that strikes the irreversible variation-margin cash.** This is the discharge gap
   I have flagged before (E2), surfacing again here.

So: the mutable-map worry is a distraction; the real boundary defect is the unattested, unbound event
payload. Fix the label (clarity) and fix the payload (security) — they are different fixes.

## 5. Trust assumptions exposed (named, per discipline)

| Name | Scope | Owner | Violation consequence | Detection signal |
|---|---|---|---|---|
| TA-PRICE-ATTEST | `S` in every `Settled`/`SettleVM` event | **TBD — escalate to spec owner** | irreversible VM cash struck on an unverified number; reproducible but unverifiable | event payload lacks signature/provider key/snapshot hash |
| TA-SNAPSHOT-BIND | binding of boundary snapshot to the crystallising event | **TBD — spec owner** | "re-derive from boundary" and "as known at `t`" not satisfiable | no content-address linking event → stored snapshot |
| TA-CORR-AS-EVENT | corrections appended, never mutated | spec owner (stated, v10.3 L2265) | history rewrite; time-travel divergence | any write to `UnitStatus` not traceable to an event |

## 6. What must change — and what must not

**Must change (clarity — relabel only, no model change):** the state-table cell "mutable, shared across
holders" (FutureLifeCycle L58; addendum L162) is the *only* place the documents speak with the wrong
voice. Restate it to match the prose the same documents already carry, e.g. **"materialised projection
of the settlement-event stream; one value per contract, shared across holders; stored mutably as a read
cache — every change is caused by a logged event and is reconstructed exactly by replay."** This obeys
CLAUDE.md minimalism (do not represent two contradictory disciplines) and clarity (state each thing
once, declaratively). FutureLifeCycle L177–179/L399 and v10.3 L1501 are already correct; align the table
to them, not the reverse.

**Must change (security — substantive, separate from the label):** the `Settled`/`SettleVM` event
payload MUST carry the settlement price together with its attestation envelope / snapshot binding
(content-address of the stored boundary snapshot: provider key, source, observation timestamp,
fallback-chain-as-traversed, signature), per the requirement already present at v10.3 L1418/L2644 but
not wired into the lifecycle event. Without this, DERIVED PROJECTION guarantees a reproducible number,
not a verifiable one.

**Must NOT change:**
- The three-map model (ProductTerms immutable-versioned / UnitStatus shared-one-per-contract /
  PositionState per-holder). The split is correct and minimal; the rationale (separate mutation
  disciplines, addendum L585) stands.
- "Shared across holders" — correct: there is genuinely one settlement price per contract.
- The placement: price in shared state, its *consequence* (`ac` reset, VM cash) in per-wallet state
  (FutureLifeCycle L314–317). Correct.
- `accumulated_cost` remaining per-position (C11). It is path-dependent — the intraday-trade subtlety
  (FutureLifeCycle L295–300) shows it cannot be read off the current price. It is nonetheless a fold of
  the log like everything else; "stored" here means "not derivable from the current *price* alone," not
  "not derivable from the *log*." Leave it.
- The append-only event log as sole source of truth, and corrections-as-compensating-events
  (v10.3 L2265). Leave them; they are what make the projection reading sound.

## 7. Verification approach for an auditor

1. **No back channel.** Confirm `UnitStatus` is written only via `apply(Settled …)` / settle handlers;
   grep for any `set_status`-style primitive. Pass = none exists (States.tex L360–363).
2. **Replay equivalence.** Drop the materialised `UnitStatus` map, re-fold the event prefix to `t`,
   assert bit-identical to `clone_at(t)` (v10.3 P8, L2088). Pass = projection reading holds.
3. **Two-view test.** Construct a back-dated price correction as a new event; assert "as known at `t`"
   (fold ≤ `t`) and "with corrections through `t'`" diverge by exactly the correction and that the
   pre-correction view is still reconstructable (v10.3 L74/L1418).
4. **Attestation presence.** Inspect a `Settled` payload; assert it carries signature + provider key +
   snapshot content-address. **This is the test the current spec fails** — record it as the open finding.
