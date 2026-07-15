# Changelog: Ledger v10.3 → v11.0

Section-granularity record of what was folded in, corrected, compressed, and removed in the
v10.3 → v11.0 consolidation. Governing rule: **drop the path, keep the substance.** Every
change traces to a row of the signed coverage map (coverage_map.md). Result: 20 sections +
appendices A–I, 137 pp, with the consolidated reference Haskell woven in.

The v11.0 section numbering differs from v10.3 because the body was reordered into deductive
order and three new fold-ins were inserted. The mapping is given per entry.

---

## Folded in (new authoritative treatments, superseding informal v10.3 prose)

- **§4 Where Unit State Lives: The Three-Home State Model** (new). Folds in States.tex +
  addendum_stateshome_v2.tex + StatesHome.hs. Introduces ProductTerms / UnitStatus /
  PositionState, the 2×2 derivation (per-unit vs per-(holder,unit) × ledger- vs
  externally-authored, fourth cell empty), the W-sector collapse (C12), and the twelve
  conditions C1–C12. **Supersedes** v10.3 §7.3 "Unit State as Explicit Object" (the mutable
  state-dictionary; `get_unit_state(u)` → `(product_terms, unit_status)`,
  `get_unit_state(w,u)` → `position(w,u)`). Primary Haskell anchor (full StatesHome.hs).

- **§8 The Futures Lifecycle** (new). Folds in FutureLifeCycle.tex + FutureLifeCycle.hs:
  full life-cycle (register → trade → daily VM settle → intraday trade → close-to-flat →
  expiry → Close), the VM fan-out identity, expiry/Close, physical vs cash settlement.
  **Supersedes and merges** the v10.3 §7 futures accumulated-cost ALPHA/CH worked example.
  Haskell anchor (full FutureLifeCycle.hs: distinct Qty/Cash/Price, Stage machine,
  settlementFanout, closeDelta, handle/step/replay).

- **§9 Managed Accounts, Virtual Portfolios, and TRS** (folds in
  managed_account_workflow.tex). **Supersedes** v10.3 §6 (informal managed accounts). Adds
  the derived workflow: managed account = composition of four primitives, mandate-as-unit
  issuance law, fee logic (mgmt + perf, HWM ratchet, perf net of flows, double-entry
  crystallisation), the corrected Segregation theorem, TRS equivalence (= P7 isolation), CSA
  margin, redemption/wind-down, worked example to the penny.

---

## Corrected (substance changed, not merely moved)

- **UnitStatus characterisation (§3, §4, §7, §8, §9, §10, §11, §14).** v10.3's "mutable"
  phrasing for per-unit/per-row state is replaced by the authoritative correction: UnitStatus
  is a materialised projection of the immutable event log — a read cache the log always
  rebuilds, NOT an authoritative mutable store. The canonical wording is used verbatim at
  every cached-state writer site. §12 (settlement) carries a pure-projection pointer to §4.
  Without this, cache/log drift re-admits internal-reconciliation failure.

- **Segregation theorem (§9).** v10.3 §6's "conservation alone enforces segregation by
  algebra" was a **false theorem** — it permits a cross-client move. Replaced by:
  segregation is a theorem under **CONS ∧ LOC ∧ C4** (conservation ∧ locality ∧ the
  capability-read condition). Correctness-critical correction.

- **Futures variation margin (§8).** The merged treatment preserves the direction-reversal
  result: after an intraday trade against the prior mark, A's day-2 VM = **−100, not the
  naive −300**. This forces stored per-position accumulated_cost (C11), now a first-class
  condition rather than an incidental example detail.

- **Decimal arithmetic (§6).** v10.3's decimal-arithmetic requirement is
  superseded-in-improvement by exact-Integer minor units from the Haskell thread (a
  correctness upgrade); noted at the point of supersession.

---

## Compressed (path removed, substance kept)

