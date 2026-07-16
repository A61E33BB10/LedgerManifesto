# Design Memo — The Adjustment Algebra: State-Tagged Data for The Ledger

**Author:** MILEWSKI · Phase 2, independent design (isolation) · No FORMALIS sign-off obtained in this phase, per instruction; the handshake obligations are listed at the end as open items.

---

## 0. Position

**I take position (iii), a synthesis with a small, precisely bounded (ii) component.**

- **The basis coordinate is state.** The corporate-action basis of a unit is already a fold over the CA events in the log — it is a `UnitStatus` fact that the current text simply forgot to project. I add one field, `usBasis :: CAEpoch`, a monotone per-unit counter written like every other status field, and one logged, serialisable adjustment payload per CA event. This is the (ii) half: the defect *is* a missing edge from `UnitStatus` to data validity.
- **The enforcement is a tag plus a typed seam.** Every observation is stamped `(UnitId, CAEpoch)` at the ingestion boundary; every consumption passes through a rank-2 phantom wrapper `At b` whose only constructor is the rebasing function, so mixed-basis pricing is a **compile-time error**, in exactly the style of the C11 `FieldWrite` GADT (check at the live seam, plain data at rest). This is the (i) half.
- **There is no fourth home.** Observations already enter the ledger only as logged observation events (sec04.tex:152–155); their store is a projection of those events like any other view. Promoting them to a fourth state home would add a map whose mutation discipline (immutable stamped snapshots) the log already provides. Minimalism rejects it: nothing a fourth home would hold is missing from "logged event + projection."

Why not the two pure positions:

- **Pure (i) — timestamp-tagged data — fails on its own evidence.** The spec itself records that observation time does not determine basis: appD.tex:48 introduces `mQuoteEx :: Bool` precisely because an exchange quote can still be cum-dividend *after* the ledger's ex transition. A timestamp plus a CA calendar makes validity a runtime join of two timelines, re-deriving at every consumption site what one monotone counter states once. The tag must name the *state*, not the clock.
- **Pure (ii) — "define validity against UnitStatus" with no tag — fails on history.** `UnitStatus` caches the *current* value; a datum snapped last week must name a *past* point of the unit's CA history. A whole historical `UnitStatus` value on every datum is both too heavy and too fine (a lifecycle-stage change is not a basis change). What a datum needs is a *name for a prefix of the unit's CA event stream* — and the length of that prefix is exactly the epoch counter.

So: **the epoch lives in `UnitStatus` (settling open question 1: neither timestamp nor calendar; a monotone per-unit CA epoch, materialised as a status field, authoritative in the log); data carry it as a stamp; the type system polices the seam.**

---

## 1. The concept

A **state basis** is a point in one unit's corporate-action history: the pair `(u, n)` where `n` counts the basis-changing CA events applied to `u` so far. Positions are always in the current basis by construction — the CA lifecycle event *moves* them there (sec06.tex:99: the split doubles every entitled holding). Observations are frozen in the basis at which they were snapped. A valuation is legal iff every input — quantities *and* data — is expressed in one and the same basis.

An **adjustment operator** is the logged, exactly invertible map that a CA induces on each datum kind it touches. The family of these operators, indexed by epochs and closed under composition and inverse, is the adjustment algebra.

---

## 2. The adjustment mechanism and its composition law

### 2.1 The structure, in plain words first

For one unit `u`, list its basis-changing CA events in log order: `g₁, g₂, …, g_N`. Event `gᵢ` carries, for each datum kind it affects, a total map with a total inverse (a split scales, a dividend detachment shifts, a succession substitutes — illustrations only; the framework requires only exact invertibility). Define:

> **Composition law.** The rebasing map from epoch `n` to epoch `m` is
> `A(n→m) = g_m ∘ ⋯ ∘ g_{n+1}` when `n ≤ m`, and `A(n→m) = A(m→n)⁻¹` when `n > m`, with `A(n→n) = id`. Consequently `A(n→k) = A(m→k) ∘ A(n→m)` for all `n, m, k`.

**Order sensitivity is resolved by the log, not by convention.** Adjustment operators do not commute in general — a scale and a shift stacked in the two orders differ — but the question "in which order do they apply?" never arises as a free choice: the log's total order *is* the order, and each generator is recorded in the basis at which it took effect. Between any two epochs there is exactly **one** arrow.

