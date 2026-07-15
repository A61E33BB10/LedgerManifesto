# Managed Account (§6 + Addendum A1) — Independent Read: `regulatory-reporter` lens

Derived from the primitives, not from convention. My concern is the reportable surface: which
economic events become regulatory reports, and whether the design can *produce and pair* them.

## What it is (reporting view)

A managed account is one wallet partition plus a mandate-unit `u_MA` issued manager→client
(`w_mgr(u_MA)=−1, w_cli(u_MA)=+1`). From a reporting standpoint this is not one surface but
**four distinct reportable populations**, which the framework deliberately runs through one
mechanism:

1. **Underlying book trades** — EMIR Refit / MiFIR RTS 22 / SFTR / CFTC 43-45, by instrument.
2. **The mandate issuance `u_MA` itself** — reportability *undetermined* (F5).
3. **TRS / synthetic managed account** (`§6` TRS = same mechanism as periodic reset) — an OTC
   equity/total-return swap; EMIR-reportable with daily valuation (VALU) and collateral (MARU).
4. **CSA margin contract** — EMIR margin/collateral reporting; SFTR if collateral is on-lent.

The reporting-relevant primitives are: the stored CDM `BusinessEvent` payload (the report
source of record — the *forgetful* map `F` keeps it whole in the log), `WalletRegistry`
(KYC/LEI/permissions — **the only home for legal-entity identity**), and the per-`(w,u)`
`PositionState` row (a clean, non-collapsing key per reportable relationship).

## What must hold

- **MH-1 Report source = CDM event, not the net move.** TRS and periodic reset emit a *single
  net cash move* per reset. The reportable unit is the *contract* `u_TRS`/`u_MA` and its
  lifecycle, never the netted figure. Reports must derive from the stored CDM `BusinessEvent`
  (§CDM: `F` retains it in the log payload), so this is satisfiable — but load-bearing.
- **MH-2 Every virtual counterparty wallet binds to a validated LEI + an RC/OC determination.**
  Dual-sided EMIR/SFTR pairing needs two real legal entities and a shared UTI; the closed
  system models the counterparty as a *virtual wallet*. `WalletRegistry` must resolve each such
  wallet to a real LEI and reporting-counterparty role, or no paired report can be built.
- **MH-3 Event-class → action-type mapping.** C2's per-event-class `StateDelta` is the natural
  hook for deriving EMIR/CFTC action types (NEWT/MODI/TERM/VALU/MARU/EROR). Each reportable
  event class must map to exactly one action type.
- **MH-4 Valuation cadence ⟂ reset cadence.** A monthly-reset account still owes *daily* EMIR
  VALU + collateral reports. `V_t` is state-sufficient at any `t` (P10, state-sufficiency), so
  arbitrary-`t` projection is available — but the reporting trigger must be wired independently
  of the crystallisation schedule, not derived from it.
- **MH-5 Price consistency = field consistency.** §6's TRS rule (same `P_t` for `ℒ_v` valuation
  and `ℒ_r` settlement) *is* the EMIR mark-to-market / valuation-timestamp consistency
  requirement. If violated, the reported MTM and the settled cash diverge → unexplained PnL on
  the report.
- **MH-6 Per-relationship reportability.** Multi-mandate composition (base + overlay) as two
  `(w_cli,u_MA,*)` rows is a *reporting asset*: each relationship reports independently; a flat
  per-wallet scalar would have fused two reportable populations. The three-map model is correct
  here by construction.

## Where it can break

1. **Counterparty-LEI erasure (deepest tension).** "External counterparties are virtual wallets;
   the ledger has no outside within scope" is exactly the abstraction that regulatory reporting
   refuses: reporting *is* the boundary with a separate legal/reporting entity. If
   `WalletRegistry` does not bind every counterparty/UB virtual wallet to a validated LEI and an
   RC determination, dual-sided reports cannot be generated or paired. **Framework-level; flag.**
2. **Net-settlement hides gross detail.** The single net move per reset satisfies conservation
   but is *not* the reportable artefact. CFTC Part 43 real-time and MiFIR post-trade transparency
   want the transaction, not a period net. Breaks if any pipeline reports from the move rather
   than the CDM event (violates MH-1).
3. **F5 — mandate-issuance reportability is ungoverned.** An investment-management agreement is
   generally *not* an EMIR derivative; a synthetic prime-brokerage/TRS mandate *is*. A uniform
   "mandate-as-unit" treatment risks both false positives (reporting an IMA) and false negatives
   (missing a synthetic swap). Needs a per-product, legally-sourced `ProductTerms[u_MA].reportable`
   determination *before code ships* (A1 R8/F5; ownership currently unassigned, cf. F2).
4. **Custom-basket TRS underlier identification.** `ℒ_v/ℒ_r` isolation (P7) correctly prevents
   reporting simulated trades — good. But the reportable TRS still needs UPI/ISIN/basket
   identification of the virtual underlier; a bespoke index in `ℒ_v` may have no ANNA-DSB UPI or
   ISIN, risking an incomplete EMIR underlier field.
5. **Reference-data enrichment is out of the move stream.** UTI (CPMI-IOSCO waterfall), UPI,
   LEI validation, FC/NFC± classification, collateral detail — §Regulatory states these "may
   not reside in the move stream." The ledger removes the *trade-data* pipeline, not the
   *reference-data* one. The move stream is **necessary but not sufficient** for a complete
   report; the enrichment boundary must be documented, not assumed away.

## Net

The event-sourced, CDM-payload-preserving design is structurally *well-suited* to DRR-style
reporting and to BCBS 239 / MAR / DORA audit expectations. The two genuine hazards are both at
the **boundary the closed system abstracts away**: (a) recovering real counterparty LEIs and
RC/OC roles from virtual wallets (MH-2 / break-1), and (b) the F5 legal characterisation of
mandate issuance. Both require an external stakeholder (Regulatory) before build — they are not
resolvable by argument inside the move algebra.
