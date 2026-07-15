# Briefing — Managed-Account Workflow (Ledger §6 + Addendum A1)

This is the shared, authoritative briefing for every agent in the managed-account workflow.
It is a faithful condensation of the Ledger v10.3 specification and Addendum A1 (StatesHome).
The full sources are at `/home/renaud/Ledger/past_work/ledger_v10.3.tex` (Section 6 at lines
806–977; primitives §2 lines 111–298; Unit Store §3 lines 300–491; Valuation/PnL §4 lines
494–601; Smart Contracts §5 lines 604–804; Balance-Sheet Substantiation §8 lines 1483–1599;
Invariants §9 lines 2018–2166; CDM Integration lines 1889–2018; Regulatory lines 2169–2189)
and `/home/renaud/Ledger/past_work/ledger_v10.3_addendum_stateshome.tex` (full). Read those
for any detail not captured here. **Do not invent facts; derive from the primitives or cite
an enforceable source. Do not appeal to market practice.**

The governing principles (from CLAUDE.md), in order: **Correctness** (properties hold by
construction; illegal states not representable; prove, do not assert; derive then show
conformance), **Minimalism** (fewest primitives), **Simplicity** (shippable over elegant),
**Clarity** (each statement once, result first, deductive order).

---

## 1. Primitives

- **Wallet** `w ∈ 𝒲`: a logical partition of position space. State `w_t : 𝒰 → ℝ`,
  `w_t(u)` the signed quantity of unit `u`. Negative = short/obligation. Not a custody or
  legal account; the settlement layer maps wallets to external accounts.
- **Unit** `u ∈ 𝒰`: anything that can be a wallet balance (cash, equity, listed/OTC deriv,
  bond, structured note, **and a mandate/strategy contract**). Identity by fungibility: two
  positions are the same unit iff a holder is economically indifferent. OTC unit identity =
  full CDM `Trade` incl. `Collateral`.
- **Move** `m = (w_s, w_d, u, q>0, t, source, metadata)`: indivisible transfer.
  Semantics `w_s(u) -= q; w_d(u) += q`. Quantities are positive; direction encodes sign.
- **Transaction** `τ = {m_1,…,m_n}`: finite set of moves, same timestamp, applied atomically
  (all or nothing). A total order breaks timestamp ties for deterministic replay.
- **Conservation Law (P1)**: for every τ and every unit u, net change across all wallets is
  zero. Hence **system closure**: `Q(u) = Σ_{w∈𝒲} w_t(u) = 0  ∀u,∀t`. Algebraic, by the
  `src -= q; dst += q` pattern — not a runtime check. External counterparties are **virtual
  wallets** inside the closed system; the ledger has no "outside" within scope.
- **Issuance law**: a contract unit issued by party A to party B is `w_A(u) = −1`,
  `w_B(u) = +1`, so `Σ_w w(u) = 0` holds by the same conservation.
- **Arithmetic**: fixed-precision decimal (not IEEE-754), bankers' rounding only at
  instruction generation. Deterministic, bit-identical outputs.

## 2. Valuation, PnL, smart contracts

- **Value**: `V_t = Σ_u w_t(u)·P_t(u)`, `P_t` an **external** price input (`P_t(USD)=1`).
- **Quantity vs value conservation**: conservation guarantees *quantity* integrity only;
  value changes from prices are captured by the valuation layer, not conservation.
- **State-sufficiency**: `V_t` depends only on current balances, current unit state, current
  prices — not on history (given all economic state changes are recorded).
- **Path-independent PnL (P10)**: `PnL = V_{t1} − V_{t0}`, independent of intermediate
  trades. Economic PnL, not accounting PnL (IFRS classification FVTPL/FVOCI/amortised-cost is
  out of ledger scope).
- **Smart contract**: deterministic `(Input, State, Conditions) → {Moves}`. Modular: one
  contract per payout/obligation type. A contract's effects ARE ledger entries.

## 3. The three-map state model (Addendum A1, the ruling)

State attaches to three distinct maps, each with its own totality/mutation discipline:

