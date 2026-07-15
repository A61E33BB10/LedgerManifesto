# §6 Review — NAZAROV (data-layer boundary)

**Charge (Step 2):** the boundary through which **NAV inputs and the benchmark level enter
valuation** — attestation, freshness, replay. I derive every finding from the primitives, the
three-map ruling (A1), and the spec's own text. Citations are to `ledger_v10.3.tex` (L) and
`ledger_v10.3_addendum_stateshome.tex` (A-L).

---

## 0. The boundary I am holding, located precisely

§6 is **closed in quantity, open in value**. Conservation (L33–36, P1) makes
`Σ_w w_t(u) = 0` algebraic, so the move stream self-evidences *how much* of each unit exists.
But every figure that turns positions into a **real, irreversible cash move** —
`Perf_k = V^ref_{t_k} − V^ref_{t_{k−1}}` (L826), `Payment_k = N_k·TR_k − N_k·r_k·Δt_k` (L906),
the CSA margin call (L859), the performance fee against HWM and benchmark hurdle — is built on
two external oracle inputs the framework explicitly does **not** compute or guarantee:

1. the **price vector `P_t`** — "an *external input* … may be stale, unavailable, or may not
   reflect achievable liquidation values" (L510);
2. the **benchmark level** — "from index source," homed at `UnitStatus[u_bench]` (A-L211).

Conservation guarantees the crystallisation move is *balanced*; it says nothing about whether
the *quantity* it moves is *right*. That quantity is an oracle output crossing into client cash.
**The §6 boundary is exactly the NAV/benchmark observation surface, and it is where the closed
system pays out.**

### The decisive structural fact (new vs my independent read)

The NAV price inputs and the benchmark level are **not** read from a versioned, content-addressed
snapshot. They are dereferenced from **`UnitStatus`**, which the ruling defines as
**`mutable, shared across holders`, written in place on every settle** (A-L89, A-L109, A-L303):
`last_settlement_price` (the NAV price for listed/settled units, "one settle price per contract,"
A-L181) and `current benchmark level` (A-L211) both live there. `UnitStatus` is **not** the
append-only versioned `ProductTerms` (A-L140, C6) and is **not** the hash-chained move stream
(L4/P4). It is, for valuation purposes, a **live overwritten feed**.

The spec's own determinism clause is unambiguous about why this is a problem (L1418):

> "reproducibility … requires a deterministic market data oracle … the market data used by each
> lifecycle invocation is **captured and stored at the time of execution** (e.g., as a versioned
> snapshot with source, timestamp, and fallback chain). **Subsequent replays use the stored
> snapshot, not a live feed.**"

The three-map model gives the *price/benchmark* inputs a live feed (`UnitStatus`), not a stored
snapshot. **Therefore the §6 value-dependent settlements are not replayable from the immutable
record as written** — unless the exact price/benchmark value used at `t_k` is captured into the
immutable `StateDelta`/move payload at crystallisation. §6 never says it is. This is the gap I own,
and it is now grounded in the schema, not asserted.

---

## 1. The workflow, step by step, as atomic moves — with the datum crossing at each step

For each step I give the conservation-verified move(s) and the **external datum** entering, then
its attestation / freshness / replay status. `q>0` always; direction encodes sign (Def 2.3, L149).

**S1 — Mandate issuance.** `τ = { m=(w_mgr, w_client, u_MA, q=1, t, source, meta) }` ⟹
`w_mgr(u_MA)=−1, w_client(u_MA)=+1`, `Σ_w w(u_MA)=0` (issuance law, A-L163). *Datum:* mandate
**terms** → `ProductTerms[u_MA]` (immutable, versioned — **good**): fee schedule, **benchmark
identity**, HWM/hurdle methodology (A-L206). The *binding* "benchmark identity → which external
index feed authoritatively supplies the level" is a **named trust assumption** (TA-BENCH-ID), not
a cryptographic fact. Reference-data ingestion; version-pinned by C6/C7 — replay-clean for the
*identity*. **OK on attestation of identity; the live level is S5's problem.**

