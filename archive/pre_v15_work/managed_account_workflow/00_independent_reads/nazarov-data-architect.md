# Independent Read — NAZAROV (data-layer boundary), Ledger §6 + Addendum A1

## The boundary I am holding

§6 describes a system that is **closed in quantity and open in value**. Conservation (P1)
makes `Σ_w w_t(u) = 0` an algebraic identity, so the move stream is self-evidencing for
*how much* of each unit exists and where. But every number that turns positions into money —
`V_t = Σ_u w_t(u)·P_t(u)` — is built on `P_t`, which the spec states plainly is *"an external
input to the framework, not computed by it"* and *"may be stale, unavailable, or may not
reflect achievable liquidation values."* The closed-system boundary of §6 is therefore exactly
the price/observation surface. Conservation guarantees the crystallisation move
`w_ref_cash → w_UB_cash` is internally balanced; it says nothing about whether the quantity
`Perf_k = V_{t_k} − V_{t_{k-1}}` is *correct*. That quantity is an oracle output, and it
crosses into real, irreversible client cash.

## Data classes crossing the boundary (derived from the primitives)

1. **Price vector `P_t`** — the master external input. Feeds: every managed-account Observe
   step, TRS `Payment_k`, periodic PnL settlement, HWM/perf-fee crystallisation, CSA aggregate
   MTM, and the leverage/concentration mandate guards.
2. **Benchmark level** `UnitStatus[u_bench]` — *"from index source"*. Feeds the perf-fee
   hurdle. A wrong level mis-charges a performance fee = real client-money move.
3. **Lifecycle observations** — `triggered_barrier`, `nav_index`, `vol_realised` in
   `UnitStatus[u_QIS]`. Drive rebalance and wind-down (real trade moves).
4. **Externally-sourced moves** — `Move(..., source, metadata)` for settlement confirmations
   and trade capture. `source` is a free string.
5. **Reset clock `{t_k}`** — the Observe step reads positions *and* `P_t` "at `t_k`".
6. **External reconciliation records** (§6.9) — custodian statements, counterparty
   confirmations. Explicitly out-of-ledger; require boundary reconciliation.

## What must hold (preconditions for the §6 guarantees to mean anything)

- **Replay needs a deterministic price oracle.** State-sufficiency and path-independent PnL
  (P10) depend on `P_t`; "bit-identical outputs" (the arithmetic rule) and the append-only
  hash-chained log (P4) only extend to value if the *price vector itself* is a content-
  addressed, immutable snapshot recorded in (or hash-referenced from) the stream. Otherwise a
  re-fetch reproduces different `Perf_k` and replay is not bit-reproducible. **This is the gap
  I own:** the spec asserts "the same price vector used for all other purposes" but never makes
  `P_t` a snapshotted, addressable object.
- **One price snapshot, two ledgers.** §6 *requires* `ℒ_v` and `ℒ_r` use the same `P_t` and
  warns divergence → "unexplained PnL". This must be *enforced*, not asserted: the `ℒ_v`
  valuation and the TRS settlement move must reference the same price-snapshot id, with
  equality verifiable by hash. As written it is a bare trust assumption with no detection
  signal.
- **Every external datum carries provenance, signature, timestamp — or a named trust
  assumption with an owner and a detection signal.** No bare index feed, no free-string source.

## Where it breaks (findings, ordered by consequence)

- **B1 — Unattested settlement basis.** `P_t` and `UnitStatus[u_bench]` have no signature,
  provenance, multi-source aggregation, quorum, or disagreement detection. A single wrong or
  manipulated value produces a real, irreversible crystallisation. Defence-in-depth is absent
  at the one point where the system pays out.
- **B2 — No freshness contract at a clock-triggered reset.** Resets fire on schedule `{t_k}`;
  `P_t` may be stale or absent. The spec defines no max-staleness, no fallback chain
  (primary → secondary → last-known-good-with-flag → hard stop), no behaviour-at-threshold.
  Silent use of a stale price at `t_k` is a silent fallback — forbidden — and it mints a real
  cash move.
- **B3 — Price-consistency asserted, not bound.** `ℒ_v` and `ℒ_r` can pull prices
  independently; nothing ties both to one snapshot. (Builds on **F5/price** family, not yet
  logged.)
- **B4 — Barrier observation is path-dependent and un-attested.** `triggered_barrier` drives
  wind-down, but an intra-period barrier *touch* is **not** recoverable from reset-time
  snapshots — state-sufficiency covers value, not the price path. Reconstructing it from `P_t`
  inherits B1 and adds a thresholding decision. It needs its own attested intraday feed.
- **B5 — `source` is untyped trust.** A perfectly conserved move can still inject a fabricated
  external event; P1 gives false comfort. Externally-originated moves need an attestation
  envelope, not a string.
- **B6 — Snapshot-time vs price-time skew.** Observe reads positions and `P_t` "at `t_k`";
  nothing binds the position-snapshot timestamp to the price-snapshot timestamp. P8 covers
  ledger-internal snapshots only.
- **B7 — Post-settlement price corrections undefined.** A vendor correction after `Perf_k` has
  crystallised: the cash already moved. "As known at `t`" vs "with corrections through `t'`"
  must be a first-class query and any correction a *new* snapshot + compensating move, never a
  mutation. Undefined in §6. (Relates to A1 **F5**.)

## Trust assumptions to register (currently untyped)

| Name | Scope | Owner | Violation consequence | Detection signal |
|---|---|---|---|---|
| TA-PRICE | `P_t` faithful & fresh at each `t_k` | TBD | Wrong real cash crystallised | Multi-source disagreement; staleness flag |
| TA-BENCH | `u_bench` level faithful | TBD | Perf fee mis-charged (client money) | Cross-source benchmark divergence |
| TA-PRICE-CONSISTENCY | `ℒ_v` = `ℒ_r` price snapshot | TBD | Unexplained TRS PnL | Snapshot-hash mismatch |
| TA-SOURCE | externally-sourced move provenance | TBD | Fabricated event admitted, conserved | Envelope signature verify |

Verification approach for any candidate implementation: show that for a fixed snapshot id,
`Perf_k`, the `ℒ_v` valuation, and the TRS settlement are byte-reproducible; that no reset can
commit on a stale/absent price without an explicit recorded fallback transition; and that every
external datum entering §6 either verifies a signature or maps to a registered trust assumption
with a live detection signal.
