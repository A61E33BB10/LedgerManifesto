# FORMALIS — Referee feedback, Round 4 (Temporal Committee, Part II) — FIRST RED-TEAM

Remit: verdict on the value-bound fold, the two crown-jewel invariants under attack (S1 REFOLD-ATOMIC,
S7 GATE-STATE-ATOMIC), the four load-bearing invariants named this round, and any defect the r4 edits
introduce. Round 4 of ≥10; no consensus (reserved for ≥round 10). A flag without a counterexample or a
named missing case is discarded.

---

## Item 1 — VALUE-BOUND FOLD. **HOLDS as a mechanism; TWO r4 edits leave it not-yet-one-voice.**
- Locus move discharges my r3 R-1: T-1 §3 (l.126-134) now has the door do "presence + structure only,
  model-free … does **not** compare β to any tolerance," and puts `β > this unit's tolerance` at the
  §2.3 VM-7 broken-chain locus (l.88, l.133). The exact r3 counterexample is inlined ("β=3 bp feeds U₁
  at 5 bp and U₂ at 1 bp", l.128-129). Correct decomposition; the ill-defined "consuming unit's
  tolerance at a shared surface" is gone.
- Missing-attestation door behaviour PINNED (my r3 R-2): T-1 l.130-131 "admit-and-flag … never refused
  (economic metadata is not envelope validity)". Sound and A′-consistent.
- Content-hash DELETION is SAFE (the retry race it was built for is memoised away by the split), but the
  justification over-reaches — see Item 5(c). NEW hole named — see Item 5(d).
- **One symbol NOT achieved (BREAKS the one-name rule).** T-1 l.124-125 declares "β (one symbol;
  ε_repro/τ/ε normalised to β)", but T-4 D16 (l.36) still writes **ε_repro** ~6×, and T-5 (l.7) still
  writes **τ**. The pin exists only in the assembly base. CLAUDE.md §1 ("no synonyms, ever") — fix T-4/T-5.

## Item 2 — S1 mid-refold crash. Property REFOLD-ATOMIC. **HOLDS across all three crash points.**
- Crash-atomic / idempotent / forward-only / no-double-fire / no-rewind holds: the refold appends only,
  each appended txn + synthesised firing keys on cause-derived id (`H(correction,watch,occasion)`, txid
  over recorded inputs), so re-run absorbs the partial tail (T-1 §4 l.151-163; T-5 crashes ii/iii).
- The "identical bytes on re-present" claim is a **crash-(ii)/(iii) property only**. At crash (i) the
  compute result is LOST, so the model **recomputes and, for a non-bit-reproducible model, diverges**
  (P'≠P). T-5 l.7 concedes this correctly. It is byte-atomically **benign**: the lost P was never emitted,
  so P' is the sole admission (canonical-by-first), and the value spread is the §3 β bound — not an
  admission defect. So REFOLD-ATOMIC survives on "≤ one payload reaches the door," NOT on byte-invariance.
- T-5's crash-(i) "seed-inside ⇒ double-record" mechanism (l.8) is loosely argued (at crash (i) only P'
  is ever emitted), but the invariant it lands on — key from recorded inputs, fixed before compute — is
  right and load-bearing for **txid reproducibility** (I2). Precondition (T-3 l.7): the refold must
  recompute **no model in-fold**; enforce by type, do not assume. HOLDS given I2+I3 enforced and
  `prop_refoldIdempotent`/`refold-equals-timely` shown to fire (zero firings = defect).

## Item 3 — S7 failover mid-gate. Property GATE-STATE-ATOMIC. **HOLDS.**
- No ungated/half-verdict state is nameable: state+verdict are ONE door transaction over one pinned cut C
  (Fork A), C a recorded log-cursor (T-1 §4 l.165-179); the door's admit is atomic (base-ledger property,
  not Temporal's), so the pair lands whole or not at all. Failover re-runs `gate(C)/construct(C)` — pure
  functions of C — to the SAME txid → first-admit-or-dedup. Sound.
- Rests on four cited preconditions, all correctly surfaced: Fork A one-transaction; the door's atomic
  admit; **one single writer per lineage across DCs** (T-2 l.34-36 — no active-active ledger door); **axis
  separation** (T-3 l.12-13). Each is forbidden-to-violate, not assumed-away.
- Precision (not a break): "unnameable even if a buggy worker emitted one" (T-1 l.178) is exact for the
  **honest-constructor failover** case. A Byzantine constructor bundling a **forged pass** does get an
  admission record; what saves that is D7's decidable-predicate recheck at audit, a SEPARATE guarantee —
  do not conflate the two. For S7-as-posed (interrupted honest work), HOLDS.

## Item 4 — the four new load-bearing invariants. **Three HOLD; (I2) has a load-bearing cross-file BREAK.**
- (I1) one single writer / one door per authoritative lineage across DCs (T-2 l.34-36). SOUND; it is the
  base ledger's single-writer axiom, consistent with the spine and untouched by the record kinds. ✓
- (I3) the refold is a pure fold and recomputes no model in-fold; re-derivation is forward/out-of-fold
  (T-3 l.6-7). SOUND; it is exactly "kind-2 outputs are immutable leaves," which is what makes the fold a
  pure function → idempotent → crash-atomic. The deepest of the four; consistent with the three kinds. ✓
