# FORMALIS — Referee feedback, Rounds 6+7 (Temporal Committee, Part II) — S3 + S6 RED-TEAM + r7 FOLD AUDIT

Remit: verdict on S3 (CAN mid CA-sandwich) and S6 (poisoned-cache replay after wipe-rebuild), the
three MEDIUM folds asked for in r5, the one-symbol / clean-key discipline, and any NEW rigor defect
from the r7 edits. Rounds 6-7 of ≥10; no consensus (reserved for ≥round 10). A flag without a
counterexample or a named missing case is discarded.

---

## Item 1 — S3 SANDWICH-CARRIES-NO-WORKFLOW-STATE. **HOLDS** (two wording tightenings, non-load-bearing).
- Granularity is right: the sandwich is *"a sequence of idempotent legs whose completion is a
  deterministic function of the recorded `{cut, nodeId}`"* (T-1 l.154-155); each leg is an
  S4-idempotent door admission keyed by cut (before/after marks differ by cut because the sandwich
  brackets a frame change), the certificate the one kind-3 admission (T-3 l.5, T-4 l.42). Forward-only
  and double-fire-free is proven twice: writer's past-dated synthesis vs substrate's forward re-fire are
  *"disjoint in execution time"* and, *"Even if they did"* both strike, *"the after-mark's txid … is
  identical for both → the door absorbs the second"* (T-5 l.16-17). Correct.
- Tighten (LOW): completion is stated as a function of `{cut, nodeId}` (T-1 l.154) but T-4 l.34 needs
  `{nodeId, pre-cut, post-cut}` — the two cuts are *recovered from the log via nodeId*, not carried; say
  "`{nodeId, cut}` resolved against the log," so the domain is honest. And T-4 l.47-49's counterexample
  ("CAN *drops* the in-memory before-mark → half-sandwich") is the wrong failure mode — a dropped
  un-admitted mark is safely re-struck from the log; the real hazard is T-3 l.7's *carried STALE* mark.
  Containment ("triple-only, struck as projection") closes both; adopt T-3's counterexample.

## Item 2 — S6 LOG-IS-SOLE-TRUTH. **HOLDS**; honest edge stated honestly, not overclaimed.
- All four legs proven: (i) rebuild reads only the log (R-02), cache holds *"no write credential"*
  (I1 fenced lease, T-1 l.160-161, T-2 l.34-35, T-5 (i)/(ii)); (ii) poison cannot inject a state not
  derivable from the log — it reaches only orchestration → propose to door (T-4 l.74-75); (iii) a
  replayed txid is absorbed by the atomic unique-key insert (S4); (iv) a fabricated txid is either
  door-refused as an unresolvable structural reference (R-22) or, structurally-valid-but-uncaused,
  caught by decidable audit-recompute (D7). T-2 l.9-13/25 adds the sharper door: it *recomputes* txid
  from the cause it resolves on the log, refusing any presented txid that mismatches — closing the
  *inconsistent*-txid fabrication at the door, leaving only *economically*-wrong-but-consistent to audit.
- The detection edge is honest: *"economic causality is detection-at-audit, not door-prevention …
  NOT 'no structurally-valid poison ever touches the log'"* (T-4 l.64-72; T-2 l.23 *"overclaiming
  prevention here would be the error"*). Completeness holds by construction (I3 total contract-recompute
  + envelope-first input capture, no cache-injected inputs, T-4 l.74) — timing, not coverage, is the
  edge. No overclaim.

