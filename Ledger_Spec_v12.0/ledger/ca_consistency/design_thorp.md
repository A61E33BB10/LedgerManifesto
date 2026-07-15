# THORP — Phase 2 Design Memo
## Corporate-Action Consistency of Consumed Data: the Basis-Epoch Design
### Independent solution, designed in isolation. No pricing model appears anywhere below; every datum is opaque to the framework except for its basis coordinate.

---

## 0. Position, stated first

**I take (iii), a synthesis with a precise division of labour: the basis coordinate is *state* and lives in `UnitStatus`; consumed data carry a *reference* to that state; the reference is checked once, at a single consumption boundary, where the type system makes a mixed-basis valuation unwritable.**

The defect is a missing edge between the CA fold the log already contains and the data the pricing function consumes. A pure data-tag (i) writes down the edge's endpoint but leaves the other end dangling — a tag is meaningless unless something authoritative says what epoch the *unit* is in, and that something is a fold over logged events, i.e. state. A pure fourth-home (ii) overshoots: observations need no new mutable home — the spec already rules that they enter only as logged observation events (sec04.tex:153–155) — they need a validity coordinate and a projection discipline, both of which the existing machinery (materialised projection of the log, sec04.tex:137ff) supplies once the coordinate exists. So:

- **The coordinate** — a per-unit monotone **basis epoch** — is a new `UnitStatus` field, a materialised projection like every other `UnitStatus` field, rebuilt by replay (sec04.tex:135–155).
- **The tag** on every observation is a foreign key into that field, assigned at a parse boundary in the style of `move` (Ledger.hs:207–210).
- **The enforcement** is at consumption: quantity and price meet only inside a *coherent snapshot*, and the snapshot's basis is a phantom/skolem type variable, so pricing an epoch-(n+1) position with an epoch-n quote is a compile error — the Single-Coordinate Move Principle's device (the `FieldWrite (h :: Handler)` GADT, Ledger.hs:329–334) applied at the quantity×price seam.

The three-home model survives with one field added and one derived projection named; nothing protected is touched. Adjusted data are derivations with lineage, never overwrites.

---

## 1. Where the basis lives

**Definition (basis epoch).** For each unit `u`, the *basis history* is the append-only sequence of *basis boundaries* effective on `u`, each carrying a declared adjustment operator; the *basis epoch* `e_t(u) ∈ ℕ` is the number of boundaries effective at or before `t`. Epoch is per-unit, monotone in effective time, and is a fold over logged events — hence a legitimate `UnitStatus` resident under the existing catamorphism discipline (sec04.tex:137–155).

**Two event sources feed the fold, and both are already log-shaped:**

1. **CA lifecycle events** on held units (split, dividend, merger, spin-off, rights) — already in the log as Transactions (sec06.tex:99, sec07.tex:5). The boundary record rides in the *same atomic Transaction* as the CA's moves. This is decisive: C3 atomicity then makes "position doubled but basis not bumped" *unrepresentable*, the same way it already makes "cash paid but state not advanced" unrepresentable (appD.tex:61). Phase 1 finding 10 (fractional cash-in-lieu: one event spanning moves, cash, and basis) lands inside one Transaction with no new mechanism.
2. **External basis notices** for boundaries with no lifecycle event on any held unit — index divisor recomputation, free-float true-ups, composition maintenance (Phase 1 finding 6). These enter exactly as sec04.tex:153–155 already requires external inputs to enter: as logged observation events, here with a canonical handler (`ApplyBoundary`) added to the C11 writer table.

**Why not a timestamp or calendar.** Timestamps have the wrong arity and the wrong monotonicity: one ISIN goes ex on different days per venue (finding 7), two observations at the same instant can sit in different bases, and retro-effective CAs change the basis of a *past* timestamp after the fact (finding 8). The epoch fixes arity (it is per-unit; the per-*source* lag is handled at the tag, §3) and pushes retro-effectivity onto the axis built for it: the basis history is append-only and versioned like `ProductTerms` (Ledger.hs:258–267), so "epoch of `t` as known at `k`" and "epoch of `t` restated" are both well-defined. This names the second axis sec01.tex:28 currently leaves anonymous.

**Why not `UnitStatus`-without-a-counter.** Data must *reference* the basis, and transports must *compose along* it; that requires an ordinal key, not just a state blob. The epoch is the minimal such key: the ordinal of the unit's basis-regime partition.