*Categorical name, earned and then set aside:* the epochs of `u` with the maps `A(n→m)` form a **thin groupoid** (one arrow per ordered pair of objects; every arrow invertible), and the assignment of each datum-kind's value space to each epoch, with `A(n→m)` acting on values, is a **groupoid action** — a functor out of that groupoid. The purchase, named per the restraint rule:

- **Thinness** buys the composition law for free: "the" adjustment between two bases is well-defined, so no code path can pick a wrong order — the order-ambiguity bug class is not merely caught, it has no representation.
- **Invertibility** buys time travel (§6): valuing a past date with data stamped at a *later* epoch needs the backward arrow. A monoid of forward adjustments could not express it.
- Nothing further is used. In particular I do **not** assume the action is natural with respect to derivations (§3) — that would be a model assumption, and the standing directive forbids it.

### 2.2 The single permitted illustration (split + dividend)

Spot snapped `100` at epoch 0. Then `g₁` = 2-for-1 split (per-share price scale ½), then `g₂` = dividend ex, €1 per post-split share (shift −1). Then:

```
A(0→2) 100  =  (Shift −1 ∘ Scale ½) 100  =  49
A(2→0)  49  =  (Scale 2 ∘ Shift +1)  49  = 100      -- the inverse composite, exactly
```

Had the two events occurred in the other order the arrow would be `(100 − 1)·½ = 49.5` — a *different* arrow, correctly so, and never confused with the first, because the order is data in the log.

---

## 3. Compositionality through arbitrary derivations

**Claim.** A derived datum's basis is the functorial image of its inputs' bases: whatever the derivation computes — the framework treats it as a black box — its output carries the one basis shared by all its inputs, and inputs at different bases cannot be combined at all.

**The mechanism.** The tagged wrapper is an index-preserving functor with an index-preserving zip:

```haskell
newtype At b a = At a            -- b is a phantom basis witness; constructor NOT exported

instance Functor (At b) where fmap f (At a) = At (f a)

zipAt :: (x -> y -> z) -> At b x -> At b y -> At b z
zipAt f (At x) (At y) = At (f x y)
```

**The proof, by induction over the exported API.** `At` is abstract. Its only introduction form is `rebase` (§4), which fixes `b` to the scope's basis; its only combinators are `fmap` and `zipAt`, which preserve `b` (the functor laws hold definitionally for a newtype). Hence every value of type `At b a` reachable in a well-typed program was computed exclusively from payloads rebased to basis `b` — by structural induction on the derivation expression, equivalently by parametricity of the unexported constructor. `zipAt f x y` with `x :: At b _` and `y :: At b' _` does not unify `b ~ b'` unless they are the same skolem: **mixing bases in a derivation is a type error before pricing is even reached.**

**What is deliberately *not* claimed.** I do not claim `rebase ∘ derive = derive ∘ rebase` — that a derivation commutes with adjustment is a property of the particular derivation (equivariance), i.e. a modelling fact, and the framework never needs it. The canonical rule is therefore: **primitive data are rebased by the registered operators; derived data are rebased by re-deriving from rebased inputs.** Adjusted values are new derivations, never overwrites — consistent with the protected immutability of the log.

---

## 4. The Haskell — type-level enforcement at the pricing seam

Hutton-style: types first, one construction at a time, each line total. This extends `reference/Ledger.hs` and follows its one enforcement idiom — **type-checked at the live seam, plain data at rest** — exactly as C11's `FieldWrite` GADT checks at authorship and erases into `SomeWrite` for storage (Ledger.hs:329–358).

### 4.1 The basis coordinate and the revised `UnitStatus`

```haskell
newtype CAEpoch = CAEpoch Int deriving (Eq, Ord, Show)   -- monotone per unit; 0 at registration

data UnitStatus = UnitStatus
  { usLifecycle    :: Lifecycle
  , usLastSettle   :: Maybe Qty
  , usSupersededBy :: Maybe UnitId
  , usBasis        :: CAEpoch          -- NEW: the unit's current corporate-action epoch
  } deriving (Eq, Show)

data StatusWrite
  = SetLifecycle    Lifecycle
  | SetLastSettle   Qty
  | SetSupersededBy UnitId
  | SetBasis        CAEpoch [(DatumKindName, AdjSpec)]   -- NEW: absolute epoch + logged generator
  deriving (Eq, Show)
```

