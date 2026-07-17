# v16.1 Review — Round 2 Record

**Supervisor:** TuringAward. **Date:** 2026-07-17. **Draft:** `ledger_v16_1.tex`, **113pp
(1 over the 112 cap)**, compile clean. **Standing reviewers:** FORMALIS, CONCORDIA,
correctness-architect, STYLUS. **Named but unavailable:** kleppmann (recorded, not
substituted — his ch2/ch4-picture lens on the global total order remains the one uncovered
seat; carried since Round 1, SF-4).

Round 1 closed with 14 findings actioned, all landed. Round 1 was **not clean**, so Round 2
stays in **findings mode**, and the lenses point at the **new text** the Fix-A ruling
produced — where a strong new claim now sits on machinery that Round 1 did not yet stress.

---

## 0. Supervision verdict

**State of the new text.** The pen implemented the ruling faithfully and the section reads
well. thm:refold (1257-1262) is now the strong statement — refold fold-state = timely fold of
the same external arrivals, firings re-derived — with its argument correctly demoted to a
"Why it holds" remark (1264-1272) outside the theorem environment (FORMALIS's structural
point, discharged). Step (c) (1226-1232) carries Fix-A clock-free, both directions; the
Interactions paragraph (1308-1315) adds the symmetric false→true synthesis with the
provenance sentence ("which firings are in force is a projection of the ordered prefix");
F2's single-lineage carrier (1165-1171) and fork-order correction (1187-1195) are in; A2's
stable-triple snapshot keys (1284-1292) are clean; the property block (6134-6157) swaps in the
full-pipeline timely oracle and adds idempotence + two coverage witnesses; the substrate test
(1392-1398) is quiescent and compares rebuild to timely. This is a materially stronger
section than Round 1's.

**Biggest risks I see in the NEW text (ranked).**

1. **The strong theorem's proof rests on an unstated fixpoint (central Round-2 question).**
   The remark (1264-1272) says "the operator is a deterministic function of the ordered
   arrivals **alone**." It is not — a firing's condition is read off the **folded state**,
   and a synthesized firing changes state that a later watch reads, which changes which
   firings fire. The "firing-closure" is therefore a **fixpoint of interleaved fold-and-derive**,
   not a one-shot map. The proof needs the closure to be **well-defined** (confluent) and
   **terminating** (no infinite firing cascade over the finite event set) for "the two
   closures are equal" to hold. As written, "function of the ordered arrivals alone" hides
   exactly the premise F1 was corrected for hiding. Either the fixpoint is established
   (monotone operator, finite domain ⇒ unique least fixpoint, order-independent) or the
   theorem is again a strong claim on an unproven base.

2. **Synthesis can create a new interior insertion — is the refold recursion bounded?** A
   firing synthesized in step (c) carries its **own** record-derived execution position, which
   may fall **behind** the refold cursor (the knock-in sits at Tuesday's close; other tail
   events may already be folded past it). Emitting it "at its execution position" then demands
   a further insertion + refold — the algorithm recurses. Nothing in step (c) or the cost
   analysis (1281-1283, "O(|tail|)") accounts for synthesis-driven re-insertion or shows it
   terminates. This is the L3/L4 twin of risk 1, on the algorithm rather than the theorem.

3. **Fix-A is stated globally in ch04 but the watch-bearing chapters were not re-threaded.**
   The firing-derivation rule lives only in sec:totalorder. Valuation watches (ch05/ch09),
   due-date/settlement watches (ch11), and event-kind routing (ch08) still describe firing as
   Monitor-emission with no acknowledgement that a refold re-derives their firings. If a
   valuation-watch or due-date-watch predicate does not compose with clock-free re-derivation
   the way the barrier predicate does, Fix-A is locally true and globally incomplete —
   precisely the composition seam the coordinator directed the lenses at.

4. **The strong theorem's headline case (false→true synthesis) has no firing witness.**
   `prop_refoldEqualsTimely` (6137-6140) is a sound oracle, but its precondition is only
   `insertsBeforeHead`. `prop_refoldChangesState_fires` forces a state-changing refold and
   `prop_reorderCrossUnit_fires` a cross-unit one — **neither forces a newly-synthesized
   firing.** The generator could satisfy every property without ever producing the
   corrected-close-breaches-a-barrier case the theorem was rewritten to cover. Zero firings of
   the headline case is a defect (§3), not a green test. A `prop_firingSynthesized_fires`
   witness is missing.

