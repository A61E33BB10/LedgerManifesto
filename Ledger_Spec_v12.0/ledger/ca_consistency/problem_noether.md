All citations verified against the v12.0 sources. Memo follows.

---

# PROBLEM MEMO — Corporate-Action Consistency of Consumed Data

**Author:** NOETHER. **Phase:** 1 (independent review, no solutions). **Basis:** `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/` at v12.0.

## 1. The defect, restated as a broken symmetry

**Definition (state basis).** For each unit $u$, let $\beta_t(u)$ denote the fold, over the immutable log, of all corporate-action events on $u$ effective at or before $t$. $\beta$ is a deterministic projection of the log — exactly as *UnitStatus* is (sec04.tex:135–143) — monotone in $t$, taking values in the monoid of adjustment operators. The ledger already computes the *position-side* image of $\beta$: a 2-for-1 split emits doubling moves (sec06.tex:99). It nowhere represents $\beta$ itself, and no consumed datum carries it.

**Definition (single-basis requirement).** A valuation of positions $\{(w,u)\}$ at price time $t_p$ is *basis-consistent* iff every datum $d$ it consumes satisfies $\mathrm{basis}(d) = \beta_{t_p}(u(d))$ — all inputs share **one** state basis with the positions valued. Compositionally: a derived datum's basis is the (joint) basis of its inputs, whatever the derivation.

**The symmetry.** A corporate action is a change of coordinates on the pairing $\langle q, p\rangle$: for a split of factor $k$, $q \mapsto kq$, $p \mapsto p/k$; for a distribution $d$, $p \mapsto p - d$ compensated by an explicit cash move. Economic value is the invariant of this transformation — this is precisely the spec's own Property 5, Lifecycle Value Invariance (sec01.tex:24). The valuation functional $V = \sum \langle q, p\rangle$ is invariant **only when both factors transform together**. The log transforms $q$; nothing transforms $p$. Mixed-basis valuation evaluates the pairing with the two factors in different frames, where it is undefined. The conservation law (value continuity across an economically neutral event) is violated exactly because its generating symmetry is applied to one factor and not the other.

**Why this breaks path-independent PnL (P10).** Theorem P10 (sec05.tex:74–89) telescopes: $V_{t_1}-V_{t_0} = \sum_i (V_{s_{i+1}}-V_{s_i})$, each interior $V_s$ cancelling. Cancellation requires $V_s$ to be a *single-valued function of state at $s$*. If a CA is effective at $s^* \in (t_{\mathrm{snap}}, t_p]$, the mixed-basis evaluation gives two candidate values $V_{s}^{(n)} \ne V_{s}^{(n-1)}$ depending on the observation time of the data used — a hidden path coordinate. Inserting a cut at $s^*$ then changes the total: PnL depends on where the checkpoint falls, contradicting P10 and the checkpoint-independence reading of P8 (sec07.tex:101) simultaneously. The type of `value` (sec05.tex:44, "the signature has no time and no history — state-sufficiency is the signature, not a claim") certifies nothing here: `PriceVec` smuggles the datum's observation time in as an untyped ambient fact.

## 2. Numerical reproduction of the failure modes (arithmetic only)

**(a) Stock split.** Snap: 1,000 sh × €100 = €100,000. Split 2:1 effective in $(t_{\mathrm{snap}}, t_p]$. Log (correctly) doubles: 2,000 sh.

| Pricing | Arithmetic | Value | PnL |
|---|---|---|---|
| Stale basis | 2,000 × €100 | €200,000 | **+€100,000 phantom** |
| Consistent | 2,000 × €50 | €100,000 | 0 (neutral event) |

Same arithmetic corrupts any split-sensitive reference: a strike reference K = €100 against a new-basis spot €50 reads deep out-of-the-money on an at-the-money position — moneyness sign flip, not just magnitude error.

**(b) Dividend.** 1,000 sh; cum spot €102 snapped; €2/sh ex-date in the window. Lifecycle correctly books +€2,000 cash.

| Pricing | Position mark | Cash | Total |
|---|---|---|---|
| Stale (cum) basis | 1,000 × 102 = 102,000 | +2,000 | **104,000** (dividend counted twice) |
| Consistent (ex) | 1,000 × 100 = 100,000 | +2,000 | 102,000 |

