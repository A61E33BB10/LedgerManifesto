# TALEB — Market Data Manifesto 1.0, Review Round 2

**Reading as:** market data operations lead, cold, full 7 pages, one sitting.
**Task:** did each round-1 finding land *as readable* (not just present); does the promise ledger now match the body; any fresh stall or overpromise in the new text.

---

## 1. Verdict

**PASS on the one-sitting gate.** An ops lead can now read all 7 pages in a sitting and come away knowing exactly what is promised and what is demanded. All six round-1 material items are RESOLVED — and resolved *readably*, not just inserted. The glosses land, the headline leads with the split, and the worked example finally teaches with a number.

**One fresh MATERIAL finding + one MINOR**, both a direct by-product of round-2's added honesty about mechanism: the more MD-1 explained *how* "exactly once" works, the more it exposed a conditionality on the flagship promise that it doesn't hold to its own "no silent drop" standard. Not a reopening — a single surgical clause stands between this and converged.

**CONVERGED? NOT YET** — narrowly. Fixing F1 is a material improvement (it closes the last gap between the promise ledger and the body, on the flagship promise). Everything else is done.

---

## 2. Round-1 items — RESOLVED / NOT, verified as readable

| # | Round-1 finding | Status | Where, and does it read |
|---|---|---|---|
| M1 | fold / home / cut / moveless / explain-item undefined | **RESOLVED** | *fold* §1 ("to fold the log is to replay it in order, accumulating state") — textbook-plain; *home* §1 ("its resting place in the record from which the contracts read"); *cut* MD-6 ("the exact as-at boundary that fixes which observations were in force") — glossed exactly where the as-of/as-at query needs it; *moveless* §1 ("because it records data and moves no balances"); *explain item* MD-5 ("a line in the profit-and-loss explain attributing the change to its cause"). All at first use, all plain. |
| M2 | "reconstruction" ambiguous; headline led maximal | **RESOLVED** | Abstract now *leads* with the split and states it crisply: "Reading back any recorded value is unconditional; re-deriving a model's output is what needs the model." MD-6 spells the two senses out. The worst misread in the round-1 draft is gone. |
| M3 | MD-6 "re-enters as stored obs" vs MD-8 "never stored" collision | **RESOLVED** | MD-8 retitled "A broken state cannot hide" (the round-1 overclaim "unrepresentable" is dropped) and now argues *both* cases explicitly: projection stores nothing → drift unrepresentable; re-entered observation *does* store a number → can't drift in place, but *can* go stale, and staleness is a flagged recorded fact. Honest and coherent with MD-5/MD-10. |
| M4 | capture-everything stated unconditional, no capacity boundary | **RESOLVED** | MD-2: "its guarantee runs *from arrival*… a capacity question outside this document (trust assumption TA-ARRIVAL) — but the principle forbids using capacity as a licence to drop silently." Boundary named, spine kept. |
| M5 | doc only spoke of successful derivations | **RESOLVED** | MD-6: "A derivation that *fails* — a fit that does not converge, a solve with too few inputs — is itself a recorded fact, with its inputs and diagnostics… an absent object never passes for one never attempted." Exactly the ask. |
| M6+M8 | no number; as-published vs as-recomputed not demonstrated; no late-arrival walk | **RESOLVED** | §3 now runs AAPL 150.20 → restated 150.50, with execution Tue 16:00 / door Tue 18:30, and the two-query contrast: "as published Tuesday… used 150.20… as recomputed now… uses 150.50. Same as-of date, two as-at cuts, two different surfaces; the cut is the coordinate that selects which." Plus a clean late-arrival bullet (Tuesday-stamped print arriving Thursday → projections refold, fitted surface flagged stale). This now teaches. |

Round-1 minors also all closed: m7 bulk retraction (MD-10 "the explain may summarise them as one named item rather than flood the book"); m9 "derived object" glossed inline in §1; m10 explain-item glossed; m11 MD-11 now states the seed suffices "only because every model output along the path is itself captured as a re-entered observation."

This is a thorough, faithful revision. Nothing was papered over; each fix engages the actual objection.

