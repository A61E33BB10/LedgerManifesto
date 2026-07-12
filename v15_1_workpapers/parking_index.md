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

## PARK-4 — F12 — deposit-neutrality is conditional (amends Const §8)

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

## Status: 4 parks filed (F11, F2, F10, F12). Parking index is NON-EMPTY (required). LEX MANDATUM G3
## well-formedness: PENDING certification.
## Shipped-doc reflection: ch17§3 rewritten (Phase 1) — "index empty" → enumerates PARK-1..4 with the
## clause each touches, cites open statements at ch02/Thm timetravel (P2), sec:coordinate-vector/Thm
## conservation (P3), ch07 (P4). Build exit 0, 79pp. F12 (Phase 3) adds the ch07 Prop 7.3 open statement
## that PARK-4 points to; PARK-2/PARK-3 open statements already in (F2/F10).
