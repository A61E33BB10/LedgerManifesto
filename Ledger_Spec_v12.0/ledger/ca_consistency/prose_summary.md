Compiled clean (12 pages standalone; cross-references resolve only in the full document). The draft is at:

**`/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/drafts/sec_basis.tex`**

It is not yet `\input` into `ledger_v12_0.tex`; part placement is the owner's decision (natural home: Part III after `sec07`, or Part IV before `sec13`).

**Structure** (gloss → formal → consequence at each first use): motivating defect (one glossed paragraph); the ruling and the informal invariant; §basis-coordinate (Defs: boundary event; basis point/chain/effective total order/epoch; `usBasis` + `SetBasis` listing; tip weld; invariance weld); §operators (`OpSpec` listing, basis category, Composition Law, 49-vs-50 illustration, Theorem — value invariance with proof, Pending crystallisation, re-derivation canon); §ingest (`ingest`/`StampedObs`, TA-BASIS); §invariant (Invariant B + scope-closure + C13); §types (Tier-1 GADT, Tier-2 skolem seam, unreachability argument, language-fragment proviso); §time-travel (two axes, re-stamp events); §failure (W1–W4 longtable); §worked (2-for-1 split with numbers, dividend and index-divisor fibres); §CDM mapping table (pinned to v6.0.0 per Appendix F); closing `Key Invariants and Consequences` note.

**Change log** (draft vs. the agreed design):
- cut — Parts I and III (adjudication, discharge register, source attributions): committee apparatus, not specification content.
- cut — "why not timestamp / why not fourth home" compressed to one paragraph in the opening; restated nowhere else.
- reordered — Invariant B placed before type enforcement (statement, then mechanism); design had §5 after §4 with a forward reference.
- welds recast as `principle` environments (tip weld, invariance weld, re-derivation canon) per house amsthm usage.
- Theorem given a one-mechanism proof (algebraic identity + weld-as-hypothesis); no repetition of the mechanism in commentary.
- migration list (design §10) omitted: per-section deltas belong to the owning sections; only C13, P24-family oracles, and the protected-elements statement survive, once each, in the closing note.
- active voice and declarative register throughout; epigraph folded into the closing sentence without attribution.
- P-number citations corrected to the hub (`sec15`): booking-order/append-only is P4, replay determinism P8, status idempotence P6, liveness P21; the design's "Property 5 of sec01" cited as the lifecycle value-invariance property of §sec:intro (its `\item` label, not P5, which is transaction idempotency).

**Enforceability and conformance flags** (gaps marked, not filled):
1. **`prec` — the precedence datum's enforceable carrier.** The same-`t_eff` weld requires attested notices to *declare mutual precedence*. No published notice format or standard field carrying such a declaration is named anywhere in the bundle. Needs binding to a specific source (data-governance/market-data agent), or the weld's admission input must be respecified as an internally attested governance record.
2. **`N_CA`.** Stated as `≥ 2, owner: data governance` per the design; the numeric value is an unassigned governance parameter. Return to data governance; the prose deliberately does not fix it.
3. **Datum-kind universe.** `KSpot`, `KComposition`, and `Kind a` are used but no agent has fixed whether the kind set is closed, who declares it, and where it lives (ProductTerms? framework?). The declaration's domain is undefined without it. Subject-matter gap.
4. **`BasisError` enumeration.** The constructor set (only `BasisMismatch` is named, in the worked walk) is unfixed; W1–W3 route on it. Subject-matter gap.
5. **CDM conformance demonstration.** The mapping table asserts correspondences to CDM v6.0.0 constructs (`QuantityChange`, `Transfer`, `TermsChange`, succession); the derivation stands, but conformance against the pinned Rosetta/Rune definitions (Appendix F discipline) is not yet demonstrated — no row is checked against the v6.0.0 event-qualification functions. Return to the CDM agent.
6. **TA-BASIS detection procedure.** "Daily reconciliation of vendor-published adjustment factors against applied declarations" names no factor source or comparison rule. Owner (market-data operations) must specify before the trust-registry entry in sec19 is complete.
7. **`toPrice` / rounding site.** The design fixes round-half-even "once in ProductTerms"; no such field exists in `TermsVersion` or `reference/Ledger.hs` today. Migration owner must add it; the section states the discipline but cannot point at the carrier.
8. **Reference-code status.** All listings are specification signatures, not excerpts from a FORMALIS-cleared `Ledger.hs` — the section carries no clearance remark, deliberately, unlike sec04/appD. The `reference/Ledger.hs` extension (nominal roles, module-header proviso, Tier-1 companion) is outstanding work for the reference owner.