**Standing constraint.** File is **113pp, 1 over**. DL-03 (consolidate 17 clause-discharge
openers into one ch16 traceability table, ~1pp) is before the Panel and is the sanctioned
route back under cap — a coordinator/owner matter, not a reviewer lever. **No reviewer may
propose a page-adding remedy.** Every Round-2 finding's fix is net-negative or explicitly
banked against DL-03; a fix that grows the file is incomplete until it names its displacement.
Correctness still outranks the cap (§7): a correctness fix that cannot be paid for escalates
the page, it is never dropped.

---

## 1. Round-2 lens assignment (targeted at the new text)

### FORMALIS — does the strong theorem's proof carry under Fix-A?
- **F1.** The "Why it holds" remark (1264-1272) calls the firing-derivation operator "a
  deterministic function of the ordered arrivals alone." Is the **firing-closure a
  well-defined fixpoint**? State the operator precisely (fold-step interleaved with
  predicate re-derivation), show it is **monotone** and the event domain **finite**, and
  conclude a **unique** closure independent of arrival order — or rule the theorem
  asserted-not-proved and supply the exact missing lemma. This is the Round-2 central question.
- **F2.** The theorem fixes "the same **external arrivals**" and re-derives firings. Is the
  partition crisp? A Monitor-**emitted** event is not external (monitor time null): does the
  closure operator re-derive the **entire** emitted substructure — watch **declaration**,
  **arming** acknowledgement, **firing** — or only "firings" as the prose (1226) literally
  says? If armings/acknowledgements are in the set but not in the operator's range, the
  partition is inconsistent and the closure equality fails. Pin the operator's domain.
- **F3.** `prop_refoldIdempotent` (6142) and the memo-P4 pointer (1253): under Fix-A the
  reorder now includes synthesis. Does idempotence still hold when the **second** reorder
  re-derives firings over an already-synthesized closure — i.e. is the closure operator
  **idempotent**, not just `sort_<`? Confirm the memo proof covers the post-Fix-A operator,
  not the Round-1 consequence-only refold.

### CONCORDIA — does firing-derivation compose with the recorded-firing doctrine everywhere watches appear?
- **C1.** Walk ch05 (valuation watches), ch09 (margin/collateral watches), ch11 (due-date /
  settlement watches). Does each chapter's firing description **contradict** or merely **not
  mention** the ch04 re-derivation? A chapter that says a watch "fires when the Monitor
  observes" without the "re-derived on refold" qualification is a global-consistency defect if
  a reader concludes those firings are fixed inputs. Name every site that must carry a
  back-reference to step (c), or confirm the ch04 statement governs by the one-name-one-place
  rule (§1).
- **C2.** C-4.12 (finite, closed, declared event universe; total routing). A **synthesized**
  firing (cause = the correction, monitor time null) must be a **registered kind with total
  routing** like any event. Is a synthesized firing's kind within the declared universe? What
  happens when a synthesized firing is **unroutable** — does the quarantine guarantee (which
  the Interactions paragraph invokes only for *late arrivals*, 1318-1323) extend to
  *synthesized* firings, or is there a gap? Reconcile with C-4.12 or flag.
- **C3.** The provenance doctrine (958, 972-986, C-12.5): the Interactions text (1312-1315)
  says synthesized firings take "the correction" as cause. Is that a **legitimate cause under
  the cause-derived-identifier rule** (`txid = H(cause, contract, unit, seq)`, sec:txexec)?
  The correction is one cause firing potentially many synthesized firings across many units —
  does the seq/unit keying keep them injective (the sec:txexec cascade argument), or does
  synthesis introduce a collision the Round-1 injectivity proof did not cover?

