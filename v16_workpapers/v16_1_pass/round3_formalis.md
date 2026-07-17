# Round 3 — FORMALIS findings (v16.1 pass)

Reviewer: FORMALIS (Leroy chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad).
Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`, sec:totalorder step (c) + lem:closure + snapshot key + ch15 props.
Record: `round3_record.md` (SF-1 the ⊥ inversion, headline; supervisor recused as author of the original ⊥ call — FORMALIS adjudicates).
Prior: `round1_formalis.md`, `round2_formalis.md`, `memo_w2_proofs.md`.

---

## F1 (HEADLINE, adjudicated) — the ⊥ within-instant door position is backwards — **VERDICT: DEFECT confirmed. RULING: ⊥ must sort AFTER real door times (a top element ⊤), with one addition for same-instant chains.** (Unfixed, this is a VETO: a lost knock-in or a hidden re-pass.)

**The defect is real.** A synthesised data emission `F` shares its trigger's execution instant: `exec F = exec O = t`, where `O` is the tipping observation, a real-door arrival with real door time `d_O` (step c 1244–1245; lemma 1300 "the tipping observation just folded"). The keys are
`key O = (t, d_O, h_O)`, `key F = (t, ⊥, h_F)`.
Under the landed **⊥-before** rule (1232–1234, "sorting before every real door time of its execution instant"), `⊥ < d_O`, so `key F <_lex key O`: **F sorts before the observation that triggers it.** Three consequences, all breaking:

1. **Causality inverted.** Folding in total order reaches `F` before `O`; `F`'s predicate is not yet satisfied → the knock-in is **lost** (silently: nothing emitted at F's position).
2. **lem:closure existence argument falsified (1298–1299).** "An emission at `p` depends only on the fold **strictly below** `p`." Under ⊥-before, `O` at `(t, d_O, h_O)` is strictly **above** `F` at `(t, ⊥, h_F)`, yet `F` depends on `O`. The dependency does **not** decrease in `<`; the well-founded recursion has no ground.
3. **Single forward pass falsified (1241–1247).** "Folds any newly synthesised emission in the same pass … never falls behind the cursor, no position revisited." Synthesising `F` while folding `O` puts `F`'s position `(t, ⊥)` **behind** the cursor `(t, d_O)` → mandatory re-insertion → contradicts one-pass and the `O(|tail'|)` cost (1332–1335).

The supervisor's self-correction is upheld: **1234 is the outlier.** The lemma (1298–1302, "at or above its trigger's … dependency strictly decreases") and the forward pass (1241–1247, "never falls behind the cursor") were **both written assuming ⊥-after**; only step (c) 1234 and the snapshot slot 1340 say ⊥-before. The fix makes the document consistent, and it is **net-zero** (recomputability is untouched: ⊤ is exactly as canonical, record-derived, and party-invariant as ⊥ — the "identical for every party and every rerun" clause survives verbatim; only *which* extreme changes, and causality dictates the top).

**Ruling — the coordinated edit (four sites):**

- **1232–1234 (step c).** Replace `door time~$\bot$, the null of an event that never crossed the arrival door, record-derived and identical for every party and every rerun, sorting before every real door time of its execution instant` with:
  `door time the canonical top value~$\top$ --- an event that never crossed the arrival door takes the maximal door slot, record-derived and identical for every party and every rerun, sorting \emph{after} every real door time of its execution instant, so it never precedes the arrival that tips its predicate and the forward pass reaches it only once that arrival is folded`.
- **1298 (lemma key).** Replace `p=(\mathrm{exec},\bot\text{ or }\mathrm{door},\mathrm{hash})` with `p=(\mathrm{exec},\mathrm{door}\text{ or }\top,\mathrm{hash})`.
- **1340 (snapshot slot).** Replace `its door slot $\bot$ when that event is an emitted firing` with `its door slot $\top$ when that event is an emitted firing`. (Invalidation `T_last ≥ T_e` and "nearest survivor" stay a strict, monotone order: ⊤ is a consistent maximal element, placed identically in the fold order and the key.)
- **1241–1247 (forward pass) and 1298–1302 (recursion).** No wording change — they are already correct **under ⊤** and become sound once the outlier is flipped.

**The addition ⊤ alone does not cover — same-instant synthesised chains (the "something better" the supervisor invited).** If `F1` (synthesised at `t`) has a consequence a second watch reads, `F2` is synthesised at the **same** instant `t`. Both carry door `⊤`, so under `(exec, ⊤, hash)` they are ordered by **hash** — which is causally arbitrary. If `h_{F2} < h_{F1}`, `F2` sorts before `F1`, its trigger, and lem:closure's "depends only on the fold strictly below `p`" fails **again**, one level deeper. The lemma's existing hook (1305–1308, "declared precedence for a non-commuting pair") is a **static product declaration** and does not obviously reach a **dynamically** synthesised chain. Add the record-derived derivation-order tiebreak (net ~1 sentence, load-bearing), after 1302:
  `Among synthesised emissions of one instant the tiebreak is the derivation order the forward pass produces --- it emits a trigger strictly before anything that trigger satisfies, a record-derived linear extension of causal order reproducible by any party (determinism, P2) --- so a synthesised emission sorts strictly above every event, real or synthesised, its predicate reads; the hash settles only causally independent (commuting) emissions.`

---

## F2 — the ⊤–⊤ tie to hash is not stated, and H-CR is not named at the site — **VERDICT: DEFECT (clarity/completeness)**

Two synthesised emissions of one instant now **share the door value ⊤**, so a *commuting* pair falls to the **hash** (level 3). The lemma (1305–1308) says only "the door-then-hash tiebreak orders only pairs that commute" — it does not state that both synthesised emissions carry the *same* door slot so the tie is decided **wholly** at the hash, nor name the collision-resistance that makes it definite. Per §3 (invariants stated), add after the F1 derivation-order sentence:
  `Two commuting synthesised emissions of one instant share the door value $\top$, so their order is decided wholly at the event hash; it is well-defined because the hash admits no collision on the finite domain of well-formed events --- the same collision-resistance the total order's totality rests on (H-CR, \S above).`
This closes the F1/F2 seam: **non**-commuting same-instant emissions → derivation order (F1); **commuting** ones → hash under **H-CR** (F2). Neither is left undecided.

---

## F3 — the blanket "property-tested" label overclaims — **VERDICT: DEFECT (§3)**

Line 1320–1322: "The four hypotheses H-FIN, H-WF, H-FWD, and H-INERT are named obligations … **property-tested** … not axioms." Checked against ch15 (5697, 6144–6187), the label is not honest for all four:

| Hypothesis | Witness in ch15? |
|---|---|
| **H-FIN** at-most-once | ✓ `prop_firedMatchesOneEdge` (5697). |
| **H-FIN** finiteness of occasions | ✗ **no witness.** `prop_refoldEqualsTimely`'s own comment (6150) says it is "sound **only under** … H-FIN, H-WF: a non-terminating closure **hangs, not passes**." A hang is not a firing test — non-termination is *excluded by construction*, never caught by a property. |
| **H-WF** no infinite arming cascade | ✗ **no witness.** Same as above; no acyclicity/termination property on the arming graph exists. Cannot be a firing property in principle (you cannot test non-termination by running). |
| **H-FWD** exec ≥ trigger | partial: `prop_firingSynthesized_fires` asserts `execTime f == tippingObs` (6183), the **data** case only; the scheduled-emission/inception case and general product-graph well-formedness are unwitnessed. |
| **H-INERT** superseded firing inert | implicit only: `prop_refoldEqualsTimely` fails if a retained superseded firing perturbs fold state, **but no coverage witness forces a true→false (voided) firing** — every added generator (`genBarrierBreachingCorrection`) produces false→true. So the case may never fire (§3: zero firings ≠ green). |

**Remediation.** Split the label honestly (net-neutral): H-FIN(at-most-once), H-FWD(data), H-INERT are property-tested (add `prop_supersededFiringInert_fires` — force a voided firing via a covered-call generator and assert zero fold-state contribution — to make H-INERT actually fire); **H-WF and H-FIN(finiteness) are structural obligations discharged by product-graph well-formedness (Chapter ch:objects), not firing tests.** Do not call a non-termination guarantee "property-tested."

---

## Red-team scenario 3 — late arrival whose refold RE-ARMS a fired watch — **PASSES the machinery, with two flags**

Setup: watch `W` fired under the old fold at occasion `o1`; the late insertion makes `W`'s predicate **false at `o1`** (old firing superseded) but **true again at a later occasion `o2`** (W should fire at `o2`).

**The machinery handles it correctly:**
- **No duplicate-absorption collision.** The old firing keys on its original cause and occasion; the new firing keys `H(correction, W, o2)` (1236). The **occasion** component makes `o1 ≠ o2` ⇒ distinct identifiers ⇒ the new firing at `o2` is **not** absorbed as a duplicate of the old at `o1`. This is exactly the discriminator the id was built to carry — the same cascade-injectivity argument as `(contract, unit, seq)`.
- **Both C-12.6-flagged.** The old `o1` firing is *retained, consequence voided* (step c 1240, lemma 1317 H-INERT) → restated flag; the new `o2` firing is *synthesised* (1227–1229) → reordered/restated flag. Both directions covered.
- **Terminates.** In the new closure `W` fires **once**, at `o2` (edge-triggered, `prop_firedMatchesOneEdge`); the `o1` record is inert provenance, not a second firing. **H-WF** forbids a cycle (`W`→arms→`W`…); **H-FIN** bounds the occasions. The re-arm-then-fire is a single finite step, not a cascade.

**Two flags (must not pass silently):**
1. **"occasion" is UNDEFINED in print.** It appears only in the id `H(correction, watch, occasion)` (1236) and as "candidate emission occasions" (1309) — never defined. Scenario 3's whole no-collision guarantee rests on `occasion` being a **record-derived value that distinguishes distinct edge points of one watch** (`o1 ≠ o2`). As written, the id's injectivity across a re-arm is asserted on an undefined term (§3 definition-before-use; STYLUS S3 flagged the same first-use gap). Supply a one-clause definition at 1236: `the occasion being the record position (observation point or scheduled date) at which the watch's edge is evaluated, distinct edges giving distinct occasions.`
2. **Re-ARMING, not just re-firing, must be in the operator's domain (F2-Round-2).** For `W` to fire at `o2`, the reordered prefix must *arm* `W` such that its edge lands at `o2`. Step (c) synthesises the *firing*; the re-**arming** acknowledgement that precedes it is a Monitor emission the widened domain (1225–1227) must also re-derive. Confirm the "arming acknowledgement and the firing alike" clause is read as covering a **re**-arming whose edge relocates — else a re-armed watch could fire at `o2` with no synthesised arming, breaking the declared→armed→fired handshake (1443).

---

## Outside the lenses — one item

The mitigation table (1352, 1353) still references position `$<p$` and "$p$" for the invalidation boundary, but the snapshot prose (1337–1342) has moved to the **triple** `T_last`/`T_e`, not an ordinal `p`. The table rows read against the superseded ordinal `p`; align them to `T_last < T_e` so the table and prose name one key (§ state-once). Net-neutral wording.