Two disciplines of sec04 are honoured by construction. The write is **absolute, not an increment**, so it is last-write-wins and idempotent (P6, sec04.tex:250–260): re-applying `SetBasis (CAEpoch 3) …` is the identity on a status already at 3. And it rides the **same atomic Transaction** as the CA's position-adjusting moves (C3): the state in which holdings are doubled but the epoch has not advanced — the exact gap that produces the phantom PnL — is not a representable ledger state, for the same reason appD's cash-leg/ex-state gap is not.

The generator payload is serialisable data, interpreted to functions at the seam; each form is exactly invertible, guarded at CA registration (a zero scale is rejected as a typed error, never stored):

```haskell
-- The LOGGED form of one CA's effect on one datum kind. Exact rational arithmetic:
-- the data plane carries exact scalars; positions remain Integer minor units (sec.4).
data AdjSpec = AdjScale Rational        -- e.g. a split's per-share price factor   (illustration)
             | AdjShift Rational        -- e.g. a distribution detachment          (illustration)
             | AdjSubst UnitId Rational -- identifier succession at a ratio        (illustration)
  deriving (Eq, Show)

data Iso a = Iso { fwd :: a -> a, bwd :: a -> a }   -- laws: fwd . bwd = id = bwd . fwd

idIso :: Iso a
idIso = Iso id id
(>>>) :: Iso a -> Iso a -> Iso a                     -- first i, then j (log order)
i >>> j = Iso (fwd j . fwd i) (bwd i . bwd j)
invIso :: Iso a -> Iso a
invIso (Iso f b) = Iso b f

interp :: AdjSpec -> Iso Scalar                      -- total: registration excluded AdjScale 0
interp (AdjScale r)   = Iso (* r) (/ r)
interp (AdjShift d)   = Iso (subtract d) (+ d)
interp (AdjSubst _ r) = Iso (* r) (/ r)              -- value part; the identity part in §8
```

Datum kinds close the action — each CA names what it does per kind, identity elsewhere:

```haskell
data Kind a where
  KSpot        :: Kind Scalar          -- per-share price-like observations
  KDivSeries   :: Kind [Scalar]        -- per-share forecast amounts
  KComposition :: Kind Composition     -- index membership, weights, divisor
  -- extended per datum family; a kind is a value space + its registered action

newtype CAAdj = CAAdj (forall a. Kind a -> Iso a)    -- one CA's action, interpreted
type Chain    = [CAAdj]   -- generator i maps epoch i to i+1; a PROJECTION of the log
```

### 4.2 The unique arrow — the composition law as code

```haskell
data RebaseError = ArrowUnknown UnitId CAEpoch CAEpoch   -- adjustment not (yet) in the log
                 | WrongUnit    UnitId UnitId
  deriving (Eq, Show)

-- THE arrow n -> m: unique by thinness; total up to a typed error when the log
-- does not yet contain the needed generators (late CA, §7).
arrow :: UnitId -> Chain -> Kind a -> CAEpoch -> CAEpoch -> Either RebaseError (Iso a)
arrow u gs k from@(CAEpoch n) to@(CAEpoch m)
  | max n m > length gs = Left (ArrowUnknown u from to)
  | n <= m              = Right (foldl (>>>) idIso
                                   [ f k | CAAdj f <- take (m - n) (drop n gs) ])
  | otherwise           = invIso <$> arrow u gs k to from      -- the groupoid inverse
-- laws (property oracles, §10):
--   arrow u gs k n n            == Right idIso
--   arrow u gs k n k' <=> compose with arrow u gs k k' m      (functoriality)
--   fwd a . bwd a == id == bwd a . fwd a                       (invertibility)
```

### 4.3 The seam: stamp at rest, skolem in flight

