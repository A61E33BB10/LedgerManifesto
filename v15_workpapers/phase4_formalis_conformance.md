# Phase 4 — FORMALIS Conformance Matrix (Ledger Specification v15.0)

**To:** v15 orchestrator, for disposition
**From:** FORMALIS (Leroy, chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad)
**Date:** 2026-07-12
**Authority:** rated one-way against the Ledger Framework Constitution v1.1
(`LedgerManifesto/leddeger_manifesto.md`). Read-only pass: no chapter edited.
**Inputs:** Constitution v1.1; the 17 chapter drafts
`Ledger_Spec_v15.0/ledger/drafts/ch01…ch17`; the ratified Phase 1 Design Ruling
`v15_workpapers/phase1_design_ruling_memo.md`.

> *"We verify that the specification is a proof of the constitution, pass by pass —
> that every section is discharged, and that nothing is claimed without a section to
> ground it."*

---

## 0. Method

The constitution is the theorem; each chapter is a proof obligation opened by its own
"discharges §X" line. The matrix is **total** iff (A) every constitution section maps to
≥1 chapter and (B) every chapter traces to ≥1 section. We verify both directions, audit
each chapter's discharge claim for accuracy (does it discharge what it names?) and for
over-reach (does it assert normative content with no constitutional basis?), then confirm
the three v1.1 amendments, the coverage invariant, and the absence of any genuine conflict.

### The authority's sections, enumerated

The manifesto.md carries an Abstract, fourteen numbered sections (§14 split into §14.1 and
§14.2), an unnumbered **Scope** section, a **Conclusion**, and **Authority and Amendment**
with an **Amendment record**. The project-memory names "Purpose / Principles / Method"
correspond to constitutional content as follows, and the correspondence is used below:

| Named element (CLAUDE.md framing) | Manifesto.md locus | Normative? |
|---|---|---|
| Purpose | Abstract + §1 (Objective and the Problem) | yes (§1) |
| Principles | §2 (The Six Commitments) | yes (§2) |
| Method | §3 map-then-fold + the build-order paragraph; adversarial-review is a *production* discipline | §3 is normative; the review method is not a dischargeable ledger property |
| Scope | "Scope of the Ledger Project" | yes |
| Amendment record | under "Authority and Amendment" | yes (records the three v1.1 amendments) |

Abstract, Conclusion, and the production "Method" are non-normative; they require no
dedicated chapter and their absence from the matrix does **not** break totality.

---

## 1. Direction A — every constitution section maps to ≥1 chapter

| Constitution section | Primary chapter | Also discharged / cited by | Verdict |
|---|---|---|---|
| §1 Objective and the Problem | Ch01 | Ch12 (report = projection of the one record) | **discharged** |
| §2 Six Commitments | Ch01 | auditability+reproducibility → Ch12; Testability → Ch15; Clarity → Ch13; recurs in every chapter | **discharged** |
| §3 Whole architecture (map, then fold) | Ch02 | Ch11, Ch12 (projection basis) | **discharged** |
| §4 The Objects (**amended** — A2, A3) | Ch03 | Ch09 (amended collateral clauses); Ch14 (conservation law) | **discharged** |
| §5 The Machines | Ch04 | Ch16 (restated as M1–M7) | **discharged** |
| §6 Smart Contracts | Ch05 | Ch09 (agreement/claim/obligation units); Ch13 (every right/obligation a unit) | **discharged / partial** (see F-1) |
| §7 State: The Three Homes | Ch06 | Ch14 (one-writer) | **discharged** |
| §8 Valuation and PnL (**amended** — A1) | Ch07 | Ch09 (three-case regime mechanics) | **discharged** |
| §9 Corporate Actions & Market Data Operator | Ch08 | Ch14 (invariance witness); Ch16 (B1–B6) | **discharged** |
| §10 Strategies, Virtual Ledgers, TRS | Ch10 | Ch07 (TRS reference-leg NAV); Ch08 (the bridge is an observation) | **discharged** |
| §11 Structural Invariants | Ch14 | Ch06 (writer discipline); Ch15 (tested) | **discharged** |
| §12 Time Travel, Replay, Idempotence | Ch14 | Ch06 (rebuild by replay); Ch15 | **discharged** |
| §13 Two Layers of Correctness | Ch15 | Ch04 (trust boundary); Ch14 | **discharged** |
| §14.1 Event Monitor / Events Executor minima | Ch16 (M1–M7) | derived in Ch04 | **discharged** |
| §14.2 Pricing Stack / Pricing Data Layer minima | Ch16 (V1–V6, B1–B6) | derived in Ch07, Ch08 | **discharged** |
| Scope of the Ledger Project | Ch17 | Ch11 (settlement-projection layer, a named scope item) | **discharged** |
| Authority and Amendment (one-way rule) | Ch17 (constitutional-parking rule) | Ch01 (rated against v1.1) | **discharged** |
| Amendment record (A1/A2/A3) | Ch03 (A2, A3), Ch07 (A1), Ch09 (amended clauses) | — | **discharged** (see §3) |

