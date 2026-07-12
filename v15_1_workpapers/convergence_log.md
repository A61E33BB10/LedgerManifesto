# v15.1 Convergence Log

Per-package PARETO record. Each critique: {claim attacked · counterexample or named missing case ·
severity}. A critique with neither is discarded before voting. Bench A votes valid/invalid with reason;
invalid critiques are ANSWERED here (not ignored). Min 3 rounds of adversarial iteration, max 7; early
stop when ≥75% of a round's critiques are voted invalid by ≥75% of Bench A. Escalation forbidden —
residue parks.

Compaction note: in this run the PARETO rounds are realised as author-draft → independent adversary
panel (named Bench B critics) → author vote+repair → independent certifier verification, iterated until
the certifiers sign. Every valid critique repaired; every invalid critique answered below.

---

## Phase 1
### F11 — DRAFTED (author KARPATHY, opus)
Pure addressing overlay: 110 normative clauses labelled C-<sec>.<n> in `constitution_v1_2_proposed.tex`
(PROPOSED banner + running header; no v1.1 prose changed; 3 parked deltas folded at C-4.10/C-8.7/C-12.1).
`discharge_matrix.md` maps all 110 clauses → discharging chapter or NAMED GAP. Each of 17 chapter openers'
unfalsifiable "discharges §N" line replaced by a precise clause-ID list consistent with the matrix.
Builds: spec exit 0 / 73pp; proposal exit 0 / 11pp. No chapter \inputs or cites the proposal (grep-verified).
Named gap surfaced: C-6.6 (managed-account fee accrual & NAV attribution) — for CONCORDIA at phase close.
Adversary panel + CONCORDIA G2/G7 certification: PENDING (runs at Phase-1 close over whole doc).
### F2 — DRAFTED (author KLEPPMANN, opus)
ch02: new §"Two axes of time"; typed `project :: LogPrefix -> KnowledgeHorizon -> View`; concrete back-dated
example (IDX day-2 close arriving day-4 at valid-index k=2) first; "Not event sourcing" hand-wave rewritten
to honest append-on-transaction-axis account; existing box untouched. Thm 14.4 restated over pair (p,h) with
proof of (a) as-known-at permanence + (b) as-of bit-exact recompute; distinguished from Thm 14.5 log-order
fold (both deterministic, different sequence). ch05§5/ch06/ch08§8: k named as valid-time coord vs
transaction-time position; W2 machinery made explicit. ch15§4: BITEMP-1 (as-known-at monotonicity), BITEMP-2
(as-of determinism); genBackDated inserts at k<end; checkCoverage gate asserts ≥1% firing (zero firings ⇒
failed run). Const untouched; PARK-2 cited in ch02/08/14/15; no chapter cites the proposal (grep-clean).
Build exit 0, 76pp, boxes=4, openers preserved.
RESIDUALS for certifiers: (R2) pre-existing ch06/ch15 "log total order IS index k" wording now in latent
tension with valid/transaction split — reconciled by cross-ref, not unified → CONCORDIA/JACOBI to judge.
(R4) ≥1% firing is a stated checkCoverage GATE, not an observed run (no in-repo impl) → TALEB G4 to weigh.
(R3) ch17 "parking index empty" still false — F12's job (Phase 3).
Adversary panel + certification (CONCORDIA, TALEB G4): PENDING (Phase-1 close).
### F10 — DRAFTED (author NOETHER, opus)
ch03§7: balance restated as primitive signed vector indexed by (coordinate, agreement), bal_{c,G}(w,u);
concrete failure first (W posts 100/G1, receives 100/G2 → +100,-100 distinct coords, neither vanishes);
3-vector bal_c = Σ_G bal_{c,G} derived as aggregate projection (many-to-one, strictly weaker). ch09§1/§2:
Placement.AgreementRef identified with G ("not new machinery, now lifted into the coordinate"); coverage
bound Σ_G bal_{posted,G} ≤ max(bal_owned,0), "coverage nets, encumbrance does not." Thm 14.1 retitled
"Conservation per (unit,coordinate,agreement)", Σ_w bal_{c,G}=0 proved by induction; old 3-vector law shown
as sum-over-agreements image (preserved but strictly weaker); box preserved, opener Fix(u,c)→Fix(u,c,G).
ch12: encumbrance = Σ_G max(bal_{posted,G},0) (gross), G1/G2 case worked, "encumbrance sums gross,
availability nets — never one figure." ch15§3: prop_conservation (agreement grain) + prop_encumbranceGross +
genCrossAgreement branch + checkCoverage ≥1% firing. HONEST MECHANISM: on the netting history conservation
holds at BOTH grains (within-wallet aggregation, not cross-wallet imbalance) — the property that CATCHES the
collapse is prop_encumbranceGross, not conservation; stated plainly, not overclaimed. Const untouched; PARK-3
cited ch03§7/ch14§1; no proposal cite. F2 + F11 openers intact. Build exit 0, 79pp, boxes=4.
RESIDUALS: (R1/carried) ch17§3 "parking index empty" false — FIXED at Phase-1 close (PARK-1 deliverable).
(R2) "per (unit,coordinate)" phrasing kept in ch09/ch12 owned-move episodes where grains provably coincide
(owned=null agreement) — true not wrong; CARTAN to judge if uniform naming wanted. (R3) ch14 coverage invariant
(inv:coverage + table) used bare `posted_G`/`owned` — CONCORDIA confirmed NO ch09 bridge existed (my
earlier note was wrong). FIXED: ch14:330 and :370 now `bal_{posted,G}`/`bal_{owned}`, unified with
ch09/ch12 and Thm 14.1. Notation now single-symbol across the doc; no bridge needed.
Adversary panel + certification (CONCORDIA, CARTAN): PENDING (Phase-1 close).

