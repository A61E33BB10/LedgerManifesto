# TuringAward — Part I System Review — 21 July 2026

**Subject:** the framework as a *composed system* — Constitution v1.41 + Market Data Manifesto
v1.3 + Valuation Manifesto v1.0. Not the documents singly.

**Relation to prior art (TuringReview.tex).** That single-document pass stands; this review does
not repeat it but tests **composition across the three manifestos**. Recurring findings are
flagged where a child now makes them load-bearing (TA-M-02 liveness, TA-M-04 reproducibility,
TA-M-05 single writer, TA-M-07 O(n) replay). C1, C2, C3, C5, C6, W2–W4 are new and cross-document.

---

## ADVICE — what to do next, in what order

- **A1. Rule PARK-1 before anything else.** A *certified* document (MD-16, MDM v1.3) silently
  depends on it (see C1). Ruling C-4.11 literal ("never store") would retroactively break a
  certified article. The owner must see this dependency *before* ruling.
- **A2. Amend C-2.2 at the parent, not in the children.** The read-back/re-derive split that
  patches TA-M-04 currently lives as a *narrowing* inside MD-6/VM-2. C-Auth.3 requires the
  parent be amended first. Pin the numerical-environment/determinism question in the same
  amendment.
- **A3. Decide prevention-vs-detection at the Constitution.** MD-16 Gate 1 prevents on an
  economic property; C-13 says economics is detected, never prevented (C3). Either add a
  third correctness category to C-13 explicitly, or reframe Gate 1 as detection. Park it now.
- **A4. Reconcile the look-ahead claim.** Either forbid VM-2's decoupled (as-at, cut) query
  inside a trajectory, or downgrade MD-4's "structurally impossible" to "default-prevented,
  guarded by a named discipline" (C5).
- **A5. State a liveness commitment now (TA-M-02).** Three documents rest their correctness
  story on "detect-and-flag-stale"; without a clearance deadline+owner it is a backlog (W5).
- **A6. Fix scale before implementation.** A checkpoint discipline (ties to PARK-1) and a
  single-writer throughput plan (TA-M-05) must precede the valuation/risk re-entry firehose
  meeting one door (W1). Unify the world-map family under one name while doing so (C7).

---

## CRITICISMS — wrong or weakly argued TODAY

- **C1 [MAJOR] — MD-16 records materialised projections and denies the PARK-1 conflict it sits
  inside.** *Doctrine:* C-4.11 ("computable ⇒ projection, never stored"). MD-16 records the gate
  decision *with its computed functionals and percentiles* — each "a deterministic map from a
  state to a number," i.e. a projection — as stored fields, and must, since a recompute against
  versioned terms would differ. That is PARK-1's materialised-projection pattern. MD-16 asserts
  "no collision with C-4.11 … PARK-1 neither reopened nor turned on," but the only thing
  separating its stored functionals from sprod² is the "pinned as-known" property — exactly what
  PARK-1's *amendment* authorises and C-4.11 as-written forbids. A certified article presumes a
  parked ruling.
- **C2 [MAJOR] — C-2.8 and MD-11 contradict on seed-replay.** *Doctrine:* Simulability. C-2.8:
  "the one non-record input of a simulation is the seed, recorded so that every path replays
  exactly." MD-11: "a path that recorded only the seed could not replay" — every model output
  must *also* be recorded, since C-14.9 forbids re-running the model on replay. The system does
  not deliver replay-from-seed but replay-from-fully-recorded-outputs — costlier, and void if the
  model is not retained or not bit-deterministic (C4). C-2.8 overclaims the flagship "we live in
  a simulation" thesis; MD-11 quietly patches it.
