# TALEB — Valuation Manifesto 1.0, Review Round 1

**Read as:** desk risk manager AND collateral practitioner, cold, full 7 pages, one sitting. Sibling to the MDM I gated; it inherits the re-entered-observation / projection split, dispute-by-replay, frames, and cut.
**Arithmetic:** I checked the worked chain end to end (base greeks against BS intuition; carry = one-day theta; market-move delta 1.06 / gamma 0.053; +20% shift estimate 15.9 vs reval 14.9, gap ~1.0; breakeven $1.89; the 2:1 split zero-profit via homogeneity). Every number ties out. The example is a genuine strength, not decoration.

---

## 1. Verdict

**One-sitting gate: PASS.** For the risk manager it reads clean end to end; for the collateral practitioner it passes with friction in the quant middle (VM-4, VM-5). The two-layer classification on page one lands as *load-bearing simplicity*, not taxonomy — because the document immediately states the payoff ("it is where a defect is repaired… a wrong leg is a mismarked observation, re-derived with its model; a wrong total is a mis-assembled projection… confuse the two and you repair the wrong thing"). That sentence is what rescues it.

**No material overpromise, and no material hole** — a real strength: the document inherited the MDM's hard-won bounds (read-back vs re-derive, reconstruction vs model-choice) and applies them correctly. **One MATERIAL finding**, and it is the flagship promise's silent dependency, not a headline overreach: *"unexplained P&L is forbidden"* rests entirely on a **declared residual bound** whose correctness is an un-named governance assumption with a silent-failure mode — the same class the MDM named for grain and delivery-frame, here left un-named. Plus a cluster of MINORs that matter mostly for the collateral half of the audience.

**NOT CONVERGED — narrowly.** The material finding is a one-to-two-clause fix; the minor cluster materially improves dual-audience fit. If the risk manager is deemed the sole audience and you accept the collateral reader skimming the quant middle, it is borderline converged. Nothing here reopens the design.

---

## 2. Comprehensibility findings (one-sitting test)

### The two-layer page-one classification — lands as simplicity. (Answer to the density question.)
Both layers are glossed inline with a concrete instance (projection = "owned quantity times price, summed over valued units"; re-entered observation = "model evaluated outside the fold, re-enters through the one door, stale the moment an input moves"), and the both/and is made explicit ("'valuation is a pure function of ledger state' is true of the *recipe*; 'a valuation re-enters as an observation' is true of each *leg*"). It is the densest page, and the both/and is the one spot a reader may re-read once — but the "where a defect is repaired" payoff makes it earn its place. **Not a finding.**

### F-min-1 (MINOR) — jargon the collateral practitioner does not own, unglossed, clustered in VM-4/VM-5.
The risk manager owns all of it; the second named audience does not. Cheapest to fix: **"control variate"** (VM-6 — Monte-Carlo variance-reduction term, used metaphorically for "a well-behaved correction you can trust"); **"ex-ante"** (VM-4 — a two-word gloss, "computed from entry greeks alone, before the move," would carry it). Denser but audience-appropriate to the risk manager, so leave but know the collateral reader skims: **"shadow greek," "spot channel / vol channel"** (VM-5), **"Hessian coverage," "third-order term"** (VM-3). The collateral-relevant *conclusions* of VM-4/5 are accessible; only the mechanism stalls them.

### F-min-2 (MINOR) — the "one-twelfth correction" (VM-4) is an asserted coefficient with no pointer to its source.
"the move times the average of the entry and exit deltas, less a one-twelfth correction for the gamma that moved." A risk manager accepts the trapezoidal/both-endpoint form on sight; a careful reader wonders "why 1/12?" It is a JACOBI-memo result. One clause ("a both-endpoint quadrature correction; see the PnL-calculus memo") stops it reading as a pulled number.

---

## 3. The promise ledger

