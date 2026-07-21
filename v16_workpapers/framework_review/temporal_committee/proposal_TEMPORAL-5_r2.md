# Proposal TEMPORAL-5 — Round 2 (convergence: Fork A + the determinism rule)

**Posture.** The spine is settled; I do not relitigate it. I concede the **mapping base to
TEMPORAL-1** (two record kinds + one lineage discipline — smallest primitive count) and the
**divergence-catalogue base to TEMPORAL-4** (D1 bare-read, D13 declared-convention,
split-vs-branch). This document is a *resolution carrier*: it lands the two forks the
referees assigned me — **Fork A** (MD-16 write atomicity) and **the set-wide determinism
gap** — closes my own two named defects, and endorses the Fork B synthesis while pinning the
production-vs-simulation seam all five of us collapsed. Everything here is meant to be
folded into the TEMPORAL-1 base and the TEMPORAL-4 catalogue, not to stand apart.

Adopt committee-wide, from others, without change: TEMPORAL-2's re-entry idempotence-key
wording (`dedupe on (input-cut, model/recipe-version), never a Temporal run/attempt id`) and
its PARK-1 non-activation note; TEMPORAL-3's three-versioning-axes statement; TEMPORAL-4's
D1/D13 and the split≠ContinueAsNew line.

---

## 1. Fork A — MD-16 write atomicity (RESOLVED: single transaction)

**Rule.** The derived state `m*` and its **passing gate decision** commit as **one door
transaction over one pinned base cut** — never a pass recorded first with construction gated
on the recorded pass (TEMPORAL-2's two-write pole). MD-12 is decisive: "the two gates and the
constructed state are one evaluation over that cut," so the base cannot move between gating
and construction, *and* there is no inconsistent-read window (a recorded pass with no state,
which the two-write pole opens under at-least-once retry).

**Mechanism.** `pinCut(C)` reads one log cursor once; `apply-dynamic(C)`, `gate1(C)`,
`gate2(C)` all read that same `C`; the workflow assembles `{m*, gate-decision}` and proposes
them as one transaction whose lineage names `C`. Idempotent under retry: the txid keys on
`(dynamic, base-cut C, recipe-version, seed, numerical-environment-version)` — §3 below.
Fold in TEMPORAL-1's vocabulary: on pass, the transaction **is** the admission record; on
fail/undecidable, only the **refusal outcome** is recorded (the state is never constructed —
prevention). Consumption is by reference: a state carrying no admission record cannot be
named (MD-16), so an ungated state is unconsumable even if a buggy worker emitted one.

Prevention/detection reconciliation (my D7, adopt committee-wide): the gate is a decidable
predicate on a projection run in an *untrusted* activity; prevention is that construction
refuses to emit a failing state, and the correctness backstop is recomputation — any party
re-derives the predicate over `C`, so a mis-gate degrades to a **detectable, forward-repaired
defect, exactly as an economically-wrong contract does**. No door privilege is added.

---

## 2. My defect fixed — three returned-value outcomes at three loci (FORMALIS)

My R1 collapsed broken-chain / gate-failure / door-refusal into one mapping row. They are
three doctrinally distinct outcomes, decided by three different deciders. Name them
separately (all three are returned values, never a retryable error, never a saga):

| Outcome | Locus / decider | What it is | Record |
|---|---|---|---|
| **Broken chain (VM-7)** | the valuation **projection** (certificate) | residual over its declared bound (VM-6), or a staled leaf | a named explain line + staleness flag; a visible open item |
| **Gate fail / undecidable (MD-16)** | the untrusted **gate activity** (construction-time) | `m* ∉ Θ_AF`, or thin joint history | the refusal outcome; `m*` never produced (prevention) |
| **Door refusal (R-22)** | the trusted **door** (admission-time) | structural / consistency-of-reference / authorisation / idempotence | returned value; a blocked/overdue item |

A reader must never treat a VM-7 broken chain (a projection reading the record) as a door
refusal (an admission verdict) — different loci, different liveness, different repair.

---

## 3. The set-wide determinism gap (RESOLVED)

FORMALIS's unresolved obligation: a re-entered observation's recorded VALUE is deterministic
only if the model is bit-reproducible given its recorded inputs; under at-least-once retry,
two attempts of a float/GPU-nondeterministic model present the **same** cause-derived txid
with **different** payloads, so the door's first-wins idempotence makes the canonical value
turn on a door-arrival race. "Record the seed" does not neutralise nondeterminism at fixed
seed. My R1 named this (D2/Q3) but left it open. Closed here, in three parts:

**(a) Separate the model run from the door propose — this removes the race.** The model run
is **one non-local activity** whose output Temporal durably records in workflow history; the
door propose is a **separate downstream activity** that re-proposes that **recorded** output
under the cause-derived txid. Every propose-retry therefore carries the *identical* payload —
there is no payload race at the door. The only retry that can re-run the model is a model-
activity failure *before* its result was recorded, in which case the earlier attempt's output
never reached the door and the later attempt is the sole candidate. **Never fuse model-eval
with door-propose** — fusing is what reopens FORMALIS's race.

**(b) Draw seed and numerical-environment version into the request, before the run.** The
resolved input cut, recipe/model version, seed, **and a pinned numerical-environment version**
(the piece the seed alone omits — float/GPU/reduction-order determinism) are fixed and
recorded as the derivation request *before* the activity runs, so a re-run reads identical
inputs, and all four sit inside the idempotence key. This is not a new demand: the spec's
simulated-ledger section already requires a path be "a deterministic function of (branch
point, generator version, seed)" (spec l.3921) — the rule generalises that from simulated
paths to **every** re-entered observation. Bit-reproducibility given recorded inputs is thus
the producer's **admission-time contract**, enforced by the same recomputation defence as
economic correctness (§ trust boundary): re-derive from recorded inputs and compare; a
producer that fails is a defect repaired forward.

