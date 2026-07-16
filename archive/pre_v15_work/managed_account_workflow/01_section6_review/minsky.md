# §6 Review — MINSKY lens

**Charge:** the `u_MA` type and three-map state placement. Make three illegal states
unrepresentable: (1) cross-mandate commingling, (2) a flat per-wallet scalar for per-client
state, (3) a silent high-water-mark reset. Derived from the primitives (Wallet, Unit, Move,
Transaction, Conservation, Smart Contract, three-map StatesHome) and read against the
reference implementation in Addendum A1 (lines 425–465). I state which theorems the *types*
prove and which the *prose* merely asserts.

---

## 0. The §6 workflow as atomic moves (conservation discharged per step)

Each economic state change of the managed account is a transaction `τ` of `q>0` moves; I give
the move set and the unit-wise `Σ_w Δw(u)=0` discharge. This is the substrate the three
illegal-state targets attack.

| Step | Transaction `τ` (moves) | Conservation |
|---|---|---|
| Mandate issuance | `Move(w_mgr, w_cli, u_MA, 1)` | `w_mgr(u_MA)=−1, w_cli(u_MA)=+1`; `Σ=0` by issuance law ✓ |
| Subscription | `Move(w_cli_fund, w_cli_cash, USD, K)` + StateDelta{`entry_nav`,`hwm`} | cash `Σ=0` ✓; **field writes not moves — see §3, §4** |
| Trade (guard accept) | `Move(w_cli_cash, w_mkt, USD, p·q)`, `Move(w_mkt, w_cli, u_asset, q)` | per-unit `Σ=0` ✓ |
| Trade (guard reject) | `∅` | state unchanged ✓ (precondition pure) |
| NAV / Observe | no moves (pure read of balances × `P_t`) | n/a — **partial in `P_t`, see §5(B2)** |
| Fee accrual | StateDelta{`accrued_fee += …`} (non-conserved field) | one-sided memo; no `Σ` obligation |
| Perf-fee crystallise | `Move(w_cli_cash, w_mgr_cash, USD, fee)`, `fee = r·max(0, V−max(hwm,hurdle))` | `Σ=0` ✓; then `hwm := max(hwm, V_post)` — **Target 3** |
| Perf settlement to UB (§6.2) | `Move(w_ref_cash, w_UB_cash, USD, Perf)` | `Σ=0` ✓ for `q>0` only — **signed-move defect, see §6** |
| CSA margin | `Move(w_firm_cash, w_collat, USD, call)` | `Σ=0` ✓, bidirectional (signed) |
| TRS settlement | `Move(w_payer, w_receiver, USD, Payment_k)` in `ℒ_r` | `Σ=0` ✓ for `q>0` only (signed); no `ℒ_v↔ℒ_r` crossing |
| Redemption | `Move(w_cli_cash, w_cli_fund, USD, R)`, `Move(w_cli, w_mgr, u_MA, 1)` | `Σ=0` ✓; row retained `Some(zero)` |
| Balance-sheet | no moves (projection of stream filtered to `w_cli`) | n/a |

Conservation of *quantity* holds at every step by the `src−=q; dst+=q` pattern. The three
target illegal states all live **above** quantity conservation — in field writes, in the
NAV scalar the fee reads, and in the price input — exactly where P1 gives no protection.

---

## 1. Target 1 — cross-mandate commingling: **storage closed, input open**

**Storage commingling is unrepresentable, and correctly so.** Base + overlay are two rows
`PositionState[(w_cli, u_MA,base)]` and `[(w_cli, u_MA,overlay)]`. The key is `(WalletId,
UnitId)`; two distinct `u_MA` ids cannot collapse to one row. There is no map that would let a
single `hwm`/`accrued_fee` scalar straddle both mandates. C12's schema collapse holds: the two
HWMs are structurally separate. This is the right design and I endorse it.

**But commingling re-enters through the Observe step, which the type does not close.** The
performance that *drives* both HWMs is `Perf = V^ref_{t_k} − V^ref_{t_{k−1}}`, and `V^ref` is a
**single per-wallet scalar** `Σ_u w(u)·P_t(u)`. There is exactly one wallet value; there is no
total, deterministic rule in the primitives splitting it into a base-`Perf` and an overlay-`Perf`
that each update their own HWM. Two HWMs are representable; the two performances that must feed
them are **not separable from one wallet value**. So the two-row schema is *necessary but not
sufficient* against commingling: it forbids the collapsed-HWM state and then silently commingles
the inputs. Either (a) each mandate references a **disjoint sub-partition** of `𝒰` so `V` is
per-mandate by construction, or (b) `ProductTerms[u_MA]` must declare a total attribution
function whose codomain rows are disjoint and sum to `V^ref`, reconstructible from the stream.
Until one exists, per-mandate `Perf` is non-deterministic w.r.t. the stream.

