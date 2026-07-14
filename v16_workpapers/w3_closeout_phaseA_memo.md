# W3 — Phase A Design Memo: Close-Out and Netting Algebra

**For:** the owner's gate. **Status:** design proposal only — no specification text.
**Register line:** top open risk (ch17, §Open-problems index). **Advisory lenses carried:**
GATHERAL (close-out valuation / replacement cost / side at default), REGINALD ASHWORTH
(recoverability, write-off ordering, evidencing), LEX MANDATUM (master-agreement mechanics,
single-agreement doctrine, declared terms).

This memo closes the algebra ch09 makes representable but does not yet derive: value each claim
and obligation at close-out priced by its taker, net the per-netting-set members to one figure
within a master and never across, mint that figure as one claim, and decouple recovery from it.
It reuses primitives already in the spec — the event-kind registry (ch08), the agreement unit's
declared terms and the CLM-L decoupling (ch09), the coverage-forced ordering (ch09
§knock-while-pledged, ch14 Inv. coverage), the §14.1 obligation pattern (ch16), and retirement
from the zero vector (ch14). It adds one new unit: the **close-out amount claim** (CLM-CO).
Nothing else is new.

## 1. The default event and its router
Register `COUNTERPARTY-DEFAULT` as an event kind in the ch08 registry's second column. Its
routing names **the master agreement unit's own smart contract** — the settlement-obligation
pattern. One firing **per master** referencing the defaulted counterparty; members separated by
the cause-derived identifier; the notice enters as a moveless observation-recording transaction.
*Forced consequence:* routing to the master makes "net within a master" a property of WHICH
contract fires — cross-master aggregation never has a firing that could produce it.