---

## 3. Promise ledger — does it now match the body?

**Promises (7 of 8 now match the body exactly):**
1. Read-back of any recorded value — observation, projection result, or model output re-entered as an observation — is unconditional, from the record alone. **Matches.**
2. Rebuild of a projection from the record alone is unconditional. **Matches.**
3. Re-derivation of a model output needs the retained model **and numerical environment** (out of scope). **Matches** — and the added "numerical environment" makes bit-for-bit *more* honest, not less.
4. Corrections repair forward; original never overwritten; as-known and as-recomputed both available, selected by cut. **Matches** — demonstrated with numbers.
5. No *silent* divergence: projections can't drift; re-entered observations can't hide staleness. **Matches** — with the honestly-stated caveat that stale fits don't auto-heal (see context note).
6. Failed derivations are recorded facts. **Matches.**
7. Capture runs from arrival; capacity/perimeter is a named residual. **Matches.**
8. **Every market data fact is recorded exactly once, nothing lost. → reads BIGGER than the body delivers.** See F1.

**Demands on the practitioner — all now legible:** record first / classify later; never edit / correct forward; **declare each data kind before its observations cross — fields, operators, and identifier grain**; capture model outputs as re-entered observations or lose read-back; retain model + numerical environment for re-derivation. The new demand (declare the grain) is where the one residual overpromise hides.

---

## 4. Fresh findings in the round-2 text

### F1 (MATERIAL, narrow) — "exactly once / nothing lost" is now revealed to rest on correct identifier-grain registration, and its failure mode is *silent loss* — the one thing the document's own spine forbids.

MD-1 now honestly exposes the mechanism: each arrival carries a **cause-derived identifier**; an arrival identical under it is *absorbed* as a duplicate; the identifier's **grain** — "a registered property of the data kind" — decides redelivery (absorb) vs correction (name) vs genuinely-new-print (record). Then: *"Getting the grain right excludes both failures at once — over-absorbing a real second print, which loses an observation, and double-counting a mere redelivery."*

Two problems the confident phrasing glides over:

- **The failure is silent, and that breaks the document's spine.** Everywhere else, a failure becomes a *visible recorded fact*: MD-2 quarantines the unprocessable, MD-6 records the failed fit, MD-8 flags the stale surface. But a too-coarse grain *over-absorbs a real second print* — the second observation is treated as a duplicate and **never recorded**. There is nothing on the record to flag. This is exactly the silent observation-loss the whole manifesto exists to prevent, and it is the one place the "no silent drop; every failure is a visible fact" principle is quietly not upheld.
- **"Getting the grain right excludes both failures" overpromises that a right grain always exists.** For a feed that delivers two *genuinely distinct* prints identical under every registered field and timestamp, no grain can separate them — the system must either absorb (lose one) or rely on a distinguishing field the feed never sent. Exactly-once is then unachievable regardless of registration, and the sentence implies otherwise.

Why this is material, not scope creep: the disanalogy with model retention (legitimately out of scope) is decisive. Losing a model only weakens *re-derivation* — read-back survives, nothing is lost. A mis-registered grain defeats *capture* — the flagship in-scope guarantee — and does so invisibly. The document holds itself to "no silent loss" as a spine; F1 is the one crack in it.

**Fix (surgical, same spirit as TA-ARRIVAL):** give grain the honest-boundary treatment MD-2 gave capacity. One-to-two clauses: name grain-correctness as a trust assumption; concede that over-coarse grain (and feeds without a distinguishing field) is the residual *silent*-loss case; state where it is caught — perimeter reconciliation of arrival counts against recorded observations, the same perimeter MD-2 already invokes. The ask is not "solve grain" — it is "stop presenting a correct grain as always attainable, and name where the silent case is reconciled."

### F2 (MINOR) — "cause-derived identifier" is the one new term not glossed to the round-2 standard.

