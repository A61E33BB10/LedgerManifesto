# TuringAward — Temporal Committee Referee Feedback, Round 3

Role: standing referee, architecture judgment + convergence steering + Constitution §4 anti-bias. Advisory,
no veto. This round: Part 1 certifies the R2 forks/items resolved and the assembly minimal; Part 2 tees up
the red-team. Lenses: L1 (liveness under refold/failover), L2 (write atomicity, exactly-once admission),
L3 (the pinned-cut invariant, termination), L5 (three record kinds, enforcement-locus placement), L6
(minimalism — what to delete), L7 (door backpressure), touching L8/L9. Active design files: TEMPORAL-1
(assembly) and TEMPORAL-4 (catalogue); T-2/T-3/T-5 are merge declarations, now reviewers/voters.

**Round 3 of ≥10. No consensus declared.** The one open item below is a placement seam, not an open
correctness fork; the architecture is **ready for red-team**.

---

## PART 1 — Convergence certification

### C1 — Fork A′ → FLAG in both T-1 and T-4; refuse-mode reserved. **RESOLVED.**
T-4's D15 flipped: headline l.10 "**D15 flips REFUSE → FLAG**"; D15 l.115 "a base moved under the cut
**FLAGS m\* stale-forward** … **not refused** … Refusal belongs ONLY to a gate fail/undecidable verdict
or an unresolvable structural reference." T-1 §2.2 l.76 matches verbatim ("Refuse is reserved for a gate
fail/undecidable verdict … or an unresolvable structural reference — never a fresher tip"). Merged
reviewers concur: T-2 §1 ("I take the FLAG side … explicitly"), T-3 §1 ("I **retract** R2 §2b"), T-5 A′.
Livelock proof (90 s model / 45 s corrections) carried in all three. The refuse pole is dead.

### C2 — Scope boundary, one voice. **RESOLVED.**
Stated identically across the set: T-1 §3 "Bit-reproducibility is **never** a door/admission precondition
(out-of-scope numerics, C-Scope.11)"; T-4 D14 "**NEVER an admission precondition**"; T-3 §3; T-5 Fix 1
retracts §3(b)'s "admission-time contract" phrasing. The env-version pin is Tier-2 governance-optional,
caught at audit. The §1-narrowing guard ("dispute-readiness must not quietly become an admission gate")
appears in T-1, T-3, T-5. No dissent. One voice achieved.

### C3 — Determinism actor boundary. **RESOLVED.**
Compute/emit split PRIMARY ("the race is structurally removed, not reduced", T-1 §3; T-4 D14; T-5; T-3 §2
retracts the vendor-print analogy). Env-pin Tier-2, content-hash OPTIONAL diagnostic. Actor boundary stated
cleanly: substrate never compares payloads; door *may* record a content-hash without changing the canonical
value (still first-admitted). "Never compare" (substrate) and "record a hash" (door) are different actors —
no contradiction. See minimalism note M2 for one over-build to watch here.

