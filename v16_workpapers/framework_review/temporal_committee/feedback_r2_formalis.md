# FORMALIS — Referee feedback, Round 2 (Temporal Committee, Part II)

Remit unchanged (R1): rigor of the Temporal↔Ledger mapping and containment — equivocation,
undischarged determinism obligations, doctrine violation, assertion-where-proof-is-owed.
Priorities: (1) the set-wide value-determinism gap — judged for soundness AND cross-member
consistency; (2) Fork A one-transaction atomicity + the refuse-vs-flag tie-break; (3) new defects,
and whether the R1 per-file defects are actually fixed. Round 2 of ≥10 — defects exposed, consensus
not pushed. All five proposals are active; T-2/T-3/T-5 recommend a merge, judged at the end.

---

## TEMPORAL-1
- [FIXED] R1 "two record kinds" → "three record kinds" with the gate verdict named kind 3 (l.3-12).
  [FIXED] prevention placement now DERIVED not asserted — Gate 1 needs product knowledge the door
  must not hold (spec l.917), so it runs in a gate activity, door commits verdict+state atomically
  (l.74-80). [FIXED] CA residual bounded to "VM-9's three, VM-6" declared tolerances, "not an
  asserted ≈0" (l.105).
- [NEW DEFECT] Its Fork-A tie-break refuses a stale cut — "the door's consistency-of-reference check
  fails — the state never exists" (l.69-73) — which CONTRADICTS its own kind-3 definition: "a
  verdict... *not stale-on-input-move* (it decided against inputs as they then stood)" (l.10). On its
  own doctrine a decision pinned as-known at C should stand-then-flag, not be refused.
- [DEFECT] "first-admitted is canonical (MD-1 absorption — the existing rule, not a new fiat)" (l.133)
  over-claims: MD-1 absorption assumes duplicates are the SAME observation at grain; two DIFFERING
  payloads are not, so canonical-by-first IS a fiat — the over-coarse absorption T-4 D14 flags as MD-1's
  own residual.

## TEMPORAL-2
- [FIXED] stance corrected to "(exec, door, hash)" (l.11-14); [FIXED] "never constructed" now carries
  the detection-at-audit bound (l.36); [FIXED] D6′ states the ⊤/null mechanism (l.23, l.93).
- [DEFECT] Determinism "Primary (dissolve the race)" (l.51-55) over-promises: pinning a
  numerical-environment VERSION (a governance label) does not MAKE a GPU-atomics model bit-reproducible;
  "both retry attempts compute the identical payload" holds only if the model already is reproducible.
  The residual layer saves the closure, but the "Primary" is conditional, not a dissolution.
- [INCONSISTENT] Substrate rule "never compare two attempts' payloads" (l.63) directly contradicts
  T-4 D14's content-hash divergence diagnostic — under T-2 a differing redelivery is silent, under T-4
  it is a recorded defect. Both cannot be the committee rule.
- Tie-break: flag-only — "staleness is never a construction-time verdict... Refusal belongs only to a
  fail/undecidable gate verdict; supersession belongs only to a later arrival" (l.35); the door has NO
  stale-cut refusal. Sides with T-5, against T-1/T-3/T-4.

## TEMPORAL-3
- [FIXED] Fork B blanket claim withdrawn — system-cadence→Schedule, contractual/input-moved→per-unit
  watch (l.80-91); [FIXED] input-moved corrected-leaf is now a condition watch, not a date Schedule
  (l.86). Both R1 defects on me closed.
- [DEFECT] Determinism "the race is not a correctness violation... which retry lands first is which
  'print' the record captures, exactly as source-arrival order resolves two simultaneous vendor prints"
  (l.60-62) — the analogy is unsound. Two vendor prints are two DISTINCT facts from two sources; two
  retries of one model on identical inputs are ONE fact computed twice with numeric drift. Relabelling a
  nondeterminism source as legitimate observation-multiplicity is assertion where proof is owed.
- [INCONSISTENT] Explicitly forbids pole (a): env-pin is "never a spec-level admission precondition,
  because that would reach into out-of-scope numerics" (l.57) — the exact opposite of T-5 §3(b)'s
  "admission-time contract."
- Tie-break: refuse-on-stale-cut — "a *stale cut at construction*... is **refused**... the state never
  existing" (§2b, l.76). Sides with T-1/T-4.

## TEMPORAL-4
- [FIXED] the R1 no-conflict/deferral contradiction resolved — moved into contained row D7, Q4 removed
  (l.115, l.134-143); [FIXED] value-determinism confronted head-on in D14.
- [NEW DEFECT] The content-hash-beside-txid door diagnostic (D14 guard-1, l.122) is a new door behaviour
  no peer holds, and it is only meaningful if two payloads reach the door — which the T-1/T-5
  split-compute-from-emission mechanism PREVENTS. Under an M1 consensus the guard structurally never
  fires (a dead property by the zero-firings rule); under a non-M1 consensus it contradicts T-2's
  "never compare payloads." The guard is stranded between the two mechanism camps.
- [OK] D14 is the most honest pole-(b): "making bit-reproducibility an admission precondition would pull
  that governance into scope, which C-Scope.11 forbids" (l.122) — a real doctrinal ground, and it flatly
  contradicts T-5's admission-contract.
- Tie-break: refuse-on-stale-cut — "the door refuses (C-11.3)... Refuse, not flag — a verdict against a
  base that no longer holds is meaningless" (D15, l.123).

## TEMPORAL-5
- [FIXED] three-loci table (broken chain / gate fail / door refusal, l.51-58) replaces the collapsed
  R1 row; [FIXED] the door-arrival race is genuinely removed by split-compute-from-emission (§3a) —
  the soundest mechanical fix in the set: only one payload ever reaches the door.