### correctness-architect — refold determinism and the writer/substrate seam under synthesis
- **A1.** **Synthesis-driven re-insertion (risk 2).** Trace a synthesized firing whose
  execution position is behind the refold cursor. Does step (c) recurse correctly? Is the
  recursion **bounded** and **confluent** (same final state regardless of synthesis order)?
  Is the O(|tail|) cost claim (1281-1283) still true, or is it O(|tail| × firing-cascade
  depth)? Supply the termination argument or flag it missing.
- **A2.** **Writer/substrate division for past firings.** The refold (writer) synthesizes a
  firing at a **past** execution position (step c); the substrate re-read "re-fires
  **forward** ... never rewinding" (1385) and "deposits its fresh arming and firing
  acknowledgements" (1393-1394). Who writes the **past-dated** synthesized knock-in — the
  writer's refold or the substrate? If the acceptance test (1392-1398) expects the re-read to
  deposit it, but the re-read only fires forward, the test is comparing the wrong producer.
  Confirm the past firing is writer-side (step c) and the substrate only re-fires forward on
  the refolded state, and that the prose does not conflate the two producers.
- **A3.** **Headline firing witness (risk 4).** `prop_refoldEqualsTimely` can pass without
  ever generating a false→true synthesis. Specify the missing coverage witness —
  `prop_firingSynthesized_fires`: the generator must produce a corrected observation that
  **newly satisfies** a data-predicate watch (barrier/threshold) whose firing did not exist in
  the as-arrived order — and assert it fires (§3). Also confirm `genCrossUnitLateArrival`
  reaches a synthesized firing on unit V, not merely a restated balance on V.
- **A4.** **Idempotence + snapshot interaction under synthesis.** A2's stable-triple keys
  (1284-1292): a **synthesized** firing gets its own (exec, door, hash) — but its **door** is
  assigned when the refold emits it, at refold time, not at the original insertion. Does a
  synthesized firing's triple sort to the right interior position, and does snapshot
  invalidation (`T_last ≥ T_e`) stay correct when `T_e` is itself a synthesized event whose
  door time is later than the arrivals around it? Check the key space is still monotone.

### STYLUS — is Fix-A stated once, in the right home, no re-establishment?
- **S1.** The firing-derivation rule now appears at step (c) (1226-1232), the Interactions
  synthesis sentence (1312-1315), the theorem remark (1264-1272), and the substrate test
  (1394-1396). Which site **establishes** the rule and which **refer**? Step (c) is the home.
  Flag any of the other three that re-defines rather than points; in particular whether the
  remark's "closes the ordered prefix under the firing-derivation operator" and Interactions'
  "which firings are in force is a projection" are two establishments of one idea.
