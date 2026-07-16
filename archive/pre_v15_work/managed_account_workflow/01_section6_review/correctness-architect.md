# §6 Managed-Account Workflow — Review (correctness-architect)

**Charge (Step 2):** the property taxonomy the §6 workflow must satisfy, and the determinism
boundaries it crosses — **benchmark, prices, clock**. Every stage below is derived from the
primitives (Wallet, Unit, Move `q>0`, Transaction-atomicity, Conservation P1, the three-map
ruling A1) and each state change is checked as atomic moves with conservation verified.
Cited to v10.3 line numbers. I do not appeal to practice.

The discipline I apply: a stage is *correct* only when (i) every emitted move is legal
(`q>0`, two named wallets, conserves its unit), (ii) every claimed function is **total** over
its declared domain, (iii) every read is a **pure function of recorded state + named external
inputs** so replay is a fold, and (iv) the property holds *by construction*, not by assertion.

---

## A. The workflow, derived stage by stage (moves + conservation + property + boundary)

### A0 · Mandate issuance
Manager issues `u_MA` to client. One transaction, one move pattern:
`w_manager(u_MA) −= 1 ; w_client(u_MA) += 1`. **Conservation:** `Σ_w w(u_MA)=0` by the
issuance law (briefing l.38, A1 §4). Registers `ProductTerms[u_MA]` (fee schedule, benchmark
*identity*, HWM/hurdle methodology, crystallisation frequency `{t_k}`, limits) and an empty
`PositionState[w_client,u_MA]` (`entry_nav=⊥`, `hwm=⊥`, `bench_nav_inception=⊥`, accruals 0).
- **Property (universal/structural):** *cardinality* — `support(u_MA)={w : w(u_MA)≠0}` has
  exactly two members with values `{+1,−1}`. P1 does **not** prove this (it admits `+5/−5` or
  a 3-way split — minsky T1, with whom I agree). This needs a refinement on `u_MA`, not P1.
- **Property (structural):** `u_MA` is **non-valued**: `u_MA ∉ dom(P_t)`, so it never enters
  `V_t = Σ w·P` (l.508). If priced, NAV double-counts the relationship against the underlying
  positions. This must be a **typed exclusion**, not a convention (concur banking-auditor).
- **Determinism boundary:** none yet. The *benchmark identity* is pinned here; its *level* is
  read later.

### A1 · Subscription
Client funds the book: real cash move `w_client_external(USD) → w_ref_cash(USD)`. **Conservation:**
USD nets to zero. Initialises, under the `subscribe` handler (C11): `entry_nav := V_ref(t_sub)`,
`hwm := entry_nav`, `bench_nav_inception := UnitStatus[u_bench](t_sub)`; advances the
sub/redemption cursor.
- **Determinism boundary (PRICES + BENCHMARK + CLOCK all three fire here):** `entry_nav` reads
  `P_{t_sub}`; `bench_nav_inception` reads the benchmark oracle; both must be the **recorded**
  snapshot at the recorded `t_sub`, or the inception baseline is irreproducible on replay.
- **Property (structural):** the subscription move and the cursor advance commit as one atomic
  `StateDelta` (C3) — capital and the baseline that will exclude it from performance are set
  together, or neither.

### A2 · Trading under mandate
Each trade is a transaction of `q>0` moves; quantitative constraints are **preconditions** on
move generation — reject ⇒ no moves, state unchanged (l.865). **Conservation** per unit holds
trade-by-trade.
- **Property (safety, conditional):** *guard purity* — "same wallet state + same trade ⇒ same
  accept/reject" (l.866) is **false for value-based limits** (leverage, concentration-by-value):
  freeze positions, double a price ⇒ the *same* proposed trade flips to reject. Determinism
  requires `P_t ∈ inputs(guard)` (formalis B6, with whom I agree). The claim must be
  re-quantified: *same state + same trade + same `P_t` ⇒ same decision*.