- **C3 [MAJOR] — MD-16 Gate 1 is prevention on an economic property, outside the one door,
  parked nowhere.** *Doctrine:* C-13.3 ("prefers a detectable, repairable error over a pretence
  of prevention"); C-4.8/C-5.5 (no second door, structure-only admission). No-arbitrage is
  economic correctness; MD-16 makes it a construction-time gate deciding whether a state
  "exists" — "prevention, not detection" — introducing a *third* correctness category the
  Constitution never sanctions, and parking none of it. A long article that parks nothing is
  the mechanism unexercised (CLAUDE.md §1).
- **C4 [MAJOR] — C-2.2 is narrowed in the children without amending the parent.** *Doctrine:*
  C-2.2 ("to the last minor unit," unconditional) vs C-Auth.3 (amend the parent first). MD-6/VM-2
  make reproduction conditional — re-deriving a model mark "needs the retained model and the
  numerical environment it ran in, … outside this scope" — so every model-priced mark's
  bit-for-bit claim (VM-8, VM-11) rests on an out-of-scope artifact. Builds on TA-M-04; the fix
  belongs in the Constitution, not the children.
- **C5 [MAJOR] — MD-4's "look-ahead is structurally impossible" contradicts its own "default
  read" and VM-2.** *Doctrine:* Order / time travel. MD-4 pins as-at to as-of *by default* —
  "default" concedes a non-default. VM-2 supplies it (position as-at yesterday, market cut today,
  "a distinct, legal query"); compose it with a VM-11 trajectory and look-ahead returns. A
  structural impossibility has no legal escape; this has one — a discipline to remember, exactly
  what MD-4 denies it is.
- **C6 [MAJOR] — Gate 2 is prevention resting on a learned threshold.** *Doctrine:* §3
  correctness ("safety is specified, not learned"); lens L10. A derived state's admissibility
  turns on percentiles of historical distributions, and "a declared joint-plausibility convention
  … on sparse joint history is itself a … modelling assumption about the joint tail" — load-bearing
  for a prevention gate. Making the numbers "declared terms" dodges the no-constant rule, not the
  substance: a fitted statistic gates whether a state may exist.
- **C7 [MINOR] — one concept, three names, across two documents.** *Doctrine:* C-Auth.4 (one
  name per component). "dynamic" (a datum), "shift" (a path), "𝒟" (a surface) are declared one
  "family of world-maps" — but only late, in MD-16, after each was coined separately. Unify the
  name and the home once, not thrice.

---

## POTENTIAL WEAKNESSES — what breaks LATER, and under what condition

- **W1 [MAJOR] — write amplification meets the single writer and O(n) replay.** *Doctrine:*
  single door (TA-M-05), no checkpoint (TA-M-07). VM-1 re-enters *every* model-priced mark as a
  logged observation; VM-10/MD-11 re-enter every mark of every scenario and MC path to be
  replayable. *Scenario:* a real book (instruments × re-mark cadence × scenarios × MC paths)
  funnels the whole valuation/risk firehose through one writer, and time-travel folds a prefix
  now growing at pricing cadence, not event cadence.
- **W2 [MAJOR] — Gate 2 blinds risk exactly where history is thin.** *Doctrine:* MD-16 realism
  gate + C-4.12 totality. *Exposing scenario:* an IPO, a post-restructuring name, a new dividend
  policy — no sufficient history ⇒ Gate 2 permanently "undecidable" ⇒ no derived state
  constructible ⇒ no risk report or backtest for the very names that most need one.
- **W3 [MAJOR] — Gate 2 suppresses the real tail under regime shift.** *Same gate. Scenario:*
  2008 / COVID / a dividend cut — new-regime states are statistically unprecedented, so Gate 2
  rejects them as "unrealistic," refusing to construct the scenarios risk exists to explore.
- **W4 [MAJOR] — sprod poles force structural chain-breaks the alarm cannot distinguish.**
  *Doctrine:* VM-7 ("a broken chain is forbidden … re-mark") vs PE-3/PE-6 (poles and sign flips
  are legitimate structure). *Scenario:* an ordinary vanilla under an ordinary surface dynamic at
  spot near Gadj=0 — the carry line reconciles at no real volatility, residual forced O(1), the
  chain "breaks" through no data fault. The broken-chain channel floods with un-repairable
  breaks; operators learn to ignore it exactly where carry is most degenerate.
- **W5 [MAJOR] — the detect-and-flag discipline has no liveness.** *Doctrine:* TA-M-02/09, now
  load-bearing across MD-8, VM-7, MD-16. *Scenario:* a vendor bulk retraction corrects thousands
  of leaves; MD-8 staleness "propagates forward along the chain," stale-flagging much of the book
  at once, with no deadline, owner, or fallback on when it clears. Correctness-by-surfacing
  becomes a growing pile.

---

**Declaration.** Lenses: L1 (single writer/replay), L2 (log commit point/checkpoint), L3
(liveness, look-ahead), L5 (naming, projection-vs-store discipline), L6 (conceptual integrity
across three authors), L9 (numerical determinism), L10 (Gate 2 as a learned safety component).
L7/L8 dismissed: no new network/adversarial surface beyond the prior review. Confidence
MEDIUM-HIGH — composition gaps and overclaims, not thesis errors. Biggest unknown: production
scale (W1), and whether Gate 2's "decidable predicate" is exact and cheap (C3/C6) — GATHERAL/FORMALIS.
