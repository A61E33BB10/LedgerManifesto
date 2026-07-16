# Independent read — jane-street-cto

Lens: production correctness. Effects at the edges, a pure core, illegal states
unrepresentable, every dependency visible in the signature, fail loud. I derive only from
the primitives in §6 + A1; I do not appeal to practice.

## What it is

A managed account is not an object. It is the conjunction of three things the system
already has, with no bespoke record:

1. a wallet partition `w_client` — the position carrier; its balance is a *projection*
   (a fold of the move stream filtered to its wallets), never a stored scalar;
2. a mandate **unit** `u_MA`, issued manager→client, `w_manager(u_MA) = −1`,
   `w_client(u_MA) = +1`, so `Σ_w w(u_MA) = 0` by the ordinary issuance law — this is the
   contract *identity handle*;
3. a `PositionState[w_client, u_MA]` row holding every client-specific scalar (HWM value,
   `entry_nav`, accrued mgmt/perf fee, breach flags, sub/redemption cursor), with the
   immutable terms in `ProductTerms[u_MA]` and the shared benchmark level in
   `UnitStatus[u_bench]`.

The "managed-account smart contract" is a deterministic `(Input, State, Conditions) → {Moves}`.
Performance settlement is **Observe → Crystallise → Reset**: compute `Perf = V_{t_k} − V_{t_{k-1}}`,
emit *one* net cash move `w_ref_cash → w_UB_cash`, rebaseline. TRS and periodic book
settlement are the *same* function with the reference being a virtual ledger `ℒ_v` instead of
a real wallet. From my lens this is the right refactor: "managed account" goes from a noun
with hidden state to a derivation over primitives. The only side effect is the single net
move at the edge; everything upstream (Perf, guard checks) is pure.

## What must hold

- **Conservation, including `u_MA`.** Issuance law gives `Σ_w w(u_MA)=0`; the crystallise
  move is a closed `from→to` transfer, so cash nets to zero. No carve-outs.
- **One writer per field (C11).** `ac→settle/trade`, `hwm→fee_crystallise`,
  `entry_nav→subscribe`. This is what lets the 3am responder reason about a single scalar in
  isolation. Mutation by any other handler is a type error, not a convention.
- **Atomic reset (C3).** Observe/Crystallise/Reset must commit as *one* `StateDelta` across
  all three maps. If Crystallise commits and Reset does not, the next interval double-counts.
  This is the load-bearing transaction boundary.
- **Price consistency / explicit price input.** `ℒ_v` valuation and TRS settlement must use
  the same `P_t`. `V_t` depends on external prices, which are *not* ledger state. Therefore
  the contract is **not** a pure function of ledger state alone — `P_t` must be threaded
  through the signature as an explicit argument, not read from two ambient oracles.
- **Ledger isolation (P7).** No move crosses `ℒ_v ↔ ℒ_r`. TRS *observes* `ℒ_v`'s MTM and
  emits a real move; the two systems are each closed. Multi-TRS on one `ℒ_v` is safe because
  the observation is a pure read.
- **No flat per-wallet scalar.** base+overlay = two rows `(w,u_MA,base)`, `(w,u_MA,overlay)`,
  each with its own HWM. The collapsed-HWM state is made unrepresentable by the keying — good.
- **Determinism.** Fixed-precision Decimal; bankers' rounding only at instruction generation;
  replay = fold.
- **Guards are pure.** Quantitative mandate constraints are preconditions on move generation:
  reject ⇒ no moves, state unchanged. A pure `(state, proposed_trade) → accept/reject`.

## Where it can break

1. **The reset baseline is the action-at-a-distance trap.** `Perf = V_{t_k} − V_{t_{k-1}}`
   needs `V_{t_{k-1}}`, which needs the *historical* price vector `P_{t_{k-1}}` — and prices
   are external, not recorded ledger state. A1 already rules `first_touch_date` is NOT state
   (derive it). The *same* discipline must bind the baseline: it must not be a mutable cached
   scalar that a back-dated correction can desync. Either the reset event snapshots
   `P_{t_{k-1}}` (or `V_{t_{k-1}}`) into its payload so Perf stays a pure fold, or replay and
   P10 are not reproducible. This is my sharpest finding and the first thing I would nail down
   in the workflow.

2. **"Segregation by algebra" is overstated.** Conservation guarantees a move is *visible*
   and *net-zero*; it does **not** forbid a move whose source and destination lie in different
   clients' partitions — such a move is perfectly conservative. Logical segregation therefore
   rests on an *authorization guard* (capability scoping / `WalletRegistry` permissions),
   which is not one of the structural invariants. The claim "moves within one client's
   partition cannot affect another's" holds only under that guard, not from conservation
   alone. Worth stating precisely so no one trusts algebra to do a permission check's job.

3. **Impure Observe.** As above, Observe reads an external price oracle. If that dependency is
   left implicit, two desks can settle the same book against different prices and produce
   unexplained PnL with no signal in the type. Make `P_t` a named argument; fail loud if the
   `ℒ_v` price source and the TRS price source are not provably the same handle.

4. **`u_MA` issuance is a real move in a real stream (F5, already logged).** Issuing the
   mandate emits `w_manager=−1, w_client=+1`. Any downstream projection that filters "issuance
   moves" now sees mandates as issued instruments — hence the `reportable` flag on
   `ProductTerms[u_MA]`. I concur it is real; I build on F5, I do not re-derive it.

## Verdict

The collapse to wallet + unit + position-row is genuinely minimal and the one-mechanism
treatment of desk/PB/QIS/TRS is correct. The two things I would not ship without resolving:
(1) the reset baseline must be derived-or-snapshotted, never a desyncable cached scalar;
(2) the external price input must be an explicit, shared argument. Both are about making a
hidden dependency visible — exactly where production bugs live.
