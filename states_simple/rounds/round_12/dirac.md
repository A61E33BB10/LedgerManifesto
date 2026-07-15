# DIRAC — Round 12 — States.tex

**Verdict: OBVIOUS**

## The bar

The three-home structure must read as inevitable from one rule: no unexplained
special case, no competing criteria. Reader: a competent engineer who has never
seen this problem.

## What the structure is

Two binary questions form a direct product (a 2×2):

1. **Does the value vary by holder?** — fixes the *key*, hence the *map*
   (unit vs (holder, unit)).
2. **Who owns the record's history?** — fixes the *write discipline*
   (ledger-authored, overwritten; vs externally authored, appended).

Occupied cells: Status (unit / ledger), Terms (unit / external),
Position ((holder,unit) / ledger). Empty: (holder,unit) / external.
Three homes = four cells minus one derived-empty cell.

## Why it passes

**The 2×2 is a clean direct product, not competing criteria.** The two questions
are orthogonal coordinates of a fact: one places its key, the other its
authorship. They never disagree about where a fact goes, so there is no competing
criterion to adjudicate. This is the canonical beautiful structure from two
binary attributes; forcing it into a single linear "rule" would be artificial.
The bar's "one rule" is satisfied in spirit: nothing arbitrary, nothing
competing.

**Each axis is genuinely binary within scope, and the binarity is defended, not
assumed.**
- Axis 1: the apparent third option — a holder-only (wallet) key — is excluded by
  scope ("one unit's state, only the unit and a holder of it in view," §Answer)
  and, crucially, by the framework primitive that *every economic relationship is
  itself a held unit* (lines 61–66). The hardest counterexample (managed-account
  high-water mark, which "appears to demand a wallet-keyed home") is pre-empted
  and reduced to a (client, mandate-unit) position (§Why). The axis is binary by
  construction, not by enumeration.
- Axis 2: authorship is disambiguated by its one true test — *who owns the
  history*, not who sources the number (lines 70–76). The settlement-price case
  (sourced from the exchange, yet ledger-authored) and the benchmark
  level-vs-identity case (same provider, opposite cells) are sorted by this single
  criterion, and the text claims and demonstrates exactly that: "One criterion
  sorts the whole category" (line 94).

**The empty cell is a theorem, not a special case.** §Why derives it from the
same primitive that makes axis 1 binary: an outside party can *report* on a
holder's position but cannot *define* one independent of the ledger's own moves,
because any relationship-with-an-authority is modeled as holding a unit that
authority issued — which is an internal (holder, issued-unit) position. So
external holder-position facts cannot exist; the custodian/prime-broker statement
is a reconciliation input, never an adopted record (lines 143–158). The same
primitive drives both axis-1 binarity and the fourth cell's emptiness — the
hidden unity that makes the count *three* inevitable rather than four-minus-an-
accident.

**The Terms/Status split (per-unit row into two homes) is forced, not
convenient.** Co-mingling the authority's record with the ledger's own is exactly
the single-source-of-truth violation the system exists to prevent (lines
134–136); authorship therefore forces two distinct values, and the write
discipline (append-keeps vs overwrite-discards) follows directly from authorship.

**"Three homes, two maps" is pre-empted, not a discrepancy.** Home = occupied
cell; map = storage by key. The two per-unit homes share the unit key, so ride
one map as a pair value; co-presence becomes the shape of the map, not an
invariant to police (lines 101–103, §Construction). The count *three* is the cell
count and is independent of the map-merging choice.

## Adversarial probes that failed to find residue

- Tried to break the empty cell as merely empirical: it is forced by the
  relationship-is-a-held-unit primitive; the managed-account case demonstrates the
  reduction explicitly.
- Tried to find a fact awkward to place: settlement price, benchmark level vs
  identity — all sorted by the single authorship criterion, explicitly.
- Tried to find a hidden third placement criterion: conservation and
  monoid/group structure are field properties *within* Position, not placement
  rules; they never compete for placement.
- Checked the literal "one rule" objection: the structure rests on two
  *orthogonal* commitments (relationship-as-held-unit; single-source-of-truth).
  Orthogonal is not competing; the direct product is the more beautiful, and the
  inevitability holds.

## Conclusion

The three-home structure reads as inevitable. Two orthogonal, each-defended
questions give a 2×2; one modeling primitive forces both the binarity of the key
axis and the emptiness of the fourth cell; authorship forces the Terms/Status
split with its append/overwrite disciplines. No unexplained special case, no
competing criteria. The structure feels inevitable, and the notation
(Qty as group, Price as a numbered non-quantity, NonEmpty for append-only, sealed
constructor) is minimal and revealing.

**OBVIOUS.**
