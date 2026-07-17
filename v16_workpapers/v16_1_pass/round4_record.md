# v16.1 Review — Round 4 Record

**Supervisor:** TuringAward. **Date:** 2026-07-17. **Draft:** `ledger_v16_1.tex`, **113pp
(1 over the 112 cap — the pen's honest floor, carried as a STANDING CERTIFICATION ITEM)**,
pdflatex ×2 clean, WIP now committed to git (baseline exists). **Standing reviewers:**
FORMALIS, CONCORDIA, correctness-architect, STYLUS. **Named but unavailable:** kleppmann
(recorded, not substituted — SF-4, carried since Round 1).

Round 3 closed with 15 findings actioned + the ⊤ ruling; A2 was held to this round pending the
cut manifest, now on disk (`cut_manifest_r2.md`). Round 4 stays in **findings mode**; a
reviewer returning clean **switches to red-team** on the fresh, harder scenarios in §2.

---

## 0. Supervision verdict

**State of the draft.** The Round-3 ruling landed cleanly and I spot-checked the application:
the ⊤ flip is consistent across all four sites (step c 1234–1237, lemma key 1303, snapshot
slot 1350–1351, forward pass) with **no stray ⊥** — every `\bottomrule` is a LaTeX table rule,
not the bottom symbol. The derivation-order tiebreak, the ⊤–⊤ hash-tie, and H-CR are merged
into `lem:closure`'s existence clause (1313–1318). The normative serialization paragraph
(1445–1452) reads exactly as ruled — completion + quiescent-only-observable (a) and
interleaving convergence with the DL-01 residual (b). The hypothesis-label split is honest
(1330–1333): H-WF and H-FIN(finiteness) are structural obligations, "a violated finiteness
**hangs** the closure, it does not fail a test." occasion is defined (1239–1241); re-arming is
in the domain (1227–1229). This is the strongest state the section has reached.

**Standing item.** The file is **113pp, 1 over** — the pen reports this as its honest floor,
every remaining tail item normative or protected. This is a **DEFERRED-TO-OWNER certification
item**, not a defect to engineer away by cutting correctness: the owner has raised the cap
twice before, and the cap is the owner's to move — never an agent's. Rounds 4–5 dedups **may**
recover the page; if they do not, it ships to certification with the 1-over recorded and the
owner's ruling awaited. **No reviewer may drop a witness, a normative sentence, or a proof step
to hit 112.**

**Where the new text is most likely still wrong (ranked).**
1. **A2 — the six category-(b) cuts (correctness-architect, primary this round).** Two carriers
   look thinner than the deleted span. (b5) deleted "one writer per fact, **one home per fact**
   … no second home to hold a rival copy," and cites `inv:writer` (which carries *one writer*)
   plus a surviving "not a second store" clause — but **"one home per fact"** may not be carried
   by either. (b3) deleted "totality is what turns 'never improvised at read' into a **checkable
   property**," citing `prin:sched-total` (which states totality *normatively*) — the
   **checkability** framing may have gone unless a requirement (B3) carries it. These are the
   two most likely genuine losses; the other four (b1/b2/b4/b6) map cleanly onto their carriers
   on my read but must be diffed, not trusted.
2. **The derivation-order "tiebreak" vs the "non-commuting → precedence/refuse" rule
   (FORMALIS).** Two ordering rules now sit adjacent in the lemma: 1310–1313 (any same-instant
   non-commuting pair → declared precedence or refusal, C-2.7/DL-01) and 1313–1318 (same-instant
   *synthesised* emissions → derivation/causal order; commuting → hash). A causally-**dependent**
   synthesised pair is not the DL-01 ambiguous case — its order is *forced* by causality, not a
   coin-flip, so "tiebreak" is loose shorthand for the recursion's spine. The seam is only clean
   if **causally-independent synthesised emissions always commute** (so hash never silently
   decides a non-commuting pair, preserving DL-01). That implication needs confirming, not
   assuming.
3. **Serialization paragraph — clause anchor and no new guarantee (CONCORDIA).** It is fresh
   normative text. Which clause does it discharge — C-2.7's single-writer sentence, C-2.8
   simulability, or does "only the quiescent closure is committed and observable" introduce a
   guarantee not traceable to any clause? If the latter, it is a PARK candidate; if it is an
   elaboration of C-2.7/C-2.8, the GREEN gate already covers it (both route to ch:machines).

**Anti-bias, continued (§4).** My Round-2 ⊥-before call is corrected on the record (Round 3).
I remain **recused as author of the ⊥ call**: on any residual ⊥/⊤ question FORMALIS and
correctness-architect adjudicate, I rule only on their findings.

---

## 1. Round-4 lens assignment

### correctness-architect — close A2 against the manifest (primary)
- **A1 (close A2).** Diff each of the six category-(b) cuts (`cut_manifest_r2.md`) against its
  claimed carrier and **RESTORE anything the carrier does not actually carry**. Apply the
  Round-3 5-item load-bearing checklist plus these two priors: **(b5)** confirm "one home per
  fact / no second home" is carried (not only "one writer" via `inv:writer` and "not a second
  store") — if only the writer half survives, restore the home half; **(b3)** confirm the
  **checkability** of adjustment-schedule totality is stated somewhere (requirement B3 or
  `prin:sched-total`) — if only the normative totality survives, the "checkable property"
  framing is a loss to restore. Report KEEP-CUT / RESTORE per cut, with the exact carrier text.
- **A2.** Spot-check three appendix cuts (the ~27 non-(b) removals) that touch a *proof or
  invariant* rather than pure flourish — e.g. #16 (C-12.1 discharge compression, ch:invariants),
  #22 (M/V/B requirement recap), #10 (ch:virtual no-second-store recap). Confirm none removed a
  load-bearing step, only recapitulation.
- **Red-team (if A1/A2 clean) — RT-D + RT-B (§2):** confluence under conflicting corrections;
  nested lateness.

### FORMALIS — drift check, the tiebreak seam, serialization determinism
- **F1.** Verify the **printed** ⊤ / derivation-order / hash-tie text matches the adjudicated
  ruling **exactly** — no drift in the pen's application. In particular: is 1313–1316's "the
  **causal order** the forward pass builds, record-derived and reproducible by any party" the
  canonical causal order (a function of the record), or does "the forward pass builds" leave it
  a **traversal artifact**? Party-invariance requires the former; confirm the wording.
- **F2.** The tiebreak seam (verdict risk 2): confirm 1310–1313 and 1313–1318 compose — a
  causally-dependent synthesised pair is the recursion's spine (not a DL-01 tiebreak), and
  **causally-independent synthesised emissions always commute**, so the hash never decides a
  non-commuting pair. If two independent synthesised emissions can non-commute (e.g. both write
  one field), the hash silently decides a non-commuting pair, breaching DL-01 — find such a pair
  or prove it cannot exist.
- **F3.** The serialization paragraph (1445–1452): are its determinism claims **consistent with
  `lem:closure`**? "Any interleaving of late arrivals reaches one quiescent closure" — is that
  the lemma's uniqueness (a function of the arrival *set* + triples) plus idempotence, or a
  stronger claim about admission scheduling the lemma does not license? Confirm "the sole
  residual is a same-instant non-commuting pair" is exactly `lem:closure`'s within-instant hook.
- **Red-team (if F1–F3 clean) — RT-A + RT-C (§2):** void-and-synthesise at one instant;
  self-undermining chain (H-WF acyclicity under maximal stress).

### CONCORDIA — the new normative text's clause anchor; gate still GREEN
- **C1.** The serialization paragraph (1445–1452) is NEW normative text. **Which clause does it
  discharge?** Name it (candidate: C-2.7 single-writer + C-2.8 simulability, both routed to
  ch:machines). Confirm it introduces **no guarantee untraceable to a clause** — in particular
  "only the quiescent closure is the specified, committed, observable state" must be an
  elaboration of an existing clause, not a new constraint on projections. If untraceable, draft
  the PARK; if traceable, confirm the traceability table already covers it (no new row needed).
- **C2.** Re-verify the DL-03 **GREEN gate survives the Round-3 diffs**: the C-4.12 stub mirrors
  landed at 907, 5398, 6590; the caption precision (primary-column "exactly once" + *also*
  read-instruction) did not alter the 116-clause two-way partition; the DL-01 de-jargon (change
  log) still matches `decision_log.md` DL-01 (accuracy preserved after "R-conform" struck).
- **Red-team (if C1/C2 clean) — RT-E + the C-12.4 contest angle of RT-B (§2):** duplicate
  arriving after its original was superseded by a refold; a late correction of a late arrival
  routed through the distinct-cid C-12.4 channel.

### STYLUS — style of the Round-3 additions; final dedup toward the page
- **S1.** Style-review the Round-3 additions: the serialization paragraph (1445–1452), the
  tiebreak/hash-tie sentences (1313–1318), the occasion clause (1239–1241), the re-arming clause
  (1227–1229), the hypothesis-label split (1330–1333). Are they clear, one-result-per-sentence,
  no re-establishment of what `lem:closure`/step (c) already own? Flag any that re-tell.
- **S2.** Hunt **final net-negative dedup** toward recovering the 1-over — without harming
  clarity and without touching a witness, a normative sentence, or a proof step. Report the
  exact line arithmetic and whether 112 is reachable honestly. If it is not, say so plainly:
  the residual is the owner's cap call, not a cut to force.
- **S3.** First-use and one-name integrity after the Round-3 additions: "occasion", "derivation
  order", "quiescent closure", ⊤ ("canonical top value") — each defined at first use, one name
  per concept, no synonym drift (e.g. "top element" vs "canonical top value" vs "⊤").

---

## 2. Fresh red-team scenarios (harder than the brief's four)

Assigned as the "if clean" track; each is designed to stress a specific new mechanism.

- **RT-A (FORMALIS) — void-and-synthesise in one instant chain.** A late arrival whose refold,
  at one execution instant, **voids** firing F1 (true→false, H-INERT) **and synthesises** firing
  F2 (false→true) where F2's predicate reads state F1's voiding changed. Does the derivation
  order place F2 correctly, does H-INERT keep F1's void a fold-state no-op, and do the two
  C-12.6 flags (restated on F1's consequence, reordered/restated on F2) both fire?
- **RT-C (FORMALIS) — self-undermining chain.** A synthesised firing whose own consequence,
  when folded, **falsifies the predicate of the very observation that triggered it**. Does H-WF
  (well-founded arming) forbid the oscillation, or can the closure fail to reach a fixpoint?
- **RT-D (correctness-architect) — conflicting corrections, order-independence.** Two
  corrections arrive in different admission orders; one **suppresses** a firing the other
  **synthesises**. Because `derive` is non-monotone, confirm the two admission orders still
  reach one quiescent closure (thm:refold determinism over the arrival *set*), or exhibit the
  divergence.
- **RT-B (correctness-architect / CONCORDIA) — nested lateness.** A correction contesting an
  execution time that **itself arrives late**. Confirm the distinct-cid C-12.4 correction
  re-inserts at its own execution position and the tail (which includes the first late arrival's
  refold) refolds idempotently — a late correction of a late arrival.
- **RT-E (CONCORDIA) — duplicate after supersession.** A duplicate (same cid) arrives **after**
  its original was superseded by a refold (consequence voided, event retained). Is it still
  absorbed by identifier, and does the retained-but-voided original confuse absorption or the
  C-12.6 flag set?

---

## 3. Supervisor flags (must not be missed)

- **SF-1 — A2 is the round's gate.** It was held from Round 3 specifically for the manifest;
  it must close this round with explicit KEEP-CUT/RESTORE verdicts, not a checklist. The two
  priors ((b5) "one home per fact", (b3) checkability) are where I expect a restore.
- **SF-2 — the 1-over is the owner's, not ours.** Recorded as DEFERRED-TO-OWNER. STYLUS may
  recover it by honest dedup; no one recovers it by cutting protected content. If it survives to
  round 5, it is stated to the owner with the exact residual, and the cap decision is theirs.
- **SF-3 — the serialization paragraph is a model-commitment seam.** New normative text on a
  spec that is otherwise at cap; CONCORDIA must anchor it to a clause or park it. This feeds the
  round-5 certifier signature (i) directly.
- **SF-4 — kleppmann unavailable.** The global-total-order picture is again the ground the
  tiebreak-seam (F2) and confluence (RT-D) stress; FORMALIS + correctness-architect jointly
  cover it; residual logged.
- **SF-5 — recusal continues.** I authored the ⊥ call; ⊥/⊤ questions remain FORMALIS's and
  correctness-architect's to adjudicate, mine only to rule on.

**Dispute resolution.** Co-owned findings (F2 × RT-D on confluence; A1 × S2 on a cut that is
also a page-funder) come to me; I rule and record it. Convergence among reviewers is necessary,
not sufficient — the round-5 certifier signatures (CONCORDIA, FORMALIS) decide, and they must
now cover: (i) `lem:closure` + the ⊤/derivation-order/hash-tie key are well-defined,
terminating, non-fixpoint, and drift-free from the ruling; (ii) firing-derivation and the
serialization discipline are globally consistent and clause-anchored; (iii) A2's cut audit
closed with every load-bearing span carried; (iv) the 1-over is the owner's to resolve.

---

# ROUND-4 RULING (TuringAward, supervisor) — 2026-07-17

All four Round-4 files read. This rules the five composition questions, produces a fully
specified accepted list so **Round 5 does verification + signatures only (no new design)**,
records two supervisor self-corrections (§4), and states the final page arithmetic for the
certification record. kleppmann still unavailable (SF-4).

## A. Two supervisor calls tested by review and FAILED — recorded (§4)

This pass the adversarial method overturned me **twice**, and both are on the record as the
mechanism working, not as noise to bury:
1. **⊥-before (Round 2 ruling → Round 3 reversal).** I ruled ⊥ sorts before real door times;
   FORMALIS + correctness-architect unanimously overturned it to ⊤. Corrected.
2. **A2 priors (Round 4).** I flagged (b5) "one home per fact" as possibly uncarried and (b3)
   checkability as possibly lost. **Both disproven on the record:** (b5) is carried *verbatim*
   by `prin:one-home` (1949–1953) — the manifest merely **mis-cited** `inv:writer`; (b3) is
   carried at 3034–3040 (a mechanically-checkable acceptance list), more strongly than the cut
   sentence. A2 closes **6/6 KEEP-CUT, 3/3 appendix clean, no RESTORE**. The supervisor's
   suspicion was tested by an independent reviewer and failed — exactly what §4 is for.

## B. The five compositions — rulings

**Composition 1 — F2 × RT-B: one home (product-graph / arming-firing well-formedness, ch:objects),
two distinct fixes; RT-B adopts the EXECUTABLE check, not the relabel.**
F2 and RT-B both live in the arming/firing well-formedness discipline, but are different
properties: RT-B is **acyclicity** of the cross-unit "arms a further watch" relation
(termination); F2 is **within-instant ordering determinacy** (no silent hash decision of a
non-commuting pair). A product can satisfy one and violate the other — independent.
- **F2 is resolved by a RUNTIME rewrite, no new property.** FORMALIS refuted my Round-4
  hypothesis (independence ⇒ commutation): read-independence gives the same *transaction*, but
  commutation also needs **write-independence** (disjoint non-additive home-field writes). Two
  firings on one unit's status, read-independent but write-conflicting, are **non-commuting**,
  and the reads-only relation sends them to the hash — a DL-01 breach. Fix: the tiebreak's
  commutation test is **disjoint reads AND disjoint non-additive writes**; a write-conflicting
  pair with no reads-dependency is non-commuting → **declared precedence or fail-closed
  refusal** (C-2.7/DL-01), never the hash. Adopt FORMALIS's combined 1313–1318 rewrite.
  Net-neutral-ish; no new witness.
- **RT-B adopts option (a): the executable check, NOT the relabel.** `lem:closure` (1332)
  claims H-WF is "discharged by product-graph well-formedness (ch:objects)," but ch:objects
  carries only H-FWD (inception) + **per-unit** finiteness — **no cross-unit arming-acyclicity
  condition exists**. A cyclic product (U's firing arms V, V's arms U back) passes registration
  and **hangs the closure**. The project bias is **executable > asserted (§3)**, and here the
  decisive fact is that **acyclicity of the declared arming graph is DECIDABLE at registration**
  (a static cycle-check on declared-data edges — unlike termination itself, which hangs and
  cannot be firing-tested). Because an executable check *exists*, §3 **mandates** it: add the
  ch:objects acyclicity condition (a cyclic product is **refused at registration**) +
  `prop_armingWellFounded` over generated multi-unit product graphs (cyclic branch refused,
  §3 firing witness). **Option (b) — relabel H-WF as unchecked — is REJECTED**: relabel is
  honest only when no executable check exists; here one does, so an asserted assumption where a
  decidable check is available is the §3 defect the project forbids. This distinguishes H-WF
  from H-FIN(finiteness), which *is* genuinely discharged by the per-unit finiteness already in
  ch:objects (865, 883) and stays structural. **§3-irreducible addition** (~+7 lines).

**Composition 2 — F3's two fixes + STYLUS's two restatement dedups + RT-A naming: one rewrite of
the serialization paragraph (1445–1452).** (F3-1) "the total order is arrival-independent" is
**false** — door time is admission-assigned, so *order* depends on arrival where execTimes tie;
the true claim is **fold STATE is arrival-independent** (door decides only commuting ties). (F3-2)
distinguish **termination** (H-FIN/H-WF) from **scheduling-liveness** (the overdue sweep backstops
a *lost* refold, cannot rescue a non-terminating closure). (RT-A) name "including two conflicting
execution-time corrections of one instant" in the DL-01 residual. (STYLUS-1) drop the negative
restatement "a partial refold is never committed and never observed" (the positive form carries
it). (STYLUS-2) keep the load-bearing "never by an arrival-order door tiebreak," reference the
DL-01 home for the rest. **One coordinated rewrite**; CONCORDIA re-confirms it still traces to
C-2.7 and loses no normative content (Round-5 verification — CONCORDIA already signed the paragraph
CLEAN). Net ~−1.

**Composition 3 — RT-A naming + RT-D clause: single sentences, accepted.** RT-A naming folds into
composition 2. RT-D: add one clause pinning absorption's duplicate-check to the **full retained
log including superseded/voided firings** — retain-not-delete (C-12.5) is exactly the
anti-resurrection mechanism: a voided firing's cid stays on the log, so a duplicate **absorbs**
rather than resurrects. Had the void *deleted* the firing, the duplicate's cid would be absent →
admitted as new → consequence resurrects. One clause near 1172–1179 / 1278. ~+1 line.

**Composition 4 — priors disproven, recorded (§4).** Covered in §A above. Manifest fix only:
correct `cut_manifest_r2.md` (b5) carrier citation `inv:writer` → `prin:one-home` (workpaper, not
a spec change). No RESTORE.

**Composition 5 — refold vs re-folding: DISTINCT operations, one-name fix.** They are not the
same operation: **"refold"** (one word, sec:totalorder) is the **reordering step** — interior
insertion → recompute tail → C-12.6 flag/explain; **"replay"/"rebuild"** is deterministic
reconstruction of state from a log prefix, with **no** reordering and **no** C-12.6 obligation.
The hyphenated **"re-folding"** (2092, 5193, 5204, 5264, 6501, pre-existing) is a fragile third
spelling that collides with "refold." Rule: rename each of the five sites to what it means —
**"replay"/"rebuild"** for reconstruction (the expected reading, and the spec's established terms),
**"refold"** only if a site genuinely denotes the reordering step. Restores one-name-one-operation.
Net-0.

## C. Dependency-ordered ACCEPTED-CHANGES list (fully specified — Round 5 verifies, invents nothing)

1. **RT-B — make H-WF a real, checked discharge** [correctness-architect RT-B(a); FORMALIS F3/RT-C
   honesty]. **ch:objects:** add the product-graph well-formedness condition — the declared
   "arms a further watch" relation is required **acyclic**; a product whose declared arming graph
   contains a cycle is **refused at registration** (decidable on the declared graph). **ch15:** add
   `prop_armingWellFounded` over generated multi-unit product graphs (assert registration refuses
   the cyclic branch, admits the acyclic; **firing witness on the cyclic branch**, §3). **lem:closure
   1330–1333:** update the label — H-WF is now discharged by this **checked, property-tested**
   condition; H-FIN(finiteness) remains the per-unit structural discharge that genuinely exists.
   §3-irreducible. ~+7 lines (**grows the DEFERRED-TO-OWNER residual**).
2. **F1 + F2 combined rewrite, lem:closure 1313–1318** [FORMALIS F1, F2]. (F1) the pass
   **computes**, does not build/define, the order; re-ground party-invariance in the **recorded
   reads/writes relation + canonical hash**, not P2 (P2 is same-sequence fold determinism, the
   wrong lemma). (F2) commutation = **disjoint reads AND disjoint non-additive writes**; a
   write-conflicting no-reads-dependency same-instant pair → **declared precedence or refusal**
   (C-2.7/DL-01), never the hash; hash decides only genuinely-commuting pairs. Use FORMALIS's
   supplied rewrite. ~+2–3 lines.
3. **Serialization paragraph rewrite, 1445–1452** [FORMALIS F3, RT-A; STYLUS S1.1/S1.2]. Per
   composition 2: order→**state**; termination (H-FIN/H-WF) vs scheduling-liveness (sweep);
   name the conflicting-corrections instance; drop the negative restatement; reference the DL-01
   home while keeping "never by an arrival-order door tiebreak." CONCORDIA re-confirms C-2.7
   trace + no normative loss (Round 5). Net ~−1.
4. **RT-D absorption clause** [correctness-architect RT-D]. Pin absorption's duplicate-check to
   the **full retained log including voided firings**; retain-not-delete is the anti-resurrection
   mechanism. ~+1 line.
5. **A2 manifest citation fix** [correctness-architect A2]. `cut_manifest_r2.md` (b5) carrier
   `inv:writer` → `prin:one-home`. Workpaper only; **no spec change, no RESTORE**. Net-0.
6. **refold/re-folding one-name fix** [STYLUS S3]. Rename the five hyphenated "re-folding"
   reconstruction sites to "replay"/"rebuild" (or "refold" if genuinely the reordering step).
   Net-0.
7. **occasion comma, 1239** [STYLUS S1]. Insert the copula comma so the apposition reads. Net-0.
8. **CONCORDIA optional polish — NOT required.** A discretionary C-11.2 "also ch:machines" for
   refold-atomicity. Recorded; the gate is GREEN without it; apply only if the certifier chain
   wants maximal explicitness. Not on the critical path.

## D. Rejected / superseded (recorded)
- **RT-B option (b) — relabel H-WF as unchecked** — REJECTED: a decidable registration-time
  acyclicity check exists, so §3 mandates the executable discharge (option a); an asserted
  assumption where an executable check is available is the defect §3 forbids.
- **My Round-4 priors (b5)/(b3)** — DISPROVEN on the record (§A). Not a finding rejected — a
  supervisor suspicion tested and failed.
- **F2 alternative (product-graph disjoint-non-additive-writes guarantee)** — not adopted; the
  runtime tiebreak rewrite (composition 1) is sufficient and cheaper.

## E. Every finding answered
| Finding | Verdict | Disposition |
|---|---|---|
| A2 six category-(b) cuts | 6/6 KEEP-CUT | item 5 (manifest b5 citation fix); no RESTORE; priors disproven |
| RT-D duplicate of a voided firing | SOUND + clause | item 4 |
| RT-B sub-case 1 (self-void) | SOUND | no action (stratification prevents it) |
| RT-B sub-case 2 (cross-unit arming cycle) | DEFECT | item 1 (executable acyclicity check; relabel rejected) |
| F1 derivation-order drift | DEFECT | item 2 (compute-not-build; re-ground off P2) |
| F2 independence⇏commutation | DEFECT (refuted my prior) | item 2 (write-conflict discipline) |
| F3 "arrival-independent order" false + termination/liveness | DEFECT | item 3 (order→state; distinguish) |
| RT-A conflicting corrections | confluence holds + name residual | item 3 |
| RT-C nested lateness | PASSES (iterates; cost accurate) | no action |
| C1 serialization clause anchor | CLEAN (C-2.7) | item 3 re-confirm; item 8 optional |
| C2 GREEN gate survives R3 diffs | GREEN preserved | no change (re-run Round 5) |
| RT-E duplicate after supersession | CLEAN | no change |
| S1 style / occasion comma | clean + comma | item 7; items 3/composition-2 for the two flagged restatements |
| S2 dedup / 112 unreachable | certification sentence | §F below |
| S3 refold vs re-folding | flag | item 6 |

**Accepted: 12 findings actioned (items 1–7; item 8 optional). Rejected/superseded: 3. Parks: 0
(RT-B is a §3 fix within existing clauses, not a constitutional conflict; CONCORDIA zero parks).**

## F. Page verdict for the certification record
Round-4 additions net ≈ **+8 to +9 lines** (item 1 ~+7 §3-irreducible; item 2 ~+2–3; item 4 +1;
item 3 ~−1; items 5–7 net-0), against STYLUS's honest clean dedup of **~−1 to −2** (its own
certification: the only clarity-safe non-protected candidates are ≤3 early-ch04 lines that
`\raggedbottom` slack absorbs and that do not remove the final page). **Net ≈ +7 lines** — the
overflow **grows** but stays within the single 113th page; **the file remains 113pp, 1 physical
page over.** STYLUS's certification stands verbatim for the record: **"112 is unreachable without
cutting normative content."** The 1-over is **DEFERRED-TO-OWNER** at certification; the cap is the
owner's to move (he has done so twice), never an agent's, and **no §3 / normative / correctness
item is cut to fit** (§7: correctness outranks the cap).

## G. Round-5 structure (certification — verification + signatures, no new design)
- **correctness-architect:** verify item 1 (ch:objects acyclicity condition + `prop_armingWellFounded`
  fires on the cyclic branch) and item 4 landed; confirm no regression.
- **FORMALIS:** verify items 2, 3 landed *exactly* as specified and that `lem:closure`'s H-WF
  discharge is now **real** (checked, property-tested), not asserted; then **sign** (i)+(ii).
- **CONCORDIA:** re-run the two-way 116-clause gate GREEN after the ch:objects condition (confirm
  ch:objects's clauses still cover it, no new row needed) and the serialization rewrite still
  traces to C-2.7 with no normative loss; then **sign last**.
- **Supervisor:** final page verdict (113/1-over, DEFERRED-TO-OWNER) recorded for the owner.
Everything Round 5 touches is **application-verification**; the design is fully specified above.
