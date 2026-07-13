# v15.1 Parking Index

Every genuine specification/Constitution conflict is PARKED here — never fudged, never silently
narrowed. Each entry carries the EXACT proposed amendment text and the EXACT clause it replaces.
`constitution_v1_2_proposed.tex` is a PROPOSAL, not an amendment; nothing in v15.1 cites it but this
index. An empty parking index across a 73pp spec means the mechanism was never exercised → run FAILED
(LEX MANDATUM + CONCORDIA both veto). Well-formedness certified by LEX MANDATUM (G3).

Well-formed entry = {finding · exact clause replaced (verbatim) · exact replacement text (verbatim) ·
rationale · where v15.1 states the conflict openly}.

---

## PARK-1 — F11 — clause-level addressability (structural, non-semantic)

**Clause replaced:** none (pure addressing; no prose changed).
**Proposed amendment:** every normative clause of the Constitution gains an identifier `C-<sec>.<n>`
(e.g. C-4.1 … C-4.n), inserted as labels only, with not one word of prose altered. Rendered in
`constitution_v1_2_proposed.tex`.
**Rationale:** "this chapter discharges §N" is unfalsifiable while §4 is eleven paragraphs of prose.
One-way authority requires the rating to be mechanical (discharge_matrix.md). Costs zero pages.
**Stated openly in v15.1:** every chapter opener lists the clause IDs it discharges; ch17§3 notes the
parking index is non-empty and cites this entry.

---

## PARK-2 — F2 — bitemporality requires two time axes (amends Const §12)

**Clause replaced (verbatim, Const §12):** "Every historical state of the Ledger is exactly
reconstructible by replaying the immutable transaction log up to the desired timestamp."
**Proposed replacement (verbatim):** "Every historical state of the Ledger is exactly reconstructible
from the immutable transaction log along two axes: a transaction-time horizon (the log prefix — what
was known) and a valid-time horizon (which recorded observations are in force). Fixing both yields a
deterministic projection; the as-known-at view over a prefix is never rewritten by a later correction,
and the as-of view recomputes bit-exactly from the prefix that includes the correction."
**Rationale:** §12 names one timestamp, one axis. §8.8's W2 has required both since Ch. 8 with no
machinery. A late observation inserted at index k recomputes the tail A_k… from k forward — a different
sequence from the log-order fold Theorem 14.5 proves. Both folds are deterministic; §12 must name both.
**Stated openly in v15.1:** ch02 (typed `project :: LogPrefix -> KnowledgeHorizon -> View`), Theorem 14.4
restated over the pair, ch02§8 rewritten (no "reinterpretation" hand-wave), cites this entry.

---

## PARK-3 — F10 — the coordinate is (plane, agreement) (amends Const §4)

**Clause replaced (verbatim, Const §4, as amended by v1.1):** "When a balance must carry more
information than a single number, it generalises to a signed vector of coordinates — owned, lent,
posted — whose named rays are: lent out and borrowed, the two signs of lent; posted as collateral and
received as collateral, the two signs of posted."
**Proposed replacement (verbatim):** "When a balance must carry more information than a single number,
it generalises to a signed vector indexed by (coordinate, agreement): the coordinates owned, lent,
posted, with named rays lent-out/borrowed and posted/received, each non-owned coordinate qualified by
the collateral or margin agreement under which the quantity sits. Conservation holds per (unit,
coordinate, agreement); the three-coordinate vector is the aggregate projection that sums over
agreements."
**Rationale:** if `posted` is a single signed axis, a wallet posting 100 under G1 and receiving 100
under G2 nets to zero and both encumbrances vanish; the Ch. 12 encumbrance projection then reads zero
for a fully-encumbered wallet. Conservation already holds per (unit, coordinate, agreement) — §9.1's
`Placement` type enforces the agreement reference on every marker leg.
**Stated openly in v15.1:** ch03§7 states the finer law as primitive and derives the 3-vector as the
aggregate projection; ch09§2 and Theorem 14.1 use `bal_{c,G}`; cites this entry.

---

## PARK-4 — F12 — deposit-neutrality is conditional (amends Const §8) — **RATIFIED (D1) 2026-07-13**

**Owner disposition (consistency pass, 2026-07-13): RATIFIED as C-8.7.** The owner accepted the
amendment below verbatim. It is recorded as a RATIFIED amendment in `constitution_v1_2_proposed.tex`
and awaits the owner's adoption into the authoritative manifesto (the owner's sole act). Until that
adoption the authoritative Constitution remains v1.1; the specification states deposit-neutrality as
holding at fair value with the day-one difference recognised as financing basis, citing the ratified
C-8.7. The original park record is retained below for provenance.


