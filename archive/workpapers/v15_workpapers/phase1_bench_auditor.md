# Phase 1 — Support Bench Consultation: BANKING-AUDITOR

**To:** MINSKY, drafting the Collateral Ruling (v15)
**Re:** Balance-sheet treatment of collateral received/posted; §8 conflict; repo-coupon micro-case
**Framework:** IFRS (IFRS 9 / IAS 32 / IFRS 7 primary); US GAAP divergence flagged where relevant.

---

## (1) Answer to the question asked

### (i) When does received collateral go ON the receiver's balance sheet?

The discriminating variable is **legal regime**, not asset type. Three cases:

| Case | Receiver recognises the asset? | Governing test |
|---|---|---|
| **Cash collateral received** (always title transfer in practice) | **Yes** — Dr cash (`own`), Cr return-payable | IFRS 9 §3.1.1; the receiver controls fungible cash and owes an equal debt |
| **Non-cash under pledge / security interest** (no right of use, or right unexercised) | **No** — off-balance-sheet, disclose only | Poster retains risks/rewards → poster keeps it (IFRS 9 §3.2.6(b)); receiver holds security, not asset |
| **Non-cash under title transfer with right to rehypothecate** | **No** while merely held; **Yes a *liability*** only if actually on-sold (recognise proceeds + return obligation as a short, at FV) | IFRS 9 §3.2.6/§3.2.15; IFRS 7 §15 |

The asymmetry is a matter of law, not accounting taste. **Cash carries no *nemo dat*** — title to money passes to whoever holds it ("money had and received"), so received cash is *owned* and matched by a debt. A pledged security remains the pledgor's identifiable property (*nemo dat quod non habet*). A title-transferred security passes legal title but, in a financing (repo/reverse repo, title-transfer CSA), **fails derecognition on the poster's side** because the poster retains substantially all risks and rewards (IFRS 9 §3.2.6(a)); the receiver therefore books a *receivable* (collateralised loan), never the security itself.

