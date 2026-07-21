# TuringAward — Temporal Committee Referee Feedback, Round 5 (S4: retry storm)

Role: standing referee — architecture judgment, convergence steering, §4 anti-bias. Advisory, no veto. This
round judges whether the door admit is now an **atomic unique-key insert** (my r4 demand), whether exactly-once
is a total function of the durable log, whether env-out-of-key and the D10 "dedup is optimisation" contradiction
are fixed, and whether COVERAGE-β is the right architectural statement. Lenses: L2 (write atomicity, idempotence
key, TOCTOU), L1 (crash-restart, split-brain, exactly-once-under-concurrency), L6 (minimalism), L5 (typed
boundary), touching L7 (backpressure). **Round 5 of ≥10. No consensus declared.**

---

## 1. Is the door admit an ATOMIC UNIQUE-KEY INSERT? Exactly-once a total function of the log? Residual?

**Demand met, all five files.** T-1 §4: "atomic unique-key insert on the cause-derived `txid` … **not**
check-then-append (a read-modify-write TOCTOU) … Exactly-once is a **total function of the durable log**." T-4
D10: "a **UNIQUE KEY enforced by an ATOMIC conditional-append … at the single writer**." T-2 A1 exhibits the
check-then-append double-admit (SELECT-absent / SELECT-absent / APPEND / crash / APPEND → two rows) and closes
it with the atomic INSERT under `UNIQUE(txid)`. No hand-waving — the property is *reduced*, not asserted.
**But three reviewer preconditions the assembly T-1 does not yet carry** (all counterexample-backed, fold them):
(a) **durable-before-ack** (T-5 i): ack before the append is durable → a *lost* admission (under-write); T-1
omits it. (b) **exact-grained input-cut** (T-2 A2): a coarse "latest"/truncated cut false-dedups two genuinely
different inputs → silent loss; T-1 I2 says only "input-cut IN," not "exact." (c) **quorum log per lineage**
(T-5 ii) beyond the bare fenced lease. None reopens the design; each is a missing-case fold.

## 2. Env-version OUT canonicalized consistently? D10 contradiction fixed?

