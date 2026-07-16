Anchors re-verified against the bundle (`reference/Ledger.hs:290–311` — `UnitStatus`/`StatusWrite`/`applyStatus`, last-write-wins P6; `drafts/sec07.tex:93–120` — booking-order `foldM applyTx` replay, P4). All four objections are confirmed material as filed; each is discharged below by construction, with minimal perturbation. Amended passages: Definitions 2 and 3, §2 (Composition Law note), §3 (one ingest clause), §4 (roles + proviso), §5 (Invariant B), §6 (one sentence), §7 (W4 row), §8 (two clauses), §10 (migration deltas), Part III (rows 10, 19 amended; rows 22–25 added).

---

# FORMALIS CONVERGENCE RULING — The State-Basis Discipline

**Committee:** Leroy (chair), Coquand, Huet, Paulin-Mohring, de Moura, Avigad.
**Disposition:** CONVERGED — re-affirmed after amendment round 2. One design, zero undischarged MATERIAL objections. The round-2 objections (NOETHER-R1, F1, F2, F3) are discharged by construction, not assertion; Part III is the discharge register, itemised.

---

## Part I — Frontier and adjudication

**I.1 The frontier.** All four designs, produced in isolation, converge on the same skeleton: synthesis (iii) — the basis coordinate is *state* (a `UnitStatus` fold behind the existing single door), consumed data carry a *reference* to that state, and enforcement is a *typed seam* at the quantity×price pairing; adjustment is lazy over an immutable raw store; adjusted data are derivations with lineage, never overwrites; no fourth home is added, because observations already enter only as logged events (`drafts/sec04.tex`, observation discipline) and their store is a projection. The committee treats this unanimous skeleton as **settled**. The frontier therefore lies entirely in the mechanics, where each design carries material holes that at least one competitor closes:

- THORP dominates on: joint basis for multi-unit data, per-(unit, source) tagging, the value-invariance identity, the sealed-snapshot read door, the `usLastSettle` repair.
- NAZAROV dominates on: fail-closed declarations (D9), re-stamp derivation events for late CAs, the named trust assumption with detection (TA-BASIS, W3/W4), non-invertible/terminal morphisms, the erasure-honest C11 framing.
- NOETHER dominates on: unexported arrow constructors ("an `Adj m n` IS a proof"), the kind-indexed operator table with succession/recomposition, effective-order indexing, the P10 restatement with proof unchanged.
- MILEWSKI dominates on: the absolute idempotent `SetBasis` (P6), the refusal of derivation equivariance with the re-derivation canon, the rejection of `DataKinds` ordinals in favour of skolem sameness, the `Valuation` sum type, the shippability analysis of blocking.

**I.2 Duplicates struck.** Thirty-six material objections reduce to twenty defect classes (Part III); e.g. the P6-idempotence break is one defect filed twice (vs THORP and NOETHER), the unit-blind index three times (vs NAZAROV, NOETHER, MILEWSKI). The verification round added four classes (rows 22–25), each singleton.

**I.3 The author's candidate.** Its second sentence — *"a datum is not a scalar but a pair (value, state-version); pricing requires all inputs in the same state basis as the positions; adjustment operators map data between state bases"* — is adopted verbatim as the informal statement of the invariant (Part II §5). Its first sentence — timestamp at snap, calendar check at `t_price` — is **rejected**, on grounds all four designs establish independently and the spec itself documents: observation time does not determine basis (`drafts/appD.tex:46–48` introduces `mQuoteEx` precisely because an external quote lags the ledger's ex transition); ex dates differ per venue; retro-effective CAs change the basis of a past timestamp after the fact; and a runtime join of two timelines re-derives at every consumption site what one state coordinate states once (MILEWSKI §0, NOETHER §1, THORP §1, NAZAROV §1 — convergent refutation).

**I.4 Tie-breaker.** Not reached. Every contested point was resolved by an asymmetry of undischarged objections, never by preference. The committee notes for the record that the converged design also happens to win tie-breakers (i)–(iii): one new `UnitStatus` field, one new `StatusWrite` constructor, one new condition, one new event class, one trust-registry entry; the three-home model is retained.

---

## Part II — The Converged Design

### §0. The architectural answer

**Ruling (Bourbaki register).** The answer is **(iii), a synthesis with an exact division of labour**, and it is unanimous across the frontier:

> **The coordinate is state; the datum carries a reference; the seam is typed.** For each unit, the corporate-action basis is a fold over logged events and is materialised in `UnitStatus` behind the existing single writer. Every consumed datum carries, in its attested envelope, a stable reference into that fold. Quantity-like and price-like values meet only inside a coherent snapshot whose basis assignment is fixed by the ledger and sealed by a type variable; mixed-basis pairing is a type error at authorship and a typed refusal at the erased store boundary.

*Justification.* A pure data-tag (i) writes one endpoint of the missing referential-integrity edge and leaves the other dangling: a tag is meaningful only against an authoritative statement of the unit's basis, which is a fold over the log — i.e. state (THORP §0, NOETHER §0). A pure state revision (ii) overshoots: observations need no new mutable home — they need a validity coordinate and a consumption discipline, both supplied by existing machinery once the coordinate exists (MILEWSKI §0, NAZAROV D6). The three-home model of `drafts/sec04.tex` is **retained**: one field is added to the second home, and the observation store is *named* as what it already is — a materialised projection of logged observation events. There is no fourth home.

### §1. Where the basis lives

**Definition 1 (boundary event).** A *boundary event* on unit `u` is a logged event carrying: the unit; an effective time; a **declaration** — a *finite partial map* from datum kinds to operator specifications (§2); and provenance. Boundary events are content-addressed; write `bid` for the address. Two sources emit them, both log-shaped: CA lifecycle transactions on held units (already in the log, `drafts/sec06.tex`, Corporate actions paragraph: "a 2-for-1 split doubles each entitled holding while the price reference halves" — the clause that currently has no carrier), and external basis notices with no lifecycle leg (index divisor maintenance, composition true-ups) entering as logged observation events with a canonical handler. *(Source: THORP §1 two-source analysis; NOETHER §1 placement argument.)*

**Definition 2 (basis point, chain, effective total order, epoch).** A *basis point* of `u` is either the registration point `⊥_u` or a boundary id of `u`. The *basis chain* of `u`, relative to a replay view, is the sequence of `u`'s boundary events in **effective order** known to that view — and effective order is henceforth a stated **total order**: boundaries are ordered lexicographically by

```
(t_eff, prec, bid)
```

