# Round-2 Review Harvest (7/7 returned) + Panel Ruling

## PANEL RULING DL-01 (unanimous 3-0: correctness-architect, minsky, jane-street-cto)
(a) The custodian statement CROSSES the one door as a registered witness event kind (moveless
observation; no mirror balance; perimeter-only = uncomputable DS3 = the abolished spreadsheet).
(b) TA-CUSTODY is NAMED as the fifth trust assumption — different proposition (statement
content-veracity), different detection (the N2 identity classifying BREAK) than TA-KIND
(convention, invariance witness). CONDITION (jane-street): full Owner/Violation/Detection/
Residual structure; Detection = the identity itself; Residual = a misrender coincidentally
matching the internal book. The ch16 "four…and no other"→five edit stays parked as a spec-pass
proposal with exact text.

## BREAKS (all must be answered on the record)
B1 (correctness-architect): classification undecidable as written — CLEAN and LEAD-LAG both
"identity holds". FIX: CLEAN ⟺ r≈0 ∧ F=0; EXPECTED-LEAD-LAG ⟺ r≈0 ∧ F≠0 (age = first
statement with F≠0; ripens when the unit's deadline passes); BREAK ⟺ r≠0.
B2 (jane-street): tolerance is the un-audited backdoor — a $60k tolerance reclassifies the $50k
mis-debit CLEAN. FIX: tolerance per (custody account, currency), owned by TA-CUSTODY
governance, declared de-minimis floor far below single-wire materiality.
B3 (jane-street + nazarov, convergent): no staleness watch on the statement itself — custodian
goes dark, stale CLEAN stands. FIX: freshness contract per account (expected cadence, declared)
+ scheduled-statement due-date watch (M1) minting an overdue item on non-arrival — the honest
completion of TA-ARRIVAL for this kind.
B4 (sbl): the identity OMITS the lent ray — agent lender: 1M lent, owned kept, depot 0 →
permanent false 1M BREAK. FIX: depot = owned − lent_out + borrowed + inflight_out − inflight_in;
AND whether lent mass leaves depot a (title transfer vs agency internal) is a DECLARED TERM of
the lending agreement governing W(a) membership.
B5 (sbl + minsky + reg-reporter, convergent): the depth cap is the wrong bound. T2S auto-partial:
1M shares in ~10k clips = depth 100 → false 980k CSDR fail + confirmations dropped on a retired
unit; at-cap "fail whole" ignores a recorded 7-of-10 confirmation (DS4 violation). AND minsky:
the depth cap's delete-test miscounts — parents retire at each split, settled legs are terminal,
so EXACTLY ONE residual is live at any instant: no M7 flood exists. FIX: delete splitDepthMax;
the bound is min-partial-fill-size (declared term, T2S minimum settlement quantity) and, at that
floor, aggregate-remaining-fills accumulate on the ONE live residual (cumulative-confirmed
against Q) — population bounded by construction, fragmentation = log length only. Re-derive the
delete-test honestly. NS-04 closes via this, not v11's D_max.
B6 (sbl): buy-in unbound → double-count (owned 200 vs economic 100, identity blind — both sides
inflate). FIX: the buy-in delivery DISCHARGES the failed residual (compensation binding; SO-1 →
settled-by-buy-in; no independent +100 long).
B7 (reg-reporter): CSDR Art.7 penalty needs the EXTERNAL root reference. FIX: root
settlement-instruction reference (CSD matching ref + ISD) as a declared term, invariant across
every recursive split; penalty projection = fold over the fragment tree reconstructing the daily
failing-quantity step function.
B8 (nazarov): unsigned statement — forged/replayed camt.053 makes false BREAK or false CLEAN.
FIX: origin-authenticity named (statement authenticated under an identified key at source or
gateway; owner key-mgmt; detection signature-verify + sequence recon) — as TA-CUSTODY's
Detection/companion clause.
B9 (nazarov): restatement non-deterministic — same valid-time, two readings, Thm 14.4(b) ties.
FIX: restatement carries an explicit supersedes-ref (statement-id chain); the identity nets only
the superseding observation.

## SIMPLIFICATIONS (adopt jointly)
S1 (jane-street): the INVARIANT is binary — residual zero-in-tolerance OR named by a live open
unit; the three-way classification is a §12 REPORT projection (with B1's decidable predicates);
"ripening" is DELETED as machinery — aging is M7's, keyed on the open unit's deadline.
S2 (minsky): with B5's fix, no depth term survives; one live residual carries cumulative fills.

## TYPE/CARRY ITEMS
T1 (minsky): W(a) typed as a TOTAL function wallet→account per coordinate class (disjoint+
covering); T2 (minsky/nazarov): witness kind field enumeration {account ∈ registered (else W4
unresolvable-reference quarantine — nazarov GAP-4), coordinate, balance int minor units, as-of,
statement-id, supersedes-ref}; T3 (minsky): the settlement-obligation leg typed directed
(payer→payee, coordinate, quantity) so inflight sign is total; T4 (reg-reporter): settlement
channel flag (internal vs CSD) + CSD-of-reference on the account — Art.9 computability; T5
(reg-reporter): break-identity rule (account, coordinate, residual sign) for aging/resolution
timelines; T6 (rosetta, binding): four CDM-gap rows (settlement-fail, partial, custody
statement, identity) per ch13 discipline + the note that the ledger's moveless observation is
NOT a CDM Observation.

## AFFIRMED (keep, cite the attack)
Single-custodian-single-source (nazarov: a statement is not a price; W3 quorum would be
theatre); the $50k mis-debit detection (reg-reporter, given B2's floor); DvP honesty (all);
T+0 degeneration (jane-street); re-projection-not-storage (minsky, reg-reporter).