**Direction A holds: every normative section maps to ≥1 chapter.** No section is orphaned.

---

## 2. Direction B — every chapter traces to ≥1 section, and its claim is accurate

| Ch | Opening discharge claim | Grounded? | Over-reach? |
|---|---|---|---|
| 01 | §1, §2 | yes — objective + all six commitments, each with the consequence it forces | none |
| 02 | §3 | yes — map/fold, typed picture, clock, proposal-vs-authority, not-event-sourcing | none |
| 03 | §4 as amended (A2, A3) | yes — objects + signed basis; A2/A3 verbatim | Product-graph is additive but anchored to §4+§7+§2 Clarity (F-3, low) |
| 04 | §5 | yes — three machines, one writer, trust boundary | none |
| 05 | §6 | yes — purity, statelessness, faithfulness | §6's managed-account consequence not worked (F-1) |
| 06 | §7 | yes — three homes, one-fact-one-home, one-writer, rebuild-by-replay | none |
| 07 | §8 as amended (A1) | yes — NAV, path-independent PnL, three regime-keyed cases, deposit-neutrality | Dual-valuation additive but anchored to §1+§8 (F-3, low) |
| 08 | §9 | yes — corporate actions, market data operator, three principles | Registry/W1–W4/convention-slot additive but anchored to §9+§12+§2 |
| 09 | amended §4, §8, and §6 for its agreement units | yes — conforms to the ruling in full (see §4) | none (derived guards constitutionally sanctioned) |
| 10 | §10 | yes — virtual ledger, strategy, slippage, TRS one definition | none |
| 11 | Scope (settlement-projection layer); cites §3, §4 | yes — settlement is an explicit scope item; projection basis is §3/§4 | none |
| 12 | §1, §3; §2 auditability+reproducibility | yes — reporting = projection; no reporting store | Regulatory templates named but held out of scope (no over-reach) |
| 13 | §6; §2 Clarity | yes — via CDM demonstration, "shown never adopted" | CDM not in constitutional-scope enumeration (F-2, low) |
| 14 | §11, §12 | yes — conservation law, structural laws, time-travel/replay theorems, coverage | none |
| 15 | §13; §2 Testability | yes — two layers, generator universe, three binding gates | none |
| 16 | §14.1, §14.2 | yes — M1–M7, V1–V6, B1–B6, all cross-referenced | none |
| 17 | Scope | yes — in/out lists, open-problems index, constitutional-parking rule | none |

**Direction B holds: every chapter traces to ≥1 section, and no chapter claims a section it
fails to discharge.** No false discharge claim was found.

---

## 3. Totality verdict

- Direction A (section → chapter): **YES** — every normative section has ≥1 chapter.
- Direction B (chapter → section): **YES** — every chapter has ≥1 grounding section.

**The conformance matrix is TOTAL: YES.**

The only asymmetry worth recording is structural, not a defect: three chapters
(Ch11 settlement, Ch12 reporting, Ch13 CDM) anchor to the **Scope** section and to §1/§3
rather than to a dedicated numbered section, because the constitution deliberately carries
no dedicated section for settlement projection, reporting, or CDM. This is consistent with
the constitution and is how the projection machinery of §3 is meant to be extended.

---

## 4. Verification of the three v1.1 amendments