fold/home/cut/moveless got clean plain-language glosses; "cause-derived identifier" arrives cold in §1 and MD-1 and is left to be inferred from usage. The three-arrival example (redelivery / correction / new print) teaches the *concept* well, so this is minor — but one clause ("an identifier computed from what caused the arrival, so a redelivery of the same cause collides with it") would bring it up to the bar the rest of the round set. ("Grain" itself is adequately taught by the same example.)

---

## 5. Context notes (considered, not findings)

- **Stale fits don't auto-heal.** MD-8/MD-5/MD-10 are consistent and honest that a corrected input leaves downstream *re-entered observations* flagged stale until re-fit out-of-band — so a live book can knowingly carry flagged-stale marks between a correction and the next re-run. The framework guarantees you *know* they're stale, not that they're fresh; who/when re-derives is model-governance, legitimately out of scope. Correctly disclosed — no action.
- **MD-2's residual sentence is dense** ("What the boundary cannot admit is a named, visible residual; what never reaches the boundary is the perimeter's concern") — two cases in one sentence — but the ops lead is exactly the reader who owns "hit our gateway but we couldn't take it" vs "never arrived." Lands. No action.

---

## 6. What I'd require before converged

1. **F1** — one-to-two clauses in MD-1 giving identifier-grain the TA-ARRIVAL treatment: name it as an assumption, concede the over-coarse case is the residual *silent*-loss mode, and state it is caught by perimeter arrival-count reconciliation. This is the only thing keeping the promise ledger from matching the body on the flagship promise.
2. **F2** (fold in if cheap) — one-clause plain gloss for "cause-derived identifier."

Do F1 and this converges. The document is otherwise ready.

---

# Round 3 — Convergence check (rev 3)

Re-read the two changed passages cold at the ops-lead bar.

### F1 (grain conditionality) — **RESOLVED, readably.**
MD-1 now gives identifier-grain the full TA-ARRIVAL treatment, exactly as required, and in ops-native language:
- **Grain-correctness named as an assumption:** "That the registered grain is correct is a trust assumption, named beside TA-ARRIVAL."
- **Both failure modes stated, and the asymmetry made explicit:** "A grain too *fine* records a mere redelivery twice and double-counts; a grain too *coarse* absorbs a genuine second print and loses it… The double-count is loud… but the over-coarse loss is *silent*." The r2 sharper edge is conceded head-on: "where a feed delivers two distinct prints identical under every field it sends, no grain can separate them. This is the one residual case of silent loss, and the manifesto does not pretend a grain always exists to prevent it." The overpromise ("getting the grain right excludes both failures") is gone.
- **Residual routed to the perimeter:** "caught where TA-ARRIVAL's gaps are caught --- at the perimeter, by reconciling arrival counts against recorded observations." Sound: raw arrivals are counted before dedup, so two-identical-prints shows as 2≠1 and the on-record silence becomes a visible perimeter discrepancy.
- **Bonus, in-spirit:** the routine absorb path is now shown to leave a trace — "Absorption is not a silent drop… the fact of the redelivery… is retained, so a healthy absorb is distinguishable from a feed that has gone quiet." This restores the document's "no silent drop" spine everywhere except the one named, conceded residual.

This passage is now, if anything, the most ops-lead-native in the document — dedup grain and arrival-count reconciliation are their daily bread. No new jargon, no stall.

### F2 ("cause-derived identifier" gloss) — **RESOLVED, readably.**
§1: "the grain of the cause-derived identifier --- an identifier computed from what caused an arrival, so a redelivery of the same cause collides with it." Glossed at first use, in plain words, to the bar the rest of the round set.

### Promise ledger — line 8 now matches the body.
"Recorded exactly once, nothing lost" is now explicitly bounded ("*Subject to that*, nothing about market data is written twice…"): the one silent-loss path is named, conceded, and reconciled at the perimeter, not hidden. All **8 of 8** promises now match what the body delivers. No fresh overpromise introduced by the rev-3 text — it is self-limiting throughout.

### Verdict
F1 RESOLVED · F2 RESOLVED · gate **PASS** · **CONVERGED.** From my seat, the document is ready to ship: a market data ops lead can read all 7 pages in one sitting, and the promise ledger matches the body line for line, including the flagship "exactly once."