**S2 — Subscription.** `m=(w_fund, w_client_cash, USD, q=sub_amt)`; `w_fund` is an external
counterparty as **virtual wallet** (L33–36), so `Σ=0` holds inside the closed system. *Datum:*
the **custodian credit confirmation** is an externally-sourced move — `source` is a **free string**
(L843, L917, L953). `entry_nav` written to `PositionState[w_client,u_MA]` (C11 `entry_nav→subscribe`)
captures `V` at subscription = a **NAV input** (depends on `P` at subscription time). **Unattested
move (B5); entry_nav inherits the price-snapshot replay gap.**

**S3 — Trading under mandate.** Per trade: `{ m_cash, m_security }`, two legs, `Σ=0`. Quantitative
guards are preconditions on move generation (L865): reject ⟹ no moves, state unchanged. *Datum:*
(a) **trade-capture/execution confirmation** (external, `source` string, unattested); (b) **`P_t`**
— value-based limits (leverage, concentration-by-value) are **not** pure in ledger state alone:
hold positions fixed, double a price ⟹ leverage breaches ⟹ the same proposed trade flips to reject
(this is formalis B6 / my determinism point). So `P_t` is a guard input and a **boundary datum on
the admission path**, not only the valuation path.

**S4 — NAV.** `V^ref_t = Σ_u w_ref(u)·P_t(u)` (L822). **Not a move — a projection.** This is where
the **bulk of NAV inputs cross**: the entire price vector over held units. For listed/settled units
`P_t(u)` is dereferenced as `UnitStatus[u].last_settlement_price` (A-L181) — **mutable, overwritten,
unversioned**. For an unsettled/illiquid unit it is `None` (A-L253; minsky B2): `V_t` is then
**partial**, and a silent zero would mis-state NAV. **Attestation: none. Freshness: undefined.
Replay: broken (mutable source).**

**S5 — Fee accrual & crystallisation against HWM.** Two oracle inputs jointly decide a real
client-money figure: `P_t` (NAV performance) **and** the benchmark **level** (`UnitStatus[u_bench]`,
hurdle). HWM ratchets under one writer (C11 `hwm→fee_crystallise`). Moves:
mgmt/perf fee `m=(w_ref_cash, w_mgr_cash, USD, q=|fee|)` and the performance reset
`m=(w_ref_cash, w_UB_cash, USD, q=|Perf|)` (direction by sign — see correctness-architect B,
formalis B1, minsky B1: the literal `quantity: Perf_ref_k` at L841 is a **partial function**, illegal
for `Perf<0`; I concur and build on it, it is not my charge to re-derive). `Σ=0` per move.
**This is the highest-consequence point on the boundary:** the *correctness* of the crystallised
cash rests entirely on two **un-gated, unattested, mutable-store** oracles. **Replay:** the benchmark
level at `t_k` must be **captured into the immutable crystallisation `StateDelta`** (C3 makes this
atomically possible across all three maps), else the next in-place overwrite of `UnitStatus[u_bench]`
destroys "as known at `t_k`" and the fee is no longer reproducible. §6 does not specify the capture.

**S6 — Segregation.** Quantity segregation is algebraic (L855). *Datum:* none new. (Note, with
jane-street-cto #2 and minsky T2: a cross-partition move is perfectly conservative, so segregation
of *who-can-move* rests on C4 capability scoping, not on P1. Adjacent to my boundary via the `source`
/ authz of externally-originated moves — see S2/B5 — but not my core charge.)

**S7 — CSA margin.** Reads aggregate MTM `= Σ_{trades under CSA} w(u)·P_t(u)` (L859), emits
`m=(w_firm_collat, w_cp_collat, USD, q=call)`. `Σ=0`. *Datum:* **`P_t`** (MTM) again, plus
**eligible-collateral haircuts / threshold / MTA** (reference data; haircut is itself a market-risk
parameter that can be an external input). Same attestation/freshness gate as S4–S5; a wrong MTM
mis-calls margin = real collateral move.

