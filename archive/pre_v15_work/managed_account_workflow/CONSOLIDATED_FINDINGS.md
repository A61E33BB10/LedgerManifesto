# Consolidated Findings — Step-2 Review Digest (input to Step-3 convergence)

This digest consolidates the nine lenses' Step-2 reviews into shared issue clusters, so the
Step-3 resolvers converge on **one** answer per issue rather than diverging. It is a faithful
synthesis of the review files in `01_section6_review/`; it adds no facts. Each cluster lists
the lenses that raised it and the candidate resolution direction. Resolvers must still derive
and may dispute; this is the starting register, not a verdict. A cluster's status is the
**worst** status any touched lens assigns.

The unifying verdict of the reviews: **the §6 mechanism is sound as quantity algebra
(conservation and quantity-level double-entry hold by construction at every step S1–S10), but
§6 as written is not yet correct as a *performance* and *fee* engine, and its economic-state
placement collides with Addendum A1's own anti-caching principle.** Most issues are §6
corrections / invariants §6 leaves implicit. A small set are genuine framework-level flaws.

---

## A. §6-correction clusters (candidate: ANSWERED — derivable from primitives)

- **A1 — Signed quantity vs `q>0` (partial move-generator).** Lenses: finops F2, minsky B1,
  formalis F9, correctness B1. §6's crystallise/TRS/settlement listings hardcode one direction
  with `quantity:Perf`, but `Perf`, `Payment_k`, and any fee leg are signed while `Move`
  requires `q>0`. The IRS contract already solves this (briefing §1: emit `q=|x|`, direction
  `=sign(x)`). Reject `x=0`. One root cause, four sites. **Resolution: emit `q=|x|`,
  direction by sign, `x=0` emits no move.**

- **A2 — Capital-flow contamination of `Perf`.** Lenses: finops F1, banking-auditor, formalis
  F11, correctness B2, jane-street B-5. `Perf = V_{t_k} − V_{t_{k-1}}` is gross of flows;
  §4's own `PnL = PnL_price + PnL_flow` proves a mid-period subscription/redemption is a flow,
  so the gross figure crystallises contributed capital as performance. **Resolution: net out
  flows — `Perf = (V_{t_k} − V_{t_{k-1}}) − netCapitalFlow_[t_{k-1},t_k]`, where net flow is a
  projection over the already-tagged subscription/redemption moves (the A1 cursor). No new
  coordinate.**

- **A3 — Reset baseline law.** Lenses: finops F5, formalis F10, correctness B3. Crystallise
  drains `Perf` cash; Reset must set the next baseline to the **post-settlement** capital base
  `B_k = V_{t_k} − Perf_k (+ netCapitalFlow)`, not the pre-move `V_{t_k}` (which would claw
  performance back next period). **Resolution: state `B_k` explicitly; see E1 for whether
  `B_k` is a stored field or a fold.**

- **A4 — Fee ≠ PnL settlement; fee-handler totality.** Lenses: finops F3, formalis F5,
  banking-auditor. §6's single whole-`Perf → UB` move is the **internal desk → Treasury** case.
  A client managed account pays the manager only a **fee fraction**; the gain **stays in the
  client book**. Management fee accrues on AUM regardless of sign; performance fee
  `= max(0, rate·(NAV − HWM))` floors at zero, no clawback, HWM unchanged on a loss. The
  handler must be **total over `sign(NAV − HWM)`**. **Resolution: two distinct contract
  instantiations — (i) desk PnL sweep (whole Perf), (ii) managed-account fee (only the fee
  crosses); fee handler total over sign.**

- **A5 — Segregation is NOT conservation.** Lenses: formalis F3 (category error, CRITICAL),
  correctness, jane-street, minsky. Conservation does **not** forbid a perfectly conservative
  move between two clients' partitions. §6.3's "conservation enforces segregation by algebra"
  is false as a theorem. **Resolution: segregation = conservation (CONS) **+** capability
  scoping (C4/locality LOC); restate §6.3. C4 must be a typed capability argument on the
  accessor (see E4).**

- **A6 — `u_MA` value-exclusion.** Lenses: minsky, formalis F2, correctness, jane-street,
  finops. `V_t = Σ_u w(u)P_t(u)` ranges over all held units; a non-zero `P_t(u_MA)` adds the
  mandate to the client's per-wallet NAV and double-counts the underlying exposure (it cancels
  only in the **global** sum). **Resolution: `u_MA` is a typed non-valued memo unit,
  structurally excluded from the domain of `V_t` — not merely priced 0.**

