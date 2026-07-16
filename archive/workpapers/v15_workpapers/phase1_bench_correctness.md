# Bench Answer — CORRECTNESS-ARCHITECT
## Type-level and illegal-state consequences of the universal coordinate representation

Consulted by MINSKY on Q2 (universal Position vector). Answer in the brief's format.

---

## 1. Answer

### (i) Illegal states destroyed and created

**Made unrepresentable by Q1+Q2 yes.**
- *Cash collateral booked as owned value.* v13.1's cash-on-`own` exception is precisely
  the state §8 forbids: custody value indistinguishable from owned value at the
  representation level, held apart only by a side-channel (loan-unit state). Uniform
  coordinates put cash margin on `posted`/`received` and the unwind test holds by
  construction, not by a compensating obligation being remembered elsewhere.
- *Representation dispatch.* No scalar-vs-vector branch means no unit can be "in the
  wrong representation"; the outright scalar is the all-mass-on-`owned` degenerate case.
- *Regime-dependent valuation.* v13.1's V = Σ(own+coll_post)·P under security interest
  contradicts "only owned drives PnL". Resolve at the transaction shape, not the
  valuation read: **security interest** = marker mass on `posted` while `owned` stays
  with the poster (poster bears price risk — valuation reading `owned` alone is already
  correct); **title transfer** = an `owned` move to the taker paired, in the same
  transaction, with an equal-valued return-claim unit for the poster (the §8 deposit
  pattern). One valuation formula, V = Σ owned·P, both regimes; the `legal_regime`
  valuation switch is deleted.

**Made newly expressible (raw vector), and how each is excluded.**
1. *Non-owned mass without provenance* (cash on `borrowed` with no loan; an option on
   `coll_recv` with no agreement). Exclude **by construction**: a move whose coordinate
   is non-owned has no agreement-free constructor — `AgreementRef` (the agreement unit,
   which §6 already requires to exist as a unit) is a mandatory field of the move type.
   Orphan collateral mass is not refused; it is unwritable.
2. *Ineligible collateral admitted* (a naked one-touch on `coll_recv` when the schedule
   excludes it). **Not typable, and should not be**: eligibility is declared data by the
   ruling's own principle. It is an admission-time check at the single door, evaluated
   against the referenced agreement's ProductTerms — a precondition-shape gate, not a
   standing invariant.
3. *Insufficient collateral.* Lawfully violated intraday (exposure moves before the
   margin call settles), so it must never be an invariant: it is an obligation object
   with a deadline and a discharge predicate (v13.1 P21 had this right).
4. *Retired unit with live collateral mass.* Exclude by type: the retirement
   constructor requires the zero vector. See (iii).

### (ii) The move principle and the conservation law

The Single-Coordinate Move Principle survives Q1/Q2 and strengthens. The move type:

    Move = { unit, coord, qty > 0, from: Wallet, to: Wallet,
             agreement: AgreementRef  — required iff coord ≠ owned }

**Coord is part of the move's identity.** Each coordinate of each unit is its own
closed zero-sum double-entry plane; a move debits and credits the *same* coordinate at
both endpoints; multi-coordinate operations are transactions (atomic move lists), per
v13.1.

**Recommended law: conservation per (unit, coordinate).** The per-unit-summed law is a
corollary, never the primitive. Reason: the summed law licenses cross-coordinate
"moves" (own → received inside one wallet) that conserve the sum while fabricating
custody or extinguishing obligations — a Goodhart on conservation that guts the unwind
test. Per-coordinate is strictly stronger, gives one independent executable check per
plane, and matches §4's physical-action test: distinct actions, distinct moves.

**Type-level bonus the memo should take:** with per-coordinate zero-sum planes,
`borrowed` is the negative ray of `lent` and `received` the negative ray of `posted`.
Store the signed basis (owned, lent, posted); keep the five §4 names as read-time
projections onto the rays. v13.1's paired-legs invariant P11 stops being a check and
becomes conservation itself: an unpaired loan leg is unrepresentable.

### (iii) Micro-case (c): the one-touch knocks while pledged

A owns one-touch O (owned = +1), pledges under security interest to B via agreement G
(A: posted +1, B: received +1, i.e. −1 on the posted plane). The barrier touches.

1. The market data operator appends the knock to O's **UnitStatus** — a unit-level fact,
   one legal writer, possession-independent. No coordinate consulted.
2. O's smart contract fires on the UnitStatus event; the payout entitlement folds the
   **owned** plane: A holds +1, so the payout cash moves to A's owned coordinate from
   the writer's wallet. B's `received` marker never enters the fold. (Manufactured-
   payment analogue, automatic.)
3. The knocked-and-paid option's price is now 0. The mass on posted/received **stays** —
   coordinates carry mass; prices carry value. At the next margin cycle G's CSA contract
   values the received plane through the ordinary pricing layer and declared haircuts,
   finds the shortfall, and fires a margin-call obligation. The CSA never knew O was an
   option; a defaulted bond on `received` would behave identically.

**No special case — provided one discipline is stated:** *lifecycle events extinguish
value, never mass.* The knock does not retire the unit; retirement is a separate
transaction admissible only at the zero vector, and the agreement's own machinery
(margin call, substitution, return) clears the marker planes first. Without that rule
the design needs an "extinguish-while-encumbered" special case — the trap the case is
set to catch. The intraday under-collateralisation between knock and call settlement is
the sufficiency-as-obligation point of (i)(3), already handled.

### (iv) The generator universe

One representation, one generator, one property universe:

- `gen_move`: (unit, coord, qty, endpoints, agreement iff non-owned); `gen_history`:
  admitted-transaction sequences. Case (c) is then a *generated* point — arbitrary units
  land on collateral coordinates for free — not a hand-written scenario.
- Structural: per-(unit, coordinate) zero-sum after every history prefix.
- The constitution's §4 as an executable metamorphic: **PnL is invariant under any move
  not touching `owned`** — insert a post/return round-trip anywhere in a history; all
  later valuations are unchanged.
- The counterfactual is the argument: v13.1's cash exception forces stratified
  generators (cash-collateral vs securities-collateral), and the cross case — cash and
  securities under one agreement — sits in neither stratum. The coverage hole is exactly
  where reconciliation breaks.

## 2. Constraint my domain imposes

Conservation must be stated per (unit, coordinate), moves zero-sum on one coordinate,
and collateral sufficiency must be an obligation, never an invariant (it is lawfully
false intraday; as an invariant it is a false theorem that either blocks legal
histories or is silently waived). Eligibility must remain declared data checked at the
single door — typing it would demand code deployment per schedule amendment.

## 3. Risk in answering yes

(a) The summed-conservation temptation — reject it explicitly. (b) Illegal-state
zealotry: attempting to type eligibility or sufficiency. (c) Title transfer left as a
valuation switch instead of a transaction shape re-imports the §4 contradiction.
(d) Missing the mass/value separation makes case (c) a special case after all.

## 4. Recommendation

Answer Q1 and Q2 yes, on four conditions: (1) conservation per (unit, coordinate),
signed basis (owned, lent, posted) with the five constitutional names as ray
projections; (2) non-owned move constructors carry a mandatory AgreementRef, so orphan
collateral mass is unwritable while eligibility stays declared data at the door;
(3) title transfer is booked as an owned transfer plus a return-claim unit, deleting
regime-dependent valuation; (4) lifecycle events extinguish value never mass, and unit
retirement requires the zero vector. Under these, case (c) needs no special case, the
generator universe is single, and the §4 PnL law becomes a machine-checkable
metamorphic property.

— CORRECTNESS-ARCHITECT, 2026-07-11
