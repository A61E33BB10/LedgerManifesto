# Conformance note — rewrite of §"The State-Basis Discipline"

*For the author's reply to the reader. Lives outside the specification.*

## 1. The corrected purpose, and why the reader's formulation was not adopted verbatim

The reader stated the section's purpose as:

> "to guarantee that every representation of unit state remains continuously and verifiably
> synchronised with authoritative market data."

The diagnosis behind the remark — that the old section never stated its purpose and read as
obscure and disconnected — was accepted in full and drove the whole rewrite. The
*formulation* above, however, was **not** adopted, because it inverts the design on two
points that are load-bearing:

1. **Authority.** Market data is *not* authoritative in this framework. The **ledger** is the
   sole authority on a unit's corporate-action basis: the basis is a coordinate the ledger
   folds from the unit's own logged lifecycle and carries in `UnitStatus`. A market
   observation is an external reading, stamped at the boundary and admitted only if the frame
   it claims is one the ledger has committed. To call market data "authoritative" and unit
   state something to be "synchronised" to it reverses the direction of authority the section
   establishes (Principle `prin:stamping-authority`).

2. **Direction of the discipline.** The discipline does not *synchronise state to data*. It
   governs *which data may be combined with which state*: a quantity and a price meet only
   when they stand in one basis, or when one is **carried onto the other's basis by the exact
   rule the corporate action itself published**. A mismatched pair with no such rule is
   refused rather than guessed. The goal is not to chase the feed but to make **mixed-basis
   valuation** — phantom profit across a split, a double-counted dividend, a stale index
   divisor — a state the system cannot represent.

The rewrite's first sentence therefore reads:

> "The State-Basis Discipline makes one class of valuation error unrepresentable: the
> combining of a quantity and a price that were measured against different corporate-action
> states of the same instrument."

and the paragraph fixes the direction of authority explicitly ("the ledger, not the
market-data feed, is the sole authority … it does not chase the feed, and it never treats
the feed as the authority on state"). Two independent cold readers, reading only that first
paragraph, recovered the purpose correctly and reported that the reader's original
(mis)reading "cannot be formed in good faith" from it. The misreading was used as the
regression test throughout.

One subtlety the committee corrected mid-rewrite, worth flagging because it is easy to get
wrong: the discipline does **not** "refuse mismatched frames." Where the corporate action
has published a declared conversion, a stored observation in the old frame is **transported**
onto the current frame along that one declared arrow and consumed (this is exactly what the
worked split does). Refusal is the fate only of a mismatch for which *no* declared rule
exists — fail-closed. An earlier draft that said "refused, not reconciled" asserted a
stronger rule than the mechanism implements and was corrected.

## 2. The six devices (a)–(f) and where the revised section implements each

| Device (reader) | Implementation in the revised opening of `sec09.tex` |
|---|---|
| **(a)** opening paragraph whose first sentence states the purpose unambiguously | Paragraph 1 — "makes one class of valuation error unrepresentable …", with the direction of authority stated explicitly. |
| **(b)** a short `mentalmodel` block immediately after, non-normative, picturing the divergence problem | The existing FORMALIS-ratified survey-datum ("map-datum") block, moved to sit **after** the purpose paragraph (it previously opened the section), followed by a one-line bridge naming the frame the unit's *basis*. Verbatim; deletion-safe. |
| **(c)** for each of the three homes, a clause linking it to the discipline's requirement | The three-home paragraph: *ProductTerms* → the single rounding rule that keeps basis-crossing arithmetic exact; *UnitStatus* → the one added field, the basis coordinate; *PositionState* → balances read at that basis, meeting a price only inside a coherent snapshot. |
| **(d)** a concise, named invariant introduced early and referenced from later sections | The rule paragraph names **single-basis consumption (Invariant `inv:basis`)** and forward-references its formal statement (`sec:basis-invariant`). It is **cited** from valuation (`sec06`, at `prin:state-sufficiency`), the futures lifecycle (`sec10`, at variation-margin settlement), and managed accounts (`sec11`, at the benchmark level). *The formal `\begin{invariant}` environment was **not** physically relocated to the top — see the note below.* |
| **(e)** one minimal, self-contained end-to-end example: a market-data event entering, the projection update, and verification that conservation / path-independence hold | The "rule in one walk" paragraph: a vendor print enters the ingest door and is stamped; the split commits atomically (balance ×2, `SetBasis`, `Scale ½`); a later snapshot transports the print along the declared arrow; the mark is basis-invariant (Theorem `thm:basis-value-invariance`, c=0), the phantom €200,000 unreachable. The full walk — the PnL **decomposition** (which is basis-invariant leg-by-leg, the "path-independent quantities" the reader asks after) and the late-notice replay — is deferred to `sec:basis-worked`, where it already lives. |
| **(f)** a short closing forward pointer | The final opening paragraph: the same discipline underpins state-sufficiency in valuation and every downstream mark (futures settlement, managed benchmark), then lists the machinery the rest of the section develops. |

### Note on device (d): named reference, not physical relocation

The reader asked for the invariant "given its referenceable statement and label at the top of
the section." The committee (FORMALIS, decisive) ruled **against** physically moving the
formal `\begin{invariant}` environment to the top, on two grounds: (i) *definition-before-use*
— the invariant quantifies over `usBasis` (`def:usbasis`), over stamps (defined at the ingest
door), and over the stamp-closure (defined at the typed seam); relocated to the top, every
term in it would be a forward reference to undefined vocabulary; (ii) *single-statement
discipline* — a second rendering of the invariant is a second normative source, and an
in-draft paraphrase was observed to drift from the formal statement within one iteration.
Device (d) is therefore realised as an **early named statement + forward reference + three
backward citations**, with a plain-language paraphrase explicitly subordinate to the formal
label. This satisfies "introduced early and referenced from later sections" while preserving
one formal statement, one label, one name.

## 3. Scope discipline honoured

- **No new normative content.** Every definition, condition, theorem, listing, label, and
  cross-reference already in the section survives verbatim in meaning; the opening reorganises
  and re-illustrates existing material. The named invariant is the **existing** condition
  (`inv:basis` / C13), surfaced and cited — not a sibling. The three citation touches are
  one clause + one `\ref` each, each a clarifying cross-reference to the already-general
  invariant (which quantifies over *every* datum a valuation consumes), introducing no new
  requirement.
- **Model-agnostic wall intact.** The worked example prices nothing; it checks quantities and
  marks, not a model.
- **Standing standards.** First-version voice (no trace of the remark, its author, or any
  revision history); standalone; the `mentalmodel` device used per the document's established
  convention and image-world; terminology exactly as the document defines it.
- **Build.** `latexmk` exit 0; **192 pages** (was 191; +1; cap 200); 0 undefined references,
  0 multiply-defined labels; listing discipline untouched.

## 4. One item referred to the author (not implemented)

In managed accounts the single-basis rule bites a **second** time: performance combines the
*inception* benchmark NAV (stored in `PositionState`) with the *current* benchmark level; across
a benchmark reconstitution this inception-vs-current pairing is the divisor-phantom shape, which
Invariant `inv:basis`(iii) forbids and which would require the stored inception NAV to carry its
stamp or be re-derived (`prin:rederivation`). Wiring that second hook is more than "one clause +
a `\ref`" and touches how the inception NAV is stored, so it was **not** made here; it is flagged
for the author as a deeper cross-section obligation to consider in `sec11`.