- **Property gap (safety):** *passive breach* — a concentration/leverage limit breached by a
  position **appreciating** (no move) is invisible to a precondition (finops). Admission guards
  are necessary, not sufficient; a periodic valuation sweep over `V_t` is required. This is a
  liveness/monitoring property, not provable from move-locality.

### A3 · NAV
`V_ref = Σ_u w_ref(u)·P_t(u)` (l.822). State-sufficient (l.515) **given** all economic state is
recorded and `P_t` is total on the held set.
- **Property (universal/totality):** `V_t` is **partial in the price map**. A just-registered
  or illiquid unit has `P_t(u)=None` (minsky B2). `None` must be a **typed failure of the NAV
  read** (and hence of any reset that consumes it), never a silent zero — a silent zero mints a
  wrong `Perf` and a wrong real cash move.
- **Property (structural):** `u_MA` excluded (A0).

### A4 · Fee accrual & crystallisation against HWM
Two distinct cash destinations, two cadences — **must not be conflated**:
- **Management fee** accrues `mgmt_rate · Δt_k · base` (base = NAV or committed capital),
  including on losing periods; → cash move `w_ref_cash → w_manager_cash`.
- **Performance fee** charged only on NAV **above** `hwm` (and above hurdle/benchmark);
  floored at zero; → cash move `w_ref_cash → w_manager_cash`.
- **HWM update** under the `fee_crystallise` handler (C11): `hwm := max(hwm, NAV_post_fee)`.

**Conservation:** each fee move conserves USD. **Properties:**
- **(structural) HWM monotonicity:** `hwm_k ≥ hwm_{k−1}` by construction — single writer, `max`.
- **(domain) perf-fee non-negativity & HWM gate:** `perf_fee ≥ 0` and `perf_fee = 0` whenever
  `NAV_post_mgmt ≤ hwm`. No clawback of prior fees (banking-auditor, finops — I concur).
- **(structural, re-derivability):** accrued fee is **stored mutable state** in `PositionState`,
  so it is a residual internal-reconciliation surface (banking-auditor). The "no internal
  reconciliation" claim (l.962) covers *balances*, not *accruals*. **Required property:** accrued
  fee must be re-derivable from `ProductTerms[u_MA]` + the recorded `V_t`/benchmark history, and
  tie out at any reporting date (cut-off when reporting date ≠ reset date). Otherwise it can
  diverge silently from a recomputation — a Goodhart trap (the stored number satisfies the
  schema while contradicting the methodology).
- **(structural) ordering:** `fee_crystallise` and `settle` are distinct C11 handlers but their
  relative order is unfixed; perf fee is a function of NAV, so they are **non-commutative**. The
  transaction total-order tie-break (briefing l.32) must pin fee-before-settle (or vice-versa)
  deterministically.

**Determinism boundary (CLOCK is load-bearing here):** management fee = `rate · Δt_k · base`
and the TRS financing leg both depend on **elapsed time `Δt_k`**. `Δt_k` must be computed from
the **recorded schedule `{t_k}` in `ProductTerms`**, never from wall-clock at execution, or the
fee is non-replayable. PRICES (NAV) and BENCHMARK (hurdle) also enter.

### A5 · Crystallisation / settlement of performance (the reset program)
Observe `Perf = V^ref_{t_k} − V^ref_{t_{k−1}}` (l.826) → Crystallise one net move (l.836) →
Reset baseline (l.848). **This is where the workflow is not yet correct.** Three defects, all
provable against the framework's own text:

