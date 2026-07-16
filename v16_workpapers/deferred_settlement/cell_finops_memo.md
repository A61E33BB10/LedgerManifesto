# Settlement-Domain Requirements Memo — finops-architect (Round 1)

**Cell:** deferred-settlement design (v16-native) · **Feeds:** TuringAward candidate, Round-2 integration
**Sources read in full:** `Ledger_Spec_v11.0/deferredSettlement.tex` (problem authority; DS1–DS19; worked example); `Ledger_Spec_v16.0/ledger/ledger_v16_0.tex` §9 Timing (2900–2924), §11 Settlement (full), §12 Reporting, §14 (RoU gate, one-writer, coverage), §16 (B/M/V + TA-KIND/TERMS/EXDATE/ARRIVAL); `next_step_v16.tex` NS-01, NS-04.

**Alignment note (governs every "satisfied" below).** v11 realised the design with two phantom wallet classes (`cpty_virtual`, `csd_virtual` mirrors) plus an `L_15` obligation-FSM. v16 supersedes that mechanism with **one primitive**: the **settlement-obligation unit** whose `instructed | settled | failed` node lives in UnitStatus, one product graph carrying settlement + fails-cascade + market-claim (§11). I do **not** re-import mirror wallets or a fourth state home — that would add a phantom class the constitution's minimalism (§7) and StatesHome (§6/§14) forbid. Each DS **property** is mapped onto the unit model; the v11 **mechanism** is retired, not the guarantee.

## 1. DS1–DS19 acceptance checklist (verbatim title · disposition)

| DS | Verbatim invariant | Disposition | Where in v16 |
|----|--------------------|-------------|--------------|
| **DS1** | Economic-Exposure-at-T | **satisfied** — `owned` re-books at instruction and is never moved by settlement; the open-window gap is carried in the unit, not `owned`. | §9 Timing; §11 "owned re-books at instruction" |
| **DS2** | Conservation Σ_w w_t(u)=0 | **satisfied** — conservation by construction, per (unit, coordinate) at the one door. | §4/§14 |
| **DS3** | Reconciliation Identity | **needs-the-new-design (CORE)** — v16 states no computable custody identity; this is NS-01, the reason the cell exists. | absent (see §2 below) |
| **DS4** | No Discharge Without Witness | **satisfied** — a node walk fires only on a recorded trigger (external confirmation/fail notice, or the due-date watch reading confirmed quantity); no discharge by clock or silence. | §11 "one of two recorded triggers"; §16 M2/M8 |
| **DS5** | Replay determinism | **satisfied** — deterministic replayable orchestration; late firing reproduces the identical transaction. | §16 M5 |
| **DS6** | Idempotency of finality messages | **satisfied** — cause-derived idempotence at the door; duplicate emission harmless. | §16 M2/M8 |
| **DS7** | Failure Non-Reversal | **satisfied** — "settlement failure is a recorded event, never a reversal"; the instructed re-booking is not undone; unwind only by compensating transaction. | §11 (explicit) |
| **DS8** | Status monotonicity | **satisfied** — property of the settlement-obligation unit's product graph (graph-consistency invariant). | §11; §14 |
| **DS9** | Buy-In Compensation Closure | **satisfied (structural)** — obligation liveness forces every fail to discharge / compensate / declare-defaulted by deadline; buy-in and cash-in-lieu are the compensation paths of the fails cascade + close-out. CSDR *window/penalty* mechanics are declared terms (Exclusions/downstream). | §16 M7; §9.3 fails cascade; §9 close-out |
| **DS10** | Cross-Currency Herstatt Visibility | **needs-the-new-design** — v16 assumes one implicit currency; no FX leg, no Herstatt projection. This is NS-02; **belongs to the currency workstream**, flagged here, not silently absorbed into settlement. | absent |
| **DS11a** | Partial-Settlement Per-Step Conservation | **satisfied** — the partial edge splits the unit into a settled leg q_s and a failed-residual leg q_r, q_s+q_r=Q, parent retires from the zero vector. | §11 partial edge |
| **DS11b** | Partial-Settlement Monotonicity | **needs-the-new-design** — monotonic advance and position-unchanged (i,ii) hold; the **D_max=2 fragmentation/termination bound (iii)** is diminished (NS-04): v16 re-splits recursively with no depth bound (up to Q live units). | §11 (bound missing) |
| **DS12** | Variant Degeneration (T+0…T+5+) | **satisfied** — the booking moment and settle cycle are declared terms; T+0 collapses the gap to ε; only timer durations change. | §9 Timing (declared term); §11 |
| **DS14** | CSDR penalty schema determinism | **satisfied** — any declared penalty schedule is a deterministic projection over declared terms; the field inventory is an Exclusions-Register matter. | §12; §16 B7 |
| **DS15** | Counterparty default close-out | **satisfied** — close-out + netting algebra mints one CLM-CO per master, recovery decoupled, supervised write-off as fallback. | §9 close-out (worked episode) |
| **DS16** | Bitemporal restatement | **satisfied** — time travel is a theorem of the fold; restatement is a longer log, never an edit. | §2/§12/§14 |
| **DS17** | Capability Scoping on Settlement Status Writes | **satisfied** — the node walk has exactly one legal writer, the unit's own smart contract (one-writer invariant). | §11; §14 one-writer |
| **DS18** | DvP Ledger-Level Atomicity | **satisfied (ledger-level only — see §3)** — delivery and payment are one paired-leg transaction; both apply or neither. External-CSD atomicity is *not* guaranteed. | §4 door; §11 |
| **DS19** | Witness-Identity Determinism | **satisfied** — cause-derived identifier makes intake idempotent and witness identity deterministic; a duplicate finds the node already walked. | §16 M2/M8; §4 |