Double count = exactly the distribution, €2,000. Note appD.tex:53–56 already repairs *this one case* — proof the seam is real; see §3.7 on why that repair does not generalise.

**(c) Index composition.** Level $L = (\sum_i c_i p_i)/D$; constituents A ($c_A=10$, $p_A=100$), B ($c_B=5$, $p_B=40$), $D=3$: $L = (1000+200)/3 = 400$. A splits 2:1 → $p_A' = 50$, correct adjustment $c_A' = 20$ (level-preserving): $(1000+200)/3 = 400$.

| Combination | Arithmetic | Level | Error |
|---|---|---|---|
| Stale composition, new spot | $(10·50+200)/3$ | 233⅓ | −41.7% |
| New composition, stale spot | $(20·100+200)/3$ | 733⅓ | +83.3% |
| Same basis (either) | | 400 | 0 |

Both mixings are wrong, in opposite directions: the invariant is *joint* basis, not freshness of any component. A replication book tracking €1m of this index books ±€417k/€833k phantom tracking PnL.

**Composition non-commutativity (split + dividend in one window).** Operators $S: p \mapsto p/2$, $D_v: p \mapsto p-2$ on snapped spot 102: $D_v \circ S = 102/2 - 2 = 49$; $S \circ D_v = (102-2)/2 = 50$. Adjustment operators form a **non-abelian** monoid; effective-date order is load-bearing, so any basis coordinate must totally order same-window CAs. On 2,000 post-split shares the order alone is €2,000.

## 3. Audit: where the state-free-data assumption is implicit in the v12.0 text

All paths relative to `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/`.