**S8 — TRS / virtual portfolio.** `ℒ_v` valuation `V^v = oracle(P_t over virtual positions)` (L882);
`TR_k = (V^v_{t_k} − V^v_{t_{k−1}})/V^v_{t_{k−1}}` (undefined at `V^v_{t_{k−1}}≤0` — formalis B7,
correctness-architect E; not my charge but inherited). `Payment_k` move in `ℒ_r`, `Σ=0` within `ℒ_r`;
**no move crosses `ℒ_v↔ℒ_r`** (L875, P7). *Data:* (a) **`P_t` shared across two ledger instances** —
"must use the same price vector … or unexplained PnL" (L922), asserted not bound (my B3); (b) the
**financing rate `r_k`** in `N_k·r_k·Δt_k` (L906) — **an external interest-rate fixing (e.g. an
overnight rate) crossing the boundary, which no lens has flagged and §6 leaves entirely
unattested.** `r_k` is a second oracle on the TRS settlement path, same consequence class as `P_t`.

**S9 — Redemption.** Final NAV strike + fee true-up + `m=(w_client_cash, w_external, USD, q=proceeds)`.
For QIS wind-down the trigger is `UnitStatus[u_QIS].lifecycle_stage→CLOSED` propagating a NAV-strike
redemption (A-L247), and `PositionState` rows are retained at zero (monotone carrier) preserving final
HWM. *Datum:* **redemption-strike `P_t`** (irreversible, high consequence) + settlement confirmation
(external). Same gate as S4.

