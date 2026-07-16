# FORMALIS scorecard — Round 4 — `addendum_stateshome_v2.tex`

Lens: **CORRECTNESS PRESERVATION (veto).** Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-unreachable claim
must remain present and unweakened. Verified line by line against
`CORRECTNESS_CHECKLIST.md`, `_original_addendum.tex`, and `reference/StatesHome.hs`.

## Grade: A (93%)

The rewrite preserves the full correctness payload, and in three places makes it *more*
rigorous than the original without dropping or weakening any claim. I stake my veto on it.

## Checklist verification (all present, each as strong)

**§1 Ruling** — three maps with totality/mutation discipline (155–159); WalletRegistry
sidecar explicitly NOT state (168–174); no W-sector, every per-wallet economic fact
(w,u_MA)-keyed (176–181). PASS.

**§2 C1 two orthogonal disciplines** — Option accessor None vs Some(flat), both load-bearing
(VM-settle, wash-sale, record-date), never collapsed; monotone carrier ⇒ replay literal fold,
stable key set; orthogonality + both-required stated (284–298). PASS. The added note that a
flat row need not be 0_P (may retain a non-conserved field) is an enrichment, not a weakening.

**§3 C2 handler-level conservation** — Σ_w Δf(w,u)=0 structurally per event class; the five
handler classes named; 2-leg / K-leg / VM-fan-out / vacuous base cases all present; induction
to global invariant (254–266). PASS.

**§4 C1–C12** — all twelve defined, each as strong:
- C1 (284), C2 (254), C3 atomic across the three maps, partial application unrepresentable
  (423–427), C4 (441), C5 (472), C6 (510), C7 (467), C8 (515), C9 incl. dividend/len(holders)
  bug class (482–487), C10 (490), C11 with ac→settle/trade preserved (305–316), C12 (354).
- C11 adds the field-writer-vs-event-class axis distinction and `balance→transfer`: an
  addition for illustration, not a removal. `ac→settle/trade` intact. PASS.

**§5 three keys / home of each datum** — full inventory in all three rows (184–201). PASS.

**§6 four test cases:**
- Future: distinct CME/ICE units, ac conserved by handler, first_touch_date NOT state
  (fold-inconsistency under back-dating), settled rows retained (218–282). PASS.
- Managed account: mandate-is-unit issuance ±1, full relocation table, not the Dirac sentinel,
  two-mandate→two-rows (318–372). PASS.
- QIS: five keyings no two in one map, HWM at PS[w_C,u_QIS] with two-strategies⇒two-HWMs
  argument, atomic rebalance, wind-down rows retained (374–450). PASS.
- Untraded: PT present (C7), US total with defaults (C5), PS None (C1), WalletRegistry
  unaffected, lifecycle totality, vacuous C9, two-track C8 with the total typed predicate
  (452–519). PASS.

**§7 Pareto A–F forcing reasons** — B unique optimum under gate ≥7, dominates A/C/D/F, dominates
E; each rejected design's one forcing reason stated in words (614–660). PASS.
- E is reframed from "Grothendieck sheaf on H_t" to "state indexed only over the held set
  {(w,u): position=Some}". This is the same object (sheaf over the held subset), scores
  preserved (8/9/2), forcing reason preserved ("no implementation in available tooling" =
  "sheaf generators need non-existent libraries"). Clarity gain, no correctness loss.
- F: "Minsky denormalisation trap" label dropped; its substance ("a carve-out, not a rule")
  is preserved verbatim in meaning (653). Label is provenance, not a correctness claim.

**§8 why exactly three maps** — three independent forcing constraints (i)/(ii)/(iii); removing
any breaks one; fourth is economically empty; minimum basis not compromise (559–584). PASS.

**§9 seven unreachable invariants** — P1, P3, P5, P6, P7, P9, P10 all present with mechanism and
discharging conditions; "no other candidate exceeds three" preserved (662–704). PASS.
- **Scrutinised hardest:** the original listed P1 (conservation) as "structurally unreachable"
  while *also* (in its own C2) conceding conservation cannot be a type fact — an internal
  tension. v2 resolves this honestly: P1 stays in the seven, but the gloss states the
  mechanism precisely — `ValidDelta` is abstract, its only constructor `validate` discharges
  the zero-sum, so an unconserved delta **cannot reach `applyDelta`** (illegal state
  unreachable by construction), while the check itself is value-level (signal S4). This
  **preserves** the count and the unreachability claim and removes an overclaim. Not a
  weakening — a strengthening of rigour. Confirmed against `reference/StatesHome.hs` lines
  280–294, 348–366: the abstract type + smart-constructor gate is real.

**§10 quantitative commitments** — 85–90% / 70–80% / ≥80% Feathers; |W|=3,|U|=2,depth≤6,
10^5–10^6 states TLC-tractable, violations caught at depth 1; finite enumerable generator
universe (706–727). PASS, numbers unchanged.

**§11 risk register F1–F8** — all eight with mitigations; F2/F5/F6 flagged external-before-code
(729–778). PASS. F5 mandate-as-unit SFTR/EMIR surface intact.

**§12 effect on v10.3** — supersedes line 1034 and 2287; replacement text; additive-then-swap
get_unit_state alias to (product_terms, unit_status); (w,u)→position_state (586–612). PASS.

**§13 one-sentence answer** — substance preserved; Pareto-optimal, minimum basis (819–831).
PASS.

**Reference note** — `reference/StatesHome.hs` exists (573 lines), Haskell replacing Python (as
the checklist sanctions). Verified it encodes: three maps with abstract Ledger and no PS
deleter (monotone C1); `ValidDelta` abstract with sole constructor `validate` (C2);
`ProductTerms` abstract NonEmpty with register/appendVersion only (C6/C7); `FieldWrite` GADT =
C11 table with `_c11_ok_*` plus commented `_c11_bad`; `applyDelta` all-or-nothing (C3);
`register` rejects re-registration (C10); `amend` two-track (C8). Integer minor units replace
float — a determinism/conservation **improvement**. Signals S1–S4 in the .hs are the ones the
.tex cites. The .tex's structural claims about the reference are all true.

## Substantive changes examined and cleared (none weaken correctness)

1. **C3 made per-unit; multi-unit events are groups applied all-or-nothing.** Original loosely
   called a multi-unit rebalance "one atomic StateDelta." v2 (423–434, signal S1) defines a
   StateDelta per unit and composes per-unit conservation to event-level, applied as one fold.
   This is *required* for per-unit Σ=0 to be well-defined; atomicity ("reader never observes
   one applied and another not") preserved. Strengthening.
2. **Breaking-amendment move decomposed into burn+mint paired issuance.** Original implied a
   single cross-unit re-subscription StateDelta; that cannot satisfy per-unit conservation.
   v2 (500–503, S1) makes it a burn on u_old + mint on u_new, each conserving, applied
   together. Σ_w preserved per unit; C8 predicate unchanged. Strengthening.
3. **P1 "unrepresentable" honesty caveat** — analysed above; preserves the seven-count.

## Dropped material that is NOT a correctness item (so not a regression)

- The full Iteration Log table and "27 rounds" framing (original §11): provenance, not a
  correctness claim; compressed into the closing note. The checklist lists no item for it.
- HWM tie-break attribution to correctness-architect+formalis: provenance; the substantive
  argument (two strategies ⇒ two HWMs) is preserved (408–412).

## Blocking issues

None. No invariant, determinism/totality claim, condition C1–C12, forcing reason, F-risk,
quantitative number, or the seven-unreachable claim is dropped or weakened.