**Counts: satisfied = 16 · needs-the-new-design = 3 (DS3, DS10, DS11b) · candidate-reject = 0.** No DS *property* is rejected; the v11 *mechanism* (mirror wallets + L_15 FSM) is superseded by the settlement-obligation unit.

## 2. The reconciliation identity in v16 vocabulary (DS3 / NS-01 — the deliverable)

**Internal side (a projection, no new primitive).** For each real wallet `w`, custody account, and unit, read `owned` (and, for securities, `borrowed`) and net it against the **in-flight quantities of `w`'s open settlement-obligation units** (node ∈ {instructed, failed} — i.e. unsettled):

- Cash / nostro: `nostro_ext(w, ccy) = owned(w, ccy) + inflight_out(w, ccy) − inflight_in(w, ccy)`, where `inflight_out` sums the paymentLeg of open units on which `w` is payer, `inflight_in` those on which `w` is payee.
- Securities / depot: `depot_ext(w, sec) = owned(w, sec) + borrowed(w, sec) − inflight_in(w, sec) + inflight_out(w, sec)` — the v11 SBL form `own + borr + inflight = depot` folded in.

Both are folds over `owned` and the open units → **time bounded by wallet count, not transaction count**.

**External side.** The custodian/CSD nostro/depot statement (`camt.053`, depot statement) is admitted as a **recorded witness observation through the one door — a registered event kind** (§16 B1 provenance, B2 kind-registered-before-crossing, M8 no-captured-event-lost). It is *never* stored as a mirror balance; it is an observation the projection is compared against.

**A mismatch = a perimeter reconciliation break: detection, not prevention.** Classify three-way per (w, unit): **CLEAN** (identity holds in tolerance); **EXPECTED LEAD-LAG** (violation exactly explained by open unit in-flight — the ordinary open-window state); **BREAK** (unexplained → a deadline-bearing open item). The trust-assumption pattern is the **sibling of TA-KIND/TA-TERMS/TA-ARRIVAL**: name **TA-CUSTODY** — the recorded statement faithfully renders the custodian's book — owned by data governance, its *arrival* being TA-ARRIVAL's matter (§16). The ledger *detects* drift; it cannot *prevent* the custodian's book from being wrong, because the custodian is an external authority reconciled at the boundary, never a function the ledger performs.

## 3. DvP atomicity, stated honestly (DS18)

**What the ledger guarantees:** *its own* transaction atomicity. Delivery and payment are one admitted paired-leg transaction — at instruction both `owned` legs re-book atomically (both apply or neither), and any settlement/fail node-walk is one transaction, conserving per (unit, coordinate) at the single door.

**What it cannot guarantee:** the *external CSD's* own DvP atomicity — that the real depot and real nostro actually move together at settlement. That is a trust assumption, **reconciled, not enforced**. If the CSD delivers stock but not cash (a real DvP break), it surfaces as a leg-inconsistent unsettled state: the depot side of §2's identity reconciles while the nostro side breaks, and the fails cascade carries the open leg. Ledger-level atomicity ≠ settlement-level atomicity at the CSD; the door secures the first, the identity of §2 detects violations of the second.

## 4. Worked example in v16 terms — 100 XYZ @ $50.00, T+2 (exact numbers)

Buyer wallet `w_us`; pre-trade `owned(USD)=1,000,000`, `owned(XYZ)=0`. Trade-date booking (§9 default).

**Clean settlement.**
- **T (Mon) — instruction.** One paired DvP transaction: `owned(XYZ) 100`, seller→`w_us`; `owned(USD) 5,000`, `w_us`→seller. Σ per unit = 0 (**conservation**). Settlement-obligation unit born at **instructed**: deliveryLeg 100 XYZ (in-flight_in), paymentLeg 5,000 USD (in-flight_out). Now `owned(XYZ)=100`, `owned(USD)=995,000`. External depot 0, nostro 1,000,000 (unchanged). Identity: depot 0 = 100 − 100 ✓; nostro 1,000,000 = 995,000 + 5,000 ✓.
- **T+1 (Tue) close $52.00.** No moves. `V = 995,000 + 100·52.00 = 1,000,200` → **unrealised +$200.00** on the buyer's owned position (mark-to-mid = mark-to-market over one composition, §16 V5), zero cash and zero custody movement. Custody unchanged; identity still balances via in-flight (0 = 100−100; 1,000,000 = 995,000+5,000).
- **T+2 (Wed) — confirmation.** Custodian `sese.025`/`camt.054` recorded as a witness observation through the door (moveless). Unit walks **instructed→settled**; in-flight → 0. External register now depot 100, nostro 995,000. `owned` **untouched** (DS1/DS7). Identity: depot 100 = 100 − 0 ✓; nostro 995,000 = 995,000 + 0 ✓. **Conservation holds at every step.**