## 2. Close-out valuation — taker-state pricing, convention declared
Each member valued at the close-out determination time through the ordinary state-parameterised
pricing layer (C-8.3), **priced by the taker** (ch09's CLM-L rule generalised). The valuation
convention — side (bid/offer/mid), market-quotation vs. loss vs. dealer-poll, termination
currency — is **declared data on the master agreement unit's close-out-mechanics slot**, never
improvised at default. GATHERAL: replacement-cost basis; the side is a term of the agreement.
*Forced consequence:* declared convention (TA-TERMS) keeps the figure recomputable from the
record; a misdeclaration is perimeter reconciliation, not an internal break.

## 3. Netting — one figure within a master, never across
Netting set = the units whose declared terms name one master agreement unit; the net is a
projection over those units. Cross-master netting is **door-refused, not unrepresentable**: the
close-out transaction's legs must all name one master — a door check of coverage's shape.
LEX MANDATUM: the master's declared terms carry membership, close-out-method election,
termination currency — single-agreement doctrine transcribed once.
*Why refused, not typed:* typing the master into every unit would contradict the settled
per-agreement-via-declared-terms design (ch09) and minimalism; the refusal also gives the
property something to fire on.

## 4. Recovery decoupling — the netted figure is one claim; recovery is another
The netted figure mints as **one unit, CLM-CO**, surviving party positive against the
defaulter's estate. Recovery decouples: CLM-CO's UnitStatus walks to *defaulted* and its mark
tracks recoverability, not par — ch09 §9.9's CLM-L decoupling generalised. ASHWORTH: the
par-minus-recoverable gap is explicit, authorised, evidenced loss recognition via the supervised
write-off path.
*Forced consequence:* two marks across a status transition on one immutable unit = the loss
recognised by construction (C-8.4); no new clause needed.

## 5. Ordering — the exact sequence of admitted transactions
1. Default notice (moveless; routes per master). 2. **Marker-plane clearing first** (coverage
refuses extinguishing owned while posted mass remains — the certified OT-1 pattern). 3. Close-out
determination observations (moveless). 4. Net-and-mint: retire each member claim from the zero
vector (close-out compensation = the declared §14.1 fallback), mint CLM-CO at the single net
figure. 5. Recovery decoupling (UnitStatus → defaulted). 6. Authorised write-down (supervised
write-off; person-authorised, evidenced). Steps 2-before-4 is forced by coverage, not preferred.

## 6. The obligation discipline
The close-out is itself a §14.1 obligation: deadline = the declared close-out period; discharge
predicate = amount determined and CLM-CO claimed; fallback = supervised write-off. A stalled
close-out is a visible, overdue item, never silence, and never a dead unit in the liveness queue.

## 7. The constitutional question — verified clause by clause: NOTHING
C-6.5 (CLM-CO is a unit) ✓; C-8.3/C-8.6–C-8.9 (pricing at determination; regimes unchanged) ✓;
C-8.4 (loss by construction) ✓; C-2.4 (cross-master and undeclared-convention refusals fail
closed) ✓; zero-vector retirement ✓. **No amendment demanded; nothing parked.** One
drafting-precision flag (for the author, not the owner): a default write-down is LAWFUL LOSS,
not C-12.4 error-repair — anchor it on the supervised write-off path + C-8.4, citing C-12.4's
human-authorisation discipline only by analogy.

## 8. The Phase-B episode (sketched, exact quantities)
Cast/ch09 objects only. SIGMA at 40.00; W-LEND lends 1,000 SIGMA to W-BORR under master L
(GMSLA, financing regime); CLM-L 1,000 (W-LEND +1,000 / W-BORR −1,000), 40,000 at inception,
priced by the taker. Declared for the episode: W-BORR posts 41,000 cash under L's
security-interest terms without right of use (posted-plane marker, received-negative);
determination print 44.00; declared recovery 40%.
Walk: (1) default notice → routes to L's contract, cascade via cause-derived id, duplicates
inert; (2) marker clears first — owned(USD) 41,000 W-BORR → W-LEND with posted ±41,000 → 0, one
coverage-ordered transaction; (3) determination 44.00 recorded; CLM-L valued at taker state =
44,000; (4) net within L: 44,000 − 41,000 = **3,000** to W-LEND; (5) mint CLM-CO +3,000, retire
CLM-L from the zero vector; (6) decouple: CLM-CO → defaulted, marked 40% × 3,000 = **1,200**;
(7) authorised write-down recognises the **1,800** loss. Conservation, coverage ordering,
zero-vector retirement, idempotence at every step.

## 9. Properties (named for Phase B)
P1 netting within a master only (cross-master legs refused at the door, ≥1% firing);
P2 close-out figure recomputable from the record (replay oracle, to the minor unit);
P3 retirement only from the zero vector with coverage-forced ordering (metamorphic).

## The decisions asked of the owner
1. **Valuation-convention-as-declared-data (ratify):** the close-out convention lives as
   declared terms on the master's close-out-mechanics slot, boundary data under TA-TERMS, never
   improvised at default.
2. **Cross-master refusal form (choose; recommendation door-refused):** refused at the door by
   reading each leg's declared master reference — not made unrepresentable, which would type the
   master into every unit against the settled declared-terms design.
3. **No constitutional change (confirm):** C-6.5, C-8.3, C-8.4, C-8.6–C-8.9, C-2.4 and the
   zero-vector discipline suffice.
4. **Acknowledge the drafting flag:** default write-down = lawful loss on the supervised
   write-off path (C-8.4), citing C-12.4 by analogy only — never conflated with error-repair.

Phase B drafts nothing until the owner rules.

---

## OWNER RULING (2026-07-14, recorded at the gate)
1. **Valuation convention RATIFIED as declared data** on the master's close-out-mechanics slot
   (TA-TERMS boundary data; never improvised at default).
2. **Cross-master refusal form: DOOR-REFUSED** (not typed) — legs of one close-out transaction
   must all name one master, read from declared terms; P1 fires on the refusal.
3. **No constitutional change CONFIRMED** — C-6.5/C-8.3/C-8.4/C-8.6–9/C-2.4 + zero-vector
   discipline suffice; nothing parked.
4. **Drafting flag ACKNOWLEDGED** — default write-down = lawful loss on the supervised write-off
   path (C-8.4); C-12.4 cited by analogy only, never conflated with error-repair.

Phase B drafts against this ruling.
