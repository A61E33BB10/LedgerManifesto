# FutureLifeCycle — iteration log

## Round 3 (STYLUS, 2026-06-27)

Context: `FutureLifeCycle.hs` re-cleared with the trade-positivity parse boundary (`PosQty` /
`mkPosQty`, `NonPositiveQty`) and the symmetric `Expire`-on-`REGISTERED` rejection (`NotActive`,
settled R3) already implemented. STYLUS reconciled the prose to those settled facts and closed the
two standing prose gaps. Changes by gap:

- **`ΣVM=0` at the trade events (lattner; cartan; formalis — one gap).** The §2 universal —
  "each event shows the three conservation sums" — was falsified at T2 and T3, which showed only
  `ΣΔnet_qty` and `ΣΔac`. Appended `ΣVM = 0 (a trade moves no variation-margin cash)` to T2 and
  `ΣVM = 0 (no cash leg)` to T3, matching T1. All eight events now exhibit the three sums (or the
  vacuous empty sum at Listing).
- **`net_qty` defined before use (cartan).** §1 introduced only `h(w,u)`; `\netq` then appeared in
  every formula undefined. Added one sentence to §1: `net_qty(w,u) := h(w,u)`, the signed quantity
  held.
- **Trade positivity `q>0` (minsky G5).** `.hs` enforces it at the parse boundary; the prose did
  not state it. Added a "Positive quantity" paragraph to §4: `q>0` parsed at the boundary, `q≤0`
  rejected (`NonPositiveQty`) and never recorded; `q=0` would fabricate held-flat rows for two
  never-held wallets, `q<0` would swap buyer/seller; sign comes from the leg, not from `q`. Mirrored
  in `settlement_answer.md` (new "Event legality — boundary rules" section).
- **`Expire`-on-`REGISTERED` symmetry, documented (minsky).** `.hs` rejects it symmetrically with
  settle; the prose left the policy unstated. Stated once in the §11 monotone/absorbing invariant:
  settle and expire act only on an `ACTIVE` unit, both reject `REGISTERED` (`NotActive`), so `EXPIRED`
  is reachable only from `ACTIVE` — the chain `REGISTERED → ACTIVE → EXPIRED` with no skips. §9
  Expiry carries a one-clause pointer to it; `settlement_answer.md` states the same in the new
  legality section. Added labels `sec:close`, `sec:invariants` for the cross-references.

No content sourced or decided by STYLUS: the positivity type and the Expire policy are milewski's,
already in `FutureLifeCycle.hs`; the prose now reflects them. No false positives this round — the two
minsky gaps were live prose gaps even though the code was already correct. `.tex` compiles clean
(pdflatex, 7 pages, no undefined references).

## Round 2 (STYLUS, 2026-06-27)

Context: all eight R1 reviewers returned NOT-YET; `FutureLifeCycle.hs` re-cleared by FORMALIS
(Close added; `Expired` made absorbing; terms/status fused). STYLUS reconciled the prose artifacts
to the now-corrected reference. Changes by gap:

- **Terminus / abstract (gaps 1, 5, 7, 10, 11, 14, 16, 20, 22).** `.hs main` now runs through Close
  to `(0,0,0)/(0,0,0)`, so both abstract claims are simultaneously true. Reworded the abstract: the
  life runs "through the terminal Close", and the document "reproduces them exactly in prose" of a
  reference "whose `main` computes these figures through Close" — no prose-equality claimed beyond
  what the `.hs` computes. Removed the self-flagged "Source divergence --- the Close step"
  escalation (`.tex`).
- **Conservation shown at Close (gaps 6, 8, 12, 15, 17).** Rewrote the cash-settlement paragraph to
  show all three sums with CH legs written out: `ΔnetQ = (−6,+6,0)`, `Δac = (+31500,−31500,0)`,
  CH leg the residual `0`, `Σ ΔnetQ = Σ Δac = Σ VM = 0`. State after Close `(0,0,0)/(0,0,0)`.
- **Day-2 / Expiry symmetry (gaps 4, 13).** Added `Σ Δnet_qty = 0 (no quantity moved)` to the
  day-2 settle and the Expiry settle conservation lines, matching day 1.
- **"Stage" disambiguation (gaps 2, 9).** Stated once per artifact: coarse rank
  `REGISTERED < ACTIVE < EXPIRED` is unchanged at a settle; the embedded settlement mark updates
  every settle; `last_settlement_price/date` are projections of the `Settlement` carried by the
  stage. Applied in `settlement_answer.md` §1 (revised the "lifecycle_stage unchanged" clause) and
  `.tex` (Listing fuse note + settle-mechanism shared bullet + Expiry stage line).
- **CH residual leg (gap 3).** Added one clause in the settlement mechanism: cash legs are emitted
  over holders, CH's leg is the residual that balances them — zero here — so no CH cash row
  materialises. Removed the duplicate CH clause from the day-1 settle (one statement, one place).
- **Absorbing invariant (gaps 19, 23, derived).** The "Monotone, idempotent transitions" invariant
  previously attributed exclusion of post-expiry re-settles to the rank guard. The corrected `.hs`
  makes `EXPIRED` absorbing via an explicit test (rank `2<2` is false, so rank alone is too weak).
  Reworded to "Monotone, absorbing transitions" describing the actual mechanism, with `Close` the
  one stage-write-free event still admissible.

False positives / out of STYLUS scope: gaps 18, 21, 24, 25, 26 are `.hs`-only items (replay through
Close, fused-map exhaustiveness, self-trade diagnostic, pre-trade settle rejection, `report`
net_qty assertion). All are resolved in the current `FutureLifeCycle.hs`; none required prose edits.

`.tex` compiles clean (pdflatex, 7 pages).
