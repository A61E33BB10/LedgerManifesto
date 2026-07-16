# Round 4 Reviews — on candidate_r3.md

Tally: 2 APPROVE (rosetta-cdm, jane-street-cto), 5 BREAK. All R3 items across all seven
reviewers RESOLVED — no carry-over disputes. Round 4 items below.

## BREAKS

### R4-B1 (minsky) — N6/N7 conservation is asserted, not constructed
Δpredicted = 0 is a hand-checked identity, not a typed binding. The `owned` re-book is a door
move (Σ=0); the leg amendment is moveless (ProductTerms), outside door conservation. A
malformed correction re-booking owned −10 while amending the leg −8 is door-admissible and
leaves a permanent spurious r = −2 that never self-heals — the exact failure N6 abolishes,
reintroduced. Same gap in N7 (lent_out decrement unbound to the possession leg) and latent in
the base mint (in-flight leg is a free declared term unbound to the owned move).
**Fix:** derive the in-flight leg and the owned move from ONE restated quantity/price
parameter, so a unit whose leg magnitude disagrees with its owned re-book cannot be
constructed. Δpredicted = 0 becomes a theorem of the transaction shape at instruction,
correction, re-instruction, and recall alike. (The "unrepresentable, not merely unlikely"
standard N3 just met for T+0.)

### R4-B2 (correctness-architect) — N6 discriminator under-specified; permitted form causes a real break
"Changes what the CSD will actually settle" fires on EVERY quantity/price change — so the two
worked "pure same-unit amendment" examples are re-instructions by the candidate's own
predicate. True discriminator = **emission status**: is a settlement instruction already
live/matched at the CSD (a live root reference, N5)?
Numbers: buy 100@$50, emitted Mon as CSD-REF-001 (100/$5,000). Tue amend in place to 90.
Δpredicted=0, Tue r=0 ✓. But CSD-REF-001 is never cancelled; Wed the CSD settles the matched
100/$5,000 → depot 100 vs predicted 90 → **r=+10 BREAK**; nostro 995,000 vs 995,500 →
**r=−$500 BREAK**. Real break, permitted by N6.
**Fix:** no live ref ⇒ leg amendment; live ref ⇒ mandatory re-instruction (cancel root ref +
re-mint). Property: no in-place leg amendment on a unit whose instruction has been emitted
(decidable from the record).

### R4-B3 (regulatory-reporter) — CSDR Art.7 penalty reconciliation is half-open
N5's internal fold has no recorded counterpart: the CSD's penalty advice (**semt.044** — its
reference price, SECR rate class, monthly aggregate, and the failing-party direction) never
crosses the door. Reconciling expectation vs actual charge lives in a spreadsheet — the exact
defect N1 abolishes, one regime over (the candidate's own delete-test concedes it).
**Fix (reuses machinery):** register semt.044 as a witness event kind under N1 discipline
(typed fields: reference price, rate, amount, direction; provenance; B9 supersedes-chain for
the appeal/amendment cycle) + a penalty-reconciliation identity — N5's dated-clip fold vs
semt.044-asserted penalty per root reference — classified CLEAN / EXPECTED-DIFF (reference-
price convention within tolerance) / BREAK. Absent this, DS14 downgrades to "internal fold
computable; CSD reconciliation parked."
**Secondary (composes with R4-B2):** a re-instruction mints a NEW root settlement-instruction
reference (the CSD's new matching ref), never inherits the retired unit's — semt.044
penalises the two CSD-distinct instructions separately.

### R4-B4 (sbl-specialist) — N7 recall re-book called "moveless"; possession-plane conservation not shown
Under the certified schema `lent` is a balance coordinate: every change is a **paired move**
per (unit, coordinate, agreement); a unit's in-flight leg is a projection, not a wallet
balance, so it cannot be the conservation counterparty. As written, Σ_w bal_lent(SIGMA) =
lender 0 + borrower −1,000,000 ≠ 0 for the whole return window. Two horns: literal
"moveless" ⇒ lent_out cannot change (the R3 double-count returns); paired move (correct) ⇒
the borrower's `borrowed` re-books at recall instruction while the borrower still physically
holds — giving the borrower inflight_out = 1,000,000 and a +1M depot LEAD-LAG the single-
sided micro-case never shows.
**Fix:** state the recall as a paired lent-coordinate move (lender lent_out ↔ borrower /
virtual-contra borrowed), show the borrower-side reconciliation, drop "moveless."

### R4-B5 (nazarov, scoped) — key revocation has no compromise-effective time
"Re-quarantine every statement verified under the compromised key" is undefined in scope:
literal reading nukes ~10 weeks of legitimate CLEANs (hole in the statement stream — those
as-of dates become unclassifiable); naive reading (post-discovery only) lets a forged
statement admitted before discovery escape with its planted classification standing. The
flip-set is a judgement, not a recorded coordinate — non-deterministic on replay.
**Fix:** the revocation event MUST carry a compromise-effective transaction-time `t_c`;
re-quarantine scope = statements admitted in [t_c, discovery] AND verified under the revoked
key. Deterministic projection; sledgehammer scoped to the true exposure window; pre-t_c
CLEANs preserved.

## APPROVE residuals (non-blocking; fix before/at .tex)

- **rosetta-cdm:** N6 labels two CDM-distinct constructs "correction": booking error →
  `WorkflowStep.action=Correction`; agreed economic change (re-instruction) → amendment
  (terminate + new BusinessEvent). Name the two images distinctly. (Aligns exactly with
  R4-B2's discriminator — the emitted/live case IS the amendment.)
- **jane-street-cto:** (a) the §12 classification carries, per LEAD-LAG line, its naming
  units' M7 status (on-time / overdue N days) — a projection join from the same log; closes
  the green-dashboard-over-rotting-fail blind spot without touching the binary invariant.
  (b) State explicitly that N6 re-instruction conserves only because it is one atomic door
  transaction. (c) Cite TA-TERMS for the T+0 atomic-finality declaration.

## Convergence note
R4-B1 + R4-B2 + rosetta's naming split compose into one N6 redesign: the discriminator is
emission status; both forms derive leg and owned move from one restated parameter; the two
forms are named as CDM's Correction vs amendment. R4-B3-secondary rides the same redesign
(re-instruction mints a new root ref). R4-B4 is the N7 analogue of R4-B1 (paired move = the
constructed binding on the possession plane).
