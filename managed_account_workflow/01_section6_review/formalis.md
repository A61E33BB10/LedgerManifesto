# formalis — §6 review (Step 2): invariants and proofs

*Lens: correctness is a mathematical property. I state each property as a predicate, then either
prove it from the primitives or exhibit a counterexample. My Step-2 charge is four obligations —
segregation as algebra, conservation `Σ_w w(u_MA)=0`, fee zero-sum per crystallisation, totality of
the mandate guards — discharged below against §6 (v10.3 ll.806–974), §4 PnL (ll.494–601), §9
invariants (ll.2038–2049), and Addendum A1 (three-map model, C1–C12, FIELD_SPEC).*

Notation: `Δf(w,u)` is the change a `StateDelta` makes to field `f` at key `(w,u)`. A field is
*conserved* iff its handler must satisfy `Σ_w Δf(w,u)=0` (C2). `supp(Δ) = {w : Δw ≠ 0}`.

---

## Obligation 1 — Conservation `Σ_w w(u_MA) = 0`

**Predicate.** `CONS(u_MA): ∀t. Σ_{w∈𝒲} w_t(u_MA) = 0`.

**Proof.** Issuance is the transaction `{m}` with `m=(w_manager, w_client, u_MA, 1)`, applying
`w_manager(u_MA) −= 1; w_client(u_MA) += 1`. P1 is the algebraic identity `Σ_w Δw(u)=0` from
`src −= q; dst += q`; induction over the stream (C2, vacuous base for the zero-holder unit, C9)
extends it to all `t`. **`CONS(u_MA)` holds by construction.** This is a real issuance, not the
rejected Dirac `u_∅` sentinel: `supp` is two *named* wallets, not a fictitious counterparty.

**But `CONS` is the weakest of the invariants the §6 workflow silently relies on. Three refinements
are required that conservation does *not* deliver, and §6/A1 do not state:**

- **F1 — Singleton/indivisibility refinement is missing · HIGH.**
  `CONS(u_MA)` constrains only the *sum*. It admits `(w_manager:−5, w_client:+5)`, a three-way split
  `(−2,+1,+1)`, and fractional balances. The managed-account semantics require exactly
  `|supp(w(u_MA))| = 2` with values `{−1,+1}` and `u_MA` *indivisible and non-fungible*: every
  per-relationship scalar lives at `PositionState[w_client, u_MA]` (A1 ll.208–209), and that key is
  well-defined only if there is exactly one holder wallet carrying exactly `+1`. If a client transfers
  half a mandate (`w_client(u_MA): +1→+0.5`, `w_other: +0.5`), `CONS` still holds, yet `hwm`,
  `entry_nav`, `accrued_fee` at `[w_client,u_MA]` are now split across two holders with no rule —
  the state is *representable but meaningless*. **Remediation:** declare a refinement
  `w(u_MA) ∈ {−1,0,+1}` with `Σ_{w}1[w(u_MA)≠0]=2`, enforced as an admission guard on any move
  touching `u_MA` (a non-fungibility predicate in `ProductTerms[u_MA]`, C8 territory). This is the
  same gap MINSKY logs as T1; I raise it from *asserted* to a stated proof obligation.

- **F2 — `u_MA` value-exclusion is unstated; `V_t` is otherwise corrupted · HIGH.**
  `V_t = Σ_u w_t(u)·P_t(u)` (l.508). If `P_t(u_MA)` is defined and nonzero, the mandate unit enters
  the client's valuation, double-counting: the client's economic exposure already lives in the
  underlying positions of `w_ref`/`ℒ_v`. Then `Perf = V_{t_k}−V_{t_{k-1}}` is contaminated by an
  arbitrary mandate "price." **Required invariant:** `P_t(u_MA) = 0 ∀t` (a typed memo unit excluded
  from valuation, RWA, and exposure). The framework gives no such carve-out; `P_t` is presented as
  total over held units, so absent the carve-out `V_t` is either wrong (nonzero price) or partial
  (`P_t(u_MA)=None`, MINSKY B2). I endorse BANKING-AUDITOR's assertion #2 and elevate it from a
  prudential note to a valuation-correctness invariant.