**Clause replaced (verbatim, Const §8 case 2):** "a contribution or financing received against an
equal obligation created in the same transaction — collateral received under title transfer, cash
included, is this case, owned by the receiver against an equivalent-return obligation that is itself a
unit".
**Proposed replacement (verbatim):** "a contribution or financing received against an obligation
created in the same transaction and valued at fair value, any day-one difference between the inflow
amount and the obligation's fair value being recognised as financing basis — collateral received under
title transfer, cash included, is this case, owned by the receiver against an equivalent-return
obligation that is itself a unit".
**Rationale:** Const §8 asserts deposit-neutrality UNCONDITIONALLY ("cannot change net owned value").
Proposition 7.3 makes it a theorem "exactly when the declared financing rate equals the fair rate,"
and relabels the residue "a financing basis, not a deposit." NAV *does* move at receipt of off-market
financing. That is a constitutional guarantee narrowed and the residue relabelled so it still reads
true — the archetype the run screens for. Park the conflict openly; do not paper it over.
**Stated openly in v15.1:** Proposition 7.3 states the conflict openly and cites this entry; ch17§3's
"parking index is empty" is rewritten to false (as it should be).

---

---

## RATIFIED-D4 — F2 (consistency pass) — the observation stream has no discipline (clarifies Const §1/§4/§5) — **RATIFIED (D4) 2026-07-13**

**Clause replaced (verbatim, Const §4 / C-4.8):** "...and the **record** is everything that has been
recorded --- the log and all it carries, transactions, events, and observations alike. `On the record'
means present there, and a projection is any view computed from it."
**Ratified replacement (verbatim, C-4.8):** "...and the **record** is everything the log carries. Every
observation whose reproduction the framework guarantees enters the record only as a moveless
transaction --- admitted through the one Transaction Executor and folded into a home --- the
*observation-recording transaction*. An event is a trigger: it carries timing, not admitted data. No
observation is exempt from the one door, so the single canonical record of §1 and the single writer of
§5 extend without exception to every observation. In the typed picture of §3 the contract and the fold
consume the ledger unchanged, because the observations a contract reads are home facts folded into the
ledger. `On the record' means present there, and a projection is any view computed from it."
**Rationale:** v15.0's observation stream had a second admission door with no invariants — "half the
record has no discipline." The ruling (Option 1) is that an observation is a moveless admitted
transaction through the ONE door; the record IS the log. This CLARIFIES (does not narrow) C-1.4 (one
canonical record) and C-5.1 (one writer); Theorem 14.4 already assumes it. "data" (mass noun) replaces
the memo's loose "datum" per Const §6.
**Stated openly in v15.1:** ch03 §3.5 (record = log), ch08 (Ingest recast as untrusted ingestion
contract proposing a moveless observation-recording transaction), ch04 (Events Executor proposes, never
writes), ch02 (typed-picture note), ch14 (subsection + Thm restated over the record), ch15
(prop_replayReconstructsRecord). Recorded as a RATIFIED amendment in `constitution_v1_2_proposed.tex`;
awaits owner adoption into the authoritative manifesto.

---

## Consistency-pass Track-1 dispositions (owner gate, 2026-07-13)
- **D1** (deposit-neutrality, §8/C-8.7): **RATIFIED** — see PARK-4 above.
- **D2** (invented conflict-arbitration order among the six commitments, §2): **CONFORM SPEC** — no
  constitutional change; ch01 §1.2 strikes "ordered" and states joint non-negotiability. No park.
- **D3** (trade-date booking of `owned`, §4): **CONFORM SPEC** — no constitutional change; the booking
  moment is a declared term of the agreement (default trade-date), with the settlement-date branch
  added. §4 unchanged. No park.
- **D4** (observation discipline, C-4.8): **RATIFIED** — see RATIFIED-D4 above.

## Status (after consistency pass, 2026-07-13): PARK-4 (D1/C-8.7) and the new D4 (C-4.8) are RATIFIED by
## the owner. PARK-1 (F11 addressing), PARK-2 (F2/§12 bitemporal), and PARK-3 (F10/§4 coordinate) are
## unchanged from Phase A — this pass did not gate them; they remain OPEN. Parking index is NON-EMPTY
## (required). LEX MANDATUM G3 well-formedness: PENDING re-certification for the consistency pass.
## Shipped-doc reflection: ch17§3 rewritten (Phase 1) — "index empty" → enumerates PARK-1..4 with the
## clause each touches, cites open statements at ch02/Thm timetravel (P2), sec:coordinate-vector/Thm
## conservation (P3), ch07 (P4). Build exit 0, 79pp. F12 (Phase 3) adds the ch07 Prop 7.3 open statement
## that PARK-4 points to; PARK-2/PARK-3 open statements already in (F2/F10).