### Promise 1 — same coordinates ⇒ same valuation bit-for-bit. **Coordinate list is unmissable; one qualifier thin.**
VM-2 lists all five (as-of/as-at position, unit lifecycle state, frame, cut, models) and closes with "A valuation carried without its coordinates is not a weaker valuation — it is not one." Unmissable. **Sized correctly**, because "models" is *in* the coordinate list, so "given the same coordinates" tautologically includes "given the retained model" — the bit-for-bit promise is bounded by construction.
- **F-min-3 (MINOR):** VM-2 says "any party recomputes the identical valuation, to the last minor unit" without reminding, at that spot, that the *models* coordinate is the one needing external retention to re-derive (read-back is always free; re-derivation needs the model). VM-1 and §4 carry the qualifier; VM-2 (the headline) does not. One clause ties it back to the read-back/re-derive split — same fix the MDM adopted.
- **F-min-4 (MINOR):** the list contains **two temporal cuts** — the position's as-at ("recorded at an as-at cut") and the market-data cut ("which observations are in force") — and never says they are *distinct and independently selectable*. That independence is exactly what P&L attribution and VM-10 risk rely on (hold the position cut, move the data cut). Name it once; a reader can otherwise conflate them or miss that "yesterday's book on today's prices" is a legal, distinct query.

### Promise 2 — unexplained P&L is forbidden. **This is where the MATERIAL finding sits.** See F1 below. The reader gets "explained = residual below a declared bound" (VM-6, unmissable) and "what happens on breach" (booked as a named line, chain flagged broken, re-mark — VM-6/VM-7, and demonstrated by the digital). What is *not* nailed is the anti-plug point and the bound's own fallibility.

### Promise 3 — the chain defends any dispute. **Bounded honestly; inherited faithfully.**
VM-8 reproduces the MDM's exact bound ("replay settles whether the mark is the faithful, deterministic consequence… It does not settle a two-sided economic dispute — a counterparty's mark… replays bit for bit too… localises the disagreement"). It even adds *convention* to what replay localises, and extends the exhibit list (chain + certificates) "as further rows of the one replay, never a second replay doctrine." No overpromise.
- **F-min-5 (MINOR, collateral persona):** VM-8 says it defends "a valuation dispute and a collateral dispute alike," then bounds to "the mark." A collateral dispute is often about *haircut, eligibility, netting* — collateral-agreement terms, out of scope — not the mark. Replay settles the **mark inside** a collateral call, not the collateral terms. This is the collateral-persona's version of the MDM MD-14 scope check; one clause carving mark from collateral-terms prevents the over-read.

### Promise 4 — risk needs no second system. **Lands, and honest about cost.**
VM-10 grounds "same recipe on shifted data" in the simulation doctrine + MD-11 + the shift-as-single-non-record-input, and the worked shifted-world column makes it concrete. Crucially it does *not* pretend risk is cheap: full reval re-runs the models (each scenario leg re-enters as an observation), and the greek-vs-reval gap is "a computable, recordable fact… a sound system computes both and records their difference." Correctly sized: no second *code path* (which kills the risk-vs-P&L reconciliation break), not "risk is free."
- **F-min-6 (MINOR):** VM-10 never says out loud the payoff a risk manager most wants to hear — *because it is the same recipe, your risk P&L and your official P&L cannot disagree; the classic risk-vs-books reconciliation break is gone.* It is implicit in the conclusion ("the same fact… marked by two logics, drifting apart"); make it explicit in VM-10 and the belief lands harder.
- **F-min-7 (MINOR):** the document is per-unit throughout; book-level attribution (how per-unit certificates roll up, where cross-unit / correlation P&L lands) rests on VM-6's one "aggregate bound" clause and VM-5's basket-correlation convention. A risk manager consumes the *book* explain daily. The principle is stated; the roll-up mechanics are thin. One bridging sentence would serve.

---

## 4. Fragility / what blows up the book

### F1 (MATERIAL) — the flagship "unexplained P&L is forbidden" rests on a declared residual bound whose correctness is an un-named governance assumption, and the anti-plug point is left implicit.
Two halves of one crux:

- **The residual is the plug.** VM-4 is explicit: "the residual is the balancing term — the value change less every attributed line — the certificate reconciles to the change in net asset value *by construction, not by coincidence*… no split it prints can make it disagree with the fold." So the certificate *always* sums to ΔNAV, explained or not. The document reframes the residual as "a sensor, not a rounding error" (VM-6) — which is the right instinct — but it never states the blunt consequence: **that the certificate reconciles to ΔNAV proves nothing; only the residual within its bound does.** A risk manager owns this trap; a less specialist reader can be fooled by "it reconciles." One sentence closes it, and it is the heart of "what explained means."

