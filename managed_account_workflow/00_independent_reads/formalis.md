# formalis — independent read: the managed account (§6 + A1)

*Lens: software correctness is a mathematical property. Derive from the primitives; state every
invariant; demand totality and determinism.*

## 1. What it is, from the primitives

A managed account is not a new primitive. It is the conjunction of three existing ones:

1. a **wallet** `w_ref : 𝒰 → ℝ` (the reference book), valued by the linear functional
   `V_t(w) = Σ_u w_t(u)·P_t(u)`;
2. a **mandate unit** `u_MA`, issued `w_manager(u_MA) = −1`, held `w_client(u_MA) = +1`, so
   `Σ_w w(u_MA) = 0` by the issuance law — a genuine conservation partner, not the rejected `u_∅`;
3. a **smart contract** — a deterministic map `(Input, State, Conditions) → {Moves}` — that at each
   reset `t_k` runs **Observe** (`Perf_k = V^ref_{t_k} − V^ref_{t_{k-1}}`), **Crystallise** (one net
   cash move), **Reset** (move the baseline).

Per-relationship economic state is `PositionState[w_client, u_MA]` (`hwm`, `entry_nav`, accruals,
breach flags); product terms are `ProductTerms[u_MA]`; shared observables are `UnitStatus`. The
"managed account" is therefore a *projection*, not a record: a wallet, a unit, and a reset program.

## 2. What must hold (proof obligations)

- **PO-Conservation (C2/P1).** Each reset emits a `StateDelta` with `Σ_w Δ = 0` per event class.
  Holds by `src −= q; dst += q` — *provided direction is chosen correctly* (see B1).
- **PO-Determinism.** `V_t`, `Perf_k`, and every guard decision must be **pure functions of
  (current balances, current unit state, the external price vector `P_t`, total order)**. The price
  vector is a *required argument*, not ambient.
- **PO-Totality.** The move-generation function must be total over `sign(Perf_k)`; `TR_k` is defined
  only for `V^v_{t_{k-1}} > 0`; guards total over (state × trade × prices).
- **PO-Baseline law.** The reset baseline must equal the **post-settlement** value
  `B_k := V^ref_{t_k} − Perf_k`, persisted at `PositionState[w_ref,u_MA]` under one C11 handler.
- **PO-Isolation (P7).** No move crosses `ℒ_v ↔ ℒ_r`; the price vector is the *only* shared object
  and both instances must bind the *same* external `P_t`.

## 3. Where it breaks (counterexamples, by severity)

**B1 — CRITICAL · totality/type.** `Move` requires `q > 0`; `Perf_k` (and `Payment_k`) can be
negative (a loss). The §6 listings hardcode `from: w_ref_cash, to: w_UB_cash, quantity: Perf_ref_k`.
For `Perf_k < 0` this is **not representable** — the function is partial. Remediation: emit
`Move(from,to) = sign(Perf_k)>0 ? (ref,UB) : (UB,ref)`, `q = |Perf_k|`; reject `Perf_k = 0`. Same
for the TRS move and the §6.8 periodic-settlement move.

**B2 — HIGH · semantic equivalence.** The Crystallise move drains `Perf_k` cash *from the book*, yet
"Reset: baseline → `V^ref_{t_k}`" reads the **pre-move** observed value. On the literal reading the
baseline jumps to the pre-payout high; with zero subsequent market move,
`Perf_{k+1} = V^ref_{t_{k+1}} − V^ref_{t_k} = −Perf_k` — the system **claws the performance back**.
Correct invariant: `B_k = V^ref_{t_k} − Perf_k = V^ref_{t_{k-1}}` (book returns to capital base).
The spec is ambiguous between "observed `V^ref_{t_k}`" (defines `Perf`) and "post-settlement value"
(must define the baseline); these differ by exactly `Perf_k`. The Reset step is underspecified and,
read literally, incorrect.

**B3 — HIGH · "every view is a projection" fails.** A1 places base + overlay mandates as two rows on
one wallet. The wallet yields *one* scalar `Perf_k`; splitting it into per-mandate performance for
two performance fees is **not** a projection of the move stream — it requires an attribution rule not
given by the primitives. Either each mandate needs its own reference partition, or
`ProductTerms[u_MA]` must declare a total, deterministic allocation function whose output is
reconstructible from the stream. Until then, per-mandate `Perf` is non-deterministic w.r.t. the
stream alone.

**B4 — HIGH · P10 vs periodic settlement.** P10 states `PnL = V_{t1} − V_{t0}`. Each crystallisation
is a *flow* move that removes cash, so over a multi-reset span `V_{t_n} − V_{t_0}` undercounts earned
performance by `Σ_k Perf_k`. Total economic performance `= (V_{t_n} − V_{t_0}) + Σ_k payout_k`, i.e.
the §9 `PnL_price + PnL_flow` decomposition. §6 must state *which* PnL it means; the bare
`V_{t1}−V_{t0}` is the wrong oracle for a settling account.

**B5 — HIGH · isolation vs price consistency.** P7 forbids any `ℒ_v ↔ ℒ_r` crossing, but TRS payout
is correct only if `ℒ_v` valuation and `ℒ_r` settlement use the **same** `P_t`. The price vector is
thus a mandatory shared dependency that the isolation discipline cannot carry as a move and the type
structure does not force the two instances to bind identically. Remediation: model `P_t` as a single
named external oracle referenced by both instances; consistency then holds by sharing, not by
assumption.

**B6 — MEDIUM · guard determinism is price-relative.** "Same wallet state + same trade ⇒ same
accept/reject" is **false** for value-based limits (leverage, concentration-by-value): hold
positions fixed, double a price ⇒ leverage breaches ⇒ the *same* proposed trade flips to reject.
Determinism requires `P_t ∈` the guard's inputs; the claim must be re-quantified accordingly.

**B7 — MEDIUM · partiality of `TR_k`.** `TR_k = (V^v_{t_k} − V^v_{t_{k-1}})/V^v_{t_{k-1}}` is
undefined at `V^v_{t_{k-1}} = 0` (strategy launches flat or is wiped) and changes sign meaning for
`V^v_{t_{k-1}} < 0` (net-short virtual book). Precondition `V^v_{t_{k-1}} > 0` is unstated.

**B8 — MEDIUM · missing state field.** The Reset step mutates a baseline (`last_reset_value`/`B_k`)
that A1's `PositionState[w,u_MA]` table does not name and no C11 handler tags. Add it with its unique
writer (the crystallise/reset handler), or the three-map model is incomplete for §6.

**B9 — LOW · notation.** §6's `V^v_t = w^v(USD) + Σ_{i∈𝒰} w^v(i)·P_t(i)` double-counts USD if `USD ∈ 𝒰`
and values a single wallet inside a closed instance where `Σ_w w(u)=0`. Use the §4 form
`V_t(w) = Σ_u w_t(u)·P_t(u)`, `P_t(USD)=1`, scoped to the named wallet.

## 4. One-line verdict

The construction is sound at the primitive layer (mandate-as-unit conserves; segregation is
algebraic). The defects are at the **reset program**: a partial move-generator (B1), an ambiguous
and—read literally—incorrect baseline law (B2), and three determinism/totality gaps (B3, B5, B6)
where the move stream alone does not determine the answer. None require changing the framework; all
require *stating* an invariant §6 currently leaves implicit. B2 and B3 are the two I would block on.
