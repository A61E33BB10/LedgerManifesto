All sources verified; the design follows.

---

# DESIGN MEMO — The Basis Edge: Corporate-Action Consistency by Construction

**Author:** NOETHER. **Phase:** 2 (independent design, isolation). **Basis:** `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/` at v12.0.

## 0. Position: (iii), a synthesis with its centre of gravity in (ii)

The defect is a missing **referential-integrity edge**, not a missing annotation. Accordingly the design has three parts, none sufficient alone:

- **(ii) The basis is state.** The corporate-action basis of a unit is a fold over CA events already in the log — it satisfies every UnitStatus criterion (u-keyed, ledger-authored, read identically by every holder, rebuilt by replay; sec04.tex:91–94, 135–143) — so it is materialised **in UnitStatus** as a new field, written through the existing single door. No fourth home: a fourth home would duplicate a discipline UnitStatus already owns, violating minimalism.
- **(i) Data carry a reference, not a copy.** Every consumed datum is stamped with the **epoch** of its unit at observation — a foreign key into UnitStatus history, exactly as a `Move` carries `WalletId`s rather than wallets (P3's shape).
- **The seam is typed.** Consumption requires epoch equality, obtained either by observing in the current basis or by applying the ledger-derived adjustment path. Mixed-basis pairing is a compile error, in the style of the Single-Coordinate Move Principle and the C11 `FieldWrite` GADT (sec04.tex:415–419).

This names the hypothesis the existing proofs already require (Phase 1 §6) and enforces it; it repairs no proof and touches no protected primitive.

## 1. Where the basis lives: the per-unit CA epoch, in UnitStatus

**Definition (epoch).** For each unit $u$, the *epoch* $e_t(u) \in \mathbb{N}$ is the number of corporate-action events on $u$ effective at or before $t$, in effective order. $e(u) = 0$ at registration. Each CA event advances the epoch by exactly one and carries its **adjustment operator** as payload.

**Placement.** `UnitStatus` gains one field, `usEpoch`, and the closed `StatusWrite` set (sec04.tex:251–255) gains one constructor, `AdvanceEpoch CAOp`, applied only by `applyStatus` inside `applyTx`. The catamorphism property (sec04.tex:135–143) then covers the basis for free: replay to any $t$ rebuilds $e_t(u)$ exactly, and the operator *sequence* $a_1, \dots, a_{e_t(u)}$ is likewise a projection of the log — the epoch is the length of that fold, the adjusters its content. This gives sec06.tex:99's asserted "price reference halves" its missing carrier and writer.

**Why an epoch, and not the alternatives.**

- *Not a timestamp or CA calendar.* A timestamp identifies **observation**, not validity — that conflation is the defect (Phase 1 §3.13, §3.19). Two CAs effective in one window need an order because the operator monoid is non-abelian (§2 below); a clock reading supplies coincidence, not order. The epoch is a total order by construction.
- *Not UnitStatus-the-value as the tag.* Data must reference state, not embed it; embedding copies a shared observable across thousands of rows free to drift — the exact failure UnitStatus exists to prevent (sec04.tex:91–94). The epoch is the compact key; UnitStatus history is the referenced record.
- *Noetherian shape.* Epochs strictly ascend and every consumption closes a finite gap $m \le n$; every reconciliation of a stale datum terminates in finitely many operator applications. The chain condition holds by construction.

**Succession (C8).** A Breaking amendment or merger is epoch-advancing on the predecessor with operator `Substitute u_new r`; the successor starts at epoch 0. Data keyed by $u_{\mathrm{old}}$ at its final epoch map through `Substitute` into $(u_{\mathrm{new}}, 0)$. This gives `usSupersededBy` its missing data-plane sibling (Phase 1 §4, C8 row): the identifier-succession axis and the basis axis are one mechanism.

## 2. The adjustment mechanism and its composition law

**Definition (operator action).** Each CA event class declares an element of an operator alphabet — generically `Scale k m` (a $k$-for-$m$ quantity change), `Translate d` (a distribution $d$ detaching, cash leg an explicit move), `Substitute u' r` (identity succession at ratio $r$), `Recompose σ` (constituent/divisor substitution on composite data) — together with a declared **action on each datum kind**: price-like data transform contragrediently to quantities, per-share references (strikes, barriers, dividend forecasts) as price-like, share-count data covariantly, compositions by substitution. The framework never inspects a datum's meaning; it applies the declared action. Nothing here is a pricing model: the operators are bookkeeping coordinates, and the pricing function remains an arbitrary black box downstream.

**Composition law.** The adjustment from epoch $m$ to epoch $n$ ($m \le n$) of unit $u$ is
$$A_{m \to n} \;=\; a_n \circ a_{n-1} \circ \cdots \circ a_{m+1},$$
the fold, **in effective order**, of the operators the intervening CA events carry. The monoid is non-abelian, and the order question is *dissolved rather than configured*: effective order is the epoch order, which is the order of the CA events in the log's effective sequence — already canonical, nothing new to choose. Identities: $A_{n\to n} = \mathrm{id}$, $A_{m\to n} = A_{k\to n} \circ A_{m\to k}$ for $m \le k \le n$ (so caching at any intermediate epoch is sound — the derivation is path-independent *given* the total order, which is the point).

*Single illustration (split + dividend, one window).* Snapped spot 102 at epoch $n$; effective order: dividend `Translate 2` ($\to n{+}1$), then split `Scale 2 1` ($\to n{+}2$). $A_{n \to n+2}(102) = (102-2)/2 = 50$. The reverse order gives $102/2 - 2 = 49$. The epoch's total order selects 50; no convention, no configuration.

**Conservation (the theorem this buys back).** A CA event acts on quantities through moves ($q \mapsto \tfrac{k}{m} q$, sec06.tex:99) and on data through $A$ ($p \mapsto \tfrac{m}{k} p$, minus explicit-cash translations). The pairing $\langle q, p \rangle$ is invariant under the joint action; Property 5 (sec01.tex, Lifecycle Value Invariance) becomes a theorem about the *whole* system rather than a claim proved on the position half only. Exactness: quantities are integer minor units, so any non-exact scaling residue (fractional entitlement, cash-in-lieu) is an **explicit move** carried by the CA transaction, never rounding dust — the invariant holds to the minor unit because residues are conserved flows, not arithmetic noise.

**Lazy, raw-authoritative, canonical basis = consumer's epoch (open question 2).** Observations are stored **raw and immutable**, stamped `(unit, t_obs, epoch-at-observation)` — the logged-observation discipline of sec04.tex:153–155, now carrying the one missing coordinate. Adjustment is **lazy at consumption**: a pure, total function $(d@m, A_{m\to n}) \mapsto d@n$, where $n$ is the epoch the consumer's ledger holds. Eager in-place re-basing of the store is rejected: it is a second write path, it destroys replay-to-past-$t$ (Phase 1 §5.2), and it violates the standing directive that adjusted data are derivations, never overwrites. Derived-basis snapshots may be memoised — under exactly the UnitStatus cache discipline: discardable, rebuilt from raw + log without loss.

**Vendor provenance.** A feed pre-adjusted at source declares the epoch it delivers in; the stamp is part of the ingestion contract. Mis-declaration by an external authority is a boundary-reconciliation risk (sec01.tex, out-of-scope authorities), now *detectable* — an unexplained jump at a known epoch edge is distinguishable from a market move for the first time, because the expected $A_{m\to n}$ is a computable prediction. Double adjustment becomes unrepresentable internally (§3): adjusting is typed by epoch pair, and an epoch-$n$ datum admits no second application of $a_n$.

## 3. Type-level enforcement (Hutton-style)

The discipline mirrors C11: the phantom index constrains at the live call site and is erased once the check has happened. Woven exposition, extending the sec05 listing:

```haskell
{-# LANGUAGE DataKinds, GADTs, KindSignatures, TypeOperators #-}

-- The basis coordinate. A price is meaningful only IN a basis: the epoch is in
-- the type. Price still carries NO Monoid (sec.4 dimension discipline); it now
-- also refuses the one wrong PAIRING, not only the one wrong sum.
newtype Price (e :: Nat) = Price Integer
newtype Bal   (e :: Nat) = Bal   Integer   -- a balance read at the unit's epoch e

-- The pairing exists only within one basis. Mixed basis is a TYPE error --
-- the data-plane Single-Coordinate Move Principle.
markValue :: Bal e -> Price e -> Cash
markValue (Bal q) (Price p) = Cash (q * p)

-- CA operators: the payload each corporate-action event carries.
data CAOp = Scale Integer Integer    -- k-for-m: quantities x k/m, prices x m/k
          | Translate Integer        -- distribution d detaches; cash leg is a Move
          | Substitute UnitId Ratio  -- C8 succession, ratio r
          | Recompose Subst          -- constituent/divisor substitution
  deriving (Eq, Show)

-- An adjustment PATH from basis m to basis n. The constructors admit only the
-- identity and one-epoch extensions, so "skip an epoch" and "adjust twice" are
-- untypable; the constructor is UNEXPORTED and the sole author is the ledger's
-- fold over the unit's CA events -- an Adj m n IS a proof that the log carries
-- exactly the operators a_{m+1}..a_n, in effective order.
data Adj (m :: Nat) (n :: Nat) where
  AId   :: Adj n n
  AStep :: Adj m n -> CAOp -> Adj m (n + 1)

adjust :: Adj m n -> Price m -> Price n          -- total; pure; deterministic
adjust AId          p = p
adjust (AStep a op) p = actP op (adjust a p)     -- actP: the declared price action

-- Stored observations are raw, epoch-stamped at ingestion; the epoch is
-- existential because data arrive dynamically:
data Obs = forall m. Obs (SNat m) (Price m)

-- Consumption at the seam: the ledger supplies the current epoch n and derives
-- Adj m n from its own log, or REFUSES. Valuation is fallible exactly where
-- basis can break, and only there.
value :: PriceStore -> [WalletId] -> Ledger -> Either BasisError Cash
```

Three consequences, stated as the section states its predecessors. *A stale price consumed as-is* cannot occur: the only inhabitants of `Price n` are observations stamped $n$ and images under a ledger-authored `Adj m n`. *Double adjustment* cannot be written: `adjust a` consumes a `Price m` and yields a `Price n`; feeding the result back demands an `Adj n k`, and the ledger authors no non-trivial `Adj n n`. This is the data-plane P6 the Phase 1 audit found missing. *The totality bug of `PriceVec` is repaired, not relaxed*: sec05.tex:38's total `UnitId -> Price` obligingly returned stale scalars; the revised `value` is total as a function into `Either`, and "no valid price in the current basis" is at last a representable — hence handleable — outcome.

Derived data compose for free: a derivation $g(d_1@n, \dots, d_k@n)$ type-checks only when all inputs share one index, and its output carries that index. The framework never learns what $g$ does — compositionality is the phantom index propagating through ordinary application.

## 4. The 2-for-1 split, end-to-end

Unit $u$, epoch 7. Wallet holds 1,000 shares. Raw observation ingested at $t_{\mathrm{snap}}$: `Obs 7 (Price 100)`. Snap value: `markValue (Bal 1000 :: Bal 7) (Price 100 :: Price 7)` = €100,000.

**CA event** (one atomic Transaction, C3): `txMoves` doubles every entitled holding through the corporate-action virtual wallet (1,000 → 2,000; conserved, P1); `txStatus = [AdvanceEpoch (Scale 2 1)]` → epoch 8. Log order = effective order; `applyTx` is the single door; nothing else changes.

**Repricing at $t_p$.** Positions read at epoch 8: `Bal 2000 :: Bal 8`. The store holds `Obs 7 (Price 100)`.

- *The wrong number is not constructible.* `markValue (Bal 2000 :: Bal 8) (Price 100 :: Price 7)` — **type error**, index mismatch. €200,000 does not exist in the program.
- *The legal path.* The ledger derives `a :: Adj 7 8 = AStep AId (Scale 2 1)` from its own CA fold; `adjust a (Price 100) = Price 50 :: Price 8`; `markValue (Bal 2000) (Price 50)` = **€100,000**. PnL through the event: 0 — the neutral event is neutral.
- *P10 restored.* Cut a checkpoint at the effective instant $s^*$: segment 1 values at (epoch 7 balances, epoch 7 prices) = 100,000; segment 2 at (epoch 8, epoch 8) = 100,000 plus genuine market movement. Every interior $V_s$ is single-valued because its two factors are forced to share one index; the telescope (sec05.tex:83–89) cancels. The same mechanism prices a strike reference: `Obs 7 (Price 100)` for $K$ adjusts to `Price 50 :: Price 8` against spot 50 — moneyness preserved, no sign flip.

## 5. Time travel: replay reconstructs the basis prevailing at $t$

Replay to $t$ rebuilds `usEpoch` with the rest of UnitStatus — the catamorphism does this with no new mechanism (sec04.tex:135–143). The data side follows from two rules:

1. **Raw store append-only, epoch-stamped.** A stored observation is never overwritten (the derivation directive); the as-known-at-$t$ snapshot (sec07.tex:120) selects raw observations by knowledge time, unchanged.
2. **Adjust to the replayed epoch.** `clone_at(t)` yields $e_t(u)$; consumption derives $A_{m \to e_t(u)}$ from the *same replayed log prefix*. A datum stamped ahead of $e_t(u)$ (vendor already ex, ledger at $t$ still cum) is refused or inverse-adjusted only where the operator is declared invertible; never silently accepted.

Determinism is then restored in effect, not just in letter: same log prefix + same raw snapshot → same numbers, regardless of any later vendor re-basing (which arrives as a new observation version on the bitemporal axis — orthogonal, as sec19.tex:48 already frames restatements). Both halves of Phase 1 §5.2 close: a raw store no longer mixes bases forward, and there is no in-place adjustment to re-base history backward. Sec07.tex:129–135's asymmetry — basis-aware positions, basis-blind "stored market data" — is repaired by making line 135 demand data in $\beta_{t_0}$, which rule 2 supplies.

**Late CA notification** (open question 6, ordering half). A CA event that arrives late is logged at its knowledge time with its effective position in the epoch sequence: epochs are indexed by **effective order**; knowledge time is the bitemporal axis. An "as known at $t$" replay uses only CA events known by $t$; an "as corrected" replay uses the restated sequence. Each is deterministic given its inputs — the sec07.tex:120 snapshot-version discipline, extended from data versions to basis versions. Committed moves made before the late notification are repaired by explicit compensating transactions, never by rewriting the log (immutability protected).

## 6. Failure semantics for late/unknown adjustments (workflow)

The type makes the question poseable (`Left BasisError`); policy answers it by consumer class. The classifier is the Phase 1 finding that conservation launders and monotone carriers ratchet (§5.1, §5.4):

| Consumer class | On basis break | Rationale and workflow |
|---|---|---|
| **Move-emitting** (lifecycle `handle`, margin, fee crystallisation, obligations, settlement projection) | **Block.** `handle` requires a basis witness; without it, no Transaction is proposed. | An emitted move is conserved, replayed, and — through `qmax`/write-once carriers — potentially irreversible. A blocked event queues as a pending obligation under the existing liveness machinery (P21); it fires when the witness arrives. Real money never moves on an unwitnessed basis. |
| **Read-only projections** (indicative reports, dashboards, intraday risk views) | **Flagged-stale.** Value computed in the datum's own basis, output wrapped `Stale u m n` — the flag lives in the result type and propagates through derivations; it cannot be dropped silently. | Business continuity without corruption: the number is labelled as epoch-$m$-consistent, which is a true statement, unlike a mixed number, which is no statement. Flags never enter the log. |
| **Detected gap, unknown operator** (ledger knows the epoch advanced — e.g. via an announcement event — but the operator payload is late) | **Quarantine** the (unit, epoch-pair). All consumption of $u$'s data at the gap blocks/flags per the rows above; the quarantine key is $(u, m, n)$. | Resolution is the arrival of the CA event carrying $a_{m+1..n}$; lazy adjustment then derives and the entry discharges. Termination is Noetherian: epochs only ascend and each gap is closed by finitely many operators — quarantine cannot grow unboundedly per unit. |

The staleness gate of sec14.tex:41 gains the coordinate it was measuring for: the pre-invocation check becomes *epoch equality first, timestamp threshold second*.

## 7. CDM mapping

CDM corporate actions arrive as `BusinessEvent`s composed of primitive instructions (sec13.tex:63, 69–70). The forgetful map $F$ (sec13.tex:105) currently reads only moves; it is extended to read the adjustment content and emit it as the epoch-advance payload — one added projection, the payload still stored verbatim:

| CDM representation | Primitive operators | Ledger CA operator | Quantity side (moves, existing) |
|---|---|---|---|
| Stock split / reverse split / stock dividend | QuantityChange (+ TermsChange) | `Scale k m` | entitlement moves ×k/m via CA virtual wallet (sec06.tex:99) |
| Cash dividend / coupon / return of capital | Transfer | `Translate d` | explicit cash move (already correct) |
| Merger / acquisition / symbol change | TermsChange, before/after TradeState | `Substitute u' r` (∘ `Scale` for the ratio) | C8 Breaking amendment + paired issuance |
| Spin-off | TermsChange + QuantityChange | `Substitute` into $\{u, u_{\mathrm{spin}}\}$ with weights | issuance moves of $u_{\mathrm{spin}}$ |
| Index/basket rebalance, divisor change | Reset / TermsChange on the strategy unit | `Recompose σ` (level-preserving by declared divisor rule) | rebalance moves (C12/strategy-as-unit) |

`forget` thus lands in (moves, `AdvanceEpoch CAOp`) instead of moves alone: `F` remains total, deterministic, and forgetful — the legal detail survives in the payload, and the *one* additional economic fact it now keeps is precisely the fact the ledger was discarding.

## 8. Migration impact on the v12.0 text

The protected core — atomic move, conservation, log immutability — is untouched; every change is a new projection, a new field behind the existing single door, or a restated hypothesis.

| Location | Change |
|---|---|
| sec04.tex:242–246, 251–260 | `UnitStatus` + `usEpoch`; `StatusWrite` + `AdvanceEpoch CAOp`; C5 default epoch 0. The 2×2 (62–63) already lists the cell's contents ("current weights, benchmark level") — the epoch joins them. |
| sec04.tex:614–662 | New condition **C13 (basis edge)**: every consumed datum names (unit, epoch); consumption requires epoch equality or a ledger-authored adjustment path — the data-plane sibling of P3, closing C11's writer table over the new field. |
| sec05.tex:14–18, 38, 44–57 | Definition of portfolio value gains the single-basis hypothesis explicitly; `PriceVec` totality replaced by the epoch-indexed store; `value`/`pnl` return `Either BasisError Cash`. |
| sec05.tex:74–89 (P10) | Theorem restated with hypothesis "every $V_s$ is basis-consistent (C13)"; **proof unchanged** — the hypothesis was always in use, now it is in the statement, and the type discharges it. |
| sec06.tex:99 | "while the price reference halves" gains its carrier: the `AdvanceEpoch` payload on the CA transaction. |
| sec07.tex:120, 129–135 | Snapshot versioning keyed additionally by epoch stamp; time-travel case list requires stored data re-based to $\beta_{t_0}$ (rule 2 of §5). |
| appD.tex:44–57 | `Distribution = Cum | Ex Cash` and `Market.mQuoteEx` re-derived as the two-epoch special case: `Cum`/`Ex` = epochs $n$/$n{+}1$ with `Translate d`; `statePrice` = `adjust` on a one-step path. Kept as pedagogy; the general mechanism replaces it as normative. Reference/Ledger.hs:713–720 likewise subsumed. |
| appB.tex (P8, P10 oracles) | P8 oracle compares `usEpoch` with the rest of unit state (free, it is a UnitStatus field). P10 generator extended to produce basis-mismatched `(store, Ledger)` pairs with oracle "returns `Left`" — the counterexample space Phase 1 §5.9 showed was inexpressible becomes the test. New oracle **P24 (single-basis valuation)**: `value` returns `Right` iff every consumed datum's epoch equals its unit's `usEpoch`. |
| sec13.tex:105, appB CDM tables | `forget` extension of §7; one row per CA class in the mapping table. |
| sec14.tex:41 | Data-quality gate: epoch equality before staleness threshold. |
| sec09, sec10, sec19 | No structural change; benchmark levels, dual-valuation inputs, and QIS compositions are consumed through the same typed seam — the fee/HWM and substantiation exposures of Phase 1 §3.17–18 close as corollaries. |

**Invariants:** none weakened. P10 and P8 gain their honest hypotheses; P5 becomes provable on both factors; C13/P24 and the data-plane P6-analogue (double adjustment untypable) are additions. Every strengthened statement was previously true only under an assumption no text stated.

## 9. Summary

The log already carries the symmetry's action on quantities; this design gives the same action a carrier on data — an epoch in UnitStatus, an operator payload on the CA event, a phantom index at the pairing — and the conservation law (value continuity, path-independent PnL) returns as a theorem instead of a hope. One new UnitStatus field, one new StatusWrite constructor, one new condition, one new oracle: the minimum basis of the seam, and nothing the existing fold does not already know how to rebuild.

*— NOETHER. The pairing is the invariant; type both of its factors in the same frame, and the phantom PnL has nowhere to live.*