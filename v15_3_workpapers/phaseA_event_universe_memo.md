# The Event Universe — Phase A Findings Memo (OWNER GATE)

**To the owner.** This memo is the whole of Phase A. No specification text has been drafted.
Phase B does not start before your ruling. Base: certified v15.2 (commit `64c5330`, 99pp,
CONCORDIA-signed). Authority: Constitution v1.2. Evidence sweep: KLEPPMANN; assembly:
orchestrator; adversarial verification: CONCORDIA-delegate — all load-bearing citations
checked verbatim; two substantive corrections (the C-4.8 scope reading and the loss-path
count) found and applied below; the decision asks were confirmed well-founded.

**Your working hypothesis — tested, not assumed — is confirmed for the captured side:**
the framework does assume every received event has a smart contract to map it, the
assumption is a theorem for *emitted* events and unsecured for *captured external* events,
and the third edge (the store) is a live defect: an unprocessable arriving event is lost,
not recorded.

---

## 1. Where routing totality is silently assumed

The load-bearing undefined word is **"responsible."** It appears at ch04:86–88 ("fires the
responsible smart contract"), ch02:73–78, ch03:47, ch10:114 — and the Constitution itself
echoes it (C-3.4, C-5.4) without defining a map for captured events.

**Derivable (no gap):**
- *Emitted events* — by construction. Invariant Graph consistency (ch03:367–376): every
  fired event matches exactly one out-edge of a declared product graph, and the watch list
  IS the out-edge set (ch03:309–312). The responsible contract is the declaring unit's.
- *Captured corporate actions on a referenced underlying* — the corporate-action out-edge
  (ch03:328–337) makes these match a declared guard.

**Silently assumed (the gap):** all other captured external events. A dividend
*announcement* (ch05:67–71: "the stock's smart contract fires on the announcement" —
asserted, not derived), trade fills, external fail notices (ch11:376–377), settlement
confirmations (ch11:348–350), SL recalls (ch13:169–174). The ch05 trigger class `External
Observation` (ch05:127–142) reaches the system from outside rather than from a declared
product-graph out-edge, so no graph edge names its contract — ch05:144's watch language
notwithstanding, no closed, total, declared routing map exists for captured kinds.
ch08's registry declares the *operator* per (data-kind, event-kind) pair
(ch08:171–172) — it closes the value-reframing question, never the routing question. No
section declares the map external-event → responsible contract(s); no clause requires it
to be total.

## 2. Every path on which an arriving event can be lost

The common mechanism: **refusal is a returned value, never a write** (ch04:107–108,
ch08:76–78, ch02:194). Four loss paths, each a refused observation-recording transaction:

| # | Path | Evidence | Scenario |
|---|---|---|---|
| L1 | W4 unmappable event | ch08:455–456, ch08:182 | CA with no declared operator arrives → refused → no record it ever arrived |
| L2 | Unregistered data kind | ch08:128, ch08:133 | novel feed crosses before registration → refused → no trace |
| L3 | Missing provenance / bare read | ch16:118–119, ch08:133 | refused → no trace |
| L4 | Generic door refusal of the obs-recording transaction | ch04:106–109, ch08:76 | failed admission → returned value → no trace |

A fifth case belongs to §1, not this table: a captured event whose recording is
**admitted** but which **no contract claims** (ch04:86–90 has no branch for it) is on the
record as a moveless observation yet is never processed — recorded but unrouted, an
**inaction defect of Gap-1**, not a storage loss. Verification caught the earlier draft
listing it here; the distinction matters to the ruling, because the repair for the four
loss paths is mandatory capture, while the repair for the unrouted case is routing
totality.

**M2, quoted exactly (ch16:39–42):** "At-least-once emission. No emitted event may be lost;
the Monitor must re-emit until the event is on the record…" — it binds **only the
Monitor's emissions**. The Executor's captures are outside it entirely. "No event is ever
lost" is a theorem for the emitted side and false for the captured side.

## 3. Event-kind registry and data-kind registry: siblings or one mechanism?

**Finding: the event-kind notion already exists implicitly, and structurally it is ONE
mechanism — one registry, two kind-columns — not a sibling store.** The type `EventKind`
already appears in the operator signature (ch08:172); "every event kind **the boundary
admits**" (ch08:178) already names the closed processable set — but it exists only as a
derived shadow of the operator schedule: an event kind is "admitted" iff an operator is
declared for it (ch08:177–183). Closure is enforced for value reframing, never for
routing. The registration discipline the brief asks about (registered before crossing,
immutable, correction = new kind + retirement) is exactly the data-kind registry's own
discipline (ch08:124–128) — building a parallel registry would mint two names for one
mechanism, which C-2.6 forbids.

**Recommendation (one name per component):** make "the event kinds the boundary admits"
an explicit declared column of the existing §8.3 registry, governing both the operator
pairing (already present) and the responsible routing (currently nowhere). A kind cannot
register without a router; the cascade case rides the existing cause-derived identifier
(ch04:121–131).

## 4. The quarantine store, and "no second store"

**Every primitive the quarantine needs already exists:** the moveless
observation-recording transaction through the one door (ch08:58–63, C-4.8); the visible,
deadline-bearing open item (ch15:59–60; M7 ch16:59–63); C-12.4's phase-0 human
disposition (ch15:67–68); the bitemporal valid-time coordinate for late processing
(ch02:113–120, W2); the cause-derived identifier making later processing idempotent
(ch04:121–131). A parked unprocessable event is then a **home fact on the one log** — no
second store (ch14: "there is one door"), no fourth home (ch06:31, ch11:167–169). Replay
across the registry's own evolution stays deterministic because the registry is versioned
declared data read in force at each point — the same discipline every declared term
already obeys.

**What the current text omits:** the W4/refusal path is a *non-recording* path. C-2.4's
"the system stops rather than improvises" is realised as stop-and-return-error, not
record-the-refusal-then-stop. The parking machinery exists but is not wired to the
capture-refusal path. That un-wired seam is the live defect.

## 5. The constitutional question — a genuine gap, amendment text parked

**v1.2 does not already cover this.** Verified clause by clause:
- **C-2.4** (fail closed): "stops rather than improvises" does not require recording the
  stopped input.
- **C-4.4** (exhaustive declaration): scoped to **watches** — the emitted/Monitor side
  only. It does not reach captured events.
- **C-4.8** (one door): its first sentence scopes only the *form* of recording (the
  moveless observation-recording transaction) to observations whose reproduction the
  framework guarantees. Its second sentence — "No observation is exempt from the one
  door" — is unscoped and reaches every observation, but it is an **exclusivity rule**
  (the one door is the only path into the record), not a mandatory-capture rule: it does
  not require an arriving observation to be recorded, and the door may refuse, a refusal
  being a returned value, never a write (ch04:107–108, ch08:76). C-4.8 guarantees
  single-writer discipline over what *is* recorded; it does not extend "no event is ever
  lost" to refused arrivals. Gap-2 stands — strengthened, since the one-door clause
  already reaches every observation yet says nothing about capture.
- **C-5.4**: "fires the responsible smart contract" — assumes responsibility exists;
  declares no map.
- **C-9.2/C-9.3**: already presuppose a "kind of event" enumeration, but operator-scoped
  only.

So: **Gap-1** — no clause requires the captured-event → contract map to be a declared,
total function over a closed universe. **Gap-2** — no clause extends "no event is ever
lost" to captures.

**Proposed amendment, parked for the owner's ruling (Section-4 style: the constitution
states the principle and delegates the mechanics; exact text, placement §4 as the next
append-only identifier C-4.12):**