**Read-commingling is also representable.** C4 ("cross-`(w, u_MA)` overlay reads forbidden") is
asserted, not typed. The reference accessor is `position(self, w, u) -> Optional[PositionState]`
(A1 l.448) — **no capability argument**. Any handler can read any row, so a `fee_crystallise`
firing on the overlay can read the base row. To make Target 1 unrepresentable in reads, the
accessor must take a capability that names the `(w, u_MA)` scope and return a value opaque to
other scopes; a cross-scope read must not type-check.

## 2. Target 1 corollary — `u_MA` must be structurally excluded from `V_t`

`u_MA` is a `Unit`; `V_t = Σ_u w_t(u)·P_t(u)` ranges over all held units. If `P_t(u_MA)` is a
number, `w_cli`'s NAV gains `+1·P_t(u_MA)`. In the **global** sum this cancels against the
manager's `−1` (`Σ_w w(u_MA)=0`), but the **per-wallet** valuation that drives `Perf` and the
fee base enjoys no such cancellation: a non-zero `P_t(u_MA)` inflates the client NAV and hence
the performance fee. So `u_MA` entering `V` is a fee-base corruption, not a wash. The type fix
is not "set `P_t(u_MA)=0`" (a defaulted 0 today becomes non-zero under a careless feed) but to
make `u_MA` a **contract unit that is structurally outside the domain of `V`** — `V` ranges over
valued units only; `u_MA` carries no price slot at all. Illegal state: "mandate unit with a
price." (Builds on banking-auditor's non-valued-unit point with the per-wallet mechanism; minor
tension on `0` vs domain-exclusion — see Tensions.)

---

## 3. Target 2 — flat per-wallet scalar: **mostly closed, one leak (field creep)**

The economic-state sector is keyed only by `UnitId` (`ProductTerms`, `UnitStatus`) or
`(WalletId, UnitId)` (`PositionState`). There is **no `Map[WalletId, EconomicScalar]`** — the
reference `Ledger` has `PT`, `US`, `PS` and no WalletId-only economic map (A1 l.443–445). A flat
per-wallet economic scalar has nowhere to live. C12 holds *by schema*, as claimed.

**The one leak is `WalletRegistry`/`WalletMetadata`.** The briefing tags it "KYC / permissions /
audit cursor — NOT economic state," but "NOT economic state" is a comment, not a type
constraint. If `WalletMetadata` is an open record, an implementer can add `hwm: Decimal` and the
schema accepts it — reintroducing exactly the flat per-wallet scalar C12 forbids. To make Target
2 unrepresentable, `WalletMetadata` must be a **sealed type admitting no economic-typed field**.
This is the dual of A1's own "Minsky denormalisation trap" rejection of option F (l.290): there
the per-`(w,u)` split was smuggled in as a wallet-id convention; here an economic scalar can be
smuggled into wallet metadata. Same trap, opposite map. Seal the record.

**Secondary leak — `PositionState.balance`.** The reference `PositionState` carries `balance`
(A1 l.433) alongside the wallet balance `w_t(u)`, which §6.9 says is a *projection* of the
filtered move stream. A stored `balance` is a per-`(w,u)` scalar that can **desync from the
fold**. Either it is a memoized projection (then it must be derivable and reconciled, not
authoritative) or it is authoritative (then the move stream is not the single source of truth,
contradicting §6.9). I read it as denormalisation that should not be a free-standing field.

---

## 4. Target 3 — silent HWM reset: **representable today; the monotone tag is unread**

