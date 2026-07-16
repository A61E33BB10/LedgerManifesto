---
name: spec-coverage-gate
description: Where the Ledger v11.0 completeness contract lives and the clarity gate conditions
metadata:
  type: reference
---

Coverage map (completeness contract, SIGNED): `/home/renaud/Ledger/Ledger_Spec_v11.0/ledger/coverage_map.md`. Reference Haskell: `/home/renaud/Ledger/Ledger_Spec_v11.0/ledger/reference/Ledger.hs`; per-section snippets `/home/renaud/Ledger/Ledger_Spec_v11.0/ledger/drafts/hs/<id>.hs`.

**STYLUS gate (clarity, necessary condition):** every concept defined before use; every categorical term glossed in plain words at first use; UnitStatus canonical wording verbatim at every discipline site; prose deductive and easy to follow.

**Termination gate:** minsky AND jane-street-cto both comfortable document COMPLETE; formalis confirms correctness/reproducibility.

Verified strong (Round 1): §15 is the one invariants hub (P1-P10, P11-P20, P21-P23, C1-C12 + discharge map with mechanism glosses); §9 Segregation theorem = CONS ∧ LOC ∧ C4 (not conservation alone); §8 futures merge keeps VM=-100 intraday result + C11; §14 keeps liveness P21-P23 after Temporal cut; appF keeps crystallisation + tokenized double-count + custodian-flat + 4 gaps.