**Does the coordinate design reproduce each case?** For non-cash — **yes, cleanly and without a special case.** `coll_recv` is a *held-not-owned* coordinate that does not drive PnL or the balance sheet; that is exactly cases 2 and 3 (the security is never the receiver's asset; a rehyp on-sale is a *separate* short-position unit). **For cash — no.** Cash received under title transfer **is** the receiver's owned asset. Booking it on `coll_recv` understates gross assets, hides the return liability, and denies the receiver the reinvestment return it genuinely earns and bears. Cash received must write **`own`**, with the return obligation as its own liability unit — precisely what prior v13.1 §16 and v14.0 did ("cash collateral writes `own`, not the collateral coordinates"). Those specs were right; the constitution's §8 parenthetical is wrong.

**Does any case force ownership re-booking?** Yes — and the ruling must forbid it. A **repo/title-transfer** of a *security* must **not** move the security onto the receiver's `own`. Derecognition turns on risks-and-rewards (IFRS 9 §3.2.6), not legal title. If title transfer re-booked `own` to the receiver, it would derecognise the bond from the poster — a misstatement. **`own` must track economic ownership; legal title is a declared agreement term, not a driver of `own`.**

### (ii) Does §8 conflict with the accounting fact? — Yes, and it is internally inconsistent with §4.

§8 (manifesto l.541–549) sorts every inflow into: (a) exchange with equal outflow; (b) financing against an equal obligation created in the same transaction; (c) **value held in custody without being owned** — and files "cash received as collateral" under (c). That is the miscategorisation. Title-transfer cash collateral is **not** custody: the receiver owns it, may reinvest it, bears the reinvestment result, and owes a return debt (usually with interest at the CSA rate, e.g. €STR/OIS). That is **§8's own limb (b) — financing** — economically a collateralised borrowing (ASC 860-30 concurs under US GAAP). §8 also contradicts §4: "only the *owned* coordinate carries economic value." Cash the receiver *owns* must sit on `own`. **§4 is right; the §8 parenthetical is wrong.** Limb (c) is correct only for the narrow case of **cash held under a security interest with no right of use** (segregated / trust / CASS client money) — genuinely off-balance-sheet.

**Representation that lets a balance-sheet projection recover the treatment from coordinates + agreement terms alone** — three elements, all already available:
1. **Coordinate:** cash received under title transfer writes **`own`**; non-cash writes `coll_recv`.
2. **The return obligation is its own unit** (§6 faithful representation — the obligation *is* a unit), issued receiver −1 / poster +1, so the liability exists in the log, not by inference.
3. **`legal_regime` as a declared term** of the collateral-agreement unit (title transfer vs security interest + right-of-use flag).

The projection then reads: gross assets = Σ `own`·P (cash included); gross liabilities = the return-obligation unit; IAS 32 §42 offset is a **separate, gated** projection (enforceable set-off **and** intent to settle net/simultaneously) — never a booking default. With these three, all three cases and the offset question resolve deterministically.

### (iii) Micro-case (b): bond coupon while pledged in repo — the auditor's seat

Poster A sells a bond to B under repo (GMRA, title transfer); a coupon pays during the term.

- **Whose asset:** **A's.** Repo fails derecognition (IFRS 9 §3.2.6(a)); A keeps the bond at fair value and recognises a financing liability for cash received (IFRS 9 §3.2.15). B recognises a **receivable** (reverse repo = loan), **not** the bond. Ledger: bond stays on A's `own`; B holds it on `coll_recv` (drives no PnL for B). US GAAP identical (ASC 860 — repos are secured borrowings; frameworks converge).
- **Whose income:** **A's.** A recognises coupon income on its still-recognised bond (IFRS 9 §3.2.16). Under GMRA para 5, B (legal holder) receives the coupon but owes A an equal **manufactured payment**; B's net P&L on the coupon = nil. Ledger: the coupon lifecycle event fires on the *unit*; entitlement follows the **`own`** coordinate → A. The manufactured payment is a separate obligation unit (B −1 / A +1) routing the issuer's cash to A. This is brief consequence #4 (entitlements follow `own`, not possession) — handled **without a special case.**
- **Disclosures:** A — IFRS 7 §42D (transferred assets not derecognised: carrying amount, associated liability, relationship); §14 (assets pledged as collateral / encumbered); §13A–13F offsetting for the GMRA. B — IFRS 7 §15 (collateral held it may sell/repledge: FV held, FV sold/repledged, terms). Interest **grossed up** on both sides (no netting of coupon income vs repo interest expense; IAS 1 §32). **Materiality:** repo books are typically highly material to a bank; encumbrance stays in A's leverage-ratio exposure and feeds Pillar 3 / EBA asset-encumbrance projections — flag downstream.

## (2) Constraint my domain imposes on the ruling

**Derecognition is decided by risks-and-rewards, not legal title (IFRS 9 §3.2.6).** Therefore `own` must carry **economic** ownership, and `legal_regime` (title transfer vs security interest, right-of-use flag) must be a **declared term** — load-bearing for recognition, disclosure and the rehyp seam, but never a driver of which entity's `own` holds the asset. Named anchors: IFRS 9 §3.2.6/§3.2.15/§3.2.16; IAS 32 §42; IFRS 7 §§14, 15, 42D, 13A–13F; GMRA para 5 / GMSLA manufactured-payment clauses; ASC 860 (US GAAP convergence on repo, cash collateral).

## (3) Risk in answering Q1/Q2 "yes"

Answering **Q1 yes** (cash follows the generalised coordinates *exactly* as securities) **reproduces the §8 error** and mis-states the balance sheet: it hides received-cash assets and their return liabilities on a non-owned coordinate, and would (if `own` followed possession) wrongly derecognise repo'd bonds. **Cash may join the coordinate *vocabulary*, but received title-transfer cash must resolve to `own` + an explicit return-obligation unit — not to `coll_recv`.** **Q2 yes** (universal coordinate representation) is sound *provided* the ruling fixes two invariants: (a) `own` tracks economic ownership so title transfer never re-books it; (b) portfolio-level collateral valuation must not leak into the *poster's* PnL beyond what `own` carries — a pledged option that knocks (case c) must fire on the unit and pay the *owner*, with collateral value a projection, not stored. Both are satisfiable; neither is automatic.

## (4) Recommendation

Adopt Q2 (universal coordinates) and adopt Q1 **only in the qualified form**: cash *shares the coordinate vocabulary* but **received cash under title transfer books `own` plus an explicit return-obligation unit**, never `coll_recv`. **Amend §8**: strike, or narrow, the parenthetical to read *"cash received as collateral **under a security interest with no right of use**"*; title-transfer cash collateral is §8 limb (b) — financing against an equal obligation. Make **`own` = economic ownership** (risks/rewards, IFRS 9 §3.2.6) and **`legal_regime` a declared agreement term**, so a balance-sheet projection recovers on-BS cash + return liability, off-BS pledged securities, and repo derecognition-failure from coordinates + terms alone — resolving the v13.1 title-transfer tension in favour of *no ownership re-booking.*
