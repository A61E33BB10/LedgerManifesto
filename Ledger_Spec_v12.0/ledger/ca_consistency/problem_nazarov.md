# NAZAROV — Phase 1 Problem Memo
## Corporate-action consistency of consumed data, from the data-layer side

Boundary held: the observation surface — every point at which a price, fixing, dividend, composition, divisor, or CA notification crosses from the observed world into the event-sourced world. All file references are under `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/`.

---

## 1. The defect restated in data-layer terms

**1.1 An observation's identity is incomplete.** The specification identifies a consumed datum by the pair (source, observation time): `Move` carries `mTime :: Timestamp, mSource :: SourceId` (`reference/Ledger.hs:180-181, 200-201`), a settlement price enters as `SetLastSettle Qty` (`Ledger.hs:304`), a quote is `newtype Quote = Quote Integer -- raw disseminated spot` (`drafts/appD.tex:35`, `Ledger.hs:176`). But the quantity a series *denominates* is itself a function of the underlying's corporate-action state. The true identity of a datum is the quadruple (series, value, t_obs, **basis**), where the basis is the CA state of the underlying at t_obs. The spec stores the first three coordinates and has no term for the fourth. Provenance, as currently specified, names *who* said the number and *when* — it does not name *what state of the world* the number is a statement about.

**1.2 The seam has no shared coordinate.** Positions live in a world with a monotone, per-unit event order: every quantity change passes the single door `applyTx`, and the CA state of a unit is literally a fold over its logged CA events. Observations live in wall-clock time. The two worlds meet at exactly one seam — `f : (unit, state_t(u), market_data) → (moves, state′)` (`drafts/sec07.tex:23`) and `value :: PriceVec -> [WalletId] -> Ledger -> Cash` (`drafts/sec05.tex:44`) — and at that seam nothing constrains `market_data` to be commensurate with `state_t(u)`. The type system that makes an unconserved move unrepresentable (C2) and an off-canon field write a type error (C11, `sec04.tex:415-420`) admits pricing a basis-(n+1) position with a basis-n datum without complaint. The discipline exists on one side of the seam and not the other.

**1.3 Consequence for the data layer's three duties.**
- *Snap-time capture:* a snapshot keyed by timestamp alone is ambiguous whenever a CA is effective inside the (t_snap, t_price] window; the snapshot's contents are silently re-based by an event the snapshot store never hears about.
- *Dispute-ready audit:* replay reproduces the mixed-basis number bit-for-bit (`sec07.tex:46-48` — "a fresh replay reproduces the same moves bit for bit"). Determinism is achieved; validity is not. The audit trail reproduces the error deterministically and cannot *prove* the basis of any input, because the basis was never recorded. A recorded unattested coordinate-less datum is a reproducible category error.
- *Zero-trust ingestion:* the CA notification is itself an upstream observation — and it is the single highest-consequence datum in scope, because it rewrites **both** sides of the seam at once: it emits position moves *and* re-bases every datum on the underlying. It currently enters with no attestation, quorum, or effectiveness-time discipline (`drafts/sec06.tex:99` consumes "dates, ratios, entitlement rules" as given).

**1.4 What the defect is not.** It is not in the event log, not in conservation, not in atomicity. C3 atomicity (`appD.tex:61`) correctly welds the cash leg to the state transition *inside* the ledger. The defect is that the welded state transition has no edge to the data plane: the price store does not participate in the transaction, so the system exits the CA event internally consistent and externally incommensurate.

---

## 2. Numeric reproduction of the failure modes

Arithmetic only. No pricing function appears; each computation is quantity × datum or a quotient of data.

**(a) Stock split, 2-for-1.**
Wallet: 1,000 shares; last snapped spot €100.

| | qty | spot used | mark |
|---|---|---|---|
| t_snap (pre-split) | 1,000 | 100 | €100,000 |
| t_price, log applied, **stale spot** | 2,000 | 100 | **€200,000** |
| t_price, split-adjusted spot | 2,000 | 50 | €100,000 |

Phantom PnL = 200,000 − 100,000 = **+€100,000** from an economically neutral event.

*Split-sensitive references:* a put struck at K = 120 on the same holding. Correct post-split intrinsic: (60 − 50)·2,000 = €20,000 (= pre-split (120 − 100)·1,000). Mixed basis — unadjusted strike, adjusted spot: (120 − 50)·2,000 = **€140,000**, a 7× error. `sec06.tex:116-121` settles the put on raw S_T against K fixed at inception in immutable ProductTerms; no adjustment operator connects them.

