# NAZAROV — Phase 2 Design Memo
## The Denomination Epoch: state-tagged data by coordinate-in-state, carrier-on-datum, equality-at-seam

Boundary held: the observation surface of the v12.0 bundle. All references under `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/`. Nothing in this memo names or depends on a pricing function; every pricing function is a black box that consumes `(Qty, Price)` pairs, and the design decides only which pairs are *legal to form*.

---

## 0. Position taken: synthesis (iii), with an exact division of labour

I reject the framing that (i) and (ii) are alternatives. The defect has one coordinate and two worlds, and the fix assigns each world what it can carry:

- **The coordinate is state** — option (ii)'s insight. The basis of a unit is already a fold over its logged corporate-action events; it is ledger-authored, monotone, and advanced atomically at the single door. I materialise it as a **per-unit denomination epoch** in `UnitStatus`. It is *not* a timestamp and *not* a calendar (§1).
- **The carrier on data is a tag** — option (i)'s insight. Every observation crossing the boundary is stamped, inside its attestation envelope, with the epoch it asserts to be denominated in. The tag is an *assertion of a coordinate whose authority is the ledger's own log*, not a second source of truth.
- **The enforcement is equality at the seam** — a phantom epoch index on quantity-like and price-like types, so `markValue` demands index equality and mixed-basis pricing is a type error, in exact imitation of the C11 `FieldWrite` discipline (`drafts/sec04.tex:415-443`).

One sentence: *the ledger owns the coordinate, the datum carries it, the type checker refuses the mismatch.* No fourth map is added to the sealed `Ledger` (§2.3): the observation store the design needs is a projection of logged observation events, which is machinery the spec already mandates (`sec04.tex:152-155`); what is new is the coordinate those events carry and the discipline at their consumption.

Everything protected stays protected: the atomic move, conservation, and log immutability are not touched; every artefact below is an *appended event* or a *type refinement*.

---

## 1. Where the basis lives: the denomination epoch ε(u)

**D1.** Every unit `u` carries a **denomination epoch** `ε_t(u) ∈ ℕ`: the count of basis-changing corporate-action transactions committed for `u` up to `t`. `ε(u) = 0` at registration.

**D2.** `ε` is a `UnitStatus` field, written only through the existing `StatusWrite` discipline by a new constructor (§5), applied by `applyStatus` inside `applyTx` — the same single door, the same catamorphism property (`sec04.tex:132-155`). It is therefore ledger-authored, monotone, replayable: `clone_at(t)` rebuilds `ε_t(u)` for free, because it rebuilds every `UnitStatus` field (P8, `drafts/appB.tex:33`).