```haskell
-- AT REST: every stored observation carries its basis as plain data, stamped at
-- ingestion from the source's declared convention (§7). Immutable once logged.
data Stamped a = Stamped { sUnit :: UnitId, sEpoch :: CAEpoch, sVal :: a }
  deriving (Eq, Show)

-- IN FLIGHT: a pricing scope, opened per unit. The phantom b is born at withBasis
-- and dies there; values tagged in one scope cannot leak into another (the runST
-- discipline, applied to bases).
data BasisCtx b = BasisCtx { bcUnit :: UnitId, bcEpoch :: CAEpoch, bcChain :: Chain }

withBasis :: Ledger -> UnitId -> (forall b. BasisCtx b -> r) -> Maybe r
withBasis l u body = do
  st <- unitStatus l u                                  -- Nothing = unregistered
  pure (body (BasisCtx u (usBasis st) (caChain l u)))   -- caChain: fold of SetBasis events

-- The ONLY producer of At-values from stored data. Rebasing is where the arrow acts.
rebase :: BasisCtx b -> Kind a -> Stamped a -> Either RebaseError (At b a)
rebase (BasisCtx u e gs) k (Stamped u' e' v)
  | u /= u'   = Left (WrongUnit u u')
  | otherwise = At . (`fwd` v) <$> arrow u gs k e' e

-- Positions are in the ledger's current basis BY CONSTRUCTION (the CA's moves put
-- them there, atomically with SetBasis) -- so the scope may tag them directly.
positionAt :: BasisCtx b -> Ledger -> WalletId -> Maybe (At b Qty)
positionAt (BasisCtx u _ _) l w = At . psBalance <$> position l w u
```

### 4.4 Mixed-basis pricing is a type error

```haskell
-- Scalar -> Price crosses the exact-rational / minor-unit boundary; the rounding
-- rule is fixed, per unit, in ProductTerms -- deterministic, stated once.
toPrice :: BasisCtx b -> At b Scalar -> At b Price

-- The valuation seam, mirroring the Single-Coordinate discipline: quantity and
-- price meet ONLY here, and ONLY at one shared basis witness.
markValueAt :: At b Qty -> At b Price -> Cash
markValueAt (At q) (At p) = markValue q p                 -- sec.5 markValue, unchanged

-- _bad :: At b Qty -> At b' Price -> Cash
-- _bad = markValueAt   -- TYPE ERROR: b /= b'. Pricing an epoch-(n+1) position
--                      -- with an epoch-n quote is not a wrong number; it is
--                      -- not a program.
```

Note what is *not* here: no `Nat`-literal epochs at the type level. Epochs are runtime data (a replay to arbitrary `t` yields an epoch no compiler saw), so the honest static guarantee is **sameness, not value** — which is exactly the invariant ("all inputs to one valuation share one basis"), and exactly what a rank-2 skolem enforces. A `DataKinds` epoch index would claim static knowledge the system cannot have; I reject it under the restraint rule.

### 4.5 Why this and not something simpler

A plain runtime check `sEpoch == usBasis` at each consumption site is the simpler candidate. It fails the same way the rejected `validate` gate for conservation fails (C2): it must be *remembered* at every present and future call site, and a forgotten check is silent. The phantom seam removes the bug class instead: there is no path from `Stamped` to `markValueAt` that does not pass through `rebase`, and `rebase` cannot produce two different bases under one witness. The purchase is concrete — the entire class "stale-basis datum reaches a pricer" loses its representation — and the cost is one newtype, one rank-2 entry point, and two combinators. Nothing heavier (indexed monads, free categories reified in types) buys anything further; rejected.

---

## 5. Failure mode (a), end-to-end

Wallet `W` holds 1,000 shares of `u`; `usBasis = CAEpoch 0`.

1. **Snap.** Spot observed €100, logged as an observation event, stamped from `UnitStatus` at snap: `Stamped u (CAEpoch 0) 100`. Valuation now: scope opens at epoch 0, `arrow 0→0 = id`, price €100; `markValueAt`: 1,000 × 100 = **€100,000**.
2. **The split.** One atomic Transaction (C3): moves doubling every entitled holding (`W`: 1,000 → 2,000), and `SetBasis (CAEpoch 1) [(KSpot, AdjScale (1/2))]`. No intermediate state exists in which the holding is 2,000 and the epoch is 0.
3. **Repricing at `t_price`.** `withBasis` opens the scope at the positions' basis, epoch 1. The stored spot is stamped epoch 0; `rebase` finds the arrow `0→1 = Scale ½`: **€50**, now `At b Price`. `markValueAt`: 2,000 × 50 = **€100,000**. Phantom PnL: **€0**.
4. **The broken program does not compile.** `markValue 2000 100` from the raw `Stamped` value is unreachable: `markValueAt` accepts only `At b Price`, whose sole constructor is `rebase` inside this scope. The €200,000 figure is not detected and rejected — it is **unrepresentable**.
5. **Neutrality as a checkable law.** For a value-neutral CA, the registered action on the quantity dimension and on the per-share price dimension compose to the identity on value (here 2 × ½ = 1). This is a per-CA-class property oracle (§10), not an assumption.

