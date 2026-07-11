# Phase 1 Bench Consultation — REGULATORY-REPORTER

**Summoned by:** MINSKY · **On:** collateral reporting state requirements (SFTR Art. 15 / COLU,
EMIR Refit margin fields, EBA asset-encumbrance ITS + FINREP F32–F36)

---

## (1) Answer to the question

### (i) What each regime requires, and whether it projects from coordinates + agreement terms

**EMIR Refit** (RTS 2022/1855, ISO 20022) reports margin per collateral portfolio: *initial
margin posted / collected*, *variation margin posted / collected*, *excess collateral posted /
collected* — each **pre- and post-haircut**, plus currency and a *collateralisation category*
(UNCA/PC/OC/FC). Every figure projects: post/collect value = coordinate mass (`coll_post` /
`coll_recv`) × price; post-haircut = × (1 − haircut), the **haircut a declared agreement term**;
category = a declared agreement term (one-way/two-way/threshold). **One caveat:** the coordinate
value alone does *not* separate IM from VM — both are `coll_post`. That split, and F34 below,
are projections over **(coordinate, the collateral-agreement unit the move is booked against)**.
Because §6 already makes the CSA a unit and every move lands against a unit, this is state the
model **already carries**; it is not new state.

**SFTR** (RTS 2019/356) Table 2 collateral: SECU/CASH type, ISIN/CFI, quantity, market value,
haircut/margin, **availability for reuse**, collateral-basket id. Table 4 reuse/reinvestment
(below). All Table 2 figures project from `coll_recv`/`coll_post` × price + declared terms
(haircut, reuse-permission clause).

**EBA asset encumbrance** (ITS on supervisory reporting, Annexes; FINREP **F32–F36**):
- F32.01 encumbered vs unencumbered **own** assets (carrying + fair value) = `encumb =
  onloan + coll_post`, valued — a projection.
- F32.02 **collateral received**, split encumbered (re-used) vs available = **`coll_rehyp`**
  vs `coll_recv − coll_rehyp` — this is *exactly* the rehyp coordinate, projected.
- F34 **sources of encumbrance**: match each encumbered asset to the liability/transaction
  that encumbers it — a projection over (`coll_post` move, its agreement-unit attribution).

**Verdict: every required figure is a projection of the coordinate vector plus the
collateral-agreement unit's declared terms — provided each posting/receipt move is attributed to
its agreement unit** (which §6 faithful representation already compels). No regime demands a
figure the universal model cannot carry, with the single exception in (iii).

### (ii) Cash vs securities — does regulation force a distinction that bears on Q1?

Yes, regulation distinguishes them: SFTR **field "type of collateral component" = SECU vs CASH**
is mandatory; EMIR margin currency fields presume cash VM. **But this is a distinction of
*unit type*, not of *coordinate geometry*.** Cash and securities can sit on the *same*
coordinate (`coll_recv`); the SECU/CASH flag is a projection of the unit's asset class, which the
unit already carries. Nothing in the reporting distinction argues *against* Q1. The reinvestment
requirement in (iii) argues *for* it.

### (iii) Rehypothecation / reuse as coordinate reclassification

**Securities reuse works, and beats the regulation.** SFTR Art. 15 reuse value with per-ISIN
`coll_rehyp` = Σ `coll_rehyp` × price — an **actual** figure. ESMA's proportional-estimate
formula (reuse value = received value × reused/eligible) exists *only* because firms lack
per-line attribution; a coordinate that tracks reuse per unit **over-delivers** on the required
field. F32.02's re-used-collateral line falls out of the same coordinate. Confirmed.

**Cash reinvestment is where the model can break — and it names the field.** SFTR Table 4 —
**reinvested cash amount, reinvestment rate, reinvested cash currency, reinvested cash type
(fields 4.4–4.7)** — requires the firm to project *how much of the cash it reinvested was
collateral-received cash*. If cash collateral received is booked on **`own`** (as prior v13.1/
v14 did) and commingled with proprietary cash, that distinction is **erased at the coordinate
level**: reinvested-collateral-cash is indistinguishable from spent proprietary cash. **Those
Table 4 fields become unobtainable.** Book cash collateral on **`coll_recv`** as a cash unit
(with the return obligation as its own unit per §8), and reinvestment is a tagged move
`coll_recv` ↓ → bought asset `own` ↑; amount and rate project cleanly. **This is a decisive
argument for Q1, and specifically against "cash collateral writes `own`."**

## (2) Constraint the ruling must respect

**Repo / SBL accounting (IFRS 9 secured-borrowing; EBA encumbrance definition).** An asset
posted under a *financing* pledge — repo, SBL, title-transfer VM CSA that returns equivalent —
**stays on the poster's balance sheet and is reported as *encumbered*, not derecognised.** F32
requires it to remain the poster's owned-economic asset. Therefore `coll_post` of a financing
pledge is **owned mass on an encumbered coordinate**, and the ruling's reading of "only owned
drives PnL" (§4) must admit `own + coll_post` for such pledges — vindicating v13.1's
security-interest valuation V = Σ(own + coll_post)·P. Only an outright **sale** re-books
ownership. Encumbrance reporting is the binding authority here, not accounting taste.

## (3) Risk in answering Q1 / Q2 "yes"

- **Q1 risk is the *opposite* of what one might fear:** the danger is *not* answering it yes.
  Cash-on-`own` (commingled) forfeits SFTR Table 4 reinvestment attribution. Cash-on-coordinates
  is what the reporting needs. Residual care: the return-obligation unit (§8) must exist so the
  title-transfer liability is faithful; the coordinate is *possession*, not *ownership*.
- **Q2 risk:** putting options/structured notes on collateral coordinates is reporting-safe
  **only if the move-to-agreement-unit attribution is mandatory and total** — IM/VM split,
  collateralisation category, and F34 sources-of-encumbrance are *unobtainable without it*. If
  attribution is optional or lossy, three regime figures across two regimes silently fail. The
  architecture must make agreement-unit attribution a construction invariant, not a convention.

## (4) Recommendation

Answer **Q1 yes**, and book cash collateral received on `coll_recv` (a cash unit) with the return
obligation as a separate unit — this is the only representation from which SFTR Table 4
reinvestment fields project; `own`-commingling makes them unobtainable. Answer **Q2 yes** subject
to one non-negotiable: **every collateral move must carry attribution to its collateral-agreement
unit**, because IM-vs-VM, the EMIR collateralisation category, and FINREP F34 are projections over
(coordinate, agreement-unit), not over the coordinate alone. Treat `coll_rehyp` as a first-class
coordinate for both securities and reinvested cash — it delivers SFTR Art. 15 reuse and FINREP
F32.02 as actuals, exceeding the regulatory estimate. Finally, record that encumbrance rules
require pledged financing collateral to remain the poster's owned-economic asset; the ruling must
not let title transfer erase `coll_post` value for repo/SBL.

*(~890 words)*
