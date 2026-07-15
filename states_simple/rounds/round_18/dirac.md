# DIRAC — Round 18 — States.tex

**Verdict: OBVIOUS**

The bar: the three-home structure reads as inevitable from one rule — no
unexplained special case, no competing criteria.

## What the one rule is

There is a single classification, stated as a 2×2 (§Answer):

- **Axis 1 — key.** Does the fact depend on the holder, or only on the unit?
  A binary, exhaustive over the only two terms in scope (unit, a holder of it).
- **Axis 2 — author.** Does an outside authority own the record's history, or
  do the ledger's own events produce and overwrite it? Binary, exhaustive over
  stored facts (every record has an owner of its history).

These are two coordinates of one classification, not two competing rules. They
compose; they do not contend. A home is an occupied cell. Three cells occupied,
the fourth proved empty — three homes. This is the inevitability the bar asks
for: the count is the count of occupied cells, nothing chosen by hand.

## Why I do not find a competing criterion

I went looking for a hidden third axis and each candidate is defused in the text:

- **Conserved vs non-conserved** is *within* the Position home, not across homes:
  `psHwm` rides beside `psBal` precisely to witness that the home carries a
  non-conserved fact (§Construction). So conservation is not a sorting axis.
- **Append-only vs overwrite** (Terms vs Status write discipline) is downstream
  of Axis 2, not independent of it: external authorship forces version-preservation,
  ledger authorship permits replacement. One axis, two consequences.
- **Summed vs not-summed** (`Qty` vs `Price`) is value-typing inside a home, not
  a home boundary.
- **Economic vs identity** (KYC, permissions, cursor) is the domain restriction
  applied *before* the 2×2 — what may enter conservation, valuation, or P&L — not
  a competing sort. It defines the field on which the one rule operates.

## Why the apparent special cases are not special cases

Each falls out of the general rules rather than being bolted on:

- **3 homes, 2 maps.** Terms and Status share the unit key, so they ride as a pair
  in one map; co-presence becomes the *shape* of the map, not a policed invariant.
  The collapse is derived (shared key), not asserted.
- **Empty fourth cell.** Proved, not declared: a position is the ledger's own from
  origin; a custodian/PB statement is a reconciliation input, never an adopted
  authority's record (§Why). So (holder, unit) carries only ledger-authored facts.
- **Managed account** — the obvious counterexample to the empty cell — is reified
  to a (client, mandate-unit) position under the relationship=unit premise, summing
  to zero like any issued unit. It confirms the rule instead of breaking it.
- **Self-move / zero-move / held-and-flat** all emerge from netting to `mempty`
  and row retention; no branch is added for them.

## The one disclosed assumption, and why it does not block

The closure of the 2×2 rests on the premise that *every economic relationship is a
unit the wallet holds*. This is demonstrated for a single mandate and **explicitly
assumed** for a relationship spanning several instruments (§Answer, §Why): such a
relationship is one (holder, unit) row, not a (holder, several-units) home that
"would be a fourth home and a third map." This bears directly on the count "three,
not four."

I weighed this as candidate residue and reject it. It is not an *unexplained*
special case: it is named, located, its consequence stated, and its proof scope
drawn. Every derivation carries premises; the bar forbids unexplained sorting, not
stated premises. The three-home structure is inevitable *given* the premise, and
the premise is on the page where the reader can see it — the mark of an honest
derivation, not a hidden one.

## Reader test

A competent engineer meeting this cold gets: one premise (relationship = unit),
two orthogonal questions, a 2×2, three occupied cells = three homes, the fourth
proved empty, two maps because two homes share a key. The structure feels
inevitable. The equations are beautiful and the special cases fall from the
general case rather than puncturing it.

**OBVIOUS.**
