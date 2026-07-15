# DIRAC — Round 2 — States.tex

**Verdict: NOT-YET**

The three-home structure is close to inevitable, and most of it earns its place: the
$2\times2$ frame is the right notation, the empty cell is argued, the "no fourth home"
closure is clean. But the table's column axis is named by one criterion and partitioned
by another, and the misalignment surfaces on a concrete element. Under my lens the second
distinction is not yet a single clean binary, so the three cells do not yet fall out
inevitably.

## Primary residue — the discipline axis is two non-coextensive criteria wearing one label

The $2\times2$'s second axis is introduced (§The Answer, lines 53–56) as:

> "an externally-sourced authority, versioned and never rewritten, or an internal value
> overwritten in place."

This welds **source** (external / internal) onto **retention** (versioned / overwritten)
and treats the pair as one binary. They are not coextensive, and the spec's own contents
break the weld:

- **Status holds an externally-sourced value in the "internal" pole.** The Status bullet
  (line 64) lists "last settlement price"; `settle :: UnitId -> Price -> ...` (line 222)
  takes its `Price` from outside. A settlement price is externally sourced, yet it lives
  in the home labelled "internal value overwritten in place." So the column discriminator
  cannot actually be external-vs-internal — Status is external-data-overwritten, which is
  neither stated pole.

- **The empty-cell proof then leans on the source criterion, not the retention one.**
  §Why Three, lines 111–117: "The fourth cell is empty because nothing external sources a
  per-position fact … that authority exists only for externally-sourced unit terms."
  This argues cell 4 (holder,unit × versioned) empty via *external sourcing* — the very
  attribute that, per the point above, does not align with the column.

- **Meanwhile §Why's terms-vs-status paragraph (lines 102–109) uses the *correct* axis:
  retention.** "the prior stays for audit and reconstruction" vs "keeping no history."

So three passages invoke two different second-axes (source in §Answer and the cell-4
paragraph; retention in the terms paragraph). A competent first-time reader cannot tell
which is load-bearing, and on the source reading the settlement price sits on the wrong
side of the table. That is an unexplained special case at the level of the axis itself.

**Actionable fix.** Make the second axis purely *retention discipline*:
versioned-history-retained-in-store vs overwritten-in-place. Then:
- Status holding an externally-originated price is no anomaly — it is overwritten
  regardless of where the datum came from.
- Cell 4 empties on the same axis without invoking "external": *no (holder,unit) fact
  needs retained history* — entry NAV is write-once (no history), HWM ratchets (a
  retained value, not a history). The mandate-unit argument (lines 117–121) already
  carries the rest.
Source (external/internal) can stay as *motivation* for why terms retain history and
status need not, but it must not be presented as the partition.

## Secondary residue — terms history in-store vs status history in-stream is unexplained

§Deterministic replay (lines 293–294) asserts "every view is a projection of the stream,"
and `Settled` is an event, so status history is reconstructible from the stream. Yet Terms
carries its full version list *in the store* (`NonEmpty TermsVersion`, line 184) while
Status carries only the current value. If both histories live in the stream, why does one
home cache the series and the other a single value? The text gestures at "audit and
reconstruction" (line 108) but never reconciles this with the projection claim. One
sentence — terms' prior versions are directly queried, status' prior values are only ever
needed as the current projection — would close it. Without it, a reader asks why Terms is
not also overwritten-with-replay, and the asymmetry between the two unit-keyed homes reads
as a choice rather than a consequence.

## What is already inevitable (not in dispute)

- The key axis (unit vs (holder,unit)) and its §Why justifications (lines 89–100) are
  airtight: two holders of one future hold $+1000$ and $-1000$; one settlement price has
  one writer. The notation earns its place.
- The "no fourth home holds economic state" closure (lines 74–79) and the mandate-as-unit
  resolution of the managed-account counterexample (lines 117–121) are genuinely
  unifying — the apparent wallet-keyed special case collapses into a position. That is the
  spec at its best.
- Conservation-as-property-of-the-writer (lines 257–268) is correct and beautifully put.

Fix the axis labelling so the second distinction is one clean binary, and the three cells
will fall out without a special case. As written, they do not yet.