**(c) Reconcile with MD-14/VM-8 dispute-readiness — the honest bound.** Read-back is
unconditional (the number is on the log; C-14.15). **Re-derivation** to bit-equality — what a
dispute needs (MD-14/VM-8) — holds iff the model *and* the pinned numerical-environment
version are retained. Pinning the environment version in the lineage (my Q3) is precisely what
turns MD-14's "reproduces bit-for-bit" from aspiration into a true claim for model numbers;
without it, dispute-readiness on a model number is bounded to read-back only. So FORMALIS's two
poles are not a choice — they compose: (a)+(b) make the recorded value a deterministic function
of the record and give the door a *faithful* txid key; (c) states plainly that re-derivation's
reach is exactly the retained environment.

---

## 4. My D6 loose end fixed — moved/stale base: flag, not refuse (both referees)

A moved base is **flagged stale, never refused** — and it is a different event from a gate
refusal, which is the §2 distinction applied:

- A late observation landing **after** the pinned cut `C` leaves `C`'s prefix intact → the
  derived state stands, correctly pinned as-known at `C`; no refuse, no flag.
- A late/corrected observation landing **at or before** `C` (a lineage input moves under the
  state) → the ordinary lineage mechanism **flags it stale** (MD-8/MD-10/MD-13); it stands as
  a recorded open item for forward re-derivation. **The ledger's single writer decides this**,
  on the refold — not the door, not the gate.
- **Refusal** is reserved for (i) a gate verdict of fail/undecidable — the *gate* decides — or
  (ii) an unresolvable structural reference — the *door* decides. Neither is "a moved base."

So D6's "refused *or* flagged" resolves cleanly: **flag** (moved lineage input, ledger's job);
**refuse** only on a failed gate verdict (gate's job) or an unresolvable reference (door's job).

---

## 5. Fork B endorsed + the production/simulation seam pinned

**Fork B (re-mark cadence) — adopt the contractual-vs-system split** the spec's own text
dictates (`temporalv16.tex:58-59,99`). Neither blanket pole survives:
- **System-cadence desk marks** (book-wide end-of-day revaluation, no per-unit contractual
  meaning) → a **Schedule sweep** fanning out pricing activities over open units × declared
  chains, **reading each unit's node from the record** so it prices in the correct frame
  (this answers TEMPORAL-3's wrong-frame counterexample: the sweep reads the graph position,
  it does not price blind). Holds no chain state.
- **Contractual / input-moved re-marks** (a fixing date, a CA node needing the sandwich, a
  corrected leaf staling a link) → a **watch on the unit** (date→timer; input-moved→signal).
- A unit with many chains puts a watch only for its *contractual* chains; its *system-cadence*
  chains ride the shared Schedule — so no per-unit timer bloat (TEMPORAL-4's Q2 concern gone).

**The seam all five collapsed (pin it now).** "Derived lineage" conflates two distinct things;
credential separation (R-18/R-20) depends on telling them apart:
- A **production-serving** derived object/state (today's calibrated surface serving real marks;
  a production MD-16 derived state risk consumes) lives in the **production lineage**, is a
  distinct *stream* within it, and is admitted through the **production door** — it is
  production data. MD-16's "derived states never enter the base stream" is a *stream* boundary,
  not a *namespace* one; base-history serving (MD-4) is unaffected, but these are production
  facts on the production log under the production write credential.
- A **simulation** (scenario, backtest, authorised fork) is a **distinct namespace with its own
  lineage and its own door credential** (R-20, C-12.5, C-2.8); its derived states and chains
  live in the sim lineage's record and never touch the production log. Only a final **result**
  re-enters production as an observation through the production door (spec l.3937-3941).

So: production door admits base observations **and** production derived-stream states +
gate-decisions (one credential, one single writer, serialized); a sim namespace's door is a
separate credential. A daily production surface fit is *not* a simulation; a backtest *is*.

---

## 6. Soft forks and residual open questions

- **Fork C (models/derivation queue): SOFT — do not force.** I keep a dedicated
  models/derivation queue family (pricing, calibration, gate-eval; version-pinned, heartbeated,
  bursty, possibly GPU), but adopt TEMPORAL-3's honest posture: the mapping is identical either
  way; splitting is a load-model-gated scaling parameter, not architecture. Decide against the
  load model.
- **Fork D (sim fan-out shape): decomposition, not correctness** (TEMPORAL-2's framing). Note
  this is a *different* use of child workflows than the spine forbids: the spine bans child
  workflows for **lineage coupling**, not for history-bounding **inside** a sim namespace — so
  neither pole violates the spine. Rank below A/B; settle against the same load model as C.
- **Q1 (the standing unknown).** Event + mark + derived-state volume per underlying per run
  sizes K (ContinueAsNew), the door pool, and derived-stream storage. MD-16 joint gates are the
  data-hungriest and the most likely to report *undecidable*; their compute/latency is unmeasured.
- **Q2 (numerical-environment retention).** §3(c) makes environment-version pinning load-bearing
  for dispute-readiness. Whether the reference implementation retains environments (and for how
  long) bounds MD-14/VM-8 for model numbers — a governance decision to surface to the owner, not
  a Constitution conflict.

**Constitution:** no park. Consistent with the seed and all four peers — the log stays sole
truth; every model number and gate decision re-enters through the one door.
