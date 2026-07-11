# Phase 1 Consultation — TESTCOMMITTEE (Beck, Hughes, Fowler, Feathers, Lamport)

Summoned by MINSKY. Question: testability consequences of the collateral ruling.

## (1) Answer

### (i) Property-test surface: split model (A) vs universal model (B)

The decisive metric is §2: *one representation is one generator universe.* Count the
generator shapes and the oracle branches.

**Model A (split).** The generator cannot emit a well-formed collateral history without a
case analysis. Cash collateral is a move on `own` plus a return-obligation object living
in loan-unit state; securities collateral is a move on `coll_post`/`coll_recv` with no
such object. Crossed with `legal_regime` (title transfer vs security interest), that is
~4 structural families, and the obligation-object machinery exists on the cash path only.
The **valuation oracle branches on regime**: security interest reads `V = Σ(own+coll_post)·P`,
title transfer reads `V = Σ own·P`. So model A carries:

- *Generated:* cash-shape ∪ securities-shape ∪ obligation-object generator ∪ regime tag.
- *Oracled (checked, not definitional):* (a) cash/securities equivalence — that "posted
  is still owned by poster" holds via `coll_post` for securities but via a separate
  obligation object for cash, a **cross-representation consistency property that must be
  checked**; (b) the per-regime valuation branch. Both are branches where a mutation
  (wrong branch selected) *survives* — Feathers' mutation surface is large, definitional
  guarantees few.

**Model B (universal).** One generator: histories of single-coordinate paired-leg moves
over uniform coordinate-vector units, plus a declared-terms data generator (eligibility
schedule, haircut function) attached to the collateral-agreement unit. Regime is realized
**by which coordinate the posting move targets** — title transfer moves mass off `own`
(booked like cash collateral: sale-with-return); security interest retains `own` and marks
encumbrance. Consequently:

- *Generated:* one move stream + one declared-terms record. No structural case split.
- *Definitional (unviolable, tested once at the move constructor):* coordinate conservation
  and paired legs (Noether); entitlements-follow-owned (lifecycle wired to `own` only);
  **only-owned-drives-PnL with no regime branch** — `V = Σ own·P` always, because the
  regime is already expressed in coordinate placement. The §4 tension the brief flags
  dissolves: it is resolved by construction, not by a checked branch.
- *Oracled:* collateral value from declared terms (one pricing pipeline, no per-type
  branch); margin liveness; close-out completeness.

**Net:** B moves conservation, entitlements, and regime-valuation from *checked* to
*definitional*, and collapses ~4 generator families to 1. A's saving is illusory — its
"simpler" cash path buys a second representation of ownership that must then be reconciled.

### (ii) Model B core properties (P-invariant style)

- **P-B1 Coordinate conservation.** ∀ unit `u`: `Σ_w Σ_c bal_w(u,c)` is invariant under
  every transaction except issuance/redemption of `u`; every move writes one coordinate
  with `Σ_endpoints Δbal = 0`.
- **P-B3 Entitlements-follow-owned.** ∀ lifecycle event `e` on `u`: the manufactured
  payment/entitlement is credited in proportion to `own_w(u)`, independent of
  `posted`/`received`/`onloan` mass — possession never entitles.
- **P-B4 Collateral-valuation-from-declared-terms.** ∀ agreement unit `a`, pledged package
  `Π`: `collat_value(a,Π) = f(eligibility_a, haircut_a, P)` with **no dependence on the
  unit type** of members of `Π` — cash, bond, and option value through the same pipeline.
- **P-B5 Regime-by-coordinate / only-owned-drives-PnL.** ∀ wallet `w`:
  `PnL(w) = Σ_u own_w(u)·P(u)`; legal regime enters only via the coordinate a posting move
  targets, so the valuation function contains no `legal_regime` branch.
- **P-B6 Margin-call liveness.** ∀ history with `exposure(t) > posted_value(t) − threshold`:
  a margin-call obligation with deadline exists (safety: under-collateralization is always
  witnessed by a live obligation), and every reachable state eventually reaches
  `discharge ∨ close-out` before deadline breach (liveness).
- **P-B7 Close-out completeness.** ∀ close-out of `a`: afterwards all mass on `a`'s
  collateral coordinates returns to `own` of its beneficial owner net of the settled claim,
  and **no unit remains on any coordinate referencing `a`.**

### (iii) Trap case (c) as a property — the knock-while-pledged oracle

The oracle problem is solved metamorphically (Chen): the un-pledged run *is* the oracle for
the pledged run. Define the possession transform `pledge(H,u,a,[t0,t1])` = the history `H`
with `u` added to `a`'s `posted` coordinate over `[t0,t1]`, **changing no other coordinate**.