- **S2.** Clock-free-ness of the re-derivation is asserted at 1230-1231 ("reads the record,
  not the clock"), 1268 ("the clock is never read"), and implied at 1379. State-once audit:
  the clock-confinement claim already has a home (ch04 Monitor, and the theorem hypothesis
  1277-1279). Flag the redundant tellings; keep the one the proof needs.
- **S3.** Writer/substrate clarity (pairs with A2). Does the substrate paragraph (1382-1398)
  make the reader see that **past** synthesized firings are the writer's refold and **forward**
  re-firings are the substrate's re-read? If a strong undergraduate reads "the re-read has
  deposited its fresh ... firing acknowledgements" as covering the synthesized knock-in, the
  prose conflates two producers. Propose the one-clause fix (net ≤ 0).
- **S4.** Covered-call trace (1358-1371) now cites (C-12.6) at 1364 — good. Confirm the trace
  still reads as **one** worked instance of step (c), not a re-statement of the rule, and that
  "each order's implied watch firings re-derived" (theorem 1261) is not silently re-glossed in
  the trace where a pointer suffices.

---

## 2. Supervisor flags (must not be missed)

- **SF-1 — the fixpoint (risks 1+2).** The Round-2 central defect-candidate. F1 and A1 own it
  from the proof and the algorithm sides; I am elevating it so no reviewer treats the strong
  theorem as settled. If the firing-closure is not shown well-defined and terminating, the
  strong theorem is the Round-1 equivocation reappearing one level down. It is likely fixable
  by a short lemma (monotone operator over a finite event domain ⇒ unique closure), but it
  must be **proved, not asserted** — the same bar F1 set.
- **SF-2 — global composition (risk 3).** Fix-A is a **model commitment** (Round-1 ruling)
  and a model commitment stated in one chapter must not be contradicted in another. CONCORDIA
  C1/C2 own the sweep across ch05/ch08/ch09/ch11. A silent non-mention is tolerable under
  one-name-one-place; a **contradiction** (a chapter treating firings as fixed inputs) is a
  global-consistency defect and, if it cannot be reconciled, a PARK candidate.
- **SF-3 — headline case untested (risk 4).** The strong theorem exists **for** the false→true
  synthesis case; a property regime that never generates it witnesses nothing (§3). A3 owns
  the missing `prop_firingSynthesized_fires`. This is the cheapest high-value fix of the round.
- **SF-4 — kleppmann still unavailable.** The global-total-order picture (his ch2/ch4
  authorship) is exactly what the fixpoint question stresses; no independent seat holds it.
  correctness-architect A1 and FORMALIS F1 jointly cover the ground; the residual is logged.
- **SF-5 — 113pp / DL-03.** No page-adding remedies. `prop_firingSynthesized_fires` (A3) and
  any fixpoint lemma (F1) add lines; they must be banked against DL-03's ~1pp recovery or paid
  by ornament. If a correctness fix survives compression and still overflows, escalate the
  page to the coordinator — correctness paramount (§7), never dropped to fit.

**Dispute resolution.** Colliding findings come to me; I rule and record it. The Fix-A model
commitment is now load-bearing, so the round-5 certifier signatures (CONCORDIA, FORMALIS)
must specifically cover: (i) the firing-closure is well-defined and terminating (SF-1), and
(ii) firing-derivation is globally consistent across every watch-bearing chapter (SF-2).
Convergence among reviewers is necessary, not sufficient — the signatures decide.

---

# ROUND-2 RULING (TuringAward, supervisor) — 2026-07-17

All four Round-2 files read. This rules the five compositions the coordinator posed, produces
the dependency-ordered accepted list, answers every finding, and gives the page verdict.
kleppmann still unavailable; not substituted (SF-4).

**Anti-bias note on myself (§4.4).** My Round-2 SF-1 proposed Knaster–Tarski (monotone least
fixpoint). FORMALIS is right and I was wrong: the operator is **non-monotone** — a late
arrival can *remove* a firing (the covered-call record-date firing disappears once the shares
leave Tuesday), so `S ⊆ S' ⇏ derive(S) ⊆ derive(S')`. Knaster–Tarski does not apply. Uniqueness
is by **well-founded recursion on the execution-time order**, not a monotone lattice. Recorded,
not buried.

## A. The five compositions — rulings

**Composition 1 — F1's well-founded recursion = A1's single forward pass. RULED: one
treatment, and A1's side condition is a FOURTH hypothesis, not an instance of H-WF.**
They are the same construction: well-founded recursion on a well-order *is* a single pass in
that order. Merge into one printed treatment — `lem:closure` states existence / uniqueness /
termination / confluence by well-founded recursion on `<`; the algorithm text in step (c) is
A1's single forward pass (its constructive content); A1's cost `O(|tail'|)` replaces the
undercount. **The key ruling the coordinator asked for:** A1's side condition — *a derived
firing's execution time ≥ its trigger's; scheduled watch dates ≥ unit inception* — is **NOT**
an instance of H-WF. H-WF makes the arming cascade finite in *depth*; the side condition makes
it monotone in *execution time* (no firing lands behind the cursor). They are independent (a
finite cascade can still date a firing behind its trigger; forward-dated firings can still
chain infinitely). More: the side condition is needed for `lem:closure`'s **existence** clause
itself, not merely single-pass efficiency — F1's "the dependency strictly decreases in `<`"
is only coherent if a firing's trigger sits at or below its own position, which is exactly what
the side condition guarantees. F1's three-hypothesis lemma is therefore **incomplete**; A1
plugs the hole. **Print FOUR hypotheses:** H-FIN, H-WF, **H-FWD** (= A1's side condition), H-INERT.
 - **Page-efficient placement:** H-FWD is a product-graph well-formedness condition — state it
   **once in ch03** (objects/product-graph: scheduled watch dates ≥ unit inception) and have
   `lem:closure` **cite** it, not restate it. The data-predicate half of "no landing behind" is
   free (a data firing's exec = the tipping observation just folded), so H-FWD is only the
   scheduled-watch clause.
 - **A1's within-instant sub-fixpoint — SUPERSEDED, no sub-lemma.** A1 localised a residual
   fixpoint to "several firings at one execution instant, some voiding others." It dissolves:
   a voiding interaction is **non-commuting**, and C-2.7 / DL-01 already forbid the door
   tiebreak from silently ordering a non-commuting same-instant pair — such a pair is
   **precedence-ordered by the product's declared terms** (an autocall's knock-out-before-coupon)
   or **refused**. So within an instant the forward pass follows declared precedence (or the
   pair never folds); the door/⊥/hash tiebreak only ever orders **commuting** pairs; H-INERT
   handles the voided firing's no-op re-run. No monotone-sub-operator lemma is printed — this is
   simpler and constitutionally grounded, and it saves page.

**Composition 2 — A4's ⊥ door time. RULED: adopt ⊥ in the total-order key; it strengthens
recomputability; it does not affect fold state; no park, certifier-flagged.**
 - *Defined position (the coordinator's question a):* the total-order key of an emitted firing
   is `(exec, ⊥, hash)`, where **⊥ sorts before all real door times within one execution
   instant** and hash disambiguates two ⊥-door firings at one instant (H-CR). The door slot's
   domain gains a minimal element ⊥; C-2.7's `(exec, door, hash)` shape is preserved — an
   emitted firing's door "assignment" is honestly "did not cross the arrival door." The firing
   still occupies a real physical position in the **hash chain** (its refold-append position,
   provenance); only the **meaning** total order uses ⊥. This is the draft's own "two orders
   over one log" (1197–1203), not a new concept.
 - *Fold state is insensitive to ⊥'s exact position*, because the door/⊥ tiebreak orders only
   **commuting** pairs (non-commuting simultaneity is refused/precedence-ordered, comp. 1). So
   the timely world (where the same firing crossed the door with a *real* door time) and the
   refold world (⊥) reach the **same fold state** — `thm:refold` survives the door-time
   discrepancy. To keep the *key* identical across the two worlds, an emitted firing sorts with
   ⊥ **universally** (both paths), its real admission door retained only as hash-chain provenance.
 - *Recomputability (question b):* ⊥ **strengthens** "computable by any party from the record
   alone" (1164). A refold-time real door stamp would differ per run and is **not** on the
   record — that is the violation; ⊥ is record-derived and identical for every party and every
   rerun. `lem:closure`'s recursion runs on the order with ⊥ at this position; FORMALIS's lemma
   text absorbs it. **No park** — ⊥ is a faithful null within C-2.7 — but this is exactly the
   model-commitment seam the round-5 certifiers must sign; conditional park if drafting shows
   C-2.7 needs amending to admit a ⊥-door event (I judge it does not).

**Composition 3 — F3's absorption cid and C3's `(correction, watch)` key are THE SAME
identifier. RULED: one canonical definition.** A synthesized firing is an **event**; its event
identifier must be (i) **stable** so the second reorder pass **absorbs** it, not re-emits it
(F3's idempotence), and (ii) **injective** across the fan-out of one correction newly satisfying
several watches — even several on one unit (C3; `seq` discriminates legs *within* one firing,
not distinct firings). Both are the same object. **Canonical form:** the synthesized firing's
cause-derived identifier keys on `H(correction event, watch, occasion)` — the **watch** is the
discriminator that separates distinct firings on one unit (an autocall barrier vs a coupon
barrier), `occasion` separates edges of a watch that fires on several (trivial for a one-shot).
Its proposed *transactions* then key on the firing as cause with `seq` as before (Round-1
injectivity intact, one layer down). Define this once near step (c) / sec:txexec; F3 and C3
both reference it. No new constitutional text.

**Composition 4 — F2's armings-in-domain and C2's routable-by-construction. RULED: compose
over the common widened domain.** F2 is right that the operator's domain is **all Monitor
emissions** — arming acknowledgements *and* firings — not "firings" alone (an arming is a
Monitor emission, a projection of the folded prefix, exactly like a firing; a watch declaration
is contract-written and already recomputed by the ordinary fold). C2's "carries the watch's
registered kind, routes by construction, never quarantined" then attaches to that **whole**
widened domain: a synthesized **arming** acknowledgement, like a synthesized firing, carries the
watch's registered handshake kind (a watch cannot arm unless its kind is registered with a
router, C2/ch08) and routes by construction. **One combined clause**, phrased over "every
synthesized Monitor emission (arming acknowledgement and firing alike)," covers both F2's domain
widening and C2's routability. A superseded **arming** (not only a superseded firing) keeps its
recorded event, its consequence voided (F2's second half).

**Composition 5 — S-items apply AFTER the lemma. RULED: strict ordering.** STYLUS correctly
HELD its remark rewrite (re-telling 3) pending the lemma and flagged that its de-dup must not
restyle the unproven fixpoint as settled. Once `lem:closure` lands, the words "closure" and
"deterministic" are backed by it; STYLUS's HOLD is **released**, and its remark de-dup points
to `lem:closure` (the proved statement), not to a bare "(step (c))". All S-items sequence after
items 1–6 so every dedup pointer references proved text.

## B. Dependency-ordered ACCEPTED-CHANGES list for the pen

1. **H-FWD in ch03** — product-graph well-formedness: scheduled watch dates ≥ unit inception
   (A1 rec#5). Lands first; `lem:closure` cites it. ~+1 line.
2. **`lem:closure` + single forward pass** (merge F1 + A1). Step (c): A1's single-forward-pass
   rewrite (net-neutral) + honest cost `O(|tail'|)`. "Why it holds": replace the circular
   closure-then-sort with a pointer to `lem:closure`; lemma states existence/uniqueness/
   termination/confluence by well-founded recursion on `<`, hypotheses **H-FIN, H-WF,
   H-FWD (→ch03), H-INERT**, all *named and labelled, not proved* (veto bar). Within-instant:
   cite C-2.7/DL-01 precedence-or-refuse; **no sub-lemma**. ~+0.4pp.
3. **Operator domain = all Monitor emissions** (F2). Step (c) first clause widened to arming
   acknowledgements + firings; superseded arming voided too. ~+1 line.
4. **⊥ door for emitted firings** (A4 + comp. 2). Total-order key `(exec, ⊥, hash)`, ⊥ before
   real door within an instant, universal for emitted firings; state at 1228 and the
   snapshot-key text (1284–1286); recomputability clause strengthened. ~+2 lines.
5. **Canonical synthesized-firing identifier** (merge F3 + C3). `H(correction, watch, occasion)`,
   defined once near step (c)/sec:txexec; F3 idempotence proof (1252–1255 rewrite) and C3
   same-unit multi-watch injectivity both reference it. ~+2–3 lines.
6. **Registered-kind / routing clause over the widened domain** (C2 × F2). One clause into
   1313–1314: every synthesized Monitor emission carries the watch's registered kind, routes by
   construction, never quarantined. ~net 0.
7. **Properties** (A3 + F3 witness + FORMALIS outside-lens). Add `prop_firingSynthesized_fires`
   (A3); strengthen `prop_refoldIdempotent_fires` to force a first-pass synthesis (F3); one
   comment that `prop_refoldEqualsTimely` assumes closure finiteness (H-FIN/H-WF) so a hang is
   not read as a pass. ~+0.2pp.
8. **Producer split** (A2 via S3). Writer synthesizes past-dated firings (step c); substrate
   re-fires forward only; acceptance-test opener de-ambiguated. ~net 0.
9. **S-items** (after 1–6). S1 Interactions collapse (−5), remark de-dup → cite `lem:closure`
   (HOLD released), S2 clock-free trim (−0.5), verb-synonymy: **"synthesise(d)"** the one name
   for producing the firing, "re-derive" the operator computing *which* firings hold, first-use
   moved to step (c). Net ≈ **−6.5 lines**.
10. **DL-03 consolidation** (−1pp) — executes in the **same application step**, conditioned on:
    the ch16 traceability table proven **bijectively complete** before any opener is removed;
    one-line clause-discharge stubs stay; **CONCORDIA re-runs the cross-chapter sweep green in
    round 3**. This is now the **load-bearing** page recovery, not optional.

## C. Rejected / superseded (recorded)
- **Knaster–Tarski / monotone least fixpoint** (my SF-1 instrument) — REJECTED: operator
  non-monotone; use well-founded recursion on `<`.
- **A1's separate within-instant sub-fixpoint lemma** — SUPERSEDED by comp. 1's
  precedence-or-refuse ruling (C-2.7/DL-01); simpler, grounded, saves page.

## D. Every finding answered
| Finding | Verdict | Disposition |
|---|---|---|
| F1 firing-closure fixpoint (veto-grade) | DEFECT accepted | item 2 (`lem:closure`, +H-FWD from A1) |
| F2 operator domain omits armings | DEFECT accepted | item 3 (widen to all Monitor emissions) |
| F3 idempotence over closure + absorption | DEFECT accepted | items 5, 7 (canonical id; witness) |
| F1 outside-lens: oracle termination | accepted | item 7 (finiteness comment) |
| A1 single pass / no-landing-behind / cost | DEFECT accepted | item 2 (merged with F1); within-instant superseded |
| A2 producer conflation | DEFECT accepted | item 8 (via S3) |
| A3 missing `prop_firingSynthesized_fires` | DEFECT accepted | item 7 |
| A4 ⊥ door time | DEFECT accepted | item 4 (⊥ sort position + recomputability) |
| A1 rec#5 watch dates ≥ inception | accepted | item 1 (H-FWD in ch03) |
| A1 rec#6 echo ⊥/governing | accepted | ch04 governs (CONCORDIA C1 found no contradiction); no per-chapter echo |
| C1 global composition sweep | CLEAN | no change |
| C2 synthesized firing kind/routing | FINDING accepted | item 6 (composed with F2) — 0 parks |
| C3 identifier injectivity fan-out | FINDING accepted | item 5 (composed with F3) — 0 parks |
| S1 re-tellings dedup (HOLD on 3) | accepted | item 9 (after lemma; HOLD released) |
| S2 clock-free re-assertions | accepted | item 9 |
| S3 producer clarity | accepted | item 8 |
| S4 covered-call trace | PASS | no change |
| S verb synonymy + first-use | accepted | item 9 |
| S "closure" first-use flag | resolved | item 2 (lemma makes closure a proved object) |

**Accepted: 15 findings actioned (items 1–10). Rejected/superseded: 2 (Knaster–Tarski;
within-instant sub-lemma). Parks: 0 (⊥-door and the firing-closure are constitutionally
licensed; one conditional park flagged if drafting shows C-2.7 needs ⊥ admitted by amendment).**

## E. Page verdict — TIGHT; DL-03 mandatory; escalation armed
Additions run larger than the coordinator's arithmetic assumed: lemma ~+0.4pp, plus
properties (~+0.2pp), identifier + ⊥ + domain + kind clauses (~+0.15pp), and H-FWD (~+0.02pp)
— roughly **+0.75pp** of additions against **−0.13pp** (S-items) and **−1.0pp** (DL-03). Net
≈ 113 − 0.38 ≈ **112.6pp**, which renders **113 unless compression tightens**. Ruling: **DL-03
is now load-bearing and required** — the set lands ≤112 **only** with DL-03 executed + all
S-cuts + the lemma held to its minimal named-hypotheses form (stating four hypotheses, not
proving them, is the veto bar and keeps it short). If after DL-03 + S-cuts + maximal
compression the file still exceeds 112, that is a **cap-vs-correctness conflict → escalate to
the coordinator; correctness wins (§7)**. The lemma and its four hypotheses are irreducible
(FORMALIS: without them thm:refold stands unproven, VETO holds); **no correctness item is
dropped to fit the cap.**

**Certifier chain (round 5) must additionally sign:** (i) `lem:closure` is well-defined and
terminating under the four named hypotheses (SF-1); (ii) the ⊥-door key preserves C-2.7's
total order and party-recomputability (comp. 2); (iii) firing-derivation is globally
consistent across every watch-bearing chapter (SF-2, CONCORDIA C1 clean this round, re-run
after DL-03).
