# Phase 1 Bench Consultation — ISDA Board Advisor (on Q2)

**Summoned by:** MINSKY
**Question:** Does ISDA's direction of travel support or contradict Q2 "yes" — one universal
position representation where any unit may sit on the collateral coordinates and
eligibility/haircuts are purely declared data of the collateral-agreement unit?

**Verdict: ISDA's direction of travel supports Q2 "yes" — with one correction the ruling
must adopt: value the lines, not the package.**

---

## 1. Answer

**(i) CSA schedules are line-level, not portfolio-level. A floored package is not expressible
in any standard agreement today.** ISDA CSA **Paragraph 13** ("Eligible Collateral" and
"Valuation Percentage") enumerates collateral as *asset categories* — cash in named
currencies, government/agency bonds by issuer, rating and residual-maturity band — each
carrying a Valuation Percentage (1 − haircut). Value is computed line by line:
`Value = Σ (per-asset market value × Valuation Percentage)`, adjusted for FX haircut and
tested against per-category concentration limits. There is **no clause construct** in the CSA,
GMSLA (Schedule / Para 5–6) or GMRA that recognises "stock + protective put" as a single
floored eligible unit. The put is almost never Eligible Collateral; the stock, under a
post-UMR bilateral VM CSA (typically cash-only), is usually ineligible outright. The
economic claim in the brief — a floored portfolio is *better* collateral than the naked shares
— is **true economics but not contractual reality**. Portfolio-level risk *does* appear, but
only in the **margin requirement** (CCP SPAN/VaR IM, triparty RQV), never in the **eligibility
of what is posted**, which stays line-level everywhere.

Therefore **v15 must value the pledged lines, not the package.** §6 (faithful representation)
binds the ledger to what Paragraph 13 actually does. The put and the stock are two units,
each on `coll_post`, each valued through the pricing layer at the agreement's declared
Valuation Percentage. A portfolio floor, if summed, is a **projection** — never a stored
package valuation, and never a haircut the agreement does not grant. This is fully consistent
with Q2: eligibility and haircut remain declared data applied *per unit*.

**(ii) CDM already models eligibility as declared criteria on the agreement — the universal
coordinate removes gaps, it does not create them.** CDM represents an agreement's terms via
`EligibleCollateralSpecification` / `EligibleCollateralCriteria`, where each criterion is an
*asset criterion* (asset type, issuer, maturity, rating) bearing a `treatment`
(valuationPercentage, concentration limit). Posted collateral is a `CollateralPosition` /
`AssetPool` of lots. This is **criteria-based and line-level by construction** — eligibility is
a property of the *agreement*, not of unit types. Q2's "eligibility is economics, not
architecture, and economics is declared data" **is CDM's collateral model restated.** The one
gap the ruling could open: CDM keys collateral off **transfer method** (title transfer vs
security interest / pledge) and carries specific event types (substitution, valuation,
disputes). If v15 collapses everything to a coordinate vector and drops the legal-regime
discriminator, it diverges. v13.1 already carries `legal_regime` — keep it, and CDM alignment
holds.

**(iii) Tokenisation argues *directly* for eligibility-as-declared-data.** ISDA's 2023
**tokenised-collateral model provisions for 2016 CSAs** add tokenised assets to the Eligible
Collateral schedule as *declared data* — you extend the schedule, you do not re-architect the
agreement. The GDF tokenised-MMF workstream, the DTCC Great Collateral Experiment (Apr 2025),
and ISDA/Ant Project Guardian (Jul 2025) all rest on the same premise: any tokenised unit —
MMF units, tokenised bonds, tokenised bank liabilities — is mobilised on the same rails, its
eligibility and haircut being *parameters* of a CDM-based smart-contract collateral term. A
representation where **any unit-type may sit on the collateral coordinate and the agreement's
declared terms decide acceptance and value** is precisely the substrate tokenised collateral
requires. Q2 is the enabling architecture, not a departure.

## 2. Constraints the ruling must respect (named)

- **CSA Paragraph 13 (Eligible Collateral / Valuation Percentage):** valuation is per-line.
  The ledger may not synthesise a package floor the agreement does not recognise.
- **Manufactured-payment / distribution rule (CSA distributions; GMSLA Para 6):** a coupon on
  a pledged bond, or the payout when a posted one-touch **knocks while pledged** (trap case c),
  follows the **owned** coordinate, not possession. The barrier fires on the owned unit, the
  pricing layer re-values, and the CSA smart contract observes the collapsed Value and issues
  the Paragraph 3 margin call — **no special case**. This is the correct behaviour and confirms
  Q2.
- **CDM transfer-method discriminator:** retain pledge vs title transfer as the field that
  decides ownership location.

## 3. Risk in answering yes

- **Package-valuation overreach.** If the ruling says "value the pledged package," it
  misrepresents every bilateral CSA and asserts a haircut no agreement grants. Value lines;
  floors are projections.
- **Title-transfer PnL tension with §4.** `coll_post` of a *pledge* is **owned-mass parked on
  a coordinate** — the poster retains title, so it must still drive poster PnL (v13.1's
  `V = Σ(own+coll_post)·P` is correct *for a pledge only*). Under **title transfer**, ownership
  genuinely moves: it must re-book to the taker's `own` and create a return-**obligation** unit
  (§8 unwind test — collateral held in custody against an equal obligation). If the coordinate
  vector blurs these, §4's "only owned drives PnL" breaks.

## 4. Recommendation

Answer **Q2 yes.** It is CDM's collateral model restated and the exact substrate ISDA's
tokenised-collateral programme requires; eligibility-as-declared-data of the
collateral-agreement unit is the direction of travel, not a deviation. But rule explicitly
that the ledger **values collateral line-by-line** at each agreement's declared Valuation
Percentages, with portfolio floors as projections and never a stored package valuation —
because §6 binds to Paragraph 13 and no CSA/GMSLA/GMRA expresses a floored package. Preserve
**legal regime (pledge vs title transfer)** as the discriminator that decides whether
`coll_post` is owned-mass (pledge — still drives poster PnL) or re-booked ownership plus an
obligation unit (title transfer). Do that, and the universal coordinate is CDM-native,
tokenisation-ready, and handles the trap case with no special case.