### Amendment 3 — §4 list sentence: the signed coordinate basis (owned, lent, posted)

Constitution v1.1 §4: *"…it generalises to a signed vector of coordinates — owned, lent,
posted — whose named rays are: lent out and borrowed, the two signs of lent; posted as
collateral and received as collateral, the two signs of posted."*

**Ch03** (Coordinate Vector): *"it generalises to a signed vector of coordinates:
(owned, lent, posted). The five constitutional names are the rays of this basis — lent out
and borrowed are the two signs of lent; posted as collateral and received as collateral are
the two signs of posted."* Reinforced by "A move writes exactly one coordinate … so
conservation holds per (unit, coordinate)."
**Verdict: faithfully realised.** The five constitutional names survive as rays; the
physical-action admission test ("a quantity earns a coordinate only when a distinct
real-world action can change it independently of ownership") is stated verbatim.

### Amendment 2 — §4 mass-never-value sentence

Constitution v1.1 §4: *"The remaining coordinates carry mass, never value: they record
possession and encumbrance under a named agreement, no quantity reaches them without
reference to the agreement unit that governs it, and a lifecycle event extinguishes value,
never mass — a unit leaves the ledger only from the zero vector."*

**Ch03** carries this sentence essentially verbatim after "Only the owned coordinate carries
economic value and drives profit and loss." **Ch07** operationalises it (the one-touch
mark collapses 400,000 → 0 while the OT-1 mass stays on owned). **Ch09** enforces it
(retirement only from the zero vector; the supervised write-off clears marker planes *to*
zero *then* retires — reaching the zero vector by recorded moves, never retiring from a
non-zero vector).
**Verdict: faithfully realised, and exercised as a machine-checkable property**
(Ch12 mass–value-separation; Ch14 post-and-return; Ch15 TLA+ `NoDoubleCount`).

### Amendment 1 — §8 three-case, regime-keyed inflow

Constitution v1.1 §8: three cases — (1) exchange paired with equal-valued outflow, STM
margin; (2) contribution/financing against an equal obligation, title-transfer collateral
(cash included) owned against an equivalent-return obligation unit; (3) custody without
ownership on the collateral-received coordinate, security-interest collateral without right
of use — *"which case governs it is declared once, on that agreement unit."*

**Ch07** enumerates the three cases in order, keys them on "the legal regime declared once
on the governing agreement unit," and proves deposit-neutrality via the
**Proposition [Deposit-neutrality of title-transfer financing]**: the case-2 return
obligation is a *valued* unit priced at par-plus-accrued, so net owned value cannot move at
receipt — closing exactly the item the memo left for the v15 text.
**Ch09** realises the mechanics as the four-row cash-margin table (STM = settlement;
CTM/title-transfer = financing; security-interest-no-right-of-use = custody;
security-interest-with-right-of-use = financing upon exercise), total and fail-closed, with
the fourth row a refinement collapsing into case 2 on commingling.
**Verdict: faithfully realised.** The three constitutional cases are preserved and
sharpened; the fourth (right-of-use) is the ruling's D5 refinement, consistent with §8.

**All three amendments are faithfully realised in Ch03 / Ch07 / Ch09.**

---

## 5. The coverage invariant — stated identically wherever it appears

Task target form: `Σ_G posted_G(w,u) ≤ max(owned(w,u), 0)`.

| Location | Statement | Match |
|---|---|---|
| Ch09 (collateral, "The two guards") | `\sum_{G} posted_G(w,u) \le \max(owned(w,u), 0)`, net over agreements, "same bound with lent in place of posted" | **exact** |
| Ch14 (Invariant, Possession coverage) | `\sum_{G} posted_G(w,u) \le \max(owned(w,u), 0)`, received ray positive, "analogue with lent in place of posted" | **exact** |
| Ch12 (reporting, Encumbrance bound) | "reported encumbered mass never exceeds `max(owned, 0)`" | **consistent read-back** |
| Ch15 (testability, TLA+ Safety) | `Coverage(s) == \A (w,u): postedMass(w,u) =< Max(owned(w,u), 0)` | **consistent** |