- **A7 — `u_MA` support cardinality.** Lenses: formalis F1, correctness, minsky. Conservation
  `Σ_w w(u_MA)=0` admits `(+5,−5)` or three-way splits; it does **not** prove the singleton
  `{w_manager:−1, w_client:+1}`. **Resolution: add a structural invariant — `u_MA` is a
  singleton bilateral contract, `support(w↦w(u_MA)) = {(w_manager,−1),(w_client,+1)}`.**

- **A8 — Fee accrual must be double-entry.** Lenses: banking-auditor (DECISIVE), formalis
  Ob.3(b) CRITICAL. `accrued_{mgmt,perf}_fee` as a non-conserved stored scalar is single-entry,
  outside conservation, with no contra-account; C2 checks only conserved fields, so nothing
  couples the cash leg `q_fee` to `Δaccrued_fee`. **Resolution: model accrual as a real
  position — a fee-payable unit `u_fee` issued client→manager (conserved, double-entry) — or
  bind the cash leg and the scalar in one atomic `StateDelta` (C3) with an explicit coupling
  proof. Prefer the contra-account.**

- **A9 — Settlement finality / corrections.** Lenses: finops F10, nazarov N8, correctness. The
  crystallise move is treated as final, but external cash settles T+1/T+2 and can fail; a fail
  is represented by a **compensating reversing transaction** (immutability ⇒ reverse, never
  edit). The spec already has this (l.1648, l.1807); §6 must reference it. **Resolution:
  ANSWERED by reference.**

- **A10 — Substantiation claim narrowed.** Lens: banking-auditor. §6.9 "the move stream IS the
  evidence; no record to reconcile" overclaims vs §8 (ledger substantiates **quantities +
  provenance** only; valuations/disclosures/legal status need external evidence).
  **Resolution: narrow §6.9 to quantities + provenance.**

- **A11 — Net settlement ≠ net presentation.** Lens: banking-auditor. The net move is
  **operational** netting; IAS 32.42 / ASC 210-20 require a legally enforceable right of
  set-off **+** intent. **Resolution: conformance flag — balance-sheet net presentation needs
  a separate legal-set-off determination outside the ledger.**

- **A12 — TRS: ledger identity ≠ CDM taxonomy.** Lenses: isda T1/T3, regulatory. "TRS =
  periodic reset = managed account" is true as cash algebra (one net move) but a CDM
  `TotalReturnSwap` is two-legged (performance + financing `N·r·Δt`) and the bare `Move` with
  free-string metadata is not a CDM `Transfer`/`BusinessEvent`. **Resolution: the report
  source-of-record is the retained CDM `BusinessEvent` (forgetful map F keeps it whole), never
  the netted settlement move; the structural identity is a ledger-mechanism identity, flagged
  as not a CDM/reporting identity.**

- **A13 — `u_MA` maps to CDM LegalAgreement, and is non-reportable.** Lenses: isda M1,
  regulatory. A discretionary IMA is a CDM `LegalAgreement` (ISDA Create family), not a
  tradable `Trade`; `u_MA` issuance is the MiFID II Annex I §A(4) portfolio-management
  **service**, not a Section C instrument, not an SFT, not a derivative — **not reportable**.
  The reportable artefact is never `u_MA` but the underlying book trade or `u_TRS`, each with
  its own UTI/UPI/LEI. **Resolution: discharges A1's open risk F5; `u_MA` needs no UTI.**

- **A14 — Simplicity gate (jane-street).** B-3/B-4: the three crystallisation listings collapse
  to **one** parameterised move-generator (spec itself says "same mechanism" then writes it
  thrice). B-2: a virtual ledger need not be "a second complete ledger instance" — the minimal
  basis is a `realm ∈ {real,virtual}` tag enforcing isolation invariant P7. B-6: base+overlay
  attribution — give **separable** mandates disjoint sub-wallets (then `V^ref` is per-mandate
  by projection, no attribution rule); a genuine **overlay** sharing the same positions still
  needs an explicit attribution rule (finops F8 stands). **Resolution: adopt the collapses;
  scope B-6 to separable vs overlay.**

## B. Framework-level clusters (candidate: ESCALATE — cannot resolve without changing the framework)

