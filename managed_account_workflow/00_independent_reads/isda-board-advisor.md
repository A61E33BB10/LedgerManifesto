# Independent Read — ISDA Board Advisor lens

Scope: Ledger §6 (Managed Accounts, Virtual Portfolios, TRS) read with Addendum A1
(three-map StatesHome model, mandate-as-unit). Derived from the primitives; ISDA/CDM/DRR
positions used only where the spec itself invokes CDM (§ CDM Integration, § Regulatory).

## What the managed account is, in my terms

A managed account is one wallet partition viewed as a **Reference Portfolio** whose
performance accrues to an **Ultimate Beneficiary** (Treasury, PB client, QIS investor). The
mechanism is a single deterministic smart contract — Observe `Perf = V_{t_k} − V_{t_{k-1}}`,
Crystallise one net cash move `w_ref_cash → w_UB_cash`, Reset baseline — and it is provably
the *same* mechanism as a TRS settlement (`Payment_k = N_k·TR_k − N_k·r_k·Δt_k`), with the
book playing the role of the virtual ledger `ℒ_v`. This collapse of desk-PnL-settlement,
PB swap, QIS-TRS and synthetic exposure into one primitive is the design's deepest claim and
it holds by conservation.

The crux of A1: **the mandate is itself a unit** `u_MA`, issued manager→client
(`w_mgr(u_MA)=−1`, `w_client(u_MA)=+1`, `Σ_w=0` by the standard issuance law). Every fact
that looked per-wallet (HWM value, entry NAV, accrued mgmt/perf fee, breach flags,
benchmark NAV at inception) relocates to `PositionState[w_client, u_MA]`; shared methodology
to `ProductTerms[u_MA]`; the live index level to `UnitStatus[u_bench]`. Multi-mandate
(base + overlay) is two rows, not a collapsed scalar.

## What must hold (from this lens)

1. **CDM is the declared canonical vocabulary** (§ CDM Integration). For the managed-account
   workflow to be CDM-native rather than a bespoke island, three mappings must be faithful:
   the TRS unit → CDM `TotalReturnSwap`; periodic settlement → CDM `Transfer`; and the
   lifecycle of each position → CDM `BusinessEvent`/`TradeState`. The spec asserts the first
   two map "directly" — I accept the TRS mapping; it is canonical DRR/CDM territory.
2. **Price consistency is contractual, not incidental.** `ℒ_v` valuation and the real TRS
   settlement must use the *same* price vector `P_t`. In CDM this is the observation/pricing
   source on the payout; it must be a specified source, not a bilateral choice, or the firm
   manufactures unexplained PnL. This is sound and aligns with how CDM observation terms work.
3. **CSA margin operates at portfolio level on a per-counterparty collateral wallet**, with
   `CollateralProvisions` at Trade level deciding *which* CSA governs. This is exactly the
   CDM `Collateral` model and is the correct seam for tokenised-collateral readiness later:
   if collateral units can be tokenised assets, the wallet abstraction already supports it.
4. **Quantitative mandate constraints as move-generation preconditions = CDM validation
   rules before a `BusinessEvent` is admitted.** Correct mapping; deterministic and auditable.
   Qualitative constraints stay external — also correct; the ledger evidences, never judges.

## Where it can break (this lens)

- **B1 — No native CDM product type for an investment mandate.** `u_MA` is a discretionary
  IMA wrapper, not a CDM `Trade`/derivative. CDM's product model covers tradable contracts;
  it has no canonical representation of "investment mandate issuance." Promoting the mandate
  to a first-class unit is correct *inside* the ledger, but at the CDM boundary it is a
  bespoke unit type with no synonym mapping. This is the most likely point of divergence and
  the seed of a stranded, non-interoperable object. **A1-F5 names the symptom; this is the
  cause.**
- **B2 — The `reportable` flag (A1-F5) is hardcoded regulatory interpretation = divergence
  risk.** A1 proposes a boolean `ProductTerms[u_MA].reportable`, set by pre-flight with the
  Regulatory team. This is precisely the firm-specific, human-interpreted regulatory logic
  that DRR exists to eliminate — and the kind of divergence that has cost the industry ~$300M
  in misreporting fines. The reportability of `u_MA` issuance (is it a derivative? an SFT? a
  collateral arrangement? — generally none of these for a pure discretionary IMA, but the
  *synthetic TRS exposure* it wraps IS reportable) is an **eligibility determination that
  belongs in DRR golden-source code**, not a hand-set flag. Recommendation: the flag's value
  must be *derived* by DRR-style executable logic over the unit's CDM representation, with a
  traceability link from the decision to the rule — never asserted per firm.
- **B3 — F6 is unverified and load-bearing for reporting.** CDM models lifecycle state as
  `TradeState`-per-`Trade`; the ledger collapses to `PositionState[(w,u)]`. DRR generates
  reports from CDM `TradeState`/`BusinessEvent` lineage. If the 3-map collapse and the
  per-Trade state graph diverge, any DRR report generated from the move stream is wrong at
  source. A1's mitigation (rerun Rosetta NS1–7 against the 3-map schema, publish a delta) is
  the right action and must precede any adapter work. Until that delta exists, "CDM-native"
  is asserted, not shown.
- **B4 — Reference-data gap at the reporting boundary (consistent with § Regulatory).** The
  move stream carries economic substance; it does not carry UTI generation, LEI pairs, or
  counterparty classification. Dual-sided EMIR/SFTR reporting needs both sides to produce
  matching UTI/LEI. The ledger's closed-system treatment of external counterparties as
  *virtual wallets* means the manager↔client mandate issuance has no native UTI/LEI surface.
  This confirms the spec's own caveat that DRR removes the *trade-data* pipeline but not the
  reference-data enrichment. The managed-account workflow must expose a CDM-faithful event
  stream at its boundary that DRR + a reference-data system can jointly consume.

## Net assessment

Architecturally aligned with the CDM-native direction of travel: TRS, settlement, CSA and
quantitative-constraint mappings are sound and DRR-ready. Two regulatory seams are
*misaligned and must be fixed before code ships*: (B2) replace the hand-set `reportable`
flag with DRR-derived eligibility logic + traceability, and (B3) close F6 with the Rosetta
delta. (B1) the mandate-as-unit needs an explicit CDM representation decision — extend the
product model or quarantine `u_MA` as ledger-internal with a declared non-reportable status
proven, not assumed. None of these breaks conservation; all three are boundary/interoperability
risks, which is exactly where this framework meets the regulated world.