**D3.** A corporate action is **one atomic Transaction** carrying *both halves of the seam*: the position moves (the split's doubling, per `drafts/sec06.tex:99`) **and** the epoch advance with its declared adjustment operator (§3). C3 atomicity welds them. This closes the exit state my Phase 1 memo §1.4 identified — "internally consistent, externally incommensurate" — because after the transaction commits, positions are at ε = n+1 *and* the unit's current epoch reads n+1, so any consumer demanding current-epoch data is forced onto epoch-(n+1) data by type (§5), which either exists, or is derivable (§3), or blocks (§7). The one sentence in the spec with no carrier — "while the price reference halves" (`sec06.tex:99`) — acquires its carrier: the operator in the transaction.

**Why not timestamp + CA calendar.** Rejected on three grounds. (a) The effectiveness time `t_eff` is itself observed, revisable, timezone-bound external data (Phase 1 FM-9): ordering wall clocks against a revisable `t_eff` makes the basis assignment a trust assumption classifying data of its own trust class. (b) Basis-staleness is orthogonal to time-staleness (`drafts/sec11.tex` stale-data gate tests the wrong coordinate; Phase 1 §3, sec11 row): a one-second-old datum can be basis-stale, a day-old datum basis-fresh, so no temporal key can express the invariant. (c) Two consumers snapping one series on opposite sides of a CA (reproduction (d)) are distinguished by *nothing* temporal that the ledger authors. The epoch is the unique per-unit coordinate that is ledger-authored, total-ordered, and flipped by exactly the event that re-bases the data.

**Why not "UnitStatus itself" as an unstructured answer.** The epoch *is* a `UnitStatus` field — but the answer must name what in UnitStatus, because most of UnitStatus (lifecycle stage, cached last settle) is not a basis. The design commits to the counter plus the operator log, nothing vaguer.

**Which events advance ε.** Any CA whose committed declaration includes a non-identity action on *at least one datum class* (§3): splits, reverse splits, stock dividends, cash dividends/coupons at detachment, spin-offs, merger conversions, index composition/divisor changes for basket units. A cash dividend advances ε even though the quantity action is identity — the epoch tracks the meaning of *data*, not of quantities; the quantity action is just one row of the declaration. Appendix D's `Cum | Ex Cash` (`drafts/appD.tex:44`) is recovered as the single-step, additive-operator special case (§9).

---

## 2. The observation side: epoch-stamped attested envelopes, store as projection

**D4 (envelope).** Every datum crossing the boundary enters as a logged observation event whose payload MUST include, besides the ME2 attestation fields already registered (`drafts/sec19.tex:106`: provider key, source, observation timestamp, signature, fallback-chain-as-traversed, content address): a **basis assertion** `(unit-or-series, asserted ε)`. The identity of an observation is thereby the full quadruple (series, value, t_obs, ε) my Phase 1 §1.1 demanded.

**D5 (assertion provenance).** The basis assertion is itself attested: either the source declares the basis of its dissemination (exchanges flag ex-status; index providers publish divisor effective times) and the gateway transcribes it under signature, or the ingestion gateway asserts it under its own key against the ledger's committed CA log — a **named trust assumption** (TA-BASIS, owner: market-data operations; violation consequence: mis-based valuation; detection: §7 quarantine triggers). This replaces `mQuoteEx :: Bool` (`appD.tex:48`), the unattested load-bearing Boolean of reproduction (b), with an attested, general, per-epoch assertion.

**D6 (no fourth map).** The `Ledger` record keeps three maps. The "observation store" is the projection of logged observation events, indexed by (series, t, ε) — exactly the discipline the spec already states for externally sourced inputs (`sec04.tex:152-155`) plus one coordinate. The sec04 2×2 (`sec04.tex:57-70`) is corrected, not extended: *observed* facts (last settlement price, benchmark level, weights) are externally authored facts whose record the ledger preserves — they take the Terms-column discipline (append-only, versioned, preserved "version by version", `sec04.tex:45-52`), realised as logged events; `usLastSettle` survives unchanged as a read cache of the *latest* such event. The misclassification my Phase 1 flagged (authorship-of-record conflated with authorship-of-fact, `sec04.tex:48-52`) is repaired by re-reading the criterion, with no new home: the fourth home the exercise hypothesised is the event log itself, which every view already projects.

**D7 (compositionality — reversal of `appD.tex:82`).** A derived datum carries the epoch vector of its inputs: if all inputs share ε, the output is at ε; if they mix, the derivation is **untypeable** (§5) — the framework never inspects the derivation's interior. The sentence "the distinction between 'primary' and 'derived' market data carries no content here" is struck: the distinction carries exactly one bit of content, *the basis propagates*, and that bit is what stops the laundering of Phase 1 FM-5.

---

## 3. The adjustment mechanism and its composition law

**D8 (operators ride in the CA transaction).** A basis-changing CA transaction carries a **declaration** `CaDecl`: for each datum class it affects, one adjustment operator; the declaration is committed in the log, atomically with the moves and the epoch advance (D3). Operators are exact-rational affine maps per datum class:

```
α : x ↦ (x − b) / m,     m ∈ ℚ \ {0},  b ∈ ℚ        (price-like action)
```

with the dual action on quantity-like classes fixed by the invariance requirement (a split r-for-1 acts as ÷r on price-like, ×r on quantity-like; a cash detachment acts as −d on price-like, identity on quantity-like). Nothing model-dependent enters: an operator is data, declared by the event, applied by one generic evaluator.

**D9 (fail closed).** A datum class the declaration does not name is **unadjustable across that epoch boundary**: it cannot cross; it must be re-observed at the new epoch. Absence NEVER means identity; identity MUST be declared (`AId`). A silent pass-through is the silent fallback of my standing convictions, and it is forbidden.

**D10 (composition law).** Epochs of a unit are the objects of a category; declared adjustments `A_{n→n+1}` are its generating morphisms; the composite from n to m > n is

```
A_{n→m} = A_{m−1→m} ∘ ⋯ ∘ A_{n→n+1}      (composition in log order, and in log order only)
```

Composition is associative (function composition) and **not commutative**; order-sensitivity is *resolved by construction* because the ledger's per-unit event log totally orders the CA events, and no other order is representable — the composite is a fold over the logged declarations, the same shape as every other projection in the spec. Some morphisms are non-invertible (merger for cash: the series terminates; there is no map back, and none forward — the successor unit starts at ε = 0 with its own declared conversion morphism from the predecessor, closing the FM-6 datum-succession gap alongside `usSupersededBy`, `sec04.tex:643-645`).

**The one permitted illustration** (split then dividend in one window, quote 102 at ε = n):

```
A_{n→n+1} = (÷2)   split declared first in the log
A_{n+1→n+2} = (−2) dividend declared second
A_{n→n+2}(102) = (−2)((÷2)(102)) = (−2)(51) = 49
```

The reversed order gives (÷2)(102 − 2) = 50 ≠ 49. The log order is the only order; the 1-tick difference is exactly the dividend halving with the share.

**D11 (lazy, derived, recorded — never eager, never overwrite).** Raw observations are stored at their epoch of observation, immutably, forever; the store is never re-based (eager re-derivation is mutation-shaped and violates the standing rule that adjusted data are derived). Adjustment happens **at consumption**: a consumer at epoch m offered a datum at epoch n applies `A_{n→m}` if the chain exists. For any consumption feeding a committed transaction, the adjusted value MUST be recorded as an appended **derivation event**: {content address of the raw observation, the operator chain by CA-event reference, the exact rational result, the projected integer}. Projection to integer minor units uses the sole rounding site discipline (`sec06.tex:59-61`, round-half-even, once); the recorded exact rational keeps the lineage bit-exact. This makes every adjustment a first-class, dispute-ready derivation (Phase 1 FM-8 closed): raw attested input + identified operator + basis assertion + result, all content-addressed.

---

## 4. Reference data and contract terms

Strikes, barriers, lot sizes, index compositions, divisors, and dividend-forecast series are datum classes like any other and appear in declarations (D8) or are unadjustable (D9). For **ProductTerms** (immutable, versioned), the CA transaction uses machinery that already exists: it carries a `txAppend` with the adjusted terms version — a C6 *Preserving* amendment (`sec04.tex:363, 383-386`), same identity, same fungibility, appended atomically with the epoch advance. The put of reproduction (a) is thereby repaired without an adjustment special case: post-split, the current terms version carries K = 60 at ε = n+1 with lineage to the CA event, and the ε-indexed types (§5) refuse to intersect the old K with a new S_T. Index composition/divisor (reproduction (c)) is one declared composite datum class: the declaration for a constituent CA on a basket unit is issued by the index authority and enters under the same envelope, quorum, and effectiveness discipline as any CA (§7).

---

## 5. Type-level enforcement, in the house style

The discipline mirrors C11 exactly: **the guarantee binds at authorship and is erased at storage** (`sec04.tex:415-443`). The epoch is a phantom index; the store boundary erases it into an existential carrying a runtime witness; consumption re-establishes it by witness equality or fails as a typed error. Hutton-style, woven as the spec weaves `FieldWrite`:

```haskell
-- The denomination epoch, at the type level and at run time. SEpoch is the
-- singleton witness connecting the two -- one runtime value per type index.
data Nat = Z | S Nat

data SEpoch (n :: Nat) where
  SZ :: SEpoch 'Z
  SS :: SEpoch n -> SEpoch ('S n)

-- Every basis-relative scalar is indexed by the epoch it is denominated in.
-- A Quote at epoch n and a Quote at epoch n+1 are DIFFERENT TYPES: they cannot
-- be compared, differenced, aggregated, or marked against each other.
newtype Quote (n :: Nat) = Quote Integer     -- raw disseminated value, minor units
newtype Price (n :: Nat) = Price Integer     -- internal price; still no Monoid
newtype QtyAt (n :: Nat) = QtyAt Qty         -- a holding denominated at epoch n

-- The ONLY exit from Price: the indices MUST match. This is the seam of
-- sec07:23 given its missing constraint -- state_t(u) and market_data now
-- share a coordinate, and the type checker holds it.
markValue :: QtyAt n -> Price n -> Cash
markValue (QtyAt (Qty q)) (Price p) = Cash (q * p)

-- The adjustment operators: the GADT constructors ARE the CA declaration
-- table, exactly as the FieldWrite constructors ARE the C11 field->writer
-- table. Each declared operator crosses EXACTLY ONE epoch boundary; the
-- composite crosses several, in log order only.
data Adjust (n :: Nat) (m :: Nat) where
  AId    :: Adjust n n                       -- identity: DECLARED, never assumed
  AMul   :: Rational -> Adjust n ('S n)      -- multiplicative (split r-for-1: 1/r)
  AAdd   :: Rational -> Adjust n ('S n)      -- additive (detachment: -d)
  AThen  :: Adjust m k -> Adjust n m -> Adjust n k   -- log order: later AFTER earlier

-- adjust is the ONLY function whose type crosses an epoch boundary, and it
-- exists only where a declaration exists: no Adjust value, no crossing (D9).
adjust :: Adjust n m -> Quote n -> Quote m

-- The authorship-site checkpoints, mirroring _c11_ok / _c11_bad (sec04):
_basis_ok  :: QtyAt ('S n) -> Price ('S n) -> Cash
_basis_ok  = markValue
-- _basis_bad :: QtyAt ('S n) -> Price n -> Cash
-- _basis_bad = markValue
--   TYPE ERROR: Price n is not Price ('S n) -- the quote is one corporate
--   action behind the position. The 200,000 of failure mode (a) is not a
--   wrong number here; it is a program that does not compile.
```

At the store boundary the index is erased into an existential — storage is untyped, authorship is typed, precisely C11's erasure step (`sec04.tex:422, 435`):

```haskell
data SomeQuote where SomeQuote :: SEpoch n -> Quote n -> SomeQuote   -- envelope stamp
data SomePos   where SomePos   :: SEpoch n -> QtyAt n -> SomePos     -- fold at ε_t(u)

sameEpoch :: SEpoch n -> SEpoch m -> Maybe (n :~: m)   -- witness equality

-- Consumption re-establishes the index or fails TYPED -- the runtime
-- complement of the compile-time law, never a silent pick:
consume :: SomePos -> SomeQuote -> Either BasisError Cash
consume (SomePos en q) (SomeQuote em p)
  | Just Refl <- sameEpoch en em = Right (markValue q (toPrice p))
  | otherwise                    = Left (BasisMismatch ...)  -- -> §7 workflow
```

`PriceVec` (`sec05.tex:38`, `reference/Ledger.hs:683`) is refined to a **based vector**: per unit, an epoch witness and a price at that epoch; `value` demands, per position row, witness equality with the position's fold-derived epoch. Totality is preserved — "a held unit with no price" stays unrepresentable — and its blind spot is removed: "a held unit priced in the wrong basis" is now *representable as an error and unrepresentable as a Cash*. Intra-vector incoherence (FM-7) becomes checkable at vector construction: a coherent vector is one whose epoch assignment agrees with `ε_t` for every unit in scope, a per-basis-assignment definition of snapshot consistency, which is what P8 lacked for the price plane. Aggregation (FM-1) types the same way: the aggregation function takes `[Quote n]` — one epoch, one partition; a mixed-epoch pool cannot be summed into a median any more than two `Price`s can be added.

The `mTime`/`mSource` provenance pair on observations (`Ledger.hs:180-181, 200-201`) gains the epoch as its third coordinate; `SetLastSettle` caches the value while the logged observation event carries the envelope.

---

## 6. Time travel: replay reconstructs the basis prevailing at t

Two orthogonal version axes, now explicit where `sec07.tex:118-122` had one:

1. **Basis axis (ledger-authored).** `ε_t(u)` is a fold; `clone_at(t)` rebuilds it exactly (P8). Replay of any consumption at t demands data at (series, t, ε_t(u)); since observations are immutably epoch-stamped at capture and adjustments are appended derivation events with lineage, the replay retrieves — bit for bit — the datum, in the basis, through the operator chain, that was used then. "The same market data" (`sec07.tex:144`) stops meaning same-by-timestamp and starts meaning same-by-(timestamp, epoch, derivation).
2. **Correction axis (vendor-authored).** Unchanged: "as known at t" takes the snapshot versions ≤ t; "with corrections through t′" takes restatements. Vendor back-adjusted history (FM-4) is disarmed by content-addressed capture plus the stamp: two pulls of "the close at d" differing because the vendor re-based are two distinct observations at two asserted epochs, both immutable, neither overwriting.

**Late notification (FM-3)** uses machinery the spec already has — the economic/booking timestamp pair (`sec11.tex`, Fault Tolerance, "Late events") — plus one new appended event class:

- The CA transaction commits at booking time `t_notify` with economic time `t_eff`.
- For observations captured in `[t_eff, t_notify)`, the ledger appends **re-stamp derivation events**: value unchanged, coordinate corrected, lineage to the CA transaction. This is the operation the correction algebra lacked (Phase 1 §3, sec11 row): the existing compensating-transaction machinery corrects *wrong values*; the re-stamp corrects *right values with wrong coordinates*. Both are appends; immutability is untouched.
- Replay "as known at t" for `t ∈ [t_eff, t_notify)` reproduces the world as believed (epoch not yet advanced — honest history of an honest mistake); replay "with corrections through t′ ≥ t_notify" applies the re-stamps and the economic-time projection. Any settlement struck in the window is repaired by the *existing* compensating-transaction path, now with a provable coordinate lineage to cite in the dispute.

---

## 7. Failure semantics as workflow

Consequence class decides; nothing silent anywhere.

**W1 — Settlement-grade consumption (emits irreversible moves): BLOCK.** If the required epoch m has no observation and no complete declared chain from any held observation, the lifecycle event **defers** — the sec11 stale-data gate ("defers settlement when price quality is insufficient") extended to test the basis coordinate, which is the coordinate it currently misses. A deferral is a recorded workflow event with a named unblock condition (fresh ε-m observation, or committed declaration completing the chain).

**W2 — Valuation/reporting-grade: FLAGGED STALE BASIS, whole-vector.** Value with the last *coherent* basis assignment as a whole — never mix a fresh constituent with a stale divisor (reproduction (c)) — and flag every affected unit `basis-stale(n → m)` in the output. A coherent stale vector is wrong by at most the CA's economics and says so; a mixed vector is wrong by an unbounded amount and says nothing.

**W3 — Ingestion around a CA window: QUARANTINE by partition.** Aggregation partitions sources by asserted epoch; quorum and disagreement thresholds are computed **within a partition only** (this repairs reproduction (d): {100 @ n} and {50 @ n+1} are two singleton partitions, no false 66.7% divergence, no median 75 that exists in no basis). A source whose basis assertion cannot be established is quarantined, not averaged. A large innovation coinciding with no committed CA declaration is the signature of an *undeclared* CA (or a bad feed) and quarantines the series pending resolution — the detection signal for TA-BASIS.

**W4 — The CA notification itself: strictest attestation class (FM-2).** A basis-changing declaration rewrites both sides of the seam and, once its moves are emitted, cannot be repaired by the price-correction path. Before `applyTx` admits a CA transaction, the declaration MUST carry either an issuer/exchange signature or agreement of the declaration's content hash across `N_CA` independent sources (`N_CA`: TBD, owner: data-governance; ≥ 2). Between first notice and confirmation the unit enters a **pending-transition** state: W1 blocks, W2 flags, W3 partitions.

---

## 8. Failure mode (a), end to end, with numbers

Wallet w holds 1,000 shares of u; ε(u) = 3. Observation committed: envelope {u, 100, t_snap, ε = 3, signed}. Value: `markValue (QtyAt @3 1000) (Price @3 100)` = **€100,000**.

**The CA.** Issuer declares 2-for-1; W4 quorum met. One atomic transaction τ_CA:
- `txMoves`: +1,000 to w from the CA virtual wallet (and correspondingly for every entitled holder) — the log correctly doubles, as today;
- `txStatus`: epoch advance 3 → 4 with declaration `AMul (1/2)` on price-like, `×2` dual on quantity-like, committed in the log;
- `txAppend`: adjusted terms version where strike-like terms exist (C6 Preserving).

**At t_price > t_eff.** Position fold: `QtyAt @4 2000`. The stale spot is `Price @3 100`.
- The historic wrong number: `markValue (QtyAt @4 2000) (Price @3 100)` = €200,000 — **does not compile** (`_basis_bad`). Phantom +€100,000: unrepresentable.
- Legal path 1 (fresh data): post-split quote 50 arrives stamped ε = 4 → 2,000 × 50 = **€100,000**.
- Legal path 2 (derived): `adjust (AMul (1/2)) (Quote @3 100) = Quote @4 50`, recorded as derivation event {addr(obs), τ_CA ref, 50 exact, 50 projected} → 2,000 × 50 = **€100,000**. PnL through the neutral event: **0**.
- Attribution (the Phase 1 corollary): opening holding re-expressed at ε = 4 via the declared dual (1,000 → 2,000; 100 → 50): PnL_price = 2,000·(50−50) = 0, PnL_flow = 0, CA re-denomination term = 0 by construction. The −€50,000/+€50,000 artefact of `sec05.tex:101-110` is gone: prices are differenced only within an epoch, because differencing across epochs does not typecheck.
- Strike reference: terms version at ε = 4 carries K = 60 (τ_CA append, lineage recorded); intrinsic (60−50)·2,000 = €20,000 = pre-split (120−100)·1,000. The 7× mixed-basis error is untypeable.

**Late-notification variant.** Exchange applies the split at t_eff but the notice arrives at t_notify > t_price. In the window the exchange disseminates ~50; the gateway, believing ε = 3, would stamp it 3 — W3 fires (50 vs last ε-3 observation 100, no committed declaration) and quarantines the series; W1 blocks settlement-grade consumption; W2 values flagged-stale at the coherent (1,000 @ 3, 100 @ 3) pair = €100,000, correct as-known. At t_notify, τ_CA commits with economic time t_eff; re-stamp derivations move the window's observations to ε = 4; replay-with-corrections is coherent end to end; anything settled in the window repairs through the existing compensating path with full coordinate lineage. At no point does 2,000 × 100 or 1,000 × 50 reach a committed Cash.

---

## 9. CDM corporate-action mapping

CDM `BusinessEvent` already maps to Transaction (`drafts/appA.tex:13`); the extension is that a CA BusinessEvent's instructions supply *both* halves of τ_CA — the moves and the declaration — transcription, not engineering, exactly as `sec06.tex:21` claims for contracts.

| CDM representation | Generic operator (D8) | Notes |
|---|---|---|
| `CashDividend` / coupon detachment (Transfer + Reset) | `AAdd (−d)` on price-like; `AId` on quantity-like | Generalises `Distribution = Cum \| Ex Cash` (`appD.tex:44`): appD is the single-step additive case; `mQuoteEx` is subsumed by the envelope's attested epoch assertion (D5) |
| `StockSplit` / `ReverseSplit` / `StockDividend` (QuantityChange with ratio) | `AMul (1/r)` price-like; `×r` quantity-like dual | Ratio read from the event's adjustment quantity; moves and operator from one object |
| `SpinOff` | Affine `AAdd(−v)·AMul` on parent; new unit registered at ε = 0 with its own series | Per-share entitlement value v declared by the event |
| Merger, stock-for-stock (`TermsChangeEvent` + succession) | Terminal on u_old + declared conversion morphism to u_new (ratio) | Closes FM-6: `SetSupersededBy` (`sec04.tex:645`) gains its datum-succession operator; u_new starts at ε = 0 |
| Merger for cash | Terminal, non-invertible; no successor morphism | Series ends; D9 fail-closed forbids any further crossing |
| Index rebalance / divisor change (basket redefinition, `sec07.tex:132`) | Composite operator on the (composition, weights, divisor) datum class, declared by the index authority | Reproduction (c); enters under W4 discipline like any CA |
| `TermsChangeEvent` (non-CA amendment) | No operator; C6/C8 as today | Epoch advances only on declared basis change |

CDM carries dates (announcement, ex, record, pay) natively; those bind to the economic timestamp of τ_CA, and the ledger's ordering authority remains its own log (D10), never the calendar (§1).

---

## 10. Migration impact on the v12.0 text

| Location | Change |
|---|---|
| `sec04.tex:62-64, 48-52` | 2×2 cell contents corrected: Status keeps fold-derived fields plus caches; observed facts named as externally authored, record preserved as logged observation events (Terms-discipline). No new map. |
| `sec04.tex:242-260` | `UnitStatus` gains `usEpoch`; `StatusWrite` gains the CA constructor carrying `CaDecl`; `applyStatus` extended (still total, last-write-wins on the cache, monotone on ε). |
| `sec04.tex` C11 exposition | One paragraph noting the same authorship/erasure pattern now also indexes data by epoch (§5). |
| `sec05.tex:26-57` | `PriceVec` → based vector; `value`/`pnl` demand witness equality; the "three illegal states" list gains a fourth. |
| `sec05.tex:74-110` (P10, attribution) | P10 restated: path-independence per coherent basis assignment; across CA boundaries, PnL = within-epoch telescopes + CA re-denomination terms, zero by construction under the declared dual; attribution gains the (identically zero) re-denomination bucket. |
| `sec06.tex:99, 116-141` | The split sentence gains its carrier (τ_CA declaration); the put and lot-size passages note terms adjustment via the C6 append inside τ_CA. |
| `sec07.tex:118-135` | Purity §: the oracle's determinism contract includes the epoch coordinate; time-travel items 2 and 4 point to ε_t and the declaration log as their carrier; snapshot versioning states the two axes (§6). |
| `appD.tex` | Reframed as the single-step special case; `mQuoteEx` replaced by the attested epoch assertion; `appD.tex:82`'s renunciation of primary/derived struck per D7; `appD.tex:84`'s deferral now names the interface the satellite must satisfy: (series, t, ε)-indexed, envelope-stamped, append-only. |
| `sec11.tex` | Stale-data gate gains the basis test (W1); Corrections-as-Events gains the re-stamp event class (§6); Late-events bitemporality cited as the carrier for late CAs. |
| `appB.tex` / `appE.tex` | P8 extended: `clone_at(t).epoch(u) = ε_t(u)`. New oracles: **basis coherence** (every accepted valuation consumed equal-epoch pairs — structurally guaranteed, oracle witnesses the erased boundary); **composition order** (adjusting along the chain equals folding declarations in log order); **fail-closed** (undeclared class cannot cross — a `Left`, never a pass-through); **re-stamp round-trip** (as-known vs corrected replays differ exactly on the window). |
| `sec19.tex` | Flagged-items register gains this defect's closure entry, cross-referenced to ME2 (the envelope gains the basis field) and to the bitemporal open item (partially discharged for the CA case). |
| `reference/Ledger.hs` | Parts E/F refactored per §5; `Move`-adjacent observation provenance gains the epoch; declaration GADT added beside `FieldWrite`. |

No protected element changes: moves, conservation witnesses, `applyTx`, and the hash-chained log are byte-identical in obligation; every addition is an appended event class, a new `StatusWrite` constructor, or a type refinement at the seam.

---

## 11. Verification approach

An auditor confirms a candidate implementation by: (1) exhibiting that `_basis_bad` and a mixed-epoch aggregation fail to compile against the reference types; (2) replaying a log containing the §8 script and checking the three committed values (100,000 / 100,000 / 100,000) and the absence of any committed 200,000; (3) running the composition-order oracle on a window with ≥ 2 CAs (the 49-vs-50 discriminator); (4) exercising the late-notification script and diffing as-known against corrected replay — the diff must be exactly the re-stamped window; (5) checking the trust registry: TA-BASIS named, owned, with W3 as its detection signal, and `N_CA` assigned a value by its owner.

**Deferred:** cryptographic primitives for envelope signatures and content addressing (properties specified, primitives to a cryptographer); the statistical innovation test inside W3 (it receives epoch-partitioned, attested inputs — what it does inside is not mine); workflow-engine realisation of W1–W4 (the states and transitions are specified; orchestration is not mine).

*End of memo. Design position: synthesis (iii) — coordinate in state (per-unit denomination epoch in UnitStatus), carrier on datum (epoch-stamped attested envelope), enforcement at the seam (phantom-epoch type equality, C11-style). Anchors verified against the v12.0 bundle this session.*