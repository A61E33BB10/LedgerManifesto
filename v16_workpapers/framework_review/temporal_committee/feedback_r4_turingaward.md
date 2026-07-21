# TuringAward — Temporal Committee Referee Feedback, Round 4 (first red-team)

Role: standing referee — architecture judgment, convergence steering, Constitution §4 anti-bias. Advisory,
no veto. This round certifies the r3 seam folded, judges the two crown-jewel survival arguments (S1/S7),
weighs the four new load-bearing preconditions, and tees up S4/S3/S6/S2/S5. Lenses: L1 (crash-recovery,
failover, split-brain, exactly-once-under-concurrency), L2 (write atomicity, idempotence key, TOCTOU),
L3 (fixpoint/termination), L5 (typed boundary — fused worker unrepresentable), L6 (minimalism — what the
deletion bought), touching L7 (door backpressure), L8/L9. **Round 4 of ≥10. No consensus declared.**

---

## 1. Did the value-bound seam fold cleanly? Is the content-hash deletion a win or a lost guard?

**Folded cleanly.** T-1 §3 "value-level bound — CLOSED; locus seam folded": the door "does **not** compare β
to any tolerance," and consumption "raises a **VM-7 broken chain** when β > *that* unit's VM-6 tolerance" —
now matching T-1's own §2.3 loci table ("β > this unit's tolerance" at the valuation projection). T-4 D16:
"corrected from r3, which **wrongly put the whole check at the door**." The mis-parameterised door check is
gone; the one-surface/two-consumers counterexample (β=3 bp feeds U₁@5 bp, U₂@1 bp) is now the *reason* for
the split, stated in both. Seam closed. **Content-hash deletion is a genuine win, not a lost guard** — they
took r3-M2's preferred horn: the fused worker is *unrepresentable* (T-1 §3 "typed boundary … not
representable"), so the hash "guards nothing," and S1 crash-(i) (T-5) confirms only **one** payload ever
reaches the door, so a two-payload compare "structurally never fires — a zero-firings property" (T-4 D14).
Deleting a guard over an unrepresentable state is §7 minimalism, **conditional** on the reference impl making
the typed boundary real (proposeToDoor's sole input = runModel's recorded output); if that is convention, not
type, "unrepresentable" silently becomes "lost guard." FORMALIS owns that certification.

## 2. S1/S7 — do the hardening arguments demonstrate survival at the architecture level? Hand-waving?

**Both demonstrated; no fatal hand-waving.** Each argument correctly *reduces* its property to a small set of
named, cited atoms rather than asserting it. **S1 REFOLD-ATOMIC** reduces to three: append-only (rewind
"not representable," T-1 §4 — real by-construction), cause-derived txid (no duplication), and — the sharpest
and best point of the round — T-3's "the refold is `apply∘contract`, a PURE fold over the ordered log — it
recomputes **NO model**," so "a different number on re-run cannot enter the refold." T-4 adds the correct
resume key: "the stable `(exec, door, hash)` triple, **never an ordinal position** (an interior insertion
renumbers ordinals)" — a genuine strengthening. **S7 GATE-STATE-ATOMIC** reduces to one-transaction (Fork A)
+ pinned-cut determinism (MD-12) + single-writer dedup; T-3 drives the sharpest interleaving (active-active
split-brain, both regions pin same cut, get different numbers, both propose → one door, one txid, absorbed).
The residual hand-waving is *inheritance*: S1 leans on `prop_refoldIdempotent` and `Thm refold-equals-timely`
as cited-not-shown. That is acceptable composition **only if** those are executable properties shown to
*fire* (§3: zero firings = defect) — the fault-generator witnesses (crash at each tail position; failover at
each of gate1/gate2/construct/propose) must be built and fire, not remain prose. Flag for the harvest.

## 3. The four new load-bearing invariants — real, or restatements? Any add complexity?

