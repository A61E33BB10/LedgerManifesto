# Phase 1 — Bench Conflict Matrix (for MINSKY / FORMALIS)

Six consultations complete: `phase1_bench_sbl.md`, `phase1_bench_isda.md`,
`phase1_bench_finops.md`, `phase1_bench_auditor.md`, `phase1_bench_correctness.md`,
`phase1_bench_testcommittee.md`, `phase1_bench_regreporter.md` (seven files; the
correctness/testcommittee pair were summoned as one question in two seats).

## Consensus (all benches)

- **Q2 yes**: one universal coordinate representation; any unit may sit on the
  collateral coordinates; eligibility and haircuts are declared data of the
  collateral-agreement unit, checked at the single door (never typed).
- Entitlements follow `owned`; the knock-while-pledged trap case resolves with no
  special case in every bench's worked treatment.
- Collateral sufficiency is an **obligation** (deadline, discharge predicate,
  compensation = close-out), never an invariant — lawfully false intraday.
- Every non-owned/collateral move carries a **mandatory reference to its
  collateral-agreement unit** (construction invariant; needed for IM/VM split, EMIR
  collateralisation category, FINREP F34).
- The return/repurchase/manufactured-payment obligation is always its **own unit** (§6).
- `coll_rehyp` (re-used pledged collateral) must exist as a coordinate (SFTR Art. 15,
  FINREP F32.02 as actuals).
- The **legal regime (title transfer vs security interest)** is declared once on the
  collateral-agreement unit; it must not be erased.
- Lifecycle events extinguish **value, never mass**; unit retirement requires the zero
  vector (correctness).
- Conservation stated **per (unit, coordinate)**; single-coordinate paired-leg moves the
  sole mutator (correctness, testcommittee).

## Disputes to arbitrate

### D1 — Received TITLE-TRANSFER cash: which coordinate?
- `own` + explicit return-obligation unit: **finops** (STM VM is settlement, not
  collateral — no return leg at all; nostro reconciliation breaks under coll_recv(cash)
  because cash is fungible), **auditor** (IFRS 9: receiver recognises cash + liability;
  §8 parenthetical is wrong, should be narrowed to security-interest/no-right-of-use),
  **sbl** (title transfer = §8 category 2 financing; GMSLA/GMRA/English-law CSA are the
  dominant regime).
- `coll_recv`: **regulatory-reporter** (SFTR Table 4 reinvestment fields 4.4–4.7
  unobtainable if commingled on `own`), **correctness** (uniformity; §8 as written),
  and the **constitution §8 parenthetical as written**.
- Note: reg-reporter's requirement may be dischargeable under own+obligation-unit if
  reinvestment attribution projects from the obligation unit + agreement attribution —
  MINSKY must resolve explicitly.

### D2 — TITLE-TRANSFER securities: does `own` re-book to the taker?
- Yes, with poster's claim-for-equivalent unit priced through the ordinary pricing
  layer (poster stays economically long via the claim): **sbl**, **correctness**,
  **isda**, **testcommittee**. Under this, title-transfer collateral uses NO collateral
  coordinate at all; coll_post/coll_recv are pledge-only.
- No — poster keeps `own` (IFRS 9 risks-and-rewards derecognition; re-booking would
  misstate; taker books a custody marker): **auditor**; **reg-reporter** (encumbrance
  reporting: financing-pledged assets stay the poster's owned/encumbered).
- Possible synthesis MINSKY must evaluate: re-book `own` + claim unit, with the
  balance-sheet/encumbrance presentation recovered as a projection (claim-for-equivalent
  valued identically to the asset; presentation rule maps claim → non-derecognised
  asset). Does the projection satisfy IFRS 7 §42D and FINREP F32 without a second store?

### D3 — Under PLEDGE, does posting decrement `own`?
- v13.1 mechanics: mass moves own→coll_post; PnL then must read own+coll_post
  (**reg-reporter**, v13.1 archaeology, **sbl**: "coll_post ⊂ owned", encumbered-owned).
- Marker mechanics: `own` stays; coll_post/coll_recv are a separate zero-sum plane
  (posted at poster, received at taker as contra); PnL = own·P literally
  (**correctness**: signed basis (owned, lent, posted); borrowed/received as negative
  rays). "Only owned drives PnL" holds with no formula change.
- MINSKY must pick one mechanics and show micro-cases (a)(b)(c) under it.

### D4 — Package vs line valuation of pledged collateral
- Lines only; floors are projections; no CSA/GMSLA expresses a floored package
  (**isda** — CSA Paragraph 13 binds §6 faithfulness).
- The package must be priceable or the floor is invisible; agreement references a set
  of units with joint payoff (**testcommittee**, **sbl**).
- Likely synthesis: default line-level per declared valuation percentages; the
  architecture PERMITS an agreement whose declared terms define package-level
  valuation (declared data, ordinary pricing layer); portfolio floor never a stored
  valuation. MINSKY to confirm and state which the v15 text mandates.

### D5 — Scope of §8 amendment
- Auditor: narrow parenthetical to "cash received as collateral under a security
  interest with no right of use".
- Sbl: regime-conditional statement (title transfer = category 2; pledge = category 3).
- Finops adds: settled-to-market VM is category 1 (exchange/settlement) — no return
  leg exists; the memo's micro-case (a) must state this three-way split.
- The exact amendment text is a deliverable of the memo (constitution changes only by
  explicit amendment, ratified by the owner).