*Attribution corruption even when the total is right* (`sec05.tex:101-110`): take the split as a Δw = +1,000 CA move and the corrected spot 50 at t₁. PnL_price = 1,000·(50 − 100) = **−€50,000**; PnL_flow = 1,000·50 = **+€50,000**. Total 0, correct — but a neutral re-denomination reports −€50,000 of "price move" and +€50,000 of "flow." The decomposition subtracts P_{t₁} − P_{t₀} across bases; risk attribution is corrupted even where headline PnL survives.

**(b) Dividend, €2, ex-date in (t_snap, t_price].**
1,000 shares; cum spot 102.

| | mark | cash | total |
|---|---|---|---|
| pre-ex | 1,000·102 = 102,000 | 0 | 102,000 |
| post-ex, correct | 1,000·100 = 100,000 | +2,000 | 102,000 |
| post-ex, **stale cum spot** | 1,000·102 = 102,000 | +2,000 | **104,000** |

Double count = **+€2,000** — the dividend held once as booked cash and once embedded in the mark. Note that `appD.tex:53-56` repairs exactly this case — *iff* the Boolean `mQuoteEx` is observed correctly. The converse error is symmetric: quote already ex at 100 but `mQuoteEx` wrongly `False` → mark 1,000·(100 − 2) = 98,000, total 100,000: **−€2,000** undercount. The load-bearing bit is a bare unattested `Bool` (§3, row appD).

**(c) Index composition.**
Index L = (P_A + P_B)/D; P_A = 100, P_B = 200, D = 2 ⇒ L = 150. A splits 2-for-1 at t_eff: P_A → 50, provider recomputes D′ = (50 + 200)/150 = 5/3 so L is continuous.

| inputs mixed | computation | level | error |
|---|---|---|---|
| coherent (either basis) | (100+200)/2 or (50+200)/(5/3) | 150 | 0 |
| fresh prices, **stale divisor** | (50+200)/2 | **125** | −16.7% |
| stale price, fresh divisor | (100+200)/(5/3) | **180** | +20% |

On a €100M replication book: ±€16.7M / €20M phantom tracking PnL. Weights are worse because they drive *orders*, not marks: w_A = P_A/(P_A+P_B) = 33.3% pre, 20% post. Rebalancing €100M to the stale weight allocates €33.3M to A instead of €20M — a **€13.3M real mis-trade** executed against the market, not a re-markable error.

**(d) Two consumers snapping the same series on opposite sides of the CA** (domain failure mode, required).
Consumer X snaps the daily close at t₁ < t_eff: 100. Consumer Y snaps the same series at t₂ > t_eff: 50. Both observations are individually *correct*.
- Cross-source disagreement check: |100 − 50| / mid = 66.7% divergence → the multi-source quorum falsely fails; the feed is quarantined for honest data.
- Median/mid aggregation of {100, 50} = **75** — a price that exists in *no* basis; committing it is worse than either input.
- Return computed on the series: 50/100 − 1 = **−50%** spurious daily move, propagating into any consumer of returns (limits, realised-variance observations, trigger checks — `triggered_barrier`-class observations fire or fail to fire on it).
- Desk A values its (pre-split-snapped) book 1,000·100 = 100,000; desk B values its (post-split) book 2,000·50 = 100,000. Both correct; any report *differencing their snapped data* manufactures a 50% break. The reconciliation failure the ledger was built to abolish re-enters through the data plane, between two consumers of one source of truth.

**Common structure, stated once:** in (a)–(d) every wrong number is the product or quotient of two individually attested, individually fresh values with unequal bases. No staleness gate, signature check, or source quorum — as currently defined — detects it, because each is keyed by time and source, and the failing coordinate is neither.

---

## 3. Audit: every implicit occurrence of the state-free-data assumption

