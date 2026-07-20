# GATHERAL — the Market Data side of the backtesting amendment

For THORP + KLEPPMANN. Doctrine: **backtesting is native** — the valuation
doctrine (VM) read at historical coordinates. The MDM adds no backtesting engine;
it grants three data-side guarantees that make that reading exact, gap-free, and
symmetric. All three are **clause extensions of existing MD-n**, not new articles
— the primitives exist; the amendment states what they imply. Numbering is
append-only (MDM §5): a v1.2 extending MD-4, MD-11, MD-13.

The MDM's vocabulary is fixed; it reuses the VM's coined *shift* and *valuation
chain*, and coins **no** "derived world" — a stressed history is a *simulated
path* (MD-11) under a *shift*, nothing new named.

---

## M1 — HISTORY IS REPLAYABLE  →  extend MD-4 (two coordinates / time travel)

*Derives from:* MD-4 (as-of, as-at both recorded), MD-5 (the as-known view
survives), MD-6 (the read-back / re-derive split, complete lineage), MD-12 (a
projection chain reconstructs bit-for-bit; a re-entered observation is a leaf).

*What must be STATED that is not already explicit,* two clauses:
(a) MD-4's *both honest answers at one moment* become a served history when its
two coordinates are **ranged over an interval**; the default read is the
**as-known cut** (as-at pinned to the historical as-of), so **look-ahead is
structurally impossible, not a discipline to remember**. (b) The read-back /
re-derive split (MD-6) carries into the range and fixes *completeness* and
*exactness*: read-back is unconditional (gap-free) — ordinary historical replay;
re-derivation of a model output is available **exactly where the model is
retained** — counterfactual replay, bounded by MD-6, never wider.

*Draft clause (MDM voice):*
> **A served history is the two coordinates ranged over a recorded interval, read
> as-known.** A backtest is the valuation doctrine read at historical coordinates.
> Its default read pins as-at to the historical as-of (MD-4), so each coordinate
> sees only the observations then in force (MD-5) and look-ahead cannot arise.
> Serving is gap-free by read-back: every recorded value is read back at its
> historical coordinate unconditionally (C-14.15), so a replay of the marks then
> struck has no gap. Re-deriving a model output at a historical coordinate,
> rather than reading its stored re-entered observation, is available exactly
> where the model is retained (MD-6); completeness is a property of read-back and
> holds always, re-derivation is bounded and the bound is MD-6's.

## M2 — SHIFT OPERATORS COMPOSE WITH HISTORY  →  extend MD-11 (simulability)

*Derives from:* MD-11 (a simulated path is real market data under a different
seed; the seed is the single non-record input, recorded, so the path replays),
MD-6 (lineage), the VM's *shift*.

*What must be STATED:* a stressed history is a **simulated path branched from a
historical cut**, and the **shift is its seed**. MD-11 grants the machine; the
amendment states the base may be taken from the record and the generator is a
declared shift — so *"what happened"* is the **identity shift** and *"what could
have happened"* any other, one machine at equal effort. *Coordinate discipline:*
its coordinates are the **historical cut + the declared recorded shift**, both
recorded, so it replays bit-for-bit and carries lineage; recording only the shift
(like a path recording only its seed) could not replay (MD-11).

*Draft clause (MDM voice):*
> **A stressed history is a simulated path branched from a historical cut; the
> shift is its seed.** A historical trajectory perturbed by a declared shift (the
> Valuation Manifesto's term — a recorded perturbation of the observation stream)
> is a simulated path under MD-11, real on the same terms. "What happened" is the
> identity shift; "what could have happened" is any other — one machine, equal
> effort. Its coordinates are the historical cut and the declared recorded shift;
> both recorded, it replays bit-for-bit and carries the lineage of the inputs it
> branched from and the shift that moved them.

## M3 — CA OPERATORS APPLY THROUGH THE BACKTEST HORIZON  →  extend MD-13

*Derives from:* MD-13 (corporate action = change of frame; operators compose;
ex-date boundary; delivery-frame discipline; terms-resolved condition).

*What must be STATED:* the operator algebra is **horizon-agnostic**. A backtest is
a fold over the same recorded observations and the same corporate-action events,
so crossing an ex-date inside it fires the market data operator (MD-13) with
nothing relaxed — the ex-date boundary, the delivery-frame discipline (a value
adjusted at source is never re-adjusted), and the terms-resolved condition (the
operator exists only from the resolution observation; before it the frame is
provisional) all hold inside the backtest. One sentence hands the mark-jump
decomposition to the VM.

*Draft clause (MDM voice):*
> **The operator algebra is horizon-agnostic.** A backtest is a fold over the same
> observations and corporate-action events, so an ex-date crossed inside it
> traverses frames through the market data operator (MD-13) with nothing relaxed:
> the frame boundary, the delivery-frame discipline, and the terms-resolved
> condition all hold within the horizon. The valuation sandwich that decomposes
> the ex-date mark jump — value-before in the old frame, operator, value-after in
> the new — fires inside the backtest as in production; the sandwich is the
> Valuation Manifesto's, stated once there.

## The one cross-reference the MDM makes TO the VM  (place in §4 scope)

The MDM grants the **data side**; the **backtest object** lives in the VM. Add one
sentence to §4 ("What This Manifesto Does Not Govern"):
> **The backtest object is the Valuation Manifesto's.** This manifesto grants a
> served history read as-known (M1), stressed histories as first-class simulated
> paths (M2), and corporate-action frames that hold through the horizon (M3). The
> backtest itself — a valuation chain evaluated across a served or stressed
> history, and the certificate comparing the realised world against a
> counterfactual — is a valuation object, governed by the Valuation Manifesto.

Chain-and-comparison is the VM's; the guarantees that make it exact, gap-free, and
symmetric are the MDM's. No duplication either way.

## Recommendation summary

| Mandate | Home | New vs extension |
|---|---|---|
| M1 History is replayable | MD-4 (deriving on MD-5/6/12) | **extension** — 2 clauses (as-known range; split carries in) |
| M2 Shift composes with history | MD-11 | **extension** — 1 clause (stressed history = path branched from a cut; shift = seed) |
| M3 CA operators through horizon | MD-13 | **extension** — 1 clause (horizon-agnostic) + VM pointer |
| Cross-reference to VM | §4 scope | 1 sentence |

All extensions; **no new MD-n**. M1 alone could be argued into a named article
("a served history" as a range-primitive), but MD-4/6 own the point-primitive and
minimalism (§7) forbids a second name; keep it an extension. Estimated MDM cost:
**~1.5–2 pp**, inside the 2 pp grant.