- **§14 Orchestration and Obligation Liveness** (← v10.3 §14). The Temporal.io vendor
  tutorial (~1233 lines: why-Temporal, retry/timeout config and tables, per-instrument
  workflow code, saga code, task-queue/worker architecture, fan-out code, deterministic-
  replay mechanics, idempotency-chain walkthrough, versioning/ContinueAsNew, team profiles,
  CDM activity-map listing) reduced to a ~3 pp execution-engine-requirements statement.
  **KEPT in full:** the four orchestration requirements, executor-as-activity, the due-event
  scheduler, single-writer concurrency, and the **entire Obligation Liveness subsystem**
  (first-class Obligation, state machine, taxonomy, obligation store as a view over the log,
  P21–P23 + the five-lemma liveness proof, CSA-VM and SBL-substitution worked examples).
  Net ~20 pp removed.

- **App. F CDM Product Model Developer's Guide** (← v10.3 §24, ~1491 lines). Reduced to the
  six-layer hierarchy + unit-identity-crystallisation + three sub-walkthrough RESULTS
  (payout composition + TransferableProduct boundary; tokenized double-counting resolution +
  custodian-is-flat + the four CDM gaps; date-type taxonomy + resolution chain). Dropped the
  exhaustive Rune/CDM code listings and parallel-instrument tables; one worked instance per
  concept. ~12–15 pp removed. Forward references from §1/§3/§13 retained.

- **App. H (GMSLA 2010) and App. I (SEC 15c3-3)** (← v10.3 §26, §27). **Both regimes kept** —
  title transfer ≠ pledge, distinct regulatory correctness witnesses. Prose compressed to
  per-step six-coordinate vectors + conservation lines + the comparison table. ~8 pp removed.

- **§1–§3, §5–§7, §10–§13, §15–§20** (← v10.3 §1–§3, §4–§5, §7, §8–§11, §12–§13, §15–§18,
  §20–§23). Compressed by state-once dedup and path removal: Document Roadmap regenerated
  from the TOC; `src -= q; dst += q` stated once; "every view is a projection" stated once;
  reconciliation taxonomy stated once in App. C (§10 points to it); AAPL CDM narration shared
  between §13 and App. F deduped; the ledger boundary stated once (§1, with §18 carrying the
  full inside/outside lists); invariant statements consolidated into the §15 hub.

- **Satellites (compressed-with-pointer, not re-expanded):** valuation (§5/§10),
  deferred-settlement (§12), market-data (App. D), data (§11/§16) keep v10.3's compressed
  treatment plus a pointer to the standalone spec. Load-bearing results retained:
  Path-Independent PnL (§5), coupon double-count / state-aware pricing (App. D).

- **§19 Conclusion and Open Problems** (← v10.3 §17 + addendum + escalations). Celebratory
  prose pruned; the open-problems agenda kept; concurrency, liveness, and the
  unit-vs-wallet state-attachment question marked RESOLVED (by §14 and §4). Adds the
  consolidated flagged register, kept distinct from the proven algebra.

---

## Removed (path only — no substance lost)

- **Temporal.io vendor tutorial** (v10.3 §14 vendor-specific bulk) — implementation path,
  not specification. The liveness substance it surrounded is kept in §14 (see above).
- **Temporal-for-SBL subsection** (v10.3 §15, ll. 3903–3917) — path; any substance folded
  into §14.
- **Exhaustive Rune/CDM code listings and parallel-instrument tables** (v10.3 §24) — path;
  the results they demonstrated are kept in App. F.
- **Derivation history, rejected alternatives, iteration narrative** throughout — including
  the addendum "Alternatives Considered" Pareto A–F (only the result kept: design B, three
  maps + C1–C12, is the unique Pareto-optimum; with the one forcing reason per rejected
  design). The ordinal score table dropped.
- **Restated/duplicate prose** removed under state-once dedup (enumerated above).

---

## Carried as honest open items (§19 register, not removed)

Addendum risks F1–F8; testing/mutation-score commitments; managed-account escalations E1–E5
+ the Nazarov attestation-envelope finding; futures escalations E1–E2. Stated as a flagged
register, clearly separated from the proven quantity algebra — compressing them to nothing
would overclaim soundness.

---

**Page count: v10.3 ≈ several hundred pp of thread material → v11.0 137 pp** consolidated,
with full Haskell woven in and both SBL examples retained. Advisory budget exceeded by
authorisation (substance wins); no substantive element cut to hit a number.
