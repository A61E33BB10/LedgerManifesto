# THORP — Phase 1 Problem Memo
## Corporate-Action Consistency of Consumed Data ("state-tagged data")
### Independent review — problem statement only; no solutions proposed

---

## 1. The defect restated in corporate-action terms

Every corporate action partitions time, per unit, into **basis regimes**. A 2-for-1 split with effective date `E` defines two regimes for every datum referencing that unit: quantities observed before `E` are in shares-old, after `E` in shares-new; prices before `E` are per-share-old, after in per-share-new. The market publishes an explicit conversion at every such boundary — the split factor, the ex-dividend drop, the spin-off allocation ratio, the merger exchange ratio, the recomputed index divisor. These factors exist for exactly one reason: **a number quoted in one regime is not a number in the other regime.** A price is not a scalar; it is a scalar *in a basis*.

The Ledger gets the position side of this exactly right: the split is a lifecycle event, it emits conserving moves, replay reconstructs either regime. It gets the data side exactly wrong: a spot, a dividend estimate, a composition, a divisor is consumed as a bare `Quote`/`Price`/`Qty` scalar (Ledger.hs:175–176, 292) whose regime is nowhere recorded. Valuation (`value :: PriceVec -> [WalletId] -> Ledger -> Cash`, sec05.tex:44) multiplies a position folded to the **current** CA regime by a price observed in **whatever regime prevailed at snap time**, and the type system — which elsewhere makes a one-legged move unrepresentable — happily accepts it. The conservation law protects quantities; nothing protects the quantity×price seam. The defect is a **missing validity coordinate on every observation**, equivalently a missing edge between the CA-event fold (which the log already contains) and the data the pricing function consumes.

Consequence for the abstract's central claim: path-independent PnL (sec05.tex:74–91) presumes each `V_t` is well-defined. With mixed-basis inputs at any endpoint or attribution cut, `V_t` is not a valuation of anything; the telescoping still cancels arithmetically, which makes the corruption *silent* — the worst kind on a desk, because the total may even come out right while the attribution is garbage (see §2a′).

---

## 2. Failure modes reproduced — arithmetic only

### (a) Stock split — phantom PnL of the full position value fraction

Wallet holds 1,000 shares. Spot snapped at `t_snap`: €100.00. Marked value: 1,000 × 100 = **€100,000**.

2-for-1 split effective in `(t_snap, t_price]`. The lifecycle correctly emits +1,000 shares (position → 2,000). Split factor for price-like data: ×½.

| Repricing at `t_price` | Arithmetic | Value |
|---|---|---|
| Correct (basis-adjusted spot €50) | 2,000 × 50 | €100,000 |
| **As specified (stale spot €100)** | 2,000 × 100 | **€200,000** |

Phantom PnL: **+€100,000 (+100%) from an economically neutral event.** Sign flips for a reverse split: 1-for-10 on the same book (position → 100 shares, true price €1,000) marked at the stale €100 gives 100 × 100 = €10,000, a phantom **−€90,000**. Magnitude is `(1/f − 1)` of position value for split factor `f` applied to quantity — unbounded in either direction. Every split-sensitive datum fails identically: a per-share dividend forecast of €2.00 is €1.00 post-split; a stored `usLastSettle` (Ledger.hs:292) crosses the boundary un-adjusted; a strike or barrier *reference* held as data rather than terms halves.

### (a′) Split with a correctly adjusted endpoint still corrupts attribution

Suppose the `t_price` spot IS correctly sourced post-split at €55 (spot up 10% like-for-like). Apply the sec05.tex:107–109 decomposition with `w_{t0}` = 1,000, `P_{t0}` = 100, `w_{t1}` = 2,000, `P_{t1}` = 55:

- PnL_price = 1,000 × (55 − 100) = **−45,000**
- PnL_flow = Δw × P_{t1} = +1,000 × 55 = **+45,000** (+ true price PnL in the total)
- Total = V_{t1} − V_{t0} = 110,000 − 100,000 = **+10,000** ✓

The total closes; the attribution reports a €45,000 price loss and a €45,000 "flow" on an event that moved no value and involved no flow. Economic truth: price PnL +10,000, flow 0. The P10 oracle (appB.tex:37, appB.tex:173–174) checks only that the decomposition sums — it passes on this garbage. A risk desk consuming this explain chases a €45k phantom loss; a fee calculation keying off flow PnL charges on €45k of non-flow. **The defect survives even correct prices, because the attribution formula compares prices across a basis boundary.**

### (b) Dividend — double count of exactly the dividend

1,000 shares, cum spot snapped €102.00, dividend €2.00/share, ex-date in `(t_snap, t_price]`. Lifecycle correctly books the cash move: +€2,000 to the wallet.