| Location | Text | How the assumption is embedded |
|---|---|---|
| `sec01.tex:22` | State-Sufficiency: value depends on "the current price vector" | "Current" is read as a timestamp property; it is a basis property. No statement that the vector must be in the positions' basis. |
| `sec01.tex:24` | Lifecycle Value Invariance: "the total value of all wallets under a given price vector is invariant" | The theorem silently requires the *given* price vector to switch basis atomically with the event. The vector is external and unsynchronised (`sec01.tex:76`); for a split with a stale vector the offset claim fails — reproduction (a). |
| `sec01.tex:28` | Time travel: " 'time travel to what was known at t' (market data as captured at t)" | Capture keyed by wall clock. Data captured in [t_eff, t_notify) was "known at t" under a basis later revealed wrong; the known-at/corrected distinction (two axes) omits the basis axis (a third). |
| `sec01.tex:31` | "given the same transactions and market data, the state at any time is uniquely determined" | Market data enters the determinism claim as an unstructured given; uniqueness of the *number* is secured, meaningfulness is not. |
| `sec01.tex:80` | Reference data "consumed from external sources, not created by the ledger" | Corporate-action terms are named as consumed externals with no validity contract at the crossing. |
| `sec04.tex:48-52` | "A benchmark level the ledger records and overwrites is ledger-authored" | An observed external datum is classified ledger-authored because the ledger *stores* it; authorship-of-record is conflated with authorship-of-fact, and the observation's basis is dropped at classification. |
| `sec04.tex:62-64` | Status cell: "lifecycle stage, last settlement price, current weights, benchmark level" | Prices, weights, benchmark levels — observed data — are jammed into the same home as fold-derived lifecycle stage. The 2×2 (`sec04.tex:57-70`) has no cell whose contents are *observed, basis-relative* facts: the fourth-home question, visible in the table itself. |
| `sec04.tex:152-155` | "Externally sourced inputs … enter only as a logged observation event, so the fold stays pure at the boundary" | Purity and replayability secured; the logged observation records value + time, not the CA state under which the value is meaningful. Determinism is mistaken for validity. |
| `sec04.tex:242-246, 254` | `usLastSettle :: Maybe Qty`; `SetLastSettle Qty` | The settlement price enters status as a bare scalar. Contrast `sec04.tex:415-420`: the `FieldWrite` GADT phantom-indexes *writers*; no analogous index exists on any datum. |
| `sec04.tex:643-645` (C8) | Breaking amendment → fresh unit, `superseded_by` | Identifier succession is handled for *positions*; no rule maps a data series from u_old to u_new. Post-supersession the successor is registered with `defaultStatus` (`sec04.tex:565`) — no price, no basis lineage. |
| `sec05.tex:38, 42-44` | `PriceVec = UnitId -> Price`; "The signature has no time and no history" | The central consumption type: total, timeless, basis-less. Totality is advertised as a virtue ("a held unit with no price is unrepresentable") — it equally makes "a unit priced in the wrong basis" unrepresentable *as an error*. |
| `sec05.tex:53-54` | `pnl ws p0 l0 p1 l1` | The type admits p₀ in basis n with l₁ in basis n+1; nothing couples pᵢ to lᵢ. |
| `sec05.tex:57, 83-89` | "Path-dependence cannot enter"; telescoping proof | The proof telescopes V_s terms that are each basis-dependent; with a CA in (t₀,t₁] the interior cancellation assumes every V_s is internally coherent — exactly what mixed-basis inputs violate. The abstract's central claim breaks here, per the defect statement. |
| `sec05.tex:101-110` | PnL_price = Σ w_{t₀}(i)[P_{t₁}(i) − P_{t₀}(i)] | Subtracts prices across bases; reproduction (a), attribution corollary. |
| `sec06.tex:53` | `Contract : (i, s, c) -> [Move]` | Conditions `c` (observables) untyped with respect to `s`. |
| `sec06.tex:99` | Corporate actions: "…while the price reference halves" | Asserted in prose. No ledger object *is* the price reference; no mechanism in PriceVec, UnitStatus, or the CA transaction performs the halving. The one sentence where the spec states the required behaviour has no carrier. |
| `sec06.tex:116-121, 130-141` | Put settles on raw S_T against inception-fixed K; lot size L from the Unit Store | Strike, lot size: split-sensitive reference data with no adjustment operator; reproduction (a), strike corollary. |
| `sec06.tex:153-163` | IRS: `r_float,k` observed at reset | A fixing consumed as a scalar; benign for rates until a benchmark transition (succession event) — same class, no basis. |
| `sec07.tex:23, 46-48` | `f(unit, state_t(u), market_data)`; "Market data enters only inside the Event, as a logged observation" | The seam itself; see §1.2. |
| `sec07.tex:118-122` | "versioned snapshot… 'as known at t' uses the snapshot from t; 'with corrected data' uses the restated snapshot" | The snapshot's only version axis is vendor correction. A snapshot can be uncorrected **and** basis-stale simultaneously; two orthogonal coordinates share one mechanism. |
| `sec07.tex:128-133, 144` | Time-travel items 2 (splits) and 4 (baskets) "must reconstruct each"; clone re-runs reproduce "given the same market data" | Reconstruction of *positions* is carried by unit state; reconstruction of the *data basis prevailing at t* has no carrier — the price store is not keyed by basis, so "the same market data" is same-by-timestamp. |
| `appD.tex:28, 35` | P_t(u) = P(u, state_t(u), market data at t); `Quote = raw disseminated spot` | The right equation, with its third argument untyped. |
| `appD.tex:44-48, 53-56` | `Distribution = Cum \| Ex Cash`; `Market { mQuote, mQuoteEx :: Bool }` | The spec's closest approach to a state tag — and its limits define the defect: (i) one CA class only, additive adjustment `q − d` hardcoded; (ii) one pending event, no composition of multiple CAs in the window; (iii) `mQuoteEx` is an unattested Boolean of unspecified provenance whose flip silently double-counts or double-removes — reproduction (b); (iv) a split is multiplicative, inexpressible as `Ex Cash`; (v) the tag does not propagate through derivation. |
| `appD.tex:82` | "External prices are processed in light of instrument state, never consumed blindly. The distinction between 'primary' and 'derived' market data carries no content here" | The claim generalises past the exhibited mechanism (distributions only; no split, merger, or composition branch), and the second sentence explicitly renounces compositionality — derived data lose whatever basis their inputs had. |
| `appD.tex:84` | Sourcing/snapshotting deferred to "the standalone market-data spec" | The satellite is absent from the bundle; the basis question falls into the gap between a ledger spec that defers and a satellite that does not exist. An undocumented boundary is an open boundary. |
| `sec11.tex:40, 51` | Valuation "loads the snapshots and prices at the endpoints"; stale-data gate defers on insufficient "price quality" | Staleness is defined temporally. A datum one second old is basis-stale if t_eff intervened; a datum a day old can be basis-fresh. The gate tests the wrong coordinate. |
| `sec11.tex:57-64`, `sec19.tex:45` | Corrections as compensating events; correction algebra open | The correction machinery covers *wrong values*. Retroactive re-basing (late CA notice) is *correct values with wrong coordinates* — outside the algebra as drafted. |
| `sec19.tex:18, 48` | Reproducibility "requires version-pinning" of market/reference data; bitemporal semantics open | Pin axis = version; open axis = booking vs economic time. The CA-basis axis appears in neither; the flagged-items register (F1–F8, ME1–ME5, FE1–FE2) does not contain this defect. ME2 (`sec19.tex:106`, the attestation-envelope finding) is adjacent: the basis coordinate is a *further* field the envelope must carry, over and above signature and source. |
| `appC.tex:5, 27` | "stale-data ingestion … remain[s] possible and require[s] operational controls"; "Corporate action mismatches: easier to detect" | The defect is filed as an operational failure outside the architecture. It is structural: it is a missing coordinate in the type of every consumed datum, and it defeats the *detection* claim too — the mismatch is invisible to time-keyed checks. |
| `Ledger.hs:175-176, 180-181, 304, 683, 717-720, 1035, 1077` | `Price`/`Quote` bare `Integer`; provenance = `Timestamp` + `SourceId`; `SetLastSettle Qty`; `PriceVec`; `statePrice`; `Settlement{settlePrice}`; `FTrade … Price` | Every point where a datum crosses into the reference implementation, enumerated: none carries a basis index. The codebase's own exemplar — the `FieldWrite` phantom index and the Single-Coordinate Move Principle — is applied to moves and writers, and to no datum. |