## Item 3 — the three MEDIUM folds. **TWO LANDED, ONE HALF-LANDED (BREAKS as "one-voice").**
- (a) **exact-grained input-cut — LANDED**, consistent: T-1 l.32-34 + I2 l.177-178 ("log-position /
  content-hash, never a coarse label"); T-4 D10 l.16 (iii) verbatim. The injectivity dual is stated.
- (b) **durable-before-ack + quorum-per-lineage — LANDED**, consistent: now in T-1's named invariant I1
  ("acked only after it is durable in the quorum … rejects any append not carrying the current fence
  token … Failover moves the fence, never duplicates it," l.172-175); T-4 D10 (i)/(ii) mirror it.
- (c) **seed one-voice — HALF-LANDED, BREAKS.** The *semantics* are unified (recipe governs seed
  presence; distinct seed ⇒ distinct txid), but the *form* is not: T-1 l.31 + I2 l.175 say a **clean
  3-tuple, "seed subsumed into the recipe term"**, while T-4 D10 l.16 still writes a **4-tuple
  `(input-cut, model-version, recipe/dynamic-version, seed)`** with a conditional slot. Both *claim*
  "one-voice" over two visibly different arities. See Items 4-5.

## Item 4 — β-only + clean-3-tuple-everywhere. **β-only HOLDS; 3-tuple-everywhere BREAKS.**
- **β-only HOLDS.** Grep of all five r7 files finds no live ε_repro/τ; the sole occurrence is T-4 l.5's
  own negation *"no ε_repro/τ anywhere."* The r5 rename-note residual is gone. (Micro: drop even the
  negation at final assembly per §1 "no synonyms, ever" — LOW.)
- **Clean-3-tuple-everywhere BREAKS.** The key is *not* one form: T-1 "clean 3-tuple" (subsumed) vs T-4
  4-tuple (separate conditional slot). Not a correctness break — both are injective and the txid carries
  the same information content — but a **canonicalization defect** (Coquand: only *propositionally*, not
  *definitionally*, equal): two serializations of "the same fact" can hash to different txid bytes across
  two implementations, each following a different file. Pin ONE form (recommend T-1's 3-tuple: seed is a
  recorded parameter *of the recipe term*, so the 3rd coordinate already separates draws). Rewrite T-4
  D10 to the 3-tuple. MEDIUM.

## Item 5 — NEW rigor defect from r7. **One MEDIUM (S3 byte-identity over-claim); rest LOW.**
- **(MEDIUM) The S3 "byte-identical resumed sandwich" over-claims for a kind-2 (model-priced) mark.**
  T-4 l.46 asserts *"the resumed sandwich is byte-identical to the CAN-free one."* True for kind-1
  operator-projected marks. For a kind-2 mark whose leg was computed-but-not-yet-admitted when the CAN
  fired, byte-identity holds ONLY IF the drawn seed was *durably recorded (on the log) before compute
  and reused on resume* — else re-compute re-draws (distinct seed ⇒ distinct recipe-instance ⇒ distinct
  txid), and the guarantee degrades to what T-3 (iii) actually proves: *S4-idempotent, one value
  admitted, β-bounded*. The design says only *"seed recorded before compute"* (T-1 l.31, l.52) — pin
  "recorded to the log, reused on CAN-resume" (the exact-grain analog for the seed), OR soften T-4 l.46
  to the S4-idempotent guarantee that S3-survival actually needs. The property (no half/no double)
  HOLDS either way; the *determinism* wording is what leaks.
- **(LOW)** T-3 l.5 *"the ONLY durable write is the sandwich CERTIFICATE"* is loose — the CA-txn and any
  kind-2 marks are also durable (T-3 self-corrects at (iii)); say "the certificate is the only
  *sandwich-specific* durable write."
- **(LOW)** S6 firing witness is named two ways: T-1 l.186 `prop_wipeRebuildEqualsLog` +
  `prop_fabricatedTxidRefusedOrAudited`; T-4 l.78/97 `prop_poisonedReplayCleanRebuild`; and
  `refold-equals-timely` (T-1) vs `prop_refoldEqualsTimely` (T-2/T-3). Pin one name each so the
  firing-harvest tracks (zero firings = defect, §3).
- No r7 edit introduces a load-bearing *cross-file contradiction* of the r4 env-in-key kind. The three
  LOW/MEDIUM items above are pins/softenings, not open conflicts.

---

## Survival property to DEMAND for the final two scenarios

**S2 — workflow-code deploy mid-backtest → DEPLOY-IS-ORCHESTRATION-ONLY.**
For every backtest history and every workflow-code deploy injected at any step: (economic) the admitted
`(txid, value)` set is invariant — every economic value is a version-pinned fold of terms *on the log*
(ProductTerms / model-recipe / dynamic-version, axes 2/3), and the Build-ID (axis 1) is *not in the
domain of the fold* (I4 axis non-leak, T-3 l.12); (orchestration) the in-flight run stays pinned to its
Build-ID (R-17 Worker Versioning) so deterministic replay is preserved and only *new* runs bind new
code; (isolation) a deploy to the production Build-ID leaves the simulation namespace's admitted set
untouched and vice versa (R-20). Hence a deploy degrades to at most a timing/liveness change — never a
wrong or divergent recorded fact. Witness `prop_deployMidBacktestInvariant`: inject a Build-ID change at
each step, assert admitted set + total order = no-deploy run; MUST fire (zero firings = defect).

**S5 — clock skew vs the three times → CLOCK-SKEW-TOUCHES-NO-RECORDED-TIME-OR-ORDER.**
For every adversarial assignment of per-worker / per-DC wall-clock offsets: the total order over
admitted facts is the door's logical `(exec, door, hash)` sequence at the single writer (D11/D12), and
each of the three times attached to a fact (effective/as-of, observed, recorded) is a *recorded term or
the door's sequence position* — never read from a worker's system clock (R-08: the timer authors *none*
of the three times). Therefore the admitted set, its total order, and every recorded time are invariant
under skew; skew is admissible *only* into watch/timer FIRING (a liveness effect caught by the
overdue-watch sweep). Enforce the negative BY TYPE: a "bare clock read" that stamps a recorded fact from
a worker clock is unrepresentable (the bare-read analog, D1), so R-08 is by-construction, not
convention. Witness `prop_clockSkewInvariant`: adversarial offsets over a history with timers/watches,
assert admitted set + total order + recorded three-times = zero-skew run (only the firing schedule
differs); MUST fire.

---

## Batch call
**YES — safe to batch R8(S2) + R9(S5) into the final red-team cycle before round-10 consensus.** S3 and
S6 both HOLD; S2 exercises axis-1 non-leak (pre-argued by D9/I4/T-3 l.12) and S5 the three-times /
door-order (pre-argued by D11/D12/R-08) — both *orthogonal* to the two open residuals (seed-arity
one-form pin; S3 byte-identity softening), which are MEDIUM pins carrying no cross-file load-bearing
contradiction. Carry the seed-key one-form pin and the byte-identity softening into the r8-9 assembly as
folds, not gates.
