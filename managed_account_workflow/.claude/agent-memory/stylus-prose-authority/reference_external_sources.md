---
name: external-sources-and-pinning-gaps
description: Pinned external citations in managed_account_workflow.tex and the standing CDM version-pinning gap to route
metadata:
  type: reference
---

External sources already cited in `managed_account_workflow.tex` §[sec:conformance] and body, treated as enforceable checkpoints (derive-then-conform order):
- IAS 32.42 / ASC 210-20 (net presentation / right of set-off)
- MiFID II Annex I §A(4) (portfolio-management service); MiFID II 16(8) and CASS 6 (segregation)
- ISO-17442 (LEI); CPMI-IOSCO and EU Art 7 (UTI generation waterfall); EMIR/CFTC/SFTR (reporting)
- FINOS CDM strata: LegalAgreement, Trade, TotalReturnSwap, TradeState, BusinessEvent; ISDA Create

**Standing enforceability gap to route, not fix:** CDM references are unpinned to a named release (e.g. CDM 6.x). STYLUS must not invent a version. Flag to rosetta-cdm-engineer to pin the CDM version the mapping targets. Regulation citations are at article/section level but undated; the regulatory-reporter should confirm whether a dated version is required for enforceability.

**No market-practice appeals present.** The document contains no "market practice", "typically", "commonly", "most desks", or time-bound "as of" claims. The only borderline is §[sec:fees] "the internal desk case, where a book is swept to Treasury" — a contrast to a framework-internal handling (Treasury sweep), not a custom appeal; relies on the main spec defining that case.