```
ProductTerms  : Map[UnitId, NonEmptyList[TermsVersion]]   # immutable, versioned append-only, registration-total
UnitStatus    : Map[UnitId, UnitStatus]                   # mutable, shared across all holders, registration-total
PositionState : Map[(WalletId, UnitId), PositionState]    # per-(holder,unit); monotone carrier; Option accessor
WalletRegistry: Map[WalletId, WalletMetadata]             # KYC/permissions/audit cursor — NOT economic state
```

**There is no `WalletState` sector.** Every economic per-wallet fact is `(w, u_mandate)`-keyed
and collapses into `PositionState[w, u_MA]`.

Two orthogonal disciplines on `PositionState` (both required — **C1**):
- **Option accessor**: `position_state(w,u) : Option[PositionState]`. `None` = "never held";
  `Some(zero)` = "held once, now flat". The distinction is load-bearing (cannot be collapsed).
- **Monotone carrier**: once created, a row is never deleted; close-out leaves a `zero` row.
  Makes replay a literal fold and conservation a single pass over a stable key set.

The twelve conditions C1–C12 (key ones):
- **C2** Handler-level conservation: every event handler emits a `StateDelta` with
  `Σ_w Δf(w,u) = 0` *structurally per event class*, with explicit vacuous (zero-holder) base
  case. Induction over the stream gives the global invariant.
- **C3** Atomic `StateDelta` across all three maps; partial application rejected.
- **C4** Capability-scoped reads; cross-`(w, u_MA)` overlay reads **forbidden**; strategy
  exports flow only through `UnitStatus`.
- **C8** Amendment two-track: a product-declared fungibility predicate decides *Preserving*
  (append `TermsVersion`) vs *Breaking* (allocate fresh `u` + `SupersededBy`).
- **C11** Each `PositionState` field is tagged with the unique handler allowed to mutate it
  (`ac`→settle/trade; `hwm`→fee_crystallise; `entry_nav`→subscribe; …).
- **C12** All per-`(w, mandate/strategy)` economic state lives at `PositionState[w, u_MA]` /
  `[w, u_QIS]` — no flat per-wallet scalars. W-sector collapse enforced by schema.

Under this model 7 of 10 core invariants (P1, P3, P5, P6, P7, P9, P10) are **structurally
unreachable** as violations.

## 4. The mandate as a unit `u_MA` (the crux for §6)

The mandate itself is a unit. Issued by manager, held by client:
```
w_manager(u_MA) = −1,   w_client(u_MA) = +1,   Σ_w w(u_MA) = 0.
```
This is NOT the rejected Dirac `u_∅` sentinel: `u_MA` has a real issuer (manager) and a real
holder (client); conservation holds by the standard issuance law.

State placement for the managed account:

| Field | Home |
|---|---|
| Mandate text, fee schedule, benchmark identity, max position limits, HWM/hurdle methodology, crystallisation frequency | `ProductTerms[u_MA]` |
| HWM **value** (client-specific), `hwm_date`, accrued mgmt/perf fee, mandate breach flags, subscription/redemption cursor, benchmark NAV at this wallet's inception, **entry NAV** | `PositionState[w_client, u_MA]` |
| Current benchmark level (shared, from index source) | `UnitStatus[u_bench]` |

Multi-mandate composition (base + overlay on one wallet) = two rows
`(w_client, u_MA,base)` and `(w_client, u_MA,overlay)`, each with its own HWM/fees/flags. A
flat per-wallet scalar would collapse them → illegal.

## 5. Section 6 mechanics (Managed Accounts, Virtual Portfolios, TRS)

- **Every wallet is a managed account** (structural identity): holds positions, generates PnL,
  PnL periodically settled in cash. Desk-vs-Treasury, PB client, QIS investor — identical
  mechanism; only the Ultimate Beneficiary, reset frequency, and valuation basis vary.
- **Managed-account smart contract** for reference wallet `w_ref`: at each reset `t_k`, three
  steps — **Observe** (compute `Perf = V^ref_{t_k} − V^ref_{t_{k-1}}`), **Crystallise**
  (one net cash move `w_ref_cash → w_UB_cash`), **Reset** (baseline → state at `t_k`).