**Verdict on Obligation 1.** Conservation holds and is sound, but it is load-bearing for *nothing
beyond quantity sum*. The cardinality (F1) and value-exclusion (F2) invariants the workflow depends
on are independent of P1 and currently unstated.

---

## Obligation 2 — Segregation as an algebraic constraint

**The §6.3 claim (l.855) is a category error and, read as a theorem, false.** §6.3 states:
"Conservation means that logical client asset segregation is enforced by algebra … therefore moves
within one client's wallet partition cannot affect another's balances."

**F3 — Conservation neither implies nor is necessary for segregation · CRITICAL (mis-attribution).**
Two distinct properties are conflated:

- *Conservation* `CONS: Σ_w Δw(u) = 0`.
- *Locality* `LOC: supp(Δ) ⊆ {w_s, w_d}` — the move primitive mutates only its two named wallets.

These are independent. **Counterexample.** Let `A`, `B` be distinct clients. The move
`m = (w_A_cash, w_B_cash, USD, q)` satisfies `CONS` exactly — `Σ Δw(USD) = −q + q = 0` — and yet it
*moves cash out of client A's partition into client B's*: a segregation breach that is perfectly
conservative. Hence `CONS ⇏ SEG`. Conversely the segregation that *does* hold rests entirely on:

1. **`LOC`** (primitive: no side effect beyond named endpoints) — gives "no wallet outside `{w_s,w_d}`
   changes," and
2. **C4 capability scoping / `WalletRegistry` authorization** — the *guard* that forbids ever
   *constructing* a move whose endpoints straddle two client partitions.

`SEG: ∀τ confined to partition(C). ∀w∉partition(C). ∀u. w_post(u)=w_pre(u)` is a theorem of `LOC`
*alone* (trivially); the substantive client-asset-protection property — "a client's balance changes
only via moves authorized within its partition" — is a theorem of `LOC ∧ C4`, and of **neither**
conservation nor "algebra." **Remediation:** rewrite §6.3 as "logical segregation = move-locality
(primitive) + C4 authorization (guard)"; delete the attribution to conservation. The CASS-6 / MiFID
16(8) logical-safeguarding claim then stands on the correct premises.