---

## 4. Additional failure modes, stated architecturally

**FM-1. Aggregation across a basis discontinuity.** Multi-source aggregation (the defence-in-depth requirement for any valuation-grade datum) presumes commensurable inputs. Around t_eff, honest sources publish in different bases for a window (exchanges, consolidated tapes, and vendors do not flip atomically). Median/mean of mixed-basis quotes yields a value existing in no basis (reproduction d); disagreement thresholds trip on honest data (false quarantine) or must be widened to the point of admitting real manipulation. Aggregation is undefined until inputs are basis-partitioned — which requires the coordinate the spec lacks.

**FM-2. The CA notification as adversarial input.** A *false* split notification injected upstream causes the ledger to emit doubling moves and (once the defect is fixed) halve the data basis — internally neutral, externally catastrophic: settlement instructions, lot-size projections (`sec06.tex:130-141`), and custodian reconciliation all break against the real world. A *suppressed* notification is failure mode (a) permanently. The CA feed therefore requires the strictest attestation, multi-source quorum, and effectiveness-time discipline of any input class — it currently has none, and unlike a bad price, a bad CA event cannot be repaired by the price-correction path because it has already emitted position moves.

**FM-3. Late notification = retroactive re-basing of the snapshot store.** Notification at t_notify > t_eff means every datum captured in [t_eff, t_notify) was recorded under an asserted basis n that is retroactively n+1. The values are correct; their *coordinate* was wrong. The correction machinery (`sec11.tex:57-64`) appends compensating values; it has no operation "reassign the basis of an existing immutable snapshot." Immutability of the log — protected — forces this to be a new derivation event, but no such event class exists.