1. **`drafts/sec05.tex:14–18`** — Definition of portfolio value: "$P_t : \mathcal{U} \to \mathbb{R}$ … an external input, not computed by the framework." $P_t$ is keyed by unit and time only; no coupling between the price function's basis and the ledger's fold at $t$. The category error is in this signature.
2. **`drafts/sec05.tex:38, 44–48`** — `PriceVec = UnitId -> Price`, "*total* function … 'a held unit with no price' is unrepresentable." Totality is here a bug amplifier: post-CA the framework *cannot express* "no valid price exists in the current basis"; the total function obligingly returns a stale-basis scalar. The failure-semantics question (block/flag/quarantine) is unposeable at this type.
3. **`drafts/sec05.tex:53–57`** — `pnl` and the claim "path-dependence cannot enter: `value` takes … no transaction history, so the type itself certifies state-sufficiency." The type quantifies over all `(PriceVec, Ledger)` pairs, including mixed-basis pairs; the certificate is issued for a hypothesis the type does not enforce.
4. **`drafts/sec04.tex:62–63` vs `drafts/sec04.tex:242–246`** — The 2×2 places "current weights, benchmark level" in *UnitStatus*, and §sec04-unitstatus (135–143) states UnitStatus is exactly a fold over logged events — yet the constructed `UnitStatus` carries only `usLifecycle/usLastSettle/usSupersededBy`. The CA fold $\beta$ is a $u$-keyed, ledger-authored, shared observable — it satisfies every criterion of that cell — and is absent. The defect is a missing projection, visible in the spec's own taxonomy.
5. **`drafts/sec04.tex:153–155`** — "Externally sourced inputs — a settlement price, the current benchmark level — enter only as a logged observation event." The observation event is timestamped but carries no basis coordinate; logging preserves *what was observed*, not *relative to which unit state it is meaningful*.
6. **`drafts/sec04.tex:169–171`, `reference/Ledger.hs:175–176`** — "A price is a number but not a quantity … a separate type with neither identity nor inverse." `Price`/`Quote` are bare `Integer` newtypes: the type forbids adding two prices but permits pairing a price with a position in a different basis — the one wrong combination this defect concerns is representable.
7. **`drafts/appD.tex:44–57, 63–78`; `reference/Ledger.hs:713–720`** — The nearest existing mechanism. `Distribution = Cum | Ex Cash` and `Market { mQuote, mQuoteEx :: Bool }`: the state basis of the *datum* is one Boolean, defined for one event class (distributions), with no split case, no succession case, no composition of multiple CAs, and no propagation to derived data. `statePrice` is a hand-built two-element basis lattice; it proves the seam exists and demonstrates the mechanism does not compose.
8. **`drafts/appD.tex:82–84`** — "The distinction between 'primary' and 'derived' market data carries no content here" and the punt of "sourcing, snapshotting, and curve construction" to the market-data satellite. Jointly with **`drafts/sec07.tex:120`** (same punt from the lifecycle side), the consistency requirement — a property of the *seam* — is owned by neither document. Ownership gap, stated in the text itself.
9. **`drafts/sec07.tex:23, 46–48`** — Lifecycle $f(\text{unit}, \text{state}_t(u), \text{market\_data})$: market data enters as an untagged third argument, "as a logged observation … so handle stays pure." Purity conserves garbage: a pure function of a wrong-basis datum is deterministically wrong (see §4, P9).
10. **`drafts/sec07.tex:120`** — Snapshot versioning is keyed by observation time and restatement version only ("a replay 'as known at $t$' uses the snapshot from $t$"). A snapshot from $t_{\mathrm{snap}}$ is in $\beta_{t_{\mathrm{snap}}}$; positions replayed to $t > t_{\mathrm{eff}}$ are in $\beta_t$. The rule as written *mandates* mixed-basis inputs whenever a CA falls in the window.
11. **`drafts/sec07.tex:129–135`** — Time-travel cases 2 and 4 correctly demand basis-aware reconstruction *of positions and unit state* ("replaying trade tickets into a current share definition mis-describes the $t_0$ position"; "a basket read from today's static file cannot distinguish the two") — and then line 135 re-prices with "the stored market data" with no requirement that the stored data be in $\beta_{t_0}$. The insight is applied to the event-sourced world and withheld from the observed world in the same paragraph.
12. **`drafts/sec06.tex:99`** — "a 2-for-1 split doubles each entitled holding *while the price reference halves*." The doubling has a mechanism (moves through `applyTx`); the halving is asserted prose with no carrier, no writer, no invariant.
13. **`drafts/sec01.tex:22, 24, 28`** — Property 4 (state-sufficiency: "current price vector"), Property 5 (value invariance), Property 6 (time travel: "market data as captured at $t$"). "Captured at $t$" conflates observation time with basis validity; Property 5's offset ("the jump in the instrument's price is exactly offset by the explicit cash move") presumes the jump is realised in the consumed datum — with a stale-basis datum there is no jump, and total value is discontinuous by exactly the phantom amount of §2.
14. **`drafts/sec01.tex:80`** — "Reference-data authority … corporate-action terms … consumed from external sources." Consumption discipline for those terms — the validity edge — is specified nowhere inside the boundary.
15. **`drafts/appB.tex:37, 54`** — The P10 oracle's precondition is "price vectors $P_{t_0}, P_{t_1}$; any transaction sequence" — the generator's input space cannot express a basis mismatch, so the oracle is vacuously immune to precisely this defect. Line 54 punts $P_t(u)$ construction to the satellite. Similarly `drafts/appB.tex:33` (P8 oracle) compares balances and unit state only; a silently re-based data store passes it.
16. **`drafts/sec14.tex:41`** — The pre-invocation data-quality gate is *staleness-threshold* (timestamp) based. A quote one second old in the wrong basis passes; a quote one hour old in the right basis may fail. The gate measures the wrong coordinate.
17. **`drafts/sec09.tex:78–83`** — Benchmark level captured as a logged observation drives HWM/fee crystallisation; a benchmark re-basing (divisor change, constituent CA) crosses bases inside the fee formula. See §5.4 for why `qmax` makes this permanent.
18. **`drafts/sec10.tex:98`** — Dual valuation's $P^{\mathrm{MtMk}}_t(u)$ "from observable market data" — same untagged consumption, now in balance-sheet substantiation.
19. **`drafts/sec19.tex:48`** — "Bitemporal semantics … market-data restatements" is the register's closest acknowledgment, framed as a two-timestamp problem. The defect is not bitemporal (when observed vs when known); it is that neither timestamp is the validity coordinate — $\beta$ is a fold of *events*, not a clock reading.
20. **`reference/Ledger.hs:683, 692–701`** — `value`/`pnl` consume `PriceVec` and `Ledger` as independent arguments; nothing relates the basis of one to the fold state of the other. Contrast the Single-Coordinate Move Principle, where exactly this kind of illegal pairing is a type error — the discipline exists in the codebase and stops at the data boundary.