- **The bound itself can silently defeat the promise.** "Explained" = residual below a **declared** bound (VM-6). That bound is "a declared term, not a universal constant… recorded in the model configuration." **Nowhere is it flagged that a bound set too loose makes every move 'explained' and hollows the flagship promise silently** — no breach ever fires, "unexplained P&L is forbidden" becomes vacuous, and nothing on the record announces it. This is exactly the registration-correctness-with-silent-failure pattern the parent MDM named for the identifier *grain* (too coarse → silent loss) and the *delivery frame* (mis-registered → silent double-adjust), and treated as material. The Valuation Manifesto's residual bound is the same kind of term and does not get the same honest treatment.
  - **Mitigation the document already has (why this is material-but-bounded, not re-architecture):** the residual is itself a recorded re-entered observation (VM-6), so a lax bound hides the *alarm*, not the *data* — an auditor can still inspect the residuals; and VM-6's "structurally large, sign-biased, or wakes up in stress" language is a partial guard that watches sign/regime, not just level. So it is recoverable, unlike grain's lost observation.
  - **Fix:** name it, in VM-6, the way the parent named grain — the declared bound's adequacy is a governance assumption; a too-loose bound silently makes "explained" vacuous; the guard is the residual's *regime and sign behaviour* (already recorded), not its level alone, and the bound's calibration is itself reviewable. Pair it with the one-sentence anti-plug statement above. Together they make the flagship promise mean what it says.

### Considered, not findings
- **VM-9 "≈0 means exactly three declared tolerances and no more"** (minor-unit rounding once at read; convention rounding; calibration tolerance of any re-derived surface). A confident enumeration; a risk manager might probe for a fourth source (FX rounding on a cross-currency action, surface interpolation beyond calibration). "calibration tolerance of any re-derived surface or curve" is broad enough to absorb the surface case. Left as an observation.
- **One-name discipline is scrupulous** — "valuation chain" (two words) vs the hash-chained log; "shift" not "shift operator"; certificate "extends the taxonomy, does not re-coin." A lesson visibly carried from the MDM lineage. A strength.

---

## 5. What I'd require before this ships

1. **F1** — in VM-6: (a) state that reconciliation to ΔNAV is automatic (the residual is the plug) and therefore *not* evidence of explanation — only the bounded residual is; (b) name the declared bound's adequacy as a governance assumption whose too-loose setting silently hollows "unexplained is forbidden," with the residual's recorded sign/regime behaviour as the guard. This is the one material fix.
2. **F-min-3** — tie VM-2's bit-for-bit line back to the read-back/re-derive split (the *models* coordinate needs retention to re-derive).
3. **F-min-4** — name the two temporal cuts (position as-at vs market-data cut) as distinct and independently selectable.
4. **F-min-5** — in VM-8, carve the *mark* from the *collateral-agreement terms* (haircut/eligibility/netting, out of scope) so the collateral reader does not over-read "defends a collateral dispute."
5. Cheap polish: gloss "control variate" and "ex-ante" (F-min-1); pointer for the "one-twelfth" coefficient (F-min-2); make VM-10's no-risk-vs-P&L-break payoff explicit (F-min-6); one bridging sentence on book-level roll-up (F-min-7).

**Strength worth recording:** this document did not repeat the MDM's round-1 mistakes. It leads with the split, bounds the dispute promise honestly, discloses reval cost rather than pretending risk is free, and the worked chain is arithmetically exact and pedagogically honest (the +20% overestimate and the digital break both teach). The single material finding is a silent *dependency*, not an overreach — and it is the one the desk's own precedent tells me to hunt.

---

# Round 2 — Convergence check (VM rev 2, now 8pp)

Re-read the changed passages cold, both personas, against the printed words.

