# §6 Managed-Account Workflow — Review by `jane-street-cto`

**Charge (Step 2): the simplicity gate.** Reject any map, coordinate, or abstraction that an
existing primitive already covers. Every state change must be an atomic move with conservation
verified. Justify from the primitives, not convention.

Verdict up front: **NEEDS DISCUSSION.** The collapse of desk / PB / QIS / TRS to one
Observe→Crystallise→Reset mechanism is correct and minimal, and mandate-as-unit earns its
place. But §6 + A1 carry four redundant abstractions that existing primitives already cover,
and one of them — the stored economic scalars in `PositionState[w,u_MA]` — directly contradicts
the framework's own ruling at addendum l.189. These are minimalism defects, and several of them
*also* remove correctness blockers other lenses raised, so cutting them is strictly dominant.

---

## A. The workflow, derived from primitives, with conservation checked at every step

I walked each §6 sub-workflow and reduced it to moves. Every economic state change is a move or
a set of moves; everything else is a projection (no state change). Conservation `Σ_w w(u)=0`
holds at each step by the `src -= q; dst += q` pattern.

| Step | Move(s) | Conservation |
|---|---|---|
| **Mandate issuance** | `w_mgr(u_MA) -= 1; w_client(u_MA) += 1` | `Σ_w w(u_MA)=0` by issuance law ✓ |
| **Subscription** | `w_client_ext_cash → w_ref_cash`, USD, `q=sub` | ✓ — this is a **flow**, not performance |
| **Trading-under-mandate** | per trade: `w_ref_cash → w_cpty_cash` (USD) and `w_cpty(asset) → w_ref(asset)`, atomic τ; guard precondition checked pre-emission | ✓ per unit |
| **NAV** | none — `V^ref_t = Σ_u w(u)·P_t(u)`, a projection | n/a (no state change) |
| **Fee accrual** | none — accrual is a projection of `ProductTerms · V_t · HWM` | n/a |
| **Crystallisation vs HWM** | `w_ref_cash → w_mgr_cash`, `q=|fee|`, only if fee>0; HWM ratchets | ✓ |
| **Segregation** | none — it is a *guard*, not a move (see C-4) | n/a |
| **CSA margin** | wallet contract reads aggregate MTM, emits `w_firm_coll ↔ w_cpty_coll`, `q=required` | ✓ |
| **TRS** | observe `ℒ_v` MTM, emit `w_payer → w_receiver`, `q=|Payment_k|` | ✓; no cross-realm move |
| **Redemption** | `w_ref_cash → w_client_ext_cash` (or position units, in-kind), `q=redeem`; crystallise outstanding fees first | ✓ — also a **flow** |
| **Balance-sheet substantiation** | none — projection of stream filtered to wallets | n/a |

The algebra is clean. The defects are not in the moves; they are in the *coordinates and
abstractions piled on top of the moves*. That is my gate.

---

## B. Coordinates and abstractions I REJECT (existing primitive already covers)

### B-1. Stored `hwm`, `entry_nav`, `accrued_{mgmt,perf}_fee`, `mandate_breach_flags` are projections, not state — and the framework already knows this

A1 l.111 / l.208–210 homes these as authoritative `PositionState[w_client,u_MA]` fields with
C11 writers. **Reject them as authoritative state.** Each is a deterministic fold over
`(move stream + recorded price snapshots + ProductTerms methodology)`:

- `entry_nav` = `V^ref` at the subscription event = a projection given the price at that event.
- `hwm` = running max of post-crystallisation NAV over reset dates, per methodology = a fold.
- `accrued_fee` = `methodology(elapsed, V_t, hwm, hurdle)` = a pure function of the above.
- `breach_flags` = `guard(state, P_t)` = a projection recomputed at any valuation.