Failure modes (b) and (c) are the same mechanism, not new machinery: the dividend is `AdjShift d` on `KSpot` (appD's entire `Cum`/`Ex`/`mQuoteEx` apparatus is the one-step special case — `Cum` = epoch `n`, `Ex d` = epoch `n+1` with generator `Shift −d`, `mQuoteEx` = the stamp); the index event is a CA **on the index unit itself** with its action on `KComposition` (a divisor recomputation being merely the illustration of that arrow).

---

## 6. Time travel

Replay to `t` must reconstruct data in the basis prevailing *at* `t`. The design gives this in three steps, all consequences of structures already proved:

1. `usBasis` is a status field written only through a logged `StatusWrite`, so `clone_at(t)` rebuilds the epoch prevailing at `t` by the catamorphism property (sec04.tex:145–155) — no new replay machinery.
2. Stored observations are immutable and carry their stamps; they never need "migrating" when history is replayed. (Eager re-derivation of the store is thereby also answered — open question 2: **lazy at consumption; no canonical storage basis is imposed**; a materialised current-basis view is permitted only as a discardable projection, like `UnitStatus` itself.)
3. The scope opened on the clone is at the historical epoch; `rebase` composes **backward arrows** where a datum's stamp postdates `t`. This is the concrete purchase of the groupoid over a monoid: "value the book as of `t` using a datum snapped after the split" requires `A(n+1→n)`, which exists by construction and is exact by the invertibility law.

Orthogonality preserved: sec01.tex:28 distinguishes "as known at `t`" from "with corrected data" — that is *which observation* (snapshot versioning, sec07.tex:120). The basis is *which coordinates*. Two independent axes; the design never conflates them, and both compose: replay at `t` with corrected data = corrected snapshot, rebased along the arrow into the epoch at `t`.

---

## 7. Failure semantics for late and unknown CAs

`rebase` is total with typed failure; the workflow question is what the caller does with `Left (ArrowUnknown …)`.

**Adopted: per-unit quarantine with a typed stale escape.**

```haskell
data Valuation = Priced Cash
               | Unpriced UnitId RebaseError                 -- quarantined, listed, visible
               | PricedStale CAEpoch CAEpoch Cash            -- explicit override; NOT a Cash
```

- **Block-the-book** is rejected: one late CA notice on one unit would halt every valuation; operationally unshippable, and shippability decides.
- **Silent flagged-stale** is rejected: a stale price of the same type as a clean price *is* the defect this design exists to remove.
- **Quarantine per unit** is the minimum: the book values over units with complete arrows; quarantined units are enumerated in the result, never summed silently. Where an operator explicitly accepts a stale basis (a supervised override), the result is `PricedStale`, a *different constructor carrying its basis gap* — downstream code must pattern-match, so confusion with a clean figure is a type error, the same discipline again.

Two late-CA cases, cleanly separated by the design: (α) the CA is in the log but the datum predates it — `rebase` succeeds via the arrow; no failure at all. (β) the CA has happened in the world but is **not yet logged** — the ledger's epoch is honestly stale, positions and data agree on the stale basis, valuation is internally consistent and is *corrected by replay* the moment the CA event is ingested (a new derivation, never a mutation). The residual hazard is a **vendor-adjusted datum mis-stamped** because its source's basis convention was declared wrongly at the boundary; §9 records this as representable, with its reconciliation defence.

---

## 8. CDM corporate-action mapping

The forgetful mapping `F` (appA.tex, appE.tex:33) extends to CA `BusinessEvent`s by one rule: **`F(CA event) = (the moves it already emits, `SetBasis (n+1) specs`)** — the CDM `before`/`after` `TradeState` lineage (sec13.tex:27) maps onto the arrow `n → n+1`, and the CDM event is the generator's provenance record.

| CDM representation | Ledger moves (existing, sec06.tex:99) | Adjustment generator (new) |
|---|---|---|
| Stock split / reverse split (adjustment ratio `r`) | position moves ×`r` from CA virtual wallet | `AdjScale (1/r)` on per-share price kinds |
| Cash dividend at ex-date (`DividendPayout`, transfer) | cash moves issuer → holders | `AdjShift d` on cum-quoted kinds (subsumes appD Cum/Ex) |
| Merger / succession (instrument identifier change) | paired-issuance moves; C8 **Breaking** track | `AdjSubst u' r` — its target **is** `usSupersededBy` (sec04 C8), one fact, two projections |
| Spin-off | issuance moves of the spun unit | `AdjScale` on parent kinds + registration of the child at epoch 0 |
| Index constituent event | rebalance moves on the index unit | a CA **on the index unit**: generator on `KComposition` (divisor recomputation as illustration only) |

Nothing model-dependent enters: CDM supplies parameters (`r`, `d`, successor id); the ledger stores only the declarative `AdjSpec`, and pricing remains an arbitrary black box fed only legally-based inputs.

---

## 9. Illegal states

**Made unrepresentable.**
1. Mixed-basis valuation — `markValueAt` requires one shared skolem; no coercion between `At b` and `At b'` exists (§4.4).
2. A derivation combining inputs at different bases — `zipAt` unifies the witness (§3).
3. "Holdings adjusted, epoch not" (and conversely) — moves and `SetBasis` ride one atomic Transaction (C3).
4. Order-ambiguous stacking of CAs — thinness: one arrow per epoch pair; the order is log data (§2).
5. "Rebased, but nobody knows from what" — `Stamped` carries its basis; a bare unbased scalar has no path to the seam.
6. A non-idempotent epoch write corrupting replay — `SetBasis` is absolute-valued (P6 preserved).

**Remaining representable, and why.**
- A **mis-declared source basis** (vendor delivers pre-adjusted values under a convention declared otherwise). The stamp is only as true as the boundary declaration; no internal type can see through an external number. Defence: reconciliation at the boundary plus the neutrality oracle (§5.5) flagging value jumps at CA effectiveness — detection, honestly, not prevention.
- A **wrong `AdjSpec`** registered for a CA (right structure, wrong ratio). Domain fact, sourced by the domain agents; the algebra guarantees it is applied exactly once, in order, invertibly — not that it is the right number.

## 10. Totality, determinism, and the property obligations

Every function above is total: `arrow` and `rebase` return typed errors, never bottom; `interp` is total because non-invertible specs (`AdjScale 0`) are excluded at CA registration by a typed refusal; the data plane is exact `Rational` (invertibility is exact arithmetic, never float), positions remain `Integer` minor units, and the single crossing `toPrice` uses a rounding rule fixed in `ProductTerms` — deterministic, stated once. Replay determinism is untouched: `usBasis` and the chain are folds of the log, so P8 covers them with no new mechanism. New oracles for appB: groupoid laws (`arrow n n = id`; functoriality; `fwd∘bwd = id`); stamp round-trip (`rebase` then inverse-`rebase` is identity); CA value-neutrality per class; and P10 restated — **path-independence holds again** because each endpoint's `V` is forced single-basis by type, so the telescoping proof of sec05.tex:83–89 regains its premise.

## 11. Migration impact on v12.0 (the (ii) component, bounded)

- **sec04:** `UnitStatus` + `usBasis`; `StatusWrite` + `SetBasis` (absolute, idempotent — P6 argument unchanged); the 2×2 Status cell gains "current CA epoch". C1–C12 all stand; no invariant is weakened, one (P10) regains a premise.
- **appD:** rewritten as the one-step instance of this mechanism; `Distribution`/`mQuoteEx` subsumed by stamp + arrow.
- **sec05:** `PriceVec = UnitId -> Price` (sec05.tex:38) — the seam that admits the defect — becomes basis-indexed via `At`.
- **sec06/07:** CA events add the `SetBasis` payload; time-travel prose cites the backward arrow.
- **appA/appB:** CDM CA rows (§8); new oracles (§10). `reference/Ledger.hs`: the §4 modules, appended.

**FORMALIS items open for the next phase:** the boundary-declaration hazard (§9) as an explicit workflow finding; the `toPrice` rounding rule's determinism proof; totality review of `arrow` on adversarial epoch inputs. Per the handshake, this memo is a draft until those are reviewed; nothing here ships past an objection.

---

*Memory updated:* `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/.claude/agent-memory/milewski/adjustment-algebra-phase2.md` (this position and its file:line anchors) and `ledger-representation-idioms.md` (the settled disciplines — absolute-valued `StatusWrite`s, the `FieldWrite` check/erase pattern, the replay homomorphism — that constrained this design).