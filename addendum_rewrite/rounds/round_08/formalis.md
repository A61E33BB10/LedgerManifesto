# FORMALIS scorecard — Round 8

**Lens:** Correctness preservation (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-of-10 unreachable
claim in `CORRECTNESS_CHECKLIST.md` must be present and unweakened in
`addendum_stateshome_v2.tex`. Any drop or weakening ⇒ F.

**Verdict: A — 92%.** Correctness fully preserved. No item dropped, no claim weakened. I stake
my lens on it.

## Checklist trace (all present, each ≥ as strong)

| Item | Where in v2 | Status |
|---|---|---|
| 1. Three maps + WalletRegistry NOT state; no W-sector | §3 (156–181) | preserved |
| 2. C1 Option accessor + monotone, orthogonal, both | §4.1 (284–298) | preserved |
| 3. C2 handler-level conservation, per-class, vacuous base | §4.1 (254–266) | preserved |
| C1–C12 | see below | all preserved |
| 5. Three keys / home of each datum | §3 table (184–201) | preserved |
| 6. Four test cases | §5 (218–520) | preserved |
| 7. Pareto A–F + forcing reasons | §10 (626–661) | preserved |
| 8. Why exactly three (i)(ii)(iii) | §8 (568–585) | preserved |
| 9. P1,P3,P5,P6,P7,P9,P10 unreachable (7/10) | §11 (678–706) | preserved |
| 10. Mutation scores, TLC bounds, generator universe | §12 (716–729) | preserved |
| 11. F1–F8 + (F2,F5,F6) external | §14 (743–780) | preserved |
| 12. v10.3 1034/2287 + additive-then-swap alias | §9 (592–613) | preserved |
| 13. One-sentence answer | §16 (825–830) | preserved |
| Ref note: Haskell, total, illegal-states-unrep. | §15 + StatesHome.hs | preserved |

C1 (284), C2 (254), C3 (424), C4 (442), C5 (473), C6 (511), C7 (468), C8 (516), C9 (483),
C10 (491), C11 (305), C12 (355) — each defined once, each retaining its full content.

## Five places the rewrite changed phrasing — each examined for weakening, none found

1. **C3 "across all three maps" → "for a single unit, applied as a group fold for multi-unit
   events" (424–435, 495–504).** Not a weakening. The original's "one atomic StateDelta" for a
   rebalance trading ES/NQ/YM, and for an amendment moving `(w,u_old)→(w,u_new)`, was
   imprecise: conservation `Σ_w Δf(w,u)=0` is a *per-unit* law, so a single delta cannot
   conserve across distinct units. v2 decomposes into one validated delta per unit + group
   all-or-nothing (burn/mint each conserving on its own unit). Group atomicity holds by purity
   of `replay = foldM` (intermediate ledgers are values; only `Right` is committed) — verified
   in the reference. The reader-facing guarantee ("never observe one applied and another not",
   422) is explicit. This is a correction that *strengthens* the conservation account.

2. **C1 `Some(zero)` → `Some(p)` flat with `0_P` defined (129–131, 284–290).** The
   None-vs-Some distinction ("never held" vs "held and flat", both load-bearing, never
   collapsed) is intact. v2 only adds that a flat row may retain a non-conserved field
   (crystallised hwm / entry_nav), so flat ≠ `0_P`. Enrichment, not loss.

3. **C11 "unique handler" → "canonical writer set; type error at authorship, erased at the
   row" (305–317, signal S3).** The original itself listed `ac→settle/trade` (two handlers),
   so "unique" was already a set; v2 names it correctly and separates the field-writer axis
   from the C2 event-class axis. The genuine guarantee — no field-writer can *author* an
   out-of-set write (type error) — is preserved at the authorship site where writes are built.
   "Erased at the row" is an honest statement that the homogeneous row map is type-erased
   (always true), not a surrendered guarantee. P10 still made unreachable.

4. **§11 "structurally unreachable" reframed as "unrepresentable, in a precise sense; P1
   conservation is a value-level check (signal S4)" (664–706).** This removes a latent
   internal contradiction in the original (it claimed P1 structurally unreachable while C2/§3
   admit refinement types on decimal sums are not free). The mechanism is now named per
   invariant (smart constructor for P1, NonEmpty for P6, authorship tag for P10). The **count
   7/10 is preserved**, each P still bound to its discharging conditions, and "no other
   candidate exceeds 3" retained (706). Honest precisification, not weakening.

5. **Reference switched Python(float) → Haskell(exact integer minor units).** The original
   Python `ac: float` silently violated determinism (Principle 4 / P3); v2's `Qty` exact
   arithmetic makes determinism and conservation arithmetic facts (790, notation 105–107).
   Strengthening. Reference verified to encode: three maps (`ledgerPT/US/PS`), `ValidDelta`
   abstract w/ sole constructor `validate` (C2), `applyDelta` all-or-nothing (C3),
   `appendVersion` on `NonEmpty` (C6), `register`→`ReRegistration` (C10), `amend`
   Preserving/Breaking (C8), `position :: Maybe` (C1). Core API total (the one `error` at L494
   is a test-harness `expect`, outside the exported library).

## Determinism / totality / conservation spot-checks
- P3 stated as a fold homomorphism `replay (xs<>ys) = replay xs >=> replay ys` with `>=>`
  explained (682–690) — same claim as original, made explicit.
- Conservation carries the finiteness qualifier `h(w,u)=0 for all but finitely many w` (107),
  so `Σ_w` is well-defined.
- C9 dividend/`len(holders)` bug class retained and explained (487–488).
- Vacuous base case present in C2 (264) and in reference (`mempty` empty fold).

## Non-veto observations (other lenses' call, not mine)
- New `balance` second conserved field is an *addition* (not in original). Justified and fenced
  ("not an economic datum of the schema", 203–205); load-bearing for the C11 demonstration
  (need ≥2 distinct-writer fields). No correctness property weakened; flag for minimalism lens.
- Iteration-log table and "27 rounds" provenance dropped to a one-line closing note. Outside my
  scope (not an invariant/condition/forcing-reason/risk/unreachable claim). Provenance lens may
  weigh it.

## Why A and not below
Every veto-scoped item survives unweakened; the five rephrasings are corrections or honest
precisifications that preserve (and in three cases strengthen) the correctness account. The
formal content is stated once, in deductive order, with nothing cryptic in my domain and
nothing cuttable without loss of a correctness guarantee. Bar met.
