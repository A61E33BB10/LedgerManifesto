# §6 Review — banking-auditor lens

**Charge (Step 2):** Account-level balance-sheet substantiation (§6.9); accounting treatment of
NAV, accrued management and performance fees, performance vs benchmark; journal-entry
equivalence. Derived from the primitives and from the framework's *own* established patterns;
market practice is cited only to size materiality, never to source a rule.

Sources read in full: v10.3 §4 (l.494–601), §6 (l.806–977), §8 (l.1483–1599), transaction-class
taxonomy (l.1805–1814), SBL fee mechanics (l.3620–3630, l.4201, l.6627–6804); Addendum A1
(state-home table l.107–111, l.206–217, l.236–247; C11 l.145; `FIELD_SPEC` l.433–438). All nine
independent reads.

---

## A. The decisive finding — fee accrual is single-entry; the framework already has the double-entry primitive

**Finding.** Management fee and performance fee are carried as **non-conserved stored scalars**
`accrued_mgmt_fee`, `accrued_perf_fee`, `hwm`, `entry_nav` in `PositionState[w_client, u_MA]`
(A1 l.111, l.209), and `FIELD_SPEC` explicitly tags such fee/HWM state `"conserved": False`
(A1 l.438). A scalar that grows with no equal-and-opposite contra entry is **single-entry
accounting**. It has no payable leg, no expense leg, and `Σ_w Δ ≠ 0` for that field — it sits
outside the conservation law (P1) and therefore outside the move stream.

**This contradicts the framework's own treatment of an accrued fee elsewhere.** In the SBL section
the accrued-but-unpaid lending fee is modelled as the **price of a conserved loan unit**: lender
`+1`, borrower `−1`, "the loan unit's price function is the accrued but unpaid fee" (l.3630), and
fee settlement is "a cash move that resets the loan unit price to zero — net PnL from the payment
event is zero ... Conservation: `−216.71 + 216.71 = 0`" (l.4201). That is correct double-entry: the
accrual is the **value of a held unit**, conserved by construction, projected from the stream,
substantiated by replay. The daily-accrual arithmetic there ties (l.6627:
`29,250,000 × 0.0025/360 = €203.13`; running total `€818.58` ✓).

**Standard / principle reference.** Accrual basis and double-entry: IAS 1.27–28; a management fee
earned-but-unpaid is a payable/receivable at each reporting date (IFRS 15 for the manager's revenue,
IAS 37 for the client's liability), not a memo. *Framework-internal:* the conservation law (P1,
l.33–36) and the **Minimalism** principle in CLAUDE.md — "Nothing is added that an existing
primitive already covers." The non-conserved `accrued_fee` scalar **adds** a mechanism the priced-
unit-accrual primitive (l.3630) already covers, and in adding it **breaks** double-entry.

**Risk / implication.** Two failures from one root: (i) the accrued-fee balance is **not**
substantiated by the move stream and has **no contra-account**, so it can diverge from a
recomputation and there is nothing to reconcile it *to* — a genuine internal-reconciliation surface
the design claims to have eliminated (see §B); (ii) it is not journal-entry-equivalent — see §E.
Accrued performance fee on a large book is **quantitatively and qualitatively material** (it is the
firm's revenue and the client's money simultaneously).

**Recommended treatment.** Carry the management/performance fee accrual as the **price of a
fee-accrual unit** held manager `+x` / client `−x` (or as a value component of `u_MA` itself),
exactly as the SBL loan fee at l.3630. Then accrual is conserved, double-entry, projected, and
substantiated; crystallisation resets the unit price to zero by a cash move (the l.4201 pattern).
This deletes the non-conserved scalar fields and restores every §6.9/§8 substantiation claim to the
fee population. The framework's own **ACCOUNTING** transaction class (l.1806: "internal adjustment
with no external transfer … PnL crystallisation, internal revaluation") is the correct vehicle for
the inter-reset accrual — an accrual is a set of moves with `Σ=0`, not a scalar bump.

**Management action.** Owner of §6 + A1 schema: replace `accrued_{mgmt,perf}_fee` scalars with a
priced fee-accrual unit before build; re-run the conservation proof over the fee population.

---

## B. §6.9 balance-sheet substantiation overclaims relative to §8 — and the gap is exactly the fee/HWM state