- (I4) versioning-axis separation — Build-ID pinned per run, model/recipe/dynamic version a log lineage
  fact, failover moves the region only (T-3 l.12-13). SOUND; consistent with the lineage discipline
  (txid over recorded VERSIONS, not over worker code). ✓
- **(I2) BREAKS on cross-file consistency.** T-1's pinned key (l.31-35) is `(input-cut,
  model/recipe/dynamic-version)` + seed, and **explicitly excludes** numerical-environment version *with a
  correctness reason* ("including it would admit two environments as two facts and **reopen the race**").
  T-4 D10 (l.30) and T-5 (l.3, l.7) **include env-version** (and T-4 also **drops dynamic-version**). This
  is not cosmetic: env-in-key makes two environments **two facts**, which contradicts the D16 β mechanism
  that is *defined to bound the spread across* those very values, and — under a live-hardware reading of
  env — would give an S7 cross-DC split-brain **two distinct txids → two admissions**, breaking Item 3's
  "exactly one lands." Pin the key to T-1's form (env OUT, dynamic-version IN); fix T-4 D10 and T-5.

## Item 5 — NEW defects from the r4 edits.
- **(a) [load-bearing] Idempotence-key contradiction — the sharpest.** As Item 4/(I2): T-1 pins env OUT
  with a race-reopening argument; T-4 D10 + T-5 keep env IN and T-4 drops dynamic-version. My r3 R-5
  ranked this "minor"; the r4 pin *created* the contradiction and made it load-bearing (β coherence +
  conditional S7 double-admit). Must pin to T-1.
- **(b) One symbol not achieved.** β (T-1) vs ε_repro (T-4) vs τ (T-5) all live. One-name-rule.
- **(c) Content-hash "structurally never fires" is over-stated (deletion still safe).** T-1 l.112-114 /
  T-4 D14 l.34 justify deletion by "zero firings." True for the intra-run **retry** race (memoised bytes);
  but under S7 split-brain two `runModel` payloads DO reach the one door under one txid, where the compare
  *would* fire — the design simply chooses not to look, deferring divergence to β/TA-REPRO. Deletion is
  safe (β covers it); the justification should say "never fires for the retry race it was built to catch,"
  and T-1 ("deleted") vs T-4 ("deletable, retained as optional diagnostic") should say the same thing.
- **(d) [new hole from the move] Consumption-locus coverage obligation, unstated.** Moving the check off
  the single door (correct) replaces one chokepoint with N valuation legs. The design must now show **no
  valuation path consuming a kind-2 surface escapes a β-checking leg** (the "bare valuation read" analog
  of the forbidden bare read). T-4 D16 locates the check at "the valuation chain reading the surface as a
  leaf" but never states this is *every* such consumer. Add it as an executable property (must fire).
- **(e) [wording] T-4 D16 "door checks PRESENCE … (present in lineage, well-formed, versioned)"** reads as
  refuse-on-absent, colliding with T-1's "admit-and-flag, never refused." Reconcilable (D16's own
  no-attested-class → consumption broken chain proves it admits), but align the verb to T-1's "records
  whether present."

---

## Survival property to demand — remaining red-team scenarios

- **S4 (retry storm at the one door). DEMAND: exactly-once-admission is invariant under unbounded
  redelivery, arbitrary interleaving, AND a door crash-restart** — i.e. dedup is a total function of the
  **durable log**, never of an in-memory in-flight set or of which retry arrives first/last, and no
  distinct txid is starved. This is the sharpest remaining property: S1 and S7 both reduce to
  "exactly-once at the door"; if dedup is decided against in-flight state, a storm + restart double-admits
  and retroactively breaks both.
- **S3 (history-limit / ContinueAsNew mid-CA-sandwich). DEMAND: a CAN taken at ANY point inside the
  before-mark / operator / after-mark / certificate sandwich rehydrates to the byte-identical sandwich**,
  because the sandwich is a pure projection of the log reconstructible from `{cut, nodeId}` alone and CAN
  carries no partial-sandwich intermediate in workflow state (T-1 §2.3 "CAN-boundary safe" must be shown,
  not asserted).
- **S6 (poisoned-cache replay after wipe-rebuild). DEMAND: no write path from the Temporal cache to the
  ledger log** — authoritative state is a function of the log alone (R-02), so wipe-and-rebuild yields
  byte-identical chain/states/verdicts and a poisoned cache entry can never have been admitted as a fact
  (a replayed poisoned firing carries a cause-derived txid that either dedups or fails structural
  validity). Poison degrades to a liveness/replay incident, never a wrong admitted fact.
- **S2 (workflow-code deploy mid-backtest). DEMAND: every admitted fact is a function of its recorded
  lineage terms (cut, seed, recipe/dynamic version), invariant under Build-ID** — a pinned run replays on
  its pinned Build-ID with no history-divergence non-determinism, and no code deploy can alter a recipe
  default, a seed, or a cut (the I4 axis-separation, exercised: orchestration change ⇏ economics change).
- **S5 (clock skew vs the three times). DEMAND: no admitted fact's three times, and no position in the
  committed total order `(exec, door, hash)`, is ever authored by a worker/timer wall clock** — all three
  times are read from the log and the door's commit sequence is the sole tiebreak, so arbitrary skew
  between workers/DCs is at most a liveness effect (a watch fires late), never a safety effect (a wrong
  time or a wrong order). Two skewed DCs replaying the same events must commit the identical order.