**Revised `UnitStatus` (reference exposition):**

```haskell
data Op = Affine Rational Cash      -- x |-> (x - c) / f, declared terms; invertible (f /= 0)
        | Pending SourceRef         -- boundary known, parameter not yet published (spin-off)

data BoundaryRec = BoundaryRec { brEff :: Timestamp, brOp :: Op, brDecl :: SourceRef }

data UnitStatus = UnitStatus
  { usLifecycle    :: Lifecycle
  , usLastSettle   :: Maybe (Price, EpochN)   -- was Maybe Qty (Ledger.hs:292): dimension fixed, basis attached
  , usSupersededBy :: Maybe UnitId
  , usBasis        :: [BoundaryRec]           -- NEW; append-only; epoch = length of effective prefix
  }
newtype EpochN = EpochN Integer               -- runtime epoch ordinal
```

`StatusWrite` gains `ApplyBoundary BoundaryRec` (canonical writers: the CA lifecycle handler and the basis-notice handler — one row each in the C11 table). Note the incidental repair: `usLastSettle :: Maybe Qty` was both dimensionally wrong and basis-free (Ledger.hs:292, sec04.tex:244); it becomes a `Price` carrying the epoch it was written in, and reads across a boundary transport it like any other datum.

---

## 2. The adjustment mechanism and its composition law

**Definition (boundary operator).** Each boundary `k → k+1` of unit `u` declares an invertible affine map on each *datum dimension* of `u`. For price-like data the operator is `A_{k+1}(x) = (x − c)/f` with detached cash `c ≥ 0` and factor `f ≠ 0` (an exact rational); the paired action on quantity-like data is `q ↦ q·f`. The parameters come from the **declared adjustment terms of the notice, never from the event class** — a 5% stock dividend declares `f = 21/20, c = 0` and is therefore a split regardless of its name (finding 9); an ordinary vs special dividend differs in *which* declared operators the authority publishes (finding 1), and the ledger consumes the publication, not the taxonomy.

**Definition (transport).** For epochs `m ≤ n` of `u`,

```
T_{m→n} = A_n ∘ A_{n−1} ∘ ⋯ ∘ A_{m+1},      T_{m→m} = id,      T_{n→m} = T_{m→n}⁻¹.
```

**Composition law.** `T` is a functor from the totally ordered set of epochs of `u` (viewed as a groupoid, since every arrow is invertible) into invertible affine maps: `T_{m→k} = T_{n→k} ∘ T_{m→n}` for all `m, n, k`. **Order-sensitivity is resolved by construction:** each CA is its own boundary, so "two CAs in one interval" never composes ambiguously — intervals exist only between *observation* timestamps; between *epochs* there is exactly one arrow, and its factorisation is the epoch order. Affine maps do not commute; the total order says which composite is *the* transport, and no other composite is expressible (§4 shows this at the type level).

**The one illustration (failure mode b′).** Cum spot 102 tagged at epoch `e`; dividend `c = 2` is boundary `e → e+1`; split `f = 2` is boundary `e+1 → e+2`. `T_{e→e+2}(102) = (102 − 2)/2 = 50`. The wrong order, `102/2 − 2 = 49`, is the composite `A_{e+1} ∘ A_{e+2}`, which is not an arrow of the groupoid — there is no epoch at which it typechecks.

**Value invariance becomes a theorem.** For a holding `q` and price `p` in epoch `k`, the boundary's paired action gives

```
(q·f) · ((p − c)/f) = q·p − q·c,
```

and `q·c` is exactly the cash the same atomic Transaction moves (the dividend leg; zero for a pure split). So marked value is continuous through every boundary *up to the explicit moves the boundary books* — Property 5, Lifecycle Value Invariance (sec01.tex:24), currently an assumption conditional on an unstated data discipline (Phase 1 §3), becomes provable from the operator pairing plus C3. Fractional entitlements: `q·f` non-integral triggers the cash-in-lieu move in the same Transaction; the identity holds with the CIL leg on the right-hand side (finding 10).