### F11/F2/F10 — CONCORDIA Phase-1 gate: VETO → 3 repairs applied
CONCORDIA whole-doc read (79pp) returned VETO with 3 surgical, evidence-bearing defects (2 of which the
phase's own instruments falsely claimed resolved) + 2 recorded obligations. Repairs applied verbatim:
1. F11/G2: discharge_matrix.md over-credited ch12 with DISCHARGING C-1.5 while ch12 opener says "building
   on C-1.5" (build-on ≠ discharge). FIXED: matrix C-1.5 → ch01 only; removed from multi-discharge summary.
   "openers = matrix exactly" now true. (C-2.1/C-2.2 ch01+ch12 were already consistent — opener says
   "discharges … jointly with ch01".)
2. F2/R2: ch15:194 said log "total order IS index k" (transaction=valid conflation, self-undermining) while
   ch06 was already reconciled. FIXED: ch15:194 now mirrors ch06 (fold order = valid-time index k, distinct
   from transaction-time/arrival position; cross-refs sec:bitemporal).
3. F10/R3: see above.
RECORDED OBLIGATIONS (block final freeze, not Phase-2 start):
- OBL-A (F12, Phase 3): ch07 Prop 7.3 currently IS the narrow-and-relabel archetype ("financing basis, not
  a deposit"), does NOT cite PARK-4, states no conflict — while ch17:159-162 + parking_index:81 claim it is
  openly parked. F12 must land ch07 open-conflict statement + PARK-4 cite before freeze; CONCORDIA final veto
  fires otherwise.
- OBL-B (C-6.6): CONCORDIA RULING = (a) work it in v15.1 OR relocate to a NAMED Exclusions-Register companion
  (E71–E74 neighbourhood) pointing to where it is worked (managed_account_workflow/ dir may host it). NOT a
  park (category error — constitution is satisfied, delegates to spec), NOT a bare §17.3 line (leaves spec
  knowingly non-conformant with C-6.6). Schedule in Phase 4 (or earlier if convenient).
CONCORDIA confirmed clean: manifesto byte-untouched (git), one-way authority never turned, proposal banner +
cited-by-nothing (grep), 3 parked-clause quotes verbatim-match manifesto, F2/F10 conflicts stated openly,
110-clause count reconciles, 79pp≤100, 4 boxes≤4, clean build no undefined refs.

## Phase 2 — F1, F3, F6, F4 (SEQUENTIAL — collision cycle F1↔F6 ch05, F6↔F3 ch06, F3↔F4 ch09, F4↔F1 ch14)
### F1 — DRAFTED (author NOETHER, opus) — restores Const §7 (no park)
§3.8: corporate-action out-edge on each node of every unit whose terms reference another (self-loop live→live,
appends new ProductTerms version); typed `adjust :: CorpAction -> Live -> Live`. §8 new sec:term-operator:
term-adjustment operator, sibling of market-data op, `termOp :: EventKind -> TermKind -> (Term->Term)`, §8.1
totality (every (term-kind,event-kind) pair declared; undeclared refused). Dim table: barrier/strike Price ×½,
multiplier Quantity ×2 DOUBLES, participation Proportional identity, fixed payout "declared absolute" identity;
"a multiplier is a term, not mass" sentence present; scoped pre-existing wall stmts to "market-data operator".
§8.6 witness extended to derivatives (payoff-on-terms); OT-1/OMEGA worked: 80.00→40.00, payout 1M unchanged,
47.50>40.00 no knock (phantom refused). ch14 Inv 14.3 third reading catalogued. ch15 prop_termAdjustmentInvariance
+ genDerivWithCA (split in live window, close in 40–80 gap = phantom witness) + checkCoverage ≥1%. VS-1/FUT-IDX:
declared IDENTITY (constituent split moves divisor not level) — declared per totality, not silent. Box=4, 83pp,
Phase-1 (openers, Thms 14.1/14.4/14.5, bitemp/conservation props) intact.
RESIDUALS for certifiers: (a) C-7.5 restoration cited in prose "§7" only, not in ch03/ch06 opener clause list —
JACOBI/CONCORDIA to confirm whether opener should reflect it. (b) "on each lifecycle node" rule stated but only
`live` self-loop illustrated; terminal-node identity-on-terms implied not explicit. (c) property specified not run
(same status as sibling props). Certifiers JACOBI/ASHWORTH/TALEB/CONCORDIA: PENDING (Phase-2 close).
### F3 — DRAFTED (author KLEPPMANN, opus) — Const §6 applied (no park)
ch11§11.3: settlement-obligation unit derived from §5.6 (instructed-but-unsettled = DvP obligation = unit);
lifecycle node instructed/settled/failed lives in its UnitStatus (no fourth home; sufficiency holds).
`data SettlementObligation` replaces deleted `data SettlementState` AND `data MarketClaim`. One product graph,
three walks: instructed→settled (spine), instructed→failed (fails cascade §9.3 = SAME unit later node),
market-claim leg raised at instructed on record-date-in-gap. ch09§9.3: exact "it IS the settlement-obligation
unit... not a fresh unit minted symmetric" sentence. ch06: UnitStatus para names instructed/settled/failed.
Prop 11.1 reads unit's recorded lifecycle node (no dangling ref; grep SettlementState = none). ch17§3 open-
problems: removed the fails-cascade-obligation line (now worked in body); PARK-1..4 bullets + non-empty
sentence UNTOUCHED (verified). ch15: genSettlementHistory + prop_settlementFail_fires (cover 1.0
reachesFailedNode, ≥1%). Build exit 0, 84pp, box=4.
RESIDUAL (honest, discharged): fails obligation = same INSTANCE walked to failed; market claim = same
graph/CLASS, distinct instance MC-1 (own coordinate, discharges at payment date). "one graph, three walks"
framing avoids claiming one instance carries DvP shares + dividend cash simultaneously (would break worked
example: ACME DvP settles 2026-05-16, MC-1 discharges 2026-05-22). Required "same unit at different node"
sentence satisfied exactly for the fails case (where §9.3 asserts it). Certifiers CONCORDIA/ASHWORTH/
MATTHIAS-β: PENDING (Phase-2 close).
### F6 — DRAFTED (author KARPATHY, opus) — no park
BENCH-A DECISION: (i) primitive, (ii) folded inside. §6.1: `PosFacts = Map Txid PosFact` (event-keyed by
cause-derived id of Ch4); `PosFact = Owed Money | SettledValue Integer`; retirement = entry leaves when its
obligation discharges. (a) two dividends in flight → two `Owed` under distinct ids, each retires alone
(concrete: 06-02/pay06-23 $15k, 06-09/pay06-30 $12k). (b) multi-lot futures → single `SettledValue`=Σqᵢlevelᵢ,
VM=settle×Q−stored (worked: new lot 992 → S=19,920,Q=2 → −120). Defence: two dividends can't sum (each
discharges own date, must retire alone → key per firing); futures lots discharge vs same print → summable →
one entry. ch15: prop_twoEntitlementsRetireIndependently + genTwoDividends (r₁<r₂<p₁<p₂) + cover 1.0 ≥1%;
fails on any one-slot design. Build exit 0, 86pp, box=4. Phase-1/F1/F3 intact; no settlement state in PosFacts.
RESIDUALS for CONCORDIA: (a) `SettledValue` naming sits near F3's settlement-obligation vocab — confirm no
mis-read (alt `MarkedValue` if contested). (b) §6.2 "applied level"/§6.4 single-dividend "entitlement" left
unedited (surgical); read as single-instance cases of §6.1 collection, not contradictions — tighten if wanted.
Certifiers CONCORDIA/ASHWORTH: PENDING (Phase-2 close).
### F4 — DRAFTED (author NOETHER, opus) — no park
Canonical Inv 14.6 (inv:coverage) now states received-negative explicitly: posted-out +, received-in − (poster
+Q, taker −Q). Σ_G bal_{posted,G} ≤ max(bal_owned,0). Worked once: received100(−100)/re-post60(+60)=−40 within
bound; re-post200(+200)=+100>0 refused. §9.2 no longer displays the inequality — \ref-s inv:coverage (F14
de-dup); §9.4 taker=−Q agrees. Grep: "coverage 40"/"received ray positive" = 0 hits; received-negative stated
in ch09/ch14/ch15; the one remaining "positive sign" (ch14:348) is correct (posted-out). ch15
prop_coverageSignConvention + genOverRepost (owned0/recv100/repost200 by construction) + cover 1.0 ≥1%; named
test "owned 0, received 100, re-post 200 -> net +100, refused". Build exit 0, 86pp, box=4.
RESIDUAL: §14.6 refs ch:collateral at chapter level (Pledge subsection has no \label) — resolves fine; add
\label{sec:pledge} later if finer anchor wanted. Certifiers CONCORDIA/JACOBI/CARTAN: PENDING (Phase-2 close).
## Phase 3 — F9, F5, F8, F12, F7
Collision map: ch07 shared by F9/F5/F12 (serialize F9→F5→F12); ch15 shared by F9/F7 (F7 after F9); F8
(ch08/11/16) DISJOINT (fully parallel). Schedule: Wave1 = F9 ∥ F8; Wave2 (after F9) = F5 ∥ F7; Wave3 (after
F5) = F12. OBL-A: F12 must reconcile ch07 Prop 7.3 (open-conflict + PARK-4 cite) — the only outstanding narrowing.
### F9 — DRAFTED (author NOETHER, opus) — no park
§7.3 episode: STM future prices 0 after day's VM (exposure extinguished, VM already owned; FUT-IDX double-count
shown first); CTM future marks last settled level (return obligation is a unit). Model: `price u s | isFuture,stm
= 0 | isFuture,ctm = markAt(lastSettled s)`. Def 7.1: valued unit may price 0 (extinguished) ⇒ contribution
DEFINED — closes the "undefined NAV" gap. §7.3 note: regime bit carries 2nd (valuation) consequence beyond
balance sheet, SHARPENS §9.5 (not duplicate). NoDoubleCount generalised (TLA + executable): ∀u extinguished(u,s)
⇒ price=0; extinguished = triggered OR (STM future ∧ vmApplied); CTM never extinguished. prop_noDoubleCount +
genMixedHistory + checkCoverage 3 labels (OT-1 triggered / STM VM applied / CTM marked) each ≥1%. Labels added
sec:pnl/sec:pricing-state/sec:cashmargin (ch09 label only, no prose). Build exit 0, 87pp, box=4; Phases1-2 +
OT-1 NoDoubleCount preserved (generalised in place).
RESIDUALS for CONCORDIA/JACOBI: (1) P reads regime (a term) + σ; Def 7.1 P(u,σ(u)) should state it closes over
declared terms too (implicit now). (2) CTM short-leg sign inherited from ±1 coords, not re-derived — check CTM
NAV nets 0 across legs before obligation accrual. (3) `extinguished` is an extensible predicate, not a
construction-level guarantee — a new extinguishing event (cash-settled American exercise) could silently
under-quantify NoDoubleCount; "check can be forgotten" surface → CONCORDIA may park/escalate or accept.
Certifiers CONCORDIA/JACOBI/ASHWORTH: PENDING (Phase-3 close).
### F8 — DRAFTED (author CARTAN-attack, opus) — no park (new trust assumption, not constitutional)
Prop 11.1 now total over 4 quadrants (cum/ex × settled/unsettled): (i) cum-unsettled→claim deliverer→buyer,
(ii) cum-settled no leg, (iii) ex-unsettled no leg, (iv) EX-SETTLED (the missing one)→MIRROR market-claim at
settled node, signs reversed, wrongly-paid buyer→entitled seller. Built on F3's market-claim leg (no new type):
"one mechanism reflected across the settlement node". ch08: ex-date/record-date/settlement-cycle coherence is
EXTERNAL convention not on record; breaks lawfully under due-bills special dividend (ex-date after payment date);
F1 term-op untouched. §16.3 TA-EXDATE full 4-field (owner=CA-calendar governance; violation=ex settles before
record date, lawful under due-bills; detection=routing raises mirror leg + boundary reconciliation; residual=
external convention, misroutes faithfully to record). ch15: genSettlementHistory branch 4 + prop_mirrorClaim_fires
cover 1.0 ≥1%. Build exit 0, 90pp, box=4.
RESIDUALS for ASHWORTH/CONCORDIA: (1) NODE-RETIREMENT TENSION — F3 said unit retires at `settled`; mirror claim
raised AT settled node ⇒ unit not yet at zero vector. F8 qualified F3 comment ("retires unless record date
straddles settled node"). Confirm retirement invariant (retire only from zero vector) not contradicted — sharpest
edge. (2) mirror described as leg-on-unit, no numbered ex-settled micro-example (cum MC-1 has one); parity optional.
(3) raisesMirrorClaim named not defined (chapter style). Certifiers CARTAN/ASHWORTH/LEX MANDATUM: PENDING (P3 close).
### F5 — DRAFTED (author KARPATHY, opus) — no park
§7.2 Principle reworded: "no derived figure a projection could recompute — no second copy of realised PnL, no
running valuation — is maintained" (was "no book cost"). Explanatory para draws ch06's line verbatim-in-substance
(cited to ch06): book cost = fact a contract must read (995.00 traded price, PositionState, T1) → held; realised
PnL = view → recomputed. §3.1 needs no edit (now consistent). F9 §7.3/labels intact. Build exit 0, 90pp, box=4.
Certifier CONCORDIA: PENDING (P3 close).
### F7 — DRAFTED (author KLEPPMANN, opus) — no park (discharge-matrix §5 thinness note)
§4.3: idempotence keyed on txid NOT causeEventId; normative txid=H(causeEventId,contractId,unitId,seq); concrete
ACME cascade first. Proofs: constant-under-retry (all 4 components read from record → same txid → commit once);
injective-over-cascade (fix cause; legs differ in unitId or seq; H injective on tuple domain [assumption stated] →
n distinct txids → all n commit). §13.5 lineage now true (shared causeEventId=lineage, distinct txids=each once).
ch15 prop_cascadeIdempotence (Set==cascadeTxids AND length==n; genCascade m≥2 legs delivered twice reordered;
cover 1.0 ≥1%). discharge_matrix §5 note appended (NOTE not park — rule is cause-derived, sharpens §5 within its
words). F6 Txid key consistent. Build exit 0, 92pp, box=4; Phases1-3 intact.
RESIDUALS for CONCORDIA/MATTHIAS-β/TALEB: (1) SHARPEST — `seq` provenance asserted "pure fn of record (Ch5)" but
Ch5 doesn't pin seq derivation; same-unit multi-leg REORDER could permute seq → break constant-under-retry.
Distinct-unit cascades moot (unitId carries injectivity) + that's what generator exercises. CONCORDIA: pin seq in
Ch5 OR note seq record-order-free by construction (may reopen F7 or 1-line Ch5 add). (2) H injectivity vs
collision-resistance conflated — FORMALIS/MATTHIAS-β may want "no collision over admitted tuple set" not global
injectivity (proof only needs former). (3) generator witnesses distinct-unitId not same-unit-distinct-seq;
TALEB may want 2nd sub-branch ≥1%. Certifiers: PENDING (P3 close).
### F12 — DRAFTED (author KARPATHY, opus) — PARK-4 (the run's signature repair; OBL-A CLOSED)
Prop 7.3 rewritten to state §8 conflict OPENLY, not relabel: "§8 asserts deposit-neutrality unconditionally...
theorem in one case and false in another... genuine conflict, parked openly rather than defined away." Concrete:
receive USD100 vs obligation fair value USD98 → NAV rises +2 at receipt; "that USD2 is a financing basis, the
correct measurement, but naming it does not make the inflow neutral... narrowed to fair-value financing... parked
— not resolved, not relabelled — as PARK-4 (Ch17)." Relabel phrase "financing basis, not a deposit" GONE (grep
none). ALSO fixed 2 adjacent re-papering sentences: fair-rate para now conditional ("In the fair-rate case...");
closing line "A fair-value deposit cannot move PnL... Off-market financing is the one case that can, and that is
the parked conflict above" (was unconditional §8 re-assertion). Fair-rate theorem preserved+correct. ch17:159
"Stated openly at ch07" now TRUE (was false). Const byte-untouched; ch07 cites PARK-4 (parking index), NOT the
proposal. F9/F5/Def7.1 intact. Build exit 0, 92pp, box=4. Certifiers CONCORDIA(mandatory)/LEX MANDATUM(G3):
PENDING (P3 close). This is the archetype the whole run screens for — now OPEN, not dissolved.
### CONCORDIA Phase-3 gate: VETO (1) → repaired → CERTIFIED. VETO-2 = ch07:197 3rd silent §8 re-assertion
("could leak profit, and does not, for a stated reason" vs ch07:245). FIXED verbatim → "whether it does turns
on the declared financing rate, as the next proposition shows." Build exit 0, 92pp, box 4. OBL-A DISCHARGED.
All other P3 residuals ruled KEEP/DEFER (F8 retirement CONSISTENT; F7 seq/H KEEP; F9 a/b KEEP, c DEFER-P4 note).
Confirmatory signature at P4 gate.

