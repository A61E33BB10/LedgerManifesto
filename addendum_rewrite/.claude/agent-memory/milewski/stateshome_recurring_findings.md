---
name: stateshome-recurring-findings
description: Recurring expressibility findings and their resolutions across StatesHome review rounds (milewski lens)
metadata:
  type: project
---

Expressibility-lens review history for the StatesHome addendum. My grade trajectory:
Round 1 = B (84%), Round 2 = B (88%), Round 3 = B (89%), Round 4 = A (90%), Round 5 = A (91%),
Round 6 = A (92%), Round 7 = A (93%), Round 8 = A (93%, held), Round 9 = A (93%, held),
Round 10 = A (95%, bumped).

Round 10: the P5 residual that capped me at 93% for rounds 7-9 is RESOLVED. P5 gloss
(tex lines 691-699) now attributes lifecycle idempotency to UnitStatus[u] replacement
(EXPIRED over EXPIRED = EXPIRED), notes the untraded path touches no PositionState row
(consistent with sec:untraded), hwm by max / entryNav write-once, and additive ac/balance
draw replay-safety from P1 (conservation) NOT replacement -- exactly the canonical fix I
named. No C11 in the P5 gloss anymore. No regressions: grep confirms zero antihomo; group
homo lands at mempty; replay Kleisli/monoid homo via foldM/>=>; NonEmpty/Maybe intact;
S1-S4 honesty intact; migration pair + position(w,u) clean; balance reconciliation stable.
No blocking issues; staked the lens.

Round 9: no regressions, no new defects. All categorical labels re-verified (group homo
landing at mempty; replay Kleisli/monoid homo via foldM/>=>, grep confirms zero antihomo;
NonEmpty; Maybe accessor). S1-S4 honesty intact; migration pair + position(w,u) clean; balance
reconciliation stable. HELD at 93% on the SAME unfixed residual as rounds 7-8: **P5 gloss
(tex lines 691-692) cites "(w,u)-keyed row + C11"** for lifecycle idempotency. Now sharpened
the finding: this directly CONTRADICTS sec:untraded (lines 479-481), which says lifecycle runs
"entirely through UnitStatus, creating no PositionState row" — so the canonical path touches
neither a (w,u) row nor a C11 field. Non-blocking (caps, not fails). Canonical fix unchanged:
attribute P5 to UnitStatus[u] replacement + hwm(max)/entryNav(write-once), contrast additive
ac/balance under P1; drop the (w,u)+C11 attribution.

Round 8: no regressions, no new defects. All categorical labels re-verified correct (group
homomorphism landing at mempty; replay Kleisli/monoid homomorphism via foldM/>=>, grep
confirms zero "antihomo"; NonEmpty; Maybe accessor). S3/S4 honesty intact; migration pair +
position(w,u) still clean. HELD at 93% (not bumped) because round-7's sole residual is
UNFIXED and unchanged: **P5 gloss (tex lines 691-692) still attributes lifecycle idempotency
to "(w,u) row + C11"** — wrong axis (unit lifecycle = UnitStatus[u] replacement; C11 governs
PositionState field-writers). True claim, mismatched mechanism. Non-blocking (caps score, not
fails bar). Canonical fix unchanged: attribute P5 to UnitStatus replacement + hwm(max)/
entryNav(write-once), contrast with additive ac/balance under P1; not C11.

Round 7: round-6 sole non-blocker RESOLVED — the P5 "dedup" vs "structural" inconsistency is
gone; both the §11 P5 gloss (line 690-693) and the §12 cross-reference (line 718-723) now say
"structural", and the substance is defensible (lifecycle = UnitStatus replacement / hwm max /
entryNav write-once, all idempotent; additive WAc/WBalance are conserved under P1, not P5). No
regressions; all categorical labels verified correct again (replay monoid homomorphism via
foldM/>=>, NOT anti; conservation group homomorphism landing at mempty; NonEmpty; Maybe
accessor). S1-S4 honesty intact. New residual non-blocker (did NOT hold off A): **P5 mechanism
citation is off-axis** — the gloss attributes lifecycle idempotency to "single (w,u) row +
C11", but unit lifecycle lives in UnitStatus[u] (idempotent by replacement) and C11 governs
PositionState field-writers, not UnitStatus. Claim is true, attributed mechanism imprecise.
Canonical fix if §11 reopened: attribute P5 to UnitStatus replacement (+ hwm max / entryNav
write-once for per-position OTC lifecycle), contrast with additive conserved fields under P1;
not C11 (wrong axis for unit-level lifecycle).