**Derived data compose without the framework knowing the derivation.** A derived datum's basis is the finite map `UnitId → EpochN` of its inputs' epochs, joined pointwise (a datum on one unit is the singleton case). The framework propagates tags; it never inspects the derivation — this is what "compositional" means here, and it is the whole answer to the index case: a divisor is a datum on the index unit whose basis references both the index unit's own epoch (maintenance boundaries, finding 6) and the constituents' epochs (cross-unit propagation, finding 5: the derivation graph *is* the edge set along which basis changes propagate). Rights issues, where the operator's parameter is itself an observation (finding 3), close under this rule: the derived operator parameter carries the joint basis of its inputs, and the boundary is `Pending` until that parameter is coherent.

**Lazy transport over a canonical raw store.** Raw observations are immutable log entries in their *observation* basis — the store is never re-derived (an eager rewrite is a mutation of history in all but name, and it destroys the "as known at t" reading). Transport happens at consumption, on demand; transported values may be cached as a materialised projection under exactly the `UnitStatus` cache discipline (derivable, discardable, never authoritative). Adjusted data are new derivations carrying lineage (source observation id + operator chain), per the protected constraint.

---

## 3. The tag and its parse boundary

A raw vendor number becomes a ledger observation only through one total ingest function, mirroring `move`'s positivity discipline (Ledger.hs:204–210):

```haskell
data TaggedObs = TaggedObs
  { toUnit :: UnitId, toSource :: SourceId, toTime :: Timestamp
  , toBasis :: Map UnitId EpochN       -- joint basis; singleton for a plain spot
  , toRaw   :: Integer }

ingest :: Ledger -> SourceId -> UnitId -> Timestamp -> Integer -> Maybe TaggedObs
-- tags with the epoch prevailing for (unit, source) at the observation time
```

The tag is assigned per **(unit, source)**, not per unit: a source lagging the ex transition (next-open lag, appD.tex:47–48; venue holidays, finding 7) is a source still publishing in epoch `e` while the unit is at `e+1`, recorded as a per-source epoch offset in the source's calendar. This subsumes `mQuoteEx :: Bool` (appD.tex:48, Ledger.hs:715) — the caller-asserted Boolean, wrong in arity and defined for one CA class — into a derived per-source coordinate with the right arity, and it generalises the hard-coded `Price (q − d)` branch (appD.tex:56) to `T_{e→e′}` for arbitrary boundary chains.

---

## 4. Type-level enforcement (Hutton-style)

Two tiers, matching how the spec already argues: a didactic per-unit GADT that makes the law visible on one page, and the system-level device that scales to runtime epochs.

**Tier 1 — the exposition (per unit, epoch promoted).** The analogue of `FieldWrite (h :: Handler)`:

```haskell
{-# LANGUAGE DataKinds, GADTs, KindSignatures, RankNTypes #-}

data N = Z | S N                               -- epoch ordinals, promoted

newtype ObsP (e :: N) = ObsP Integer           -- a price-like datum IN epoch e
newtype Hold (e :: N) = Hold Integer           -- a holding counted in epoch-e units
data Boundary (e :: N) =
  Boundary { bF :: Rational, bC :: Integer }   -- declared terms of boundary e -> S e

-- Transport is the ONLY function that changes an epoch index, one step, in order:
stepP :: Boundary e -> ObsP e -> ObsP (S e)    -- x |-> (x - c) / f
stepQ :: Boundary e -> Hold e -> Hold (S e)    -- q |-> q * f

-- Quantity and price meet ONLY at equal epochs:
mark :: Hold e -> ObsP e -> Cash
mark (Hold q) (ObsP p) = Cash (q * p)
```

`mark (h :: Hold (S e)) (p :: ObsP e)` **does not typecheck** — the epoch-(n+1) position priced with the epoch-n quote is a compile error, exactly the Single-Coordinate Move guarantee restated at the seam. And because `stepP` lifts `e` only to `S e`, the wrong composite of §2's illustration (`split before dividend`) is also untypeable: the split's `Boundary (S e)` cannot consume an `ObsP e`.

**Tier 2 — the system (epochs are runtime data).** Epochs are folds over the log, unknowable at compile time in general; the scalable guarantee is *scoped coherence*, the `ST`-style skolem — the same "sealed by the type" move the spec uses to seal `Ledger` (Ledger.hs:44–51):