The framework **already ruled this exact question the right way** at addendum l.189:
`first_touch_date` is **NOT state** — "derived from the event log on demand. Caching it in
`PositionState` would create a fold-inconsistency under back-dated corrections." `hwm`,
`entry_nav`, and `accrued_fee` are the *same kind of object* — folds over the log — and inherit
the *same* fold-inconsistency under back-dated **price** corrections (the case Nazarov B7 and
finops both raise). A1 is internally inconsistent: it derives one fold and caches three others.
Apply l.189 uniformly: derive them; permit a materialised value **only** as a checkpoint that
must equal the recompute (a cache, never the source of truth). Storing them as authoritative
reintroduces precisely the internal-reconciliation surface the Ledger exists to eliminate —
which banking-auditor and finops both flagged as a residual reconciliation risk. I go further
than they do: it is not a risk to *manage*, it is a coordinate to *delete*.

Two consequences that *simplify other lenses' concerns*:
- **`breach_flags` as a projection catches passive breaches for free** (finops's "appreciation
  breaches escape the trade-time guard"). A stored flag updated only on trades misses them; a
  projection recomputed on each valuation sweep does not. Deriving is *more* correct.
- **C3's three-map atomic write largely evaporates at the reset.** If `hwm`/`accrued`/baseline
  are projections, the only thing committed at a crystallisation is `(the cash move + the price
  snapshot)` — a single append to the stream, not a coordinated StateDelta across three maps.
  C3 still earns its place for genuine shared-mutable transitions (a `UnitStatus.lifecycle`
  flip, A1 l.245), but it is **not** load-bearing for the reset. This corrects my own
  independent read, which over-credited stored state when it asserted "atomic reset across all
  three maps." The reset needs atomicity across `(move, price-snapshot)` only.

This does **not** reverse C12. C12 governs *where* per-`(w,mandate)` state is keyed *if it is
state*; the checkpoint, when materialised, still lives at `(w_client,u_MA)`. I am narrowing
*what counts as state*, not moving its key.

### B-2. The virtual ledger as "a second complete ledger instance" — reject; a realm tag on the existing wallet primitive covers it

§6 (l.916–924) defines `ℒ_v` as "a complete ledger instance — wallets, move stream, unit state,
conservation law, lifecycle engine." That is a heavy abstraction. The wallet primitive already
says a wallet "is **not** a custody account; the settlement layer maps wallets to external
accounts." A *virtual* wallet is simply a wallet the settlement layer maps to **nothing**. The
minimal basis is therefore a single coordinate — `realm ∈ {real, virtual}` — on the existing
wallet, with **P7 = the typing rule that a move's source and destination share a realm**
(minsky B6 independently derives the same thing: `Move : Wallet[L] × Wallet[L]`).

The "second instance" framing buys nothing and costs duplication:
- It does **not** even deliver the isolation it claims. With a flat wallet-id namespace nothing
  makes a cross-instance move ill-typed (minsky B6); you still need the realm tag/type to
  enforce P7. So separation comes from the tag regardless — the duplicate instance is dead weight.
- It makes **price consistency harder, not easier.** §6's own "same `P_t`" requirement
  (l.922) and Nazarov B3 / minsky B7 all want **one** price object shared by valuation and
  settlement. A single realm-tagged wallet space has **one** unit registry and **one** `P_t` by
  construction — "same price" is automatic, not an assertion to police. Two instances mean two
  registries to keep byte-identical, which is the exact failure surface those lenses fear.
- Per-realm conservation is free: conservation restricted to a tag class holds automatically
  once every move stays within its realm (the P7 typing rule).

So the realm tag is **simultaneously simpler and more correct** than the second instance. Reject
the second-instance abstraction; keep the tag. (This is a genuine Step-2 cut, and it conflicts
with the spec's framing and with correctness-architect's "two closed instances" model — logged
below.)

### B-3. Three crystallisation contracts / three Move listings — reject; one parameterised move-generator covers all

§6 presents three separate listings with three formulas: managed-account
`Perf = V_{t_k}−V_{t_{k-1}}` (l.842), TRS `Payment_k = N_k·TR_k − N_k·r_k·Δt_k` (l.915), and
periodic settlement `PnL = V_{t_k}−V_{t_{k-1}}` (l.965). The first and third are **literally
identical**; the TRS adds a financing leg. The spec itself says they are "the same mechanism"
(l.969) — then writes them three times. Duplication is a defect: minsky/formalis/correctness all
note the **same sign bug appears at three sites** (B-4 below) precisely because it is copied
three times. Collapse to **one** generator:

```
Crystallise(reference, UB, financing_leg) -> Move
    perf = Observe(reference)                # V_tk − V_t(k-1), flow-adjusted (B-5)
    net  = perf − financing_leg              # financing_leg = 0 for the non-TRS case
    q    = abs(net); src,dst = (ref,UB) if net>=0 else (UB,ref)
    emit Move(src, dst, USD, q, t_k, ...)
```

`reference` is a real wallet or a virtual-realm wallet (B-2); `financing_leg` is `N_k·r_k·Δt_k`
or zero. One function, one site to prove, one site to fix. This is the minimal basis of §6.2 /
§6.6 / §6.8.

### B-4. Signed quantity in a `q>0` field — reject; the framework's own `|q|`+direction pattern covers it

The listings hardcode `from: w_ref_cash, to: w_UB_cash, quantity: Perf_k` (l.842) and the
identical TRS/periodic forms. The Move primitive makes `q>0` a type invariant (briefing l.29).
`Perf_k`/`Payment_k` are signed. For a loss this constructs a **non-representable** state — an
illegal state made representable only by ignoring the primitive. The framework **already solved
this correctly** for the futures reset at v10.3 l.787 ("emit `|Payment_k|`; direction from
sign"). §6 is internally inconsistent with l.787 and with Def 2.3. Fix once, in the single
generator (B-3): `q=|net|`, direction from `sign(net)`, reject `net=0`. I concur fully with
formalis B1 / minsky B1 / correctness B / banking #5 — this is one root cause, one fix.

### B-5. `Perf = V_{t_k} − V_{t_{k-1}}` conflates performance with capital flows — the flow filter is a projection, not a new field

Subscriptions and redemptions move `V` without being performance. `Perf` must be
`(V_{t_k} − NetFlows_[t_{k-1},t_k]) − V_{t_{k-1}}`. The fix needs **no new coordinate**: the
flows are already moves in the stream, tagged `SUBSCRIPTION`/`REDEMPTION`; net flow is a
projection over those tagged moves. The "subscription/redemption cursor" (A1 l.209) is that
filter — and it too is a projection, not stored state (reinforces B-1). I concur this is the
headline correctness gap (correctness A, formalis B4, finops, minsky), and add: it is fixed by
*deriving*, not by storing a cursor scalar.

### B-6. Multi-mandate attribution — reject an attribution *coordinate* where a disjoint sub-wallet already covers it

A1 l.217 places base+overlay as two `PositionState` rows on **one** wallet, each with its own
HWM. But one wallet yields **one** `V^ref`; splitting it into base-`Perf` and overlay-`Perf` is
not a projection of the stream — it needs an attribution rule the primitives do not supply
(formalis B3, minsky B5). My gate ruling: **prefer the existing wallet-partition primitive.** If
the two mandates reference distinct position sets, give each its own sub-wallet — then each
`Perf` is a clean projection and *no attribution coordinate is added*. Only when an overlay
genuinely shares one book is an attribution function unavoidable; then it must be a **declared,
total** function in `ProductTerms[u_MA]`, reconstructible from the stream — an admitted
coordinate, justified because no primitive covers same-book attribution. Do not smear an
attribution rule across the general case to support the special one.

---

## C. Coordinates I ADMIT (they earn their place) and one claim I reject as miscredited

- **`u_MA` as a unit — admit.** Real issuer (manager), real holder (client), conserves by the
  issuance law. Not the rejected Dirac `u_∅`. It is the contract identity handle and nothing
  cheaper carries the bilateral relationship. **But reject valuing it:** `P_t(u_MA)` must be
  undefined/0 so `u_MA` never enters `V_t`. The exposure is already the underlying positions; a
  price on `u_MA` is a redundant coordinate double-counting the same economic fact
  (banking-auditor #2 — concur).
- **`PositionState[w,u]` as a record — admit** for genuinely irreducible per-position lifecycle
  state (OTC `ccp_binding`, per-position lifecycle). That state is not a fold over cash moves.
  My B-1 cut removes only the *economic scalars that are folds*, not the per-position lifecycle.
- **`WalletRegistry` — admit;** explicitly non-economic (KYC/permissions). Not in my scope.
- **Per-client wallet model makes equalisation/series accounting unnecessary — a minimalism
  win.** banking-auditor lists "equalisation/series accounting" as model risk. That machinery
  exists to fairly allocate one *pooled* NAV across investors who entered at different HWMs. The
  Ledger gives each managed account **its own wallet and its own HWM** — there is no pool to
  equalise. The wallet-partition primitive already covers what equalisation solves. Do not add
  series accounting; it is a coordinate the partition makes redundant.
- **Reject "segregation by conservation" as stated (l.855).** Conservation does **not** forbid a
  move whose source and destination lie in two different clients' partitions — that move is
  perfectly conservative. The actual guarantee is "no *unnamed* side effects." Real segregation
  rests on the **C4 capability guard / `WalletRegistry` permissions**, which is not a structural
  invariant. This is not an abstraction I save — it is one the spec **miscredits**: algebra is
  asked to do a permission check's job. State it precisely so no 3am responder trusts
  conservation to enforce an authorization boundary (minsky T2 conditional-on-C4 — concur).

---

## D. The linchpin: `P_t` is an explicit, recorded, shared argument — not an ambient oracle

Every cut above depends on one discipline. `V_t`, `Perf_k`, `TR_k`, and every value-based guard
are pure functions of `(balances, unit state, P_t, total order)` — and `P_t` is **external**,
not ledger state. Therefore:
- `P_t` must be threaded through the contract signature explicitly, never read from two ambient
  oracles. The contract is **not** a pure function of ledger state alone; pretending it is hides
  the one nondeterministic input (correctness H, formalis PO-Determinism, Nazarov B1–B3).
- `P_t` must be a **recorded, content-addressed snapshot event in the stream.** This is what
  makes B-1 legal: once the price at each reset is in the log, `hwm`/`entry_nav`/`accrued`/the
  baseline are folds and replay is bit-reproducible (P3/P10). Without recorded prices the
  baseline is *not* derivable and you are forced back into a stored, desyncable scalar — the
  worst of both worlds.
- Thread **one** `P_t` value into both valuation and settlement; do not fetch two and reconcile
  them (minsky B7). With the single realm-tagged wallet space (B-2) there is one `P_t` by
  construction.

`TR_k = (V^v_{t_k}−V^v_{t_{k-1}})/V^v_{t_{k-1}}` is additionally **partial** at
`V^v_{t_{k-1}} ≤ 0` (flat/wound-down/net-short book). Precondition `V^v_{t_{k-1}} > 0` must be
stated and the violation a typed failure, not a NaN (formalis B7, correctness E, minsky B2 — concur).

---

## E. Net

The mechanism is sound as quantity algebra and the one-mechanism collapse is the right design.
What §6 + A1 over-build:

1. **B-1** stored `hwm`/`entry_nav`/`accrued`/`breach_flags` — delete as authoritative; derive
   per the framework's own l.189 ruling; keep only as recompute-checked checkpoints.
2. **B-2** the second full `ℒ_v` instance — replace with a `realm` tag / phantom type on the
   wallet; simpler *and* more correct on price consistency.
3. **B-3/B-4** three crystallisation listings with a signed-`q` bug — collapse to one
   `|q|`+direction generator, per l.787.
4. **B-5/B-6** flow-contaminated `Perf` and smeared multi-mandate attribution — fix by
   projection / sub-partition, not by new coordinates.

Each cut removes machinery *and* closes a correctness gap another lens raised. None requires
changing the framework; all require **stating** what §6 left implicit and **deleting** what A1
stored that the log already determines. The one thing that must be *added* is the recorded,
shared `P_t` snapshot (D) — without it, B-1 is unsafe and replay is not reproducible.

The 3am test: a responder must be able to recompute any HWM, fee, or baseline from
`(stream, recorded prices, ProductTerms)` and get the byte-identical number the system acted on.
Today, with those values stored as authoritative mutable scalars, they cannot — there is a
cached number to distrust. Delete the cache's authority and the test passes.