- **Segregation as algebraic constraint**: conservation ⇒ moves within one client's wallet
  partition cannot affect another's. This is *logical* segregation (CASS 6 / MiFID II
  16(8) safeguarding) by construction. *Legal* segregation (distinct custodial accounts,
  trust/nominee) is outside scope — the ledger evidences it but cannot establish it.
- **CSA margin = wallet-level smart contract**: attached to a per-counterparty collateral
  wallet; reads aggregate MTM across all trades under the CSA; computes required collateral
  (threshold, MTA, eligible collateral); emits margin-call moves. `CollateralProvisions`
  attaches at Trade level (which CSA governs); the calculation operates at portfolio level.
- **Mandate constraints as smart-contract guards**: *quantitative* constraints (asset-class,
  concentration, leverage, currency limits) are preconditions on the move-generation
  function — reject ⇒ no moves emitted, state unchanged; deterministic and auditable. In CDM,
  validation rules before a `BusinessEvent` is admitted. *Qualitative* constraints (best
  execution, suitability, prudent person) need judgment; the ledger enforces necessary
  conditions only and supplies evidence, not the judgment.
- **Virtual ledger** `ℒ_v`: a complete second ledger instance where every wallet is virtual,
  holds no real assets, connected to no custody. Closed and self-consistent; **no move ever
  crosses between `ℒ_v` and the real ledger `ℒ_r`.**
- **TRS as synthetic managed account**: a TRS contract in `ℒ_r` *observes* `ℒ_v`'s MTM and
  emits real cash settlement. At reset `t_k`: `Payment_k = N_k·TR_k − N_k·r_k·Δt_k`, one real
  move `w_payer → w_receiver`. **Price consistency**: `ℒ_v` valuation and TRS settlement must
  use the same price vector `P_t`, else unexplained PnL. CDM `TotalReturnSwap` maps directly;
  `Transfer` events = periodic settlement moves.
- **Periodic reset & cash settlement**: positions stay in-book; only net cash crosses the
  boundary. Identical mechanism to TRS (book = virtual ledger).
- **Balance-sheet substantiation at account level (§6.9)**: each account's balance is a
  deterministic projection of the move stream filtered to its wallets. No separate
  account-level record to reconcile internally; the move stream is the evidence. External
  records (custodian, counterparty confirmations) require boundary reconciliation.

## 6. The ten core invariants (v10.3 §9)

P1 Conservation `Q(u)=0`; P2 Atomic commitment; P3 Referential integrity; P4 Log
monotonicity (append-only, hash-chained); P5 Transaction idempotency; P6 Lifecycle
idempotency; P7 Virtual/real ledger isolation; P8 Snapshot consistency; P9 Lifecycle purity;
P10 PnL path-independence. (Addendum A1 renumbers a structurally-unreachable subset as
P1,P3,P5,P6,P7,P9,P10 — read A1 §6 for that mapping; the canonical list is the v10.3 one.)

## 7. Open risks already logged in A1 (do not re-derive; build on them)

F2 ownership of the C8 fungibility predicate is ungoverned; **F5 mandate-as-unit creates an
SFTR/EMIR reporting surface for mandate issuance — may need a `reportable` flag on
`ProductTerms[u_MA]`**; F6 CDM `TradeState`-per-`Trade` vs `PositionState[w,u]` alignment is
asserted, not verified. These are candidates for escalation if a challenge deepens them.

---

## Workflow charge

You are one lens in an adversarial review converging on the exact managed-account workflow,
derived step by step from the primitives. Justify every finding from the primitives, not from
convention. Where two lenses conflict and cannot be reconciled by argument, `formalis` and
`jane-street-cto` break the tie — correctness first, then the simpler design. When a challenge
reveals a genuine flaw in the *framework* (not merely this workflow) that cannot be resolved
without changing the framework, the correct outcome is to **escalate it plainly**, never to
engineer a workaround that hides it. Do not reshape a question, narrow its scope, or assume
away its premise to make it answerable — that is forbidden.
