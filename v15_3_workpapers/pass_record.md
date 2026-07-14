# v15.3 Event Universe Pass — Record (Phase B)

Base: certified v15.2 (`64c5330`). Ruling: Phase A memo + owner gate 2026-07-14 — C-4.12
RATIFIED (awaiting adoption into the manifesto, the owner's sole act); one registry, two
kind-columns; quarantine discipline confirmed. Page cap holds (<100).

## Phase B forced consequences
1. ch08 §8.3: event-kind column + mandatory routing on the existing registry (one mechanism).
2. ch04: Events Executor capture path — "responsible" becomes a defined word (the contracts
   registration names); unroutable arrivals recorded as **quarantined events** (one name).
3. ch08 W4 rewire: record-then-refuse-processing; the refusal on the record; nothing lost.
4. Later processing: cause = the recorded quarantined event; idempotent; valid-time per W2;
   registry versioned declared data read in force at each position.
5. ch16 new minimum: no captured event is lost — every arriving event is recorded, or its
   refusal is recorded.
6. ch15: prop_registryTotality, prop_routingDeterminism, prop_quarantineNeverDrop,
   prop_lateRegistrationReplay — each with firing floors under the §2 standing gate.
7. C-2.8 identity: the registry is the alphabet of the paths that could have occurred.
8. ch17: register entry for C-4.12 (ratified-awaiting-adoption). Note: the v15.2 brief ran
   W1–W6 with no W7, so no v15.2 ch17 open-problems entry exists for the event universe to
   close; recorded here so the audit trail is exact.

## Certification — COMPLETE
| Reviewer | Verdict |
|---|---|
| Adversarial + FORMALIS-delegate | C-4.12 discharge FAITHFUL; emitted side INTACT; properties sound. 1 BLOCKING finding (M8 unbacked over malformed/provenance-less arrivals — the L3/L4 hole) → REPAIRED with its preferred fix: the **capture envelope**, stamped source+log-position and recorded BEFORE payload validation; W4 gains the failed-validation trigger; bare-read pull vs pushed arrival distinguished. 5 minors applied (awaiting-adoption citations; "responsible" forward ref; park→recorded sweep; genRegistry vacuity guard + prop_registryRouted_fires; registry-in-force cross-ref). Page-cap recommendation: 100 compliant. |
| CONCORDIA (absolute veto, signs last) | **SIGNED 2026-07-14.** Repairs confirmed (no circularity in the envelope); 104-clause two-way map preserved by construction (no header touched; C-4.12 cited, never claimed adopted); sweep clean; page cap ruled compliant at the HARD CAP 100 (reserve drawn to preserve normative minima). See `concordia_signoff.md`. |

## Status: SIGNED — the v15.3 Event Universe pass is certified.
Final build 100pp (= ratified hard cap), exit 0, datum=0, boxes=4, "quarantined event" the sole
name of the recorded object. C-4.12 remains ratified-awaiting-adoption — the manifesto is the
owner's to amend.

---

# v15.3.1 Housekeeping Pass (Constitution v1.3)

Authority: `ledger_manifesto_v1_3.tex` (committed 2cb905c BEFORE drafting). One clause changed:
C-4.12 ADOPTED with the owner's two deltas — the generalisation (quarantine covers every
unprocessable arrival, matching what v15.3 built) and the arrival bound (the guarantee runs from
arrival; the perimeter is a named trust assumption).

- **H1** adoption sweep: all awaiting-adoption citations → adopted in v1.3; constitution citations
  v1.3 (v1.2 RULING mentions kept as history); ch17 C-4.12 entry CLOSED in v1.3 noting the owner's
  generalisation; parking index declared FULLY CLOSED, six resolutions the evidence. (3b6e80b)
- **H2** TA-ARRIVAL added as the fourth named trust assumption (TA-KIND pattern; wording verified
  against the ADOPTED clause); count 3→4; ch04/ch08 discharge text aligned with the arrival bound.
- **H3** scope check: NO sentence states or implies capture before arrival. Sweep of "never
  lost/never dropped/nothing lost/unconditional": every capture claim is arrival-scoped
  ("Capture of every arrival...", M8's "Every arriving external event...", the W4 quarantine
  sites); non-capture hits (deposit-neutrality history, valuation recomputation, conditional legs)
  are unrelated. Expected result confirmed: none.

Certification: adversarial reviewer (stale-language + overreach sweep) → FORMALIS (no normative
property changed) → CONCORDIA (115-clause audit vs v1.3, C-4.12 discharged as adopted) — pending.

Certification COMPLETE: reviewer+FORMALIS all five sweeps CLEAN (1 polish nit applied: "no
captured event is lost" at the ch16 Verification summary); CONCORDIA VETO (C-4.12 discharge-header
orphan — the C-6.6 situation; register named four claim sites no header carried) → repaired with
its one-line ch:marketdata header extension (joint pointer to ch:machines/ch:testability/
ch:requirements) → **SIGNED 2026-07-14**. 115/115 clauses two-way complete. 100pp = hard cap.
The v15.3.1 housekeeping pass is certified; the parking index is fully closed with its history.