All four carry the **`max(·,0)`** form (the ruling's DEFECT-9 / Attack-7 correction: the
bound binds only the posting direction, so a negative-owned issuer wallet or plain short
with nothing posted is admissible). No chapter reverts to the pre-correction `Σposted ≤
owned` form that would refuse lawful shorts. The lent-plane analogue and the
received-ray-positive-sign convention are carried in both the exercising chapter (Ch09) and
the cataloguing chapter (Ch14). **Coverage-invariant conformance: clean.**

---

## 6. Ch09 conformance to the ratified ruling memo

Every load-bearing decision of the ruling is realised in Ch09:

| Ruling decision | Ch09 realisation |
|---|---|
| One representation, regime-keyed coordinate | opening section, `Regime = Settlement \| Financing \| Custody` |
| D1 title-transfer cash: owned + return-obligation unit at par+accrued | "Cash under title transfer is the same shape …"; nostro-divergence rationale |
| D2 title-transfer securities: owned re-books + claim-for-equivalent + obligation | "Title transfer: owned re-books; the claim is a unit," pricing/identity/timing rules |
| D2 market-claim over the instruction-to-settlement gap | stated in Ch09, machinery carried in Ch11 (MC-1, entitlement-routing proposition) |
| D3 pledge: marker mass, owned untouched; post-and-return metamorphic property | "Pledge: marker mass under the coverage bound" |
| D4 line valuation default, package admissible as declared data | "Line valuation" |
| D5 cash margin four cases, total, key fallible | "Cash margin: four cases, one machine" + regime-bit repair (terms amendment **plus** compensating rebooking) |
| Two guards: coverage = invariant, sufficiency = obligation | "The two guards" |
| Determination reads owned; payment via conditional obligation with trapping predicate; no unconditional pass-through | "Entitlements: determination and payment" |
| Micro-case (c) worked to the zero vector; order forced by coverage | "The knock while pledged," six steps |
| SBL corollary: lent plane, title-transfer financing on the lending axis | "The lent plane: securities lending" |
| Supervised write-off retirement path | "Retirement, and the supervised write-off" |

**Ch09 conforms to the ruling in full.** The TALEB correction ("conditional leg whose
condition may be vacuous, never an absent leg") is honoured: "in the ordinary state the
condition vanishes, never the leg; an unconditional issuer-to-owner pass-through is
forbidden."

---

## 7. Findings — gaps, over-reach, conflict

### F-1 (MEDIUM) — §6 managed-account fee accrual / NAV attribution: partial discharge

Constitution §6, final paragraph: *"Treating the client's redemption claim as a valued unit
has direct consequences for fee accrual and NAV attribution in managed accounts; these
consequences are resolved in the detailed specification consistently with the principles
stated here."*

The v15 spec **states the principles** — redemption claim is a valued unit (Ch03),
mandate rulebook is a non-valued unit (Ch03, Ch07), subscription is booked as an exchange
(Ch05) — but **does not work the promised consequence**: there is no episode, formula, or
section resolving fee accrual or NAV attribution across a managed-account mandate. A grep
confirms the mandate/redemption terms appear only as classificatory examples (Ch03:18,28,29,
121-122; Ch05:227-228; Ch07:36) and the words "fee accrual" / "NAV attribution" appear
nowhere. Nor is the item named in Ch17's open-problems index (which lists close-out/netting,
correction algebra, inter-ledger federation).

This is a **partial discharge**, not a conflict: the constitution explicitly deferred this
to "the detailed specification," and the detailed specification neither works it nor parks
it. The clean disposition under the constitution's own discipline (implementation questions
are *named and left*, never silently dropped) is to add it to Ch17's open-problems index.
No constitutional amendment is required.

*Remediation:* either (a) add a short managed-account episode resolving fee accrual as an
ordinary mandate-contract entitlement and NAV attribution as the Σ owned·P projection over
the redemption-claim units, or (b) add one line to the Ch17 open-problems index naming
"managed-account fee accrual and NAV attribution" as a carried-open design question.

### F-2 (LOW) — Ch13 CDM alignment sits outside the constitutional-scope enumeration

