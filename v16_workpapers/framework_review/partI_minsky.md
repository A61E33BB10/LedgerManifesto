# Part I Framework Review — MINSKY (type discipline, illegal states, interface composition)

Reviewer: MINSKY. Date: 2026-07-21. Charter: make illegal states unrepresentable; parse don't
validate; total functions; exhaustive cases; interface discipline. Corpus read in full: Constitution
v1.41; Market Data Manifesto (MDM) 1.3; Valuation Manifesto (VM) 1.0 incl. Part B and PARK-1.

Mandate framing: I trace every point where a value crosses a document boundary and ask whether its
type guarantees survive. Severities: [High]=guarantee eroded / illegal state constructible; [Med]=gap
or drift a stress exposes; [Low]=wording/partiality hazard. Boundaries examined: (a) external
observation -> observation-recording transaction -> home -> contract read; (b) model output ->
re-entered observation -> projection leg; (c) execution-ordered fold and late-arrival refold; (d)
frame/cut/as-of/as-at coordinates; (e) world-map family (dynamic / shift / D); (f) storing a
deterministic function of the record.

## ADVICE (ordered, highest leverage first)
A1. Complete the Constitution's typed arrow algebra (C-3.6). It types one Transaction producer,
    `contract:(Event,Ledger)->Transaction`. Add the recording arrow(s) with a named producer, OR
    ratify an "observable-is-a-unit" convention so a bare price print has a contract and a home. First:
    C1, C2, C4 all sit on it.