- **E1 — Store-vs-derive economic scalars (A1 internal inconsistency).** Lenses: minsky
  (FRAMEWORK-LEVEL ESCALATION), jane-street B-1, banking-auditor, correctness (Goodhart trap).
  A1 stores `hwm`, `entry_nav`, `accrued_fee`, and the reset baseline at
  `PositionState[w_client, u_MA]`, yet A1's **own** `first_touch_date` ruling (addendum l.189)
  forbids caching a value that is derivable from the event log, because the cache desyncs under
  **back-dated corrections** (fold-inconsistency). HWM is a monotone fold over recorded price
  snapshots; accrued fee is a fold over the rate schedule and NAV path; the baseline is a fold
  over settlements. Storing them re-creates exactly the internal-reconciliation surface the
  framework claims to abolish. **This is a genuine A1 inconsistency. Escalation, with the fix
  direction in E2: once prices are recorded as snapshot events, these scalars become folds
  (derived), and only genuinely irreducible state remains stored.**

- **E2 — Observation surface is not versioned/attested.** Lenses: nazarov N2 (decisive
  structural gap), N4, jane-street (LINCHPIN), correctness (determinism boundary), banking-
  auditor. `last_settlement_price` and the benchmark level live in **`UnitStatus`**, which A1
  defines as **mutable, shared, overwritten in place, NOT versioned**. So the exact price /
  benchmark level that struck an **irreversible fee** is overwritten and not replayable; the
  benchmark (which sets the perf-fee hurdle = client money) gets weaker discipline than the
  price vector and no staleness/fallback/cross-source check; and `P_t` is an ambient oracle,
  not a recorded input shared by `ℒ_v` valuation and `ℒ_r` settlement. **Escalation: the
  framework needs an attested, content-addressed, append-only price/benchmark **snapshot event**
  discipline (consistency by sharing the snapshot hash, not after-the-fact reconciliation).
  This is the linchpin that also discharges E1.** (Fixing-data corrections, TRS financing
  fixing `r_k`, and intraday path observations ride on the same surface — N6, N8.)

- **E3 — Virtual-wallet LEI gap for dual-sided reporting.** Lens: regulatory. The closed system
  models counterparties as **virtual wallets with no LEI**, but dual-sided EMIR/SFTR pairing
  and the CPMI-IOSCO / EU Art 7 **UTI-generation waterfall** require **two validated LEIs** (ISO
  17442), a reporting-counterparty determination, and FC/NFC(+/−) (CFTC SD/MSP) classification.
  `WalletRegistry` is the only candidate home and is declared non-state. **Escalation: the
  virtual-wallet abstraction erases the second real LEI that dual-sided reporting requires;
  the framework must either promote counterparty identity to first-class reportable state or
  document the boundary dependency.**

- **E4 — C4 capability scoping is asserted, not typed.** Lenses: minsky, correctness, formalis.
  Segregation (A5) and the no-cross-`(w,u_MA)`-overlay-read guarantee depend on C4, but A1's
  reference accessor `position(self, w, u) → Option[PositionState]` takes **no capability
  argument**, so a `fee_crystallise` firing on the overlay can read the base mandate's state.
  **Candidate: ANSWERABLE by giving the accessor a capability parameter (a §-level refinement),
  OR ESCALATE if the touched lenses judge the reference signature a framework defect. Let the
  loop decide.**

- **E5 — No in-ledger solvency/funding liveness.** Lenses: finops F4, correctness. Crystallising
  unrealised MTM can drive `w_ref_cash` negative; negative = legal obligation, so nothing
  distinguishes a **funded** obligation from an **insolvent overdraft**. **Candidate: ANSWERED
  as "ledger represents the obligation; the settlement layer funds it; client-money wallets
  carry a non-negativity precondition," OR ESCALATE if the lenses want a liveness invariant.
  Let the loop decide.**

- **F6 (carried from A1) — CDM `TradeState`-per-`Trade` vs `PositionState[w,u]`** alignment is
  asserted, not verified. A13 (map `u_MA` to LegalAgreement) discharges the mandate side;
  whether the position side aligns remains a flagged conformance item for the responsible owner.

---

## C. Numerical worked example to carry end-to-end (resolvers must keep it consistent)

One managed account `w_C` under mandate `u_MA` (manager `w_M`), USD, quarterly reset,
2%/year management fee, 20% performance fee over a high-water mark, no hurdle/benchmark for the
fee (benchmark used only for performance *reporting*). Carry: subscription → one trade → a
period's NAV → a performance-fee crystallisation against the HWM → redemption, verifying
`Σ_w w(u) = 0` for every unit at every step, and fee zero-sum at crystallisation. The
orchestrator will fix and verify the exact figures; resolvers must not contradict the chain.