- **BLOCKER 1 — partial move-generator (sign/totality).** `Move` requires `q>0` (briefing
  l.29); `Perf` (l.841) and `Payment_k` (l.915) are **signed**. The listings hardcode
  `from:w_ref_cash, to:w_UB_cash, quantity:Perf`. For `Perf<0` this is **not representable** —
  the function is partial, and §6 is internally inconsistent with the futures-reset pattern at
  l.787 ("emit `|Payment|`; direction from sign"). **Fix (total):**
  `q=|Perf|`, `(src,dst)=(ref,UB) if Perf>0 else (UB,ref)`, reject/skip `Perf=0` (`q=0` is
  illegal). Same root cause, three sites: A5, TRS (l.915), §6.8 periodic settlement (l.951).
  *Unanimous across formalis B1, minsky B1, banking-auditor #5, finops, my prior read.*

- **BLOCKER 2 — capital-flow contamination of `Perf`.** §4 itself decomposes
  `PnL = PnL_price + PnL_flow`, `PnL_flow = Δw(USD) + Σ Δw(i)·P_{t1}` (l.547–554). A subscription
  or redemption mid-period moves `V` by the **flow**, not by performance. `Perf = V_{t_k}−V_{t_{k−1}}`
  (l.826) is *gross of flows*, so crystallising it pays the client's own subscribed capital out
  to the UB as if it were performance. The fix-data exists (`entry_nav` + sub/redemption cursor,
  A1 l.209) but the §6 formula never references it. **Required property:**
  `Perf = (V_{t_k} − NetExternalFlows_[t_{k−1},t_k]) − V_{t_{k−1}}`. *Concur finops, formalis B4.*

- **BLOCKER 3 — baseline reset ambiguous and, read literally, incorrect.** The Crystallise move
  drains `Perf` cash *from the book*, yet "Reset: baseline → state at `t_k`" (l.848) reads the
  **pre-move** `V^ref_{t_k}`. On the literal reading, with zero subsequent market move,
  `Perf_{k+1} = V_{t_{k+1}} − V_{t_k} = −Perf_k` — the system **claws performance back**. Correct
  law: `B_k := V^ref_{t_k} − Perf_k` (= the post-settlement capital base), persisted at
  `PositionState[w_ref,u_MA]` under one C11 writer. The field is **absent from A1's table** and
  tagged to no handler — a hole in the three-map model for §6. *Concur formalis B2/B8, minsky B8,
  jane-street #1.*

### A6 · Segregation
- **Property (structural, conditional):** quantity segregation — a move touches only its two
  named wallets, so one client's partition cannot perturb another's *quantity*. But P1/move-
  locality proves only "no side effect beyond named wallets"; it does **not** forbid a perfectly
  conservative move *between two clients' partitions* (jane-street #2, minsky T2 — I agree).
  Segregation is a theorem **only under C4 capability scoping**, which restricts the wallet set a
  contract may name. The §6 claim "enforced by algebra, not operational controls" (l.853) is
  therefore **overstated**: it is algebra **+ an authorization guard**. State it precisely.
- **Property (not held):** value/risk is **not** segregated — all wallets share one `P_t`.
- **Refinement gap:** the type draws no line between "may be negative" (a derivative short) and
  "must be ≥0" (segregated **client cash**, CASS). A crystallisation that drives client cash
  negative may be illegal yet is representable (minsky B3). A non-negativity refinement is needed
  exactly where regulation, not the ledger, mandates it.

### A7 · CSA margin
Wallet-level contract reads aggregate MTM across all CSA trades → required collateral
(threshold, MTA, eligible set) → margin move to the per-counterparty collateral wallet (l.859).
**Conservation** of the collateral unit holds per move.
- **Property (domain, determinism-conditional):** aggregate MTM is a pure function of recorded
  positions + `P_t`; given the same `P_t` the required-collateral computation is deterministic.
- **Property (liveness):** a margin call is *either discharged or triggers close-out netting* —
  cross-referenced to the obligation workflow (l.861). **Missing solvency property** (see below)
  applies: conservation does not guarantee the payer can fund the call.