> **P-B(c) Possession-invariance of lifecycle.** ∀ `H,u,a` with a barrier knock at
> `τ ∈ [t0,t1]`: in `pledge(H,u,a,[t0,t1])` versus `H` — (1) the barrier event fires at the
> same `τ`; (2) the payout is credited to the same owner (the poster, who retains `own`);
> (3) `price(u,t≥τ)` is identical, so `a`'s collateral value updates to the collapsed value
> at `τ` with no freeze; (4) the resulting margin state of `a` equals the one P-B6 implies
> from the collapsed value.

Any special-cased knock-while-pledged — suppressing the event during pledge, routing the
payout to the pledgee, or freezing collateral value — breaks leg (1), (2), or (3). Hughes'
shrinking reduces the counterexample to the minimal history: one unit, one pledge interval,
one knock inside it. No bespoke oracle is written.

### (iv) Verdict — whom does Hughes generate against?

**Model B, decisively, with far fewer generator special cases.** B is one generator
universe (§2 satisfied literally); A forces the generator to branch cash/securities × regime
and forces the valuation oracle to branch on regime. Every branch is a place the generator
can be wrong and silently under-sample the trap region — A's securities-shape generator
would never emit a *one-touch option* pledged, because an option is neither its cash case
nor its plain-securities case; the barrier trap (c) is unreachable without a *third* hand-
written generator case. Under B, "one-touch option pledged" is just mass on the `posted`
coordinate of a unit whose declared terms carry a barrier — the generator reaches (c) for
free, and P-B(c) catches the special case automatically. Hughes generates against B.

## (2) Domain constraints the ruling must respect

- **Noether's theorem.** Conservation (P-B1) is definitional *only if* moves are the
  symmetry that conserves mass — the Single-Coordinate paired-leg move must be the sole
  mutator. If any projection or lifecycle handler writes balances directly, conservation
  drops back to *checked* and the win is lost. **Bind: no balance write except through a move.**
- **ISDA CSA / GMSLA-GMRA.** Title transfer (English-law CSA / GMSLA) vs security interest
  (NY-law CSA) are declared contract data, not architecture — this authorizes regime-by-
  coordinate (P-B5). GMRA para 5 / GMSLA manufactured-payment clauses **require** the coupon
  on pledged collateral to be manufactured to the collateral provider — this *binds* P-B3
  and settles micro-case (b): the poster receives the coupon, on `own`, via the entitlement
  firing on ownership.
- **Metamorphic testing (Chen et al., 1998).** The possession-invariance relation is the
  named technique that supplies the missing oracle for (c); the ruling should record that
  the barrier trap is testable *because* an oracle-free metamorphic relation exists.

## (3) Risk in answering Q2 "yes"

1. **Enlarged trusted surface (Commandment 5).** Routing heterogeneous collateral (options,
   structured notes) through the ordinary pricing layer means P-B4 and P-B6 inherit that
   layer's model risk and any non-determinism. The barrier knock in (c) requires the market
   data operator to deliver a *deterministic, replayable* barrier observation; absent that,
   P-B(c) and P-B6 go flaky. Determinism must be pushed to the data boundary (NAZAROV's
   concern), or the win is nominal.
2. **Liveness needs a model checker, not QuickCheck (Lamport).** P-B6 is a temporal
   property, and the knock creates a race between three firings — barrier event,
   revaluation, margin-call obligation. If their order is under-specified, an interleaving
   can violate P-B7 (close-out completeness) while every example test passes. **This
   requires a TLA+ invariant over the (event, revalue, call, close-out) state machine;**
   property tests alone will not discharge it.
3. **Non-compositional package valuation.** P-B4 must value the *package* (option-floored
   portfolio), not the lines, or the floor is invisible. Package valuation does not shrink
   to its members, so Hughes' shrinking is weaker on exactly the case the ruling advertises.
   Manageable, but the generator needs a package-aware minimizer.

## (4) Recommendation

Rule Q2 **yes**, on the testability ledger it is strictly superior: B is one generator
universe, it converts conservation, entitlements-follow-owned, and regime-valuation from
checked branches into unviolable-by-construction invariants, and it makes the trap case (c)
reachable and oracle-free through a single metamorphic relation — the split model A cannot
reach (c) without a third bespoke generator case and leaves a branchy valuation oracle where
mutations survive. Two conditions bind the ruling: (i) *no balance write except through a
single-coordinate paired-leg move*, or Noether-conservation reverts to merely checked; and
(ii) *the knock-while-pledged interleaving must carry a TLA+ safety/liveness proof*, because
P-B6 and P-B7 are temporal and the barrier-revalue-margin race is not discharged by property
tests. Grant those two and the universal model is the one a testing team can actually
specify the system from.
