# Proposal TEMPORAL-3 (Round 3) — MERGE INTO proposal-1

**Declaration.** My distinct contributions are adopted committee-wide and folded into the
assembly target (mapping base TEMPORAL-1, three record kinds + lineage discipline; catalogue
base TEMPORAL-4). I therefore **merge into proposal-1** and continue as reviewer, carrying
across three things confirmed adopted — the **two-tier determinism contract**, the **three
versioning axes**, and the **Fork-B split** — and correcting my two R2 defects exactly as both
referees direct. I also contribute the one obligation the whole set still owes: the
**value-level bound**. I relitigate nothing settled.

---

## 1. Correction — Fork A′ flipped from REFUSE to FLAG (my R2 §2b retracted)

I **retract** R2 §2b: "a stale cut at construction … is refused … the state never existing."
That was wrong, and it contradicted my own §1 taxonomy. Adopt **FLAG** (T-1 §2.2 / T-5 §4
wording), which is the certified MD-16 answer, not a committee vote:

- The scenario is a correction to a consumed input admitted at ≤C in the **pinCut→door-admit
  window**. The constructed state m* is **admitted as the as-known-at-cut value it was gated
  as**, and the **single writer flags it stale-forward on the refold** (MD-8/MD-10) — not the
  door, not the gate.
- By our own three-kind taxonomy: **m\* is kind-2** (a re-entered observation → stales when a
  consumed input moves) and the **gate decision is kind-3** (pinned as-known, never stale).
  REFUSE conflated the two — it tried to make a kind-3 decision "meaningless" on a later base
  move, which its own definition forbids.