All four are **real** (each names a specific interleaving that flips HOLDS→BREAKS with a counterexample), and
**none adds a mechanism** — each is a constraint sharpening an existing element for the crash/failover mode.
(i) *No model recomputed in-fold* (T-3): the cleanest; minimality-**positive** — the refold need not reason
about model determinism. (ii) *cut+seed+env recorded BEFORE compute* (T-5 crash-(i): "seed drawn inside
runModel → re-draws → DIFFERENT txid → two distinct observations both commit"), plus T-2's corollary "drop
input-cut from the key and the correction is **silently absorbed** → broken state" — a sharpening of D10's
key with a temporal-ordering constraint; keep. (iii) *One single writer per lineage across DCs* (T-2): a
sharpening of R-18, minimality-neutral. (iv) *Axis non-leak — Build-ID per run, recipe a lineage fact*
(T-3): sharpens D9 for failover. **Nothing to delete; two are minimality-positive.** One push: (iii) and (iv)
are phrased as operational "**forbid it**" / "must be enforced." Per §3 (illegal states unrepresentable),
promote them to by-construction — **one write credential per lineage, un-forgeable** — not deployment
discipline, else a misconfiguration reopens S7. The only vestige to cut is T-4 D14's "retained at most as an
OPTIONAL diagnostic … for a buggy *fused* worker": a buggy fused worker is unrepresentable, so this ornament
contradicts the deletion — match T-1's clean cut.

## 4. §4 anti-bias — still holding?

**PASS, all five.** No document introduces anything categorically first; no proof leans on a functor,
adjunction, or box; no commutative diagram. The new terms — reproducibility class, β bound, compute/emit
split, single writer per lineage, cause-derived txid — are ordinary, each with a concrete example (90 s/45 s
livelock; {P₁,P₂} spread; crash-(i)/(ii)/(iii) interleavings). **One §1 vocabulary defect, not §4:** the
reproducibility-class bound is written **β** (T-1, "earlier drafts' ε_repro/τ/ε normalised to β"), **ε_repro**
(T-4 D16), and **τ** (T-5) — three names for one quantity. §1 forbids synonyms across documents. Unify to β
at assembly; route the clause to CONCORDIA.

## 5. Convergence — one design, or did red-team reopen a fork?

**Still one design; no fork reopened.** All five agree on the two-loci value-bound fold, the content-hash
deletion, S1 HOLDS/REFOLD-ATOMIC, S7 HOLDS/GATE-STATE-ATOMIC. Red-team surfaced **preconditions**, not
disagreements — the four invariants above are constraints every document endorses. Residual open items
(TA-REPRO attestation truth; load model K; Forks C/D soft) are unchanged and correctly parked. The only
intra-committee splits are merge-hygiene, not correctness: (a) symbol β/ε_repro/τ unification; (b) T-4's
content-hash vestige vs T-1's clean deletion. Convergence intact; the red-team hardened rather than reopened.

---

## Tee-up — the ONE architectural property each remaining scenario must demonstrate survives

**R5 · S4 retry storm at the one door — EXACTLY-ONCE-UNDER-CONCURRENCY (+ bounded backpressure).**
Show the door's admit is an **atomic conditional-append keyed on the cause-derived txid** (a unique-key
insert at the single writer), so two concurrent retries of the same txid serialize and exactly one lands —
*and none is dropped* — while throughput degrades but the door never blocks, drops-silently, or lies (L7).
This is the scenario I flag **most likely to bite**: T-4 D10 says "**Dedup is optimisation, never
load-bearing**," yet S1 and S7 both rely on txid dedup for exactly-once across crash and failover. The
reconciliation the committee must state is that exactly-once = the txid is a **unique key enforced atomically
at the single writer** (load-bearing, by-construction); only the *pre-log early-drop* is optimisation. If the
door's admit is "read log, then append" (check-then-append), a storm is a classic read-modify-write TOCTOU
and double-admits. Members attack here hardest: force the atomic-unique-key statement.

**R6 · S3 continue-as-new mid CA sandwich — SANDWICH-IS-PURE-PROJECTION (no state in workflow memory).**
Show the sandwich (before-mark + operator projection + after-mark + certificate) is struck **entirely from
log records**, CAN carrying only `{unitId|lineageId, nodeId, cut}` (R-15), so a CAN between before- and
after-mark re-strikes identically — no half-sandwich. The break: any intermediate (the before-mark, the
operator projection) held in a workflow variable that CAN drops. Witness: inject CAN at each sandwich step,
assert the completed sandwich = the CAN-free one. Second-most-likely to bite — same kind of audit as S1's
no-model-in-fold: it turns on whether state was actually kept off workflow memory.

**R7 · S6 poisoned-cache replay after wipe-rebuild — LOG-IS-SOLE-TRUTH.**
Show that after wiping Temporal and rebuilding from the log, rebuilt state = pre-wipe state (R-02), and a
poisoned cache **cannot** have written poison into the log because it holds **no write credential — only the
door writes** (R-18): a replayed old txid is absorbed by dedup; a poisoned input never enters because inputs
cross the door envelope-first, so the cache can only corrupt orchestration/timing, never a recorded fact.
Property: no cache poison yields an admitted fact differing from a clean rebuild-from-log. Well-defended by
the cache-vs-log separation; lower bite risk.

**R8 · S2 workflow-code deploy mid-backtest — AXIS-ISOLATION-UNDER-DEPLOY.**
Show a Build-ID deploy mid-backtest changes **only orchestration**, never a recorded economic value: marks and
states are functions of the recipe/model version **on the log** (D9), not of the Build-ID, so a running
workflow that drains on the old Build-ID or continues-as-new onto the new one yields a **deploy-invariant**
result. Same axis-separation S7 leaned on (T-3 "region ≠ Build-ID ≠ recipe version"), now under live deploy
rather than failover — so it is largely pre-argued if invariant (iv) is enforced by construction.

**R9 · S5 clock skew vs the three times — TIMES-ON-THE-LOG.**
Show substrate clock skew changes only orchestration timing, never execution/monitor/door time (all
record-derived): a late- or early-firing timer yields the **identical** transaction (C-3.7, D11/D12 —
"timers carry NO time authority"). No path lets `workflow.Now` or a timer's wall-clock reach a contract,
model, or the committed order `(exec, door, hash)`. Lowest residual risk — the design argues this most
completely — but must still **witness firing** (skew injected, identical transaction asserted).

---

**On track for round-10 consensus?** Yes — one design, both crown-jewel invariants survived with only
preconditions surfaced (no fork reopened); on track provided S4 forces the atomic-unique-key (not
check-then-append) statement, invariants (iii)/(iv) are promoted from "forbid" to by-construction, and the
two merge-hygiene items (β symbol, content-hash vestige) close.

---

## Declaration
Lenses applied: L1, L2, L3, L5, L6 (touching L7, L8/L9). Dismissed: L4 (no algorithmic subproblem — the
round adds no data structure or hot loop); L10 (no learned component near a safety property — MD-16 gates
are decidable predicates). Confidence: **HIGH** on items 1–5 (each finding carries a counterexample or a
cited clause); **MEDIUM** on the tee-up — the single biggest unknown is whether the door's admit is an
atomic unique-key insert or a check-then-append, which is exactly why S4 is flagged to be attacked hardest.
