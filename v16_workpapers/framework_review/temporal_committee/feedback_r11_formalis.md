# FORMALIS — ROUND-11 FINAL SIGNATURE (Temporal Committee, Part II)

Remit: verify the five non-blocking folds I carried at r10 landed in the ACTUAL r11 text
(proposal_TEMPORAL-1_r11.md, proposal_TEMPORAL-4_r11.md), then record my final signature. A
signature is on the artifact, never on a promise. Cites are file:line.

## The five folds — verification

1. **prop_noSilentUnderAdmit in the firing harvest, with a near-identical-cut generator.**
   **HOLDS.** T-1 §5 l.183: row present, S4 injectivity/under-admit half of I2; generator = "two
   **fine-grained-distinct** causes with near-identical input-cuts (a too-coarse cut label would
   collapse them to one txid)" → the injectivity guard actually fires. Header l.174-175 pins "11
   properties … both halves of I2". Mirrored T-4 l.23. TuringAward's blocker closed.

2. **prop_sandwichCANInvariant — pre-softening byte-identity over-claim REMOVED.**
   **HOLDS.** T-1 §5 l.185 obligation restated: "pre-admitted leg reproduces **byte-identical by
   read-back** of its durable emission; a re-driven leg is S4-idempotent — no half, no double, value
   β-bounded (not byte-identical)"; CAN injected in **both** positions. The r10 "completed = CAN-free"
   over-claim is gone; body prose l.140-142 now agrees. Mirrored T-4 l.29.

3. **prop_clockSkewInvariant — "recorded three-times unchanged" over-claim REMOVED.**
   **HOLDS.** T-1 §5 l.188: "{admitted set, fold result, execution+monitor times} invariant;
   door-order invariant **up to commuting same-execution-time transposition**; a skewed timer fire
   yields the identical txid; skew never changes a recorded time by type." Fold-order (exec,door,hash)
   preserved; the commuting-pair leak is now inside the obligation. Mirrored T-4 l.28.

4. **prop_fabricatedTxidRefusedOrAudited — VALUE-CORRUPTED audit generator.**
   **HOLDS.** T-1 §5 l.186: two generators — "(ii) **structurally-valid, txid-consistent,
   value-corrupted** (real logged cause, wrong value) → audit-caught (D7) — so the audit branch
   actually fires, never silent." T-4 l.31: "The generator MUST include the value-corrupted case, else
   the audit disjunct passes on 'refused' alone." Zero-firing closed.

5. **Complete harvest in BOTH T-1 and T-4; canonical 3-tuple, no residual 4-tuple.**
   **HOLDS.** T-1 §5 = 11 properties incl. prop_exactlyOnceAdmission (l.182) + prop_gateStateAtomic
   (l.184). T-4 §1 = 11 rows incl. both (l.22, l.24) — the r9 omission is repaired. Key = clean
   3-tuple `(input-cut, model-version, recipe/dynamic-version)`, seed+env OUT of identity (T-1
   l.28-37/l.167; T-4 l.9-12); every "4-tuple"/"seed slot" occurrence is a **negation** — no positive
   4-tuple survives.

## Guarantee-preservation check
All five edits are witness/harvest-only (T-1 l.5-6; T-4 l.3), reopening no design decision. The
architecture guarantees I blessed at r10 — S1–S7 reduced to I1–I4 + S4 + COVERAGE-β, the value-level
bound by construction, key-arity resolved — are untouched. Softening three obligations to what
actually holds (read-back, fold-order-up-to-commuting-transposition, audit-on-value-corruption) and
completing the set **strengthens** the harvest against zero-firing; it breaks nothing proven.

---

## FORMALIS FINAL CONSENSUS SIGNATURE: **YES**

I, FORMALIS, **SIGN** proposal_TEMPORAL-1_r11.md (with its T-4 witness companion) as the final
Pareto-consensus design. Justification: all five carried folds landed verbatim in the r11 artifacts,
each closing a §3 zero-firing or over-claim without touching a proven guarantee — no rigor defect
remains open.