## Phase 4 — F16, C6 sweep, F13, F14, F15 (+ deferred polish)
Collision plan: Wave A ∥ = F13(ch02) · F16(ch15) · OBL-B(ch17+matrix). Wave B = F15(ch01,ch02, after F13).
Wave C = F14 (cross-cutting: ch02/04/05/07/09/12/14/15 — run ALONE). Wave D = C6 sweep (TALEB audit all firing
props, after F14 settles ch15). Deferred polish (fold into F14 or a cleanup): F9(c) extinguished maintenance
note, F7 optional ch05 seq pin, F6 SettledValue→? , F4 pledge \label, F1(b) terminal-node edge, F3 STYLUS tighten.
OBL-B (C-6.6): CONCORDIA ruling = work it OR relocate to NAMED Exclusions companion (E75, near E71–E74).
### F13 — DRAFTED (author KARPATHY, opus) — no park
§2.8: false clause "an admission door event sourcing has no equivalent of" DELETED (grep 0); §2.8 now leads with
the two strong claims — "First, a single total order, not per-aggregate streams stitched back together... Second,
replay re-reads transactions and never re-executes contracts" — merged the duplicate trailing total-order sentence
(state once). "admits or refuses" fact retained (just unwrapped from false uniqueness). F2 sec:bitemporal + box
intact. discharge_matrix §3 NOTE appended (same overreach in Const §3 prose — NOTE not park; C-3.11 stands on the
2 genuine claims). Build exit 0, 92pp, box=4. Certifier CONCORDIA: PENDING (P4 close).
### OBL-B (C-6.6) — DONE (author KARPATHY, opus) — CONCORDIA ruling: RELOCATE
C-6.6 → new Exclusions Register line E75 "Managed-Account Companion" (fee accrual + NAV attribution, "consequences
Const §6 delegates to detailed spec for managed accounts"), phrased like E71–E74; removed from §17.3 open-problems
index (no longer an undischarged gap). PARK-1..4 + non-empty stmt + opener intact; matrix updated by orchestrator
(C-6.6 row → E75; "no NAMED GAP remains"). Build exit 0, 92pp, box=4. Certifier CONCORDIA re-confirms at P4 gate.
### F16 — DRAFTED (author WILSON, opus) — no park; honest-illustration path
ch15§15.4 temporal block: header declares "TLA⁺-style specification written as ILLUSTRATION, not a machine-checked
proof; reference impl + model-checking lie outside (§5)". All proof-claiming phrases struck ("proof obligation"→
"leads-to property exercised over generated histories"; "is proved"→"is drawn"). Fairness INSIDE formula:
`Liveness == WF_vars(dischargeObligation) => ((open) ~> (discharged \/ closed_out))`. Safety `[](Coverage /\
NoDoubleCount)` (□) vs Liveness (⇝) split PRESERVED, each labelled asserted+executably-checked not theorem.
Haskell/TLA⁺ separated w/ explicit boundary sentence. All ch15 props intact, ≥1% regime untouched. Build exit 0,
92pp, box=4.
RESIDUAL for FORMALIS/TALEB: liveness executable counterpart is a BOUNDED-HORIZON discharge check (only executable
rendering over finite histories), labelled as bounded approx of ⇝ — NOT dressed as unbounded theorem; no invented
prop_liveness_fires (genuine liveness has no single generated witness). If FORMALIS wants liveness in firing regime,
needs a deadline-parameter design decision — flagged, not papered. Certifiers TALEB(G4)/FORMALIS: PENDING (P4/P5).
### OBL-B — (Wave A) C-6.6 relocate to Exclusions E75 (managed-account companion) OR work it; update matrix+§17.3
### F15 — DRAFTED (author KARPATHY, opus) — no park; authority-direction + de-pedantry
ch01§1.1: cut 3-para re-run of Const §1 (objective / two-stores-disagree / one-record) → citing summary
C-1.1 / C-1.2–1.3 / C-1.4–1.5; kept "the rest is what it forces" + scope. ch02 opening: cut map-then-fold
re-derivation of Const §3 → cite C-3.1 ("constitution defines both words; this chapter instantiates on the six
threads"); kept E→T→Ledger instantiation + 4-term gloss. Citations use C-x.y (not proposal file). PRESERVED:
abstract; all 6 commitments WITH consequences (§1.2 intact); all 6 threads (T1–T6 table); F13 §2.8; F2
sec:bitemporal+box; openers. Build exit 0, 92pp (cut ~15 lines, didn't cross page break), box=4.
KEPT-when-unsure (C5): ch02 §2.3/§2.4 (instantiation not re-derivation), §2.7 OT-1 walkthrough (spec-specific
worked fact), §1.3 conventions (spec framing). Certifiers STYLUS(G5a)/CONCORDIA: PENDING (P4 close).
### F14 — DRAFTED (author KARPATHY, opus) — no park; de-pedantry
Cast built: ch02§2.1 "The cast: six threads" (\label sec:cast) = expanded F15 table, FULL T1–T6 terms once
(parties/dates/qty/headline nums/one-line char); added T2 "marked 400,000 while live". 2nd canonical home
§9.8 sec:knockpledged (pledge overlay G/B/50%/+1/−1/200,000/150,000). 8 episodes (§2.7/4.4/5.4/7.3/9.8/12.5/
14.6/15.4) now open with Cast pointer + add-only; re-establishment deleted; 5-part episode shape kept.
CONSERVATION LEDGER (JACOBI): every recurring number has ONE canonical home + kept where USED in live
computation (400,000→0 collapse §7.3; ×50%=200,000 §12.5; coverage 200k vs 150k §14.6/15.4). No episode-
specific fact lost (split out-edge, STM/CTM, 6-step pledge close, projection-no-store, coverage-order, temporal
machine all intact). Theorems/props/openers/box=4 intact (edits only touched episode Setup lines). Build exit 0,
92pp. KEPT-when-unsure: 400k/200k/150k as computation inputs; §5.4 "two watches" antecedent; T3/T4 dates NOT
added to Cast (their episodes out of F14 scope → would create duplication). Certifiers STYLUS(G5a)/JACOBI(G6
re-verify ties): PENDING (P4 close).

### C6 SWEEP (TALEB G4) — DONE — VERDICT: READY (anti-vacuity satisfied across ALL properties)
All 11 implication props FIRE: each interesting branch built by construction + checkCoverage cover 1.0 ≥1%
(prop_netting/coverageSign/termAdj/settlementFail/mirrorClaim/twoInFlight/bitemp/noDoubleCount[3 labels]/
cascadeIdempotence). Guardless props (recompute/movesOnly/replay/4 graph-consistency) can't go vacuous or
driven transitively. Liveness (F16): honestly-labelled bounded-horizon check, fairness inside formula, no
prop_liveness_fires — ACCEPTABLE not defect. F9(c) note ADDED (extinguished extensible → each new extinguishing
kind must extend BOTH pricing rule + predicate or noDoubleCount under-quantifies). Build exit 0, 92pp, box=4.
NON-BLOCKING soft spots (record, 1-line cross-ref at next edit): prop_lateInsertRecomputesTail fires only
transitively via bitemp; genSettlementHistory branch-3 (cum claim) generated w/o own ≥1% floor.
FORWARD VERIFY-ITEM for F9 (→ CONCORDIA P4 gate to rule): confirm NO CURRENT product (option exercise, autocall
redemption, entitlement retirement, VS/TRS maturity) extinguishes exposure without being in `extinguished` TODAY
— if one does, prop_noDoubleCount under-quantifies NOW (not just future). TALEB: verify-item, not G4 reopening.
### F14 — (Wave C) Cast section (T1–T6 full terms once); episodes point + add only; no claim/number/design-point lost