A2. Resolve "may a deterministic function of the record be stored?" ONCE, framework-wide. C-4.11 says
    never; PARK-1 parks it for sigma_prod^2; MD-16 already stores a gate verdict as an "event-outcome."
    One clause must govern all three (PARK-1's three-condition materialised projection is a candidate)
    so no document decides it by private nomenclature.
A3. Give NAV/valuation one type across documents. C-8.1/C-8.2 type NAV as a bare cash number; VM-2
    says a valuation without coordinates "is not one" and may be stale/broken. Coerce explicitly, or
    the headline number carries different guarantees in different documents.
A4. Wire VM-10's finite-shift greeks to MD-16's gates. A bumped state (spot +20%, VM's own example)
    is a constructed derived state a risk report consumes; MD-16 requires such states to carry a gate
    decision. VM 1.0 predates MD-16 and omits the linkage.
A5. Give MD-9 a cross-reference to MD-16's carve-out, so a reader of MD-9 alone is not told
    "detection, not admission" flatly while MD-16 says "prevention, not detection."
A6. Name the identifier-grain trust assumption in the invariant catalogue (C-11.5). MD-1 is honest
    grain-correctness can fail silently; C-11.5 lists idempotence as an invariant with no such caveat.
A7. Make valued-ness a type, not a runtime property. C-4.3 makes price "undefined" on non-valued
    units — a partial function. Type `price:ValuedUnit->Price` so pricing a governance shell is
    unconstructible, not a runtime undefined.
A8. Force cross-grain consistency in the world-map family: a surface's D (MD-16 / PE-1 A5 / VM-5)
    must agree with the per-datum dynamics (MD-16) of the vols composing it. "One family" is asserted;
    agreement between members at different grains is required nowhere.

## CRITICISMS (wrong as written today)
C1 [High] — The observation-recording transaction and the re-entered-observation transaction have no
   producer in the Constitution's type algebra. C-3.6 types only `contract`. C-6.1 asserts "the smart
   contract is the converter" of everything outside, yet C-6's barrier example has "the close is
   observed and recorded" with no unit's contract firing (the note's contract fires on the knock, not
   the print). MD-1 attributes recording to the Events Executor — but C-5.4 says it "never writes the
   ledger; its output is only proposals," and a contract is "the executable form of [a unit's] terms"
   (C-4.4, C-6.4), which a bare price feed is not. The value crosses the trust boundary via an arrow
   whose producer, input type, and validation are unspecified.
C2 [High] — The framework answers "store a computable?" two opposite ways. MD-16 records the gate
   decision ("pinned event-outcome ... no collision with C-4.11 ... PARK-1 neither reopened nor turned
   on"); PARK-1 parks storage of sigma_prod^2 for the owner because "a projection stores nothing"
   (C-4.11, MD-6). Both are deterministic functions of versioned recorded inputs. MD-16's "event-
   outcome" label is the reclassification PARK-1 refused to make without the owner. Either MD-16's
   storage needs the same parking, or PARK-1 is over-parked by MD-16's own reasoning — both cannot
   stand. This is the CLAUDE.md-named worse failure: a guarantee (C-4.11 "never stored") kept reading
   true by relabeling the residue.
C3 [Med] — MD-9 and MD-16 state the no-arbitrage enforcement mode with opposite polarity ("detection,
   not admission" vs "prevention, not detection"), reconciled only inside MD-16; MD-9's text (unchanged
   per the 1.3 record) carries no pointer. A reader landing on MD-9 gets the wrong rule. Violates
   "state each thing once."
C4 [Med] — "Home" drifts. The Constitution fixes "the three homes" as vocabulary (C-Auth.4), all
   unit-scoped (C-7.2). MD-1 folds an observation "into a home," but a market-data observation of an
   observable the firm does not hold (index constituent, unheld underlying) is keyed to no unit and
   fits none of the three. The charitable observable-as-unit reading (A1) is unstated and duplicates a
   held name against its price source.
C5 [Med] — The as-of/as-at indexing the Constitution delegated to "the specification" (C-12.1) is
   fixed at manifesto level by MD-4. Natural, but a later implementation spec that indexes differently
   now conflicts with a manifesto, not a free delegation.

## POTENTIAL WEAKNESSES (correct now; break under stress)
W1 [High] — Stale marks under refold. Stressed: NAV = owned quantity x price vector (C-8.2);
   projections refold on a late arrival (C-12.6, MD-5), but re-entered marks cannot refold and go
   stale (MD-5, VM-7). Scenario: an execution-time-early observation lands, the fold refolds
   quantities, mark legs go stale; NAV recomputes fresh quantities x stale marks and surfaces a bare
   number (C-8.1 has no staleness coordinate) unless every read propagates VM-7's broken-chain flag —
   which the Constitution's NAV type cannot carry.
W2 [Med] — Prevention veneer over a detection-only root. MD-16 prevents at every derived step but the
   base state is admissible by MD-9 detection only. Scenario: an arbitrageable base surface is admitted
   (detected late), all derived stress states pass both gates, the risk report reads as fully gated yet
   is rooted in an un-prevented economic error. MD-16 is honest about it; a consumer over-trusts.
W3 [Med] — World-map family unconstrained across grains (see A8). Scenario: a surface re-marked by a D
   whose per-strike moves contradict the declared per-datum dynamics of its vols; both recorded,
   neither gates the other, and sigma_prod^2 (PE-3) inherits an inconsistency no article forbids.
W4 [Med] — Idempotence conditional on grain. Stressed: C-11.5 lists idempotence-under-cause-derived-
   identifier as a structural invariant. Scenario: two distinct prints identical under every field a
   feed sends (MD-1's admitted residual) collide; the "invariant" silently drops one. It is a theorem
   conditional on a perimeter trust assumption the catalogue does not name.
W5 [Med] — Greek regime gap between VM's local A5 and MD-16's finite gate. PE-1(A5) discharges surface
   admissibility infinitesimally (interior base + continuous D); MD-16 Gate 1 discharges it at a finite
   shift. Scenario: a finite-difference greek bump (VM-10) lands between — too large for the local
   argument, ungated by MD-16 (A4) — so the shifted surface's admissibility is asserted by neither.
W6 [Low] — "Marks it stale" invites a mutable field. VM-7/MD-8 say lineage "marks stale"; the clean
   reading is a projection over lineage carrying a flag (MD-8 states this). Scenario: an implementer
   mutates the append-only re-entered observation, reintroducing the second store the architecture
   removes. Language hazard, not a spec contradiction.
W7 [Low] — Virtual wallet vs C-4.5's two-party invariant. Every wallet "names two parties" (manager +
   beneficial owner); a virtual wallet for "the market" or a CCP (C-4.9, C-10.1) has no natural manager
   authorised to transact. Either virtual wallet is a subtype with a relaxed invariant (unstated) or
   the two parties are a fiction.

Gravest: C2 — the framework stores a deterministic function of the record (MD-16 gate verdict) by
calling it an "event-outcome" while parking the identical act (PARK-1, sigma_prod^2) for the owner,
eroding C-4.11 ("never stored") — the reconciliation-failure root the architecture exists to close
(C-1.2, C-1.3) — by nomenclature rather than by ruling.