**Both fixed, cleanly.** Env-out is consistent across all five: T-1 I2, T-4 D10 "OUT of the key," T-3 SA3, T-5,
and — the convergence signal — T-2 A3 *corrects its own R3/R4 key* ("env-IN … BREAKS: a retry storm migrating
across heterogeneous workers … double-admits one fact"). D10 contradiction FIXED: T-4 "my r4 'dedup is
optimisation, never load-bearing' was **WRONG** … load-bearing, by construction"; T-1 reconciles — "the
unique-key insert is load-bearing … only the pre-log early-drop is the 'optimisation.'" Both r4 merge items
also closed: symbol unified (T-4 "ε_repro → β," T-5 "β replaces τ"); content-hash DELETED (T-4 D14).
**One residual seed-spelling divergence:** T-1/T-4 write the key as a 4-tuple with `seed`; T-2/T-3 as a 3-tuple
without; T-5 says "recipe/dynamic-version must subsume the seed policy." Same identity when seed is
recorded-before-compute, but "the one pin" now has two spellings — CONCORDIA/assembly must pick one. Not a break.

## 3. COVERAGE-β — right architectural statement, or a mechanism that should be by-construction?

**Right statement, and it IS by-construction — not a bolted-on checker.** T-1 §3: "a valuation reads a kind-2
leaf **only** through the 'current fit' selector … there is **no raw path** to a kind-2 leaf." That is the
valuation analog of D1's forbidden bare read: totality follows from there being one read path, not from a new
runtime guard. The executable `prop_everyKind2ConsumerChecksBeta` (T-4) is the firing witness §3 demands, not a
second mechanism. **One condition, identical to r4's fused-worker:** "no raw path" must be enforced by **type**
(the selector the sole typed constructor reading a kind-2 leaf), not convention — else by-construction silently
degrades to a check you can forget. FORMALIS owns that certification, exactly as it owns the typed
`proposeToDoor` boundary.

## 4. Minimalism + §4 anti-bias — clean? Did the storm hardening add complexity to delete?

**§4 PASS.** No functor, adjunction, box, or commutative diagram in any of the five; every term is ordinary
(unique-key insert, TOCTOU, fenced lease, quorum, split-brain, durable-before-ack). **Minimalism POSITIVE — the
round is subtractive.** The content-hash is DELETED (T-4 D14) and the storm argument *confirms* the deletion
("never fired for the retry race it was built to catch — memoised bytes"). No new component added; the hardening
only *names requirements* on the one existing door. Defense-in-depth (split + insert, T-3 SA1b) is **not**
redundant: the insert buys exactly-once, the split buys value-determinism for Tier-1 read-back (T-5 iii "the
split's extra guarantee is only that the one row's value is deterministic") — both load-bearing. Nothing to delete.

## 5. Convergence — still one design?

**Still one design; no fork reopened.** All five agree on the atomic unique-key insert, env-out, D10
load-bearing, COVERAGE-β, and single-writer. T-2 folding its own prior env-IN key is a red-team that
*converged*, not a split. Every residual delta is a merge-hygiene fold — the three named preconditions (item 1)
and the seed spelling (item 2) — no disagreement of substance. The red-team hardened S4 without reopening it.

---

## Tee-up — the ONE architectural property each next scenario must show survives

**R6 · S3 · history-limit hit / continue-as-new mid CA sandwich — SANDWICH-CARRIES-NO-WORKFLOW-STATE.**
The sandwich survives a CAN (including a history-limit-forced one) because it holds **no economic state in
Temporal history**: its before/after marks are kind-1 projections recomputed from the log (T-1 §2.3 "struck as a
projection from the log (CAN-safe, S3)"), its certificate is a kind-3 admission idempotent under S4, and CAN
carries only `{unitId|lineageId, nodeId, cut}` (R-15). So a CAN at any step re-derives the whole sandwich or
resumes the one missing certificate admission — **never a half-sandwich**. R6 must state whether the sandwich is
one door transaction or several idempotent legs; if several, completion must be a **deterministic function of the
recorded cut**, so resume re-drives exactly the missing legs (each S4-collapsed to one row). Witness: inject CAN
at before-mark / operator / after-mark / certificate; assert completed sandwich = CAN-free sandwich. This is the
*same audit as S1's no-model-in-fold* — it turns entirely on whether state was actually kept off workflow memory.

**R7 · S6 · poisoned-cache replay after wipe-rebuild — LOG-IS-SOLE-TRUTH (in two halves).**
(1) Rebuild reads the **log**, never the cache (R-02), so the rebuild is trivially cache-independent; the real
question is whether poison could reach the log *before* the wipe. (2) It cannot become silently-trusted truth:
the cache holds **no write credential — only the door writes** (I1 fenced lease); a replayed old txid is absorbed
by the atomic unique-key insert (S4); a cache-fabricated *novel* txid is either door-refused as an unresolvable
structural reference (R-22) or, where structurally valid but economically uncaused, caught by the **decidable
audit-recompute** (D7). **Honest edge R7 MUST state:** economic causality is detection-at-audit, not
door-prevention (Gate 1 needs model knowledge "the door must not hold," T-1) — so the guarantee is "no poison
silently becomes trusted truth / no rebuilt state not derivable from the log," **not** "no structurally-valid
poison ever touches the log." Witness: seed a poisoned/forged Temporal cache, replay, wipe, rebuild-from-log;
assert rebuilt log = clean rebuild, and every cache-fabricated txid is door-refused or audit-flagged.

---

**Safe to batch R6+R7?** **Yes.** Both are the lower-bite scenarios and both *reduce to already-proven
properties* — S3 → S1 (no state in workflow memory) + S4-idempotent certificate; S6 → S4 (absorb) + I1 (no write
credential) + D7 (decidable audit). Neither adds a mechanism nor can reopen the design; batch them, provided each
still **witnesses its firing** and R7 states the audit-detection edge honestly.

**Still on track for round-10 consensus?** **Yes.** The scenario I flagged most-likely-to-bite (S4) HELD under
all five with the atomic-unique-key statement made explicit; the design is one; only three named-precondition
folds + one seed-spelling merge item remain, all mechanical. Batching R6+R7 leaves R8 (S2 deploy) and R9 (S5
clock skew) — both largely pre-argued by I4 axis-non-leak and times-on-the-log — with headroom for a
firing-witness harvest and final assembly before round 10.

---

## Declaration
Lenses applied: L2, L1, L6, L5 (touching L7). Dismissed: L4 (no algorithmic subproblem — the round adds no data
structure or hot loop; the unique-key insert is an existing DB primitive, not a new algorithm); L10 (no learned
component near a safety property). Confidence: **HIGH** on items 1–5 (each finding carries a cited clause or a
counterexample). Single biggest unknown, unchanged: whether "no raw path to a kind-2 leaf" (COVERAGE-β) and
"proposeToDoor's sole input is runModel's recorded output" are enforced by **type** or by convention in the
reference implementation — FORMALIS's certification, not this committee's prose.