### C4 — Value-level spread bound tied to VM-6 via a door-checkable class. **RESOLVED in substance; OPEN on enforcement locus (a seam).**
All five tie the admissible spread to VM-6 via a producer-attested reproducibility class, model-free. But
the folds left a genuine split on **where the `ε_repro ≤ VM-6` comparison happens**. T-1 §3 l.150 puts it
at the **door** ("a … door predicate: the attested bound ε_repro ≤ the instrument's declared VM-6 residual
tolerance — the door compares two recorded numbers"). T-5 l.72–82 puts **presence** at the door and the
`τ ≤ VM-6` comparison at **consumption** (a VM-7 broken-chain projection). Counterexample forcing T-5's
placement: one calibrated surface serves unit A (tight VM-6 τ) and unit B (loose τ) — VM-6 tolerance is the
**consuming** instrument's, unknown at admission and not single-valued, so the door cannot evaluate "≤ the
instrument's tolerance." T-1 is also internally inconsistent: its own three-loci table (§2.3 l.108) already
places "residual over bound / staled leaf" at the **valuation projection (VM-7)**, not the door. Resolve to
T-5's split (door = presence check; consumption projection = `τ`-vs-VM-6, VM-7 on fail). Outcomes are
identical (admit + VM-7 flag; never a refusal — A′-consistent), so this is a placement seam, not a
correctness fork.

### C5 — Three record kinds throughout. **RESOLVED.**
Projection (kind-1) / re-entered observation (kind-2) / recorded-decision-pinned-as-known (kind-3) carried
consistently: T-1 l.5–12, T-4 l.24–29, and T-5 Fix 2 explicitly corrects its r2 "two" → "three." Kind-3 is
correctly named as an existing shape (the door's admit/refuse, spec l.1051), not a new primitive — this is
load-bearing for the A′ FLAG argument (m\* state = kind-2 staleable; decision = kind-3 pinned) and it holds.

### C6 — §4 anti-bias. **PASS.**
No document introduces anything categorically first; no proof leans on a functor, adjunction, or box; no
commutative diagram anywhere. "Projection, pinned cut, refold, staleness, compute/emit split, reproducibility
class" are ordinary terms, each with a concrete example (the 90 s/45 s livelock; the `{P₁,P₂}` spread).
Nothing to flag.

### Minimalism note
- **M1 (the seam — act on it).** The value-level bound (C4) is the one place the folds left a seam: T-1's
  §3 "door compares ε_repro ≤ VM-6" contradicts T-1's own three-loci table and T-5's presence/consumption
  split. **Delete the door-side ε-vs-VM-6 comparison.** Keep the door's job minimal and A′-consistent
  (structural presence check only); let the consumption-time valuation projection compare `τ` against the
  *consuming* instrument's VM-6 tolerance and raise VM-7. This removes a mis-parameterised check the door
  cannot correctly evaluate, and aligns the merged artifact with its own loci table.
- **M2 (over-build to resolve, not yet delete).** The design says the compute/emit split "**structurally
  removes**" the race (T-1 §3) yet keeps a content-hash diagnostic for "a buggy **fused** worker" (T-5
  l.95, T-4 D14). These cannot both be fully true: if the fused worker is *representable*, the race is
  removed only by **convention** and the diagnostic earns its keep; if it is *unrepresentable* (the propose
  activity's only input is the compute activity's recorded output — a typed boundary, per CLAUDE.md §3
  "illegal states are not representable"), the race is removed by **construction** and the diagnostic guards
  nothing and should be deleted. Pick one. Preferred: make the fused worker unrepresentable, then delete the
  content-hash. Until the committee picks, the two claims sit in mild tension. Not a blocker.
- **Otherwise coherent.** The folds are clean: idempotence key (T-2), two-tier determinism + versioning axes
  + Fork-B split (T-3), compute/emit + env-version + loci table + A′ (T-5) each appear once, in deductive
  order, no duplication, no backsliding on the spine, Forks A/B/C/D, or the namespace seam. The soft-sixth
  models/derivation queue is correctly parked as load-gated (Fork C), not over-built. Merged T-1 is a single
  coherent design save the M1 seam.

**Certification.** Convergence **certified** with one seam (M1) flagged for the assembly to close. The seam
does not reopen any correctness fork and both placements yield identical admission outcomes, so it runs in
parallel with the red-team. Route the exact `C-11.3`-vs-`MD-8` and `VM-6`-vs-`ε_repro` clause readings to
CONCORDIA/FORMALIS for the certifying signature, as all five request. **Architecture ready for red-team.**

---

## PART 2 — Red-team plan (rounds 4–9)

The design converged early; rounds 4–10 harden it. Each scenario names the **one property the committee must
show survives** — a property, not a paragraph, that the property-test regime must witness *firing* (CLAUDE.md
§3: zero firings is a defect). I pick the two that attack the two most load-bearing invariants under the two
nastiest failure modes: the **forward-only refold** (the single writer's core, on which A′ FLAG's progress
rests) and the **gate+state door atomicity** (Fork A, the design's strongest safety claim).

### Round 4 — the two sharpest

**S1 — mid-refold worker crash. Property REFOLD-ATOMIC (safety+liveness, L1/L3/L2).**
*Show: the forward-only refold is crash-atomic and idempotent — a worker crash at any point during a refold,
on recovery, resumes strictly forward from the log with (a) no admitted transaction duplicated, (b) no
past-dated firing synthesised twice, (c) no rewind of an already-committed order.* This is the invariant the
design leans on hardest: T-1 D3 "past-dated synthesis is the single writer's work; on refold the unit is
signalled-to-re-read, re-fires **forward** only," and A′ FLAG turns entirely on "the single writer decides
this **on the refold**." If a crash mid-refold can double-apply or rewind, both staleness propagation and
A′'s progress guarantee break. Sharpest because it attacks the mechanism the largest number of settled
claims depend on. The exactly-once-admission idempotence key (D10) is the tool; the red-team must show it
holds *across the crash boundary*, not just under retry.

**S7 — namespace failover mid-gate. Property GATE-STATE-ATOMIC (safety, L1/L2/L3).**
*Show: no failover during gate evaluation can admit an ungated state or a state bearing only one of the two
verdicts — because the derived state and its passing verdict cross the door as ONE transaction over ONE
pinned cut (MD-12), a failover **before** that commit leaves nothing admitted (re-pin, re-run, no orphan),
and **after** it leaves the atomic {state, verdict} pair; there is no window in which an ungated or
half-verdict state is nameable.* This directly attacks Fork A — "No window where an ungated state exists …
an ungated state is unnameable" (T-1 §2.2) — the single most load-bearing safety invariant, under
infrastructure failure landing exactly in the `gate1 / gate2 / construct / propose` sequence. Sharpest
safety attack: it tests whether the atomicity is real (one door transaction) or merely sequential-and-hoped.

These two are complementary: one crash-recovery on the **writer's refold**, one failover on the **door's
atomic admit** — the two crown-jewel invariants, each under its worst failure mode.

### Rounds 5–9 — ordering of the remaining five (sharpness descending)

- **Round 5 — S4 retry storm at the one door.** Property EXACTLY-ONCE-UNDER-LOAD: the cause-derived-txid
  dedup admits each distinct fact exactly once and drops none; the storm degrades throughput but the door
  never blocks, drop-silently, or lies (L7 backpressure bounded). Tests the claim "dedup is optimisation,
  never load-bearing" (D10) — does correctness secretly depend on dedup timing at the single chokepoint?
- **Round 6 — S3 continue-as-new mid CA sandwich.** Property SANDWICH-CAN-SAFE: a CAN landing between the
  before-mark and after-mark leaves no half-sandwich, because the sandwich is a projection over log records
  and CAN carries only `{unitId, nodeId, cut}` — it re-strikes identically across the boundary. Verifies the
  design's asserted "CAN-boundary safe" (T-1 l.99) on its most complex multi-step projection; catches any
  intermediate state held in workflow memory rather than the log.
- **Round 7 — S6 poisoned-cache replay after wipe-rebuild.** Property LOG-IS-SOLE-TRUTH: after wiping
  Temporal and rebuilding from the log, rebuilt state = pre-wipe state (R-02, the acceptance test), and a
  poisoned cache cannot have written poison into the log because the cache holds no write credential — only
  the door writes. Tests INV-4, the foundational strip-Temporal-and-rebuild claim.
- **Round 8 — S2 workflow-code deploy mid-backtest.** Property AXIS-ISOLATION: a Build-ID deploy mid-backtest
  changes only orchestration, never a recorded economic value; the backtest's marks/states re-enter its own
  namespace's record under model/recipe versions on the log (D9 three axes), so the deploy cannot alter a
  result mid-flight. Tests the orchestration-vs-economics axis separation under a live deploy.
- **Round 9 — S5 clock skew vs the three times.** Property TIMES-ON-THE-LOG: substrate clock skew changes
  only orchestration timing, never execution/monitor/door time (read from the log); a late- or early-firing
  timer yields the identical transaction (C-3.7, D11/D12). Placed last because the design already argues this
  most completely — it is a confirmation the regime must *witness firing*, the lowest residual risk.

**Round 10** is reserved for consolidation and the final property-test harvest (firings tabulated per
scenario), not a new attack. If S1 or S7 surfaces a real defect in Round 4, promote its repair ahead of the
Round-5 schedule; the ordering above assumes both survive.

---

## Declaration
Lenses applied: L1, L2, L3, L5, L6, L7 (touching L8/L9). Lenses dismissed: L4 (no algorithmic subproblem
this round — the design adds no data structure or hot loop); L10 (no learned component near a safety
property — MD-16 gates are decidable predicates, not learned). Confidence: **HIGH** on the certification
(the seam M1 is precisely located with a counterexample and a named resolution); **MEDIUM** on the red-team
ordering — the single biggest unknown is whether S1's REFOLD-ATOMIC property holds across a crash, which is
exactly why it is assigned first.