## 4. Does recognising a CA state basis disturb any existing invariant? (P1–P23, C1–C12)

Audit verdict: **recognising the basis disturbs nothing that currently holds; it exposes that three invariants hold under an unstated hypothesis, and that four have no data-plane analogue.** The protected core (atomic move, conservation, log immutability) is untouched: $\beta$ is a *read projection* of events already in the log.

| Invariant | Verdict | Ground |
|---|---|---|
| **P1** conservation | Undisturbed | Quantities are event-sourced; CA moves conserve; a data basis touches no move. But note P1's dark side: conservation *faithfully preserves wrongly-sized quantities* emitted from mixed-basis inputs (§5.1) — it launders, it does not detect. |
| **P2** atomicity | Undisturbed as stated; **incomplete at the seam** | appD.tex:61 claims no configuration exists "in which the cash has appeared without the state advancing" — true across the three maps, false across (three maps × data store): the data store is outside the C3 transaction, so CA effectiveness and data re-basing are today two non-atomic steps. Recognising $\beta$ makes the hole statable; it does not create it. |
| **P3** referential integrity | Undisturbed; **the defect is its missing sibling** | P3 requires every move to reference existing wallets/units. No analogous edge datum → basis exists. The defect is a missing referential-integrity edge, not a broken one. |
| **P4** log monotonicity | Undisturbed | Adjusted data as *derivations* (per the standing directive) respect append-only. Eager in-place re-basing of a data store would be the violation — of the data plane's (nonexistent) P4-analogue, not of P4. |
| **P5** tx idempotency | Undisturbed | Keyed by tx\_id; orthogonal. |
| **P6** lifecycle idempotency | Undisturbed as stated; **no data analogue** | P6 guards moves via state. Applying an adjustment twice to a datum (€100→50→25) is the same failure class with no guarding state — the datum's basis is precisely the state P6 would need. |
| **P7** isolation | Undisturbed | Endpoint predicate on moves. |
| **P8** snapshot consistency | **Hypothesis exposed** | `clone_at(t)` rebuilds balances and unit state (appB.tex:33) but says nothing about the basis of data consumed at the reconstructed $t$. As stated, P8 is under-specified rather than false; a basis-aware restatement *strengthens* it. §5.2 gives the silent-re-basing replay. |
| **P9** purity | Undisturbed and **vacuous against the defect** | Purity quantifies over passed inputs; it cannot rule on which inputs are legal to pass. Determinism of a wrong number is not correctness. |
| **P10** path-independence | **Holds only under the unstated single-basis hypothesis** | §1. The proof at sec05.tex:83–89 is valid; the theorem's statement omits the hypothesis that every $V_s$ is basis-consistent. Recognising $\beta$ requires restating P10's hypothesis, not repairing its proof. |
| **P11–P12, P15–P20** | Undisturbed | Quantity-coordinate invariants; CA moves already handle the quantity side. |
| **P13** collateral sufficiency | **Exposed** | Sufficiency compares collateral *value* to exposure — both computed from consumed data. Mixed basis produces phantom exposure (§2a) → wrong margin call in real cash. The invariant's arithmetic is fine; its inputs are ungoverned. |
| **P14** locate | Marginally exposed | Locate is quantity-based, but lot sizes/board lots (sec06.tex:130) are CA-sensitive reference data consumed state-free. |
| **P21** obligation liveness | **Exposed** | The liveness machinery will faithfully drive a *phantom* obligation (created from mixed-basis exposure) to Discharged — real money moves on a basis error, exactly once, durably. |
| **P22–P23** | Undisturbed | Structural (conservation, idempotency of discharge). |
| **C1–C3, C9, C10** | Undisturbed | Position/transaction plane only. |
| **C5** | **Omission surfaced** | $\beta$ is $u$-keyed, ledger-authored, registration-total-able, a fold of the log — it satisfies every UnitStatus criterion (sec04.tex:91–94, 135–143) and is not there. |
| **C11** | Undisturbed; extension implied | The closed `StatusWrite`/`FieldWrite` writer sets contain no writer for any basis field — by construction nothing can corrupt a field that does not exist; equally, nothing can maintain it. |
| **C8** succession | **Exposed** | `usSupersededBy` governs unit identity succession for *terms*; no corresponding succession discipline governs data keyed by the predecessor identifier (§5.6). |

