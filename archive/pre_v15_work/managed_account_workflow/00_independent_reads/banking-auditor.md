# Independent Read — Managed Account (Ledger §6 + Addendum A1)
**Lens:** banking-auditor (assurance / IFRS / Basel / CASS). Derived from the primitives, not from practice.

## What it is (my model)
The managed account is a **wallet** `w` whose economic relationship to a beneficiary is carried by a
**mandate unit** `u_MA`, issued manager→client at quantity `−1 / +1` (issuance law, §6 / A1 §5.2). It is
not a custody account; it is a partition of position space plus a smart contract. At each reset `t_k` the
contract **Observes** `Perf = V^ref_{t_k} − V^ref_{t_{k-1}}`, **Crystallises** one net cash move
`w_ref_cash → w_UB_cash`, and **Resets** the baseline (§6.2). Per A1, the mandate's economic state is split:
methodology/terms in `ProductTerms[u_MA]` (immutable, versioned); client-specific HWM value, `entry_nav`,
accrued mgmt/perf fee, breach flags, sub/redemption cursor in `PositionState[w_client,u_MA]`; shared
benchmark level in `UnitStatus[u_bench]`. There is no per-wallet scalar sector (C12).

In assurance terms this is a **trading-book sub-ledger and system of record**: client statements, desk PnL
and position reports are one move stream under different wallet filters (§6.9). Its strength is *internal*
integrity by construction (conservation P1, append-only hash-chained log P4, monotone carrier). It is **not**
a statutory measurement engine: PnL is explicitly *economic, not accounting* — IFRS 9 classification
(FVTPL/FVOCI/amortised cost) and fair-value mechanics are out of scope.

## What must hold (audit assertions, derived)
1. **Conservation incl. `u_MA`** — `Σ_w w(u)=0 ∀u` by `src−=q; dst+=q`; the mandate balances `−1/+1`. Quantity integrity by construction (P1).
2. **`u_MA` is non-valued** — it must carry no price (`P_t(u_MA)` undefined/0) so it never enters `V_t=Σ w·P`. The client's exposure is the underlying positions in `w_ref` / `ℒ_v`, **not** the mandate unit. Else exposure is double-counted.
3. **Price consistency / one governed vector** — carry `V_t` and crystallisation/TRS settlement must use the *same* timestamped, externally-governed `P_t` (§6.7 TRS note). Divergence ⇒ unexplained PnL.
4. **Atomicity (C3)** — fee accrual/crystallisation, baseline reset, and the cash move are one `StateDelta` across all three maps, or none.
5. **Sign-correct crystallisation** — moves require `q>0`; a *negative* `Perf` must reverse direction (`w_UB→w_ref`), with mgmt fee accruing on losses but performance fee not (asymmetry, hurdle, HWM).
6. **HWM monotone, single writer** — `hwm` ratchets only per declared methodology (C11: `hwm→fee_crystallise`); perf fee charged only above HWM/hurdle. Each field has one canonical handler.
7. **Substantiation by projection (§6.9)** — each balance is a deterministic projection of the filtered move stream; no separate internal account record to reconcile.

## Where it can break (risk, with materiality)
- **Boundary / existence — most material.** Internal consistency ≠ external existence. "Single source of truth, no internal reconciliation" says nothing about whether positions exist at the custodian or whether the counterparty confirms the trade. Custodian/counterparty confirmation and **legal** CASS-6 segregation (vs the ledger's *logical* segregation) remain independent procedures (§6.3). Over-reliance is the dominant audit risk. **Material & pervasive.**
- **Valuation — pervasive.** Ledger is a price-*taker*. No IFRS 13 / ASC 820 fair-value hierarchy, no independent price verification, no CVA/DVA/FVA, no bid-offer / liquidity / model reserves, no IFRS 9 C&M. A separate **accounting overlay** is required to move from economic PnL to statutory FS. The ledger evidences quantities and an economic value; it cannot alone support Level 2/3 disclosures.
- **Accrued fee / HWM stored as state, not projection.** Accrued mgmt/perf fee is *mutable stored* `PositionState`, so it can diverge from a recomputation from `ProductTerms` + `V_t`. This is a residual internal-reconciliation surface the "no internal reconciliation" claim does not cover — accrued fee should be re-derivable and tied out to `V_t` at any reporting date (cut-off when reporting date ≠ reset date).
- **Performance-fee model risk.** Crystallisation arithmetic, hurdle, equalisation/series accounting, clawback are not proved here — a Level-3-like estimate needing model governance and validation. Risk of fee over/understatement; fee-income recognition (IFRS 15) sits outside ledger scope.
- **Offsetting presentation.** Portfolio-level CSA netting (§6.4) is the right *netting set* but does not by itself satisfy IAS 32.42 / ASC 210-20 net-presentation criteria (legal right + intent to settle net). Gross-vs-net on the balance sheet is a separate determination.
- **Regulatory reporting surface (F5).** `u_MA` issuance may trigger SFTR/EMIR reportability (UTI/LEI). Risk of spurious *or* omitted reporting; the `reportable` flag and the C8 fungibility-predicate ownership (F2) are ungoverned — **escalate**, do not engineer around.
- **Completeness at input boundary.** Conservation guarantees integrity of what is *recorded*, not capture of what *occurred*; a trade that never enters the stream is invisible (state-sufficiency assumes all economic changes are recorded).
- **Restatement / cut-off.** Back-dated corrections must be compensating entries preserving P4 (no in-place edit), with IAS 8 prior-period restatement reproducible from the log.

## Escalation
Endorse A1 **F5** (mandate-as-unit reporting surface) and **F2** (predicate ownership) for external
(Regulatory/Legal) sign-off before build. Add: confirm `u_MA` is a zero-value memo unit excluded from
`V_t` and from RWA/exposure, to prevent double-count.