- **C-11.3 is a structural consistency-of-reference guard** (the quantity/price-coordinate
  guard, VM-9's phantom-valuation / zero-PnL guard), **not a tip-freshness check.** My R2
  "broken state forbidden by construction" for a moved base misread it; a moved base is not a
  broken state.
- **Refuse is reserved for two loci only:** a gate **fail/undecidable** verdict (the gate
  decides), or an **unresolvable structural reference** (the door decides). Neither is a
  moved-but-resolvable base.
- **Livelock proof (why REFUSE is not merely inelegant but wrong):** a 90 s GPU calibration
  pins C at t=0; a correction lands at t=45 s; the derived-state transaction lands at t=90 s.
  Under REFUSE the door refuses, re-pins, re-runs the 90 s model — and under corrections every
  45 s it **never converges** (an L3 termination defect). FLAG admits and flags forward:
  progress guaranteed.
- **Optional, never load-bearing:** a producer-side freshness pre-check (re-read the tip before
  proposing; if C is already superseded, skip and re-pin) is a permissible *optimization* — the
  flag path catches any born-stale state that races through, so correctness never rests on it.

The exact C-11.3-vs-MD-8 clause reading routes to CONCORDIA/FORMALIS for a certifying signature;
the answer is already on record (MD-16 as certified: a later input correction "flags m* stale
forward … m* remaining the as-known-at-cut value it was gated as").

## 2. Correction — the vendor-print analogy retracted; compute/emit split is the primary mechanism

I **retract** R2 §2a's "which retry lands first is which 'print' the record captures, exactly as
source-arrival order resolves two simultaneous vendor prints." FORMALIS is right: two vendor
prints are two **distinct facts from two sources**; two retries of one model on identical inputs
are **one fact computed twice with numeric drift**. Relabelling a nondeterminism source as
legitimate observation-multiplicity was assertion where proof is owed.

Adopt the **compute/emit split** (T-1 §3 / T-5 §3a) as the **primary** mechanism, which
*structurally removes* the door-arrival race rather than tolerating it:

- **Never fuse model-eval with door-propose.** The model runs **once**; its output is the single
  recorded Temporal activity result (memoized in history); any retry is a retry of **door-propose
  only**, which re-presents **identical bytes**. One payload ever reaches the door.
- Tier-1 read-back canonical is then deterministic **by construction, within a run** — not by
  fiat, not by relabelling. The two-tier contract stands; this is the mechanism that makes its
  Tier-1 floor sound.

## 3. Scope-boundary line — held (T-5 §3b yields)

Canonical-by-first-admission is the spec default; **bit-reproducibility is never a
door/admission precondition** — that would pull out-of-scope numerics into the fold
(C-Scope.11). The numerical-environment pin is a **governance-optional Tier-2** dispute-readiness
term, caught at audit, never an admission gate. This is a §1-narrowing guard: dispute-readiness
must not quietly become an admission gate.

## 4. Substantive addition — the value-level bound (the obligation still open)

Read-back proves you can reproduce the recorded **byte**; it does **not** bound the value spread
across independent re-derivations. For a non-bit-reproducible model the recorded value is one
member of {P₁,P₂,…}; if |Pᵢ − Pⱼ| can exceed the VM-6 residual tolerance, then "reproduces
bit-for-bit against the record" is satisfied only trivially — self-consistency of the record, not
correctness of the mark. Close it **without** giving the door model knowledge:

- Carry a **producer-attested reproducibility class** in the lineage (an extension of the third
  versioning axis) — a **label the door checks, never numerics it evaluates**. The class states
  the producer's re-derivation guarantee: *bit-exact under env-version X* (strong), *within-ε*
  (bounded-divergence, ε a declared term), or *non-reproducible* (weak).
- A mark whose **use** demands dispute-readiness (a collateral-call mark, a disputed valuation)
  must carry a class whose **ε ≤ the VM-6 dispute tolerance** for that use; the door checks the
  attested class against the declared requirement. A label check, not a model check — so the
  scope boundary of §3 holds while the admissible re-entry-value spread is tied to VM-6.
- **Composition:** compute/emit (§2) removes the intra-run race (Tier 1); the class attestation
  bounds the inter-derivation spread (Tier 2). Together: canonical-by-record cannot admit a mark
  outside the dispute tolerance for a dispute-consumed use.
- **Actor boundary (merge hygiene, reconciles T-2/T-4):** the **substrate never compares
  payloads**; the **door** (the trusted single writer) may record a content-hash as a *diagnostic*
  without changing which value is canonical (still first-admitted). Under the compute/emit split
  this diagnostic fires only on a buggy fused worker — a residual guard, not a mechanism.

---

## 5. Carried across (confirmed adopted; no change)

- **Two-tier determinism contract** — Tier-1 read-back (spec-mandatory), Tier-2 re-derivation
  (governance-optional, numerical-environment version), now with §4's reproducibility class as
  its door-checkable predicate.
- **Three versioning axes** — Temporal orchestration (Build-IDs) / contract economics
  (ProductTerms on the log) / model-recipe-dynamic-declared-term versions on the log (extended
  with the numerical-environment version and the reproducibility class).
- **Fork-B split** — system EoD marks → Schedule sweep; contractual/CA/input-moved re-marks →
  per-unit watch; and (T-4/T-5 canonical wording) the sweep's pricing activity **reads the unit's
  node/frame/cut from the record (VM-2)**, so even the system sweep is frame-correct.

## 6. Open (nothing new from me)

1. **Fork A′ clause certification** — CONCORDIA/FORMALIS to sign the C-11.3-vs-MD-8 reading;
   confirmation of an on-record answer, not a new decision.
2. **Load model** — the standing gating unknown (Forks C, D stay soft; decide against the load
   model, not in committee).

**Parked constitutional conflicts: none.** FLAG keeps m* as the as-known-at-cut fact the single
writer stales forward; the reproducibility class is a declared lineage label, not out-of-scope
numerics; every value keeps the log as sole truth.

**Assembly recommendation (unchanged from TuringAward's path):** merged mapping on TEMPORAL-1
(three kinds), catalogue on TEMPORAL-4 (D15 corrected to FLAG), folding in T-2's idempotence key
+ seam list, my two-tier determinism + versioning axes + Fork-B split + §4 value-level bound, and
T-5's compute/emit split + env-version + loci table.
