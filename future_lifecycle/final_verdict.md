# Final Verdict — FutureLifeCycle

## Outcome: PASS at round 3 (the floor)

The committee reached **unanimous CORRECT-AND-COMPLETE at round 3** — the earliest round permitted
by the floor — with no FORMALIS veto and zero open gaps. The three anchor sub-questions are
answered without evasion and conservation is shown at every event.

| Round | result |
|---|---|
| 1 | 0/8 — Haskell cleared; settlement answer accepted; gaps on artifact consistency, two `.hs` bugs, conservation-shown-at-close |
| 2 | 4/8 — karpathy, dirac, jane-street-cto, milewski CORRECT-AND-COMPLETE |
| 3 | **8/8 — unanimous CORRECT-AND-COMPLETE** ← terminate |

Round-3 verdicts: karpathy, chris-lattner, henri-cartan, dirac, jane-street-cto, formalis,
minsky, milewski — all CORRECT-AND-COMPLETE.

## The anchor question, answered

Settlement is a **hybrid event that necessarily touches both layers within one atomic
`StateDelta`** — not a purely shared transition.
1. **It is a state update; shared vs per-wallet split:** the shared part (`UnitStatus[u]`) is the
   single `last_settlement_price`/date update (the coarse rank `REGISTERED → ACTIVE → EXPIRED` is
   unchanged at a settle); the per-position part (`PositionState[w,u]`, one row per holder) is the
   `accumulated_cost` reset and the variation-margin cash leg.
2. **One atomic event that fans out, not a derived consequence:** the cash leg is real daily money
   and is per-wallet, so a fan-out over holders is unavoidable; given that, materialising the `ac`
   reset in the same atomic event is the consistent choice. The naive shared-only formula
   `net_qty·(S−S_prev)·m` is *wrong* for any intraday trader (the worked example's day-2
   `VM = −100`, not `−300`), which is the concrete proof that per-wallet `ac` must be stored.
3. **Price only shared, consequence only per-wallet:** `last_settlement_price` lives only in shared
   state; the `ac` reset and VM cash live only in per-position state and the move stream.

Escalated honestly (not buried): **E1** the daily fan-out is `O(open positions)` writes and cash
legs per contract — a real scale cost intrinsic to per-wallet variation margin; **E2** the
derived-consequence alternative is declined because it saves nothing on the dominant (cash) cost and
cannot produce correct VM for intraday traders.

## Correctness and consistency

FORMALIS cleared the Haskell and returned CORRECT-AND-COMPLETE at round 3: conservation
(`Σ Δnet_qty = Σ Δac = Σ VM = 0`) is discharged at **every** event including the final close; the
committee's two genuine `.hs` bugs were fixed — `Expired` is now terminal (lifecycle idempotency)
and a `SettleVM` on a never-traded unit no longer silently promotes it. The three artifacts agree on
the terminus: `.tex`, `WORKED_EXAMPLE_FUTURE.md`, and `FutureLifeCycle.hs` `main` (and its replay)
all reach `net=(0,0,0)`, `ac=(0,0,0)`. The verified worked example carries through the whole life
with cash tying to economic PnL (A +2100, B −1700, C −400, CH 0).

## Artifacts
- `FutureLifeCycle.tex` / `.pdf` — 7 pp., compiles clean; ligature extraction fixed (0 broken
  remnants); lifecycle in deductive order, conservation shown at every event, worked example carried
  through.
- `FutureLifeCycle.hs` — milewski's incremental Haskell, FORMALIS-cleared; settlement handler the
  centrepiece; Close event and terminal `Expired` included.
- `settlement_answer.md` — the explicit, non-evasive answer to the three sub-questions + E1/E2.
- `rounds/round_01..03/` — 24 independent scorecards; `iteration_log.md`; `SETTLEMENT_SEED.md`,
  `WORKED_EXAMPLE_FUTURE.md`, `R1_FIXES.md`.

`clarifications/` is empty: no specialist consult arose that could not be resolved from §4.1, the
primitives, and the cleared Haskell.

## Addendum — finance-domain review (added round, three new specialists)

After the formal/architecture committee converged, three finance-domain specialists were added and
asked for feedback: **finops-architect**, **banking-auditor**, **isda-board-advisor**. One round was
agreed to suffice absent material concerns.

**Outcome: unanimous `ENDORSE-WITH-NITS` — zero in-scope material concerns.** No fix/second-round pass
was triggered; the brief's "2 iterations unless material concerns" resolved to one round.

What they confirmed from their lenses:
- *finops-architect*: every cash leg conserves; per-wallet `ac` is genuinely load-bearing (the
  day-2 `−100` vs naive `−300` is exact); cumulative VM ties to economic PnL to the penny; **no
  division anywhere**, so no rounding can break conservation; settlement handler is idempotent at a
  fixed mark and correction-safe; `first_touch_date` derived not cached is correct discipline.
- *banking-auditor*: correct settlement-to-market model of variation margin; `ac` reset
  `= −net_qty·S·m` is the right next-period cost basis; conservation shown not asserted at every event.
- *isda-board-advisor*: matches modern CME/LCH settlement-to-market clearing; the intraday case is
  exactly the failure mode real margin systems get wrong, and the model gets it right; cash- vs
  physically-settled split is realistic.

Six in-scope **minor/nit** items (none material) were applied as cheap clarity fixes — all `.hs`
changes were comment-only, so FORMALIS clearance stands:
1. Pinned the shared **Price/Cash minor-unit scale** invariant (the example uses whole points/USD;
   production carries price in scaled minor units so sub-point ticks are exact) — `.hs` §1 + `.tex` §1
   + worked example.
2. Stated the **event de-duplication boundary assumption** and the trade-vs-settle idempotency
   asymmetry (duplicate `SettleVM` inert; duplicate `Trade` not) — `.hs` replay + `.tex` invariants.
3. Pinned the **physical-delivery (DvP) cash leg to the final settle price `S`** so VM is not
   double-counted — `.tex` physical-settlement paragraph.
4. Softened **CH's label** from "central counterparty" to "settlement hub / balancing residual",
   noting that faithful CCP novation (interposing CH on the contract leg) is out of scope — `.tex` §2.
5. Added the **open-book case**: when the firm is not flat (`Σ net_qty ≠ 0`) the CH leg carries the
   firm's nonzero net VM, the boundary figure reconciled against the clearing broker — `.tex` §5.

Logged out-of-scope (no change, boundary correct as stated): initial margin / performance bond is a
separate collateral unit; VM cash-settlement timing (T+0/T+1) is downstream settlement infrastructure;
CDM serialization is honoured at the boundary-mint per the existing Q054 ruling.

After the edits the document recompiles clean to 7 pages with clean text extraction (0 ligature
remnants).

## Scope notes
- Instrument: a **listed future** (exchange-traded); initial *ledger stage* is `REGISTERED` (per the
  corrected terminology), not the stage-name "Listed".
- Expiry covers **both** cash-settled (the worked example) and physically-settled (delivery-versus-
  payment) variants.
- The reviewing group was the eight-member committee with STYLUS authoring prose and milewski the
  FORMALIS-cleared Haskell, **plus** the three-member finance-domain panel (finops-architect /
  banking-auditor / isda-board-advisor) added afterward — see the addendum above.