**S10 — Balance-sheet substantiation (§6.9).** Quantity/flow substantiation = deterministic projection
of the filtered move stream (L962, L1509) — **internally replay-clean.** *Datum:* the **valued**
balance sheet at a reporting date needs the **price snapshot at that date**, which is **not hash-bound
to the move stream**; and external custodian/counterparty records require boundary reconciliation
(L962; banking-auditor's existence risk). Replay of the *number* on a statement is therefore only as
reproducible as the (currently mutable, unversioned) `UnitStatus` price it used.

**Conservation verdict across S1–S10:** every state change is expressible as atomic, two-legged,
`q>0` moves with `Σ_w Δ(u)=0`. *Quantity conservation holds by construction at every step.* The
defects are **not** in conservation; they are in the **provenance, freshness, and replay-binding of
the value inputs** that conservation is silent about.

---

## 2. Findings (ordered by consequence)

The spec already contains the *right requirements* in §Implementation and §Limitations. My finding
is that **§6 does not discharge them on the settlement path**, and the three-map schema actively
works against one of them.

**N1 — The data-quality gate exists in the spec but is NOT wired into the §6 contract (discharge
gap).** L1642 states: value-dependent settlements "produce economically incorrect moves if driven by
stale prices. An implementation **must gate value-dependent settlements on data quality checks
(staleness thresholds, cross-source validation) and defer settlement** when price quality is
insufficient." L2644 wires this gate into *lifecycle* workflows ("a data quality check activity before
invoking the lifecycle function … defers the event"). **But the §6 managed-account contract
(Observe/Crystallise/Reset, L829–848), the TRS contract (L904–920), and the periodic-settlement move
(L946–956) contain no such gate, no staleness threshold, no fallback chain, no deferral state.** The
contract that mints irreversible client cash is the one place the gate is *not* bound. §6 MUST make
the data-quality gate a **precondition of the crystallisation move-generation function** (reject/defer
⟹ no move, recorded deferral event), exactly as quantitative mandate constraints are preconditions
(L865). Otherwise a clock-triggered reset at `{t_k}` fires on a stale or `None` price — a **silent
fallback**, which is forbidden, and it moves real cash.

**N2 — NAV/benchmark replay is broken because the price source is mutable, not snapshotted.** L1418
requires replays to "use the stored snapshot, not a live feed." The NAV price (`UnitStatus.
last_settlement_price`) and the benchmark level (`UnitStatus[u_bench]`) are **mutable, in-place
overwritten** (A-L89, A-L109, A-L303). Nothing in §6 captures the value *used at `t_k`* into the
immutable record. **Requirement:** every value-dependent `StateDelta` (Perf reset, perf-fee, margin
call, TRS `Payment_k`) MUST embed, in its immutable move/event payload, a **content-addressed
reference to the exact price/benchmark snapshot consumed** (source, timestamp, fallback-chain-as-
traversed, value digest). C3 atomicity already permits this across the three maps; it must be made
mandatory. Without it, "as known at `t`" vs "with corrections through `t'`" (L1418, L1648) is
unanswerable for any fee or settlement, and P10/replay do not hold at the *valued* level. This is the
same dependency jane-street-cto #1 and formalis PO-Determinism name for the **baseline**; I extend it
to the **price and benchmark inputs themselves**, and locate the leak in the `UnitStatus` mutation
discipline.

**N3 — No attestation, only provenance, and only sometimes that.** The spec's strongest data clause
(L1418) asks for "source, timestamp, and fallback chain" — that is **provenance metadata, not
attestation**. There is no signature, no verifiability against the named source, no multi-source quorum,
no disagreement detection at the one point that pays out. `source` on the move is a **free string**
(L843). **Requirement:** every NAV/benchmark datum entering a §6 settlement MUST arrive with a
verifiable signature from an identified provider and a verifiable timestamp, **or** map to a named,
owned trust assumption with a live detection signal. A REST/index level with no signature is a rumour;
conservation will faithfully move cash on a signed-looking lie (P1 gives false comfort — my B5).

**N4 — Benchmark level has *weaker* discipline than the price vector.** The fault-tolerance language
(L1642) and the determinism clause (L1418) speak of "price feeds"/"market data." The **benchmark
level** is a distinct oracle that directly sets the **performance-fee hurdle** = client money, yet §6
gives it no staleness rule, no fallback, no cross-source check, and homes it in mutable `UnitStatus`.
A stale or manipulated benchmark level mis-charges a performance fee with no detection signal.
**Requirement:** the benchmark level is in-scope for N1–N3 identically to `P_t`; treat it as a
first-class NAV input, not as a passive shared scalar.

**N5 — Price consistency across `ℒ_v` and `ℒ_r` is asserted, not bound.** L922 *warns* that divergent
sources create unexplained PnL but provides no enforcement. **Requirement (aligns with minsky B7):**
thread **one** content-addressed price snapshot into both the `ℒ_v` valuation and the `ℒ_r`
`Payment_k` computation; both must hash-reference the **same** snapshot id, equality verifiable by
digest. Consistency must hold **by sharing**, not by after-the-fact reconciliation — *and* the shared
snapshot must itself be attested (N3), or both ledgers agree on an unverified number.

**N6 — `r_k` (the financing fixing) is an unflagged oracle.** The TRS financing leg `N_k·r_k·Δt_k`
(L906) consumes an external interest-rate fixing. It is a NAV/settlement input on the same consequence
class as `P_t` and is covered by **none** of the spec's data-quality language. It MUST be attested,
fresh-gated, and snapshot-bound exactly as `P_t`.

**N7 — Intraday/path observations are not recoverable from reset snapshots and are unattested.**
`triggered_barrier`, `nav_index`, `vol_realised` (A-L236) drive QIS rebalance and wind-down (real
trade moves, A-L245/247). State-sufficiency (L516) covers value from *current* state; an intra-period
**barrier touch** is path-dependent and **not** reconstructible from reset-time `V_t`. The write of
`triggered_barrier` into `UnitStatus[u_QIS]` is an **externally-sourced oracle observation** with the
same unattested status as a price (N3) and needs its own attested intraday feed with its own freshness
contract.

**N8 — Corrections after a settled crystallisation are undefined in §6.** L1648 gives the correction
algebra (compensating transactions, `corrects` field) and flags it an **open problem**; L1807 notes a
`CORRECTION` "may require settlement reversal if the original has already settled." §6 never states
what happens when a vendor restates `P` or the index restates a level *after* `Perf_k`/a fee has
crystallised: the cash already moved. **Requirement:** a post-settlement correction MUST be a **new
snapshot version + a compensating, linked transaction** (never an `UnitStatus` overwrite that silently
re-bases history), and "as known at `t`" vs "with corrections through `t'`" MUST be a first-class query.

---

## 3. Trust-assumption registry (currently untyped in §6)

| Name | Scope | Owner | Violation consequence | Detection signal |
|---|---|---|---|---|
| TA-PRICE | `P_t` faithful & fresh at each `t_k` (S4–S9) | TBD (CDO/market-data) | Wrong real cash crystallised/settled | Multi-source disagreement; staleness flag; deferral count |
| TA-BENCH-LEVEL | `UnitStatus[u_bench]` level faithful & fresh (S5) | TBD | Perf fee mis-charged (client money) | Cross-source benchmark divergence |
| TA-BENCH-ID | benchmark identity → authoritative feed binding (S1) | TBD | Whole fee computed off wrong index | Feed-identity attestation at registration |
| TA-PRICE-CONSISTENCY | `ℒ_v` valuation = `ℒ_r` settlement snapshot (S8) | TBD | Unexplained TRS PnL | Snapshot-digest mismatch |
| TA-RATE | `r_k` financing fixing faithful (S8) | TBD | TRS financing leg mis-settled | Cross-source rate divergence |
| TA-SOURCE | externally-originated move provenance (S2/S3/S9) | TBD | Fabricated event admitted, conserved | Envelope signature verify; `source` is a string today |
| TA-OBS | intraday barrier/vol/nav observation faithful (S7/N7) | TBD | False rebalance/wind-down → real trades | Independent intraday-feed cross-check |
| TA-CUSTODY | custodian/counterparty external records (S2/S9/S10) | TBD (Ops) | Internal-vs-external existence break | Boundary reconciliation exception |

Every row is presently an **untyped** trust assumption: §6 neither signs the datum nor names the owner.

---

## 4. Threat model (boundary attackers)

| Attacker | Capability | §6 mitigation today | Residual / required |
|---|---|---|---|
| Malicious/erroneous **vendor** | Emits a wrong `P_t`/benchmark/`r_k` level | None on settlement path (N1) | Multi-source aggregation + quorum + disagreement flag, gating crystallisation |
| Malicious **gateway** | Forges `source`/timestamp on a datum or move | `source` is a free string (N3) | Signature verification at ingestion; named key + rotation |
| Malicious **operator** | Overwrites `UnitStatus` price/benchmark before a reset | `UnitStatus` is mutable, in-place (N2) | Snapshot-bind the consumed value into the immutable `StateDelta`; one-writer (C11) on the *capture* |
| Malicious **consumer/desk** | Settles `ℒ_v` and `ℒ_r` on different prices | Consistency only asserted (N5) | One shared content-addressed snapshot, digest-checked |
| **Replay/network** | Re-injects a stale datum at `t_k` | Clock-triggered reset, no freshness contract (N1) | Max-staleness + behaviour-at-threshold + recorded fallback transition |

P1 conservation defeats *none* of these: a conserved move can carry a fabricated or stale value.
Conservation is necessary, not sufficient, for boundary integrity.

---

## 5. Tensions logged (with named lenses)

- **vs formalis (and correctness-architect H, finops "flag any live read", jane-street-cto #3):**
  determinism ≠ correctness. formalis's `PO-Determinism` treats `P_t` as a *trusted given argument*
  ("pure function of … the external price vector"); recording `P_t` as an event makes the wrong number
  *reproducible*, not *right*. **Attestation is upstream of determinism.** Their fix (inject the price
  as a recorded input) is necessary but not sufficient — a recorded unattested price is a reproducible
  lie. We must agree the snapshot is *both* content-addressed (their need) *and* signature-verified
  + multi-source (my need).

- **vs jane-street-cto / minsky (B7):** snapshot-as-consistency vs snapshot-as-attestation. Their fix —
  thread one immutable `P_t` value into both `ℒ_v` and `ℒ_r` (minsky: "parse the snapshot once") — kills
  divergence, but makes both ledgers agree on a value **neither has attested**. Consistency without
  provenance. The shared snapshot must additionally be attested and the settlement move must hash-
  reference it. Necessary-but-stops-short.

- **vs banking-auditor:** placement of independent price verification. banking-auditor frames cross-
  source/IPV as a *downstream accounting overlay* (IFRS 13 hierarchy). I require cross-source validation
  as an **upstream gate that defers crystallisation** (the spec's own L1642 "cross-source validation …
  defer settlement") *before* the irreversible move. If IPV lives only in the accounting overlay, the
  client cash has already moved on a single unverified price. Both are needed; the *placement* is the
  tension and it is load-bearing.

- **vs regulatory-reporter (MH-1):** report substantiation source. regulatory-reporter says reports
  derive from the stored CDM `BusinessEvent` payload. But the **valuation/MTM field** (EMIR VALU, daily
  per MH-4) is computed from the price-snapshot oracle, which the forgetful map `F` keeps **out** of the
  CDM payload (L1999: "the ledger should not carry … CDM should not carry wallet-level balance
  arithmetic") and which is **not hash-bound** to the event. A VALU number therefore **cannot be
  substantiated from the CDM event alone** — it needs the attested, content-addressed price snapshot
  that §6 does not currently produce. The reporting boundary and the valuation boundary need the *same*
  snapshot object, and neither lens has placed it.

---

## 6. Verification approach (how an auditor confirms a candidate implementation)

1. **Replay binding:** for a fixed snapshot id, show `Perf_k`, the perf-fee, the `ℒ_v` valuation, the
   margin call, and the TRS `Payment_k` are **byte-reproducible**, and that each move payload carries a
   content-addressed reference to the snapshot it consumed (N2/N5).
2. **No silent fallback:** show no reset/fee/margin/TRS move can commit on a stale, absent, or `None`
   price/benchmark/`r_k` without an **explicit recorded deferral or fallback-transition event** (N1).
3. **Attestation:** show every NAV/benchmark/rate datum entering a settlement either verifies a
   signature against an identified provider key or maps to a registered trust assumption (§3) with a
   live detection signal; show `source` is no longer an unverified free string (N3).
4. **Mutation discipline:** show that re-reading `UnitStatus` after later overwrites still reproduces a
   historical fee/settlement via the captured snapshot — i.e. "as known at `t`" ≠ "with corrections
   through `t'`" is a working query, and corrections are compensating transactions, never overwrites
   (N2/N8).
5. **Consistency by sharing:** show the `ℒ_v` and `ℒ_r` computations dereference the **same** snapshot
   digest, enforced structurally, not reconciled after the fact (N5).

**Bottom line:** §6's quantity algebra is sound and conservation holds at every step. The spec already
*states* the data-quality, snapshot, and correction requirements I would impose — but **in
§Implementation and §Limitations, not in the §6 settlement contracts**, and the three-map schema homes
the NAV price and benchmark level in **mutable, unversioned `UnitStatus`**, which contradicts the
spec's own "replays use the stored snapshot, not a live feed." The boundary is not yet watertight at
the one place the closed system pays out. None of this requires changing the framework; it requires
**binding the existing requirements into the §6 move-generation functions** and **snapshotting the
consumed value into the immutable record**.