where `prec` is the intra-day precedence **declared in the attested notice** (W4) and `bid`, the content address, is a deterministic final tie-break, so the order is total on every representable log. The case in which the order is load-bearing — two non-commuting boundaries on one unit with equal `t_eff` (the design's own same-day dividend + split, §2) — is forced to carry declared precedence by the **same-`t_eff` weld** (§7, W4): a boundary whose `t_eff` equals that of a boundary already committed, or co-presented, on the same unit is admitted only if the notices declare mutual precedence; absent declaration it refuses into pending-transition, fail-closed. Booking order remains banished from the composite: the tie-break is data in the notice, never the log's arrival sequence, and `bid` is reached only where declared precedences tie. *(Discharges F3.)*

The *epoch ordinal* of a basis point is its position in the chain — a **derived, per-view quantity**, never stored. **Stamps and state store basis-point ids, never ordinals.** This is the arbiter's one construction not present in any single memo, forced by the objections: ordinals renumber under retro-effective insertion (objections T2, N7); content-addressed ids do not. *(Source: THORP's foreign-key idea + NAZAROV's content-addressed envelope, hardened.)*

**Definition 3 (the `UnitStatus` field).** `UnitStatus` gains one field, `usBasis :: BasisPoint`, defined from registration onward — `defaultStatus` carries `⊥_u` (C5) — and written only through the closed `StatusWrite` set (`reference/Ledger.hs:299–311`) by a new constructor:

```haskell
SetBasis BasisPoint    -- ABSOLUTE, not an increment: last-write-wins, idempotent (P6)
```

Re-applying `SetBasis b` to a status already at `b` is the identity, exactly as `SetLastSettle`/`SetSupersededBy` behave (`Ledger.hs:301`: "Last-write-wins, idempotent (P6)"). *(Source: MILEWSKI §4.1, verbatim in discipline; discharges T1/N1.)* The chain is a projection of the log; the counter is not stored at all. The stated invariant is: **`usBasis` equals the effective-order tip of the chain as known to the view.** This invariant is *not* self-maintaining, and the committee strikes its own earlier claim that it was: `applyTx` folds in **booking order** (P4; `drafts/sec07.tex`, replay is `foldM applyTx` over the log, never reordered), while the chain is projected in **effective order**, and the two folds do not commute on the retro orbit — under naked last-write-wins, a retro-effective boundary booked late would regress the coordinate to a mid-chain point, on live application and on corrected replay alike. The invariant is therefore **welded at the door**, not assumed:

> **Tip weld.** `applyTx` admits a transaction carrying `SetBasis b` on unit `u` only if `b = tip_eff(chain(u) ⊎ {g})` — the last element, in the effective total order of Definition 2, of `u`'s chain **after insertion of the boundary `g` the transaction itself carries**. Checkable at admission from the committed log and the transaction alone, no market data — the same gate idiom as `move`'s positivity and the invariance weld below.

*Consequences.* For a chain-tip boundary (the common case) the mandated write is its own `bid` — unchanged behaviour. For a **retro-effective boundary** (`t_eff` earlier than a committed boundary's), the post-insertion effective tip is the already-committed tip, so the mandated `SetBasis` re-asserts the standing tip — idempotent under P6 — and the coordinate never moves backward: *"basis regressed by a late notice" is an unrepresentable ledger state*, by admission rather than by the false commutation. The inserted boundary changes mid-chain **arrows** — but arrows are per-view projections of the log, never stored (Definition 5), so every subsequent snapshot recomputes them; stamps captured in the window repair through §6's re-stamp events, moves through the existing compensating path. The booking-order status fold and the effective-order chain projection therefore agree on `usBasis` at **every log prefix**, because every committed write is forced to name the effective tip — an equality witnessed, not merely asserted, by the **retro-insertion permutation oracle** (§10, appB/appE). *(Discharges M6 — now by construction — and NOETHER-R1.)*

**Atomicity and the weld.** A basis-changing CA is **one atomic Transaction** (C3) carrying its entitlement moves, its `SetBasis`, and its declaration. Additionally — closing NAZAROV's gap Z2 — `applyTx` **admits** the transaction only if the moves and the declaration jointly satisfy the *invariance identity* (§2, Theorem 1): quantity legs equal to `q ↦ q·f` up to explicit cash-in-lieu legs, and booked cash legs equal to `q·c`. This is checkable from the transaction alone, requires no market data, and is the same admission idiom as `move`'s positivity gate (`Ledger.hs`, Part B). Consequence: "positions doubled but basis not advanced", "basis advanced but declaration missing", "declaration inconsistent with moves", and — by the tip weld — "basis regressed by a late notice" are all **unrepresentable ledger states**. *(Sources: all four for atomicity; THORP §2 for the identity; NAZAROV Z2 forced the invariance weld; NOETHER-R1 forced the tip weld.)*

Incidental repair carried in: `usLastSettle :: Maybe Qty` (`Ledger.hs:292`) — dimensionally wrong and basis-free — becomes a stamped cache `Maybe (Price, BasisPoint)`. *(Source: THORP; discharges M10.)*

**Why not a timestamp or calendar** — settled by I.3. **Why not a fourth home** — settled by §0.

### §2. The operator algebra and its composition law

**Definition 4 (operator specification).** A declaration maps each affected *datum kind* to one of:

```
Scale q      (q ∈ ℚ, q ≠ 0)      -- invertible          Pending ref   -- boundary known, parameter unpublished
Shift d      (d ∈ ℚ)             -- invertible          Terminal      -- series ends; no arrow in either direction
Subst u' r   (r ∈ ℚ, r ≠ 0)      -- cross-unit, invertible
Recompose σ                       -- invertible iff σ declared bijective
AId                               -- identity: DECLARED, never assumed
```

Non-zero and bijectivity side conditions are enforced by **unexported smart constructors at the single admission door** (`applyTx`), the spec's `move` idiom — the invalid spec is never stored, so `interp` is total over stored values by construction, not by a remembered gate. Parameters come from the **declared terms of the notice, never the event taxonomy**: a 5% stock dividend declaring `f = 21/20` is a scale regardless of its name. *(Sources: kinds and `Recompose`/`Subst` from NOETHER §2 and MILEWSKI §4.1; `Pending` from THORP; `Terminal` from NAZAROV D10; declared-terms register from THORP §2; the fail-closed rule from NAZAROV D9: **absence never means identity; a kind outside the declaration's domain cannot cross that boundary** — and the partial-map encoding makes fail-closed *expressible*, which MILEWSKI's total `∀a. Kind a → Iso a` could not. Discharges T6, Z6, N8, M2.)* All data-plane arithmetic is **exact rational**; the single crossing to integer minor units is `toPrice`, whose rounding rule is fixed once in `ProductTerms` (round-half-even, one site). Intermediate caching is therefore sound: composition of exact maps is path-independent. *(Sources: MILEWSKI §4.1/§10, NAZAROV D11, THORP §2; discharges N5.)*

**Definition 5 (the basis category).** Objects: basis points of all units. Generating arrows, per datum kind `k`: for each boundary event `g` with `k ∈ dom(decl(g))`, one arrow from the point before `g` to the point `bid(g)`, with action `interp(decl(g)(k))`; and for each declared succession (`Subst u'`, welded to `usSupersededBy`, `Ledger.hs:293`), one arrow from the predecessor's final point to `⊥_{u'}`. Inverse arrows exist **exactly where the generator is invertible** (Definition 4); `Pending` and `Terminal` generate no action. The category is *thin on each reachable pair*: within one unit the chain is totally ordered — by Definition 2's total order, including at equal `t_eff` — and succession edges are unique per `usSupersededBy`, so **between any two basis points there is at most one arrow per kind**.

**Composition Law.** For basis points `b ≤ b′` on the (possibly succession-extended) chain, with intervening boundaries `g₁, …, g_n` **in the effective total order of Definition 2**,

```
A_k(b → b′) = interp(decl(g_n)(k)) ∘ ⋯ ∘ interp(decl(g₁)(k))        defined iff k ∈ dom(decl(gᵢ)) for all i
A_k(b′ → b) = A_k(b → b′)⁻¹                                          defined iff every generator is invertible
A_k(b → b)  = id;      A_k(b → b″) = A_k(b′ → b″) ∘ A_k(b → b′).
```

Operators do not commute; **order-sensitivity is dissolved, not configured**: effective order is the epoch order, which is data in the log — `t_eff` and `prec` from the attested notice, `bid` from content — and no other composite is *expressible*, because arrow values are authored solely by the ledger's fold — their constructors are unexported (§4). Knowledge order lives on the bitemporal axis (§6), never in the composite. *(Sources: effective-order indexing from NOETHER §2 and THORP §2 — this is where NAZAROV's booking-order fold, objection Z1, is overruled; sole-authorship from NOETHER §3 and MILEWSKI §4; partial invertibility from NAZAROV D10 — overruling THORP's total groupoid, objection T3, and MILEWSKI's total-invertibility axiom, objection M9.)*

*The one illustration.* Spot 102 stamped at `b`; effective order: dividend `Shift 2` (`b → b₁`), then split `Scale ½` (`b₁ → b₂`). `A(b → b₂)(102) = (102 − 2)/2 = 50`. The reversed composite, `102/2 − 2 = 49`, is not an arrow of the category: no pair of basis points has it as its unique arrow, and no exported constructor can forge it. Had the dividend and split shared one `t_eff`, the composite would be fixed by their W4-declared mutual precedence — and the pair would be **inadmissible without it**: the 49-vs-50 ambiguity is refused at the door, never resolved by arrival order.

**Theorem 1 (Lifecycle Value Invariance — Property 5 of `drafts/sec01.tex`, now proved).** Let a boundary declare price action `p ↦ (p − c)/f` with quantity legs `q ↦ q·f` (up to explicit CIL legs) and cash legs `q·c`, as the admission weld requires (§1). Then

```
(q·f) · ((p − c)/f)  =  q·p − q·c,
```

i.e. marked value is continuous through every boundary **up to exactly the cash the same atomic transaction books**. Fractional entitlements land as explicit cash-in-lieu moves in the same transaction, so the identity holds to the minor unit; residues are conserved flows, never rounding dust. *(Source: THORP §2; the weld from Z2; the exact statement with the cash leg in the proposition per the stylistic objection vs NOETHER.)*

**Pending crystallisation.** A `Pending` boundary advances the basis point at effectiveness (the moves and `SetBasis` commit; C3); its parameter arrives later as a **parameter-publication event referencing the boundary id** — a versioned resolution, exactly the `ProductTerms` append discipline. The chain projection resolves each boundary to its latest parameter version; no list element mutates, no ordinal shifts, and the epoch is unaffected because publication is not a boundary. Until publication, no arrow crosses that boundary for the affected kinds — quarantine is *forced* (§7), which is correct: any interim mark is a guess. *(Discharges T4; keeps THORP's `Pending` while repairing its state transition.)*

**Derived data: the re-derivation canon.** The framework **never assumes** `rebase ∘ derive = derive ∘ rebase` — equivariance of a derivation under adjustment is a property of the black box's interior, and the model-agnostic directive forbids depending on it. The canonical rule is:

> **Primitive data are transported by declared arrows; derived data are re-derived from transported inputs.**

A *stored* derived datum (a vendor divisor, an index level) carries as its stamp the **joint basis** of its inputs — a finite map `UnitId → BasisPoint` (a plain observation is the singleton case). It is admissible at a target assignment `β` **iff its stamp equals `β` pointwise on its whole domain** (Invariant B(ii), §5 — the check ranges over `dom(stamp)`, not over the position scope); the framework refuses to transport it, fail-closed. A derivation performed *inside* a snapshot scope consumes transported primitive inputs and is automatically at `β` — the phantom index propagating through ordinary application. *(Sources: the canon from MILEWSKI §3, adopted normatively — discharging T5; the joint-basis carrier from THORP §2/§3 — discharging Z5, M8, and the vacuity half of N2.)*

### §3. The tag and the ingest door

A raw vendor number becomes a ledger observation only through **one total ingest function** — the parse-boundary idiom of `move` (`Ledger.hs`, Part B):

```haskell
ingest :: Ledger -> SourceId -> Timestamp -> RawDatum
       -> Either IngestError StampedObs
data StampedObs   -- ABSTRACT: constructor unexported; ingest is the only door
  -- carries: value (exact), t_obs, source, and stamp :: Map UnitId BasisPoint,
  -- inside the ME2 attestation envelope (provider key, signature, content address)
```

The stamp is assigned per **(unit, source)**: a source lagging the ex transition (next-open lag, `drafts/appD.tex:47`: "it may LAG the ledger's own ex transition") is a source still publishing at the old basis point while the unit has advanced — recorded as a per-source basis offset, either transcribed from the source's own declared convention under signature or asserted by the gateway against the committed CA log. `ingest` additionally **refuses a stamp naming an unregistered unit** — so the scope-closure condition of Invariant B (§5) is an ingest obligation discharged at the door, never a consumption-time surprise. This subsumes `mQuoteEx :: Bool` (`appD.tex:48`) — caller-asserted, wrong in arity, defined for one CA class — and generalises `priceOf`'s hard-coded `Price (q − d)` branch (`appD.tex:54–57`) to arbitrary boundary chains. The assignment is a **named trust assumption**:

> **TA-BASIS.** Owner: market-data operations. Content: the per-(unit, source) basis stamp assigned at ingest is true of the source's dissemination. Violation consequence: mis-based valuation. Detection: W3 partition quarantine (§7) — a large innovation coinciding with no committed boundary quarantines the series; daily reconciliation of vendor-published adjustment factors against applied declarations.

*(Sources: per-(unit, source) coordinate from THORP §3 — discharging N6 and the case-β half of M3; the single door with typed error from THORP's `ingest` repaired per its own stylistic objection — discharging M4; TA-BASIS with owner/consequence/detection from NAZAROV D5/W3 — discharging T10. The ingest-time contradiction of M3 is resolved by fiat of the door: the stamp comes from the (unit, source) declared convention, never defaulted from the ledger's prevailing state.)*

### §4. Type-level enforcement (Hutton-style, C11 discipline)

The guarantee is stated honestly, in two tiers, exactly as C11 argues (`Ledger.hs:315–358`): **typed at authorship, erased at rest, re-established at consumption**. Epochs are runtime replay outputs; the honest static guarantee is *sameness, not value* — a `DataKinds` ordinal in the normative layer would claim static knowledge the system cannot have. *(Source: MILEWSKI §4.4; discharges N9 and NAZAROV's "does not compile" overstatement.)*

**Tier 1 — the didactic law (one page, exposition of the invariant, not the system mechanism).** All constructors below are **unexported**; the sole author is the ledger's fold — an `Adj` value *is* a proof that the log carries exactly these boundaries, in effective order:

```haskell
{-# LANGUAGE DataKinds, GADTs, KindSignatures, RoleAnnotations #-}
data N = Z | S N

newtype PriceAt (e :: N) = PriceAt Rational   -- constructor NOT exported
newtype BalAt   (e :: N) = BalAt   Integer    -- constructor NOT exported
type role PriceAt nominal   -- GHC would infer PHANTOM: Coercible (PriceAt e) (PriceAt e')
type role BalAt   nominal   -- would hold for ALL e, e', and Data.Coerce.coerce -- Safe
                            -- Haskell, no unsafe feature -- would forge the crossing.
                            -- Nominal makes the coercion derivable only at equal index.

data Adj (m :: N) (n :: N) where              -- constructors NOT exported:
  AIdA  :: Adj n n                            -- the ledger fold is the only author
  AStep :: Adj m n -> OpSpec -> Adj m ('S n)  -- one boundary, in effective order

adjust :: Adj m n -> PriceAt m -> PriceAt n   -- the ONLY epoch-crossing function

markValue :: BalAt e -> PriceAt e -> Cash     -- Qty and Price meet ONLY at equal index
markValue (BalAt q) (PriceAt p) = ...

-- _bad :: BalAt ('S e) -> PriceAt e -> Cash
-- _bad = markValue
--   TYPE ERROR. The epoch-(n+1) position priced with the epoch-n quote is not a
--   wrong number; it is not a program. And `AStep` extends only to 'S n, so the
--   mis-ordered composite of §2's illustration has no inhabitant.
```

*(Sources: the GADT shape from NOETHER §3 and THORP §4 Tier 1; the unexported-constructor repair from NOETHER/MILEWSKI — discharging T9; the role annotations forced by F1.)*

**Tier 2 — the normative seam (runtime epochs, skolem sameness).** The one constructor of coherent read scopes, mirroring `applyTx` as the one write door. Three repairs relative to the filed designs are load-bearing: the ledger is **sealed inside** the scope (no `Ledger` parameter downstream — discharging M1); the skolem `b` denotes a whole **basis assignment**, not one unit's epoch, and every accessor is unit-keyed (discharging Z3, N2); the per-unit price accessor is **fallible**, so quarantine is representable (discharging T8):

```haskell
data Snapshot b   -- ABSTRACT. Constructed only by withSnapshot, which fixes the
                  -- target assignment β = β_t on the STAMP-CLOSURE of the scope
                  -- (Invariant B, §5: β_t is total over registered units; Scope
                  -- restricts which balances are read, never β's domain), reads
                  -- balances from the SAME sealed ledger, and transports every
                  -- admissible stamped observation to β along declared arrows --
                  -- refusing, per unit and kind, where none exists.
type role Snapshot nominal

newtype BalAt'   b = ...        -- constructors NOT exported
newtype PriceAt' b = ...
newtype At b a     = ...
type role BalAt'   nominal
type role PriceAt' nominal
type role At       nominal nominal

withSnapshot :: Ledger -> Timestamp -> Scope
             -> (forall b. Snapshot b -> r) -> r          -- quantifier where the proof lives

snapBal   :: Snapshot b -> WalletId -> UnitId -> BalAt' b
snapPrice :: Snapshot b -> UnitId -> Either BasisError (PriceAt' b)   -- per-unit refusal

markV :: BalAt' b -> PriceAt' b -> Cash                    -- the seam; Cash is basis-free
zipAt :: (x -> y -> z) -> At b x -> At b y -> At b z       -- in-scope derivation: index-preserving

data Valuation = Priced Cash
               | Unpriced UnitId BasisError                -- quarantined, enumerated, visible
               | PricedStale UnitId BasisPoint BasisPoint Cash   -- logged election; not a Cash

value :: Snapshot b -> [WalletId] -> (Cash, [Valuation])   -- book total + exclusion list

-- The single cross-scope door, ledger-authored, factoring ONLY through declared arrows:
carry :: Snapshot b0 -> Snapshot b1 -> Kind a -> At b0 a
      -> Either BasisError (At b1 a)
```

**The unreachability argument, for an arbitrary black-box pricing function.** Let `F :: forall b. Snapshot b -> r` be any pricing function. By parametricity in `b` — within the fragment stated below — every `b`-indexed value `F` manipulates derives from its one `Snapshot b` argument: the constructors of `BalAt'`, `PriceAt'`, and `At b` are unexported, their only introduction forms are `snapBal`, `snapPrice`, `carry`, and index-preserving combinators, and each of these yields values at `β` by construction of the door. Two snapshots' skolems never unify, and `carry` — the only cross-skolem function — factors through the unique declared arrow or refuses. Hence **every (quantity, price-like) pair any well-typed `F` can form lies in a single basis assignment**; the runtime complement, at the erased store boundary, is the witness-equality check inside `withSnapshot` (`sameBasis`-style, NAZAROV §5), which returns a typed `BasisError`, never a silent pick. This is the C11 guarantee restated at the read seam: compile-time at authorship, typed refusal at the boundary — claimed as exactly that and no more.

**Language-fragment proviso (the parametricity appeal, made honest).** GHC infers role *phantom* for a type parameter occurring in no constructor field; `Coercible (PriceAt e) (PriceAt e')` then holds for all `e, e'`, and `Data.Coerce.coerce` — Safe Haskell, no unsafe feature — forges the epoch/skolem crossing regardless of unexported constructors, reaching a committed `Cash` past the witness check. Every basis-indexed carrier — `PriceAt`, `BalAt`, `PriceAt'`, `BalAt'`, `At`, `Snapshot` — therefore **declares `type role … nominal`** on its basis index, making the coercion derivable only at equal indices; the annotations are normative, not stylistic. The enumeration above is claimed for exactly this fragment and no more: Safe Haskell; nominal roles on every basis-indexed parameter; constructors, field selectors, and eliminators unexported; no `Generic`, `Data`, or `Typeable`-derived path exposing representation; no `GeneralizedNewtypeDeriving` on the carriers; no Template Haskell in consuming modules. Within the fragment, the free-theorem reading of `forall b.` is sound and `coerce` contributes no introduction form. *(Discharges F1; completes register item 10.)*

*(Sources: skolem scope from THORP §4 Tier 2 and MILEWSKI §4.3; witness machinery from NAZAROV §5; `Valuation` from MILEWSKI §7; `carry` is the arbiter's construction forced by T7 — the seal is preserved because cross-basis flow is possible *only* through declared arrows, which is the invariant, not an exception to it.)*

### §5. The formal invariant

**Invariant B (single-basis consumption).** *Let `V` be a valuation invocation over position scope `S` at time `t`. Let `β_t : UnitId → BasisPoint` be the **total** basis assignment given by replayed `usBasis` over all registered units (`usBasis` is defined from registration onward, Definition 3: `defaultStatus` carries `⊥_u`). Then: (i) every balance consumed by `V` is read from `S` at `β_t|S`; (ii) every datum `d` consumed by `V` satisfies `stamp(d)(u) = β_t(u)` for **every** `u ∈ dom(stamp(d))` — the check ranges over the stamp's whole domain, whether or not `u ∈ S`; (iii) every value formed from several data is formed from data satisfying (ii) under one and the same `β_t`.*

**Well-definedness (the scope-closure condition).** `withSnapshot` fixes `β` as `β_t` restricted to the *stamp-closure* of `S` — `S ∪ ⋃{dom(stamp(d)) : d consumed}` — which is defined because `β_t` is total over registered units and `ingest` admits no stamp naming an unregistered unit (§3). `S` restricts which **balances** are read; it never restricts the domain on which admissibility is checked. Worked case (c) is the exercise: the scope holds only `I`, the divisor's stamp has domain `{I, A, B}`, and `β_t(A)`, `β_t(B)` are defined and consulted exactly where the joint-basis carrier is exercised. *(Discharges F2.)*

Clause (iii) is what makes the invariant meaningful for a black box: the framework legislates *which data it is legal to feed the function*, never what the function does. The argument that mixed-basis valuation is unreachable is §4's parametricity enumeration under its stated language fragment (compile side) plus the door's witness check (runtime side). State-sufficiency (`drafts/sec05.tex:57`) survives with its third, previously silent dependency — basis agreement — now carried by `b`; the "three illegal states" of sec05 gain a fourth: *a held unit priced in the wrong basis is representable as an error and unrepresentable as a `Cash`*. *(Sources: statement shape from THORP/NOETHER; the author's candidate, second sentence, is this invariant's informal form.)*

### §6. Time travel

`clone_at t` (`drafts/sec07.tex:96`) already rebuilds every `UnitStatus` field by the catamorphism; `usBasis` is such a field, so **the basis prevailing at `t` is reconstructed with zero new machinery** (P8, extended). Historical valuation is `withSnapshot (clone_at t) t`: the target assignment is `β_t`; raw observations are immutable and stamped, so they never migrate; a datum stamped *after* `β_t` is transported backward **iff every intervening generator is invertible** (Definition 4), else refused into the §7 workflow — the honest, partial statement replacing THORP's total `T⁻¹` claim.

The two version axes are orthogonal and both compose. **Basis axis (ledger-authored):** effective total order, per §2. **Knowledge axis (bitemporal):** "as known at `t`" replays with the chain as known at `t`; "restated" replays with corrections. A **late or retro-effective boundary** (booking time `t_notify`, economic time `t_eff`) changes no stored stamp silently: stamps are stable ids, and the ledger appends **re-stamp derivation events** for observations captured in `[t_eff, t_notify)` — value unchanged, coordinate corrected, lineage to the late CA transaction. Its `SetBasis` is tip-welded (Definition 3): it re-asserts the standing effective tip, so the live coordinate never regresses; the corrected replay's chain projection places the boundary mid-chain and recomputes the spanning arrows, and booking-order replay agrees with the effective-order projection on `usBasis` at every prefix — by the weld, witnessed by the retro-insertion permutation oracle. The as-known replay reproduces the honest mistake; the corrected replay applies the re-stamps; moves committed in the window repair through the existing compensating-transaction path, now with a citable coordinate lineage. A pinned snapshot (`sec07.tex:120`) plus a pinned chain version is reproducible *and* right; pinning alone was reproducibly wrong. *(Sources: replay-for-free from all four; the re-stamp event class from NAZAROV §6 — discharging T2's restatement half and N7; effective/knowledge separation from NOETHER §5 and THORP §6; the tip-weld sentence from NOETHER-R1.)*

### §7. Failure semantics for late and unknown CAs — as workflow

Every refusal is typed (`BasisError`); consequence class decides the regime; nothing is silent anywhere.

| Regime | Trigger and mechanism | Workflow consequence | Where mandatory |
|---|---|---|---|
| **W1 — Block** | Move-emitting consumption (settlement projection, NAV strike, fee crystallisation) meets any `BasisError` | The lifecycle event defers as a recorded workflow event with a named unblock condition (fresh observation at `β`, or the crystallising publication event); queues under existing liveness (P21). Real money never moves on an unwitnessed basis | `drafts/sec11.tex` stale-data gate, extended to test the basis coordinate first; `drafts/sec14.tex` pre-invocation check becomes *basis equality first, timestamp threshold second* |
| **W2 — Per-unit quarantine (valuation default)** | `snapPrice` returns `Left` for a unit (no admissible datum, `Pending` gap, undeclared kind) | Book values on time as `(Cash, [Unpriced …])` — a total minus a *named, enumerated* exclusion list; the desk chases a worklist, not a phantom PnL. Block-the-book is rejected: one late notice must not halt thousands of units; shippability decides | Daily marks, risk, management PnL |
| **W2′ — Flagged-stale carry** | An explicit, *logged* election event with its canonical writer row in the C11 table | The unit is valued **coherent-at-`β⁻`** — the latest assignment `β⁻ ≤ β_t` at which its data are pointwise complete — never a mixed vector. Result is `PricedStale u b⁻ b_t cash`: a distinct constructor carrying its gap; downstream must pattern-match. Terminology fixed: *coherent-at-`β`* = all inputs share assignment `β` (internal consistency); *current* = `β = β_t`. W2′ is coherent, not current, and says so | Management PnL where quarantining a large unit is worse than a flagged carry |
| **W3 — Ingestion partition quarantine** | Aggregation partitions sources **by asserted basis point**; quorum and divergence are computed within a partition only | `{100 @ b₃}` and `{50 @ b₄}` are two singleton partitions — no false 66.7% divergence, no median 75 that exists in no basis. A large innovation with no committed boundary is the signature of an undeclared CA or a bad feed: series quarantined. This is TA-BASIS's detection signal | All ingestion around CA windows; the structural window in which the world has split but the log has not is thereby *detected*, honestly, not prevented |
| **W4 — CA notice attestation** | A boundary declaration rewrites both sides of the seam and, once its moves are emitted, cannot be repaired by the price-correction path | Admission requires issuer/exchange signature or content-hash agreement across `N_CA ≥ 2` independent sources (owner: data governance). **Same-`t_eff` precedence weld:** a boundary whose `t_eff` equals that of another boundary on the same unit — committed or co-presented — is admitted only if the attested notices declare mutual precedence (the `prec` component of Definition 2's total order); absent declaration, the colliding notice refuses into pending-transition, fail-closed. Between first notice and confirmation the unit is *pending-transition*: W1 blocks, W2 quarantines, W3 partitions | Every boundary event |

The pending spin-off is the normal case, not the edge: `Pending` advances the basis point at effectiveness, so no number prices the unit at the new basis until the parameter publishes — quarantine is forced, and a flagged carry at the old basis is the only honest alternative. *(Sources: regime table synthesised from THORP §7, NAZAROV W1–W4, NOETHER §6, MILEWSKI §7; the coherent/current distinction repairs Z7; the `Valuation` carrier repairs T8; the same-`t_eff` weld discharges F3.)*

### §8. Failure modes (a), (b), (c) — structurally excluded, with numbers

**(a) The 2-for-1 split, end to end.** Wallet holds 1,000 shares of `u`; `usBasis = b₃`.

1. *Snap.* Vendor EX1 publishes 100.00; `ingest` stamps `{u ↦ b₃}` per the (u, EX1) convention. Immutable, logged.
2. *The CA.* One atomic transaction `τ`: moves +1,000 from the CA virtual wallet (1,000 → 2,000); `SetBasis b₄`; declaration `{KSpot ↦ Scale ½, …}`. **Admission welds:** quantity legs `2,000 = 1,000 × 2` ✓, cash legs `0 = 1,000 × 0` ✓ (Theorem 1's hypotheses), and `b₄ = tip_eff` ✓ (tip weld). No reachable state has the doubling without the boundary.
3. *Snapshot at `t_price`.* `β(u) = b₄`; balance `2,000` at `b₄` by the fold; stored spot stamped `b₃`; the door transports along the unique arrow: `A(b₃→b₄)(100) = 50`.
4. *Mark.* `markV 2000 50` = **€100,000**. Phantom: none.
5. *The bug, attempted.* Feeding the raw 100 requires a `PriceAt' b` value, whose only doors are `snapPrice` and `carry` — both refuse or transport — and whose nominal role bars the `coerce` back door (§4 proviso). In Tier 1: `markValue (BalAt @('S e) 2000) (PriceAt @e 100)` — **type error**. The €200,000 is a program that does not exist (compile side) and a `Left BasisMismatch` (runtime side); it never reaches a committed `Cash`.
6. *Attribution.* True post-split spot 55 (up 10% like-for-like). Open `Snapshot b₀` (pre) and `Snapshot b₁` (post); `carry` transports the opening pair along the declared arrow: `(1,000, 100) ↦ (2,000, 50)`, value-preserving by Theorem 1 (`c = 0`). Then `PnL_price = 2,000 × (55 − 50) = +10,000`; `PnL_flow = (2,000 − 2,000) × 55 = 0`. The −45,000/+45,000 phantom pair of the attribution decomposition is gone — the *decomposition*, not just the sum, is basis-invariant, and it is now *writable*, through the one declared door. *(T7 discharged in the walk itself.)*
7. *Late notice.* If `τ` is unlogged at `t_price`, C3 keeps moves and boundary together, so the snapshot is coherent at `b₃`: `1,000 × 100 = €100,000` — right under the information held. Meanwhile the exchange disseminates ~50: W3 fires (innovation with no committed boundary), quarantines the series; W1 blocks settlement-grade use. At `t_notify`, `τ` commits with economic time `t_eff`; if other boundaries have committed with later `t_eff` in the interim, the tip weld makes `τ`'s `SetBasis` re-assert the standing effective tip — the coordinate cannot regress — while `τ`'s boundary inserts mid-chain in the projection. Re-stamp events move the window's observations to their corrected points; corrected replay is coherent end to end. At no point does `2,000 × 100` or `1,000 × 50` reach a committed `Cash`.

**(b) The dividend.** Same walk with `Shift 2`, `f = 1`: transport gives `102 − 2 = 100`; the €2/share cash leg books once, in the same transaction, `booked cash = q·c` by the weld; total €102,000. `drafts/appD.tex:44–57` — `Distribution = Cum | Ex Cash`, `mQuoteEx`, and `priceOf`'s three equations — is recovered exactly as the one-step, `f = 1` fibre: `Cum` = the old basis point, `Ex d` = the new one with generator `Shift d`, `mQuoteEx` = the per-(unit, source) stamp. The lagging source (quote still cum after the ledger's ex transition) is stamped at the old point and transported — the case appD hard-codes, generalised.

**(c) The index divisor.** Index `I` over A (60) and B (84); level `(60 + 84)/D = 100` fixes `D = 1.44`, snapped as a **derived observation with joint stamp** `{I ↦ b_I, A ↦ b_A, B ↦ b_B}`. B splits 2-for-1 (`b_B → b_B′`); fresh prices: A 60, B 42. The corrupt number — `(60 + 42)/1.44 = 70.8`, a phantom −29.2% index move — requires consuming the snapped `D` at an assignment where `β_t(B) = b_B′ ≠ b_B`: **pointwise inadmissible; refused, fail-closed** — and the check is well-defined although the scope holds only `I`, because `β_t` is total over registered units and admissibility ranges over the stamp's full domain `{I, A, B}` (Invariant B(ii), scope-closure). The framework will not transport a derived datum (no equivariance assumed). Legal paths: the index authority's maintenance boundary on `I` declares `Recompose` with `D′ = 1.02` (so `(60 + 42)/1.02 = 100`), entering under W4 like any CA; or a fresh divisor observation arrives stamped at the new assignment; or the level is re-derived in-scope from transported constituents where the derivation runs inside the snapshot. Until one of these, `snapPrice I = Left …` — `Unpriced I`, enumerated, never a silent 70.8.

### §9. CDM corporate-action mapping

CDM v6.0.0 `BusinessEvent`s already map to Transactions; the extension is one rule: a CA event's instructions supply **both halves** of `τ` — the moves and the declaration — keyed on **declared terms, never taxonomy** (THORP §2). The forgetful map of `drafts/sec13.tex` lands in (moves, `SetBasis` + declaration) instead of moves alone; it remains total and deterministic, and the one economic fact it now keeps is precisely the fact it was discarding.

| CDM representation | Moves (existing) | Declaration (new) |
|---|---|---|
| StockSplit / ReverseSplit / StockDividend (QuantityChange, ratio `r`) | entitlement ×`r` via CA virtual wallet (`sec06.tex`) | `KSpot ↦ Scale (1/r)`, per-share reference kinds likewise; weld checks `q′ = q·r` |
| CashDividend / coupon detachment (Transfer) | cash issuer → holders | `KSpot ↦ Shift d` on cum-quoted kinds; weld checks cash = `q·d`; subsumes appD Cum/Ex |
| SpinOff | issuance moves of the child; child registered at `⊥` | parent kinds `Pending ref` until allocation publishes, then the publication event crystallises the affine parameter |
| Merger stock-for-stock (TermsChange + succession) | C8 Breaking amendment + paired issuance; `usSupersededBy` | `Subst u′ r` — the cross-unit arrow; predecessor data reach the successor's basis through it (dead quotes on the old id price nothing without it) |
| Merger for cash | terminal moves | `Terminal` — no arrow in either direction; fail-closed forbids any further crossing |
| Index rebalance / divisor change | rebalance moves on the strategy unit | boundary **on the index unit** via the basis-notice handler; `KComposition ↦ Recompose σ`, under W4 |
| Election / proration windows | per-holder entitlement differences are moves | boundary `Pending` during the window; unit-level operator crystallises at proration — Status stays "read identically by every holder" |
| TermsChange (non-CA amendment) | C6/C8 as today | no declaration; the basis advances only on declared basis change |

*(Rows merged from THORP §8, NAZAROV §9, NOETHER §7, MILEWSKI §8; succession semantics per NOETHER/NAZAROV — successor starts at `⊥` with a declared conversion arrow — repairing M7.)*

### §10. The state model ruling and migration impact on v12.0

**Ruling.** The **three-home model is retained**. Home 2 (`UnitStatus`) gains `usBasis`; the observation store is *named* as a materialised projection of logged observation events under the existing cache discipline (derivable, discardable, never authoritative). The hypothesised fourth home is the event log itself, which every view already projects. The sec04 2×2 is corrected in one sentence, with derivation: observed external facts are externally authored facts whose *record* the ledger preserves version by version (the Terms-column discipline realised as logged events); the epoch is ledger-authored per-unit Status. *(NAZAROV's reclassification, now argued rather than asserted, per its stylistic objection.)*

Migration list (minimal basis; no protected primitive moves — the atomic move, conservation, and log immutability are byte-identical in obligation):

- **sec04** — `usBasis :: BasisPoint` in `UnitStatus`, with `defaultStatus` carrying `⊥_u` (C5, so `β_t` is total over registered units); `SetBasis` (absolute) in `StatusWrite` with its C11 writer rows (CA lifecycle handler; basis-notice handler; the W2′ election event's writer row — closing THORP's stylistic gap); the **three admission welds stated together at the door**: invariance identity, tip weld, same-`t_eff` precedence weld; `usLastSettle → Maybe (Price, BasisPoint)`; one paragraph naming the observation projection; new condition **C13 (basis edge)**: every consumed datum names its joint basis; consumption requires pointwise agreement, over the stamp's whole domain, with the prevailing total assignment `β_t`, or a ledger-authored arrow — the data-plane sibling of P3.
- **sec05** — `PriceVec` (sec05.tex:38) replaced by the sealed `Snapshot b`; `value`/`pnl` re-typed as §4; the "three illegal states" (sec05.tex:57) gain the fourth; **P10 restated** with the hypothesis "each endpoint a coherent snapshot (C13)" — *proof unchanged*: the hypothesis was always in use, now it is in the statement and the type discharges it, with the cross-boundary telescope closed by Theorem 1's identity plus C3 (NOETHER's framing, THORP's lemma — supplying the boundary lemma MILEWSKI's stylistic objection demanded).
- **sec06** — sec06.tex's orphan clause "while the price reference halves" gains its carrier: the declaration in the same transaction; put/lot-size passages note terms adjustment as a C6 Preserving append inside `τ`.
- **sec07** — snapshot versioning acquires the second axis (stored in observation basis, consumed at the prevailing assignment); time-travel items 2 and 4 extend to data, discharged by §6; the oracle's determinism contract includes the basis coordinate; the replay-law remark gains one sentence: P4's booking-order fold and the effective-order chain projection agree on `usBasis` by the tip weld, not by commutation.
- **sec11** — stale-data gate tests basis first; Corrections-as-Events gains the **re-stamp** event class; late-events bitemporality cited as the late-CA carrier.
- **sec14** — pre-invocation check: basis equality first, timestamp threshold second.
- **appD** — reframed as the one-step special case; `Distribution`/`mQuoteEx`/`statePrice` subsumed (§8b); the satellite hand-off re-cut: sourcing stays outside, **the stamp and the coherence check are ledger-owned**.
- **appB/appE** — P8 extended (`clone_at(t)` rebuilds `usBasis` and the observation projection); new oracles: **P24 basis coherence** (accepted valuations consumed pointwise-equal bases over full stamp domains — structurally guaranteed; the oracle witnesses the erased boundary); **value invariance** (the weld: `value_after = value_before − booked_cash` across every boundary — the oracle that makes (a)–(c) falsifiable); **composition order** (the 49-vs-50 discriminator on ≥ 2-CA windows, **extended to equal-`t_eff` pairs**: declared precedence, never arrival order, decides the composite, and an undeclared collision is a refusal, not a pick); **retro-insertion permutation** (commit a retro-effective boundary mid-chain: assert `usBasis` equals the effective tip at every log prefix, that the live coordinate never regressed, and that booking-order replay and the effective-order chain projection agree on the coordinate before and after corrected replay — the two-fold agreement on the retro orbit, witnessed rather than asserted); **fail-closed** (undeclared kind cannot cross — a `Left`, never a pass-through); **re-stamp round-trip** (as-known vs corrected replays differ exactly on the window); **stamp round-trip** (invertible arrows compose to identity).
- **appF** — Observable row: "Observable → stamped observation (basis-disciplined)".
- **sec01/sec19** — Property 5 restated as Theorem 1 with the weld as proof; sec01's second axis named; the sec19 flagged-items register gains the closure entry, **TA-BASIS** in the trust registry (owner, consequence, detection, `N_CA` assigned by data governance), and one honest residual: the interaction of retro-effective basis corrections with the standing bitemporal open item — narrowed by the tip weld to stamp/move repair, the coordinate itself being protected.
- **sec13** — `forget` extended per §9.
- **reference/Ledger.hs** — §4's modules beside `FieldWrite`, **with `type role … nominal` on every basis-indexed carrier and the language-fragment proviso in the module header**; the Tier-1 GADT with unexported constructors as the didactic companion.

**Invariants restated:** none weakened. P5 becomes a theorem on both factors; P6 unchanged (all writes absolute; the tip weld constrains *which* absolute write is admissible, not how writes compose); P8 extended; P10 gains its honest hypothesis with proof unchanged; C13 and P24 are additions. Every strengthened statement was previously true only under an assumption no text stated.

---

## Part III — Discharge register

Every MATERIAL objection, grouped by defect class (duplicates struck), with the discharging construction:

| # | Objections | Defect | Discharged by |
|---|---|---|---|
| 1 | T1, N1 | Non-idempotent basis write breaks P6 | Absolute `SetBasis BasisPoint`, last-write-wins (§1; MILEWSKI) |
| 2 | T2, N7 | Ordinal stamps renumber under retro-effective CAs | Stamps are content-addressed boundary ids; ordinals derived per view; re-stamp events for affected windows (§1 Def. 2, §6; arbiter + NAZAROV) |
| 3 | T3, N4, M9 | Total invertibility asserted; `Pending`/terminal/`f=0` refute it | Category with *declared* partial invertibility; `Pending`/`Terminal` in the alphabet; backward transport iff invertible, else typed refusal → workflow (§2, §6) |
| 4 | T4 | `Pending` crystallisation unimplementable in append-only list | Parameter-publication event referencing the boundary id; chain projection resolves latest version; epoch unaffected (§2) |
| 5 | T5 | Derived-data transport needs equivariance (model-agnostic violation) | Re-derivation canon adopted normatively; stored derived data admissible only at pointwise-equal stamps, fail-closed (§2; MILEWSKI) |
| 6 | T6, Z6, N3, M7 | Alphabet cannot express succession/recomposition; `Subst` untypeable, `WrongUnit` blocks the crossing it exists for | Kind-indexed declarations; objects are (unit, point) pairs; cross-unit succession arrows welded to `usSupersededBy` (§2 Def. 5, §9) |
| 7 | Z3, Z5, N2, M8 | Unit-blind index; joint basis has no carrier; multi-unit derivations untypeable | Skolem denotes a whole basis *assignment*; accessors unit-keyed; joint stamp `Map UnitId BasisPoint`; in-scope derivations at `β` by construction (§2, §4) |
| 8 | Z1 | Booking-order composite permanently wrong | Effective-order indexing; knowledge on the bitemporal axis; re-stamps (§2, §6) |
| 9 | Z2 | Operator not welded to moves; Property 5 unproved | Commit-time admission identity + Theorem 1 + value-invariance oracle (§1, §2) |
| 10 | Z4, T9, M4 | Forgeable arrows / stamps / Tier-1 constructors | All constructors unexported; sole authors: the ledger fold, `ingest`, `withSnapshot`, `carry`; **`type role … nominal` on every basis-indexed carrier + language-fragment proviso, closing the `coerce` forgery path** (§3, §4) |
| 11 | T8 | Quarantine unrepresentable in total `PriceV` | `snapPrice :: … -> Either BasisError …`; `Valuation` sum; `(Cash, [Valuation])` (§4, §7) |
| 12 | T7 | Cross-basis attribution unwritable under the seal | `carry`: the single declared cross-scope door; seal preserved because only declared arrows flow (§4, §8a.6) |
| 13 | N6, M3 | Lagging source mis-stamped; ingest specification contradictory; case-β window silent | Per-(unit, source) stamp through the single door, never defaulted from ledger state; W3 partition quarantine as detection; window acknowledged as detected-not-prevented residual (§3, §7, §8a.7) |
| 14 | T10 | Load-bearing stamp assignment unnamed as a trust assumption | TA-BASIS: named, owned, consequence stated, detection = W3 + daily factor reconciliation (§3) |
| 15 | N5 | Integer arithmetic breaks totality and caching soundness | Exact rationals on the data plane; single rounding site `toPrice`; caching path-independent (§2) |
| 16 | N8, M2 | Undeclared kind passes through as identity (fail-open) | Partial declaration map: absence = no arrow = cannot cross; `AId` must be declared; fail-closed *expressible* (§2) |
| 17 | N9 (+ Z-stylistic) | "Does not compile" overstates a static claim | Honest two-tier statement: sameness-not-value skolem normatively; Tier-1 GADT labelled didactic; runtime witness at the erased boundary, C11 register; parametricity bounded by the stated language fragment (§4) |
| 18 | M1 | Skolem does not seal the ledger; two-ledger mixing compiles | Balances constructed inside `withSnapshot`; no `Ledger` parameter escapes the scope (§4) |
| 19 | M5, M6 | `arrow` non-total on adversarial `Int` epochs; chain-contiguity invariant unstated | No arithmetic indexing anywhere: resolution is log lookup keyed on boundary ids; the counter is not stored; **`usBasis` = effective-order tip is a stated invariant enforced by the tip weld at admission — not by an asserted commutation of the two folds — and witnessed by the retro-insertion permutation oracle** (§1 Def. 3, §10) |
| 20 | Z7 | W2 "coherent" self-contradictory | *Coherent-at-`β`* (internal) distinguished from *current* (`β = β_t`); W2′ values coherent-at-`β⁻`, flagged with its gap (§7) |
| 21 | M10 | `usLastSettle` left basis-blind inside the repaired record | `Maybe (Price, BasisPoint)` stamped cache (§1; THORP) |
| 22 | **NOETHER-R1** | Booking-order status fold and effective-order chain projection do not commute on the retro orbit; naked last-write-wins lets a retro-effective boundary regress `usBasis` to a mid-chain point on live application and corrected replay; "basis regressed by a late notice" was representable, `β_t` wrong, P10's coherent-endpoint hypothesis satisfied at a stale assignment | **Tip weld** (§1 Def. 3): `applyTx` admits `SetBasis b` only if `b` is the post-insertion last-effective element — checkable from log + transaction, P6-idempotent in the retro case, so the coordinate cannot regress by construction; arrows recomputed per view (never stored); **retro-insertion permutation oracle** (§10 appB/appE) witnesses two-fold agreement at every prefix; §6 and §8a.7 carry the corrected walk |
| 23 | **F1** | Basis indices inferred role phantom; `Data.Coerce.coerce` (Safe Haskell) forges the epoch/skolem crossing past unexported constructors, refuting the §4 unreachability enumeration | `type role … nominal` declared on `PriceAt`, `BalAt`, `PriceAt'`, `BalAt'`, `At`, `Snapshot`; **language-fragment proviso** bounding the parametricity appeal (Safe Haskell, nominal roles, no representation-exposing derivation, no GND on carriers, no TH); normative in `reference/Ledger.hs` (§4, §10) |
| 24 | **F2** | Invariant B(ii) ill-defined under `β = β_t|S` where consumed stamp domains exceed `S` — undefined exactly where the joint-basis carrier is exercised (case (c)) | `β_t` **total** over registered units (`defaultStatus` carries `⊥_u`); `S` restricts balances only; admissibility ranges over the stamp's whole domain; **scope-closure condition** stated on `withSnapshot`; `ingest` refuses stamps naming unregistered units (§3, §4, §5, §8c) |
| 25 | **F3** | "Effective order" partial used as total; equal-`t_eff` non-commuting boundaries (the 49-vs-50 pair) leave the composite ambiguous with no surviving tie-break | Effective order made **total**: lexicographic `(t_eff, prec, bid)` with `prec` W4-attested precedence declared in the notice, `bid` deterministic residue; **same-`t_eff` weld** in W4 — undeclared collisions refuse into pending-transition, fail-closed (§1 Def. 2, §2, §7) |

The stylistic objections are absorbed where noted (typed `IngestError`, writer row for the election event, quantifier placement, cash-leg-in-the-proposition, declared-terms-not-taxonomy register, moneyness sentence struck).

**Standing directive compliance:** no pricing or volatility model appears; every operator is declared data applied by one generic evaluator; the split factor and divisor recomputation appear only as illustrations of the generic mechanism; the pricing function is `forall b. Snapshot b -> r` throughout — correctness is about which data it is legal to feed it, never what it does inside.

**Protected elements:** the atomic move primitive, the conservation law, and the immutability of the event log are unchanged in obligation; every addition is an appended event class, a new `StatusWrite` constructor, a new admission condition at the existing single door, a named projection, or a type refinement at the seam. P4 in particular is untouched: the log is never reordered; effective order lives entirely in projection and in the admission predicate.

*"The pairing is the invariant; type both of its factors in the same frame, and the phantom PnL has nowhere to live."* — adopted from NOETHER as the design's epigraph, now with the constructors — and the roles, the total order, the total assignment, and the tip weld — to prove it.

— FORMALIS, re-converged. Zero undischarged material objections.