Round 6: round-5 sole non-blocker RESOLVED — paragraph header (line 300) now "A canonical
writer set per field." (was "One writer per field." while ac has two writers). No regressions;
all categorical labels correct (group homomorphism landing at identity; replay Kleisli/monoid
homomorphism, no antihomomorphism); validate/ValidDelta value-level honesty (S4) intact; C11
authorship-vs-erased honesty (S3) intact; axis divergence stated. New non-blocker noted (not
holding off A): **P5 idempotency "dedup" vs "structural" wobble.** Line 692 gloss says single
(w,u) row + C11 "make idempotency a per-key dedup"; line 722 says "P5, whose idempotency is
structural." Tension: status/hwm(max)/entryNav(write-once) are replacement-idempotent (no dedup
needed); additive WAc/WBalance (psAc <> q) are NOT idempotent and would need event dedup the
reference doesn't implement. Defensible if P5 read strictly as lifecycle/status events, but P5
is the murkiest of the seven on one pass. Canonical fix if §10 reopened: "replacement-idempotent
at a single key; additive fields are conserved, not idempotent." Pre-existing, not a regression.

Round 5: both round-4 cosmetic non-blockers RESOLVED. (i) Migration line 615 now reads
`position(w,u)` — phantom `position_state` token gone. (ii) C11 (lines 307-319) now "the
canonical writer SET --- the closed set of field-writers: ac->settle/trade"; the "unique/
one canonical" overstatement is gone and matches the GADT (WAc 'Settle, WAcTrade 'Trade).
No regressions, no new defect; categorical labels all correct. Awarded A (91%). Sole
recorded non-blocker: paragraph header "One writer per field." (line 302) still says "One"
while ac has two writers; body's first sentence corrects in place — header label only.

Round 4: round-3 `++` blocker RESOLVED (migration line now the pair
`(product_terms(u), unit_status(u))`, not list-concat on two Maybes). Awarded A.

Recurring finding classes (watch for these):

1. **Prose over-claims the encoding.** Round 1 R1: amend "emits atomic re-subscription" — it
   doesn't (paired issuance is a separate event, S1). Round 1 R2: C11 claimed as type-level /
   "structurally unrepresentable" when it is authorship-only and erased at the row.
   Resolution that satisfies me: soften prose to match what the code delivers, cite the
   relevant Expressibility Signal (S1-S4). Both fixed by round 2.

2. **Vocabulary divergence tex vs reference.** C2 event classes (Trade, SettleVM,
   CorporateAction, QISRebalance, MandateAmend) vs C11 `Handler` field-writers (Settle, Trade,
   Transfer, FeeCrystallise, Subscribe) are DIFFERENT axes. Must be stated explicitly.
   Fixed in round 2 (C11 paragraph says so).

3. **Reference carries state the spec inventory omits.** `psBalance`/`Transfer`: a conserved
   field present in the .hs and now in the notation table, but NOT in the §3 "home of each
   datum" table, and never reconciled with the framework holding `h(w,u)`. Was issue B5.
   RESOLVED in round 3: notation table (lines 122-127) declares balance a *demonstrative*
   second conserved field (canonical writer = transfer, distinct from ac), explicitly "neither
   h(w,u) nor an economic datum of the §3 inventory"; §3 (lines 203-205) excludes it on the
   same grounds. This was exactly the canonical fix I'd named.

5. **`++` between two record-typed Maybes (NEW, round 3, sole blocker).** Migration line 611:
   `get_unit_state(u)` aliased to `product_terms(u) ++ unit_status(u)`. `++` is Haskell list
   concat; the two operands are `Maybe ProductTerms` / `Maybe UnitStatus` — type-incorrect in a
   Haskell-anchored doc. Fix: a pair or prose. The one expressibility defect in my exact domain
   holding round 3 off A. Also still: tex names `position_state(w,u)` where reference exports
   `position` (migration-paragraph drift, non-blocking).

Round-3 confirmations: categorical labels all correct ("homomorphism", no "antihomomorphism");
C11 prose honest (authorship-only/erased-at-row, axis divergence stated); replay homomorphism
law correct and genuinely satisfied by `foldM applyDelta`.

4. **Categorical mislabels in my own domain.** Round 2: replay law called "(anti)homomorphism"
   in a .hs comment — it is a plain homomorphism. I flag these as blocking because the
   categorical name is exactly what my lens owns. Trivial to fix; corrosive if left.

Carryover non-blockers: §7 "encoding carries the conditions" silently omits C4 (read-scoping
is a capability/Reader concern, S2 — correct call, just say it) and C12; migration prose uses
`++` across two record types and names `position_state` where the reference exports `position`.

See [[stateshome-representation]] for the settled design.
