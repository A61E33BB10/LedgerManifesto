# Managed Account — Independent Read (MINSKY lens)

Lens discipline: a design is correct when illegal states are unrepresentable, every case is
handled exhaustively, every claimed function is total, and failure is explicit in the type.
I derive only from the primitives (Wallet, Unit, Move, Transaction, Conservation, Smart
Contract, the three-map state model). I do not assert; I state which theorems the types
prove and which they only assert.

## What it is (composition, not a new primitive)

A managed account is the composition of four existing primitives, no fifth:

1. a **wallet** `w_client` — a partition `w : 𝒰 → ℝ`;
2. a **mandate unit** `u_MA`, issued by the manager: `w_manager(u_MA)=−1`, `w_client(u_MA)=+1`;
3. a **reset smart contract** `(Input,State,Conditions)→{Moves}`, deterministic, that at each
   `t_k` does Observe (`Perf = V^ref_{t_k} − V^ref_{t_{k−1}}`), Crystallise (one cash move),
   Reset (baseline ← `V^ref_{t_k}`);
4. **state** homed by the three-map ruling: terms in `ProductTerms[u_MA]`, the client-specific
   relationship state (HWM value, accrued fees, breach flags, sub/redemption cursor, entry NAV)
   in `PositionState[w_client,u_MA]`, shared benchmark in `UnitStatus[u_bench]`.

The "account" carries no economic state of its own: it is the move stream filtered to
`w_client`'s wallets, with `u_MA` as the carrier of the bilateral relationship state.

## What must hold (theorems; mark proved-by-type vs asserted)

- **T1 — u_MA is a singleton bilateral contract.** Support `{w : w(u_MA)≠0}` has exactly two
  members with values `{+1,−1}`. *Asserted, not proved.* Conservation (P1) gives only
  `Σ_w w(u_MA)=0`; it equally admits `(+5,−5)` or a three-way split. The cardinality/unit-value
  invariant is not encoded by P1 and needs its own refinement.
- **T2 — segregation.** A move touches only its two named wallets, so one client's partition
  cannot perturb another's. *Proved by the move primitive — but conditionally.* The primitive
  guarantees no side effect beyond named wallets; it does **not** guarantee the contract names
  the right wallets. Segregation is a theorem only once C4 capability scoping restricts the
  wallet set a contract may name. Absent C4 enforcement it is "no unnamed side effects," weaker.
- **T3 — telescoping of resets.** `Σ_k Perf_{[t_{k−1},t_k]} = V_{t_n} − V_{t_0}` (P10).
  *Holds at the value level, breaks at the settled-cash level under rounding* — see B4.
- **T4 — idempotent crystallisation (P6).** Re-firing reset `t_k` must not double-pay.
  *Proved only if* the crystallise handler is keyed `(w_client,u_MA,t_k)` and dedups via the
  sub/redemption cursor. The key must be explicit; it is the cursor's job.

## Where it can break (cracks the types do not close)

- **B1 — Crystallisation is a partial function presented as total.** `Move` requires `q>0`;
  direction encodes sign. `Perf` is signed. The spec's single fixed-direction move
  (`w_ref_cash → w_UB_cash`, `quantity: Perf`) is correct only for `Perf>0`. The
  `Perf<0` (UB pays the book) and `Perf=0` (no move; a `q=0` move is illegal) cases are
  unhandled. Exhaustive `sign(Perf) ∈ {neg,zero,pos}` is mandatory. Same defect in TRS
  `Payment_k` and in §6.9 periodic settlement — one root cause, three sites.
- **B2 — V_t is partial in the price map.** `V_t = Σ w_t(u)·P_t(u)` assumes `P_t` total on the
  held set. A just-registered or illiquid unit has `last_settlement_price = None` (UnitStatus),
  so `V_t`, hence `Perf`, is undefined. The `Option[Price]` `None` case must be an explicit,
  typed failure of the reset, not a silent zero.
- **B3 — Cash-wallet sign is unconstrained.** Crystallising a gain pays UB by driving
  `w_ref_cash(USD)` negative — representable (negative = obligation), possibly intended for a
  desk, but a **segregated client cash** wallet going negative may be illegal (CASS). The type
  draws no line between "may be negative" (short/derivative) and "must be ≥0" (client cash).
  No non-negativity refinement exists where one is required.
- **B4 — Rounding residue defeats telescoping.** Cash moves are bankers-rounded at instruction
  generation; the baseline resets to **unrounded** `V_{t_k}`. Then `Σ(rounded Perf_k)` differs
  from `V_{t_n}−V_{t_0}` by accumulated dust. Either residue is retained in the book (then "PnL
  reset to zero" is false — a dust position survives, and that must be a typed, conserved value)
  or it is dropped (then P10 telescoping fails at the settled level). The residue must be made
  explicit in the type, not discarded.
- **B5 — Multi-mandate performance attribution is underdetermined.** Base+overlay are two rows
  on one wallet (correct: a flat scalar would collapse the two HWMs — illegal). But `V^ref` is a
  single per-wallet number; the spec gives no rule to split it into a base `Perf` and an overlay
  `Perf` that each update their own HWM. Two HWMs are representable; the performance that drives
  them is not separable from one wallet value unless each mandate owns a disjoint sub-partition.
  Genuine tension: "two rows, one wallet" vs "attribution needs disjoint sub-wallets."
- **B6 — Real/virtual isolation (P7) rests on namespace convention.** "No move crosses ℒ_v↔ℒ_r"
  is asserted as a property to maintain. With a flat wallet-id namespace nothing makes a
  boundary-spanning move ill-typed. Remedy in-lens: phantom-tag the ledger,
  `Move : Wallet[L] × Wallet[L] → …`, so a cross-ledger move does not compile.
- **B7 — TRS price consistency is reconciled, not constructed.** "ℒ_v valuation and TRS
  settlement must use the same `P_t`" is enforceable by threading **one** immutable `P_t` value
  into both computations, rather than two independent fetches checked after the fact. Parse the
  snapshot once; do not validate two snapshots for equality.

## Net

The mandate-as-unit move is sound and makes the right collapse (single-HWM) unrepresentable.
The open work is at the function boundaries, not the data model: the reset/crystallise/settle
functions are written as if total and as if prices are total, and the real/virtual and price-
consistency guarantees live in prose rather than in types. The load-bearing fixes are B1
(exhaustive signed crystallisation), B2 (`Option[Price]`), B4 (typed rounding residue), and B5
(attribution under co-resident mandates). B6/B7 are cheap to encode and should be. B3 is a
missing refinement that regulation, not the ledger, makes mandatory.
