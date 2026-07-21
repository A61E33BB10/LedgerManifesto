# Temporal Committee — Round Log

Protocol: Part II of FrameworkReview. 5 independent temporal-engineer instances (TEMPORAL-1..5, opus),
two referees per round (FORMALIS opus; TuringAward general-purpose opus loading Turingaward.md).
Iterate 10–15 rounds. Consensus = all 5 members + both referees concur in same round, never before r10.

## Round 1 — independent proposals
- Launched all 5 in parallel with identical mandate before any writes shared (independence enforced by parallel spawn).
- Each read: temporalv16.tex, ledger_manifesto_v1_41.tex, MarketDataManifesto_1.3.tex, ValuationManifesto_1.0.tex, ledger_v16_1.tex (ch04/substrate/ch08 min).
- Output: proposal_TEMPORAL-N_r1.md (N=1..5).

## Round 1 — referee feedback (complete)
FORMALIS (feedback_r1_formalis.md): strongest-on-rigor = TEMPORAL-4 (broadest grounded catalogue; only one to name bare-read D1 + attribution-convention D13). Set-wide unresolved obligation: recorded VALUE of a re-entered observation is deterministic only if the model is bit-reproducible given recorded inputs+seed; under at-least-once retry two attempts present same cause-derived txid with different payloads — door preserves exactly-once ADMISSION (first-wins) but canonical value turns on a door-arrival race. No proposal contains it. Per-proposal defects: T1 "two record kinds" undercounts (gate decision is a 3rd, recorded event-outcome); T2 stance "only execution orders fold" contradicts its own (exec,door,hash); T3 all-marks-on-Schedule collides VM-3; T4 asserts prevention+defers it in Q4; T5 collapses broken-chain/gate-fail/door-refusal into one row.
TuringAward (feedback_r1_turingaward.md): §4 anti-bias — all 5 PASS. Spine settled (10 points). Genuine forks: A) MD-16 write atomicity (single-transaction TEMPORAL-5/-1 vs record-pass-then-construct TEMPORAL-2 — atomic pole wins per MD-12); B) valuation re-mark cadence (Schedule sweep TEMPORAL-3 vs per-unit watch TEMPORAL-4/-5 — resolve by contractual-vs-system split, temporalv16.tex:58-59,99); C) models-queue split (SOFT, load-model param, not architecture); D) sim fan-out shape (low-stakes, decomposition not correctness). Under-specified seam: production derived stream vs isolated sim namespace. Nominations: TEMPORAL-1 = mapping base; TEMPORAL-4 = divergence-catalogue base.

## Round 2 — members revise (in progress)
Resumed all 5 with both feedback files + all 5 proposals (convergence now permitted). Steer: resolve Fork A (atomic single-transaction), Fork B (contractual/system split), close the value-reproducibility gap, pin production-vs-sim namespace seam. Encouraged mergers toward T1 (mapping) / T4 (catalogue).

### Round 2 — member revisions (complete)
Files: T1_r2 196L, T2_r2 121L, T3_r2 155L, T4_r2 155L, T5_r2 176L. Reported convergence: T2/T3 cede mapping/catalogue bases to T1/T4; Fork A single-transaction pole adopted; Fork B contractual-vs-system split adopted; determinism gap closed (two members converging on same rule). Referees (fresh) convened on r2 set.

### Round 2 — referee feedback (complete)
FORMALIS (feedback_r2_formalis.md): determinism gap CLOSED at read-back but NOT consistent across members — two collision axes: (i) bit-reproducibility as admission precondition (T-5 requires it; T-3/T-4 say requiring it violates C-Scope.11); (ii) mechanism M1-remove-race (T-1/T-5 compute/emit split) vs accept-race+diagnose (T-4 content-hash) vs accept-race+never-compare (T-2) vs accept-race+embrace (T-3). Recommended merge "not performable" until these resolve. Fork A atomicity CONVERGED; refuse-vs-flag tie-break NOT pinned (3-2). Sharpest still-open: nobody BOUNDS |Pi-Pj| — read-back proves byte-reproducibility, not that the mark is within VM-6 tolerance of an honest re-derivation.
TuringAward (feedback_r2_turingaward.md): §4 all pass. Forks A/B/C/D + namespace seam SETTLED. New fork A′ (refuse-vs-flag on base moved under pinned cut between pinCut and door-admit): answer = FLAG, certified upstream (MD-16/KLEPPMANN: correction flags m* stale-forward, m* stays as-known-at-cut; C-11.3 is a STRUCTURAL guard not a freshness check). Livelock counterexample (90s model / 45s corrections) kills REFUSE. T-3/T-4 must flip. Also: T-5 §3b "admission-time contract" narrows out-of-scope-numerics boundary → yield to §3c. Assembly: T-1 mapping + T-4 catalogue (D15→FLAG), fold T-2 idempotence-key/seam, T-3 two-tier determinism/versioning/Fork-B, T-5 compute/emit split/env-pin/loci table.

### Round 3 — members resolve residual forks (in progress)
Steer: (1) A′→FLAG (T-3/T-4 flip, T-2 make explicit); (2) scope boundary one-voice (bit-reproducibility NEVER an admission precondition; env-pin is governance-optional Tier-2; T-5 §3b→§3c); (3) determinism merge-hygiene actor boundary (compute/emit PRIMARY + env-pin Tier-2 + content-hash OPTIONAL diagnostic; substrate never compares, door may record hash without changing canonical); (4) VALUE-LEVEL bound — tie admissible re-entry spread to VM-6 tolerance via a door-checkable predicate w/o model knowledge (producer-attested reproducibility class in lineage); (5) wording three-kinds (T-5 fix). T-1 grows toward consensus assembly base. Red-team scenarios begin R4.

(entries appended per round below)