| Repricing at `t_price` | Equity mark | Cash | Total |
|---|---|---|---|
| Correct (dividend-adjusted spot €100) | 100,000 | 2,000 | €102,000 |
| **Stale cum spot €102** | 102,000 | 2,000 | **€104,000** |

Overstatement: **+€2,000 — the dividend counted once as cash and once embedded in the stale mark.** appD handles precisely this one case (`priceOf u (Ex d) (Market q False)`, appD.tex:56) — and *only* this case: the adjustment is hard-coded additive, the state slice is the two-point sum `Cum | Ex Cash` (appD.tex:44), and the `mQuoteEx :: Bool` flag (appD.tex:48) is asserted by the caller, not derived from any recorded basis — the missing edge, restated as an honest-input assumption.

### (b′) Split + dividend in one interval — composition is order-sensitive

Same stock, cum spot snapped €102; dividend €2/share (declared pre-split) goes ex, then the 2-for-1 split becomes effective, both in `(t_snap, t_price]`. Position → 2,000 shares.

- Correct (event order): (102 − 2) / 2 = **€50.00** → 2,000 × 50 = €100,000
- Wrong order: 102/2 − 2 = **€49.00** → 2,000 × 49 = €98,000 — a **€2,000** error from ordering alone.

Adjustment operators do not commute (an additive and a multiplicative map never do). Any fix that "applies the adjustments" without a composition law ordered by effective-date sequence reproduces this error. appD's single additive branch cannot express the composite at all.

### (c) Index composition — divisor and membership staleness

Price-weighted index, three constituents, divisor `D = 3`:

| | A | B | C | Sum | Level = Sum/D |
|---|---|---|---|---|---|
| At `t_snap` | 100 | 50 | 30 | 180 | 180/3 = **60.00** |

B splits 2-for-1 (B → 25). The index authority recomputes the divisor so the level is continuous: `D′ = (100 + 25 + 30)/60 = 155/60 ≈ 2.5833`. Repricing the index against post-split constituent quotes with the **snapped divisor** `D = 3`:

- (100 + 25 + 30)/3 = **51.67** — a phantom **−13.9%** index move; nothing traded, nothing changed economically.

A replicating basket sized off snapped weights fails the same way: pre-split replication of a 60-level unit needs (1, 1, 1)/3 shares of (A, B, C); post-split the correct holding is (1, **2**, 1)/3 — the stale composition under-holds B by half, and "tracking error" appears that is pure data-basis error, indistinguishable in the PnL from real slippage. For a merger/replacement the stale composition is worse than wrong: it prices a **dead identifier** — the datum for the removed constituent either vanishes (no quote) or freezes (last stale quote), and the QIS state carrying "current weights" (sec04.tex:62–64, sec07.tex:196) silently diverges from the externally authored composition it claims to mirror.

---

## 3. Audit — every implicit state-free-data assumption in the current text

**sec04 — three-home model**
- `sec04.tex:62-64` — the 2×2 places "last settlement price, current weights, benchmark level" in Status as bare ledger-authored scalars; no cell of the 2×2 carries a validity coordinate, and no edge exists from CA lifecycle events to the validity of any Status field. The classification axis is *who authors* the record, never *in which basis* it is stated.
- `sec04.tex:153-155` — "Externally sourced inputs --- a settlement price, the current benchmark level --- enter only as a logged observation event." The observation is timestamped but basis-free: replay reproduces the raw number in whatever regime it was observed, which is exactly what makes the time-travel guarantee vacuous for data (see sec07 below).
- `sec04.tex:244` / `Ledger.hs:292` — `usLastSettle :: Maybe Qty`: a stored scalar with no basis; read across a split boundary it is wrong by the split factor. (Also dimensionally a `Qty`, not a `Price` — the one type discipline the spec is proudest of, lapsed at the one field that stores a price.)
- `sec04.tex:253` / `Ledger.hs:304` — `SetLastSettle Qty`: the write path is equally basis-free.

**sec05 — valuation and PnL**
- `sec05.tex:14-18` — `P_t : U → ℝ` "an external input, not computed by the framework": the price function is keyed by unit and time only; no coherence requirement between the basis of `P_t` and the basis of `w_t`.
- `sec05.tex:38` / `Ledger.hs:683` — `PriceVec { priceOf :: UnitId -> Price }`: totality is enforced ("a held unit with no price is unrepresentable") but validity is not — any `Price` in any basis prices any epoch of the position. The type that makes one illegal state unrepresentable makes the CA-mismatch state *invisible*.
- `sec05.tex:42-44, 57` — "value depends ONLY on current balances in scope and prices. State-sufficiency is the signature, not a claim." The signature admits mixed-basis inputs; state-sufficiency as typed is *under*-stated: value depends on balances, prices, **and their agreement on basis**, and the third dependency has no representation.
- `sec05.tex:63-66` — Principle (State-sufficiency): "current wallet balances, current unit state, and current prices." Three uses of "current" with no shared definition; the defect lives in the gap between them.
- `sec05.tex:74-91` — Theorem P10 and proof: each interior `V_s` is assumed well-defined; a CA between `s_k` and `s_{k+1}` with un-adjusted data breaks the premise, not the algebra — the failure is silent (§2a′).
- `sec05.tex:101-110` — PnL attribution compares `P_{t1}(i) − P_{t0}(i)` across the interval and prices `Δw` at `P_{t1}`: both operations are basis-naive; reproduced numerically in §2a′.