## 5. Additional failure modes (architectural, this domain)

1. **Conservation as launderer.** Any lifecycle function consuming mixed-basis data *emits moves* (margin, fees, rebalance trades, option settlement). Once committed through the single door, those moves are perfectly conserved, perfectly replayed, perfectly audited — and wrong. The framework's strongest guarantees transport the error losslessly forever. The corruption boundary is the data-consumption seam, upstream of every invariant.
2. **Replay that silently re-bases.** Replay to past $t$ against a data store that has since been adjusted (eagerly, in place, or by a vendor) reconstructs positions in $\beta_t$ and prices them with data in $\beta_{\mathrm{now}}$: historical valuations restate *with no new log event*. Determinism (sec01.tex:20) is violated in effect — same log, different numbers before/after the store adjustment — while every logged-event check passes. Dual failure: a store kept raw silently mixes bases forward (§2); a store adjusted in place silently re-bases backward. Without a basis coordinate, both policies are wrong and the choice between them is invisible.
3. **Unknown provenance / double adjustment.** A vendor feed pre-adjusted at source, ingested by a consumer that adjusts again (€100→50→25); or a late CA notification (open question 6) replayed twice. With no basis tag, under- and over-adjustment are *observationally indistinguishable from a market move*.
4. **Monotone algebras make transient errors permanent.** `psHwm` is written by `qmax` (sec04.tex:428; write-once for `psEntryNav`). One fee crystallisation against a phantom-inflated NAV ratchets the high-water mark permanently: the monotone-carrier discipline, correct for its purpose, converts a one-snap basis error into irreversible position state written through the legitimate single door.
5. **Irreversible lifecycle transitions on mixed-basis comparisons.** Barrier/knock and exercise decisions compare a reference (old basis) with a spot (new basis): a lifecycle *stage* transition fires or fails to fire; the closed lifecycle sum (sec04.tex:240) has no un-expire. Option-value extinction that Property 5's qualification (sec01.tex:26) legitimises for genuine resolution occurs here for spurious resolution.
6. **Identifier succession.** After a Breaking amendment / merger, data keyed by $u_{\mathrm{old}}$ consumed against positions in $u_{\mathrm{new}}$ (or vice versa) is the composition defect on the *key* axis; `usSupersededBy` points one way, for terms only.
7. **The Cum/Ex Bool does not scale.** appD's basis lattice is $\{ \mathrm{behind}, \mathrm{caught\ up}\}$ per single distribution. Two CAs in one window need order (§2, non-commutativity); $n$ CAs need the monoid; derived data need functorial propagation. A Boolean has none of these; generalising it *is* the architectural question, out of scope for this memo.
8. **False external breaks.** Reconciliation at the boundary (sec01.tex:47, custodian statements post-CA) compares an external record in $\beta_{\mathrm{new}}$ with an internal valuation mixing bases: false breaks arise in the one place the framework concedes breaks are possible, and the "repair" may be applied to the correct side.
9. **Test blindness is structural.** The generator universe (sec15.tex:223, appB.tex:5) draws CDM products and lifecycle events; the input space contains no basis-mismatched `(PriceVec, Ledger)` pair, so no current oracle can ever produce the counterexample. The defect is unfalsifiable by the existing suite — the strongest sign it is an architecture gap, not a bug.

## 6. Summary statement

The event-sourced world carries its state basis in the log; the observed world carries none. Every valuation is a pairing across that seam, and the spec's central theorems (P5-invariance, P8, P10) are proved under an implicit hypothesis — single-basis inputs — that no type, no condition C1–C12, no invariant P1–P23, and no test oracle states or enforces. Recognising the basis contradicts nothing proved; it names the hypothesis the proofs already require.

*— NOETHER. Find the symmetry; the missing conservation law was never about the log.*