### A8 · TRS (synthetic managed account)
`TR_k = (V^v_{t_k}−V^v_{t_{k−1}})/V^v_{t_{k−1}}` (l.887), `Payment_k = N_k·TR_k − N_k·r_k·Δt_k`
(l.906), one real move (l.911). **Conservation** in `ℒ_r` holds for the cash leg.
- **Property (universal/totality):** `TR_k` is **undefined at `V^v_{t_{k−1}}=0`** (strategy
  launches flat / wound down) and **sign-inverts at `V^v_{t_{k−1}}<0`** (net-short virtual book).
  Precondition `V^v_{t_{k−1}}>0` is unstated and must be a typed reject. *Unanimous.*
- **Property (structural) isolation P7:** no move crosses `ℒ_v ↔ ℒ_r` (l.875, l.924). As written
  this is **asserted prose**; with a flat wallet-id namespace a boundary-spanning move is not
  ill-typed. **Encode it:** phantom-tag the ledger, `Move : Wallet[L]×Wallet[L] → …`, so a
  cross-ledger move does not compile (minsky B6 — I endorse; this is the only construction that
  makes P7 hold *by construction* rather than by discipline).
- **Sign defect (BLOCKER 1) recurs** at `Payment_k`.

### A9 · Redemption
Client withdraws: cash move `w_ref_cash → w_client_external`, **after** crystallising
outstanding fees (equalisation). Updates `entry_nav`/cursor under the `subscribe` handler.
- **Property (the dual of BLOCKER 2):** a redemption is a **flow**, not negative performance; it
  must be netted out of the next `Perf`, not crystallised as a loss to the UB. Same data, same
  fix as BLOCKER 2.