This confirms JANE-STREET-CTO #2 and MINSKY T2 with an explicit conservative counterexample, and
corrects the BRIEFING §5 wording ("conservation ⇒ moves … cannot affect another's"). CORRECTNESS-
ARCHITECT §2 already attributes segregation to *move locality* (l.26, "Holds for quantity by move
locality"), which is the correct premise — but still omits that even locality yields nothing without
C4 enforcing which wallets a contract may name.

---

## Obligation 3 — Fee zero-sum per crystallisation

This obligation exposes the largest gap. **§6 specifies no fee mechanics at all.** §6.2's
crystallisation (l.834) pays the *gross* `Perf_ref_k` to the Ultimate Beneficiary; there is no
management-fee leg, no performance-fee leg, no HWM, no hurdle anywhere in §6. The entire
"fee accrual & crystallisation against HWM" workflow is carried by A1 state
(`accrued_{mgmt,perf}_fee`, `hwm`, `hwm_date` at `PositionState[w_client,u_MA]`; handler
`fee_crystallise`; FIELD_SPEC `hwm:{conserved:False, monotone:True}`) plus a `fee_crystallise`
handler that **is never written down**. I reconstruct it from the primitives and test zero-sum.

**Zero-sum, two readings.**

- **(a) Cross-wallet zero-sum (cash leg) — HOLDS by P1.** The only correct realisation of a fee
  crystallisation is a move `m_fee = (w_client_cash, w_manager_cash, USD, q_fee)`. By `src−=q;dst+=q`,
  `Σ_w Δw(USD) = 0`: every USD the client pays, the manager receives; no value created or destroyed
  inside the closed system. **This is the sense in which "fee zero-sum" is structural and provable.**

- **(b) Liability-vs-cash zero-sum (the coupling) — DOES NOT hold structurally · CRITICAL.**
  A crystallisation must atomically (C3) do *two* things: emit `m_fee` (cash, conserved) **and**
  reduce the stored scalar `accrued_fee` at `[w_client,u_MA]` (non-conserved: FIELD_SPEC has no
  `Σ_w Δaccrued_fee = 0` obligation — correctly, since it is a per-position scalar, not a wallet
  quantity). C2 checks *only conserved fields*. Therefore **nothing in the invariant set couples
  `q_fee` to `Δaccrued_fee`.** Counterexample: a handler that emits `q_fee = q` cash but sets
  `Δaccrued_fee = −q'` with `q' ≠ q` satisfies C2 (USD trivially conserves between the two cash
  wallets) **and** the schema (the scalar is non-conserved), yet the client has paid `q` while being
  relieved of liability `q'`. The books are wrong and no invariant fires. The required invariant
  `q_fee = −Δaccrued_fee(w_client,u_MA)` is an *additional, unstated* handler obligation.

**F4 — `accrued_fee`/`hwm` as stored non-conserved scalars defeat §6.9's "everything is a
projection" · HIGH.** §6.9 (l.962): "each account's balance is a deterministic projection of the
move stream … there is no separate account-level record to reconcile." This is **false for fee
state.** `accrued_fee` is mutable stored state, not a projection, so it *is* a second record that can
diverge from a recomputation — exactly the internal-reconciliation surface the section claims to have
eliminated. Worse, the performance fee is **not recomputable from the move stream at all**:
`perf_fee = max(0, rate·(V_t − HWM))` where `HWM` is itself path-dependent stored state
(FIELD_SPEC `hwm: monotone`, ratcheting at each crystallisation), and `V_t` over the period depends
on the *historical price path* `P_{t_{k-1}}…P_{t_k}`, which is external and not ledger state. So the
fee is a function of (stored monotone HWM) × (external price history), neither of which the move
stream alone determines. The §6.9 projection guarantee holds for *cash balances* but is overstated as
soon as fees enter.

**F5 — fee asymmetry breaks totality of the crystallise handler · HIGH.** The performance fee is
`max(0, rate·(V_t − HWM))`: on a loss (`V_t < HWM`) the perf fee is **0** (no clawback) and HWM is
unchanged, while the *management* fee still accrues. The handler must therefore be **total over
`sign(V_t − HWM)` and over `sign(net cash) ∈ {pos, zero}`** and emit *different* legs (a positive
client→manager move, or no move, never a `q≤0` move — see F9). The single fixed-direction positive-`q`
move pattern of §6 cannot represent the loss/zero-fee case. Total order (l.32) must additionally pin
the *non-commuting* sequence mgmt-fee → perf-fee → performance-settlement: the perf fee is a function
of NAV, so whether it is computed gross or net of the management fee, and before or after the
performance settlement leaves `w_ref`, changes the answer (CORRECTNESS-ARCHITECT G).

**Remediation for Obligation 3 (two admissible designs; I rank them).**
1. *Preferred (correctness + the framework's own minimalism):* model accrued fee as a **conserved
   obligation/accrual unit** `u_fee` (`w_manager(u_fee)=+a, w_client(u_fee)=−a`, `Σ_w=0`), exactly as
   `u_MA` and the CSA margin obligation (l.861) are units. Then accrual is a conserved move, the
   liability-vs-cash coupling becomes `Σ`-structural (crystallisation converts `u_fee` to USD 1:1),
   and "fee zero-sum" is a *theorem*, not a handler promise. This makes F4 disappear: the fee is a
   projection again. **It is a framework-level move (A1 chose a scalar), so per the escalation rule I
   flag it plainly rather than engineer around it.**
2. *Minimum patch:* keep the scalar but add to C2 a per-event-class coupling obligation for
   `fee_crystallise`: `q_fee_emitted = −Δaccrued_fee(w_client,u_MA)` and `Δhwm ≥ 0`, with rounding
   residue retained in `accrued_fee` (never dropped), and explicitly **carve fee/HWM state out of the
   §6.9 projection claim.** This closes F-FEE(b) and F4(coupling) but leaves fees non-replayable from
   the stream alone (the HWM + price-path dependence remains).

---

## Obligation 4 — Totality of mandate guards

§6.5 (l.865): quantitative constraints are preconditions on move generation;
"the same wallet state and proposed trade always produce the same accept/reject decision."

Model the guard as `g : State × Trade → {accept, reject}`. Two formal defects and one scope error.

**F6 — the determinism claim is false because it omits `P_t` · HIGH.** Value-based limits (leverage,
concentration-by-value, currency-exposure caps) are functions of `V_t`, hence of `P_t`. Hold `State`
and `Trade` *fixed* and double a constituent price: gross-exposure/equity rises, the leverage cap is
breached, and the *same* `(State, Trade)` flips `accept → reject`. Therefore "same state + same trade
⇒ same decision" is **false**; determinism holds only for `g : State × Trade × P_t → {…}`.
**Remediation:** add `P_t` to the guard signature and re-quantify the claim
("same state, same trade, **same price vector** ⇒ same decision"). This is the value-relativity my
independent B6 and JANE-STREET-CTO #3 raise; it directly contradicts ISDA-BOARD-ADVISOR #4's
acceptance of the guard as "deterministic and auditable" *as stated*.

**F7 — `g` is partial; presented as total · HIGH (my charge).** Totality fails on two regions of
`State × Trade × P_t`:
- *Missing price.* Leverage/concentration need `V_t = Σ w(u)·P_t(u)`. For a just-registered or
  illiquid held unit, `P_t(u) = None` (UnitStatus `last_px : Option`, A1 l.429), so `V_t` — and `g` —
  is **undefined**. The guard must have a *typed* behavior here (fail-closed reject, or a typed error
  surfacing the missing price), **never silent accept**. Unspecified.
- *Degenerate denominator.* `leverage = exposure / equity` with `equity = V_t` is undefined at
  `V_t = 0` and sign-inverts at `V_t < 0` (book wiped, or net-short). Same partiality family as
  `TR_k = ΔV/V_{t_{k-1}}` at `V_{t_{k-1}} ≤ 0` (my B7, CORRECTNESS-ARCHITECT E). `g` must define the
  decision at `V_t ≤ 0` (reject), or it is not total.

**F8 — the guard establishes a precondition, not the invariant it appears to · HIGH (scope error).**
A precondition on *move generation* fires only when a trade is proposed. A limit breached by a held
position **appreciating** (no move) is never evaluated. Formally, `g` maintains the invariant
`within_limits(State)` only over the subset of transitions *caused by admitted trades*; price-driven
transitions lie outside `dom(g)`. So the correct statable property is the *relation*
`¬worsens_breach(State, Trade)` over admitted trades — **not** the global state invariant
"portfolio always within limits," which is **false** under passive (price-driven) breach. Enforcing
the global invariant needs a periodic valuation sweep, which is a different mechanism, not a
precondition. I endorse FINOPS-ARCHITECT and BANKING-AUDITOR here and give the formal reason the two
cannot be the same object.

**Verdict on Obligation 4.** The guards are deterministic, total, and auditable *only* once `P_t`
enters their signature (F6) and the missing-price / `V_t ≤ 0` cases are given typed totalising
behavior (F7); and even then they enforce an admission-time precondition, not the portfolio invariant
(F8). As written, all three claims are overstated.

---

## Cross-cutting (root causes shared with the independent reads; not re-derived)

- **F9 — partial crystallise/settle/TRS move · CRITICAL.** `Move` requires `q>0` (l.149); `Perf_k`,
  `Payment_k`, and any fee leg are signed. The fixed-direction listings (ll.834, 911, 947) are
  *non-representable* for the loss case and illegal at `q=0`. One root cause, four sites
  (perf, TRS, periodic settle, **and the fee leg of F5**). Emit `q=|x|`, direction `= sign(x)`,
  reject `x=0`. (My independent B1; MINSKY B1; CORRECTNESS-ARCHITECT B.)
- **F10 — reset baseline has no home and no writer · HIGH.** Observe/Reset read and mutate a baseline
  `B_k` (the value `V_{t_{k-1}}` carried forward) that is absent from the A1 `PositionState[w,u_MA]`
  table and tagged by no C11 handler. The three-map model is incomplete for §6 until the baseline is
  a named field with a unique writer (the crystallise/reset handler) — and the spec must fix whether
  it is the **pre- or post-settlement** value (they differ by exactly `Perf_k`; the post-settlement
  reading `B_k = V_{t_k} − Perf_k` is the only one that does not claw performance back). (My B2/B8;
  CORRECTNESS-ARCHITECT D; JANE-STREET-CTO #1.)
- **F11 — `Perf = V_{t_k} − V_{t_{k-1}}` conflates performance with capital flows · CRITICAL for the
  managed-account case.** §4 itself decomposes `PnL = PnL_price + PnL_flow` (l.547). A
  subscription/redemption mid-period moves `V` as a *flow*; the §6 `Perf` is gross of flows and would
  crystallise the client's own subscribed capital to the UB as if it were performance. The fix-data
  (`entry_nav`, subscription/redemption cursor) exists at `[w_client,u_MA]` but the §6 formula never
  references it. Required: `Perf = (V_{t_k} − NetExternalFlows_[t_{k-1},t_k]) − V_{t_{k-1}}`. I record
  this for completeness; CORRECTNESS-ARCHITECT (A) and FINOPS own it.

---

## Tensions logged

- **vs banking-auditor** — accrued fee as stored `PositionState` scalar. Banking-auditor treats it as
  a manageable *audit surface* that "should be re-derivable and tied out to `V_t`." I hold it is a
  *correctness* defect, not merely an audit note: the performance fee is **not** re-derivable from the
  stream (path-dependent stored HWM + external price history), so the tie-out they prescribe is
  impossible by construction. My resolution (F4): either model the accrual as a conserved obligation
  unit (zero-sum becomes a theorem) or explicitly retract §6.9's projection claim for fee state.
- **vs isda-board-advisor** — guard determinism. Isda-board accepts the quantitative-constraint guards
  as "deterministic and auditable" CDM validation rules. I contest this as *stated*: F6 shows
  determinism fails without `P_t` in the signature; F7 shows the guard is partial (missing price,
  `V_t ≤ 0`); F8 shows it is an admission precondition, not the portfolio invariant. The CDM mapping is
  fine; the determinism/totality *claim* must be re-quantified before it is auditable.
- **vs minsky / correctness-architect** — multi-mandate performance attribution. MINSKY (B5) leaves
  "two rows, one wallet" vs "attribution needs disjoint sub-wallets" as an open tension; the A1 ruling
  (which correctness-architect and I co-authored, addendum l.243) keeps base+overlay as two rows on one
  wallet. As tie-breaker I resolve it: a *single* wallet value `V^ref` yields *one* scalar `Perf`, and
  splitting it into per-mandate performance for two independent HWM/fee streams is **not** a projection
  of the move stream — it needs an attribution rule the primitives do not supply. Resolution: each
  co-resident mandate must own a **disjoint reference sub-partition**, *or* `ProductTerms[u_MA]` must
  declare a total, deterministic allocation function whose output is reconstructible from the stream.
  Until one is chosen, per-mandate `Perf` is non-deterministic w.r.t. the stream — a correctness gap,
  not a style choice.

## Verdict

The construction is sound *as quantity algebra*: `CONS(u_MA)` holds by the issuance law, and the cash
leg of every crystallisation is zero-sum by P1. It is **not yet correct as a managed-account engine**,
and three of my four charge items fail as currently stated:
- **Segregation (Obl. 2)** is mis-attributed to conservation; the honest theorem is locality + C4. The
  spec's stated property is false (conservative cross-partition counterexample). **Block.**
- **Fee zero-sum (Obl. 3)** holds across wallets but the liability-vs-cash coupling is not structural,
  and §6 specifies no fee mechanics at all; the performance fee is not a projection of the stream,
  contradicting §6.9. **Block.**
- **Guard totality (Obl. 4)** fails on missing price and `V_t ≤ 0`, and the determinism claim omits
  `P_t`; the guard enforces a precondition, not the portfolio invariant. **Block.**
- **Conservation (Obl. 1)** holds but is weak: cardinality/indivisibility (F1) and value-exclusion
  (F2) of `u_MA` are independent of P1 and unstated.

None requires reversing the StatesHome ruling. F4-preferred (fee as a conserved unit) is a framework
extension I escalate rather than work around. Everything else is a §6 correction: *state the invariant
§6 currently leaves implicit, and stop attributing to conservation properties it does not entail.*