**Fail-and-recover variant.** T and T+1 identical (+$200 unrealised stands).
- **T+2 due date, no confirmation.** Due-date watch fires; cumulative confirmed 0 < instructed 100 → unit walks **instructed→failed** on the full 100. Owned re-booking **not undone** (DS7): `owned` still XYZ 100 / USD 995,000. Fails cascade carries the 100 as a recorded, deadline-bearing obligation (§16 M7). Identity **still balances** — external depot still 0, nostro 1,000,000; the 100/5,000 stay in-flight under the now-`failed` (still unsettled) unit, so EXPECTED LEAD-LAG, not a false BREAK.
- **Recovery (§11 / §9).** By the fails-cascade deadline the obligation is (a) **discharged** — late confirmation walks it to settled, in-flight→0; or (b) **compensated** — buy-in delivers replacement 100 XYZ (recorded confirmation→settled), or cash-in-lieu at fair value (e.g. 100·51.50 = $5,150), the 5,000 payment leg netting, recovery claim decoupling on default; or (c) **declared defaulted** — supervised write-off, loss = the fall in the recovery claim's mark, no second copy (§9 close-out, CLM-CO). Never a silent reversal.

**Partial variant.** Confirmation of 60 of 100 → split: settled leg 60 (settled) + failed-residual leg 40 (instructed→failed); 60+40=100, parent retires from the zero vector (DS11a ✓); cascade fires on the 40 only (DS11b). **NS-04 flag:** v16 lets the residual re-split recursively with no depth bound — reinstate D_max=2.

## 5. Interfaces (cite, don't redesign)

**Partial settlement.** Use the certified **partial edge** of §11 verbatim — mint a settled leg (q_s, settled) and a failed-residual leg (q_r=Q−q_s, instructed), one paired-leg split transaction moving the parent's delivery/payment mass into the legs, parent from the zero vector, four-quadrant routing applying leg-wise. My only addition is NS-04's fragment bound + variant (residual strictly decreases; beyond declared depth → Failed→Compensated), not a redesign of the edge.

**RoU (right-of-use) gate.** Closed in v16.0: collateral received without right of use (Constitution C-8.8, segregated included) contributes zero to the coverage net and a re-post of segregated mass is refused **at the door** — an admission bound, not a report convention (§14 right-of-use gate; §9 case 3; §12 re-use projection reports only what the gate admitted). Settlement delivery of a bought-not-yet-settled position composes with this gate unchanged: order-forced at the door, an owned reduction below posted mass is refused (§9).

**Close-out.** Closed in v16.0: counterparty default nets each master's set to one CLM-CO, collateral marker cleared first (coverage-ordered), recovery decoupled to `defaulted`, supervised write-off as the §14.1 fallback; close-out is itself a deadline-bearing obligation, a stalled one visible and overdue (§9 close-out and netting algebra, worked seven-transaction episode). The settlement fails cascade routes into exactly this machinery on counterparty default (DS15).

---

### Return to Round-2 integration

- **DS counts:** **16 satisfied / 3 needs-the-new-design (DS3, DS10, DS11b) / 0 candidate-reject.**
- **Reconciliation identity, one sentence:** *For every (real wallet, custody account, unit), the custodian's recorded nostro/depot statement — admitted as a registered witness observation through the one door — must equal that wallet's `owned` (plus `borrowed`, for securities) netted against the in-flight delivery/payment quantities of its open settlement-obligation units, computed as a projection in time bounded by wallet count and classified clean / expected lead-lag / break.*
- **Conflict I refuse to absorb (parked, not fudged):** DS3 must be **computable** — a projection + the custodian statement registered as a witness event kind (TA-CUSTODY, sibling of TA-KIND/TA-TERMS) + the three-way classify. If the owner rules the custodian statement stays purely *at* the perimeter and never crosses the door as a recorded witness, then the identity cannot be made computable inside the ledger and DS3 stays prose-only — which re-admits the exact reconciliation drift the framework exists to abolish (TuringAward NS-01's "one call an owner could decide the other way"). I will not sign a narrative-only DS3; if the owner so rules, DS3 is parked with exact proposed text rather than relabelled satisfied. I also refuse to absorb DS11b's unbounded recursive split (NS-04) or to fold DS10's FX/Herstatt leg into settlement silently — DS10 is the currency workstream's (NS-02), flagged here for Round-2 routing.