The constitution's Scope section enumerates nine in-scope components; **CDM alignment is not
among them**, and the constitution's body never mentions the CDM. Ch13 nonetheless exists and
Ch17's in-scope list adds "Alignment with the Common Domain Model — shown, never adopted as
authority."

This is **defensible, not a defect**: Ch13's *discharge target* (§6 "every right and
obligation is a unit," and §2 Clarity "behaviour as declared data") is fully grounded, and
the constitution's Method expressly permits *satisfying* a binding standard without
*adopting* it ("shown to satisfy the regulation and standards that bind them — never adopted
because a standard mandates them"). Ch13 keeps the one-way authority explicit and introduces
no primitive. It is therefore a §6/§2 **demonstration**, not new normative content — the
thinnest constitutional anchor in the set, but not over-reach. Recorded for the orchestrator's
awareness only.

### F-3 (LOW) — additive-but-anchored mechanisms

Three chapters introduce mechanisms the constitution does not name explicitly, each derived
"from first principles" (as the constitution's Correctness/Method require) and each anchored:
- Ch03 **product graph** (nodes/edges/guards/actions) — anchored to §4 (units carry
  terms/state/contracts), §7 (state), §2 Clarity (declared data).
- Ch07 **dual valuation** (mark-to-market vs mark-to-mid over one composition) — anchored to
  §1 (one position record removes settlement-vs-risk drift) and §8.
- Ch08 **datum-kind registry, W1–W4 failure regimes, boundary-convention slot** — anchored to
  §9 ("never improvised at read," "originals never overwritten"), §12 (reproducibility), §2.

None contradicts the constitution; each is the kind of derived design the constitution
endorses. No action required; listed for completeness.

### Constitutional conflict

**None.** The constitutional-parking index in Ch17 is empty, and this review confirms it
should remain empty: no chapter contradicts Constitution v1.1. In particular —
- the **coverage invariant** (door-checked) does not conflict with §4's "conservation by
  construction": conservation remains a law (Ch14 Theorem), coverage is a *separate* derived
  guard, and §5 already sanctions door-checks (authorisation, idempotence, consistency of
  reference, writer discipline);
- the **supervised write-off** does not conflict with §4's "leaves the ledger only from the
  zero vector": it *reaches* the zero vector by recorded compensating moves, then retires;
- **title-transfer securities on owned** (D2) does not double-count against §8: value is
  conserved across poster (claim-for-equivalent) and taker (asset owned + redelivery
  obligation).

No amendment text is proposed for Ch17, because no genuine conflict exists.

---

## 8. Ranked discrepancies for disposition

1. **F-1 (MEDIUM) — §6 managed-account fee accrual / NAV attribution is neither worked nor
   parked.** The one constitutional promise ("resolved in the detailed specification") the
   v15 spec leaves open without naming it. Cleanest fix: one line in Ch17's open-problems
   index, or a short Ch07 episode.
2. **F-2 (LOW) — Ch13 CDM alignment is outside the literal constitutional-scope enumeration.**
   Defensible as a §6/§2 demonstration and as satisfying-not-adopting a binding standard;
   recorded so the orchestrator can confirm the intent is deliberate.
3. **F-3 (LOW) — three additive-but-anchored mechanisms** (product graph, dual valuation,
   boundary registry/W1–W4/convention slot). Derived and grounded; no action needed.

---

## 9. Committee verdict

**Totality: YES.** Every constitution section is discharged by ≥1 chapter; every chapter
traces to ≥1 section; no chapter claims a section it does not discharge.

**Amendments: faithfully realised.** A1 in Ch07 (+ Ch09), A2 and A3 in Ch03 (used in
Ch07/Ch09/Ch12/Ch14/Ch15).

**Coverage invariant: clean.** `Σ_G posted_G(w,u) ≤ max(owned(w,u),0)` stated identically
in Ch09 and Ch14 and consistently in Ch12 and Ch15.

**Conflict: none.** The constitutional-parking index is correctly empty.

**Residual:** one MEDIUM partial-discharge (F-1) and two LOW notes (F-2, F-3). The
specification discharges the Ledger Framework Constitution v1.1; discharge is total up to
the single named promise of §6, which should be worked or parked before freeze.

— Leroy, for the FORMALIS committee
