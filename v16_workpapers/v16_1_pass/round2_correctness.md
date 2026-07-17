# v16.1 Round 2 — Correctness review (correctness-architect)

Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`, sec:totalorder + sec:substrate + ch15.
Lenses A1–A4 (coordinator) targeted at the Fix-A synthesis text. Round-1 fixes all verified
landed (timely oracle 6137-6140; quiescent rebuild==timely 1392-1396; stable-triple keys
1284-1292; both-direction synthesis 1226-1232, 1312-1315). Round 2 stresses the machinery
Fix-A introduced. Fixes below are net-neutral or banked against DL-03 (SF-5); none adds a page
unpaid.

---

## A1 (CENTRAL) — Synthesis-driven re-insertion: bounded? confluent? cost honest? — VERDICT: DEFECT

**The printed algorithm does not acknowledge the recursion.** Step (c) (1226-1232) says a
newly-satisfied firing "is emitted at its record-derived execution position" — a **past**
position — but never states that emitting at a past position is *itself an interior insertion*
whose own tail must refold, nor that a refolded tail can synthesize *further* firings. The
"Why it holds" remark (1264-1272) papers over exactly this: it calls the firing-derivation
operator "a deterministic function of the ordered arrivals **alone**" (1266-1267). It is not —
a firing's condition is read off the **folded state**, and a synthesized firing changes state a
later watch reads. So the "closure" is a fixpoint of *interleaved fold-and-derive*, not the
one-shot map the prose implies. This is the Round-1 equivocation (F1's original target)
reappearing one level down.

**Worse — the remark is circular.** 1269-1271 defines the object as "the closure of the
arrivals under the operator" and then "$\mathrm{sort}_<$ of that closure." But the *set* of
synthesized firings **depends on the fold order** (each firing depends on state built in
order), so "the closure" is not a well-defined set you may sort — its well-definedness is the
very thing to prove. The remark assumes confluence to prove equality, then leans on equality
for confluence.

**It is in fact bounded and confluent — but for a reason the draft doesn't give.** The correct
argument is **well-founded induction on execution position**, not a closure-then-sort:

- *No firing lands behind the cursor.* A data-predicate firing's execution time is the instant
  its condition became true — the tipping observation the forward pass has just folded — and a
  scheduled firing on a minted unit is dated at/after that unit's inception (a product-graph
  well-formedness side-condition: **a unit's declared watch dates are ≥ its inception**). So a
  synthesized firing's execution time is always ≥ its triggering event's. It lands *at or ahead
  of* the cursor, never behind.
- *Therefore one forward pass suffices.* Fold the event at the cursor, evaluate armed
  predicates against the running state, fold any newly-derived firing in the same pass as the
  cursor reaches its position. Each event — arrival or derived firing — is folded **exactly
  once**. No re-insertion, no recursion.
- *Termination is inherited, not new.* The firings armed over a finite prefix are finite and
  each fires at most once per watched transition — the **same measure that already bounds the
  timely fold's firing cascade**. If the timely fold terminates, so does the refold, because it
  computes the same object.

**Residual the proof must still discharge (localised for FORMALIS/SF-1):** the *between-
position* part is the well-founded induction above and needs no fixpoint theorem. The genuine
sub-fixpoint is **within a single execution instant** — several firings derived at one instant,
some voiding others (1229-1230). Termination there needs the within-instant sub-operator
monotone (a knock-in is a one-way transition; voiding targets a *different* firing's
consequence, never re-arms) and same-instant firings sequenced by the (door, hash) tiebreak.
That is the exact lemma to prove, not the global closure.

**The cost claim is dishonest.** $O(|\text{tail}|)$ (1281-1283) counts only external arrivals;
the tail now also carries every synthesized firing.

**Fixes (net-neutral rewrites).**
Step (c), append:
> The refold is a single forward pass from the insertion point: at each execution position it
> folds the event there, evaluates the armed predicates against the running state, and folds
> any newly-satisfied firing in the same pass. A derived firing's execution time is the instant
> its condition became true — the tipping observation just folded, or a minted unit's scheduled
> date, never before its inception — so it never falls behind the cursor and no position is
> revisited. Each event, arrival or derived firing, is folded exactly once; the pass terminates
> because the watches armed over a finite prefix are finite and each fires at most once per
> watched transition — the measure that bounds the timely fold.

Replace the "Why it holds" closure-then-sort argument with induction on execution position
(prefix before the insertion point identical in both folds; from there both are the same
deterministic single pass, so they agree position-by-position).

Cost sentence → :
> The refold re-runs fold step over the tail once: $O(|\text{tail}'|)$, where $|\text{tail}'|$
> counts the external arrivals **and** the firings the reordered prefix derives after the
> insertion point. The single forward pass folds each exactly once — no cascade multiplier —
> because no derived firing lands behind the cursor.

## A2 — Producer of a past synthesized firing: writer vs substrate — VERDICT: DEFECT

The two texts **conflate the producers**. sec:totalorder(c) makes the past-dated firing a
**writer/refold output** (1226-1229: single writer's work per 1379-1380; monitor time null;
emitted at its past execution position). But the substrate acceptance test (1392-1396) reads:
"at quiescence — after **the re-read** has deposited its fresh arming and **firing
acknowledgements** — the state rebuilt ... equals the timely state." The re-read, per 1385,
"re-fires **forward** ... never rewinding." So the sentence attributes the past knock-in to a
producer that only fires forward. A reader concludes the substrate deposits the synthesized
past firing — it does not, and cannot (never rewinds). The rebuild then compares against a
firing produced by the *writer's* refold, not the re-read.

**Fix (net-neutral, into 1392-1396):** separate the producers explicitly —
> The past-dated firing the reordered order newly implies is the writer's refold output
> (\S\ref{sec:totalorder}(c)), on the log before any re-read; the substrate's re-read only
> re-fires *forward* on the refolded state. The acceptance test's deposited acknowledgements
> are those forward re-firings; the rebuild reads the past synthesized firing from the log the
> writer already wrote.

This removes the contradiction with ch04's "re-fires forward, never rewinding" (1385) without
weakening the quiescent rebuild==timely test.

## A3 — Missing witness prop_firingSynthesized_fires — VERDICT: DEFECT (cheapest high-value fix)

The property block (6129-6158) has `prop_refoldEqualsTimely` (sound oracle), plus
`_fires` witnesses forcing a *state-changing* refold (6151) and a *cross-unit* one (6155) —
but **none forces a newly-synthesized firing**. The generator can satisfy every property while
never producing the corrected-close-breaches-a-barrier case the strong theorem was rewritten to
cover. Zero firings of the headline case is a defect (§3), not a green test. Supply:
```haskell
-- The case thm:refold EXISTS for: a corrected order that NEWLY satisfies a data-predicate
-- watch, forcing a firing absent from the as-arrived order (monitor time null, cause = late).
prop_firingSynthesized_fires =
  checkCoverage $ cover 1.0 newlySatisfies
    "late arrival newly satisfies a watch -> firing synthesized in refold"
    genBarrierBreachingCorrection
  where newlySatisfies l h =
          any (\f -> isSynthesized f && monitorTime f == Null
                     && execTime f == tippingObs l h
                     && cause f == cid l
                     && not (firedIn (asArrived h) f))
              (firings (refoldState l h))