**appD — the market-data appendix (the seam itself)**
- `appD.tex:4, 82` — scope confined to coupons/dividends; "The distinction between 'primary' and 'derived' market data carries no content here" — compositionality explicitly waved off, which is precisely where the generic defect hides.
- `appD.tex:44` / `Ledger.hs:713` — `data Distribution = Cum | Ex Cash`: the "pricing-relevant slice of lifecycle state" is a two-point sum. No split factor, no succession, no composition, no multiplicative operator is expressible. The type closes the world at one CA class.
- `appD.tex:48` / `Ledger.hs:715` — `Market { mQuote :: Quote, mQuoteEx :: Bool }`: the entire validity coordinate compressed to one caller-asserted Boolean, defined only for the dividend case, per quote not per basis, with no specification of who sets it or against what recorded state.
- `appD.tex:56` / `Ledger.hs:720` — `Price (q - d)`: adjustment hard-coded additive; splits are multiplicative; composites are order-sensitive (§2b′).
- `appD.tex:84` — sourcing and snapshotting delegated to the market-data satellite: the validity coordinate falls into the gap between two documents, owned by neither.

**sec06/sec07 — contracts, lifecycle, time travel**
- `sec06.tex:53` — `type Contract i s c = (i, s, c) -> [Move]`: observed conditions enter as an unconstrained type parameter; no basis discipline can attach.
- `sec06.tex:99` — "a 2-for-1 split doubles each entitled holding **while the price reference halves**": the halving is narrated in prose; it has no writer, no home in the three maps, and no mechanism anywhere in the spec. This line is the defect stated by the spec itself without noticing.
- `sec06.tex:116-141` — put settlement consumes `S_T` as a bare scalar; strike `K` sits in immutable terms. A split between inception and expiry requires the coordinated contract adjustment (K → K/2, N → 2N, or a non-standard deliverable); no path exists from a CA on the underlying unit to the terms basis of the derivative unit.
- `sec07.tex:23, 46-48` — `f : (unit, state_t(u), market_data) → (moves, state′)`; "market data enters only inside the Event, as a logged observation" — basis-free at the lifecycle interface, same as sec04:153.
- `sec07.tex:120` — "market data … stored at execution time as a versioned snapshot. Replays read the stored snapshot." Versioning axis = vendor correction only. A stored snapshot is frozen in its *observation* basis; nothing states that a consumer at a later `t` must receive it in the basis prevailing at `t`. This is failure mode (a) institutionalised as the replay discipline.
- `sec07.tex:128-135` — time-travel items 2 and 4 acknowledge splits and basket redefinition and claim reconstruction "via unit state" — for **positions**. The data side of the reconstruction (what basis the snapped spot/composition is in at the replay target) is unclaimed and unimplementable with basis-free snapshots.
- `sec07.tex:196-200` — QIS state carries "current weights or holdings" as ledger-authored Status while the true composition is externally authored reference data; the divergence mechanism of §2c.

**sec01/sec19 — claims and open problems**
- `sec01.tex:22` — Property 4 (State-Sufficiency): "the current price vector" — same undefined "current".
- `sec01.tex:24` — Property 5 (Lifecycle Value Invariance): "the jump in the instrument's price is exactly offset by the explicit cash move" — **presumes the price vector jumps**, i.e. is basis-consistent at the event. With a stale vector the invariance fails by exactly the amounts in §2a/§2b; the property as stated is conditional on the un-stated data discipline.
- `sec01.tex:28` — time travel distinguishes "as known at t" vs "restated" (bitemporal axis) but not observation basis vs prevailing basis (the CA axis). Two axes, one named.
- `sec01.tex:80` — corporate-action terms are consumed from external reference-data authorities with no boundary discipline on validity.
- `sec19.tex:18` — "Reproducibility requires version-pinning of these external dependencies." Pinning is not basis: a pinned snapshot in the wrong basis reproduces the wrong number, deterministically.
- `sec19.tex:43-58` — the open-problems register lists bitemporal semantics (line 48) but **the CA-consistency defect is absent from the register entirely**: the spec does not know it has this problem.