```haskell
newtype PriceV b = PriceV { priceAt :: UnitId -> Price' b }
data Snapshot b  = Snapshot { snapPrices :: PriceV b
                            , snapBal    :: WalletId -> UnitId -> Bal b }

-- The ONE constructor of coherent inputs. Fixes target time t; reads e_t(u) for
-- every unit from replayed UnitStatus; transports every raw observation from its
-- tagged basis to e_t; b never escapes.
withSnapshot :: Ledger -> Timestamp
             -> (forall b. Either StaleReport (Snapshot b) -> r) -> r

markV :: Bal b -> Price' b -> Cash        -- Cash is basis-free: reference currency
value :: [WalletId] -> Snapshot b -> Cash
pnl   :: [WalletId] -> Snapshot b0 -> Snapshot b1 -> Cash   -- two scopes; Cash subtracts
```

Two snapshots' `b`s are distinct skolems and never unify: a price from one cannot mark a balance from the other, and no bare `Price` exists to smuggle in — `withSnapshot` is the single door on the read side, the mirror of `applyTx` on the write side (sec07.tex:68–75). The runtime check (tag = prevailing epoch, else transport, else report) lives *once*, inside the constructor; everything downstream is coherent by type. `value`'s state-sufficiency signature (sec05.tex:44) survives with its third, previously silent dependency — basis agreement — now carried by `b`.

---

## 5. Failure mode (a) end-to-end, with numbers

Unit XYZ; wallet holds 1,000 shares; basis history has 3 boundaries, so `e(XYZ) = 3`.

1. **t_snap.** Vendor EX1 publishes 100.00. `ingest` tags: `TaggedObs {XYZ, EX1, t_snap, {XYZ ↦ 3}, 10000}`. Raw, immutable, in the log.
2. **E ∈ (t_snap, t_price].** 2-for-1 split. **One atomic Transaction**: move +1,000 XYZ from the CA virtual wallet to the holder (position → 2,000), and `ApplyBoundary (BoundaryRec E (Affine 2 0) src)` (epoch 3 → 4). C3: no reachable state has one without the other.
3. **t_price.** `withSnapshot l t_price` fixes target basis `e = 4`. Balance 2,000 is already epoch-4 by the fold. The stored spot is tagged epoch 3; the constructor transports: `T_{3→4}(100.00) = (100 − 0)/2 = 50.00`.
4. **Mark.** `markV (Bal 2000) (Price' 5000)` = **€100,000**. No phantom.
5. **The bug, attempted.** Feeding the raw 100.00 to the mark means either a bare `Integer` (no `Price' b` constructor available outside the snapshot) or a `Price' b'` from a stale snapshot — a skolem mismatch. In the Tier-1 exposition: `mark (h :: Hold (S e)) (ObsP 10000 :: ObsP e)` — **type error**. The €200,000 of Phase 1 §2a is not a wrong number any more; it is a program that does not compile.
6. **Attribution (the §2a′ corruption).** Suppose the true post-split spot at `t_price` is 55 (up 10% like-for-like). Attribution is computed **in one basis**: transport the opening pair to the closing epoch — `w̃_{t0} = T(1,000) = 2,000`, `P̃_{t0} = T(100) = 50`; note `w̃·P̃ = w·P` (the §2 identity, `c = 0`). Then
   - `PnL_price = 2,000 × (55 − 50) = +10,000` ✓ (economic truth),
   - `PnL_flow = (w_{t1} − w̃_{t0}) × 55 = 0` ✓ — the split's moves vanish under transport, as they must: no flow occurred.
   Against Phase 1 §2a′: the −45,000/+45,000 phantom pair is gone, and it is gone *even though the total closed either way* — the decomposition, not just the sum, is now basis-invariant.
7. **Late notice (boundary unknown at t_price).** Then *neither* the moves nor the boundary exist in the log — C3 keeps the two sides together — so the snapshot is coherent at epoch 3: 1,000 × 100 = €100,000, the right value under the information the ledger had. When the notice arrives, restatement replays with the boundary in place; the discrepancy is a knowledge-time correction on the bitemporal axis, not a basis break. The residual control is a boundary reconciliation at the external interface (sec01.tex:80): vendor-published adjustment factors vs applied `BoundaryRec`s, daily.