- [NEW DEFECT / INCONSISTENT] §3(b) makes bit-reproducibility "the producer's **admission-time
  contract**" for EVERY re-entered observation — colliding head-on with T-3 ("never a spec-level
  admission precondition") and T-4 ("C-Scope.11 forbids"). It is also internally equivocal: an
  "admission-time contract" (prevention wording) "enforced by the same recomputation defence as economic
  correctness" (l.89) — which is detection-at-audit, not admission. Prevention words, audit enforcement.
- [DEFECT] The cited authority, spec l.3921 ("deterministic function of (branch point, generator version,
  seed)"), is a SIMULATION-reproducibility rule; "the rule generalises that... to every re-entered
  observation" (l.87) is precisely the scope-stretch two peers call out-of-scope. Asserted, not derived.
- Tie-break: flag-only — "a moved base is flagged stale, never refused... refuse only on a failed gate
  verdict or an unresolvable reference" (§4, l.104-119). Sides with T-2, against T-1/T-3/T-4.

---

## Determinism-gap verdict — closed at read-back, NOT consistent

**Closed at the admission/read-back level, soundly.** All five discharge exactly-once ADMISSION plus
unconditional read-back. The door-arrival RACE (two differing payloads, same txid, first-wins) is
genuinely removed only by T-1/T-5, by splitting model-eval from door-propose so one recorded payload
reaches the door (T-1 l.122-134, T-5 §3a) — this is sound: Temporal records exactly one activity
result, so retries of the propose re-present identical bytes. T-2/T-3/T-4 do NOT remove the race; they
keep it and resolve by first-admitted-canonical (T-4 adds a content-hash diagnostic).

**Not consistent — two mutually-exclusive closures on the two axes the remit named:**
1. **Bit-reproducibility as admission precondition.** T-5 REQUIRES it ("admission-time contract",
   §3b); T-3 and T-4 hold that requiring it VIOLATES the Constitution (out-of-scope numerics /
   C-Scope.11). T-1/T-2 treat it as optional/governance. One consensus design cannot contain both
   "required" and "forbidden."
2. **Mechanism.** M1 split-compute-emit (T-1/T-5) vs accept-race+diagnose (T-4) vs accept-race+
   never-compare (T-2) vs accept-race+embrace (T-3). T-4's content-hash guard is dead under M1;
   T-2's never-compare contradicts T-4's compare.

**Consequence — the recommended merge is not performable.** T-2, T-3, and T-5 each say "build on T-1's
mapping + T-4's catalogue and fold in my resolution." But their folded resolutions of these two forks
contradict one another and D14 at exactly the hard points: folding T-5 §3 into the T-4 catalogue is
LOSSY (admission-contract vs C-Scope.11-forbidden); folding T-2/T-5's flag-only tie-break onto T-4's
D15 refuse is a straight conflict. The convergence is illusory where it costs the most.

## Fork A
- [CONVERGED] All five commit state+gate-decision as ONE door transaction over ONE pinned cut (MD-12):
  T-1 l.63-73, T-2 l.33, T-3 §2b, T-4 D15, T-5 §1. Atomicity is settled; the R1 two-write window is gone.
- [NOT PINNED — 3-2 SPLIT] The refuse-vs-flag tie-break the remit asked to verify is pinned in two
  contradictory ways for the SAME interleaving (a correction landing at-or-before the pinned cut C
  BEFORE admission): REFUSE (T-1 consistency-of-reference; T-3 "refused... the state never existing";
  T-4 D15 "the door refuses... Refuse, not flag") vs FLAG-ONLY (T-2 "staleness is never a
  construction-time verdict"; T-5 "a moved base is flagged stale, never refused"). Sharper than wording:
  T-1/T-3/T-4 give the DOOR a stale-cut refusal mode; T-2/T-5 DENY the door has that mode at all.
- The flag-only camp (T-2/T-5) is the more doctrine-consistent — it matches the kind-3 "pinned as-known,
  not stale-on-input-move" definition T-1 itself states (l.10). The refuse camp (T-1/T-3/T-4) is at odds
  with that definition. The committee has not chosen; it has pinned both.

## Still-open (sharpest remaining rigor defect)
**Nobody bounds the value-divergence itself.** Every member proves READ-BACK (you can reproduce the
recorded byte) and calls that MD-14/VM-8 dispute-readiness. But for a non-bit-reproducible model the
recorded value is one arbitrary member of the set {P₁,P₂,…} the attempts could have produced, and no
proposal bounds |Pᵢ − Pⱼ|. If that spread can exceed the VM-6 residual tolerance, a mark that
"reproduces bit-for-bit against the record" is still a mark no honest independent re-derivation would
produce within tolerance — MD-14/VM-8's "reproduces bit-for-bit" is then satisfied only trivially,
against itself, and dispute-readiness is a guarantee about the record's self-consistency, not about the
mark's correctness. T-4's content-hash DETECTS the spread but does not BOUND it; T-2 forbids even
looking (l.63); T-3 declares it non-violating (l.60); T-5 would bound it to zero only via the
admission-contract two peers reject. The obligation the whole set still owes: tie the admissible
re-entry-value spread to the VM-6 tolerance — a bounded-divergence or reproducibility-class predicate
the door CAN check without holding model knowledge (e.g. a producer-attested reproducibility class in
the lineage) — so canonical-by-record cannot admit a mark outside the dispute tolerance. Until then the
gap is contained at the byte level and open at the value level.