**appB/appF — tests and CDM**
- `appB.tex:33, 37, 147-148, 173-174` — the P8 oracle compares balances and unit state only; the P10 oracle takes `pnlPrice`/`pnlFlow` as given `Cash`. **No oracle in the catalogue constrains the basis of a generated `PriceVec`; failure modes (a)–(c) are unfalsifiable by the entire property suite as written.** The test catalogue inherits the category error.
- `appF.tex:15` — CDM Layer 1 (Observable): "a market-data input to pricing and lifecycle observation --- not a unit, never held or transferred." Correct that it is not held; but this is the one object in the whole architecture with *no* home, no state, and no discipline — and it is exactly the object the defect lives in.

---

## 4. Additional failure modes in the corporate-action domain, stated architecturally

Each of these is a fact of market structure that any design must survive; none is exotic.

1. **Ordinary vs special dividend — operator selection is externally authored.** An ordinary dividend adjusts nothing except the cum/ex spot (option strikes, index divisors of price-return indices absorb it); a *special* dividend triggers strike/reference adjustments and divisor recomputation. The same cash event maps to different adjustment operators depending on a market-convention classification the ledger does not own. Architecturally: the event→operator map is itself externally authored reference data with its own validity and its own late corrections.

2. **Spin-off — one basis splits into two, with late parameters.** Parent price basis changes by an allocation (`S → S − v(spinco)`); a new unit appears with identifier succession; the official allocation ratio (used for cost basis and often for adjusted data series) is frequently published *after* the effective date. Architecturally: an adjustment whose operator is known before its parameter is — failure-semantics question 6 is not an edge case, it is the normal case for spin-offs.

3. **Rights issue — the adjustment factor is itself a derived datum.** The standard factor is TERP/cum-price, where TERP is computed *from* the observed cum price and the issue terms. Architecturally: adjustment operators can have parameters that are themselves observations, so operator validity and data validity are mutually dependent; any compositional rule must close over this.

4. **Merger with election — the factor is temporarily per-holder.** Cash/stock elections make the effective exchange ratio position-dependent until election and proration resolve. Architecturally: an adjustment that is per-(holder, unit) during a window strains "Status: one value read identically by every holder" (sec04.tex:91-94); the datum's basis has, transiently, the wrong key.

5. **Cross-unit propagation — a CA on X changes the basis of Y.** A split on the underlying adjusts listed-option strikes, multipliers, and deliverables (OCC-style), single-stock-future terms, and every index containing X. Architecturally: basis change propagates along the derivation graph of units and data; a per-unit tag with no edges cannot express it. This is the compositional requirement in its hardest form.

6. **Basis changes with no CA at all — scheduled index maintenance.** Free-float updates, share-count true-ups, and quarterly rebalances change composition/divisor with no lifecycle event on any held unit. Architecturally: the "CA calendar" is not a projection of the ledger's own log; some basis boundaries originate wholly outside it, so a design that derives all basis changes from logged lifecycle events is incomplete on arrival.

7. **Venue-asynchronous ex-dates.** One ISIN, multiple venues, one venue on holiday: the quote goes ex on different calendar days per source. Architecturally: `mQuoteEx` is a property of the (datum, source) pair against the unit's basis, not of the unit; a single per-unit Boolean is the wrong arity.

8. **Timestamp insufficiency and retro-effective CAs.** CA notifications are corrected and occasionally applied retroactively (record-date breaks, depositary-receipt ratio changes announced late). Two observations with identical timestamps can be in different bases; the same timestamp can change basis after the fact. Architecturally: validity is not a monotone function of observation time — this bounds design answer 1 (timestamp alone cannot be the coordinate) and interacts with, but is not solved by, the sec19.tex:48 bitemporal open problem.

9. **Stock dividends / scrip — the event-class→operator map is not injective.** A 5% stock dividend is mechanically a 21-for-20 split (quantity ×1.05, price ×1/1.05) but classified, taxed, and announced as a dividend. Any design keying operators off event class rather than off declared adjustment terms will mis-adjust.

10. **Fractional entitlements — a CA emits both a basis change and a cash move.** Reverse splits and stock mergers generate cash-in-lieu for fractions: the position leg and the cash leg the ledger already handles, *plus* the data-basis leg it does not — one atomic event spanning both worlds, which is the strongest argument that the seam must sit inside the C3 atomicity boundary, wherever the design puts it.

---

## 5. Summary of the finding

The event-sourced half of the system is sound and protected. The observed half has no state model at all: every datum is a scalar, every consumption site is basis-naive, the one existing patch (appD) covers one CA class with one hard-coded additive operator and a caller-asserted Boolean, the property suite cannot detect the resulting mispricings even in principle, and the open-problems register does not contain the defect. The failure is quantitatively unbounded (§2a), silent under a closing total (§2a′), order-sensitive under composition (§2b′), and propagates across the unit graph and into every index and QIS product (§2c, §4.5–4.6). Phase 2 must settle the eight open questions; nothing in this memo presupposes an answer to any of them.