**Finding.** §6.9 (l.944) states "there is no separate account-level record to reconcile against:
the account IS the set of wallet balances, and the move stream IS the evidence." §8 (l.1495–1507) is
materially more careful: "the ledger substantiates **quantities and transaction provenance**;
disclosures, valuations, and legal status require supplementary evidence." §6.9 is the **looser**
statement; §8 is the defensible one. They must be reconciled in §6.9's favour of §8.

A *balance sheet* is quantities × prices + accruals + classification. The move stream substantiates
**quantities** by projection (the l.1490 replay formula — verified: it is a clean fold). It does
**not** substantiate, and §6.9 must not be read to claim it does:
1. **Accrued mgmt/perf fee** — stored, non-conserved, not a projection (§A). This is the *one*
   account-level record that *does* require internal reconciliation, and it is a fee/revenue figure.
2. **Valuations** — the ledger is a **price-taker** (`P_t` is "an external input … not computed by
   it", l.516; "may be stale, unavailable, or may not reflect achievable liquidation values"). No
   IFRS 13 / ASC 820 fair-value hierarchy, no independent price verification (IPV), no CVA/DVA/FVA,
   no bid-offer/liquidity/model reserves. §8 itself concedes IAS 1.117–124 and IFRS 13 Level 1/2/3
   disclosures "depend on information outside the move stream" (l.1505).
3. **Classification** — FVTPL/FVOCI/amortised-cost is "outside the ledger's scope" (§4 scope note,
   l.~590); economic PnL ≠ accounting PnL.

**Risk / implication.** Over-reading §6.9 as "the balance sheet needs no reconciliation" is the
dominant audit risk: it conflates **internal** integrity (real, by construction) with **external
existence and statutory measurement** (neither established). Material and pervasive.

**Recommended treatment.** Amend §6.9 to adopt the §8 wording verbatim: *quantities and provenance*
substantiated by projection; *accruals, valuations, classification, and legal status* require
supplementary evidence and (for fees) re-derivation. Once §A is adopted, the accrued fee migrates
from list-item (1) into the substantiated set — the cleanest resolution.

---

## C. NAV and the Perf formula — fees charged on contributed capital, and no unitisation

**Finding (flow contamination).** The reset oracle is `Perf = V^ref_{t_k} − V^ref_{t_{k-1}}`
(l.826), and §4's own decomposition proves `PnL = PnL_price + PnL_flow` with
`PnL_flow = Δw(USD) + Σ Δw(i)·P` (l.547–554); l.1366 confirms subscriptions/redemptions are flows
that change the book. Therefore `Perf` as written is **gross of capital flows**. A management or
performance fee struck on `Perf` is charged on **subscribed capital**, not investment return — an
overstatement of fee income and a real, irreversible cash move out of client money. The fix-data
(`entry_nav`, subscription/redemption cursor, A1 l.208–209) exists but §6 never references it.

**Standard reference.** A performance fee is payable only on **net asset value appreciation above the
high-water mark net of contributions/redemptions** — basic NAV accounting; charging on capital is a
client-money misappropriation, not merely a measurement error. Framework-internal: the §4
flow-decomposition is the binding authority against the §6 formula.

**Required form.** `Perf_[t_{k-1},t_k] = (V_{t_k} − NetExternalFlows) − V_{t_{k-1}}`, flows read from
the subscription/redemption cursor.

**Finding (no unitisation / no equalisation).** "NAV" exists in the spec only as `entry_nav`,
`benchmark_nav_at_inception`, `nav_index` — **per-client scalars**, not a unitised
NAV-per-share with units-outstanding. For a single-beneficiary managed account that is adequate
(one `entry_nav`, one HWM). But §6.7/§6.8 explicitly support **multiple investors on one virtual
ledger** ("multiple investors can hold TRS contracts referencing the same virtual ledger", l.969;
"performance proportional to their notional"). Subscriptions at different NAVs into a shared
strategy create the classic **performance-fee equalisation** problem (series accounting or
equalisation-credit method). Neither is specified. `entry_nav` per client handles the simple HWM
case but **not** cross-investor equalisation.

**Risk.** Fee over/under-charge across investors who subscribed at different points; a Level-3-
equivalent estimate with no model governance in the spec. Material to fee income and to inter-client
fairness (and to MiFID II costs-and-charges disclosure).

**Recommended treatment.** Specify the equalisation method in `ProductTerms[u_MA]` and prove it is a
deterministic, stream-reconstructible allocation (this is the same determinism gap formalis B3 /
minsky B5 raise for *performance* attribution — it recurs for *fee* attribution).

---

## D. Performance vs benchmark and the fee asymmetry

**Finding (benchmark mechanics).** Relative performance uses `benchmark_nav_at_inception`
(`PositionState[w_client,u_MA]`, A1 l.210) and the current level (`UnitStatus[u_bench]`, l.211).
The comparison is computable. Three gaps: (i) the benchmark level is an **unattested external feed**
(aligns with nazarov TA-BENCH) — it is a direct input to **fee revenue**, so it requires the same
independent price verification governance as `P_t`; a wrong level mis-charges a real client-money
fee. (ii) total-return vs price-return benchmark basis is unspecified. (iii) benchmark
corporate-action / rebalancing adjustment is unspecified.

**Finding (fee sign asymmetry — accounting, not just move legality).** Other lenses (correctness-
architect B, formalis B1, minsky B1) correctly flag that the single fixed-direction move is a
**partial function** — `Perf < 0` needs `q = |Perf|`, src/dst swapped. The *audit-specific* point
sits on top of that: a **management fee accrues on losses** (it is an AUM/NAV-based charge,
independent of sign), whereas a **performance fee floors at zero and does not reverse below HWM**
(no clawback of prior crystallised fees; HWM loss-carryforward). A single signed `Perf` move
**cannot** encode this asymmetry. Conflating "PnL settlement" (genuinely sign-flipping) with
"performance fee" (floored, HWM-gated) mis-signs cash.

**Finding (fee base undefined).** Management fee base — gross AUM vs net NAV — is not specified;
performance fee base — gain above HWM net of hurdle — is methodology in `ProductTerms[u_MA]` but no
framework-level formula. An unspecified base is unauditable.

**Finding (accrual cadence / cut-off).** C11 tags `hwm → fee_crystallise` (A1 l.145), i.e. the only
handler that touches HWM/fee fires **at reset `t_k`**. No handler is tagged to **accrue the fee
between resets**. Consequence: at a reporting date that is **not** a reset date (the normal interim
case, IAS 34), the accrued mgmt/perf fee is **stale or zero** — the interim balance sheet **omits
the accrual**. Cut-off failure. Material for quarterly/half-year reporting. (This is finops-
architect's "fee-cadence mismatch" seen from the accruals/cut-off side.)

**Recommended treatment.** Define: fee base, the loss-asymmetric fee function with HWM floor, a
continuous accrual handler distinct from the crystallise handler (two cadences, two handlers), and
benchmark IPV governance. Re-strike `accrued_fee` (as the priced fee-unit, §A) at every reporting
date, not only at resets.

---

## E. Journal-entry equivalence — a single net move is not a journal entry

**Finding.** The Move primitive `w_s −= q; w_d += q` is, at the **quantity** level, structurally
double-entry, and conservation `Σ_w w(u) = 0` (l.33) is the trial-balance-balances property by
construction. I affirm this — it is the design's genuine strength. But "journal-entry equivalence"
fails on three counts that fall in my lane:

1. **Net settlement collapses three distinct postings into one cash line.** Crystallisation /
   periodic settlement / TRS each emit **one net cash move** (l.834, l.910, l.937). A correct fee
   reset comprises three economically distinct journal entries: (a) PnL settlement, (b) management-
   fee crystallisation, (c) performance-fee crystallisation (HWM-gated). The single net move
   destroys the gross detail required for IFRS 15 revenue recognition, EMIR VALU/MARU reporting, and
   audit. *Even after the correctness lenses' sign/flow fixes, a single net move is still not
   journal-entry-equivalent.* (Aligns with regulatory-reporter "net-settlement hides gross detail".)

2. **A wallet is not a GL account.** A move debiting `w_UB_cash` is, in chart-of-accounts terms,
   ambiguously a settlement of an intercompany payable, OR fee income, OR a return of capital —
   three different statutory postings behind the **same** move. Classification metadata (the
   accounting overlay) is required and is out of ledger scope; the move is the **cash leg only**.

3. **Accruals have no contra (the §A root cause).** A management-fee accrual moves no cash and no
   position; in this model it bumps a non-conserved scalar with no expense leg and no payable leg.
   That is single-entry. The §A priced-fee-unit fix restores the contra and makes the accrual a
   genuine journal entry.

**Recommended treatment.** Emit the reset as a **transaction of multiple moves** (the §6/l.1814
multi-move decomposition is already the framework's pattern: a `SETTLEMENT` transaction plus a
separate `ACCOUNTING` transaction): one leg per economic component (PnL, mgmt fee, perf fee), each
gross, netting only at the settlement-instruction boundary (§ settlement), never in the ledger.
Retain the gross legs as the report/journal source of record.

---

## F. Offsetting / net presentation (secondary, but balance-sheet-material)

**Finding.** Crystallisation, periodic settlement, and CSA margin all operate on **net** figures
(l.834, l.882 CSA aggregate MTM). Net *presentation* on the balance sheet is a separate
determination: IAS 32.42 / ASC 210-20 require **both** a legally enforceable right of set-off **and**
intention to settle net/simultaneously. The ledger's net *move* is an operational netting; it is not
evidence of the legal right. Presenting net on the strength of net settlement would understate gross
assets and gross liabilities — material to balance-sheet size and to the Basel III **leverage ratio
exposure measure**, which is largely gross.

**Recommended treatment.** Flag gross-vs-net as an accounting-overlay determination outside the
ledger; the ledger evidences the netting set, not the right to net.

---

## G. Arithmetic verification (per QA norm)

- §4 PnL example (l.560–600): `V_0 = 1,000 + 10×100 = 2,000` ✓; `V_1 = 507 + 15×110 = 2,157` ✓;
  Total PnL `2,157 − 2,000 = 157` ✓; `PnL_price = 10×(110−100) = 100`; `PnL_flow = (507−1,000) +
  5×110 = 57`; `100 + 57 = 157` ✓. **One presentational note:** `PnL_price` uses **opening weights
  only** (`w_{t_0}(i)=10`), so the appreciation on the 5 intra-period shares (`5×10 = 50`) lands in
  `PnL_flow`, not `PnL_price`. Arithmetically sound; but performance *attribution* users should know
  it is a Laspeyres (opening-weight) split, not a true time-weighted attribution.
- SBL fee accrual (l.6627): `29,250,000×0.0025/360 = 203.125 → €203.13`; `3×203.125 + 209.20 =
  €818.58` ✓. SBL fee settlement (l.4201): `−216.71 + 216.71 = 0` ✓ — the correct accrual pattern.

No arithmetic discrepancies. No unit ambiguities in the sections reviewed (USD/EUR consistently the
reference currency; `P_t(USD)=1`).

---

## H. Escalations (build on A1, do not re-derive)

- **F5** (mandate-as-unit → SFTR/EMIR surface) and **F2** (C8 fungibility-predicate ownership):
  endorse for external Regulatory/Legal sign-off before build.
- **Add:** confirm `u_MA` carries **no price** (`P_t(u_MA)` undefined/0) so it never enters
  `V_t = Σ w·P` — else the client's exposure is double-counted (mandate unit + underlying
  positions) in valuation and in RWA/exposure. This is a memo/identity unit, not a valued one. The
  fee-accrual *value*, by contrast, **must** be priced (§A) — keep the two cleanly separate.

---

## I. Verdict (my lane)

The quantity algebra and projection-substantiation are genuinely strong for **positions and cash**.
For the **fee/NAV/balance-sheet** layer the section is not yet auditable: (A) fee accrual is single-
entry and inconsistent with the framework's own SBL accrual primitive — the load-bearing defect;
(C) `Perf` charges fees on contributed capital and lacks equalisation; (D) the fee function's loss
asymmetry, base, accrual cadence, and benchmark IPV are unspecified; (E) a single net move is not
journal-entry-equivalent. (B) §6.9 must defer to §8's wording, and (F) net settlement ≠ net
presentation. None require changing the framework — (A) in particular is *resolved by reusing an
existing primitive*, which the Minimalism principle already mandates.
