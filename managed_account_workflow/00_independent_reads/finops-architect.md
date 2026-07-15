# Independent read — `finops-architect` lens

Ledger §6 + Addendum A1. Operations/reconciliation/settlement lens. Derived from the
primitives; not from market practice.

## What it is (from the primitives)

A managed account is **two objects on one move stream**: (a) a wallet partition `w_client`
that holds positions and generates PnL, and (b) a mandate unit `u_MA` issued by the manager,
`w_manager(u_MA)=−1, w_client(u_MA)=+1`, so issuance balances by the standard conservation
law (P1). Everything an operator would normally keep in a side ledger — HWM value, accrued
mgmt/perf fee, entry NAV, breach flags, subscription/redemption cursor — is **per-position
state `PositionState[w_client, u_MA]`**, tagged (C11) to a unique mutating handler. The static
deal terms (fee schedule, HWM/hurdle methodology, crystallisation frequency, limits) sit in
immutable versioned `ProductTerms[u_MA]`. The account "balance" and the client statement are
not stored records; they are a **projection of the move stream filtered to `w_client`** (§6.9).

This is the operator's dream: double-entry is structural (every move is two legs, `Σ_w
w(u)=0`), there is **no internal sub-ledger to reconcile** — the move stream is the evidence.
The only reconciliation surface is the **external boundary** (custodian, counterparty
confirmations). Crystallisation is one deterministic net cash move at each reset `t_k`:
Observe `Perf=V_{t_k}−V_{t_{k-1}}` → Crystallise `w_ref_cash→w_UB_cash` → Reset baseline.

## What must hold

1. **Double-entry by construction (P1).** Every fee/perf/PnL crystallisation is a two-legged
   move with explicit src/dst. Cash that crosses the boundary at `t_k` must equal the computed
   amount **to the penny**; the move *is* the entry, so there is no second record to break.
2. **Decimal + bankers' rounding only at instruction generation.** Internal HWM, entry_nav,
   accruals stay full-precision; rounding happens once, when the cash instruction is cut. The
   sub-penny residual between economic `Perf` and the rounded moved cash must remain in
   `w_ref` (an un-crystallised remainder), never be silently dropped.
3. **HWM/accruals are per-`(w_client, u_MA)`, never a per-wallet scalar (C12).** A client with
   base+overlay carries two rows, two HWMs, two fee streams. Collapsing to a wallet scalar
   cross-subsidises fees — a correctness failure, not a style choice.
4. **Reset idempotency (P5/P6).** Replaying `t_k` must not double-pay. Each reset needs an
   idempotency key; the immutable, hash-chained log (P4) makes replay a literal fold.
5. **Handler isolation (C11) and atomic StateDelta across all three maps (C3).** A
   crystallisation that updates `accrued_fee`, `hwm`, and emits the cash move is one atomic
   delta or it is rejected — no partial books.
6. **Price consistency for synthetic accounts.** Virtual ledger valuation and TRS/PnL
   settlement must use the same `P_t`, else unexplained PnL with **no internal reconciliation
   path** — only a contractual price-source pin can close it.

## Where it can break (operator's failure modes)

- **Capital flows corrupt `Perf=V_{t_k}−V_{t_{k-1}}`.** A subscription or redemption mid-period
  moves `V` by the cash flow, not by performance. The §6 formula is *gross of flows*. Unless
  subscription/redemption moves are netted out of the performance computation (true-NAV /
  equalisation against `entry_nav`), the next crystallisation pays a fee on contributed
  capital. This is the single most dangerous gap; `entry_nav` + the subscription cursor exist
  to fix it but the §6 reset formula as written does not use them.
- **Negative performance / direction.** Moves require `q>0`; direction encodes sign. A loss
  reverses the move direction (`w_UB→w_ref`); the perf-fee leg must floor at zero with HWM
  loss-carryforward (no clawback of prior fees), while the desk-vs-Treasury PnL leg genuinely
  flips. Conflating "PnL settlement" with "performance fee" mis-signs cash.
- **Funding of unrealised PnL.** Crystallisation pays from `w_ref_cash`; if gains are
  unrealised, the move drives cash negative (allowed: negative=obligation). Logically clean,
  but operationally an overdraft / funding event the settlement layer must source. The ledger
  shows the obligation; it does not fund it.
- **Settlement finality is outside scope.** The crystallisation move is instantaneous and
  treated as final inside the closed system, but external cash settles T+1/T+2 and can *fail*.
  A fail has no in-ledger representation except a **compensating reversing transaction**
  (immutability ⇒ reverse, never edit). The lifecycle Trade→…→Settlement→Reconciliation lives
  at the boundary, not in the projection.
- **Passive limit breaches escape the guards.** Mandate constraints are preconditions on
  *move generation* — they catch active trades. A concentration/leverage limit breached by a
  position *appreciating* (no move) is invisible to a precondition. Passive-breach detection
  needs a periodic valuation sweep, not just admission guards.
- **The §6 "structural identity" hides different boundary regimes.** Desk-vs-Treasury (internal
  reallocation: no external settlement, no client reporting, no HWM) and a PB/QIS client
  account (external client cash, CASS-6/MiFID safeguarding, SFTR/EMIR reporting, fiduciary
  fees) share the *mechanism* but not the *controls*. Treating them identically risks omitting
  the external boundary controls that only the client case requires.
- **Mandate issuance as a reportable event (F5).** `w_manager(u_MA)=−1` is itself an issuance;
  whether it triggers SFTR/EMIR UTI/LEI reporting is ungoverned. Needs a `reportable` flag on
  `ProductTerms[u_MA]` and a regulatory pre-flight — an external dependency, not codeable away.
- **Fee-cadence mismatch.** Daily PnL sweep vs quarterly perf-fee crystallisation on the same
  wallet are two reset cadences; they must not be conflated under one "fee_crystallise" handler.

## Bottom line
The model is operationally strong: one immutable stream, structural double-entry, no internal
break possible, the move stream as audit evidence. The exposure is entirely at the **boundary
and in the crystallisation arithmetic** — capital-flow netting in the `Perf` formula,
rounding-residual handling, external settlement finality/fails, and the differing control
regimes the §6 unification papers over.
