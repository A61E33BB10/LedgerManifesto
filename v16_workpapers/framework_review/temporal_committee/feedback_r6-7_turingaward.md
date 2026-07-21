# TuringAward — Temporal Committee Referee Feedback, Rounds 6+7 (batched: S3 CA-sandwich CAN + S6 poisoned-cache replay)

Role: standing referee — architecture judgment, convergence steering, §4 anti-bias. Advisory, no veto. Fresh
instance; consulted feedback_r5 (which set the S3/S6 survival properties). This round judges whether the two
lowest-bite scenarios were demonstrated at the architecture level, whether the S6 detection-at-audit edge is
stated without overclaim, whether sandwich granularity resolved, and whether the assembly is consensus-ready.
Lenses: L2 (log-as-truth, idempotence key, exactly-once), L1 (CAN/failover/replay), L8 (poisoned-cache adversary,
hash-chain tamper-evidence), L3 (firing properties), L5 (by-type boundaries), L6 (minimalism), touching L7. **Round 6-7 of ≥10. No consensus.**

---

## 1. S3 + S6 — architecture-level, or hand-waving? Is the S6 edge stated without overclaim?

**Both demonstrated at the architecture level; no hand-waving; the S6 edge is stated without overclaim — and
reinforced.** S3 is *reduced*, not asserted: marks are projections / kind-2 re-entries on the log, the certificate
is one kind-3 S4-idempotent admission, CAN carries `{unitId|lineageId, nodeId, cut}` only (T-1 l.147-156; T-3 l.4-9;
T-5 l.15). Each red-team states the ONE break honestly — "**Break iff** the CAN carried mark/partial-certificate
state" (T-3 l.7; T-2 l.55). S6 is attacked from three independent angles that agree: door recomputes txid + revalidates
against the log (T-2 l.5), axis separation keeps economics off the Build-ID (T-3 l.11-12), and — the sharpest —
**rebuild is Tier-1 read-back, not Tier-2 re-derivation, so no model runs for a cache to poison** (T-5 l.5-7). The
edge is verbatim and self-policing: "detection-at-audit, not door-prevention — and the design already says so;
overclaiming prevention here would be the error" (T-2 l.23); T-1 l.166-168 states the exact non-claim I demanded.

## 2. Did sandwich-granularity wording resolve cleanly?