```
Also confirm `genCrossUnitLateArrival` (6155) can reach a *synthesized firing on V*, not merely
a restated balance on V — else A3's cross-unit and synthesis witnesses never intersect.

## A4 — Snapshot key stability under synthesized firings — VERDICT: DEFECT

The invalidation *mechanism* survives synthesis: a firing F synthesized during the refold of
late arrival e has execution time $\mathrm{exec}_F \ge \mathrm{exec}_e$, so $T_F \ge T_e$, so the
snapshots F would invalidate ($\ge T_F$) are a **subset** of those e already invalidated
($\ge T_e$) — F adds no new invalidation, and F sorts to its correct interior position because
exec dominates the key (1284-1288 hold). **But the key is unstable.** A synthesized firing's
**door time** is assigned when the refold emits it, at refold time — *not* a record fact.
Re-running the refold, or rebuilding from the log, assigns a **different** door time, so:
- `prop_refoldIdempotent` (6142) holds at fold-state but the event *triple* differs between
  runs;
- a snapshot whose last folded event is F has an **unstable key** $T_F$, so the invalidation
  comparison $T_{\text{last}} \ge T_e$ can flip on rebuild;
- it breaks "computable by any party from the record alone" (1164) — door\_F is not on the
  record.

The theorem tolerates this at *state* level (door time is provenance, 1274), but idempotence,
snapshot keys, and party-recomputability do not.

**Fix:** a synthesized firing carries **no door time** — it never crossed the door; it is a
refold derivation. Give it the null/⊥ door that mirrors its null monitor time, so its key is
$(\mathrm{exec}_F, \bot, \mathrm{hash}_F)$ with hash content-derived and record-stable
(sufficient to order it, since exec dominates and hash disambiguates). State this beside the
"monitor time null" clause at 1228 and at the snapshot-key text 1284-1286. Never assign a
synthesized firing a fresh refold-time door stamp.

---

## Blockers
1. **A1** — step (c) does not state the single-pass/no-landing-behind/termination; "Why it
   holds" is circular; cost $O(|\text{tail}|)$ undercounts. Rewrite as supplied. (Joint with
   SF-1/F1: the residual proof obligation is the *within-instant* sub-fixpoint, now localised.)
2. **A4** — synthesized firing door time is not record-derived; make it null/⊥. Breaks
   idempotence + snapshot-key stability + party-recomputability until fixed.
3. **A2** — substrate acceptance test conflates writer (past firing) with re-read (forward);
   separate the producers.
4. **A3** — add `prop_firingSynthesized_fires`; the headline case is currently untested.

## Recommendations
5. Add the product-graph side-condition **watch dates ≥ unit inception** (Chapter objects) —
   it is the hypothesis A1's no-landing-behind lemma rests on; without it a minted unit could
   date a scheduled firing behind the cursor and the single-pass claim fails.
6. SF-2 (CONCORDIA's sweep): the door-time-null rule for synthesized firings must be echoed
   wherever a chapter describes a firing's door time, or ch04 must be named as governing.