This is the worst of the three. `FIELD_SPEC["hwm"] = {"conserved": False, "monotone": True,
"handler": "fee_crystallise"}` (A1 l.438). But `apply` (A1 l.454–460) enforces **only**
conservation (`Σ=0` for conserved fields). Nothing reads `monotone: True`. The write is a blind
overwrite: `PositionState(**{**old.__dict__, **diff})`. A handler that writes `hwm_new < hwm_old`
is accepted. **A silent HWM reset is therefore representable in the model as written.** The §6.2
"Reset: baseline → state at `t_k`" step, taken literally, overwrites the baseline to `V_{t_k}`
unconditionally; if a handler conflates that performance baseline with the HWM (both are
"baselines"), it lowers the HWM after a loss and lets the manager re-charge a performance fee on
the same recovered gains. Economic harm: double-charged performance fee.

Three distinct silent-reset channels, each needing a type-level closure:

- **(a) Downward overwrite at Reset.** Fix: `hwm` is write-only through a `max` combinator —
  the handler proposes a candidate; the carrier stores `max(old, candidate)`. A downward write
  is then not rejected at runtime but **unrepresentable by construction**. `apply` must honour
  the `monotone` tag, not ignore it.
- **(b) Re-subscription into a `Some(zero)` row.** After full redemption the row is retained
  `Some(zero)` with the final HWM (A1 l.247). A re-subscription must establish a *new* relationship
  (new `entry_nav`); it must not silently inherit a stale HWM nor silently zero it. The `None` vs
  `Some(zero)` distinction (load-bearing, C1) makes re-subscription distinguishable from first
  subscription — good — but the subscribe handler must make the HWM decision **explicit and
  audited**, not defaulted.
- **(c) C8 Breaking amendment.** A fungibility-breaking amendment (benchmark swap, restructuring)
  allocates a **fresh `u_MA,new`** with a default `PositionState` (`hwm=0.0`). Monotonicity is
  per-`(w,u)`; it does not bind across a `u`-transition. So a Breaking amendment is a silent-HWM-
  reset channel that **bypasses the monotone tag entirely** — the HWM "resets" to the default of
  a new key, disguised as an amendment. Fix: the C8 Breaking re-subscription `StateDelta` must
  **explicitly transport `hwm`/`hwm_date`** from `u_old` to `u_new` as a typed, audited write;
  absent that, the fresh row's default-zero HWM silently resets it.

**Initial-HWM defect (same class).** `PositionState` defaults `hwm=0.0` (A1 l.433). A HWM of 0
means every positive NAV is above the mark, so the *first* crystallisation charges a performance
fee on the entire subscribed capital. The illegal initial state ("HWM below entry capital") is
not merely representable — it is the **default**. `hwm` before subscription must be `None`
(unrepresentable-as-fee-eligible), set to `entry_nav` (or the hurdle) at subscription. Which
raises:

**C11 single-writer gap.** C11 tags `hwm → fee_crystallise` and `entry_nav → subscribe`. But the
*initial* `hwm` is established at **subscription**, not at a crystallisation. Either `subscribe`
is permitted to initialise `hwm` (violating the single-writer rule) or the initial-HWM transition
has **no canonical writer**. C11 must grant `subscribe` the initialisation right explicitly, or
the field has an unowned transition.

---

## 5. The framework-level escalation: HWM (and entry_nav, accrued_fee) are cached projections

This is the finding I will not engineer around. A1 rules (l.189): *"`first_touch_date` is NOT
state — it is derived from the event log on demand. Caching it in `PositionState` would create a
fold-inconsistency under back-dated corrections."* Apply that ruling honestly to the §6 fee state:

- `entry_nav` = `V` at the subscription move's timestamp — a fold of the stream.
- `hwm` = `max` over post-crystallisation NAVs per methodology — a fold of the stream.
- `accrued_fee` = a fold over the accrual schedule and `V_t` — a fold of the stream.

All three are **fold-derivable** (given recorded prices), and all three **desync under a
back-dated price correction** exactly as cached `first_touch_date` does: a corrected historical
price changes a historical NAV, changes the HWM path, changes every subsequent fee. By A1's own
criterion these are **NOT state** — yet A1 homes them as mutable `PositionState[w_cli, u_MA]`
fields with single writers. The boundary between "state" and "projection" is drawn
**inconsistently**: the same back-dated-correction argument that demoted `first_touch_date`
demotes `hwm`/`entry_nav`/`accrued_fee`. This is a *framework* inconsistency, not a §6 wrinkle,
so I escalate it rather than patch §6.