Failure mode (b) is the same walk with `Affine 1 2`: transport gives (102 − 2)/1 = 100, the €2,000 cash leg books once, total €102,000 — appD's one hard-coded case recovered as the special case `f = 1`. Failure mode (c): the snapped divisor is a datum whose joint basis names constituent B at epoch `e`; B's split moves B to `e+1`; the divisor observation is incoherent at the target basis and the constructor either transports it (if the maintenance boundary's declared operator covers it) or reports it — the phantom −13.9% index move and the half-held replication of Phase 1 §2c are both unreachable through the door.

---

## 6. Time travel

`clone_at t` (sec07.tex:141) already rebuilds `UnitStatus` from the log; `usBasis` is a `UnitStatus` field, so **the epoch prevailing at `t` is reconstructed by the existing mechanism with zero new machinery**. Valuation at a past `t` is `withSnapshot (clone_at t) t`: the target basis is `e_t(u)`, and every stored raw observation is transported *to that epoch* — downgrades use `T⁻¹`, which exists because operators are invertible. This is the guarantee item 2 and item 4 of the time-travel list claim for positions (sec07.tex:128–135), now delivered for data: replay to `t` reconstructs data in the basis prevailing at `t`, not the current basis, because raw observations are frozen and the transport target comes from the replayed state, never from now.

The two axes separate cleanly: **"as known at t"** replays with the basis history as it stood at knowledge time `t` (append-only, so this is a prefix); **"restated"** replays with corrections applied. A pinned snapshot (sec19.tex:18) plus a pinned basis-history version is reproducible *and* right; pinning alone, as Phase 1 noted, was reproducibly wrong.

---

## 7. Failure semantics for late/unknown CAs — as workflow

The snapshot constructor is total: `Either StaleReport (Snapshot b)`, never a silently mixed snapshot (the analogue of `Accepted` being the only `Outcome` carrying a ledger, appB.tex:¶"Typed oracles"). Three regimes, chosen per control point, all typed:

| Regime | Mechanism | Workflow consequence | Where used |
|---|---|---|---|
| **Quarantine** (default) | Units whose data cannot reach the target epoch (`Pending` operator, or no post-boundary observation and no transportable one) are excluded; `StaleReport` lists unit, last coherent epoch, last coherent value, and what is missing | Book values on time minus a named exclusion list; the desk chases a worklist, not a phantom PnL | Daily marks, risk, management PnL |
| **Flagged-stale carry** | An explicit, *logged* election event: carry the unit at its last coherent-basis value, flagged | PnL-explain shows a "stale-basis carry" bucket — auditable, sized, and hunted; never mistaken for price PnL | Management PnL when quarantine of a large unit is worse than a flagged carry |
| **Block** | Constructor failure is a hard stop | Operational halt on every late notice — intolerable for a book of thousands of units, mandatory where a wrong number binds externally | Official NAV strike, settlement projection (§12 boundary) |

The spin-off case (finding 2: operator known before its parameter) is the normal case, not the edge: `Pending` increments the epoch at effectiveness, so *no* number prices the unit at the new epoch until the allocation ratio observation arrives — quarantine is forced, which is correct, because any interim mark is a guess and a flagged carry at the old basis is the only honest alternative. Retro-effective corrections (finding 8) are basis-history appends triggering restatement, per §6.

---

## 8. CDM mapping

CDM v6.0.0 (appF.tex:6) supplies event representations; the map targets the generic operator, keyed on **declared terms, never event taxonomy** (§2):

| CDM object | Ledger construct |
|---|---|
| Layer-1 `Observable` (appF.tex:15) — currently the one object with no home | `TaggedObs`: logged raw observation + joint basis tag. The appF table row "Observable → Market-data input" becomes "Observable → tagged observation (basis-disciplined)" |
| `BusinessEvent` for a CA (split/stock dividend: adjustment ratio; cash dividend: amount; merger: exchange ratio + succession; spin-off: allocation) | One atomic `Transaction`: entitlement moves + `ApplyBoundary` with `Affine f c` read from the declared terms; merger succession additionally writes `usSupersededBy` (Ledger.hs:293), and transport composes across the succession edge so a datum on the dead identifier prices nothing (Phase 1 §2c's dead-quote case is a `StaleReport`, not a freeze) |
| Election/proration events (merger with election, finding 4) | Boundary is `Pending` during the window; per-holder entitlement differences are *moves* (position side, per (holder, unit) — the right key), and the unit-level operator crystallises at proration, restoring "Status read identically by every holder" (sec04.tex:91–94) |
| Index transition / composition instructions | `ApplyBoundary` on the *index unit* via the basis-notice handler — the non-CA boundary source (finding 6) |
| `Observation` primitives / vendor corrections | New raw `TaggedObs` versions on the knowledge axis (sec07.tex:120's versioning, now orthogonal to basis) |

Where CDM's CA coverage is thin (its OTC-derivative origin, cf. the CCP-margin gap appF.tex:57), the notice enters through the same declared-terms schema; the gap note belongs beside appF's existing ones.

---

## 9. Migration impact on the v12.0 text

Minimal-basis edit list; no protected primitive moves.

- **sec04** — add `usBasis` to `UnitStatus` and `ApplyBoundary` to `StatusWrite`/C11 (sec04.tex:244, 253; Ledger.hs:290–311); fix `usLastSettle` to `(Price, EpochN)`; one paragraph after sec04.tex:153–155: observations are logged *with* a basis tag, and the observation store is a named materialised projection under the existing cache discipline. The 2×2 (sec04.tex:62–64) is untouched — the epoch is ledger-authored per-unit Status; the *notice* is externally authored and versioned, sorting exactly as the benchmark example at sec04.tex:46–53 already sorts.
- **sec05** — `value`/`pnl` re-typed over `Snapshot b` (sec05.tex:38–55); State-sufficiency (sec05.tex:63–66) restated: "…current wallet balances, current unit state, and prices **coherent with that unit state's basis**" — the three "current"s acquire the shared definition they lacked; P10 (sec05.tex:74–91) gains the premise "each endpoint a coherent snapshot"; the attribution proposition (sec05.tex:101–110) is restated in a common basis via transport (§5 item 6), with the remark that CA moves contribute zero flow by construction.
- **sec06** — sec06.tex:99's orphan clause "while the price reference halves" gets its writer: the `ApplyBoundary` in the same Transaction. The put schedule (sec06.tex:116–141) notes that a boundary on the underlying propagates to derivative terms via the declared operator on terms-referencing data (strike/multiplier adjustment is a `ProductTerms` `appendVersion` driven by the same boundary event — cross-unit edge, finding 5).
- **sec07** — sec07.tex:120: snapshot versioning acquires the second axis: stored in observation basis, consumed in prevailing basis via transport; time-travel items 2 and 4 (sec07.tex:128–135) extend their claim to data, discharged by §6.
- **appD** — generalised from `Cum | Ex Cash` (appD.tex:44) to the operator groupoid; `statePrice`'s three equations (Ledger.hs:718–721) become the `f = 1` fibre of transport; `mQuoteEx` deleted in favour of the per-source tag; the appD.tex:84 hand-off to the satellite is re-cut: sourcing stays outside, **the basis tag and coherence check are ledger-owned** — the coordinate no longer falls between two documents.
- **appB** — P10's precondition adds coherence; new **P24 (basis coherence)**: for generated boundary sequences and observation sets, `withSnapshot` yields `Right` only when every consumed datum's joint basis transports to the prevailing epochs, and the value-invariance oracle `value_after = value_before − booked_cash` holds across every boundary — this is the oracle that makes failure modes (a)–(c) *falsifiable*, which no existing property could (Phase 1 §3); P8 extends to reconstructing `usBasis` and the observation projection.
- **sec01/sec19** — Property 5 (sec01.tex:24) restated as a theorem with the §2 identity as proof sketch; sec01.tex:28 names the second axis; the sec19 register (sec19.tex:43–58) gains the closed defect and one honest residual: the interaction of retro-effective basis corrections with the bitemporal open problem at sec19.tex:48.
- **appF** — Observable row updated per §8.

---

## 10. Self-check

Signs and limits: transport with `f = 1, c = 0` is the identity (no CA, nothing changes); reverse split `f = 1/10` sends 100 → 1,000 for prices and ×1/10 for quantities, killing the −€90,000 phantom of Phase 1 §2a with the sign right; value invariance holds at every boundary by the §2 identity, so no boundary is a free-money seam; `pnl` of identical snapshots is `mempty`. Frictions assumed away, stated: operator parameters are taken as the authority declares them (disputes and corrections ride the knowledge axis, not this design); exact-rational factors with integral minor units push residuals into explicit CIL moves, never rounding drift; nothing anywhere depends on what any pricing function does with a coherent snapshot — the framework legislates only *which* data it is legal to feed it.