### F1 (MATERIAL — flagship condition) — **RESOLVED, comprehensively and readably.**
VM-6 now carries both halves I demanded, signposted "Two things the bound must survive," each with a crisp landing:
- **Anti-plug, explicit:** "that the certificate reconciles to the change in net asset value proves *nothing* — the residual is the balancing term, so the parts sum to ΔNAV whether the move is explained or not; only the residual *below its declared bound* certifies. **Reconciliation is automatic; explanation is earned.**" That last line is the memorable one — it lands.
- **Too-loose-bound named with its detection:** "the bound's own adequacy is a governance assumption, named here as the parent named the identifier grain and the delivery frame: a bound set too loose makes every move 'explained,' fires no breach, and empties 'unexplained profit-and-loss is forbidden' in silence. The guard is that the residual is recorded whatever the bound — its sign and regime behaviour, not its level alone, are inspectable — and that the bound's calibration is itself a recorded, reviewable event, so a loosened bound is an auditable change, never a silent one." The silent-failure mode is named, the detection (regime/sign + auditable calibration) is stated, and it is explicitly tied to the parent's precedent.

### Minor cluster — all **RESOLVED, readably.**
- **Two-cuts (VM-2):** now explicit — "The position's as-at cut and the market-data cut are two coordinates, not one, and independently selectable: hold the position at yesterday's as-at and move the market-data cut to today, and you have yesterday's book on today's prices — a distinct, legal query on which profit-and-loss attribution and the shifted worlds of VM-10 both rely."
- **Bit-for-bit qualifier (VM-2):** "Reading a recorded valuation back is unconditional; *re-deriving* it from its inputs needs the retained model — the one coordinate whose retention is external to the record."
- **Mark-vs-collateral-terms carve-out (VM-8):** "A collateral dispute is bounded the same way: replay settles the *mark* inside the call, never the collateral-agreement terms — haircut, eligibility, netting — which are model choice and out of scope."
- **No-risk-vs-books payoff (VM-10):** "because risk and the books run the one recipe, the risk report and the official profit-and-loss cannot disagree by construction: the classic risk-versus-books reconciliation break — two systems, two code paths, two numbers — has no way to arise." The belief-clincher a risk manager wants, now explicit. (VM-10 also tightened that simulated legs enter "the simulated path's *own* record, never as a link in the real unit's valuation chain.")
- **Glosses:** "ex-ante — the reading available *before* the move, computed from the entry greeks alone"; "a control variate — a correction whose smallness can be trusted." Both landed.
- **Book roll-up (VM-6):** "These bounds roll up: the per-unit residuals aggregate to a book-level residual against the aggregate bound, where cross-unit and correlation profit-and-loss — routed under the declared convention — must also come to rest."

### Flagship promise-ledger line, re-run
"Unexplained profit-and-loss is forbidden" now carries its honest condition **unmissably**: explained = residual below a declared bound; reconciliation is automatic and proves nothing (only the bounded residual certifies); and the bound's adequacy is a named governance assumption whose too-loose failure is silent-but-detected (regime/sign inspection + auditable calibration). The promise finally means exactly what it says.

### Fresh stall / overpromise?
The named-assumption paragraph — the flagged density risk — is dense but **navigable, not a stall**: it is signposted (First/Second) and each half ends on a punch ("explanation is earned"; "an auditable change, never a silent one"). No fresh overpromise; every addition narrows the claim rather than widening it.
- **One micro clarity nit (non-blocking):** in the roll-up sentence, "cross-unit and correlation profit-and-loss … must also come to rest" could momentarily read as "correlation P&L is residual (unexplained)." The clause "routed under the declared convention (VM-5)" resolves it (it is *attributed*, then its book-level residual falls under the aggregate bound), but tightening to "are attributed under the declared convention, their book-level residual falling under the aggregate bound" would remove the flicker. Does not gate.

### Verdict
F1 RESOLVED · full minor cluster RESOLVED · flagship condition now unmissable · named-assumption paragraph dense-but-navigable, no fresh stall/overpromise · gate **PASS** · **CONVERGED.** One non-blocking clarity nit recorded ("come to rest") — it would not produce material improvement to hold for it. From my seat, VM 1.0 is ready to ship: a desk risk manager and a collateral practitioner can each read all 8 pages in one sitting, and every promise — coordinates ⇒ bit-for-bit, unexplained-is-forbidden, dispute-by-replay, risk-with-no-second-system — now matches the body, with its honest condition on the page.
