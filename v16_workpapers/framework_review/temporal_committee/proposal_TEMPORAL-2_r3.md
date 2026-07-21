# Temporal Committee — TEMPORAL-2, Round 3

## MERGE INTO proposal-1

My distinct value (the re-entry idempotence key and the Q2 constitutional-seam list) is adopted
committee-wide and folds cleanly into the nominated mapping base (TEMPORAL-1, three record kinds +
lineage discipline) and catalogue base (TEMPORAL-4, D1/D7/D13/D14/D15). I hold **no distinct
architecture** that competes with that assembly. I therefore declare a merge and continue as a
reviewer. This file states the four positions T-1/T-4 should carry across verbatim, with my two R2
defects corrected. Nothing here reopens the spine, Forks A/B/C/D, or the namespace seam — all settled.

---

## 1. Fork A′ — I take FLAG explicitly (closing the window I was silent on)

My R2 claimed the base "cannot move between gating and construction." That is true only of the
**internal** gate evaluation (all activities read one pinned cut). It was **silent** on the
**pinCut→door-admit window**, where the single writer can admit a correction to a consumed input at
≤C before the derived-state transaction lands. I take the FLAG side of that window explicitly:

- A correction to a consumed input admitted in that window **flags m\* stale-forward (MD-8/MD-10)**;
  m\* is admitted as-known-at-C and **remains the value it was gated as**. It is **not** retroactively
  refused. This is the **certified** MD-16 dynamics reading, which I verified at source:
  *"the gate and the constructed m\* are one projection-evaluation over that single pinned cut … A
  later correction to one of m's inputs does not create a TOCTOU: it flags m\* stale forward via
  MD-8/MD-10 … m\* remaining the as-known-at-cut value it was gated as"* (`kleppmann_dyn_review.md`
  l.15). The single writer decides this, on the refold — not the door, not the gate.
- **Refuse** is reserved for exactly two construction-time verdicts: a **gate fail/undecidable** (the
  gate decides) or an **unresolvable structural reference** (the door decides). It is never a
  freshness verdict.
- By the committee's own three-kind taxonomy this is forced: the m\* **state** is kind-2 (a re-entered
  observation → stales on a consumed-input move); the gate **decision** is kind-3 (pinned as-known,
  not stale-on-input-move). REFUSE conflates the two.
- **C-11.3 is a structural consistency guard** (quantity/price-coordinate consistency; the VM-9
  phantom-valuation / zero-PnL guard), **not** a tip-freshness check. T-4 D15 and T-3 §2b invoke it
  as a stale-cut refusal; that misreads the clause and must flip to FLAG.
- **Optional, never load-bearing:** a producer-side freshness pre-check (re-read the tip before
  proposing; skip and re-pin if C is already superseded) is a livelock-avoidance optimisation only —
  the FLAG path catches any born-stale state that races through, so correctness never rests on it.
  (The refuse pole would livelock: a 90s calibration with corrections every 45s never converges.)

## 2. Determinism — two R2 defects corrected, one actor boundary stated

- **Correction (my R2 over-promise).** My "Primary (dissolve the race)" over-claimed: pinning a
  numerical-environment **version** is a governance label and does not *make* a GPU-atomics model
  bit-reproducible. The actual race-removal mechanism is the **compute/emit split** (T-1 §3, T-5 §3a):
  run the model once, memoise its output, and let door-propose re-present identical bytes — Temporal
  records exactly one activity result, so retries carry identical payloads and no two differing
  payloads ever reach the door. I **cede** primacy to that mechanism. The env-version pin is **Tier-2**
  (governance-optional, dispute-readiness re-derivation), never the race fix.
- **Scope one-voice (adopt).** Bit-reproducibility is **never** a door/admission precondition
  (out-of-scope numerics, C-Scope.11). Canonical-by-first-admission is the spec default; the
  env-version pin is a Tier-2 governance term caught at audit. My R2 wording must not read as making
  reproducibility an admission gate. (This also retires T-5 §3(b)'s "admission-time contract"
  phrasing in the merged artifact.)
- **Actor boundary (my carried contribution, reconciled with T-4 D14).** My "substrate never compares
  payloads" and T-4's "door records a content-hash" are **not** in conflict once the actors are named:
  the **substrate** (untrusted orchestration) never retries-for-value and never compares two attempts'
  payloads — on any doubt it re-reads the admitted value. The **door** (the trusted single writer)
  **may** record a content-hash **diagnostic** beside the txid without changing which value is
  canonical (still first-admitted). Substrate-side comparison would smuggle a value judgement into the
  untrusted layer; door-side diagnosis is a trusted-writer observation. Both hold. In an M1
  compute/emit-split design the diagnostic is a residual guard for a buggy fused worker, not a primary
  mechanism — so it is complementary, not competing.

## 3. Value-level bound — I endorse and sharpen FORMALIS's still-open obligation

Read-back alone proves record self-consistency, not that the mark is one an honest independent
re-derivation would produce within tolerance. To close the gap at the **value** level, tie the
admissible re-entry-value spread to the **VM-6** tolerance via a **producer-attested reproducibility
class** carried in the re-entered observation's lineage — a label the **door can check without holding
model knowledge** (it checks the class is declared and permitted for the data kind, not the numerics).
A model attesting a "bounded-divergence within VM-6" class permits canonical-by-first-admission
soundly; a model that cannot attest it exposes that its recorded mark is one arbitrary member of
{P₁,P₂,…} and is dispute-ready only trivially. This keeps model numerics out of scope (the door checks
a lineage label, not a computation) while refusing to let canonical-by-record admit a mark outside the
dispute tolerance. I offer this as a committee obligation, not a T-2-only row.

## 4. Wording to carry into the merged artifact verbatim

- **Re-entry idempotence key (D4, adopted committee-wide):** every re-entry — re-entered observation,
  MD-16 gate decision, valuation-chain link — dedupes on the recorded
  `(input-cut, model/recipe/dynamic-version, numerical-environment-version)` identity, **never** a
  Temporal run/attempt id.
- **Q2 constitutional-seam list (adopted committee-wide):** three seams tested and each already
  resolved — (i) derived stream as a "second store": no, same immutable-log mechanism on a distinct
  lineage (C-2.8, C-12.5); (ii) gate-decision storage vs recompute-on-read (C-4.11): a pinned
  event-outcome, not a live projection (MD-16), *strengthened* by the Fork-A single transaction;
  (iii) late-CA sandwich vs Temporal compensation: the reordering path. Live neighbour: Valuation
  **PARK-1** (valuation storage) — this design must **not** turn it on. The index is exercised, not
  merely empty.

---

**Reviewer standing.** With §1–§4 carried, I have no open design point and no dissent from the T-1 +
T-4 assembly. Remaining committee work is FORMALIS/CONCORDIA certification of the exact
C-11.3-vs-MD-8 clause reading (§1) — a confirmation, since the answer is already on the record — and
folding the value-level bound (§3). I will review the assembled artifact against the spine, not
re-author.