> **C-4.12** The kinds of event the system can process form a finite, closed, declared
> set. An event kind is registered, on the record, before any event of that kind crosses
> the boundary, and registration names the responsible routing — the contract or
> contracts that must fire on it, defined for every event of that kind. An event of an
> undeclared kind, or one whose reference the record cannot resolve, is never processed
> and never lost: it is captured and recorded through the one door as a moveless fact
> carrying its provenance, and it stands as a visible open item until its kind is
> registered or a person disposes of it. How the registry is kept, how routing is
> declared, and how a parked event is later processed are decided in the specification.

*(Wording notes from verification: "kinds … form a finite, closed, declared set" — event
instances are unbounded, only the kinds close; and the routing sentence carries totality
alone, determinism/replay being owned by the existing clauses. Both are the verifier's
tightenings of the sweep's draft.)*

One tension verification surfaced, for your eyes: ratifying C-4.12 **mandates a change**
to the current design, not a pure addition. Today an unregistered-kind or unmapped arrival
is refused as a returned value and never written (ch08:76, ch08:128, W4); C-4.12 requires
that arrival to be recorded as a moveless provenance-carrying fact *before* processing is
refused. That override is the intended effect — wiring the parking machinery to the
capture-refusal path — and the parked arrival is a new record category the specification
must place in a home, correctly delegated to Phase B.

If you decline the amendment, the specification conforms: the quarantine and routing
machinery can be specified as design decisions (Section 4 as it stands does not forbid
them), but "an undeclared event is never lost" would then rest on a specification
guarantee with no constitutional anchor — the same shape as the pre-v1.2 observation
stream, which you resolved by adopting C-4.8.

## 6. The C-2.8 tie

C-2.8's simulated paths are "driven by generated events, folded by the same contracts and
the same door." The generator universe is seeded by closed enumerations including "the
trigger and event kinds" (ch15:96–111, ch13:138–145) — but for captured events that
alphabet is today the *implicit, undeclared* set of §3. A generated off-menu event
(ch15:115) hits either a refusal loss path (L1/L2/L4) or the recorded-but-unrouted case,
so "the same door" cannot be shown total over generated captures. **The registry is the alphabet of the paths that could have occurred**: it is
what makes the generator universe and the simulation sample space well-defined. (The
behavioural-event and corporate-action generation open problems in ch17:133–138 are this
same edge already surfacing.)

## 7. The decision asked of the owner

1. **Ratify or decline the C-4.12 amendment text above** (Gap-1 + Gap-2 closed
   constitutionally, mechanics delegated to the specification), or direct a variant.
2. **Confirm the registry ruling**: one registry, two kind-columns (an explicit event-kind
   column with mandatory routing on the existing §8.3 registry) — not a sibling store.
3. **Confirm the quarantine discipline** as sketched in §4 (moveless recorded fact through
   the one door; open item; phase-0 human disposition; bitemporal late processing;
   idempotent under the cause-derived identifier).

Phase B (v15.3) drafts nothing until you rule.
