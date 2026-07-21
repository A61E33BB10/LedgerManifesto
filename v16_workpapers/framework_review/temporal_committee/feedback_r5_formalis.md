# FORMALIS — Referee feedback, Round 5 (Temporal Committee, Part II) — S4 RED-TEAM + r4 FIX AUDIT

Remit: verdict on S4 survival (exactly-once-admission as a total function of the durable log), the
r4 load-bearing idempotence-key fix, the D10 reconcile, the one-symbol rule, the COVERAGE totality
obligation, and any new defect from the r5 edits. Round 5 of ≥10; no consensus (reserved for ≥round
10). A flag without a counterexample or a named missing case is discarded.

---

## Item 1 — S4 SURVIVAL / EXACTLY-ONCE-ADMISSION. **HOLDS.**
- Total-function-of-log stated exactly: T-1 §4 l.137-141 — dedup "decided against the committed
  txid-set *on the log*, never an in-memory in-flight set or arrival order," invariant under "N
  redeliveries × W racing workers × a door crash-restart," "each distinct txid admitted exactly
  once and none is starved." T-4 §2 l.47-51 mirrors it.
- Admit is stated as an ATOMIC UNIQUE-KEY INSERT, not check-then-append (T-1 l.136-137; T-4 D10
  l.33; T-2 A1 l.11-15). The TOCTOU is closed by counterexample: T-2 A1 exhibits the double-admit
  under check-then-append (SELECT→SELECT→APPEND→crash→APPEND = two rows), then shows the unique-key
  insert admits {txids durably on the log}, retry/crash-count-independent. Correct.
- Storm + DC split-brain closed: T-5 crux (ii) — substrate split-brain is harmless (both clusters
  propose the same txid to the ONE door, which serializes); door split-brain is FORBIDDEN by
  single-writer, made un-representable by I1's fenced lease (T-1 l.166) + quorum log (T-5). The
  T-2 injectivity attack (A2/A3) holds: env-out never collides distinct facts; the sole residual is
  the exact-grained-input-cut precondition (Item 6). Differing-payload-under-one-txid → first-wins +
  β-bounded discard (T-1 l.104-106), so admission is exactly-once even when value is arbitrary.

## Item 2 — IDEMPOTENCE KEY (the r4 load-bearing break). **HOLDS — FIXED and consistent across all files.**
- Canonical `(input-cut, model-version, recipe/dynamic-version)`, env OUT, now agrees everywhere:
  T-1 l.30-38, T-4 D10 l.33, T-5 l.4-5, T-2 l.3, T-3 l.2. The r4 divergence (T-4/T-5 env-IN,
  T-4 dropping dynamic-version) is gone; T-4 l.9-11 and T-2 A3 explicitly retract their own env-in keys.
- The correctness reason is now uniform: env-in-key mints two txids per fact under DC split-brain →
  double-admit, reopening S7 (T-4 D10 l.33; T-3 SA3 l.13; T-5 l.5). Env is lineage/Tier-2, never
  identity. The r4 Item-4/5(a) break is closed. seed handled consistently (distinct seed ⇒ distinct
  fact), modulo a one-voice arity nit (Item 6).

## Item 3 — D10 RECONCILE (dedup load-bearing, not optimisation). **HOLDS.**
- T-4 D10 l.33 reverses its r4 wording verbatim: "**Load-bearing, by construction** (my r4
  'optimisation, never load-bearing' was WRONG — S1/S7/S4 all rely on it)." T-1 l.145-147 confirms:
  "the unique-key insert is load-bearing and by-construction; only the pre-log early-drop is the
  'optimisation.'" The load-bearing mechanism (door's atomic insert on the durable log) and the
  optimisation (Temporal's own pre-log early-drop) are now cleanly separated in both files. Correct.

## Item 4 — ONE SYMBOL (β everywhere). **HOLDS (cosmetic residual only).**
- β is the sole LIVE symbol in all five files (T-1, T-4 D16, T-5 l.5, T-3 l.10/15, T-2 §3-bound).
  The r4 break — T-4 writing ε_repro ~6× live, T-5 using τ live — is fixed: ε_repro now appears in
  T-4 only as rename notes (l.13, D16 l.39), τ in T-5 only at l.3 ("β replaces τ"). No competing
  live term survives. Residual: strip the changelog rename notes before final assembly (a strict
  read of §1 "no synonyms, ever, in any document" wants even the note gone). Not a break.

## Item 5 — COVERAGE property (totality of the β-check). **HOLDS — discharges my r4 5(d).**
- Named invariant COVERAGE-β (T-1 l.119-123, listed l.174; T-4 COVERAGE row l.40). It is a
  TOTALITY claim, not existence: "No valuation path consuming a kind-2 leaf escapes the β check";
  "there is no raw path to a kind-2 leaf"; T-4 "Every valuation path ... routes through the VM-7
  leg; no read path bypasses it." Backed by executable `prop_everyKind2ConsumerChecksBeta`, MUST
  fire (zero firings = defect), the bare-valuation-read analog of D1's forbidden bare read.
- Sound. Minor: the "no raw path" is asserted structurally, not yet raised to I3's "unrepresentable
  by type" bar — name the sole selector/accessor so the raw path is a type error, not a convention.

## Item 6 — NEW defects from the r5 edits. **No NEW load-bearing contradiction; three unfolded preconditions.**
- No r5 edit introduces a cross-file contradiction (unlike r4's env-in-key). The r5 story is
  internally coherent: exactly-once-ADMISSION unconditional; value-determinism holds on the normal
  path (compute/emit split, one memoized payload) and degrades to β-bounded arbitrariness only under
  substrate split-brain / crash-before-record — each of which still admits exactly one row.
- **(a) [fold, dual of the double-admit] exact-grained input-cut.** T-2 A2 l.20-22 surfaces the
  injectivity precondition — a coarse cut label false-dedups two distinct facts → silent under-admit
  — and states "New containment: exact-grained input-cut." T-1 I2 (l.168) still says only
  "input-cut IN," not "exact-grained (log-position / content-hash), never a coarse label." Fold it.
- **(b) [fold] T-5's named requirements live only in T-5.** durable-before-ack (l.10), one-leader +
  quorum-log-per-lineage (l.12), recipe-subsumes-seed (l.5). These are load-bearing for the
  crash-restart and split-brain legs; T-1 I1 has the fence but not durable-before-ack or the quorum
  substrate. Migrate into T-1's named-invariant list (same failure mode as the r4 I2 cross-file gap:
  a precondition asserted in one file only).
- **(c) [one-voice nit] seed arity.** T-4 lists seed as a 4th key slot (l.33); T-5 subsumes it into
  recipe (l.5); T-1 says "plus seed where stochastic" (l.31). Semantics agree (distinct seed ⇒
  distinct txid); pin one form. LOW.

---

## Readiness call
**YES — safe to BATCH R6 (S3 CAN-in-CA-sandwich) + R7 (S6 poisoned-cache replay after wipe-rebuild)
with no load-bearing risk.** The r4 load-bearing break (env-in-key) is fixed and consistent; the S4
root (atomic unique-key insert, total-function-of-log) is proven and is exactly what R7's
poisoned-replay reduces to (a replayed firing's cause-derived txid dedups or fails structural
validity); R6 rests on sandwich-is-pure-projection + I3 + S1, all now stable. The three unfolded
preconditions in Item 6 are confirmations to migrate into T-1, not open conflicts, and R6/R7
exercise different machinery (projection-purity, log-sole-truth), so they do not gate the batch.