**FM-4. Vendor back-adjustment: upstream mutable history.** Vendors republish historical series back-adjusted after a CA, under vendor-specific conventions. Two pulls of "the close at date d," made before and after t_eff, return different numbers with no correction event ever issued. Upstream history mutates while ledger history is immutable; "as known at t" replay (`sec07.tex:120`) is unsatisfiable for adjusted series without content-addressed capture *plus* a basis tag distinguishing which convention the captured value embodies. Cross-vendor aggregation of adjusted-vs-unadjusted history is mixed-basis by construction.

**FM-5. Derived-data basis laundering.** A datum computed from basis-n inputs carries no marker; after one derivation the basis is unrecoverable. `appD.tex:82` declares the primary/derived distinction contentless — precisely backwards for this defect: the rule must be compositional (inputs carry a basis ⇒ the derived datum carries one, with the framework ignorant of the derivation's interior), and the current text renounces the propagation.

**FM-6. Identifier succession without series succession.** C8-Breaking and mergers create u_new with `superseded_by` on u_old (`sec04.tex:643-645`). The position migration is specified; the *data* migration is not: no rule states which series prices u_new at t_eff, what conversion maps u_old's history onto u_new, or how `PriceVec` — total over all units — obtains a price for a unit seconds old. Totality of `PriceVec` guarantees an answer exists; nothing guarantees it is not garbage.

**FM-7. Intra-vector incoherence.** A single valuation run snaps thousands of series over a nonzero wall-clock window. A basket unit and its constituents snapped on opposite sides of a constituent's t_eff make one `PriceVec` internally incommensurate — reproduction (c) inside a single "consistent" snapshot. Snapshot consistency must therefore be defined per-basis-assignment, not per-timestamp; no such definition exists (P8 covers balances and unit state, not the price vector).

**FM-8. The dispute trail proves the wrong thing.** For a disputed margin call or fee computed across a CA boundary, the current record supports: "we can recompute the same number" (`sec07.tex:46-48`). Dispute-readiness requires: raw attested observation + identified adjustment operator + basis assertion referencing the CA event = a first-class derivation record. `appD`'s adjustment `(q − d)` is computed transiently inside valuation and recorded nowhere; the adjusted value has no lineage. Under the standing rule that adjusted data are *derived, never overwrites*, every adjustment must be an appended derivation event — the spec currently has neither the event class nor the obligation.

**FM-9. The validity coordinate is itself an observation.** Whether t_snap precedes t_eff is decided against an *observed* effectiveness time — exchange-calendar-defined, timezone-bound, occasionally amended after announcement. Ordering wall-clock timestamps against a revisable external t_eff makes the basis assignment itself a trust assumption with no owner. Any resolution (open question 1: timestamp vs CA calendar vs monotone per-unit counter vs UnitStatus) must account for the fact that the boundary between bases is external data of the same untrusted class as the data it classifies.

---

*End of memo. Phase 1 — no solutions proposed. Memo path anchors verified against the v12.0 bundle at `/home/renaud/Ledger/Ledger_Spec_v12.0/ledger/` (drafts/sec01, sec04–sec07, sec11, sec19, appC, appD; reference/Ledger.hs).*