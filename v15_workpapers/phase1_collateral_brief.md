# Phase 1 Briefing — The Collateral Ruling (v15)

You are a Support Bench agent consulted by MINSKY, who drafts the Design Ruling memo
that settles the position model of Ledger Specification v15. Answer the specific
question you were summoned with, grounded in this brief. Your answer will be logged in
the memo's consultation annex. The bench advises; the owner decides.

## Governing constitution (binding; the ruling is rated against it)

The Ledger Framework Constitution v1.0 (`LedgerManifesto/ledger_manifesto.md`) rules:

- **§4 (objects, coordinates):** "When a balance must carry more information than a
  single number, it generalises to a vector of coordinates: owned, lent out, borrowed,
  posted as collateral, received as collateral. A quantity earns a coordinate only when
  a distinct real-world action can change that coordinate independently of ownership.
  Only the owned coordinate carries economic value and drives profit and loss. Anything
  computable from the coordinates is a projection, computed when needed and never
  stored."
- **§4 (uniformity):** "Because every unit — asset, liability, or contractual
  obligation — is represented uniformly, the same move machinery and the same
  conservation discipline apply without special cases."
- **§6 (faithful representation):** "every right and obligation the legal contract
  creates is represented in the ledger as a unit."
- **§8 (unwind test / deposits):** "Every inflow of value is one of three things: an
  exchange paired with an equal-valued outflow; a contribution or financing received
  against an equal obligation created in the same transaction; or value held in custody
  without being owned (including cash received as collateral, recorded on the
  collateral-received coordinate)."
- **§2 (testability):** one representation is one generator universe; every core
  invariant is an executable check over generated products, events, and histories.
- Vocabulary is fixed: unit, wallet, balance, move, transaction, watch, the immutable
  log, projection, the Event Monitor, the Events Executor, the Transaction Executor,
  smart contract, the market data operator, the three homes, virtual wallet, virtual
  ledger. One name per component, no synonyms.

## The two questions to be ruled on

- **Q1:** Should cash follow the securities' generalised coordinates entirely — i.e.,
  is the coordinate vector (owned, lent, borrowed, posted, received, …) the
  representation for cash exactly as for securities?
- **Q2:** Should *everything* follow the generalised coordinates by design — one
  universal position representation, the outright scalar being the degenerate case
  where all mass sits on *owned*? Nothing prevents taking structured notes, bonds, or
  even listed options as collateral. The economics argue for generality: a single
  option is usually too volatile to serve as collateral, but a portfolio of stock plus
  a protective put is floored at the strike and is therefore *better* collateral than
  the shares alone — eligibility is a property of portfolios and agreements, not of
  unit types. The proposed principle: **the architecture permits anything on the
  collateral coordinates; the collateral agreement's declared terms — eligibility
  schedules, haircuts — decide what is accepted and at what value. Eligibility is
  economics, not architecture, and economics is declared data.**

## State of the art in prior specifications (archaeology; carries no authority)

Prior version v13.1 §16 ("Generalised Positions and SBL") defined a six-coordinate
vector per (entity, unit): (own, onloan, borr, coll_post, coll_recv, coll_rehyp), with:

- Single-Coordinate Move Principle: one atomic move writes exactly one coordinate of
  one unit at both endpoints; multi-coordinate operations are transactions (move lists).
- avail = own − onloan + borr, a read-time projection, never stored. Projections
  possess = avail + coll_recv; encumb = onloan + coll_post.
- **Cash collateral writes `own`, not the collateral coordinates** — a cash margin
  payment is an ordinary cash move; the return obligation lives in the loan unit's
  state. The collateral coordinates were used for non-cash (securities) collateral.
- Title transfer vs security interest as a `legal_regime` field; identical wallet
  structure under every regime; **the regime affects only the PnL/valuation
  projection**: under security interest the poster's valuation reads
  V = Σ (own + coll_post)·P — i.e. pledged collateral still valued by the poster —
  whereas under title transfer V = Σ own·P. (Note the tension with the constitution's
  "only the owned coordinate carries economic value": v15 must resolve whether
  coll_post of a *pledge* is owned-mass on a different coordinate, or whether the
  title-transfer case re-books ownership.)
- Rehypothecation as reclassification: coll_recv ↓, coll_rehyp ↑ within the taker.
- Collateral methods: cash rebate, non-cash bilateral (haircut), non-cash triparty
  (RQV), cash pool standard/EU, uncollateralised.
- Invariants P11–P20 (paired legs, on-loan consistency, collateral sufficiency, locate
  drawdown, partial-return monotonicity, SFTR completeness, settlement-state
  monotonicity, lender ownership invariance, rehyp regime compliance, avail identity);
  obligations P21–P23 (margin call = obligation object with deadline, discharge
  predicate, compensation = close-out).
- CSA margin: a wallet-level smart contract on a per-counterparty collateral wallet;
  eligibility and haircuts as contractual data in ProductTerms; exposure an observed
  valuation.

Prior version v14.0 (tour, SBL stop): five coordinates (own, on-loan, borrowed,
collateral-posted, collateral-received), rehypothecated addable by a deployment "at the
same seam"; cash collateral again on `own` with the return obligation in loan-unit
state; initial margin explicitly outside the variation-margin stream, "a collateral
position posted to the clearinghouse, booked like any other collateral"; manufactured
dividend booked on the on-loan line as its own unit and move.

## Consequences the memo must work through if Q2 is answered yes

1. Eligibility and haircuts as declared terms of the collateral-agreement unit.
2. Valuation of heterogeneous collateral through the ordinary pricing layer.
3. Portfolio-level collateral valuation, including floors created by option overlays —
   a haircut on a floored portfolio can rationally be smaller than on its naked shares;
   the design must say whether it values the pledged package or its lines.
4. Lifecycle events on pledged units — entitlements follow the *owned* coordinate, not
   possession (the manufactured-payment analogue).
5. Substitution rights.
6. The rehypothecation seam.
7. Close-out.

## The three mandated micro-cases (work them as moves/coordinates if your question touches them)

(a) Daily cash variation margin on the running future.
(b) A bond posted as repo collateral pays a coupon while pledged — who receives it, on
    which coordinate, through which contract firing.
(c) **The trap case:** a one-touch option posted as collateral *knocks while pledged* —
    the barrier event fires regardless of possession, the payout must follow ownership,
    the collateral value collapses mid-pledge, possibly triggering a margin call. A
    design that handles (c) without a special case is probably right.

## Constitution anchors the ruling must respect

The physical-action test and only-owned-drives-PnL (§4); the unwind test (§8); uniform
representation, no special cases (§4); faithful representation — the rights a contract
creates are themselves units (§6); testability — one representation is one generator
universe (§2).

## Output format

Return: (1) your answer to the specific question you were asked, decisive and concrete;
(2) where your domain imposes a constraint the ruling must respect (name the instrument,
agreement clause, standard, or theorem); (3) any risk you see in answering Q1/Q2 "yes";
(4) a one-paragraph recommendation. Keep it under ~900 words. No hedging: where practice
varies, say which variant binds and why.