**Yes on all three criteria I named.** Idempotent legs: T-4 l.35 "several idempotent legs, not one door
transaction — necessarily." Completion = deterministic function of the cut: T-4 l.44 "Completion is a deterministic
function of the recorded cut"; T-1 l.154 same. Certificate = the one kind-3 admission: T-3 l.5, T-1 l.150, T-5 l.16.
Witness `prop_sandwichCANInvariant` injects CAN at before-mark/operator/after-mark/certificate and asserts
completed = CAN-free (T-4 l.52) — exactly my r5 ask. **One residual, wording not design:** the *mark* kind-status is
headlined as kind-1 (T-3 l.4) vs kind-2 (T-4 l.35); the assembly correctly carries the disjunction ("a projection,
or a kind-2 re-entered observation," T-1 l.150) — kind-1 when operator-reframe, kind-2 when model-priced. State that rule once.

## 3. Minimalism + §4 anti-bias — clean? Complexity to delete?

**§4 PASS — no functor, adjunction, box, or diagram in any file; every term is ordinary** (fenced lease, quorum,
unique-key insert, read-back, hash chain, half-sandwich, continue-as-new). **Minimalism POSITIVE — subtractive
round.** Both scenarios "reduce to already-proven properties (no new mechanism): S3 → S1 + S4-idempotent legs; S6 →
S4 + I1 + D7" (T-4 l.82-83); no component added. T-5's read-back insight is a *deletion of worry*: it shows the
compute/emit split and env-version are **not** load-bearing for rebuild (Tier-2 only, T-5 l.7) — the S6 argument
gets simpler, not larger. **One spelling to prune:** T-4 l.35 keys sandwich legs on `(node, cut, leg-tag)` under a
uniform "leg" umbrella, while T-1/T-3/T-5 keep two key shapes (kind-2 marks on I2's tuple; kind-3 certificate on
H(cause,contract,unit,seq)). The cut already distinguishes pre/post marks (different frames) — "leg-tag" and "node"
are redundant decoration. Reconcile to the canonical keys; do not let the sandwich mint a fourth ad-hoc axis.

## 4. Convergence — still one design? Fork reopened?

**Still one design; no fork reopened; the three r5 preconditions folded.** durable-before-ack + quorum-per-lineage
→ I1 (T-1 l.172-175, T-4 D10 i/ii); exact-grained input-cut → I2 (T-1 l.176-177, T-4 D10 iii); β is the sole
reproducibility symbol, ε_repro/τ purged (T-4 l.5). Forks A/A′/B unchanged; C/D still soft, load-gated,
non-correctness. T-3's S6 (stale Build-ID poison) and T-2/T-5's S6 (content/txid poison) are **complementary
coverage of two poison vectors, not a split** — and the Build-ID vector pre-argues S2. **One surviving cross-document
divergence (the r5 seed residual, NOT closed):** the assembly says a **3-tuple**, "recipe term subsumes seed" (T-1
l.29-32); the catalogue still says a **4-tuple** with a conditional `seed` slot (T-4 D10 l.16). Same identity, two
spellings of "the one pin" across the two artifacts that become consensus — CONCORDIA must pick one before round 10.

## 5. Is the assembly (T-1 r7) a coherent single document, consensus-ready?

**Substantially yes — coherent and integrated (mapping table, decomposition, containment, I1-I4 + COVERAGE-β,
firing list, exercised-empty parking).** S3/S6 fold in cleanly; the honest edge is stated; β is single-voice. **Three
closes before it is the clean consensus artifact, all polish not breaks:** (a) canonical-key arity 3-tuple (T-1) vs
4-tuple (T-4) — reconcile; (b) state the mark kind-1/kind-2 rule once rather than as an inline "or" (§2); (c) prune
the `(node, cut, leg-tag)` leg-key to the canonical shapes (§3). **The one substantive gap for consensus is §3-of-CLAUDE.md:
the firing witnesses are NAMED but still OWED** — T-4 l.96-98 lists `prop_refoldIdempotent`, `refold-equals-timely`,
`prop_everyKind2ConsumerChecksBeta`, `prop_sandwichCANInvariant`, `prop_poisonedReplayCleanRebuild` as "owed ... each
must be shown to fire." Consensus requires the harvest to actually fire (a precondition never generated = defect), not the list.

---

## Tee-up — the ONE architectural property each final scenario must show survives

**R8 · S2 · workflow-code deploy mid-backtest — DEPLOY-CANNOT-CHANGE-A-RECORDED-VALUE (axis separation is total).**
A deploy changes only the orchestration Build-ID (axis 1, Worker Versioning, R-17); it cannot change any admitted
transaction or any backtest result, because every economic value is a **fold / read-back over the log under the
*recorded* economic versions** — ProductTerms, model/recipe, dynamic/gate-terms (axes 2/3, on the log) — never the
deployed binary (I4 axis-non-leak: the activity reads the version *from the log*, T-1 l.180). A version-pinned
activity fires the recorded version, so a new deploy folds the same log to the same value; backtest determinism is a
function of `{recorded input-cut, pinned model/recipe-version, recorded seed}` in an isolated namespace against its
own door — the deployed code is **not an input**. So a deploy is either a pure orchestration change → byte-identical
results, or, if it changes economics, that is a **new recipe-version = a new txid = a distinct fact**, never a silent
mutation of an existing one. **Break iff** economics were pinned to the Build-ID (axis 1 fused into axis 2/3) — T-3
already named this exact break for S6, so the SAME guard (I4) defends both. Witness: deploy a new Build-ID
mid-backtest; assert admitted values and backtest results unchanged; assert any economic change surfaces as a new
version/txid, never an in-place rewrite. Pre-argued by I4 + D9 + T-3's axis separation — lowest bite.

**R9 · S5 · clock skew vs the three times (execution / monitor / door) — THE-THREE-TIMES-ARE-RECORDED-VALUES-NOT-WALL-CLOCK.**
The fold is ordered by **recorded execution time** (the as-of on the log), by the total order `(exec, door, hash)`
read from the log (D11/D12, T-1 l.122) — never sampled from a clock at replay — so no skew can reorder it. Durable
timers/schedules are **liveness-only** (R-08/R-09, T-1 l.24), authoring **none** of the three times: a skewed timer
fires early or late, but the transaction it produces is keyed on the recorded as-of/cut, so a skewed fire yields the
**byte-identical transaction** (same txid, S4-absorbed if duplicated). The three times are recorded coordinates —
execution orders the fold, door is the admission stamp (monotone per single writer), monitor/watch is liveness. Skew
degrades to a liveness incident (a watch fires early/late → caught by the overdue-watch sweep), never a reordered
fold and never a different value. **Break iff** the fold ordered on wall-clock sampled at replay, or a timer's
fire-time entered a txid — then skew would mint a different fact. Witness: inject skew across workers and timers;
assert fold order unchanged, assert a skewed timer fire produces the identical txid (S4-absorbed), assert skew
surfaces only as an overdue-watch event. Pre-argued by D11/D12 + R-08 (times-on-the-log) — lowest bite.

---

**Safe to batch R8+R9?** **Yes.** Both are the lowest-bite remaining, both reduce to already-stated invariants (S2 →
I4 axis-non-leak, already exercised in T-3's S6; S5 → times-recorded-not-sampled, D11/D12/R-08), neither adds a
mechanism nor can reopen the design — batch them, provided each **witnesses its firing** and the R6/R7
firing-harvest is delivered alongside (not deferred again).

**On track for round-10 consensus?** **Yes, conditionally.** The highest-bite scenario (S4) held; S3/S6 held with the
honest edge intact; the design is one. Remaining before round 10: (a) the **firing-witness harvest must actually fire**
— the one thing that could still reopen (a precondition never generated = §3 defect); (b) three merge-hygiene closes,
chief being the **key-arity 3-tuple (T-1) vs 4-tuple (T-4)** reconciliation CONCORDIA must land; (c) S2/S5, both
pre-argued. Plausible landing in R8-10 with a clean assembly pass at round 10 — held to the firing harvest, not just its list.

---

## Declaration
Lenses applied: L2, L1, L8, L3, L5, L6 (touching L7). Dismissed: **L4** (no new algorithm or data structure — both
scenarios reduce to existing primitives: unique-key insert, hash-chain revalidation, fold); **L9** (no new numeric —
β is a prior bound, no new float or accumulation); **L10** (no learned component near a safety property). Confidence:
**HIGH** on items 1-5 (each finding carries a cited clause or a named divergence). Single biggest unknown: whether the
owed firing-witness harvest, once run, **fires** for every property — a named property whose precondition is never
generated is a §3 defect that would reopen S3/S6 or COVERAGE-β; that certification is FORMALIS's, not this committee's prose.