Note the dependency: if prices are **not** recorded in the stream, `hwm` is not derivable at all
and replay/P10 fail (nazarov's point) — so determinism *already requires* recorded price
snapshots; and once prices are recorded, the first_touch_date ruling forbids caching `hwm`.

**Constructive resolution (closes Target 3 for free).** Make `hwm` a **monotone max-projection**
— a memoized fold whose only legal value is `max` over recorded crystallisation NAVs, with the
derivation function attached and back-dated corrections invalidating the memo. Then: a silent
reset is unrepresentable because there is no authoritative writable field to reset (the cache can
only equal the fold); and the cached value reconciles to the stream by construction, removing the
internal-reconciliation surface banking-auditor flags on stored fees. Genuinely state (not a
fold): the **subscription/redemption cursor** (an idempotency dedup key) and possibly the
**breach-flag latch** — these encode decisions, not valuations, and may stay as fields.

---

## 6. Confirmed §6 defects (convergent across lenses; restated in my idiom, not re-derived)

- **Signed crystallisation move.** `Move` requires `q>0`; `Perf_k`, `Payment_k`, the §6.8
  settlement, and a CSA call are all signed. The §6 listings hardcode one direction with
  `quantity: Perf_ref_k` — partial, non-representable for `Perf<0`, and illegal for `Perf=0`.
  Emit `q=|x|`; direction from `sign(x)`; reject `0`. One root cause, four sites. (My B1;
  formalis B1; correctness-architect B; finops, banking-auditor concur.)
- **`V_t` partial in `P_t`.** `last_px : Optional[float]` (A1 l.429); the `None` case must be a
  typed reset failure, not a silent zero. (My B2.)
- **Baseline ambiguity.** §6.2 "Reset → `V_{t_k}`" reads the **pre-payout** value; the baseline
  must be the **post-settlement** value `V_{t_k} − Perf_k`, else the next interval claws the
  performance back. (formalis B2; I rank this with Target 3.)
- **Perf-settlement vs performance-fee conflation.** §6.2's single move crystallises the whole
  signed `Perf` to the UB; the **performance fee** is a different, `≥0`, client→manager move with
  HWM/hurdle/no-clawback. One move cannot carry both sign disciplines. (finops concurs.)
- **Segregation rests on a guard, not algebra.** Conservation does **not** forbid a move whose
  src and dst lie in different clients' partitions — such a move is perfectly conservative.
  `Move : Wallet × Wallet × Unit × q` is total over all wallet pairs. Segregation needs the
  move-generation capability scoped to one partition (phantom-tag wallets by owning partition so
  a cross-partition move does not type-check). (jane-street-cto break-2; my T2.)
- **Real/virtual isolation and price consistency are namespace/prose conventions.** Phantom-tag
  the ledger (`Wallet[L]`) so a cross-ledger move does not compile (B6); thread **one** immutable
  `P_t` into both `ℒ_v` valuation and TRS settlement rather than fetching twice and checking (B7).
- **`TR_k` partial at `V^v_{t_{k−1}} ≤ 0`.** Precondition `V^v_{t_{k−1}} > 0` is unstated.

---

## 7. Verdict

The `u_MA`-as-unit move is sound (it conserves by the issuance law) and the three-map keying
makes the **collapsed-HWM** and **flat-per-wallet-scalar** states unrepresentable in *storage* —
the right structural wins. The residual illegal states are all places where the *type stops short
of the discipline it claims*:

1. **Cross-mandate commingling** is closed in storage but open in the **Observe input** (one
   `V^ref` feeding two HWMs) and in **reads** (capability-free accessor). Needs disjoint
   sub-partitions or a declared attribution function, and a capability-scoped accessor.
2. **Flat per-wallet scalar** is closed except for **`WalletMetadata` field creep** (seal the
   record) and the stored **`PositionState.balance`** denormalisation.
3. **Silent HWM reset** is **representable today** — the `monotone` tag is unread by `apply`, the
   default `hwm=0.0` is itself the illegal initial state, and the C8 Breaking track resets the
   HWM across a `u`-transition that monotonicity does not span. Make `hwm` a monotone
   max-projection; that closes the reset channel and resolves the framework-level inconsistency
   that A1's own `first_touch_date` ruling exposes (§5 — escalate).

None require reversing the StatesHome ruling on the *model*; the load-bearing change is to honour
the state/projection boundary A1 itself drew, and to make C4/monotonicity/`V`-domain facts hold
in the types rather than in prose.