### A10 · Balance-sheet substantiation
Each balance = deterministic projection (fold) of the move stream filtered to the wallets
(l.962); no internal record to reconcile.
- **Property (structural) idempotent replay (P5/P6):** re-firing a reset must not double-pay;
  each reset needs an explicit idempotency key `(w_client,u_MA,t_k)` dedup'd via the cursor
  (minsky T4, finops #4). The append-only hash-chained log (P4) makes replay a literal fold.
- **Scope correction:** "single source of truth, no internal reconciliation" is a **quantity +
  economic-substance** claim. It does **not** extend to (a) stored accruals (A4 re-derivability),
  nor (b) reference data (LEI/UTI/UPI), which regulatory-reporter correctly places outside the
  stream. The projection claim must be scoped to what the stream actually determines.

---

## B. Missing global property: settlement solvency (liveness)

Crystallising **unrealised** MTM (positions stay in-book, l.944) drains `w_ref_cash` while gains
sit in non-cash position value. Conservation holds (quantity), yet `w_ref_cash` can go negative.
Negative is a *legal* short by the primitive (briefing l.22), so **nothing distinguishes a funded
obligation from an insolvent overdraft.** There is no property guaranteeing the payer can fund the
move. **Missing property:** a funding precondition, or an explicit `obligation` vs `overdraft`
classification at every crystallisation/margin boundary (A5, A7, A8). Conservation gives no
liveness; this must be added, not assumed. *Concur finops, minsky B3.*

---

## C. The property taxonomy (the ramp) for §6

| Level | Property | Status |
|---|---|---|
| **Universal** | every emitted move legal (`q>0`, two named wallets) | **FAILS** — BLOCKER 1 (signed Perf/Payment) |
| **Universal** | `V_t`/`Perf` total over price map; `P_t(u)=None` ⇒ typed failure | **MISSING** — minsky B2 |
| **Universal** | `TR_k` total; `V^v_{t_{k−1}}>0` precondition | **MISSING** |
| **Structural** | conservation `Σ_w w(u)=0` incl. `u_MA` | **holds by construction** |
| **Structural** | `u_MA` non-valued (typed exclusion from `V_t`) | **MISSING (typed)** |
| **Structural** | `u_MA` support cardinality `{+1,−1}` | **MISSING** — refinement, not P1 |
| **Structural** | atomic `StateDelta` across three maps (C3) per reset | required, assert it spans Observe+Crystallise+Reset |
| **Structural** | HWM monotone, single writer | holds by construction (C11+`max`) |
| **Structural** | reset idempotency keyed `(w,u_MA,t_k)` | **MISSING (explicit key)** |
| **Structural** | `ℒ_v↔ℒ_r` isolation by phantom type | asserted in prose; **encode it** |
| **Safety** | guard purity *incl. `P_t`* | claim mis-quantified (formalis B6) |
| **Safety** | segregation under C4 capability scoping | conditional; §6 overstates |
| **Safety** | passive-breach valuation sweep | **MISSING** |
| **Domain** | `Perf` net of external flows | **FAILS** — BLOCKER 2 |
| **Domain** | baseline `B_k = V_{t_k} − Perf_k` | **FAILS** — BLOCKER 3 |
| **Domain** | perf-fee `≥0`, gated on HWM, no clawback | must be asserted |
| **Domain** | accrued fee re-derivable & tied to `V_t` | **MISSING** — Goodhart surface |
| **Liveness** | settlement solvency / funding precondition | **MISSING** (§B) |
| **Speculative** | `Σ_k crystallised_k == V_n − V_0 − Σ flows` within 1 ULP | **rounding residue breaks it** (§D) |

---

## D. Determinism boundaries (my primary charge: benchmark, prices, clock)

§6 crosses **three** non-deterministic boundaries. Each mints a real, irreversible cash move and
each must be an **injected, recorded, content-addressed input** for replay/P3/P10/state-
sufficiency to mean anything. The framework asserts "the same price vector used for all other
purposes" (l.974) but **never makes any of the three an addressable, snapshotted object.**

**1 · PRICES — `P_t` (the master oracle).** Feeds: NAV/Observe (A3, l.822), fee crystallisation
(A4), CSA aggregate MTM (A7), TRS `TR_k`/`Payment_k` (A8), value-based guards (A2). Requirements:
- Recorded as a content-addressed immutable snapshot referenced from the stream — a re-fetch must
  reproduce bit-identical `Perf`. "Bankers' rounding, bit-identical outputs" (briefing l.40) and
  the hash-chained log (P4) extend to *value* only if `P_t` itself is snapshotted.
- **One snapshot, two ledgers:** `ℒ_v` valuation and `ℒ_r` TRS settlement must reference the
  **same snapshot id**, with equality verifiable by hash — *price consistency* (l.922) enforced
  by **sharing one value**, not by validating two fetches after the fact (minsky B7, formalis B5).
- Injectable as a **named argument**, never an ambient read. Flag any handler that reads a live
  oracle: it is impure and non-replayable.

**2 · BENCHMARK — `UnitStatus[u_bench]` (a *second*, distinct oracle).** Feeds the perf-fee
hurdle (A4) and `bench_nav_inception` (A1). A wrong level mis-charges **client money**. It has the
*same* determinism requirements as `P_t` (recorded snapshot at inception and at each `t_k`) but is
a **separate trust surface** — do not fold it into `P_t`. Its inception level must be the recorded
snapshot tagged to the `subscribe` handler (C11).

**3 · CLOCK — the reset schedule `{t_k}`.** A determinism boundary for three reasons:
- **Elapsed-time dependence:** management fee `rate·Δt_k·base` (A4) and TRS financing
  `N_k·r_k·Δt_k` (A8) depend on `Δt_k`. `Δt_k` must derive from the **recorded `{t_k}` in
  `ProductTerms`**, never wall-clock at execution.
- **Freshness contract (MISSING):** resets fire on schedule regardless of price freshness. There
  is no max-staleness, no fallback chain (primary→secondary→last-known-good-with-flag→hard-stop),
  no behaviour-at-threshold (nazarov B2). Silent use of a stale price at `t_k` is a **silent
  fallback — forbidden** — and it mints real cash.
- **Snapshot-time vs price-time skew (MISSING):** Observe reads positions *and* `P_t` "at `t_k`"
  (l.832); nothing binds the position-snapshot timestamp to the price-snapshot timestamp (nazarov
  B6). P8 covers ledger-internal snapshots only.

**Latent 4th (lifecycle, flagged not owned):** path-dependent observations (`triggered_barrier`
for QIS wind-down) are **not state-sufficient** — an intra-period barrier *touch* is not
recoverable from reset-time snapshots (nazarov B4). Any handler that consumes a path observation
needs its own attested intraday feed; it cannot be reconstructed from `{t_k}` snapshots.

**Rounding residue (§D corollary, value-telescoping).** Bankers' rounding at instruction
generation (l.40) makes `Σ_k round(Perf_k) ≠ V_n − V_0` by accumulated dust, while the baseline
resets to **unrounded** `V_{t_k}`. The residue must be a **typed, conserved value retained in the
book** (an un-crystallised remainder in `w_ref`), never silently dropped — else either P10
telescoping fails at the settled level or "PnL reset to zero" is false (minsky B4, finops #2, my
prior read). Carry it forward so cumulative crystallised cash reconciles to cumulative performance
within 1 ULP.

---

## E. Blockers (must resolve before approval)

1. **Signed-move totality** (A5/A8/§6.8): emit `|Perf|`/`|Payment|`, direction from sign, reject
   zero. Three sites, one fix. (BLOCKER 1)
2. **Flow-adjusted performance** (A5/A9): `Perf = (V_{t_k} − NetFlows) − V_{t_{k−1}}`. (BLOCKER 2)
3. **Baseline law** (A5): `B_k = V_{t_k} − Perf_k`, persisted at `PositionState[w_ref,u_MA]` under
   one C11 writer; field added to the A1 table. (BLOCKER 3)
4. **Settlement-solvency property** (§B): funding precondition or `obligation`/`overdraft`
   classification at every crystallisation/margin boundary.
5. **Totality of `V_t` and `TR_k`**: `P_t(u)=None` and `V^v_{t_{k−1}}≤0` are typed rejects, not
   silent zeros.
6. **Determinism of all three boundaries** (§D): `P_t`, benchmark, and `{t_k}` recorded as
   injected, content-addressed snapshots; `ℒ_v`/`ℒ_r` bound to one price-snapshot id; freshness
   contract defined.

None of these requires changing the framework. They are §6 corrections / invariants §6 currently
leaves implicit — **not** StatesHome reversals. The mechanism is sound *as quantity algebra*
(conservation and quantity-segregation hold by construction); it is **not yet correct as a
performance engine** until E1–E3 land, nor **replayable** until E6 lands.

---

## F. Concrete properties to instrument (Hypothesis)

```python
# BLOCKER 1 — every emitted move legal regardless of sign (3 sites)
@given(perf=decimals(allow_negative=True))
def test_crystallise_move_is_legal(perf):
    m = crystallise(perf)
    assert m.quantity > 0 and m.src != m.dst
    assert (m.src, m.dst) == ((w_ref, w_ub) if perf > 0 else (w_ub, w_ref))
    assume(perf != 0)            # q==0 is illegal -> reset must skip, not emit

# BLOCKER 2 — flow-adjusted telescoping (headline invariant)
@given(resets=reset_streams(with_flows=True))
def test_perf_net_of_flows(resets):
    crystallised = sum(r.perf for r in resets)
    assert crystallised == (V(resets[-1].t_k) - V(resets[0].t0)
                            - sum(r.net_external_flow for r in resets))

# BLOCKER 3 — baseline is post-settlement; no claw-back on a flat market
@given(book=books())
def test_baseline_is_post_settlement(book):
    r = crystallise_on(book)
    assert r.baseline == r.V_tk - r.perf           # == prior capital base
    nxt = crystallise_on(advance(book, no_market_move=True))
    assert nxt.perf == 0

# §B — funding precondition explicit, not implied by conservation
@given(book=books())
def test_crystallisation_funding_classified(book):
    r = crystallise_on(book)
    assert r.funded or r.flagged_as_obligation       # never a silent negative cash row

# E5 — totality of V_t / TR_k
@given(held=portfolios())
def test_nav_partial_in_price_is_typed_failure(held):
    if any(price_of(u) is None for u in held.units):
        with pytest.raises(UndefinedNAV): nav(held)
@given(v_prev=decimals())
def test_tr_k_requires_positive_base(v_prev):
    assume(v_prev <= 0)
    with pytest.raises(UndefinedReturn): total_return(v_prev, v_next=anything())

# E6 / boundaries — replay is a pure fold over recorded P_t; one snapshot, two ledgers
@given(stream=event_streams())
def test_valuation_is_pure_fold(stream):
    k = len(stream)//2
    assert V_after(apply_all(stream)) == V_after(apply_all(stream[:k]) + stream[k:])
@given(snap=price_snapshots())
def test_lv_lr_share_one_snapshot(snap):
    assert lv_valuation(snap).snapshot_id == trs_settlement(snap).snapshot_id

# §D corollary — rounding residue is conserved, not dropped
@given(resets=reset_streams())
def test_residue_conserved(resets):
    moved = sum(round_bankers(r.perf) for r in resets)
    book_residue = w_ref_cash_residue_after(resets)
    assert moved + book_residue == sum(r.perf for r in resets)   # within 0 ULP
```

---

## G. Tensions logged (to resolve in adversarial round)

1. **vs `formalis` — multi-mandate performance attribution.** formalis (B3) holds that splitting a
   single wallet's scalar `Perf` into base + overlay performance is "not a projection of the move
   stream" and requires **disjoint sub-partitions**. I hold that a **total, deterministic
   allocation function declared in `ProductTerms[u_MA]`** *is* a projection — *provided* each
   mandate acts on tagged, disjoint positions. Where base and overlay act on the **same**
   positions (overlay mutates the same book), attribution becomes a *counterfactual* ("what the
   book would have returned without the overlay") which is **not** state-sufficient — there
   formalis is right. Tension: is disjoint sub-partitioning the *only* fix, or does a declared
   allocation function suffice for the non-overlapping case? Needs the formalis/jane-street
   tie-break.

2. **vs `nazarov-data-architect` — scope of the determinism boundary.** nazarov bundles
   *attestation* (provenance, signature, multi-source quorum, disagreement detection) into the
   price/benchmark boundary. I separate two distinct properties: **determinism** (the *same* datum
   reproduces on replay — satisfied by recording + content-addressing) vs **veracity** (the datum
   is the *right* one — needs attestation). Both are required, but they are different invariants
   with different owners and different failure signals; my charge (replay/P3/P10) is closed by
   recording alone, whereas nazarov's correctness-of-settlement needs the attestation layer on
   top. Tension is one of factoring, not of conclusion — log so the two boundaries are specified
   separately, not merged.

3. **vs `jane-street-cto` — minimal recorded object for the baseline.** jane-street (#1) proposes
   the reset event **snapshot `P_{t_{k−1}}`/`V_{t_{k−1}}`** into its payload so `Perf` stays a
   pure fold. I prefer storing the baseline as a **single C11-tagged NAV scalar `B_{k−1}` in
   `PositionState[w_ref,u_MA]`** (= the previous reset's post-settlement value): replay is still a
   fold and the recorded object is one decimal, not a whole price vector. The two diverge under a
   **back-dated price correction**: jane-street's snapshot re-derives from corrected prices; my
   scalar would be stale and require a compensating reset. Tension: snapshot-the-prices vs
   store-the-scalar — which is the minimal *and* correction-safe recorded baseline. Resolve with
   nazarov's correction model (B7) in the loop.
</content>
</invoke>
